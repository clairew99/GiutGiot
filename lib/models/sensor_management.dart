import 'dart:async';
import 'package:sensors/sensors.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'voice_recorder.dart';
import 'bluetooth_scan.dart';
import '../Dio/access_token_manager.dart'; // 토큰 관리를 위한 파일 임포트

List<List<double>> sensorData = []; // 센서 데이터 저장용 리스트
int maxIndexCount = 0; // 최대 인덱스 카운트
List<double>? accelerometerValues;
List<double>? gyroscopeValues;
List<double>? userAccelerometerValues;

late AudioRecorder recorder; // 녹음기 객체
DateTime? lastVoiceDetectedTime; // 전역 변수로 선언

BluetoothScanner bluetoothScanner = BluetoothScanner();

class MovementDurationTracker {
  DateTime? movementStartTime;
  int consecutiveNonMovementCount = 0;
  bool isTracking = false;

  Duration? trackMovementDuration(int maxIndex) {
    if (maxIndex == 1) {
      if (!isTracking) {
        movementStartTime = DateTime.now();
        isTracking = true;
        consecutiveNonMovementCount = 0;
        print('Movement started at: $movementStartTime');
      }
    } else {
      if (isTracking) {
        consecutiveNonMovementCount++;
        if (consecutiveNonMovementCount >= 3) {
          isTracking = false;
          DateTime movementEndTime = DateTime.now();
          Duration movementDuration = movementEndTime.difference(movementStartTime!);
          print('Movement ended at: $movementEndTime');
          print('Movement duration: ${movementDuration.inSeconds} seconds');
          return movementDuration;
        }
      }
    }
    return null;
  }
}

// 초기화 함수
Future<void> initialize() async {
  print('record start ..');
  recorder = AudioRecorder();
  await recorder.initRecorder();
}

// 권한 요청 함수
Future<void> requestPermissions() async {
  var sensorStatus = await Permission.sensors.request();
  var activityStatus = await Permission.activityRecognition.request();
  var microphoneStatus = await Permission.microphone.request();
  print ('permission strat');
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
  if (!recorder.isInitialized) {
    initialize();
  }

  List<int> predictionHistory = [];
  MovementDurationTracker durationTracker = MovementDurationTracker();

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

        // 움직임 지속 시간 추적
        Duration? movementDuration = durationTracker.trackMovementDuration(maxIndex);
        if (movementDuration != null) {
          print('Movement duration: ${movementDuration.inSeconds} seconds');

          // 서버로 초 단위의 움직임 지속 시간을 전송
          await sendMovementDurationToServer(movementDuration.inSeconds);
        }

        predictionHistory.add(maxIndex);
        if (predictionHistory.length > 15) {
          predictionHistory.removeAt(0);
        }

        int movementCount = predictionHistory.where((element) => element == 1).length;
        if (movementCount >= 12) {
          if (!recorder.isRecording) {
            try {
              await recorder.startRecording();
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

// 서버로 움직임 지속 시간 전송
Future<void> sendMovementDurationToServer(int durationInSeconds) async {
  try {
    String? token = await AccessTokenManager.getAccessToken();  // 토큰 가져오기
    if (token == null) {
      print('Access token is missing');
      return;
    }

    var url = Uri.parse('https://i11a409.p.ssafy.io:8443/activity'); // 서버 URL을 적절히 변경
    var now = DateTime.now();

    var data = {
      "time": durationInSeconds,
      "date": "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}"
    };

    var response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': '$token',  // 토큰을 헤더에 포함
      },
      body: jsonEncode(data),  // JSON 인코딩
    );
    print('Server response: ${response.statusCode} ${response.body}');
  } catch (e) {
    print('Error sending duration to server: $e');
  }
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
