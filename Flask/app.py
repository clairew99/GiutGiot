from flask import Flask, request, jsonify, session
from Conversation_Analysis.Keyword_extraction import ClothingFeatureExtractor
from Speaker_Analysis.main import AudioProcessor
from Conversation_Analysis.Interrogative_Plain_model import QuestionStatementClassifier
from Conversation_Analysis.Sentiment_Analysis import predict_sentiment
from config import Config
from datetime import datetime, timedelta
import os
import requests

app = Flask(__name__)
app.secret_key = Config.SECRETKEY
app.access_token = Config.access_token

# 세션 수명을 30분으로 설정
app.config['PERMANENT_SESSION_LIFETIME'] = timedelta(minutes=30)

# ClothingFeatureExtractor 클래스의 인스턴스를 생성합니다.
extractor = ClothingFeatureExtractor()

# AudioProcessor 클래스의 인스턴스를 생성합니다.
audio_processor = AudioProcessor(hf_token=Config.PYANNOTE_TOKEN)

# QuestionStatementClassifier 클래스의 인스턴스를 생성합니다.
classifier = QuestionStatementClassifier()
classifier.load_model('svc_model.pkl', 'tfidf_vectorizer.pkl')

@app.route('/conversation', methods=['POST'])
def conversation():
    print("찍히나?")
    request_data = request.get_json()
    text = request_data.get('text', '')
    text_type = classifier.predict(text)  # text_type을 통해 Statement 또는 Question을 구분
    
    # access_token을 request headers에서 가져옴
    access_token = request.headers.get('Authorization')
    if not access_token:
        access_token = app.access_token
    
    print(f"Authorization header: {access_token}")
    print(f"text_type: {text_type}")

    # 세션을 영구적으로 설정하여 30분간 유지
    session.permanent = True

    features = extractor.extract_clothing_features(text)
    print(f"features: {features}")

    if text_type == 'Statement':
        # Statement: 사용자가 특정 옷을 입겠다는 의지를 표현한 경우
        if 'top' in features:  # 상의 정보가 있는 경우
            session['top_features'] = features['top']  # 세션에 상의 정보를 저장
            session['top_clothesId'] = features['top'].get('clothesId', '')  # Spring에서 받아온 clothesId를 저장한다고 가정
            return jsonify({
                "message": "상의가 선택되었어요. 하의도 선택해주세요."
            })

        elif 'bottom' in features:  # 하의 정보가 있는 경우
            session['bottom_features'] = features['bottom']  # 세션에 하의 정보를 저장
            session['bottom_clothesId'] = features['bottom'].get('clothesId', '')  # Spring에서 받아온 clothesId를 저장한다고 가정

            if 'top_clothesId' in session:  # 상의 정보가 이미 있는 경우
                # 상의와 하의 정보를 모두 받아서 최종 저장
                return jsonify({
                    "message": "코디가 완료되었습니다. 저장합니다."
                })
            else:
                return jsonify({
                    "message": "하의가 선택되었어요. 상의도 선택해주세요."
                })

    elif text_type == 'Question':
        # # Question: 사용자가 조언을 묻는 경우
        # if 'top' in features:  # 상의 정보가 있는 경우
        #     session['top_features'] = features['top']  # 세션에 상의 정보를 저장
            
        #     spring_url = "http://i11a409.p.ssafy.io:8080/clothes/check"
        #     spring_headers = {
        #         'Content-Type': 'application/json;charset=UTF-8',
        #         'Authorization': access_token,
        #     }

            # spring_data_top = {
            #     "isTop": True,
            #     "color": features['top'].get('color', ''),
            #     "type": features['top'].get('sleeve_type', ''),
            #     "category": features['top'].get('top_type', ''),
            #     "pattern": features['top'].get('pattern', '')
            # }

            # try:
            #     response = requests.post(spring_url, headers=spring_headers, json=spring_data_top)
            #     response.raise_for_status()
            #     spring_response_data = response.json()
            # except requests.exceptions.RequestException as e:
            #     return jsonify({"error": str(e)}), 500
            
            # # Spring에서 받아온 응답에 따라 처리
            # isAvailable = spring_response_data.get('isAvailable', False)
            # session['top_clothesId'] = spring_response_data.get('clothesId', '')

            # if isAvailable:
            #     return jsonify({"message": "입어도 됩니다. 입으시겠어요?"})
            # else:
            #     return jsonify({"message": "다른 걸 입는 걸 추천드려요. 그래도 입으시겠어요?"})

        if 'bottom' in features:  # 하의 정보가 있는 경우
            session['bottom_features'] = features['bottom']  # 세션에 하의 정보를 저장
            
            spring_url = "http://i11a409.p.ssafy.io:8080/clothes/check"
            spring_headers = {
                'Content-Type': 'application/json;charset=UTF-8',
                'Authorization': access_token,
            }

            spring_data_bottom = {
                "isTop": False,
                "color": features['bottom'].get('color', ''),
                "type": features['bottom'].get('pants_type', ''),
                "category": 'COTTON',#features['bottom'].get('bottom_type', ''),
                "pattern": features['bottom'].get('pattern', '')
            }
            print("spring_data_bottom,",spring_data_bottom)
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
                return jsonify({"message": "입어도 됩니다. 입으시겠어요?"})
            else:
                return jsonify({"message": "다른 걸 입는 걸 추천드려요. 그래도 입으시겠어요?"})

    return jsonify({"error": "잘못된 요청입니다."}), 400

