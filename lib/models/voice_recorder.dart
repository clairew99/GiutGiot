import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AudioRecorder {
  FlutterSoundRecorder? _audioRecorder;
  String? _audioFilePath;
  bool _isRecorderInitialized = false;
  bool _isRecording = false;
  DateTime? lastVoiceDetectedTime;
  StreamSubscription? _recorderSubscription;
  Timer? inactivityTimer;

  double? _lastDecibels; // 마지막 데시벨 값을 저장할 변수

  Future<void> initRecorder() async {
    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openRecorder();
    _isRecorderInitialized = true;
  }

  Future<void> disposeRecorder() async {
    if (_isRecorderInitialized) {
      await _audioRecorder!.closeRecorder();
      _audioRecorder = null;
      _isRecorderInitialized = false;
    }
    _recorderSubscription?.cancel();
  }

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

      bool hasPermissions = await Permission.microphone.request().isGranted;
      if (!hasPermissions) {
        throw RecordingPermissionException('Microphone permission not granted');
      }

      io.Directory appDocDir = await getApplicationDocumentsDirectory();
      _audioFilePath = '${appDocDir.path}/audio_record.wav';

      print('Attempting to record to: $_audioFilePath');

      await _audioRecorder!.startRecorder(
        toFile: _audioFilePath,
        codec: Codec.pcm16WAV,
      );

      _isRecording = true;
      lastVoiceDetectedTime = DateTime.now();

      // 오디오 스트림 구독
      _recorderSubscription = _audioRecorder!.onProgress!.listen((event) {
        if (event.decibels != null) {
          print('Decibels received: ${event.decibels}');
          _processAudioData(event.decibels!);
        } else {
          print('Decibels are null');
        }
      });

      print('Recording started at ${DateTime.now()}');
      print('Audio file path: $_audioFilePath');
    } catch (e) {
      print('Error starting recording: $e');
      if (e is RecordingPermissionException) {
        print('Permission error: ${e.message}');
      }
    }
  }

  void _processAudioData(double decibels) {
    _lastDecibels = decibels;
    print('Current decibel level: ${decibels.toStringAsFixed(2)} dB'); // 터미널에 데시벨 정보 출력

    if (decibels > 60) {  // 예시 임계값, 필요에 따라 조정
      lastVoiceDetectedTime = DateTime.now();
      print('Voice detected at ${lastVoiceDetectedTime} (${decibels.toStringAsFixed(2)} dB)');
    } else {
      print('No voice detected (${decibels.toStringAsFixed(2)} dB)');
    }
  }

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
        print('Recorder stopped at ${DateTime.now()}');
        print('Recording file path: $_audioFilePath');

        if (_audioFilePath != null && _audioFilePath!.isNotEmpty) {
          io.File audioFile = io.File(_audioFilePath!);
          if (await audioFile.exists()) {
            print('Audio file exists at: $_audioFilePath');
            print('File size: ${await audioFile.length()} bytes');
            await sendAudioFileToServer(audioFile);
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

  Future<void> sendAudioFileToServer(io.File file) async {
    try {
      if (await file.exists()) {
        print('Attempting to send file: ${file.path}');

        final request = http.MultipartRequest('POST', Uri.parse('http://127.0.0.1:5000/pyannote'));
        request.files.add(await http.MultipartFile.fromPath(
          'audio',
          file.path,
          filename: 'audio_record.wav',
        ));
        final response = await request.send();

        if (response.statusCode == 200) {
          final responseBody = await response.stream.bytesToString();
          final result = jsonDecode(responseBody);
          print('Server response: $result');
        } else {
          print('Failed to upload audio file. Status code: ${response.statusCode}');
        }

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

  // 1분 동안 음성이 감지되지 않았는지 확인하는 메서드
  bool isInactive() {
    if (lastVoiceDetectedTime == null) return false;
    return DateTime.now().difference(lastVoiceDetectedTime!) >= Duration(minutes: 1);
  }

  // 주기적으로 호출하여 비활성 상태 확인
  void checkInactivity() {
    if (_isRecording && isInactive()) {
      print('No voice detected for 1 minute. Stopping recording.');
      stopRecording();
    }
  }

  // 음성 비활성 타이머 시작
  void startInactivityTimer() {
    inactivityTimer?.cancel();
    inactivityTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkInactivity();
      printCurrentDecibels(); // 데시벨 정보 출력
    });
  }

  // 현재 데시벨 정보를 터미널에 출력
  void printCurrentDecibels() {
    double? lastDecibels = _lastDecibels;
    if (lastDecibels != null) {
      print('Current decibel level from recorder: ${lastDecibels.toStringAsFixed(2)} dB');
    }
  }

  bool get isRecording => _isRecording;
}
