import 'package:GIUTGIOT/Dio/access_token_manager.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';

class DioSingleton {
  static final DioSingleton _instance = DioSingleton._internal();
  final Dio dio;

  factory DioSingleton() {
    return _instance;
  }

  DioSingleton._internal()
      : dio = Dio(BaseOptions(
    // 요청할 기본 url
    baseUrl: 'https://i11a409.p.ssafy.io:8443',
  )){
    dio.interceptors.add(InterceptorsWrapper(
        onRequest: (options, handler) async {
          var accessToken = await AccessTokenManager.getAccessToken();
          if(accessToken == null){
            await AccessTokenManager.fetchAndSaveToken();
            accessToken = await AccessTokenManager.getAccessToken();
          }
          options.headers['Content-Type'] = 'application/json';
          options.headers['Authorization'] = '$accessToken';

          print(options.uri.toString());
          return handler.next(options);
        },
        onError: (error, handler){
          debugPrint(error.message);
          debugPrint(error.requestOptions.uri.toString());
    }
    ));
  }
}

// dio 수정이다 이 자식아~