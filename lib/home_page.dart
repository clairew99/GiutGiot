import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:tflite_flutter/tflite_flutter.dart';
// 외부 dart import
import 'speech_recognition.dart';
import 'sensor_management.dart';
import 'ml_model.dart';
// 메인 홈페이지
class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // 240802 SHJ: 음성 인식 관련 변수들
  late stt.SpeechToText _speech; // 240802 SHJ: SpeechToText 객체를 초기화
  bool _isListening = false;
  String _text = 'Press the button to start speaking';
  double _confidence = 1.0;

  // 240802 SHJ: 센서 관련 변수들
  List<List<double>> array = [];
  int? maxIndex; // 240802 SHJ: 예측된 자세의 인덱스
  int maxIndexCount = 0; // 240802 SHJ: 자세 인식 카운트
  Timer? timer;
  late Interpreter _interpreter;
  String name = '';
  List<StreamSubscription<dynamic>> _streamSubscriptions = [];
  static const String _modelFile = 'assets/model/posture_analysis.tflite'; // 240802 SHJ: TFLite 모델 파일 경로
  List<double>? _accelerometerValues;
  List<double>? _gyroscopeValues;
  List<double>? _userAccelerometerValues;

  List<double>? latestAccelerometerValues;
  List<double>? latestGyroscopeValues;
  List<double>? latestUserAccelerometerValues;

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  // 240802 SHJ: 앱 초기화 메서드
  Future<void> _initialize() async {
    _speech = stt.SpeechToText(); // 240802 SHJ: SpeechToText 객체를 초기화
    await _initSpeech(); // 240802 SHJ: 음성 인식 초기화
    initializeSensors(_streamSubscriptions, _updateSensorValues);
    _interpreter = await loadModel(_modelFile); // 240802 SHJ: TFLite 모델을 로드
    _startRecording(); // 240802 SHJ: 센서 데이터 기록을 시작
  }

  // 240802 SHJ: 센서 데이터 업데이트 메서드
  void _updateSensorValues(List<double>? accelerometerValues, List<double>? gyroscopeValues, List<double>? userAccelerometerValues) {
    setState(() {
      if (accelerometerValues != null) {
        latestAccelerometerValues = accelerometerValues;
      }
      if (gyroscopeValues != null) {
        latestGyroscopeValues = gyroscopeValues;
      }
      if (userAccelerometerValues != null) {
        latestUserAccelerometerValues = userAccelerometerValues;
      }

      // 240802 SHJ: 센서 데이터가 업데이트될 때 로그 출력 - 디버깅용
      //print('Accelerometer: $latestAccelerometerValues, Gyroscope: $latestGyroscopeValues, UserAccelerometer: $latestUserAccelerometerValues');
    });
  }

  // 240802 SHJ: 음성 인식 초기화 메서드
  Future<void> _initSpeech() async {
    await initSpeech(_speech, (isListening) {
      setState(() => _isListening = isListening);
    });
  }

  // 240802 SHJ: 음성 인식을 시작 또는 중지하는 메서드
  Future<void> _listen() async {
    await listen(_speech, _isListening, (isListening, text, confidence) {
      setState(() {
        _isListening = isListening; // 240802 SHJ: 음성 인식 상태
        _text = text; // 240802 SHJ: 텍스트 인식
        _confidence = confidence;
      });
      if (_isListening) {
        print('Recognized text: $_text'); // 240802 SHJ: 터미널에 인식된 텍스트를 출력
      }
    });
  }

  // 240802 SHJ: 센서 데이터 기록을 시작
  void _startRecording() {
    timer = Timer.periodic(Duration(milliseconds: 20), (timer) {
      if (array.length < 128) {
        _addToArray();
      }
      if (array.length == 128) {
        timer.cancel();
        print('Predicting...'); // 240802 SHJ: 예측 시작 로그
        _predict();
        array.clear();
        _startRecording();
      }
    });
  }

  // 240802 SHJ: 센서 데이터를 배열에 추가
  void _addToArray() {
    if (latestAccelerometerValues != null && latestGyroscopeValues != null && latestUserAccelerometerValues != null) {
      array.add([
        latestAccelerometerValues![0], latestAccelerometerValues![1], latestAccelerometerValues![2],
        latestGyroscopeValues![0], latestGyroscopeValues![1], latestGyroscopeValues![2],
        latestUserAccelerometerValues![0], latestUserAccelerometerValues![1], latestUserAccelerometerValues![2]
      ]);
      setState(() {
        // print('Array size: ${array.length}'); // 240802 SHJ: 배열 크기를 출력 - 디버깅용
      });
    }
  }

  // 240802 SHJ: TFLite 모델을 사용하여 자세를 예측
  void _predict() {
    print('Running prediction...'); // 240802 SHJ: 예측 시작 로그
    predict(array, _interpreter, maxIndexCount, (predictedMaxIndex, updatedMaxIndexCount) {
      setState(() {
        maxIndex = predictedMaxIndex;
        maxIndexCount = updatedMaxIndexCount;
        String activity = getActivityText(maxIndex);
        print('Predicted activity: $activity'); // 240802 SHJ: 터미널에 예측된 자세 출력
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    for (StreamSubscription<dynamic> subscription in _streamSubscriptions) {
      subscription.cancel();
    }
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('홈페이지'), // 페이지 구별을 위함
        actions: [
          IconButton(
            icon: Icon(_isListening ? Icons.mic : Icons.mic_none),
            onPressed: _listen, // 240802 SHJ: 음성 인식 버튼을 눌렀을 때 _listen 메서드를 호출
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (maxIndex == 1) // 240802 SHJ: "Walking"일 때만 움직임을 표시
              Text(
                '움직임 감지됨',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
          ],
        ),
      ),
    );
  }
}
