import 'dart:convert';

import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class AuthRepo {
  final DioClient dioClient;
  AuthRepo({
    required this.dioClient,
  });

  Future<ApiResponse> signIn(Map<String, dynamic> signInBody) async {
    print('dfvdfv');
    String url = AppConstants.instance.signIn;
    var data = json.encode(signInBody);
    print('dfvdfvsd $data');
    return dioClient.postResponse(url: url, data: data, dioClient: dioClient);
  }

  Future<ApiResponse> updateUserDataForApp(
      [Map<String, dynamic>? signInBody]) async {
    String url = AppConstants.instance.updateUserDataForApp;
    var data = json.encode(signInBody);
    return dioClient.postResponse(url: url, data: data, dioClient: dioClient);
  }

  Future<ApiResponse> loginDetails() async {
    String url = AppConstants.instance.loginPageData;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> socialLogin(Map<String, dynamic> signInBody) async {
    String url = AppConstants.instance.socialLogin;
    var data = json.encode(signInBody);
    return dioClient.postResponse(url: url, data: data, dioClient: dioClient);
  }

  Future<ApiResponse> socialLoginNumber(Map<String, dynamic> signInBody) async {
    String url = AppConstants.instance.socialLoginNumber;
    var data = json.encode(signInBody);
    return dioClient.postResponse(url: url, data: data, dioClient: dioClient);
  }

  Future<ApiResponse> socialLoginVerify(Map<String, dynamic> signInBody) async {
    String url = AppConstants.instance.socialLoginVerify;
    var data = json.encode(signInBody);
    return dioClient.postResponse(url: url, data: data, dioClient: dioClient);
  }

  Future<ApiResponse> signUpTap(Map<String, dynamic> signInBody) async {
    String url = AppConstants.instance.signUp;
    var data = json.encode(signInBody);
    return dioClient.postResponse(url: url, data: data, dioClient: dioClient);
  }

  Future<ApiResponse> authVerify(Map<String, dynamic> signInBody,
      {required bool isSignUp}) async {
    String url;
    if (isSignUp) {
      url = AppConstants.instance.signUpVerify;
    } else {
      url = AppConstants.instance.signInVerify;
    }

    var data = json.encode(signInBody);
    return dioClient.postResponse(url: url, data: data, dioClient: dioClient);
  }
}
