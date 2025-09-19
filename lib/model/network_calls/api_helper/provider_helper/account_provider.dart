import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import '../../../models/network_call_model/api_response.dart';
import '../../../models/network_call_model/error_response.dart';
import '../repository_helper/account_repo.dart';

class AccountProvider {
  final AccountRepo accountRepo;
  AccountProvider({required this.accountRepo});

  Future getLanguage(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map)
          onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.getLanguage();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  Future getLiveClassRating(Map<String, dynamic> payload,
      {required Function(String? message, Map<String, dynamic>? errorMap)
      onError,
        required Function(String? message, Map<String, dynamic>? map) onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.getLiveClassRating(payload);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }


  Future getCategories(
      {required Function(String? message, Map<String, dynamic>? errorMap)
      onError,
        required Function(String? message, Map<String, dynamic> map)
        onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.getCategory();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  Future getNotificationCount(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map)
          onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.getNotificationCount();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getLevel(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map)
          onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.getLevel();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getServiceData(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map)
          onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.getServiceData();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getTags(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map)
          onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.getTags();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future logOut(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map)
          onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.logOut();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future deleteAccount(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map)
          onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.deleteAccount();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }


  Future verifyPayment(
      {required Function(String? message, Map<String, dynamic>? errorMap)
      onError,
        required Function(String? message, Map<String, dynamic> map)
        onSuccess, required Map<String, String?> body}) async {
    ApiResponse apiResponse = await accountRepo.verifyPayment(body);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getProfile(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map)
          onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.getProfile();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onPreferSubmit(Map<String, dynamic> map,
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map) onSuccess,
      XFile? file}) async {
    ApiResponse apiResponse =
        await accountRepo.onPreferSubmit(data: map, file: file);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onSubmitRefer(Map<String, dynamic> map,
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic> map)
          onSuccess}) async {
    ApiResponse apiResponse = await accountRepo.onSubmitRefer(
      data: map,
    );
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}

class CheckApiResponse {
  static CheckApiResponse? _instace;

  static CheckApiResponse get instance => _instace ??= CheckApiResponse._init();

  CheckApiResponse._init();

  Future<void> initResponse(ApiResponse apiResponse,
      {required Function(String? message, Map<String, dynamic> map) onSuccess,
      required Function(String? message, Map<String, dynamic>? errorMap)
          onError}) async {
    if (apiResponse.response != null &&
        apiResponse.response!.statusCode == 200) {
      Map<String, dynamic> map = apiResponse.response?.data ?? {};
      String message = map["message"] ?? "";
      if (map["status"]) {
        onSuccess(message, map);
      } else {
        String errorMessage;

        try {
          var errorResponseMap = jsonDecode(apiResponse.error ?? "{}");
          Map<String, dynamic> errorMap = {};
          if (errorResponseMap is String) {
            errorMessage = apiResponse.error.toString();
          } else {
            errorMap = errorResponseMap;
            ErrorResponse errorResponse;
            if (errorResponseMap is ErrorResponse) {
              errorResponse = errorResponseMap;
            } else {
              errorResponse = ErrorResponse(
                  errors: [Errors(message: StringResource.noDataFound)]);
            }
            errorMessage = errorResponse.errors![0].message!;
          }
          onError(errorMessage, errorMap);
        } catch (e) {
          // logPrint("dfsdfsd $e");
          onError.call(message, map);
        }
      }
    } else {
      String errorMessage;
      Map<String, dynamic> errorMap = {};
      String responseError;
      if (await apiResponse.error is ErrorResponse) {
        ErrorResponse tempError = await apiResponse.error;
        responseError = jsonEncode(tempError.toJson());
      } else {
        responseError = await apiResponse.error;
      }
      dynamic errorResponseMap;
      try {
        errorResponseMap = jsonDecode(responseError);
      } catch (e) {
        errorResponseMap = responseError;
      }
      if (errorResponseMap is String) {
        errorMessage = errorResponseMap;
      } else {
        errorMap = (errorResponseMap['errors'] == null)
            ? errorResponseMap
            : errorResponseMap['errors'][0];
        errorMessage =
            errorResponseMap[errorResponseMap.keys.first][0] is String
                ? errorResponseMap[errorResponseMap.keys.first][0]
                : errorResponseMap[errorResponseMap.keys.first][0]['message'];
        // ErrorResponse errorResponse = ErrorResponse.fromJson(errorResponseMap);
        // logPrint("masdasd ${errorResponse.toJson()}");
        // errorMessage = errorResponse.errors![0].message??"";
      }
      onError(errorMessage, errorMap);
    }
  }
}
