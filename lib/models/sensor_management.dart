import 'package:sensors/sensors.dart';
import 'dart:async';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'voice_recorder.dart';  // voice_recorder.dart 임포트

List<List<double>> sensorData = []; // 센서 데이터 저장용 리스트
int maxIndexCount = 0; // 최대 인덱스 카운트
bool isRecording = false; // 녹음 상태
List<double>? accelerometerValues;
List<double>? gyroscopeValues;
List<double>? userAccelerometerValues;

// 권한 요청 함수
Future<void> requestPermissions() async {
  var status = await Permission.sensors.status;
  if (status.isDenied) {
    await Permission.sensors.request();
  }
  status = await Permission.activityRecognition.status;
  if (status.isDenied) {
    await Permission.activityRecognition.request();
  }
}

// 자이로스코프 및 가속도계 센서 초기화
void initializeSensors(List<StreamSubscription<dynamic>> streamSubscriptions, Function(List<double>?, List<double>?, List<double>?) onData) async {
  await requestPermissions(); // 권한 요청

  streamSubscriptions.add(accelerometerEvents.listen((AccelerometerEvent event) {
    accelerometerValues = [event.x, event.y, event.z];
    onData(accelerometerValues, null, null);
  }));
  streamSubscriptions.add(gyroscopeEvents.listen((GyroscopeEvent event) {
    gyroscopeValues = [event.x, event.y, event.z];
    onData(null, gyroscopeValues, null);
  }));
  streamSubscriptions.add(userAccelerometerEvents.listen((UserAccelerometerEvent event) {
    userAccelerometerValues = [event.x, event.y, event.z];
    onData(null, null, userAccelerometerValues);
  }));
}

// 센서 데이터 추가
void addToSensorData() {
  if (accelerometerValues != null && gyroscopeValues != null && userAccelerometerValues != null) {
    sensorData.add([...accelerometerValues!, ...gyroscopeValues!, ...userAccelerometerValues!]);
  }
}

// 움직임 감지 및 녹음 시작
void startMovementDetection(Interpreter interpreter, Function(List<List<double>>, Interpreter, int, Function(int, int)) predict, Function(int) onPrediction, Function onUpdate) {
  DateTime? startTime;
  DateTime? lastVoiceDetectedTime = DateTime.now();

  Timer.periodic(Duration(milliseconds: 20), (Timer timer) {
    if (sensorData.length < 128) {
      addToSensorData();
    }

    if (sensorData.length == 128) {
      print('Predicting with sensor data...');
      predict(sensorData, interpreter, maxIndexCount, (int maxIndex, int newMaxIndexCount) {
        maxIndexCount = newMaxIndexCount;
        print('Predicted maxIndex: $maxIndex');
        onPrediction(maxIndex);
        if (maxIndex == 1) { // 걸음 감지
          if (!isRecording) {
            startRecording();  // voice_recorder.dart의 함수 호출
            startTime = DateTime.now();
            isRecording = true;
          }
        } else {
          if (isRecording && startTime != null) {
            Duration elapsed = DateTime.now().difference(startTime!);
            if (elapsed.inSeconds >= 30) {
              stopRecording();  // voice_recorder.dart의 함수 호출
              isRecording = false;
              startTime = null;
            }
          }
        }
      });
      sensorData.clear();
    }

    // 1분 동안 음성이 감지되지 않으면 녹음 종료
    if (isRecording && DateTime.now().difference(lastVoiceDetectedTime).inMinutes >= 1) {
      stopRecording();  // voice_recorder.dart의 함수 호출
      isRecording = false;
    }

    onUpdate();
  });
}