import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:account_picker/account_picker.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_html/flutter_html.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:mobile_number/mobile_number.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sms_autofill/sms_autofill.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:stockpathshala_beta/model/models/auth_models/login_page_data_model.dart';
import 'package:stockpathshala_beta/model/utils/helper_util.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/sign_up_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/profile_controller/profile_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
// import 'package:truecaller_sdk/truecaller_sdk.dart';
import '../../../model/models/popup_model/pop_up_model.dart';
import '../../../model/network_calls/api_helper/provider_helper/auth_provider.dart';
import '../../../model/network_calls/api_helper/provider_helper/root_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../model/services/auth_service.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../view/widgets/button_view/animated_box.dart';
import '../../../view/widgets/button_view/common_button.dart';
import '../../../view/widgets/log_print/log_print_condition.dart';
import '../../../view/widgets/popup_view/my_dialog.dart';
import '../../../view/widgets/text_field_view/common_textfield.dart';
import '../../../view/widgets/toast_view/showtoast.dart';
import '../../routes/app_pages.dart';

class LoginController extends GetxController {
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> mobileFormKey = GlobalKey<FormState>();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();

  // final RootViewController rootController = Get.find<RootViewController>();

  // final GoogleSignIn _googleSignIn = GoogleSignIn(
  //   scopes: [
  //     'email',
  //   ],
  // );
  AuthProvider authProvider = getIt();
  late StreamSubscription _streamSubscription;

  //TextEditingController emailController = TextEditingController();  // Ensure initialization
  // RxString emailError = ''.obs;

  RxBool isTruecallerAvailable = false.obs;
  var payload = Rx<String?>(null);
  var signature = Rx<String?>(null);
  var emailError = "".obs;
  var mobileError = "".obs;
  var passwordError = "".obs;
  var otpError = "".obs;
  RxBool isRememberChek = true.obs;
  RxBool isEmailKeyboard = false.obs;
  RxBool isHint = true.obs;
  RxBool isLoading = false.obs;
  RxBool isPageLoading = true.obs;
  RxBool isMobileVerify = false.obs;
  RxBool isMobileLoading = false.obs;
  RxBool isGoogleLoading = false.obs;
  RxBool isAppleLoading = false.obs;
  RxBool isSocialLoading = false.obs;
  RxBool isFaceLoading = false.obs;

  RxBool isTrial = false.obs;
  static RxMap<String, String> promptData = <String, String>{}.obs;
  static RxMap<String, String> bgData = <String, String>{}.obs;
  RootProvider rootProvider = getIt();
  RxBool isPromptDataLoading = true.obs;

  // Initialize Truecaller callback

  Rx<LoginPageDataModel> loginPageData = LoginPageDataModel().obs;

  String _result = 'Unknown';
  //final _phoneNumberHintPlugin = PhoneNumberHint();

  final confettiController =
      ConfettiController(duration: const Duration(seconds: 10));

  LoginController() {
    if (LoginController.promptData.isEmpty && LoginController.bgData.isEmpty) {
      _initializeLoginPromptData();
    }
  }

  logInTap() async {
    // print('asdcasdc ${Get.find<SignUpController>().hashKey}');

    if (signInFormKey.currentState!.validate() && isLoading.value == false) {
      String hashKey = await SmsAutoFill().getAppSignature;
      print('sdvsdv $hashKey');
      isLoading.value = true;

      try {
        await authProvider.signInTap({
          "user_name": emailController.text,
          "hash_code": hashKey,
          "device": Platform.isIOS ? "ios" : "android"
        }, onError: (message, errorMap) {
          if (errorMap?.isEmpty ?? false) {
            toastShow(message: 'Check your internet connection', error: true);
          }
          if (errorMap?.isNotEmpty ?? false) {
            errorMap?.forEach((key, value) {
              if (key == "otp") {
                if (value.isNotEmpty) {
                  emailError.value = value.first;
                }
              }
            });
          }
          isLoading.value = false;
        }, onSuccess: (message, data) async {
          Get.find<AuthService>().removeToken();
          if (data != null) {
            isLoading.value = false;
            Get.toNamed(Routes.otpScreen, arguments: emailController.text);
            toastShow(message: message);
          }
        });
      } catch (e) {
        logPrint("Login error: $e");
        isLoading.value = false;
      }
    } else {}
  }

