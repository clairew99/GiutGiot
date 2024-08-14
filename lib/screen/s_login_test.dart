import 'dart:async';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:flutter_custom_tabs/flutter_custom_tabs_lite.dart' as lite;

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
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
                  TextButton( onPressed: () => _launchUrlLite(context),
           child: Text('구글 로그인'))

                      ],
                    ),
                  ),
        ]),)
      );

  }

  Future<void> _launchUrlLite(BuildContext context) async {
    final theme = Theme.of(context);
    try {
      await lite.launchUrl(
        Uri.parse('https://i11a301.p.ssafy.io/oauth2/authorization/google'),
        // Uri.parse('http://10.0.2.2.nip.io:8080/oauth2/authorization/google'),
        options: lite.LaunchOptions(
          barColor: theme.colorScheme.surface,
          onBarColor: theme.colorScheme.onSurface,
          barFixingEnabled: false,
        ),
      );
    } catch (e) {
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
      },
    );
  }

  Future<void> _handleLink(Uri uri) async {
    final accessToken = uri.queryParameters['code'];
    if (accessToken != null) {
    //
    print("액세스토큰 널 아님");
    }
  }
}