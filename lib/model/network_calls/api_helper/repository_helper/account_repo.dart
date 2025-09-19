import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart' as get_package;
import 'package:http_parser/http_parser.dart';
import 'package:image_picker/image_picker.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';

import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class AccountRepo {
  final DioClient dioClient;
  AccountRepo({
    required this.dioClient,
  });

  Future<ApiResponse> getLanguage() async {
    String url = AppConstants.instance.language;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }
  Future<ApiResponse> getCategory() async {
    String url = AppConstants.instance.counsellors;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }
  Future<ApiResponse> getNotificationCount() async {
    String url = AppConstants.instance.notificationCount;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getTags() async {
    String url = AppConstants.instance.tags;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> logOut() async {
    String url = AppConstants.instance.logOut;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: {
      "device_token": get_package.Get.find<AuthService>().getUserFcmToken(),
      "device_type": Platform.isIOS ? "ios" : "android"
    });
  }

  Future<ApiResponse> getLiveClassRating(Map<String, dynamic?> body) async {
    String url = AppConstants.instance.liveClassRating;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: {
      ...body,
      "device_token": get_package.Get.find<AuthService>().getUserFcmToken(),
      "device_type": Platform.isIOS ? "ios" : "android"
    });
  }

  Future<ApiResponse> deleteAccount() async {
    String url = AppConstants.instance.deleteAccount;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: {
      "device_token": get_package.Get.find<AuthService>().getUserFcmToken(),
      "device_type": Platform.isIOS ? "ios" : "android"
    });
  }

  Future<ApiResponse> verifyPayment(Map<String, String?> body) async {
    String url = AppConstants.instance.verifyPayment;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: {
      ...body,
      "device_token": get_package.Get.find<AuthService>().getUserFcmToken(),
      "device_type": Platform.isIOS ? "ios" : "android",

    });
  }

  Future<ApiResponse> onSubmitRefer(
      {required Map<String, dynamic> data}) async {
    String url = AppConstants.instance.referby;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: data);
  }

  Future<ApiResponse> getProfile() async {
    String url = AppConstants.instance.getProfile;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getLevel() async {
    String url = AppConstants.instance.level;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getServiceData() async {
    String url = AppConstants.instance.service;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> onPreferSubmit(
      {required Map<String, dynamic> data, XFile? file}) async {
    String url;
    Object postData;
    if (file?.path != null) {
      String? fileName = file?.path.split('/').last;
      postData = FormData.fromMap({
        "image": await MultipartFile.fromFile(file?.path ?? "",
            filename: fileName, contentType: MediaType("image", "jpg")),
      });
      url = AppConstants.instance.profileImageUpdate;
    } else {
      postData = data;
      url = AppConstants.instance.profileUpdate;
    }
    return dioClient.postResponse(
        url: url, data: postData, dioClient: dioClient);
  }
}
