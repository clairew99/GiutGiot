import 'dart:async';
import 'dart:io' as io;
import 'package:flutter_sound/flutter_sound.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

FlutterSoundRecorder? _audioRecorder;
String? _audioFilePath;

// 마이크 권한 요청 함수
Future<void> requestPermissions() async {
  var status = await Permission.microphone.request();
  if (status != PermissionStatus.granted) {
    throw RecordingPermissionException('Microphone permission not granted');
  }
}

// 녹음 시작 함수
Future<void> startRecording() async {
  try {
    await requestPermissions();

    _audioRecorder = FlutterSoundRecorder();
    await _audioRecorder!.openRecorder();

    io.Directory tempDir = await getTemporaryDirectory();
    _audioFilePath = '${tempDir.path}/audio_record.wav';

    print('Attempting to record to: $_audioFilePath');

    await _audioRecorder!.startRecorder(
      toFile: _audioFilePath,
      codec: Codec.pcm16,
      numChannels: 1,
      sampleRate: 16000,
    );

    print('Recording started');
    print('Audio file path: $_audioFilePath');
  } catch (e) {
    print('Error starting recording: $e');
  }
}

// 녹음 중지 함수
Future<void> stopRecording() async {
  try {
    String? path = await _audioRecorder!.stopRecorder();
    await _audioRecorder!.closeRecorder();
    _audioRecorder = null;

    if (path != null) {
      io.File audioFile = io.File(path);
      if (await audioFile.exists()) {
        print('Audio file exists at: $path');
        print('File size: ${await audioFile.length()} bytes');
        await sendAudioFileToServer(audioFile);
      } else {
        print('Error: Audio file not found at $path');
        print('Current directory contents:');
        io.Directory(io.Directory(path).parent.path).listSync().forEach((entity) {
          print(entity.path);
        });
      }
    } else {
      print('Error: Recording failed, path is null');
    }

    print('Recording stopped');
  } catch (e) {
    print('Error stopping recording: $e');
  }
}

// 오디오 파일을 서버로 전송하는 함수
Future<void> sendAudioFileToServer(io.File file) async {
  try {
    if (!await file.exists()) {
      throw io.FileSystemException('File not found', file.path);
    }

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

    // 파일 전송 후 삭제
    await file.delete();
    print('Temporary audio file deleted');
  } catch (e) {
    print('Error sending audio file to server: $e');
    if (e is io.FileSystemException) {
      print('File system error: ${e.message}, path: ${e.path}');
    }
  }
}