  Future<void> _initializeLoginPromptData() async {
    isPromptDataLoading.value = true;
    try {
      await rootProvider.getPopUpData(
        onError: (e, m) {
          logPrint("Error initializing promptData: $e, $m");
        },
        onSuccess: (message, json) {
          PopUpModel popUpModel = PopUpModel.fromJson(json!);
          // isTrial.value = popUpModel.isTrial == 0 ? false : true;
          LoginController.promptData.value =
              Map<String, String>.from(popUpModel.trialPromptData);
          LoginController.bgData.value =
              Map<String, String>.from(popUpModel.backgroundData);
          logPrint("promptData set: $bgData");
          logPrint("promptData set: $promptData");
        },
      );
    } catch (error) {
      logPrint("Unexpected error in _initializePromptData: $error");
    } finally {
      isPromptDataLoading.value = false;
    }
  }

  void trailOnTap(hasName, isFirst, [bool? isTrialSheet]) async {
    isLoading.value = true;
    try {
      await authProvider.updateUserDataForAppTap(
          signInBody: hasName ? {"name": emailController.text} : null,
          onError: (message, errorMap) {
            logPrint("error");
            if (errorMap?.isEmpty ?? false) {
              emailError.value = message ?? "";
            }
            if (errorMap?.isNotEmpty ?? false) {
              errorMap?.forEach((key, value) {
                if (key == "otp") {
                  if (value.isNotEmpty) {
                    emailError.value = value.first;
                  }
                }
              });
            }
            isLoading.value = false;
          },
          onSuccess: (message, data) async {
            if (data != null) {
              isLoading.value = true;
              // Get.toNamed(Routes.otpScreen, arguments: emailController.text);
              // Get.find<AuthService>().isPro.value = true;
              // Get.find<AuthService>().user.value.name = emailController.text;

              Get.find<AuthService>().getCurrentUserData();
              Get.find<ProfileController>().getCurrentUserData();

              Get.find<RootViewController>().getProfile();

              if (isTrialSheet == true) {
                Get.find<RootViewController>().joinOnTap(
                    Get.find<RootViewController>().emailController.text);
              }

              Get.find<RootViewController>().getProfile();

              // Get.back();

              // if (isFirst) {
              //   logPrint("clicked123");

              //   // Access promptData from RootViewController
              //   // var trialPromptData = promptData;
              //   // logPrint("Trial Prompt Data in LoginController: $trialPromptData");
              //   print("lkjfsdkjkljkljlkj ${LoginController.promptData}");

              //   if (LoginController.promptData != null) {
              //     await showSucessDialog(
              //       // Get.find<RootViewController>().popUpModel.value?.trialPromptData ?? {},
              //       LoginController.promptData,

              //       // days,
              //       // days == 1
              //       //     ? "Trial Activated for $days Day!"
              //       //     : "Trial Activated for $days Days!",
              //       Get.find<AuthService>().user.value.name == null,
              //       LoginController.bgData,
              //     );
              //   }
              // } else {
              //   emailController.text = "Enter your name";
              //   Get.back();
              // }
            }
            // isLoading.value = false;
          });
    } catch (e) {
      logPrint("Login error: $e");
      isLoading.value = false;
    }
  }

