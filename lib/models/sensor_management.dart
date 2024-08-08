import 'package:sensors/sensors.dart';
import 'dart:async';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'voice_recorder.dart';
import 'bluetooth_scan.dart';

List<List<double>> sensorData = []; // 센서 데이터 저장용 리스트
int maxIndexCount = 0; // 최대 인덱스 카운트
List<double>? accelerometerValues;
List<double>? gyroscopeValues;
List<double>? userAccelerometerValues;

late AudioRecorder recorder; // 녹음기 객체
DateTime? lastVoiceDetectedTime; // 전역 변수로 선언

BluetoothScanner bluetoothScanner = BluetoothScanner();


// 초기화 함수
Future<void> initialize() async {
  recorder = AudioRecorder();
  await recorder.initRecorder();
}

// 권한 요청 함수
Future<void> requestPermissions() async {
  var sensorStatus = await Permission.sensors.request();
  var activityStatus = await Permission.activityRecognition.request();
  var microphoneStatus = await Permission.microphone.request();

  print('Sensor permission status: $sensorStatus');
  print('Activity recognition permission status: $activityStatus');
  print('Microphone permission status: $microphoneStatus');

  if (sensorStatus.isDenied || activityStatus.isDenied || microphoneStatus.isDenied) {
    throw Exception('Required permissions not granted');
  }
}

// 자이로스코프 및 가속도계 센서 초기화
void initializeSensors(List<StreamSubscription<dynamic>> streamSubscriptions, Function(List<double>?, List<double>?, List<double>?) onData) async {
  try {
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
  } catch (e) {
    print('Error initializing sensors: $e');
  }
}

// 센서 데이터 추가
void addToSensorData() {
  if (accelerometerValues != null && gyroscopeValues != null && userAccelerometerValues != null) {
    sensorData.add([...accelerometerValues!, ...gyroscopeValues!, ...userAccelerometerValues!]);
  }
}

// 움직임 감지 및 녹음 시작
void startMovementDetection(Interpreter interpreter, Function(List<List<double>>, Interpreter, int, Function(int, int)) predict, Function(int) onPrediction, Function onUpdate) {
  List<int> predictionHistory = [];
  // BluetoothScanner scanner = BluetoothScanner(); // 이 줄을 제거

  Timer.periodic(Duration(milliseconds: 20), (Timer timer) async {
    if (sensorData.length < 128) {
      addToSensorData();
    }

    if (sensorData.length == 128) {
      print('Predicting with sensor data...');
      predict(sensorData, interpreter, maxIndexCount, (int maxIndex, int newMaxIndexCount) async {
        maxIndexCount = newMaxIndexCount;
        print('Predicted maxIndex: $maxIndex');
        onPrediction(maxIndex);

        predictionHistory.add(maxIndex);
        if (predictionHistory.length > 15) {
          predictionHistory.removeAt(0);
        }

        int movementCount = predictionHistory.where((element) => element == 1).length;
        if (movementCount >= 12) {
          if (!recorder.isRecording) {
            try {
              await recorder.startRecording();
              await bluetoothScanner.startScanning(); // await 추가 및 전역 변수 사용
              predictionHistory.clear();
              print('Recording started');
              recorder.startInactivityTimer();
            } catch (e) {
              print('Error starting recording: $e');
            }
          }
        }
      });
      sensorData.clear();
    }

    onUpdate();
  });
}

// 이 함수를 앱 시작 시 호출
Future<void> setupSensorManagement() async {
  try {
    await initialize();
    print('Sensor management setup completed');
  } catch (e) {
    print('Error setting up sensor management: $e');
  }
}

// 리소스 해제 함수
Future<void> disposeSensorManagement() async {
  await recorder.disposeRecorder();
  print('Sensor management resources disposed');
}
