import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/hex_color.dart';
import 'package:stockpathshala_beta/view/screens/auth_view/sign_up_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/web_view/open_web_view.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/custome_checkBox/custome_chack_box.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/sign_up_controller.dart';

// import 'package:truecaller_sdk/truecaller_sdk.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/string_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../view_model/controllers/auth_controllers/login_controller.dart';
import '../../../view_model/routes/app_pages.dart';
import '../../widgets/button_view/common_button.dart';
import '../../widgets/text_field_view/common_textfield.dart';
import '../../widgets/text_field_view/common_textfield_login.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    LoginController controller = Get.isRegistered<LoginController>()
        ? Get.find<LoginController>()
        : Get.put<LoginController>(LoginController());

    return SafeArea(
      child: Scaffold(
        backgroundColor: ColorResource.white,
        body: Obx(
          () => controller.isPageLoading.value
              ? const Center(
                  child: CircularProgressIndicator(),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Obx(() => SizedBox(
                                height: Get.height / 2.7,
                                width: Get.width,
                                child: Image.network(
                                  controller.loginPageData.value.image ?? "",
                                  fit: BoxFit.fitWidth,
                                ),
                              )),
                          Padding(
                            padding: const EdgeInsets.only(
                                top: DimensionResource.marginSizeExtraLarge),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                InkWell(
                                  onTap: () async {
                                    await Get.find<AuthService>().saveUser({
                                      "name": StringResource.guestUserName,
                                      "profile_image": AppConstants
                                          .instance.guestUserProfile,
                                      "is_guest": true,
                                    });
                                    Get.offAllNamed(Routes.rootView);
                                  },
                                  child: Card(
                                    margin: EdgeInsets.zero,
                                    color: ColorResource.secondaryColor
                                        .withOpacity(0.1),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal:
                                              DimensionResource.marginSizeSmall,
                                          vertical: DimensionResource
                                              .marginSizeExtraSmall),
                                      child: Text(
                                        "Skip",
                                        style: StyleResource.instance
                                            .styleMedium(
                                                color: ColorResource.white,
                                                fontSize: DimensionResource
                                                    .fontSizeSmall),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 24,
                                ),
                                // clipContainer("Skip", onTap: () async {
                                //
                                // }),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      SizedBox(
                        width: Get.width / 1.5,
                        child: Obx(() => Text(
                              controller.loginPageData.value.promotionalText ??
                                  "",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: HexColor(controller.loginPageData.value
                                          .promotionalTextColor ??
                                      "#000000"),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20),
                            )),
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.3,
                            width: Get.width * 0.20,
                            decoration: BoxDecoration(
                              color:
                                  ColorResource.borderColor.withOpacity(0.25),
                              // border: Border.all(color:ColorResource.borderColor, )
                            ),
                          ),
                          const Text(
                            '  Log in or sign up  ',
                            style: TextStyle(),
                          ),
                          Container(
                            height: 1.3,
                            width: Get.width * 0.20,
                            decoration: BoxDecoration(
                              color:
                                  ColorResource.borderColor.withOpacity(0.25),
                              // border: Border.all(color:ColorResource.borderColor, )
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 0),
                        child: Form(
                          key: controller.signInFormKey,
                          child: Obx(
                            () => CommonTextFieldLogin(
                              showEdit: false,
                              onTap: () async {
                                // await controller
                                //     .getPhoneNumber(); // Fetch the phone number on tap
                                controller
                                    .clearController(); // Clear the controller after fetching
                              },
                              isLogin: !controller.isEmailKeyboard.value,
                              isSpace: true,
                              label: "Enter Phone Number",
                              isHint: controller.isHint.value,
                              readOnly: controller.isLoading.value,
                              controller: controller.emailController,
                              // Bind the controller
                              inputFormatters: [
                                FilteringTextInputFormatter.deny(RegExp(r'\s')),
                              ],
                              keyboardType: controller.isEmailKeyboard.value
                                  ? TextInputType.emailAddress
                                  : TextInputType.phone,
                              validator: (value) {
                                if ((value!.isEmpty ||
                                        value.length < 5 ||
                                        !value.contains("@") ||
                                        !value.contains(".") ||
                                        value == "Enter email address") &&
                                    controller.isEmailKeyboard.value) {
                                  controller.emailError.value =
                                      StringResource.emailInvalidError;
                                  return "";
                                } else if ((value.isEmpty ||
                                            value == "Enter phone number") &&
                                        !controller.isEmailKeyboard.value ||
                                    (value.isNum && value.length != 10)) {
                                  controller.emailError.value =
                                      StringResource.mobileInvalidError;
                                  return "";
                                } else {
                                  controller.emailError.value = "";
                                  return null;
                                }
                              },
                              errorText: controller.emailError.value,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 14, right: 12, top: 12, bottom: 12),
                        child: Obx(() {
                          return _buildPrivacyPolicyRow(SignUpController(),
                              errorText: SignUpController().privacyError.value);
                        }),
                      ),
                      Obx(
                        () => Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: CommonButton(
                            text:
                                controller.loginPageData.value.buttonText ?? "",
                            loading: controller.isLoading.value,
                            onPressed: controller.logInTap,
                            color: HexColor(controller
                                    .loginPageData.value.buttonBackColor ??
                                "#000000"),
                            textColor: HexColor(
                                controller.loginPageData.value.buttonColor ??
                                    "#ffffff"),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 8,
                      ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     Container(
                      //       height: 1.3,
                      //       width: Get.width * 0.4,
                      //       decoration: BoxDecoration(
                      //         color:
                      //             ColorResource.borderColor.withOpacity(0.25),
                      //         // border: Border.all(color:ColorResource.borderColor, )
                      //       ),
                      //     ),
                      //     SizedBox(
                      //       child: Text(
                      //         StringResource.or,
                      //         style: StyleResource.instance.styleRegular(
                      //             color: ColorResource.borderColor),
                      //       ),
                      //     ),
                      //     Container(
                      //       height: 1.3,
                      //       width: Get.width * 0.4,
                      //       decoration: BoxDecoration(
                      //         color:
                      //             ColorResource.borderColor.withOpacity(0.25),
                      //         // border: Border.all(color:ColorResource.borderColor, )
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      // const SizedBox(
                      //   height: 4,
                      // ),
                      // Row(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //     GestureDetector(
                      //       onTap: () {
                      //         controller.handleGoogleSignIn();
                      //       },
                      //       child: CircleAvatar(
                      //           radius: 22,
                      //           backgroundColor: ColorResource.grey_2,
                      //           child: CircleAvatar(
                      //             radius: 21,
                      //             backgroundColor: ColorResource.white,
                      //             child: Image.asset(
                      //               ImageResource.instance.googleIcon,
                      //               height: 18,
                      //             ),
                      //           )),
                      //     ),
                      //     const SizedBox(
                      //       width: 36,
                      //     ),
                      //     GestureDetector(
                      //       onTap: () {
                      //         if (controller.isEmailKeyboard.value) {
                      //           controller.setEmailToController(false);
                      //           controller.isEmailKeyboard.value = false;
                      //         } else {
                      //           controller.setEmailToController(true);
                      //           controller.isEmailKeyboard.value = true;
                      //         }
                      //       },
                      //       child: CircleAvatar(
                      //           radius: 22,
                      //           backgroundColor: ColorResource.grey_2,
                      //           child: CircleAvatar(
                      //             radius: 21,
                      //             backgroundColor: ColorResource.white,
                      //             child: Image.asset(
                      //               controller.isEmailKeyboard.value
                      //                   ? ImageResource.instance.phoneCallIcon
                      //                   : ImageResource.instance.emailIcon,
                      //               height: 18,
                      //             ),
                      //           )),
                      //     ),
                      //   ],
                      // ),
                    ],
                  ),
                ),
        ),
      ),
    );
    // Prev code
    // AuthView(
    //   viewControl: LoginController(),
    //   onPageBuilder: (BuildContext context, LoginController controller) =>
    //       _buildLoginView(context, controller),
    //   backgroundImage: ImageResource.instance.loginBg,
    // );
  }

  Widget _buildPrivacyPolicyRow(SignUpController controller,
      {String? errorText}) {
    return GestureDetector(
      onTap: () =>
          controller.isRememberChek.value = !controller.isRememberChek.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => Padding(
                  padding: const EdgeInsets.only(top: 3.0),
                  child: CustomCheckBox(
                    onTap: null,
                    value: controller.isRememberChek.value,
                  ),
                ),
              ),
              const SizedBox(
                width: 4,
              ),
              Expanded(
                  child: Wrap(
                children: [
                  Text(
                    "By sign in/sign up, you accept the",
                    style: StyleResource.instance.styleLight(
                        color: ColorResource.textColor_6,
                        fontSize: DimensionResource.fontSizeDefault - 1),
                  ),
                  GestureDetector(
                      onTap: () {
                        Navigator.of(Get.context!).push(MaterialPageRoute(
                            builder: (context) => OpenWebView(
                                url: AppConstants.instance.privacyUrl,
                                title: StringResource.privacyPolicy)));
                      },
                      child: Text(
                        " Privacy Policy ",
                        style: StyleResource.instance.styleSemiBold(
                            color: ColorResource.primaryColor,
                            fontSize: DimensionResource.fontSizeDefault - 1),
                      )),
                  Text(
                    "of the app.",
                    style: StyleResource.instance.styleLight(
                        color: ColorResource.textColor_6,
                        fontSize: DimensionResource.fontSizeDefault - 1),
                  )
                ],
              ))
            ],
          ),
          errorText == null || errorText == ""
              ? const SizedBox(
                  height: 0,
                )
              : Padding(
                  padding: const EdgeInsets.only(
                      left: 0, right: 0, top: 2, bottom: 3),
                  child: Text(
                    errorText.capitalize ?? "",
                    style: StyleResource.instance.styleRegular(
                        color: ColorResource.errorColor,
                        fontSize: DimensionResource.fontSizeExtraSmall),
                    textAlign: TextAlign.start,
                  ),
                ),
        ],
      ),
    );
  }

  // Future<void> initializeTruecaller() async {
  //   try {
  //     bool isUsable = await TruecallerSdk.isUsable;
  //
  //     if (isUsable) {
  //       TruecallerSdk.getProfile(); // Get the profile when Truecaller is usable
  //     } else {
  //       print("***Not usable***");
  //     }
  //   } catch (e) {
  //     print("Error initializing Truecaller: $e");
  //   }
  // }

  Widget _buildLoginView(BuildContext context, LoginController controller) {
    return Obx(() {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(
                  height: DimensionResource.marginSizeExtraLarge,
                ),
                Center(
                    child: Text(
                  StringResource.welcomeTo,
                  style: StyleResource.instance
                      .styleSemiBold(color: ColorResource.primaryColor),
                )),
                const SizedBox(
                  height: DimensionResource.marginSizeExtraSmall - 2,
                ),
                Center(
                  child: Text(
                    StringResource.instance.appName,
                    style: StyleResource.instance
                        .styleBold(
                            fontSize: DimensionResource.fontSizeOverExtraLarge)
                        .copyWith(shadows: <Shadow>[
                      Shadow(
                        offset: const Offset(-2.0, 3.0),
                        blurRadius: 2.0,
                        color:
                            ColorResource.lightSecondaryColor.withOpacity(0.3),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: controller.signInFormKey,
                        child: Obx(
                          () => CommonTextField(
                            showEdit: false,
                            label: "Email",
                            readOnly: controller.isLoading.value,
                            controller: controller.emailController,
                            hintText: StringResource.emailOrMobile,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s'))
                            ],
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                controller.emailError.value =
                                    StringResource.emailInvalidError;
                                return "";
                              } else if (value.isNum && value.length != 10) {
                                controller.emailError.value =
                                    StringResource.mobileInvalidError;
                                return "";
                              } else if (value.length < 5) {
                                controller.emailError.value =
                                    StringResource.emailInvalidError;
                                return "";
                              } else {
                                controller.emailError.value = "";
                                return null;
                              }
                            },
                            errorText: controller.emailError.value,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => CommonButton(
                          text: StringResource.signIn,
                          loading: controller.isLoading.value,
                          onPressed: controller.logInTap,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      dontHaveAccountRow(controller),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.3,
                            width: Get.width * 0.25,
                            decoration: BoxDecoration(
                              color:
                                  ColorResource.borderColor.withOpacity(0.25),
                              // border: Border.all(color:ColorResource.borderColor, )
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color:
                                    ColorResource.borderColor.withOpacity(0.25),
                                shape: BoxShape.circle),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              StringResource.or,
                              style: StyleResource.instance.styleRegular(
                                  color: ColorResource.borderColor),
                            ),
                          ),
                          Container(
                            height: 1.3,
                            width: Get.width * 0.25,
                            decoration: BoxDecoration(
                              color:
                                  ColorResource.borderColor.withOpacity(0.25),
                              // border: Border.all(color:ColorResource.borderColor, )
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SocialSigningClass(
                        fromSignIn: true,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
              visible: controller.isSocialLoading.value,
              child: Container(
                  color: Colors.white.withOpacity(0.4),
                  child: const CommonCircularIndicator()))
        ],
      );
    });
  }

  Widget _loginView(BuildContext context, LoginController controller) {
    return Obx(() {
      return Stack(
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    StringResource.instance.appName,
                    style: StyleResource.instance
                        .styleBold(
                            fontSize: DimensionResource.fontSizeOverExtraLarge)
                        .copyWith(shadows: <Shadow>[
                      Shadow(
                        offset: const Offset(-2.0, 3.0),
                        blurRadius: 2.0,
                        color:
                            ColorResource.lightSecondaryColor.withOpacity(0.3),
                      ),
                    ]),
                  ),
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * .01,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        //autovalidateMode: AutovalidateMode.onUserInteraction,
                        key: controller.signInFormKey,
                        child: Obx(
                          () => CommonTextField(
                            showEdit: false,
                            label: "Email",
                            readOnly: controller.isLoading.value,
                            controller: controller.emailController,
                            hintText: StringResource.emailOrMobile,
                            inputFormatters: [
                              FilteringTextInputFormatter.deny(RegExp(r'\s'))
                            ],
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value!.isEmpty) {
                                controller.emailError.value =
                                    StringResource.emailInvalidError;
                                return "";
                              } else if (value.isNum && value.length != 10) {
                                controller.emailError.value =
                                    StringResource.mobileInvalidError;
                                return "";
                              } else if (value.length < 5) {
                                controller.emailError.value =
                                    StringResource.emailInvalidError;
                                return "";
                              } else {
                                controller.emailError.value = "";
                                return null;
                              }
                            },
                            errorText: controller.emailError.value,
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Obx(
                        () => CommonButton(
                          text: StringResource.signIn,
                          loading: controller.isLoading.value,
                          onPressed: controller.logInTap,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      dontHaveAccountRow(controller),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 1.3,
                            width: Get.width * 0.25,
                            decoration: BoxDecoration(
                              color:
                                  ColorResource.borderColor.withOpacity(0.25),
                              // border: Border.all(color:ColorResource.borderColor, )
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color:
                                    ColorResource.borderColor.withOpacity(0.25),
                                shape: BoxShape.circle),
                            padding: const EdgeInsets.all(8),
                            child: Text(
                              StringResource.or,
                              style: StyleResource.instance.styleRegular(
                                  color: ColorResource.borderColor),
                            ),
                          ),
                          Container(
                            height: 1.3,
                            width: Get.width * 0.25,
                            decoration: BoxDecoration(
                              color:
                                  ColorResource.borderColor.withOpacity(0.25),
                              // border: Border.all(color:ColorResource.borderColor, )
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const SocialSigningClass(
                        fromSignIn: true,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
              visible: controller.isSocialLoading.value,
              child: Container(
                  color: Colors.white.withOpacity(0.4),
                  child: const CommonCircularIndicator()))
        ],
      );
    });
  }

  Center dontHaveAccountRow(LoginController controller) {
    return Center(
      child: Wrap(
        children: [
          Text(
            StringResource.dontHaveAccount,
            style: StyleResource.instance.styleLight(
                color: ColorResource.textColor_6,
                fontSize: DimensionResource.fontSizeDefault - 1),
          ),
          GestureDetector(
              onTap: () {
                Get.toNamed(Routes.signUpScreen);
                controller.emailController.clear();
              },
              child: Text(
                " ${StringResource.signUp} ",
                style: StyleResource.instance.styleSemiBold(
                    color: ColorResource.primaryColor,
                    fontSize: DimensionResource.fontSizeDefault - 1),
              )),
        ],
      ),
    );
  }
}