@app.route('/response', methods=['POST'])
def handle_response():
    request_data = request.get_json()
    text = request_data.get('text', '')

    print("response",text)

    sentiment = predict_sentiment(text)
    print(f"Sentiment: {sentiment}")

    # last_question = session.get('last_question')
    # if not last_question:
    #     return jsonify({'error': 'No question asked previously.'}), 400

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
            topId = session['top_clothesId']
            bottomId = session['bottom_clothesId']
            date = datetime.now().strftime("%Y-%m-%d")

            spring_data = {
                "topId": topId,
                "bottomId": bottomId,
                "date": date
            }

            spring_url = "http://i11a409.p.ssafy.io:8080/coordinates"
            spring_headers = {
                'Content-Type': 'application/json',
                'Authorization': app.access_token,
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

if __name__ == '__main__':
    os.makedirs('temp', exist_ok=True)
    app.run(host='0.0.0.0', port=5000, debug=True)






# from flask import Flask, request, jsonify, session
# from Conversation_Analysis.Keyword_extraction import ClothingFeatureExtractor
# from Speaker_Analysis.main import AudioProcessor
# from Conversation_Analysis.Interrogative_Plain_model import QuestionStatementClassifier
# from Conversation_Analysis.Sentiment_Analysis import predict_sentiment
# from config import Config
# from datetime import datetime
# import os
# import requests

# app = Flask(__name__)
# app.secret_key = Config.SECRETKEY

# # ClothingFeatureExtractor 클래스의 인스턴스를 생성합니다.
# extractor = ClothingFeatureExtractor()

# # AudioProcessor 클래스의 인스턴스를 생성합니다.
# audio_processor = AudioProcessor(hf_token=Config.PYANNOTE_TOKEN)

# # QuestionStatementClassifier 클래스의 인스턴스를 생성합니다.
# classifier = QuestionStatementClassifier()
# classifier.load_model('svc_model.pkl', 'tfidf_vectorizer.pkl')

# @app.route('/conversation', methods=['POST'])
# def conversation():
#     request_data = request.get_json()
#     text = request_data.get('text', '')
#     text_type = classifier.predict(text)
#     session.clear()
    
#     # access_token을 request headers에서 가져옴
#     access_token = request.headers.get('Authorization')
#     if not access_token:
#         access_token = "Bearer eyJhbGciOiJIUzI1NiJ9.eyJzdWIiOiIxIiwiaWF0IjoxNzIzMTY4NjQ3LCJleHAiOjE3NTQ3MDQ2NDd9.O4P9-t4xBLA4_gxp1rb4XJh79yfr9jA_3sY-miTYyss"
    
#     print(f"Authorization header: {access_token}")
#     print(text_type)

#     if text_type == 'Statement':
#         features = extractor.extract_clothing_features(text)
#         print(features)

#         spring_response_data = session.get('spring_response_data', None)
#         if spring_response_data is None:
#             spring_response_data = {'clothesId': ""}
#             session['spring_response_data'] = spring_response_data

#         if 'topId' not in session:
#             session['topId'] = spring_response_data['clothesId']
#             return jsonify({
#                 "message": "상의가 선택되었어요. 하의도 선택해주세요.",
#                 "topId": session['topId']
#             })
#         elif 'bottomId' not in session:
#             session['bottomId'] = spring_response_data['clothesId']
        
#         if 'topId' in session and 'bottomId' in session:
#             topId = session.get('topId')
#             bottomId = session.get('bottomId')
#             date = datetime.now().strftime("%Y-%m-%d")
            
#             spring_data = {
#                 "topId": topId,
#                 "bottomId": bottomId,
#                 "date": date
#             }

#             spring_url = "http://i11a409.p.ssafy.io:8080/coordinates"
#             spring_headers = {
#                 'Content-Type': 'application/json',
#                 'Authorization': access_token,
#             }

#             try:
#                 response = requests.post(spring_url, headers=spring_headers, json=spring_data)
#                 response.raise_for_status()
#             except requests.exceptions.RequestException as e:
#                 return jsonify({"error": str(e)}), 500
            
#             spring_response_data = response.json()

#             session.pop('topId', None)
#             session.pop('bottomId', None)

#             return jsonify(spring_response_data)
        
#         return jsonify({"error": "상태가 유효하지 않습니다."}), 400

#     elif text_type == 'Question':
#         features = extractor.extract_clothing_features(text)
#         print(features)

#         spring_url = "http://i11a409.p.ssafy.io:8080/clothes/check"
#         spring_headers = {
#             'Content-Type': 'application/json;charset=UTF-8',
#             'Authorization': access_token,
#         }

#         responses = []

#         if features.get('top', {}):
#             top_features = features.get('top', {})
#             is_top = True  # 상의 정보이므로 True로 설정
#             color = top_features.get('color', '')
#             clothing_type = top_features.get('sleeve_type', '')
#             category = top_features.get('top_type', '')
#             pattern = top_features.get('pattern', '')

#             spring_data_top = {
#                 "isTop": is_top,
#                 "color": color,
#                 "type": clothing_type,
#                 "category": category,
#                 "pattern": "SOLID"
#             }
#             print("spring_data_top", spring_data_top)
#             try:
#                 response = requests.post(spring_url, headers=spring_headers, json=spring_data_top)
#                 print("response: ",response)
#                 response.raise_for_status()
#                 responses.append(response.json())
#             except requests.exceptions.RequestException as e:
#                 return jsonify({"error": str(e)}), 500

#         elif features.get('bottom', {}):
#             bottom_features = features.get('bottom', {})
#             print("bottom_features: ",bottom_features)
#             spring_data_bottom = {
#                 "isTop": False,
#                 "color": bottom_features.get('color', ''),
#                 "type": bottom_features.get('pants_type', ''),
#                 "category": bottom_features.get('bottom_type', ''),
#                 "pattern": bottom_features.get('pattern', '')
#             }
#             print("spring_data_bottom", spring_data_bottom)
#             try:
#                 response = requests.post(spring_url, headers=spring_headers, json=spring_data_bottom)
#                 response.raise_for_status()
#                 responses.append(response.json())
#             except requests.exceptions.RequestException as e:
#                 return jsonify({"error": str(e)}), 500

#         session['spring_response_data'] = responses
#         message = create_message_from_response(responses)
#         session['last_question'] = message

#         return jsonify({'message': message})


#     return jsonify({"error": "잘못된 요청입니다."}), 400

# def create_message_from_response(response_data):
#     if isinstance(response_data, list):
#         for item in response_data:
#             if item.get('isAvailable', False):
#                 return "입어도 됩니다. 입으시겠어요?"
#         return "다른 걸 입는 걸 추천드려요. 그래도 입으시겠어요?"
#     else:
#         if response_data.get('isAvailable', False):
#             return "입어도 됩니다. 입으시겠어요?"
#         else:
#             return "다른 걸 입는 걸 추천드려요. 그래도 입으시겠어요?"




# @app.route('/response', methods=['POST'])
# def handle_response():
#     data = request.json
#     response = data.get('response', '')
#     print(response)

#     sentiment = predict_sentiment(response)
#     print(f"Sentiment: {sentiment}")

#     last_question = session.get('last_question')
#     if not last_question:
#         return jsonify({'error': 'No question asked previously.'}), 400

#     if sentiment == '긍정':
#         return jsonify({'message': '데이터가 저장되었습니다.'})
#     else:
#         return jsonify({'message': '다른 옷을 추천합니다.'})




# @app.route('/pyannote', methods=['POST'])
# def pyannote():
#     print(request.files)
#     if 'audio' not in request.files:
#         return jsonify({"error": "파일이 필요합니다."}), 400
    
#     file = request.files['audio']
#     if file.filename == '':
#         return jsonify({"error": "파일이 필요합니다."}), 400
    
#     print(file)
    
#     result = audio_processor.process_audio(file)
    
#     return jsonify(result)

# if __name__ == '__main__':
#     os.makedirs('temp', exist_ok=True)
#     app.run(host='0.0.0.0', port=5000, debug=True)
