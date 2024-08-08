from flask import Flask, request, jsonify, session
from Conversation_Analysis.Keyword_extraction import ClothingFeatureExtractor
from Speaker_Analysis.main import AudioProcessor
from Conversation_Analysis.Interrogative_Plain_model import QuestionStatementClassifier
from Conversation_Analysis.Sentiment_Analysis import predict_sentiment
from config import Config
from datetime import datetime
import os
import requests

app = Flask(__name__)
app.secret_key = 'your_secret_key'

# ClothingFeatureExtractor 클래스의 인스턴스를 생성합니다.
extractor = ClothingFeatureExtractor()

# AudioProcessor 클래스의 인스턴스를 생성합니다.
audio_processor = AudioProcessor(hf_token=Config.PYANNOTE_TOKEN)

# QuestionStatementClassifier 클래스의 인스턴스를 생성합니다.
classifier = QuestionStatementClassifier()
classifier.load_model('svc_model.pkl', 'tfidf_vectorizer.pkl')

@app.route('/conversation', methods=['POST'])
def conversation():
    request_data = request.get_json()
    text = request_data.get('text', '')
    # 문장 타입 예측 (의문문 또는 평문)
    text_type = classifier.predict(text)

    access_token = request.headers.get('Authorization')

    # 입는다 -> 무조건 coordinate에 post 요청
    if text_type == 'Statement':
        # 평문일 경우 키워드 추출
        features = extractor.extract_clothing_features(text)
        print(features)
        # 추출된 키워드를 백엔드로 전송 (데이터 저장)
        # 이 부분은 적절한 백엔드 API 호출로 대체 필요
        # 예: backend_api.save_clothing_features(features)
        # request로 모델이 분석한 값을 넣어줘야 함

        spring_response_data = session.get('spring_response_data', None)
        if spring_response_data is None:
            return jsonify({"error": "No data from previous request"}), 400

        if 'topId' not in session:
            session['topId'] = spring_response_data['clothesId']
            return jsonify({
                "message": "상의가 선택되었어요. 하의도 선택해주세요.",
                "topId": session['topId']
            })
        elif 'bottomId' not in session:
            session['bottomId'] = spring_response_data['clothesId']
        
        if 'topID' in session and 'bottomId' in session:
            topId = session.get('topId')
            bottomId = session.get('bottomId')
            date = datetime.now().strftime("%Y-%m-%d")
            
            spring_data = {
                "topId": topId,
                "bottomId": bottomId,
                "date": date
            }

        spring_url = "http://localhost:8080/coordinates"
        spring_headers = {
            'Content-Type': 'application/json',
            'Authorization': access_token,
        }

        try:
            response = requests.post(spring_url, headers=spring_headers, json=spring_data)
            response.raise_for_status()
        except requests.exceptions.RequestException as e:
            return jsonify({"error": str(e)}), 500
        
        spring_response_data = response.json()

        session.pop('topId', None)
        session.pop('bottomId', None)

        return jsonify(spring_response_data)

    elif text_type == 'Question':
        # 의문문일 경우 키워드 조회
        features = extractor.extract_clothing_features(text)
        print(features)
        # 조회된 키워드를 기반으로 백엔드에서 옷 정보 조회
        # 예: clothing_info = backend_api.get_clothing_info(features)
        is_top = features[0]
        color = features[1]
        clothing_type = features[2]
        category = features[3]
        pattern = features[4]

        # spring url 수정 필요
        spring_url = "http://localhost:8080/clothes/check"
        spring_headers = {
            'Content-Type': 'application/json',
            'Authorization': access_token,
        }

        spring_data = {
            "isTop": is_top,
            "Color": color,
            "Type": clothing_type,
            "Category": category,
            "Pattern": pattern
        }

        try:
            # 스프링 서버로 HTTP POST 요청 보내기
            response = requests.post(spring_url, headers=spring_headers, json=spring_data)
            response.raise_for_status()
        except requests.exceptions.RequestException as e:
            # 오류 처리
            return jsonify({"error": str(e)}), 500

        # 스프링 서버의 응답을 JSON 형태로 플러터로 반환
        spring_response_data = response.json()

        session['spring_response_data'] = spring_response_data

        message = create_message_from_response(spring_response_data)

        # isTop, clothesId, isAvailable 형태에서 메시지 형태로 반환
        return jsonify({'message': message})

def create_message_from_response(response_data):
    if response_data.get('isAvailable', False):
        return "입어도 됩니다."
    else:
        return "다른 걸 입는 걸 추천드려요. 그래도 입으시겠어요?"

@app.route('/response', methods=['POST'])
def handle_response():
    data = request.json
    response = data.get('response', '')
    print(response)

    # 감정 예측
    sentiment = predict_sentiment(response)
    print(f"Sentiment: {sentiment}")

    last_question = session.get('last_question')
    if not last_question:
        return jsonify({'error': 'No question asked previously.'}), 400

    if sentiment == '입겠다':
        # 긍정일 경우 데이터 저장
        # 예: backend_api.save_user_choice(last_question)
        return jsonify({'message': '데이터가 저장되었습니다.'})
    else:
        # 부정일 경우 다른 옷 추천 요청
        return jsonify({'message': '다른 옷을 추천합니다.'})



# 화자 분석
@app.route('/pyannote', methods=['POST'])
def pyannote():
    print(request.files)
    if 'audio' not in request.files:
        return jsonify({"error": "파일이 필요합니다."}), 400
    
    file = request.files['audio']
    if file.filename == '':
        return jsonify({"error": "파일이 필요합니다."}), 400
    
    print(file)
    
    # 분석 실행
    result = audio_processor.process_audio(file)
    
    return jsonify(result)

if __name__ == '__main__':
    os.makedirs('temp', exist_ok=True)  # temp 디렉토리 생성
    app.run(host='0.0.0.0', port=5000, debug=True)
