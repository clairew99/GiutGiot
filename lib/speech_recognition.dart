import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
// 240802 SHJ : stt
Future<void> initSpeech(stt.SpeechToText speech, Function(bool) onInit) async {
  bool available = await speech.initialize(
    onStatus: (val) => print('onStatus: $val'),
    onError: (val) => print('onError: $val'),
  );
  if (available) {
    onInit(false);
  }
}

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
      );
    } else {
      onResult(false, '', 1.0);
    }
  } else {
    speech.stop();
    onResult(false, '', 1.0);
  }
}
