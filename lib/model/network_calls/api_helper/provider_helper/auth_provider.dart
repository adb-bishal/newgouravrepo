import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/account_provider.dart';

import '../../../models/network_call_model/api_response.dart';
import '../repository_helper/auth_repo.dart';

class AuthProvider {
  final AuthRepo authRepo;
  AuthProvider({required this.authRepo});

  Future socialLogin(Map<String, dynamic> signInBody,
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await authRepo.socialLogin(signInBody);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future socialLoginNumber(Map<String, dynamic> signInBody,
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await authRepo.socialLoginNumber(signInBody);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future socialLoginVerify(Map<String, dynamic> signInBody,
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await authRepo.socialLoginVerify(signInBody);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future signInTap(Map<String, dynamic> signInBody,
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    print('sdfwecw $signInBody');
    ApiResponse apiResponse = await authRepo.signIn(signInBody);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future updateUserDataForAppTap(
      {Map<String, dynamic>? signInBody,
      required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await authRepo.updateUserDataForApp(signInBody);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getLoginDetails(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await authRepo.loginDetails();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future signUpTap(Map<String, dynamic> signInBody,
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await authRepo.signUpTap(signInBody);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future authVerify(Map<String, dynamic> signInBody,
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required bool isSignUp}) async {
    ApiResponse apiResponse =
        await authRepo.authVerify(signInBody, isSignUp: isSignUp);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}
