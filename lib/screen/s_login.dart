import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:app_links/app_links.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart' as lite;
import '../widget/button/bt_login.dart';
import 'package:GIUTGIOT/Dio/access_token_manager.dart';
import 'package:GIUTGIOT/src/myHome.dart';
import 's_PageSlide.dart';


class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<LoginPage> {
  StreamSubscription<dynamic>? _sub;

  @override
  void initState() {
    super.initState();
    _initUriListener();
  }

  @override
  void dispose() {
    _sub?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: size.width,
              height: size.height * 0.01,
            ),
            Container(
              width: 0.8 * size.width,
              child: Column(
                children: [
                  ButtonWidget(
                    button1Text: 'Google Login',
                    button2Text: 'Naver Login',
                    button3Text: 'Kakao Login',
                    onPressedButton1: () => _launchUrlLite(context, 'google'),
                    onPressedButton2: () => _launchUrlLite(context, 'naver'),
                    onPressedButton3: () => _launchUrlLite(context, 'kakao'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _launchUrlLite(BuildContext context, String provider) async {
    final theme = Theme.of(context);
    try {
      await lite.launchUrl(
        Uri.parse('https://i11a409.p.ssafy.io:8443/oauth2/authorization/$provider'),
        options: lite.LaunchOptions(
          barColor: theme.colorScheme.surface,
          onBarColor: theme.colorScheme.onSurface,
          barFixingEnabled: false,
        ),
      );
    } catch (e) {
      print("Error launching URL: $e");
    }
  }

  void _initUriListener() {
    final appLinks = AppLinks();
    _sub = appLinks.uriLinkStream.listen(
          (Uri? uri) {
        if (uri != null && uri.scheme == 'giutgiot' && uri.host == 'callback') {
          _handleLink(uri);
        }
      },
      onError: (err) {
        print("Error in URI listener: $err");
      },
    );
  }

  Future<void> _handleLink(Uri uri) async {
    final code = uri.queryParameters['code'];
    if (code != null) {
      print("Authorization code received: $code");

      try {
        // 서버에 Authorization Code를 보내고, 액세스 토큰 및 리프레시 토큰을 받아옴
        final response = await sendCodeToServer(code);

        final accessToken = response['accessToken'];
        final refreshToken = response['refreshToken'];

        // 토큰을 시큐어 스토리지에 저장
        await AccessTokenManager.setAccessToken(accessToken);
        await AccessTokenManager.setRefreshToken(refreshToken);

        print("토큰 저장 성공");

        // 로그인 성공 후 홈 화면으로 이동
        Get.offAll(() => PageSlide());
      } catch (e) {
        print("로그인 실패: $e");
        // 오류 메시지 표시 등 추가 작업
      }
    } else {
      print("Authorization code not found");
    }
  }

  Future<Map<String, dynamic>> sendCodeToServer(String code) async {
    final dio = Dio();
    final url = 'https://i11a409.p.ssafy.io:8443/login';

    try {
      final response = await dio.post(
        url,
        data: {
          'code': code,
        },
      );

      if (response.statusCode == 200) {
        final accessToken = response.headers.value('Authorization') ?? '';
        final refreshToken = response.headers['set-cookie']?.firstWhere(
              (cookie) => cookie.startsWith('refresh='),
          orElse: () => '',
        ) ?? '';

        print("accessToken $accessToken");
        print("refreshToken $refreshToken");
        return {
          'accessToken': accessToken,
          'refreshToken': refreshToken,
        };
      } else {
        throw Exception('Failed to login: ${response.statusCode}');
      }
    } catch (e) {
      print("Error sending code to server: $e");
      throw e;
    }
  }
}

