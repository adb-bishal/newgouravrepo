import 'dart:io';

import 'package:curl_logger_dio_interceptor/curl_logger_dio_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart' as get_pack;
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../service/floor/clientService.dart';
import '../../models/network_call_model/api_response.dart';
import '../../services/auth_service.dart';
import '../exception/api_error_handler.dart';
import 'logging_interceptor.dart';

class DioClient {
  final String baseUrl;
  final LoggingInterceptor? loggingInterceptor;
  // final SharedPreferences sharedPreferences;

  late Dio dio;
  late String token;

  DioClient(
    this.baseUrl,
    Dio? dioC, {
    this.loggingInterceptor,
    // this.sharedPreferences,
  }) {
    token = get_pack.Get.find<AuthService>().getUserToken();
    logPrint("Token : $token");
    dio = dioC ?? Dio();
    dio
      ..options.baseUrl = baseUrl
      ..options.connectTimeout = 50000
      ..options.receiveTimeout = 600000
      ..httpClientAdapter
      ..options.headers = {
        'Content-Type': 'application/json',
        'Device-Type': Platform.isAndroid ? "android" : "ios"
      };
    if (token != "" && token.isNotEmpty) {
      dio.options.headers.addAll({'Authorization': 'Bearer $token'});
    }
    if (kDebugMode) {
      dio.interceptors.add(loggingInterceptor!);
      dio.interceptors.add(CurlLoggerDioInterceptor(printOnSuccess: true));
      dio.interceptors.add(
        DioLoggingInterceptor(
          level: Level.body,
          compact: false,
        ),
      );
    }
  }

  Future<Response> _get(
    String uri, {
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.get(
        uri,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on SocketException catch (e) {
      throw SocketException(e.toString());
    } on FormatException catch (_) {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> getResponse(
      {required String url, required DioClient dioClient}) async {
    try {
      var sp = GlobalService().key;
      sp = (sp == null || sp == 'null') ? '' : sp;
      // print('scfsedc $sp');
      Response response = await dioClient._get(
        '$url$sp',
      );
      print('api response $response');
      return ApiResponse.withSuccess(response);
    } catch (e) {
      logPrint("error $e");
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<Response> _post(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.post(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> postResponse(
      {required String url,
      required data,
      required DioClient dioClient}) async {
    try {
      Response response = await dioClient._post(
        url,
        data: data,
      );
      if (response.statusCode == 200 && response.data['status']) {
        return ApiResponse.withSuccess(response);
      } else {
        return ApiResponse.withError(ApiErrorHandler.getMessage(response.data));
      }
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }

  Future<Response> put(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
    ProgressCallback? onSendProgress,
    ProgressCallback? onReceiveProgress,
  }) async {
    try {
      var response = await dio.put(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
        onSendProgress: onSendProgress,
        onReceiveProgress: onReceiveProgress,
      );
      return response;
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<Response> delete(
    String uri, {
    data,
    Map<String, dynamic>? queryParameters,
    Options? options,
    CancelToken? cancelToken,
  }) async {
    try {
      var response = await dio.delete(
        uri,
        data: data,
        queryParameters: queryParameters,
        options: options,
        cancelToken: cancelToken,
      );
      return response;
    } on FormatException {
      throw const FormatException("Unable to process the data");
    } catch (e) {
      rethrow;
    }
  }

  Future<ApiResponse> deleteResponse(
      {required String url,
      required data,
      required DioClient dioClient}) async {
    try {
      Response response = await dioClient.delete(
        url,
        data: data,
      );
      if (response.statusCode == 200 && response.data['status']) {
        return ApiResponse.withSuccess(response);
      } else {
        return ApiResponse.withError(ApiErrorHandler.getMessage(response.data));
      }
    } catch (e) {
      return ApiResponse.withError(ApiErrorHandler.getMessage(e));
    }
  }
}
