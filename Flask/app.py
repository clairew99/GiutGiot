from flask import Flask, request, jsonify, session
from Conversation_Analysis.Keyword_extraction import ClothingFeatureExtractor
from Speaker_Analysis.main import AudioProcessor
from Conversation_Analysis.Interrogative_Plain_model import QuestionStatementClassifier
from Conversation_Analysis.Sentiment_Analysis import predict_sentiment
from config import Config
from datetime import datetime, timedelta
import os
import requests
from pydub import AudioSegment
import schedule
import time
import threading

app = Flask(__name__)
app.secret_key = Config.SECRETKEY

# 세션 수명을 30분으로 설정
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=30)

# ClothingFeatureExtractor 클래스의 인스턴스를 생성합니다.
extractor = ClothingFeatureExtractor()

# AudioProcessor 클래스의 인스턴스를 생성합니다.
audio_processor = AudioProcessor(hf_token=Config.PYANNOTE_TOKEN)
audio_files = []

# QuestionStatementClassifier 클래스의 인스턴스를 생성합니다.
classifier = QuestionStatementClassifier()
classifier.load_model('svc_model.pkl', 'tfidf_vectorizer.pkl')

def get_access_token():
    """Request headers에서 토큰을 받아오는 함수"""
    access_token = request.headers.get('Authorization')
    return access_token

@app.route('/conversation', methods=['POST'])
def conversation():
    request_data = request.get_json()
    text = request_data.get('text', '')
    text_type = classifier.predict(text)
    
    # access_token을 받아옴
    access_token = get_access_token()
    
    print(f"Authorization header: {access_token}")
    print(f"text_type: {text_type}")

    # 세션을 영구적으로 설정하여 30분간 유지
    session.permanent = True

    features = extractor.extract_clothing_features(text)
    
        # 기본값 설정
    default_top = {
        "color": "WHITE",
        "type": "SHORT",
        "category": "COTTON",
        "pattern": "SOLID"
    }
    default_bottom = {
        "color": "BLACK",
        "type": "LONG",
        "category": "SLACKS",
        "pattern": "SOLID"
    }

    # 사용자가 상의를 말한 경우, 추출된 키워드는 그대로 유지하고 누락된 값만 기본값으로 채움
    if 'top' in features:
        top_features = {key: features['top'].get(key, default_value) 
                        for key, default_value in default_top.items()}
    else:
        top_features = None

    # 사용자가 하의를 말한 경우, 추출된 키워드는 그대로 유지하고 누락된 값만 기본값으로 채움
    if 'bottom' in features:
        print(features['bottom'])
        bottom_features = {key: features['bottom'].get(key, default_value) 
                        for key, default_value in default_bottom.items()}
    else:
        bottom_features = None


        ''
    print(f"features: {features}")
    print(f"top_features: {top_features}")
    print(f"bottom_features: {bottom_features}")

    if text_type == 'Statement':
        # Statement: 사용자가 특정 옷을 입겠다는 의지를 표현한 경우
        if top_features:  # 상의 정보가 있는 경우
            session['top_features'] = top_features  # 세션에 상의 정보를 저장
            session['top_clothesId'] = features.get('top', {}).get('clothesId', '')  # Spring에서 받아온 clothesId를 저장한다고 가정
            return jsonify({
                "type":"Statement",
                "message": "상의가 선택되었어요. 하의도 선택해주세요."
            })

        elif bottom_features:  # 하의 정보가 있는 경우
            session['bottom_features'] = bottom_features  # 세션에 하의 정보를 저장
            session['bottom_clothesId'] = features.get('bottom', {}).get('clothesId', '')  # Spring에서 받아온 clothesId를 저장한다고 가정

            if 'top_clothesId' in session:  # 상의 정보가 이미 있는 경우
                return jsonify({
                    "type":"Statement",
                    "message": "코디가 완료되었습니다. 저장합니다."
                })
            else:
                return jsonify({
                    "type":"Statement",
                    "message": "하의가 선택되었어요. 상의도 선택해주세요."
                })

    elif text_type == 'Question':
        # Question: 사용자가 조언을 묻는 경우
        spring_url = "https://i11a409.p.ssafy.io:8443/clothes/check"
        spring_headers = {
            'Content-Type': 'application/json;charset=UTF-8',
            'Authorization': access_token,
        }

        if top_features:  # 상의 정보가 있는 경우
            session['top_features'] = top_features  # 세션에 상의 정보를 저장
            spring_data_top = {
                "isTop": True,
                "color": top_features.get('color', ''),
                "type": top_features.get('type', ''),
                "category": top_features.get('category', ''),
                "pattern": top_features.get('pattern', '')
            }

            print("spring_data_top", spring_data_top)
            try:
                response = requests.post(spring_url, headers=spring_headers, json=spring_data_top)
                response.raise_for_status()
                spring_response_data = response.json()
            except requests.exceptions.RequestException as e:
                return jsonify({"error": str(e)}), 500
            
            # Spring에서 받아온 응답에 따라 처리
            isAvailable = spring_response_data.get('isAvailable', False)
            session['top_clothesId'] = spring_response_data.get('clothesId', '')

            if isAvailable:
                return jsonify({
                    "type":"Question",
                    "message": "입어도 됩니다. 입으시겠어요?"
                })
            else:
                return jsonify({
                    "type":"Question",
                    "message": "다른 걸 입는 걸 추천드려요. 그래도 입으시겠어요?"
                })

        if bottom_features:  # 하의 정보가 있는 경우
            session['bottom_features'] = bottom_features  # 세션에 하의 정보를 저장
            spring_data_bottom = {
                "isTop": False,
                "color": bottom_features.get('color', ''),
                "type": bottom_features.get('type', ''),
                "category": bottom_features.get('category', ''),
                "pattern": bottom_features.get('pattern', '')
            }

            try:
                response = requests.post(spring_url, headers=spring_headers, json=spring_data_bottom)
                response.raise_for_status()
                spring_response_data = response.json()
            except requests.exceptions.RequestException as e:
                return jsonify({"error": str(e)}), 500
            
            # Spring에서 받아온 응답에 따라 처리
            isAvailable = spring_response_data.get('isAvailable', False)
            session['bottom_clothesId'] = spring_response_data.get('clothesId', '')

            if isAvailable:
                return jsonify({
                    "type":"Question",
                    "message": "입어도 됩니다. 입으시겠어요?"
                })
            else:
                return jsonify({
                    "type":"Question",
                    "message": "다른 걸 입는 걸 추천드려요. 그래도 입으시겠어요?"
                })

    return jsonify({"error": "잘못된 요청입니다."}), 400

