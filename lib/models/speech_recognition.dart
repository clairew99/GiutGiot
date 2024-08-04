import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';

// 240803 SHJ: 음성 인식 초기화
Future<void> initSpeech(stt.SpeechToText speech, Function(bool) onInit) async {
  bool available = await speech.initialize(
    onStatus: (val) => print('onStatus: $val'),
    onError: (val) => print('onError: $val'),
  );
  if (available) {
    onInit(false);
  }
}

// 240803 SHJ: 음성 인식 시작
Future<void> listen(stt.SpeechToText speech, bool isListening, Function(bool, String, double) onResult) async {
  if (!isListening) {
    var status = await Permission.microphone.request();
    if (status.isGranted) {
      speech.listen(
        onResult: (val) {
          String text = val.recognizedWords;
          double confidence = val.hasConfidenceRating && val.confidence > 0 ? val.confidence : 1.0;
          onResult(true, text, confidence);
        },
        listenFor: Duration(seconds: 30), // 240803 SHJ: 음성 인식 최대 시간 설정
        pauseFor: Duration(seconds: 5), // 240803 SHJ: 음성 인식 일시 중지 시간 설정
        partialResults: true,
        onSoundLevelChange: (level) => print('Sound level: $level'), // 240803 SHJ: 소리 레벨을 출력 - 디버깅용
        cancelOnError: true,
      );
    }
  } else {
    speech.stop();
    onResult(false, '', 1.0);
  }
}
