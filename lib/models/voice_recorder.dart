import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bluetooth_scan.dart';

class AudioRecorder {
  FlutterSoundRecorder? _audioRecorder;
  String? _audioFilePath;
  bool _isRecorderInitialized = false;
  static bool _isRecording = false;
  DateTime? lastVoiceDetectedTime;
  StreamSubscription? _recorderSubscription;
  Timer? inactivityTimer;

  double? _lastDecibels;

  // 블루투스 스캐너 인스턴스 생성
  static final BluetoothScanner bluetoothScanner = BluetoothScanner();

  // 레코더 초기화
  Future<void> initRecorder() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openRecorder();
    _isRecorderInitialized = true;
  }

  // 레코더 해제
  Future<void> disposeRecorder() async {
    if (_isRecorderInitialized) {
      await _audioRecorder!.closeRecorder();
      _audioRecorder = null;
      _isRecorderInitialized = false;
    }
    _recorderSubscription?.cancel();
  }

  // 녹음 시작
  Future<void> startRecording() async {
    if (!_isRecorderInitialized) {
      throw RecordingPermissionException('Recorder is not initialized');
    }

    if (_isRecording) {
      print('Recording is already in progress');
      return;
    }

    try {
      print('Starting recording process...');

      // 마이크 권한 요청
      bool hasPermissions = await Permission.microphone.request().isGranted;
      if (!hasPermissions) {
        throw RecordingPermissionException('Microphone permission not granted');
      }

      // 오디오 파일 경로 설정
      io.Directory appDocDir = await getApplicationDocumentsDirectory();
      _audioFilePath = '${appDocDir.path}/audio_record.wav';

      print('Attempting to record to: $_audioFilePath');

      // 녹음 시작
      await _audioRecorder!.startRecorder(
        toFile: _audioFilePath,
        codec: Codec.pcm16WAV,
      );

      _isRecording = true;
      lastVoiceDetectedTime = DateTime.now();

      // 오디오 데이터 스트림 구독
      _recorderSubscription = _audioRecorder!.onProgress!.listen((event) {
        if (event.decibels != null) {
          print('Decibels received: ${event.decibels}');
          _processAudioData(event.decibels!);
        } else {
          print('Decibels are null');
        }
      });

      // 블루투스 스캔 시작
      await bluetoothScanner.startScanning();

      print('Recording and Bluetooth scanning started at ${DateTime.now()}');
      print('Audio file path: $_audioFilePath');
    } catch (e) {
      print('Error starting recording: $e');
      if (e is RecordingPermissionException) {
        print('Permission error: ${e.message}');
      }
    }
  }

  // 오디오 데이터 처리 (데시벨 레벨 체크)
  void _processAudioData(double decibels) {
    _lastDecibels = decibels;
    print('-----------------------------------------------------------------');
    print('데시벨 측정중: ${decibels.toStringAsFixed(2)} dB');

    if (decibels > 50) {  // 예시 임계값, 필요에 따라 조정
      lastVoiceDetectedTime = DateTime.now();
      print('Voice detected at ${lastVoiceDetectedTime} (${decibels.toStringAsFixed(2)} dB)');
    } else {
      print('No voice detected (${decibels.toStringAsFixed(2)} dB)');
    }
  }

  // 녹음 중지
  Future<void> stopRecording() async {
    if (!_isRecorderInitialized || !_isRecording) {
      print('Recorder is not initialized or not recording');
      return;
    }

    try {
      print('Attempting to stop recording at ${DateTime.now()}...');
      if (_audioRecorder!.isRecording) {
        await _audioRecorder!.stopRecorder();
        _isRecording = false;
        _recorderSubscription?.cancel();

        // 블루투스 스캔 중지
        bluetoothScanner.stopScanning();

        print('Recording and Bluetooth scanning stopped at ${DateTime.now()}');
        print('Recording file path: $_audioFilePath');

        if (_audioFilePath != null && _audioFilePath!.isNotEmpty) {
          io.File audioFile = io.File(_audioFilePath!);
          if (await audioFile.exists()) {
            print('Audio file exists at: $_audioFilePath');
            print('File size: ${await audioFile.length()} bytes');

            // 감지된 블루투스 기기 ID 가져오기
            List<String> devices = bluetoothScanner.getPhoneDeviceIds();
            print('디바이스 기기 : $devices');
            // 서버로 오디오 파일 및 기기 ID 전송
            await sendAudioFileToServer(audioFile, devices);
          } else {
            print('Error: Audio file not found at $_audioFilePath');
          }
        } else {
          print('Error: Recording failed, _audioFilePath is null or empty');
        }
      }
    } catch (e) {
      print('Error stopping recording: $e');
    }
  }

  // 서버로 오디오 파일 전송
  Future<void> sendAudioFileToServer(io.File file, List<String> devices) async {
    try {
      if (await file.exists()) {
        print('Attempting to send file: ${file.path}');

        // 멀티파트 요청 생성
        final request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:5000/pyannote'));
        request.files.add(await http.MultipartFile.fromPath(
          'audio',
          file.path,
          filename: 'audio_record.wav',
        ));
        // 기기 ID 목록을 JSON으로 인코딩하여 전송
        request.fields['devices'] = jsonEncode(devices);
        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final result = jsonDecode(responseBody);
          print('Server response: $result');
        } else {
          print('Failed to upload audio file. Status code: ${response.statusCode}');
        }

        // 임시 오디오 파일 삭제
        await file.delete();
        print('Temporary audio file deleted');
      } else {
        print('Error: File does not exist at ${file.path}');
      }
    } catch (e) {
      print('Error sending audio file to server: $e');
      if (e is io.FileSystemException) {
        print('File system error: ${e.message}, path: ${e.path}');
      }
    }
  }

  // 비활성 상태 체크 (1분 이상 음성 미감지)
  bool isInactive() {
    if (lastVoiceDetectedTime == null) return false;
    return DateTime.now().difference(lastVoiceDetectedTime!) >= Duration(minutes: 1);
  }

  // 비활성 상태 확인 및 녹음 중지
  void checkInactivity() {
    if (_isRecording && isInactive()) {
      print('No voice detected for 1 minute. Stopping recording.');
      stopRecording();
    }
  }

  // 비활성 타이머 시작
  void startInactivityTimer() {
    inactivityTimer?.cancel();
    inactivityTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkInactivity();
      printCurrentDecibels();
    });
  }

  // 현재 데시벨 레벨 출력
  void printCurrentDecibels() {
    double? lastDecibels = _lastDecibels;
    if (lastDecibels != null) {
      print('Current decibel level from recorder: ${lastDecibels.toStringAsFixed(2)} dB');
    }
  }

  // 녹음 상태 확인
  bool get isRecording => _isRecording;

  // 정적 메서드: 녹음 중인지 확인
  static bool isAnyRecording() {
    return _isRecording;
  }
}
