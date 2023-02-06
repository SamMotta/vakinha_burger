import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vakinha_burger/app/core/exceptions/expire_token_exception.dart';
import 'package:vakinha_burger/app/core/global/global_context.dart';
import 'package:vakinha_burger/app/core/rest_client/custom_dio.dart';

class AuthInterceptor extends Interceptor {
  final CustomDio dio;

  AuthInterceptor(this.dio);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {
    final sp = await SharedPreferences.getInstance();
    final accessToken = sp.getString('access_token');

    options.headers['Authorization'] = 'Bearer $accessToken';

    super.onRequest(options, handler);
  }

  @override
  void onError(DioError err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      try {
        if (err.requestOptions.path != '/auth/refresh') {
          await _refreshToken(err);
          await _retryRequest(err, handler);
        } else {
          GlobalContext.instance.loginExpire();
        }
      } catch (e, s) {
        log('Ocorreu um erro', error: e, stackTrace: s);
        GlobalContext.instance.loginExpire();
      }
    }

    super.onError(err, handler);
  }

  Future<void> _refreshToken(DioError err) async {
    try {
      final sp = await SharedPreferences.getInstance();
      final refreshToken = sp.getString('refresh_token');

      if (refreshToken == null) {
        return;
      }

      final refreshResult = await dio.auth().put('/auth/refresh', data: {
        'refresh_token': refreshToken,
      });

      sp.setString("access_token", refreshResult.data['access_token']);
      sp.setString("refresh_token", refreshResult.data['refresh_token']);
    } on DioError {
      throw ExpireTokenException();
    }
  }

  Future<void> _retryRequest(DioError err, ErrorInterceptorHandler handler) async {
    final requestOptions = err.requestOptions;

    final result = await dio.request(
      requestOptions.path,
      options: Options(
        headers: requestOptions.headers,
        method: requestOptions.method,
      ),
      data: requestOptions.data,
      queryParameters: requestOptions.queryParameters,
    );

    handler.resolve(
      Response(
        requestOptions: requestOptions,
        data: result.data,
        statusCode: result.statusCode,
        statusMessage: result.statusMessage,
      ),
    );
  }
}