  showSucessDialog(
    Map<String, String> trialPromptData,
    hasName,
    Map<String, String> backgroundData,
  ) {
    // Retrieve each prompt field from the trialPromptData map
    logPrint("-------mytrialPromptData is :::: " + trialPromptData.toString());
    final promptTitle =
        (trialPromptData['title'] ?? '').replaceAll(r'\n', '\n');
    final promptTitleColor = trialPromptData['titleColor'] ?? '#000000';
    final promptDescription =
        (trialPromptData['description'] ?? '').replaceAll(r'\n', '\n');
    final promptDescriptionColor =
        trialPromptData['descriptionColor'] ?? '#000000';
    final confirmButtonText =
        trialPromptData['confirmButtonText'] ?? 'Start Learning';
    final confirmButtonColor =
        trialPromptData['confirmButtonColor'] ?? '#000000';
    final confirmButtonTextColor =
        trialPromptData['confirmButtonTextColor'] ?? '#ffffff';
    final promptNameInputPlaceholder =
        trialPromptData['userNameInputPlaceholder'] ?? 'Your Name please';
    final promptImage_url = trialPromptData['image_url'] ?? '';
    final bgType = backgroundData['bgType'] ?? '';
    final bgColor = backgroundData['bgColor'] ?? "#ffffff";
    final bgImage = backgroundData['bgImage'] ?? '';

    emailController.text = promptNameInputPlaceholder;
    isLoading.value = false;

    // Set a timer to prevent closing the BottomSheet until the confetti animation completes
    bool animationCompleted = false;
    Timer(const Duration(seconds: 10), () {
      animationCompleted = true;
      // Dispose of the confetti controller when the animation completes
      confettiController.stop();
    });

    Get.bottomSheet(
      WillPopScope(
        onWillPop: () async => animationCompleted,
        child: Stack(
          children: [
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: bgType == 'color'
                    ? Color(int.parse(bgColor.replaceFirst('#', '0xff')))
                    : Colors.transparent,
                image: bgType == 'image'
                    ? DecorationImage(
                        image: NetworkImage(bgImage),
                        fit: BoxFit.cover,
                      )
                    : null,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25.0),
                  topRight: Radius.circular(25.0),
                ),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const SizedBox(height: 16),
                    // Display the image from promptImage_url
                    promptImage_url.isNotEmpty
                        ? Image.network(
                            promptImage_url,
                            height: 100,
                            errorBuilder: (context, error, stackTrace) {
                              return const Icon(Icons.image_not_supported,
                                  size: 100);
                            },
                          )
                        : Image.asset(
                            ImageResource.instance.successIcon,
                            height: 100,
                          ),
                    const SizedBox(height: 20),
                    Text(
                      promptTitle,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        color: Color(int.parse(
                            promptTitleColor.replaceAll('#', '0xff'))),
                      ),
                    ),
                    Get.find<AuthService>().user.value.name == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8.0, vertical: 2),
                            child: Html(
                              data: promptDescription,
                              style: {
                                'body': Style(
                                  textAlign: TextAlign.center,
                                  color: Color(int.parse(promptDescriptionColor
                                      .replaceAll('#', '0xff'))),
                                  fontSize: FontSize(14),
                                ),
                              },
                            ),
                          )
                        : Container(),
                    const SizedBox(height: 16),
                    Get.find<AuthService>().user.value.name == null
                        ? Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12, vertical: 0),
                            child: Obx(
                              () => Form(
                                key: signInFormKey,
                                child: CommonTextField(
                                  showEdit: false,
                                  isTrailPopUp: true,
                                  readOnly: isLoading.value,
                                  onTap: () {
                                    emailController.text = "";
                                  },
                                  isLogin: false,
                                  isHint: true,
                                  controller: emailController,
                                  keyboardType: TextInputType.text,
                                  validator: (value) {
                                    if (value == promptNameInputPlaceholder) {
                                      emailError.value =
                                          StringResource.nameInvalidError;
                                      return "";
                                    } else if (value!.length <= 3) {
                                      emailError.value =
                                          StringResource.nameInvalidError;
                                      return "";
                                    } else {
                                      emailError.value = "";
                                      return null;
                                    }
                                  },
                                  errorText: emailError.value,
                                ),
                              ),
                            ),
                          )
                        : Container(),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15.0, top: 5),
                      child: SizedBox(
                        width: Get.width * 0.8,
                        height: Get.width * 0.1,
                        child: Obx(() => CommonButton(
                            color: Color(int.parse(
                                confirmButtonColor.replaceAll('#', '0xff'))),
                            text: confirmButtonText,
                            textColor: Color(int.parse(confirmButtonTextColor
                                .replaceAll('#', '0xff'))),
                            loading: isLoading.value,
                            onPressed: () {
                              if (hasName) {
                                if (signInFormKey.currentState!.validate() &&
                                    isLoading.value == false) {
                                  confettiController.play();
                                  trailOnTap(true, false);
                                } else {}
                              } else {
                                Get.back();
                              }
                            })),
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
            Positioned.fill(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: confettiController,
                  blastDirectionality: BlastDirectionality.explosive,
                  numberOfParticles: 50,
                  shouldLoop: false,
                  colors: [
                    Colors.blue,
                    Colors.red,
                    Colors.green,
                    Colors.yellow
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5), // Optional
      isDismissible: true, // Optional
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ), // Optional
      enableDrag: true, // Optional
    );
  }

  // showSucessDialog(message, hasName) {
  //   showDialog(
  //       context: Get.context!,
  //       builder: (BuildContext context) {
  //         return WillPopScope(
  //           onWillPop: (() async => false),
  //           child: Dialog(
  //               backgroundColor: Colors.white,
  //               shape: RoundedRectangleBorder(
  //                 borderRadius: BorderRadius.circular(16.0),
  //               ),
  //               child: SizedBox(
  //                 height: Get.height / 2.25,
  //                 child: Column(
  //                   children: [
  //                     const SizedBox(
  //                       height: 16,
  //                     ),
  //                     Image.asset(
  //                       ImageResource.instance.successIcon,
  //                       height: 100,
  //                     ),
  //                     const Text(
  //                       "Trial Activated for 2 Days!",
  //                       style: TextStyle(
  //                           fontSize: 18, fontWeight: FontWeight.w500),
  //                     ),
  //                     Padding(
  //                       padding: const EdgeInsets.symmetric(
  //                         horizontal: 8.0,
  //                         vertical: 2,
  //                       ),
  //                       child: Text(
  //                         "Fill Your Name below to Start Learning:",
  //                         textAlign: TextAlign.center,
  //                         style: TextStyle(
  //                           fontSize: 14,
  //                         ),
  //                       ),
  //                     ),
  //                     const SizedBox(
  //                       height: 16,
  //                     ),
  //                     Get.find<AuthService>().user.value.name == null
  //                         ? Padding(
  //                             padding: const EdgeInsets.symmetric(
  //                                 horizontal: 12, vertical: 0),
  //                             child: Obx(
  //                               () => Form(
  //                                 key: signInFormKey,
  //                                 child: CommonTextField(
  //                                   showEdit: false,
  //                                   isTrailPopUp: true,
  //                                   readOnly: isLoading.value,
  //                                   onTap: () {
  //                                     clearController();
  //                                   },
  //                                   isLogin: false,
  //                                   isHint: false,
  //                                   controller: emailController,
  //                                   keyboardType: TextInputType.text,
  //                                   validator: (value) {
  //                                     if (value == " Your Name Please") {
  //                                       emailError.value =
  //                                           StringResource.nameInvalidError;
  //                                       return "";
  //                                     } else if (value!.length <= 3) {
  //                                       emailError.value =
  //                                           StringResource.nameInvalidError;
  //                                       return "";
  //                                     } else {
  //                                       emailError.value = "";
  //                                       return null;
  //                                     }
  //                                   },
  //                                   errorText: emailError.value,
  //                                 ),
  //                               ),
  //                             ),
  //                           )
  //                         : Container(),
  //                     Container(
  //                       width: 120,
  //                       height: 35,
  //                       child: CommonButton(
  //                           color: ColorResource.primaryColor,
  //                           text: 'Explore',
  //                           loading: false,
  //                           onPressed: () {
  //                             if (hasName) {
  //                               if (signInFormKey.currentState!.validate() &&
  //                                   isLoading.value == false) {
  //                                 Get.find<AuthService>().user.value.name =
  //                                     emailController.text;
  //                                 trailOnTap(true, false);
  //                                 emailController.text = "";
  //                                 Get.find<AuthService>().isPro.value = true;
  //                                 Get.back();
  //                               } else {}
  //                             } else {
  //                               Get.back();
  //                             }
  //                           }),
  //                     )
  //                   ],
  //                 ),
  //               )),
  //         );
  //       },
  //       barrierDismissible: false);
  // }

  Future<void> getLoginDetails() async {
    await authProvider.getLoginDetails(onError: (message, errorMap) {
      toastShow(
        message: message,
      );
    }, onSuccess: (message, json) {
      loginPageData.value = LoginPageDataModel.fromJson(json!);
      isPageLoading.value = false;
      HelperUtil.checkForUpdate();
      // subscriptionDescriptionData.value.description!
      //     .removeWhere((item) => item == null);
    });
  }

  @override
  void onInit() {
    // TruecallerSdk.initializeSDK(
    //   sdkOptions: TruecallerSdkScope.SDK_OPTION_WITH_OTP,
    // );

    //  initializeTruecaller();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.onInit();

    // getTruecallerData();

    // _streamSubscription = TruecallerSdk.streamCallbackData.listen((truecallerSdkCallback) {
    //   switch (truecallerSdkCallback.result) {
    //     case TruecallerSdkCallbackResult.success:
    //       print("First Name: ${truecallerSdkCallback.profile?.firstName}");
    //       print("Last Name: ${truecallerSdkCallback.profile?.lastName}");
    //
    //       print("payload ${truecallerSdkCallback.profile?.payload}");
    //       break;
    //     case TruecallerSdkCallbackResult.failure:
    //       print("Error code: ${truecallerSdkCallback.error?.code}");
    //       print("Error message: ${truecallerSdkCallback.error?.message}");
    //       break;
    //     case TruecallerSdkCallbackResult.verification:
    //       print("Verification Required!!");
    //       break;
    //     default:
    //       print("Invalid result");
    //   }
    // });

    //emailController.text = "Enter phone number";
    getLoginDetails();
  }
  // Future<void> getTruecallerData() async {
  //   try {
  //     // Fetch Truecaller data
  //     Map<String, String> truecallerData = await TruecallerService().getTruecallerData();
  //     // Assign the payload and signature values
  //     payload.value = truecallerData['payload'];
  //     signature.value = truecallerData['signature'];
  //
  //
  //     print("payload value: ${payload.value}");
  //     print("signature value: ${signature.value}");
  //
  //     // Optionally send payload and signature to your backend
  //     if (payload.value != null && signature.value != null) {
  //       // Uncomment the line below to send data to the backend
  //        sendPayloadAndSignatureToBackend(payload.value!, signature.value!);
  //     }
  //   } catch (e) {
  //     print("Error: $e");
  //   }
  // }
  // Future<void> sendPayloadAndSignatureToBackend(String payload, String signature) async {
  //   // Send the payload and signature to your backend for verification
  //   print("Payload: $payload, Signature: $signature");
  // }

