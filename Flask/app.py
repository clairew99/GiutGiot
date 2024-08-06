from flask import Flask, request, jsonify
from conversation import ClothingFeatureExtractor
from main import AudioProcessor
from config import Config
import os

app = Flask(__name__)

# ClothingFeatureExtractor 클래스의 인스턴스를 생성합니다.
extractor = ClothingFeatureExtractor()

# AudioProcessor 클래스의 인스턴스를 생성합니다.
audio_processor = AudioProcessor(hf_token=Config.PYANNOTE_TOKEN)

@app.route('/conversation', methods=['POST', 'GET'])
def conversation():
    data = request.json
    sentence = data.get('text', '')
    print(sentence)
    # ClothingFeatureExtractor 클래스의 extract_clothing_features 메서드를 호출합니다.
    features = extractor.extract_clothing_features(sentence)
    print(features)
    return jsonify({
        'colors': features[0],
        'sleeve_types': features[1],
        'pants_types': features[2],
        'top_types': features[3],
        'bottom_types': features[4],
        'patterns': features[5],
    })


# 화자분석
@app.route('/pyannote', methods=['POST', 'GET'])
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
