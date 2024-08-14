import 'package:flutter/material.dart';
import 'package:speech_to_text/speech_to_text.dart' as stt;
import 'package:permission_handler/permission_handler.dart';
import 'package:dio/dio.dart';
import 'package:siri_wave/siri_wave.dart';
import 'package:flutter_tts/flutter_tts.dart';
import 'dart:convert';
import '../Dio/config.dart';
import '../Dio/access_token_manager.dart';

class VoiceActivationScreen extends StatefulWidget {
  @override
  _VoiceActivationScreenState createState() => _VoiceActivationScreenState();
}

class _VoiceActivationScreenState extends State<VoiceActivationScreen> {
  String _text = '';
  late stt.SpeechToText _speech;
  late IOS9SiriWaveformController _waveController;
  late FlutterTts _flutterTts;
  bool _isListening = false;
  Map<String, dynamic>? _clothesDetail;

  @override
  void initState() {
    super.initState();
    _speech = stt.SpeechToText();
    _waveController = IOS9SiriWaveformController();
    _flutterTts = FlutterTts();
    _initializeTts();
    // _fetchToken();
    _startListeningIfNotActive();
  }

  void _initializeTts() {
    _flutterTts.setStartHandler(() {
      setState(() {
        print("TTS is starting");
      });
    });

    _flutterTts.setCompletionHandler(() {
      setState(() {
        print("TTS is completed");
        _startListeningIfNotActive();
      });
    });

    _flutterTts.setErrorHandler((msg) {
      setState(() {
        print("TTS error: $msg");
      });
    });
  }

  // Future<void> _fetchToken() async {
  //   bool success = await AccessTokenManager.fetchAndSaveToken();
  //   if (!success) {
  //     print('Failed to fetch and save token');
  //   }
  // }

  Future<void> _startListeningIfNotActive() async {
    if (!_isListening) {
      await _listen();
    }
  }

  Future<void> _listen() async {
    PermissionStatus status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
      print('Microphone permission denied');
      return;
    }

    bool available = await _speech.initialize(
      onStatus: (status) => print('Speech recognition status: $status'),
      onError: (errorNotification) => print('Speech recognition error: $errorNotification'),
    );
    print('Speech recognition available: $available');
    if (available) {
      setState(() => _isListening = true);
      _speech.listen(
        onResult: (val) {
          if (mounted) {
            setState(() {
              _text = val.recognizedWords;
              _waveController.amplitude = (val.confidence ?? 1.0) * 0.5;
              print('Recognized words: $_text');
            });
            if (val.finalResult) {
              _sendTextToServer(_text);
              setState(() => _isListening = false);
            }
          }
        },
        onSoundLevelChange: (level) {
          _waveController.amplitude = level / 100;
        },
        listenFor: Duration(seconds: 60),
        pauseFor: Duration(seconds: 3),
        cancelOnError: true,
      );
    } else {
      setState(() => _isListening = false);
    }
  }

  Future<void> _stopListening() async {
    await _speech.stop();
    setState(() => _isListening = false);
  }

  Future<void> _sendTextToServer(String text) async {
    try {
      String? accessToken = await AccessTokenManager.getAccessToken();
      if (accessToken == null) {
        print('Access token is missing');
        return;
      }

      final dio = Dio();
      print('Sending text to server: $text');
      final response = await dio.post(
        Config.getConversationUri().toString(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': '$accessToken',
          },
        ),
        data: jsonEncode(<String, String>{'text': text}),
      );
      print('Server response status: ${response.statusCode}');

      if (response.statusCode == 200) {
        final responseData = response.data;
        print('Server response data: $responseData');

        if (responseData['type'] == 'Question') {
          String message = responseData['message'];

          setState(() {
            _text = message;
          });

          await _speak(message);

          if (responseData.containsKey('clothesId')) {
            String clothesId = responseData['clothesId'].toString();
            _fetchClothesDetail(clothesId, accessToken);
          }
        }
      } else {
        print('Failed to send text: ${response.statusCode}');
      }
    } catch (e) {
      print('Error sending text to server: $e');
    }
  }

  Future<void> _fetchClothesDetail(String clothesId, String token) async {
    try {
      final dio = Dio();
      final response = await dio.get(
        Config.getClothesUri(clothesId).toString(),
        options: Options(
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
            // 'Authorization': '$token',
          },
        ),
      );

      if (response.statusCode == 200) {
        setState(() {
          _clothesDetail = response.data;
          print('Clothes detail fetched: $_clothesDetail');
        });
      } else {
        print('Failed to fetch clothes detail: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching clothes detail: $e');
    }
  }

  Future<void> _speak(String text) async {
    print('Speaking text: $text');
    if (_isListening) {
      await _stopListening();
    }
    try {
      await _flutterTts.speak(text);
    } catch (e) {
      print('Error speaking text: $e');
      _startListeningIfNotActive();
    }
  }

  @override
  void dispose() {
    _stopListening();
    _flutterTts.stop();
    super.dispose();
    print('Disposed VoiceActivationScreen');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/background/bg.gif',
              fit: BoxFit.cover,
            ),
          ),
          Positioned(
            top: 40,
            left: 10,
            child: IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () async {
                await _stopListening();
                Navigator.pop(context);
                print('Back button pressed');
              },
            ),
          ),
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SiriWaveform.ios9(
                  controller: _waveController,
                  options: IOS9SiriWaveformOptions(
                    height: 150,
                    width: 300,
                    showSupportBar: true,
                  ),
                ),
                SizedBox(height: 20),
                Text(_text, style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    if (_isListening) {
                      await _stopListening();
                      print('Stopped listening');
                    } else {
                      await _startListeningIfNotActive();
                      print('Started listening');
                    }
                  },
                  child: Text(_isListening ? 'Stop Listening' : 'Start Listening'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}