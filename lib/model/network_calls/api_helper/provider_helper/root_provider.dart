import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/root_repo.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';

import '../../../models/network_call_model/api_response.dart';
import 'account_provider.dart';

class RootProvider {
  final RootRepo rootRepo;
  RootProvider({required this.rootRepo});

  Future openTradingAccount(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required Map<String, dynamic> data}) async {
    ApiResponse apiResponse = await rootRepo.openTradingAccount(data);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future setGoal(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required Map<String, dynamic> data}) async {
    ApiResponse apiResponse = await rootRepo.setGoal(data);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onScalpHistory(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required String id}) async {
    ApiResponse apiResponse = await rootRepo.onScalpHistory(id: id);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future deleteGoal({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await rootRepo.deleteGoal();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future postFeedback(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required Map<String, dynamic> data}) async {
    ApiResponse apiResponse = await rootRepo.postFeedback(data);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future postUserActivity(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required dynamic data}) async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      ApiResponse apiResponse = await rootRepo.postUserActivity(data);
      CheckApiResponse.instance
          .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
    }
  }

  Future getUserActivity({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      ApiResponse apiResponse = await rootRepo.getUserActivity();
      CheckApiResponse.instance
          .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
    }
  }

  Future onRedeem({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await rootRepo.onRedeem();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getUpdateVersionCode(
    var data, {
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await rootRepo.getUpdateVersionCode(data);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getFaqData({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await rootRepo.getFaqData();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getTnc({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await rootRepo.getTnc();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getPromoCode(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required int pageNo}) async {
    ApiResponse apiResponse = await rootRepo.getPromoCode(pageNo: pageNo);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getNotification(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required int pageNo}) async {
    ApiResponse apiResponse = await rootRepo.getNotification(pageNo: pageNo);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getScalpData(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required int pageNo}) async {
    ApiResponse apiResponse = await rootRepo.getScalpData(pageNo: pageNo);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getDashBoardData({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await rootRepo.getDashBoardData();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getPopUpData({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
  }) async {
    ApiResponse apiResponse = await rootRepo.getPopUpData();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onLike(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required int id}) async {
    ApiResponse apiResponse = await rootRepo.onLike(id: id);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onShare(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required int id}) async {
    ApiResponse apiResponse = await rootRepo.onShare(id: id);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}