@app.route('/response', methods=['POST'])
def handle_response():
    data = request.json
    response = data.get('text', '')
    print(response)
    
    access_token = get_access_token()
    
    sentiment = predict_sentiment(response)
    print(f"Sentiment: {sentiment}")

    if sentiment == '긍정':
        if 'top_clothesId' in session and 'bottom_clothesId' not in session:
            return jsonify({
                "message": "상의가 선택되었어요. 하의도 선택해주세요."
            })

        elif 'top_clothesId' not in session and 'bottom_clothesId' in session:
            return jsonify({
                "message": "하의가 선택되었어요. 상의도 선택해주세요."
            })

        elif 'top_clothesId' in session and 'bottom_clothesId' in session:
            print(session)
            topId = session['top_clothesId']
            bottomId = session['bottom_clothesId']
            date = datetime.now().strftime("%Y-%m-%d")

            spring_data = {
                "topId": topId,
                "bottomId": bottomId,
                "date": date
            }
            print(spring_data)

            spring_url = "https://i11a409.p.ssafy.io:8443/coordinates"
            spring_headers = {
                'Content-Type': 'application/json',
                'Authorization': access_token,
            }

            try:
                response = requests.post(spring_url, headers=spring_headers, json=spring_data)
                response.raise_for_status()
            except requests.exceptions.RequestException as e:
                return jsonify({"error": str(e)}), 500
            
            session.pop('top_clothesId', None)  # 세션에서 상의 정보 삭제
            session.pop('bottom_clothesId', None)  # 세션에서 하의 정보 삭제

            return jsonify({"message": "코디가 저장되었습니다."})

    elif sentiment == '부정':
        session.pop('top_clothesId', None)
        session.pop('bottom_clothesId', None)
        return jsonify({"message": "상의와 하의 정보가 초기화되었습니다. 새로운 옷을 선택해주세요."})

    return jsonify({"message": "다른 옷을 추천합니다."})

## 화자분석
@app.route('/pyannote', methods=['POST'])
def pyannote():
    global audio_files  # 전역 변수 사용 선언

    print(request.files)
    if 'audio' not in request.files:
        return jsonify({"error": "파일이 필요합니다."}), 400
    
    file = request.files['audio']
    if file.filename == '':
        return jsonify({"error": "파일이 필요합니다."}), 400
    
    # 파일을 고유한 이름으로 저장
    timestamp = datetime.now().strftime("%Y%m%d%H%M%S")
    filepath = os.path.join('temp', f"{timestamp}_{file.filename}")
    file.save(filepath)
    
    # 파일 경로를 리스트에 추가
    audio_files.append(filepath)
    
    return jsonify({"message": "음성 파일이 저장되었습니다."})


def send_voice_data(voice_list, date):
    url = "https://i11a409.p.ssafy.io:8443/voice"
    headers = {
        'Content-Type': 'application/json',
        'Authorization': app.access_token,
    }
    data = {
        "voiceList": voice_list,
        "date": date
    }
    try:
        response = requests.post(url, headers=headers, json=data)
        response.raise_for_status()
        print(f"Voice data sent successfully for date: {date}")
    except requests.exceptions.RequestException as e:
        print(f"Error sending voice data: {str(e)}")


def process_audio_files():
    global audio_files  # 전역 변수 사용 선언

    if audio_files:
        combined_audio = AudioSegment.empty()
        for file in audio_files:
            audio_segment = AudioSegment.from_file(file)
            combined_audio += audio_segment
        
        combined_filepath = 'temp/combined_audio.wav'
        combined_audio.export(combined_filepath, format='wav')
        
        # 합친 파일을 audio_processor에 넘기기
        with open(combined_filepath, 'rb') as f:
            result = audio_processor.process_audio(f)
        
        print(result)
        
        # 결과를 /voice 엔드포인트로 전송
        voice_list = result  # 여기서 result는 대화 시간 리스트라고 가정합니다
        date = datetime.now().strftime("%Y-%m-%d")
        send_voice_data(voice_list, date)
        
        # 처리 후 파일 삭제
        for file in audio_files:
            try:
                os.remove(file)
            except OSError as e:
                print(f"Error: {file} : {e.strerror}")
        
        # 처리 후 파일 목록 초기화
        audio_files = []

        # 합친 파일도 삭제
        os.remove(combined_filepath)

# 스케줄 설정: 매일 오후 11시에 파일 처리
schedule.every().day.at("23:00").do(process_audio_files)

def run_schedule():
    while True:
        schedule.run_pending()
        time.sleep(1)

if __name__ == '__main__':
    os.makedirs('temp', exist_ok=True)
    
    # 스케줄 실행을 위한 쓰레드 시작
    schedule_thread = threading.Thread(target=run_schedule)
    schedule_thread.start()
    
    app.run(host='0.0.0.0', port=5000, debug=True)
