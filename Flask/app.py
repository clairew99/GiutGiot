from Flask import Flask, request, jsonify, session
from Flask.Conversation_Analysis.Keyword_extraction import ClothingFeatureExtractor
from Flask.Speaker_Analysis.main import AudioProcessor
from Conversation_Analysis.Interrogative_Plain_model import QuestionStatementClassifier
from Conversation_Analysis.Sentiment_Analysis import predict_sentiment
from config import Config
import os

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
    data = request.json
    sentence = data.get('text', '')
    print(sentence)

    # 문장 타입 예측 (의문문 또는 평문)
    sentence_type = classifier.predict(sentence)

    if sentence_type == 'Statement':
        # 평문일 경우 키워드 추출
        features = extractor.extract_clothing_features(sentence)
        print(features)
        # 추출된 키워드를 백엔드로 전송 (데이터 저장)
        # 이 부분은 적절한 백엔드 API 호출로 대체 필요
        # 예: backend_api.save_clothing_features(features)
        return jsonify({
            'type': 'Statement',
            'colors': features[0],
            'sleeve_types': features[1],
            'pants_types': features[2],
            'top_types': features[3],
            'bottom_types': features[4],
            'patterns': features[5],
        })

    elif sentence_type == 'Question':
        # 의문문일 경우 키워드 조회
        features = extractor.extract_clothing_features(sentence)
        print(features)
        # 조회된 키워드를 기반으로 백엔드에서 옷 정보 조회
        # 예: clothing_info = backend_api.get_clothing_info(features)
        clothing_info = {
            'example_info': 'example_value'  # 예제 값
        }
        session['last_question'] = {
            'features': features,
            'clothing_info': clothing_info
        }
        return jsonify({
            'type': 'Question',
            'clothing_info': clothing_info,
            'message': '이 옷을 입으시겠습니까?'
        })

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
