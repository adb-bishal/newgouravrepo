import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../view/widgets/log_print/log_print_condition.dart';
import '../../../enum/routing/routes/app_pages.dart';
import '../../models/network_call_model/error_response.dart';
import '../../services/auth_service.dart';

class ApiErrorHandler {
  static dynamic getMessage(error) async {
    dynamic errorDescription = "";
    if (error is Exception) {
      try {
        if (error is DioError) {
          logPrint("sdfsd ${error.type}");
          switch (error.type) {
            case DioErrorType.cancel:
              errorDescription = "Request to API server was cancelled";
              break;
            case DioErrorType.connectTimeout:
              errorDescription = "Connection timeout with API server";
              break;
            case DioErrorType.other:
              errorDescription =
                  "Connection to API server failed due to internet connection";
              break;
            case DioErrorType.receiveTimeout:
              errorDescription =
                  "Receive timeout in connection with API server";
              break;
            case DioErrorType.response:
              switch (error.response!.statusCode) {
                case 401:
                  Get.offAllNamed(Routes.loginScreen);
                  await Get.find<AuthService>().logOut();

                  if (kDebugMode) {
                    toastShow(
                        message: "Invalid Token !!! Please login again",
                        error: true);
                  }
                  ErrorResponse errorResponse =
                      ErrorResponse.fromJson(error.response!.data);

                  if (errorResponse.errors != null &&
                      errorResponse.errors!.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription = error.response?.data['message'] ??
                        "Failed to load data - status code: ${error.response!.statusCode}";
                  }
                  if (error.response!.data['errors'] == "token_invalid" ||
                      error.response!.data['message'] == "LOGGED_OUT") {}
                  break;
                case 503:
                  errorDescription = error.response!.statusMessage;
                  break;
                default:
                  logPrint("this is error response ${error.response!.data}");
                  ErrorResponse errorResponse =
                      ErrorResponse.fromJson(error.response!.data);
                  if (errorResponse.errors != null &&
                      errorResponse.errors!.isNotEmpty) {
                    errorDescription = errorResponse;
                  } else {
                    errorDescription = error.response!.data['message'] ??
                        "Failed to load data - status code: ${error.response!.statusCode}";
                  }
              }
              break;
            case DioErrorType.sendTimeout:
              errorDescription = "Send timeout with server";
              break;
          }
        } else {
          errorDescription = "Unexpected error occured";
        }
      } on FormatException catch (e) {
        errorDescription = e.toString();
      }
    } else {
      Map<String, dynamic> errorResponse = error;
      if (errorResponse.isNotEmpty && errorResponse['errors'] != null) {
        Map<String, dynamic> errors = errorResponse['errors'];
        if (errors.isNotEmpty) {
          // errors.forEach((key, value) {
          //   errorDescription = value[0].toString();
          // });
          errorDescription = jsonEncode(errors);
        } else {
          errorDescription =
              errorResponse["message"] ?? "is not a subtype of exception";
        }
      } else {
        errorDescription =
            errorResponse["message"] ?? "is not a subtype of exception";
      }
    }
    return errorDescription;
  }
}