//

  /// Initialize the Truecaller SDK and add listeners

  clearController() {
    if (emailController.text == "Enter phone number" ||
        emailController.text == "Enter email address" ||
        emailController.text == "Enter your name" ||
        emailController.text == "Your Name Please") {
      emailController.text = "";
      isHint.value = false;
    }
  }

  setEmailToController(isEmail) {
    emailController.text =
        isEmail ? "Enter email address" : "Enter phone number";
  }

  onSocialSignIn({required Map<String, dynamic> firebaseData}) async {
    //showReferByDialog();
    logPrint("i am in login");

    isSocialLoading.value = true;
    String deviceId = await Get.find<AuthService>().getDeviceToken() ?? "";
    await authProvider.socialLogin({
      "firebase_id": firebaseData['firebase_id'],
      "device_token": deviceId,
      "device_type": Platform.isIOS ? "ios" : "android",
      "email": firebaseData['email'],
      "name": firebaseData['name']
    }, onError: (message, errorMap) {
      isMobileLoading.value = false;
      isSocialLoading.value = false;
      toastShow(message: message ?? "Please try again", error: true);
      logPrint("login error => $message");
    }, onSuccess: (message, data) async {
      logPrint("jhhg ${data?['token']}");
      if (data != null && data.isNotEmpty) {
        if (data['data']["mobile_no"] == null) {
          //Get.toNamed(Routes.otpScreen,arguments: emailController.text);

          showReferByDialog(firebaseData: firebaseData);
          isSocialLoading.value = false;
          //isLoading.value = false;
        } else {
          // await Get.find<AuthService>().removeUserData();
          // await Get.find<AuthService>().removeToken();
          await Get.find<AuthService>().saveUser(data["data"] ?? {});
          await Get.find<AuthService>()
              .saveUserToken(data["token"] ?? "", deviceId);
          if (data["data"]['language'] == null) {
            // Get.find<ProfileController>().getTags();
            Get.offAllNamed(Routes.selectPrefer);
          } else if (data["data"]['level'] == null ||
              data["data"]['tags'] == null) {
            // Get.find<ProfileController>().getTags();
            Get.offAllNamed(Routes.selectPrefer);
          } else {
            await Get.find<AuthService>().saveTrainingTooltips('buyNow');
            await Get.find<AuthService>().saveTrainingTooltips('applyCoupon');
            await Get.find<AuthService>().saveTrainingTooltips('joinLiveClass');
            await Get.find<AuthService>().saveTrainingTooltips('registerClass');
            await Get.find<AuthService>()
                .saveTrainingTooltips('registerFirstFreeClass');
            await Get.find<AuthService>()
                .saveTrainingTooltips('classRecordings');
            Get.offAllNamed(Routes.rootView);
          }

          isMobileLoading.value = false;
          isSocialLoading.value = false;
        }
      }
      isMobileLoading.value = false;
    });
  }

  onSocialLoginNumber({required Map<String, dynamic> firebaseData}) async {
    isMobileLoading.value = true;
    mobileError.value = "";
    await authProvider.socialLoginNumber({
      "mobile_no": mobileController.value.text,
      "firebase_id": firebaseData['firebase_id']
    }, onError: (message, errorMap) {
      isMobileLoading.value = false;
      isSocialLoading.value = false;
      //toastShow(message: message??"Please try again",error: true);
      mobileError.value = message ?? "";
      logPrint("login error => $message");
    }, onSuccess: (message, data) async {
      isMobileVerify.value = true;
      isMobileLoading.value = false;
    });
  }

  socialLoginVerify({required Map<String, dynamic> firebaseData}) async {
    isMobileLoading.value = true;
    String deviceId = await Get.find<AuthService>().getDeviceToken() ?? "";
    await authProvider.socialLoginVerify({
      "mobile_no": mobileController.text,
      "firebase_id": firebaseData['firebase_id'],
      "name": firebaseData['name'],
      "email": firebaseData['email'],
      "otp": otpController.text,
      "device_token": deviceId,
      "device_type": Platform.isIOS ? "ios" : "android"
    }, onError: (message, errorMap) {
      isLoading.value = false;
      isMobileLoading.value = false;
      isSocialLoading.value = false;
      //toastShow(message: message??"Please try again",error: true);
      otpError.value = message ?? "";
      logPrint("login error => $message");
    }, onSuccess: (message, data) async {
      // await Get.find<AuthService>().removeUserData();
      // await Get.find<AuthService>().removeToken();

      isSocialLoading.value = false;
      await Get.find<AuthService>().saveUser(data?["data"] ?? {});
      await Get.find<AuthService>()
          .saveUserToken(data?["token"] ?? "", deviceId);
      // if (data?["data"]['language'] == null) {
      //   Get.offAllNamed(Routes.selectLanguage);
      // } else
      if (data?["data"]['level'] == null) {
        Get.offAllNamed(Routes.selectPrefer);
      } else {
        await Get.find<AuthService>().saveTrainingTooltips('buyNow');
        await Get.find<AuthService>().saveTrainingTooltips('applyCoupon');
        await Get.find<AuthService>().saveTrainingTooltips('joinLiveClass');
        await Get.find<AuthService>().saveTrainingTooltips('registerClass');
        await Get.find<AuthService>()
            .saveTrainingTooltips('registerFirstFreeClass');
        await Get.find<AuthService>().saveTrainingTooltips('classRecordings');
        Get.offAllNamed(Routes.rootView);
      }
      isMobileLoading.value = false;
    });
  }

  showReferByDialog({required Map<String, dynamic> firebaseData}) {
    return showAnimatedDialog(
        Get.context!,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          description:
              "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary.",
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {},
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter your mobile number",
                  style: StyleResource.instance.styleSemiBold(),
                ),
                Image.asset(
                  ImageResource.instance.referNEarnPOPBG,
                  height: 180,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: DimensionResource.marginSizeDefault),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: mobileFormKey,
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextField(
                            readOnly: isMobileVerify.value,
                            showEdit: false,
                            label: "",
                            controller: mobileController,
                            hintText: StringResource.enterMobile,
                            keyboardType: TextInputType.phone,
                            maxLength: 10,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                mobileError.value =
                                    StringResource.emptyPhoneError;
                                return "";
                              } else {
                                mobileError.value = "";
                                return null;
                              }
                            },
                            errorText: mobileError.value,
                          ),
                          Visibility(
                            visible: isMobileVerify.value,
                            child: CommonTextField(
                              showEdit: false,
                              label: "",
                              controller: otpController,
                              hintText: StringResource.enterOtpF,
                              keyboardType: TextInputType.text,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  otpError.value = StringResource.enterOtp;
                                  return "";
                                } else {
                                  otpError.value = "";
                                  return null;
                                }
                              },
                              errorText: otpError.value,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  return CommonButton(
                    text: StringResource.submit,
                    onPressed: () {
                      if (mobileFormKey.currentState?.validate() ?? false) {
                        if (isMobileVerify.value) {
                          socialLoginVerify(firebaseData: firebaseData);
                        } else {
                          onSocialLoginNumber(firebaseData: firebaseData);
                        }
                      }
                    },
                    loading: isMobileLoading.value,
                  );
                }),
                TextButton(
                    onPressed: () {
                      Get.back();
                      isMobileVerify.value = false;
                      mobileController.clear();
                      otpController.clear();
                      mobileError.value = "";
                      otpError.value = "";
                      isSocialLoading.value = false;
                    },
                    child: Text(
                      StringResource.cancel,
                      style: StyleResource.instance
                          .styleSemiBold(color: ColorResource.primaryColor),
                    ))
              ],
            ),
          ),
        ),
        dismissible: false,
        isFlip: true);
  }

  // Future<void> handleGoogleSignIn() async {
  //   Map<String, dynamic> firebaseData = {};
  //   isGoogleLoading.value = true;
  //   try {
  //     await _googleSignIn.signIn().then((value) async {
  //       if (value != null) {
  //         GoogleSignInAuthentication authentication =
  //             await value.authentication;
  //         logPrint(
  //             "valaue ${authentication.idToken},   ${value.email}   , ${value.displayName}");
  //         firebaseData = {
  //           "firebase_id": value.id,
  //           "email": value.email,
  //           "name": value.displayName ?? ""
  //         };
  //         onSocialSignIn(firebaseData: firebaseData);
  //         isGoogleLoading.value = false;
  //       } else {
  //         toastShow(
  //           message: "Sign In Canceled",
  //         );
  //         isGoogleLoading.value = false;
  //       }
  //     });
  //   } catch (error) {
  //     toastShow(message: error.toString());
  //     isGoogleLoading.value = false;
  //   }
  // }

  // Future<void> handleFacebookSignIn() async {
  //   isFaceLoading.value = true;
  //   await FacebookAuth.instance.login().then((value) {
  //     logPrint(
  //         "this si facebook value ${value.message} & ${value.status.name} & ${value.accessToken?.userId}  & ${value.accessToken?.toJson()}");
  //     if (value.accessToken?.userId != null) {
  //       Map<String, dynamic> firebaseData = {};
  //       firebaseData = {
  //         "firebase_id": value.accessToken?.userId,
  //         "email": "",
  //         "name": ""
  //       };
  //       onSocialSignIn(firebaseData: firebaseData);
  //       isFaceLoading.value = false;
  //     } else {
  //       toastShow(message: "Something went wrong");
  //       isFaceLoading.value = false;
  //     }
  //   });
  // }

  // Future<void> handleAppleSignIn() async {
  //   isAppleLoading.value = true;
  //   final credential = await SignInWithApple.getAppleIDCredential(
  //     scopes: [
  //       AppleIDAuthorizationScopes.email,
  //       AppleIDAuthorizationScopes.fullName,
  //     ],
  //   );
  //   if (credential.identityToken != null) {
  //     Map<String, dynamic> firebaseData = {
  //       "firebase_id": credential.userIdentifier,
  //       "email": credential.email ?? "",
  //       "name": credential.givenName ?? ""
  //     };
  //     onSocialSignIn(firebaseData: firebaseData);
  //     isAppleLoading.value = false;
  //   } else {
  //     toastShow(message: "Something went wrong");
  //     isAppleLoading.value = false;
  //   }
  // }
}

class TruecallerService {
  Future<Map<String, String>> getTruecallerData() async {
    // Mocking the service call (replace with actual logic for fetching data)
    await Future.delayed(Duration(seconds: 2));

    // Return mock data for the payload and signature
    return {
      'payload': 'sample_payload_data',
      'signature': 'sample_signature_data',
    };
  }
}
