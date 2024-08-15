import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'bluetooth_scan.dart';
import '../Dio/access_token_manager.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:http_parser/http_parser.dart';

class AudioRecorder {
  FlutterSoundRecorder? _audioRecorder;
  String? _audioFilePath;
  bool _isRecorderInitialized = false;
  static bool _isRecording = false;
  DateTime? lastVoiceDetectedTime;
  StreamSubscription? _recorderSubscription;
  Timer? inactivityTimer;
  double? _lastDecibels;
  static final BluetoothScanner bluetoothScanner = BluetoothScanner();
  stt.SpeechToText _speech = stt.SpeechToText();

  bool get isInitialized => _isRecorderInitialized;
  bool get isRecording => _isRecording;

  Future<void> initRecorder() async {
    if (!_isRecorderInitialized) {
      _audioRecorder = FlutterSoundRecorder();
      await _audioRecorder!.openRecorder();
      _isRecorderInitialized = true;
    }
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
      await initRecorder();
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

      _recorderSubscription = _audioRecorder!.onProgress!.listen((event) {
        if (event.decibels != null) {
          print('Decibels received: ${event.decibels}');
          _processAudioData(event.decibels!);
        } else {
          print('Decibels are null');
        }
      });

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

  void _processAudioData(double decibels) {
    _lastDecibels = decibels;
    print('-----------------------------------------------------------------');
    print('데시벨 측정중: ${decibels.toStringAsFixed(2)} dB');

    if (decibels > 50) {
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

        bluetoothScanner.stopScanning();

        print('Recording and Bluetooth scanning stopped at ${DateTime.now()}');
        print('Recording file path: $_audioFilePath');

        if (_audioFilePath != null && _audioFilePath!.isNotEmpty) {
          io.File audioFile = io.File(_audioFilePath!);
          if (await audioFile.exists()) {
            print('Audio file exists at: $_audioFilePath');
            print('File size: ${await audioFile.length()} bytes');

            List<String> devices = bluetoothScanner.getPhoneDeviceIds();
            print('디바이스 기기 : $devices');
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

  Future<void> sendAudioFileToServer(io.File file, List<String> devices) async {
    try {
      if (await file.exists()) {
        String? accessToken = await AccessTokenManager.getAccessToken();

        print("accessToken: $accessToken");
        if (accessToken == null) {
          throw Exception('Access token is missing');
        }

        print('Attempting to send file: ${file.path}');

        final request = http.MultipartRequest('POST', Uri.parse('http://i11a409.p.ssafy.io:5000/pyannote'));
        request.files.add(await http.MultipartFile.fromPath(
          'audio',
          file.path,
          contentType: MediaType('audio', 'wav'),  // Content-Type 명시
          filename: 'audio_record.wav',
        ));

        request.fields['devices'] = jsonEncode(devices);
        request.fields['token'] = '$accessToken';
        request.headers['Content-Type'] = 'multipart/form-data';

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

  bool isInactive() {
    if (lastVoiceDetectedTime == null) return false;
    return DateTime.now().difference(lastVoiceDetectedTime!) >= Duration(minutes: 1);
  }

  void checkInactivity() {
    if (_isRecording && isInactive()) {
      print('No voice detected for 1 minute. Stopping recording.');
      stopRecording();
    }
  }

  void startInactivityTimer() {
    inactivityTimer?.cancel();
    inactivityTimer = Timer.periodic(Duration(seconds: 10), (timer) {
      checkInactivity();
      printCurrentDecibels();
    });
  }

  void printCurrentDecibels() {
    double? lastDecibels = _lastDecibels;
    if (lastDecibels != null) {
      print('Current decibel level from recorder: ${lastDecibels.toStringAsFixed(2)} dB');
    }
  }

  static bool isAnyRecording() {
    return _isRecording;
  }

  // 새로운 음성 인식 메서드
  Future<void> initSpeech(Function(bool) onInit) async {
    bool available = await _speech.initialize(
      onStatus: (val) => print('onStatus: $val'),
      onError: (val) => print('onError: $val'),
    );
    if (available) {
      onInit(false);
    }
  }

  Future<void> listen(bool isListening, Function(bool, String, double) onResult) async {
    if (!isListening) {
      var status = await Permission.microphone.request();
      if (status.isGranted) {
        _speech.listen(
          onResult: (val) {
            String text = val.recognizedWords;
            double confidence = val.hasConfidenceRating && val.confidence > 0 ? val.confidence : 1.0;
            onResult(true, text, confidence);
          },
          listenFor: Duration(seconds: 30),
          pauseFor: Duration(seconds: 5),
          partialResults: true,
          onSoundLevelChange: (level) => print('Sound level: $level'),
          cancelOnError: true,
        );
      }
    } else {
      _speech.stop();
      onResult(false, '', 1.0);
    }
  }
}