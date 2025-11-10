import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:sms_autofill/sms_autofill.dart';
// import 'package:sms_otp_auto_verify/sms_otp_auto_verify.dart';
import '../../../feedback/web_socket_service.dart';
import '../../../main.dart';
import '../../../model/network_calls/api_helper/provider_helper/auth_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../model/services/auth_service.dart';
import '../../../model/utils/string_resource.dart';
import '../../../view/widgets/log_print/log_print_condition.dart';
import '../../../view/widgets/toast_view/showtoast.dart';
import '../../../enum/routing/routes/app_pages.dart';

enum ScreenViewType { login, signUp }

class SignUpController extends GetxController {
  final GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> mobileController = TextEditingController().obs;
  Rx<TextEditingController> otpController = TextEditingController().obs;
  Rx<ScreenViewType> screenViewType = ScreenViewType.signUp.obs;
  AuthProvider authProvider = getIt();
  RxString hashKey = "".obs;
  RxString emailError = "".obs;
  RxString mobileError = "".obs;
  RxString nameError = "".obs;
  RxString privacyError = "".obs;
  RxBool isRememberChek = true.obs;
  RxBool isLoading = false.obs;
  RxBool isOtpLoading = false.obs;
  Timer? timer;
  RxInt countValue = 0.obs;
  RxInt second = 30.obs;
  RxString time = "".obs;
  RxBool isTimeUp = false.obs;
  RxBool isResend = false.obs;
  RxBool isSignUp = true.obs;

  generateHashKey() async {
    logPrint("-------------------------------key--------------------------");
    hashKey.value = await SmsAutoFill().getAppSignature;
    logPrint("-----------hashKey value-------------  = " + hashKey.value);
  }

  @override
  void onInit() {
    super.onInit();

    // Lock the device orientation to portrait mode
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

    logPrint(
        "-------------------------------Get.arguments--------------------------" +
            Get.arguments);
    // Check if there are arguments passed and initialize the OTP listener
    if (Get.arguments != null) {
      _startListeningSms();
      emailController.value.text = Get.arguments;
      isSignUp.value = false;

      // Add a listener to detect OTP input
      otpController.value.addListener(() {
        if (otpController.value.text.length == 4) {
          onSubmitOtp();
        }
      });
      //startTimer();
    }

    // Generate the app's hash key for SMS auto-fill
    generateHashKey();
  }

  // Request runtime SMS permissions

  final intRegex = RegExp(r'\d+', multiLine: true);

  _startListeningSms() async {
    /* logPrint(
        "-------------------------------_startListeningSms started --------------------------");

    // Start listening for SMS
    await SmsVerification.startListeningSms().then((message) {
      logPrint("--------Received SMS message: ------------------$message");

      // Extract OTP code using the regex
      String otpCode = SmsVerification.getCode(message, intRegex);
      logPrint(
          "-------------------------------otpCode ---------------------- = " +
              otpCode);

      // Check if an OTP was found and submit it
      if (otpCode != "") {
        otpController.value.text = otpCode;
        onSubmitOtp();
      } else {
        logPrint(
            "-------------No OTP code found in the message.---------------");
      }
    });*/
  }

  @override
  void onClose() async {
    otpController.value.removeListener(() {});
    super.onClose();
  }

  VoidCallback get logInTap => () async {
        isLoading.value = true;

        try {
          await authProvider.signInTap({
            "user_name": emailController.value.text,
          }, onError: (message, errorMap) {
            if (errorMap?.isEmpty ?? false) {
              toastShow(message: 'Check your internet connection');
            }
            isLoading.value = false;
            toastShow(message: message ?? "Please try again", error: true);
            logPrint("login error => $message");
          }, onSuccess: (message, data) async {
            if (data != null) {
              toastShow(message: message);
              //await Get.find<AuthService>().saveUser(data["user"]);
              // await Get.find<AuthService>().saveUserToken(data["accessToken"]);
              // if(isRememberChek.value){await Get.find<AuthService>().isRememberTap(isRememberChek.value.toString());}
              // Get.toNamed(Routes.otpScreen,arguments: emailController.text);
              // Get.offAllNamed(Routes.permissionScreen);
              isLoading.value = false;
            }
          });
        } catch (e) {
          logPrint("login error $e");
          isLoading.value = false;
        }
      };

  void resendOtp() async {
    isResend.value = true;
    isTimeUp.value = false;
    isSignUp.value ? onSignUp() : logInTap();
    otpController.value.clear();
    Future.delayed(const Duration(milliseconds: 50), () {
      isResend.value = false;
    });
  }

  Future onSignUp() async {
    print('sdsdcdcs');
    isOtpLoading.value = false;
    if ((signUpFormKey.currentState?.validate() ?? false) &&
        !isLoading.value &&
        isRememberChek.value) {
      isLoading.value = true;
      privacyError.value = "";
      try {
        print('sdcvsdcs ${SmsAutoFill().getAppSignature}');
        await authProvider.signUpTap({
          "mobile_no": mobileController.value.text,
          "email": emailController.value.text,
          "name": nameController.value.text,
          "hash_code": await SmsAutoFill().getAppSignature
        }, onError: (message, errorMap) {
          logPrint('error Map: $errorMap');
          if (errorMap?.isEmpty ?? false) {
            toastShow(message: 'Check your internet connection');
          }
          isLoading.value = false;
          if (errorMap?.isNotEmpty ?? false) {
            String key = errorMap?['code'];
            String value = errorMap?['message'];
            if (key == "mobile_no") {
              if (value.isNotEmpty) {
                mobileError.value = value;
              }
            } else if (key == "email") {
              if (value.isNotEmpty) {
                emailError.value = value;
              }
            } else if (key == "name") {
              if (value.isNotEmpty) {
                nameError.value = value;
              }
            }
          }
        }, onSuccess: (message, data) async {
          if (data != null) {
            toastShow(message: message, error: false);
            otpController.value.clear();
            _startListeningSms();
            Get.toNamed(Routes.otpScreen);
            isTimeUp.value = false;
            isLoading.value = false;
          }
        });
      } catch (e) {
        logPrint("this is login try error ${e.toString()}");
        isLoading.value = false;
      }
    } else {
      if (!isRememberChek.value) {
        privacyError.value = StringResource.privacyPolicyCheck;
      } else {
        privacyError.value = "";
      }
      isLoading.value = false;
    }
  }

  Future onSubmitOtp() async {
    logPrint("otp bhai aa jaa ");
    if (otpController.value.text.length > 3 && !isOtpLoading.value) {
      logPrint("otp bhai aa jaa: hi");
      isOtpLoading.value = true;
      Map<String, dynamic> data;
      String deviceId = await Get.find<AuthService>().getDeviceToken() ?? "";
      logPrint("otp bhai aa jaa:  ${deviceId}");

      if (isSignUp.value) {
        logPrint("otp bhai aa jaa: hii");
        data = {
          "mobile_no": mobileController.value.text,
          "email": emailController.value.text,
          "name": nameController.value.text,
          "otp": otpController.value.text,
          "device_token": deviceId,
          "device_type": Platform.isAndroid ? "android" : "ios",
        };
      } else {
        data = {
          "user_name": emailController.value.text,
          "otp": otpController.value.text,
          "device_token": deviceId,
          "device_type": Platform.isIOS ? "ios" : "android",
          "device": Platform.isAndroid ? "android" : "ios"
        };
      }
      try {
        await authProvider.authVerify(
          data,
          isSignUp: isSignUp.value,
          onError: (message, errorMap) {
            isOtpLoading.value = false;
            toastShow(message: message ?? "Please try again", error: true);
          },
          onSuccess: (message, data) async {
            logPrint("otp bhai aa jaa: onSuccess $data ");
            if (data != null) {
              logPrint("otp bhai aa jaa: onSuccess if ");
              isOtpLoading.value = false;
              // await Get.find<AuthService>().removeUserData();
              // await Get.find<AuthService>().removeToken();
              await Get.find<AuthService>().saveUser(data["data"]);
              await Get.find<AuthService>()
                  .saveUserToken(data["token"], deviceId);
              // if (data["data"]['language'] == null ||
              //     data["data"]['tags'] == null) {
              //   // Get.find<ProfileController>().getTags();
              //   Get.offAllNamed(Routes.selectPrefer);
              // } else {
              await Get.find<AuthService>().saveTrainingTooltips('buyNow');
              await Get.find<AuthService>().saveTrainingTooltips('applyCoupon');
              await Get.find<AuthService>()
                  .saveTrainingTooltips('joinLiveClass');
              await Get.find<AuthService>()
                  .saveTrainingTooltips('registerClass');
              await Get.find<AuthService>()
                  .saveTrainingTooltips('registerFirstFreeClass');
              await Get.find<AuthService>()
                  .saveTrainingTooltips('classRecordings');

              // final accessToken = Get.find<AuthService>().getUserToken();

              // try {
              //   print("SocketService from sign up ");
              //   Get.find<SocketService>().connect(
              //     userData: data['data'],
              //   );
              // } catch (e) {
              //   print(e);
              // }

              Get.offAllNamed(Routes.rootView, arguments: true);
              // }
            }
          },
        );
      } catch (e) {
        isOtpLoading.value = false;
        logPrint("otp bhai aa jaa: isotpLoading false");
      }
    } else {
      logPrint("otp bhai aa jaa: else ");
      if (otpController.value.text.length < 4) {
        toastShow(message: "Please enter otp");
      }
    }
  }
}
