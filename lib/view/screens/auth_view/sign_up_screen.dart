import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/screens/root_view/web_view/open_web_view.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/text_field_view/regex/regex.dart';

import '../../../model/services/auth_service.dart';
import '../../../model/utils/app_constants.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/string_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../view_model/controllers/auth_controllers/login_controller.dart';
import '../../../view_model/controllers/auth_controllers/sign_up_controller.dart';
import '../../../enum/routing/routes/app_pages.dart';
import '../../widgets/button_view/common_button.dart';
import '../../widgets/custome_checkBox/custome_chack_box.dart';
import '../../widgets/text_field_view/common_textfield.dart';
import '../base_view/base_view_screen.dart';
import '../root_view/courses_detail_view/course_detail_view.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthView(
      viewControl: SignUpController(),
      onPageBuilder: (BuildContext context, SignUpController controller) =>
          _buildLoginView(context, controller),
      leadingIcon: (context, controller) => Padding(
        padding:
            const EdgeInsets.only(top: DimensionResource.marginSizeExtraLarge),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            clipContainer("Skip", onTap: () async {
              await Get.find<AuthService>().saveUser({
                "name": StringResource.guestUserName,
                "profile_image": AppConstants.instance.guestUserProfile,
                "is_guest": true,
              });
              Get.offAllNamed(Routes.rootView);
            }),
          ],
        ),
      ),
      backgroundImage: ImageResource.instance.signUpBg,
    );
  }

  Widget _buildLoginView(BuildContext context, SignUpController controller) {
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
                  StringResource.signUpWith,
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
                  height: MediaQuery.of(context).size.height * .03,
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Form(
                        key: controller.signUpFormKey,
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CommonTextField(
                                label: "Name",
                                showEdit: false,
                                controller: controller.nameController.value,
                                hintText: StringResource.enterName,
                                keyboardType: TextInputType.name,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[A-Za-z ]"))
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    controller.nameError.value =
                                        "Please enter your name";
                                    return "";
                                  }
                                  // else if(!value.isValidEmail()){
                                  //   controller.emailError.value ="Please enter valid email address";
                                  //   return "";
                                  // }
                                  else {
                                    controller.nameError.value = "";
                                    return null;
                                  }
                                },
                                errorText: controller.nameError.value,
                              ),
                              CommonTextField(
                                label: "Email",
                                showEdit: false,
                                controller: controller.emailController.value,
                                hintText: StringResource.enterEmail,
                                inputFormatters: [
                                  FilteringTextInputFormatter.deny(
                                      RegExp(r'\s'))
                                ],
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    controller.emailError.value =
                                        "Please enter your email address";
                                    return "";
                                  } else if (!value.isValidEmail()) {
                                    controller.emailError.value =
                                        "Please enter valid email address";
                                    return "";
                                  } else {
                                    controller.emailError.value = "";
                                    return null;
                                  }
                                },
                                errorText: controller.emailError.value,
                              ),
                              CommonTextField(
                                label: "Email",
                                showEdit: false,
                                controller: controller.mobileController.value,
                                hintText: StringResource.enterMobile,
                                keyboardType: TextInputType.phone,
                                maxLength: 10,
                                inputFormatters: [
                                  FilteringTextInputFormatter.allow(
                                      RegExp("[0-9]")),
                                ],
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    controller.mobileError.value =
                                        "Please enter mobile number";
                                    return "";
                                  } else if (!value.isValidNumber()) {
                                    controller.mobileError.value =
                                        "Please enter valid mobile number";
                                    return "";
                                  } else {
                                    controller.mobileError.value = "";
                                    return null;
                                  }
                                },
                                errorText: controller.mobileError.value,
                              )
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: DimensionResource.marginSizeExtraSmall - 2,
                      ),
                      Obx(() {
                        return _buildPrivacyPolicyRow(controller,
                            errorText: controller.privacyError.value);
                      }),
                      const SizedBox(
                        height: 25,
                      ),
                      Obx(
                        () => CommonButton(
                          text: "Sign Up",
                          loading: controller.isLoading.value,
                          onPressed: controller.onSignUp,
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      dontHaveAccountRow(),
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
                              "or",
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
                        fromSignIn: false,
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
          Visibility(
              visible: Get.find<LoginController>().isSocialLoading.value,
              child: Container(
                  color: Colors.white.withOpacity(0.4),
                  child: const CommonCircularIndicator()))
        ],
      );
    });
  }

  Center dontHaveAccountRow() {
    return Center(
      child: Wrap(
        children: [
          Text(
            "Already have an account?",
            style: StyleResource.instance.styleLight(
                color: ColorResource.textColor_6,
                fontSize: DimensionResource.fontSizeDefault - 1),
          ),
          GestureDetector(
              onTap: () {
                Get.offAllNamed(Routes.loginScreen);
              },
              child: Text(
                " Sign In ",
                style: StyleResource.instance.styleSemiBold(
                    color: ColorResource.primaryColor,
                    fontSize: DimensionResource.fontSizeDefault - 1),
              )),
        ],
      ),
    );
  }

  Widget _buildPrivacyPolicyRow(SignUpController controller,
      {String? errorText}) {
    return GestureDetector(
      onTap: () =>
          controller.isRememberChek.value = !controller.isRememberChek.value,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                    "By signing up, you accept the",
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
}

class SocialSigningClass extends GetView<LoginController> {
  final bool fromSignIn;
  const SocialSigningClass({Key? key, required this.fromSignIn})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // _buildGoogleLoginRow(controller.handleGoogleSignIn,
          //     type: "google",
          //     image: ImageResource.instance.googleIcon,
          //     fromSignIn: fromSignIn,
          //     isLoading: controller.isGoogleLoading.value),
          // _buildGoogleLoginRow(controller.handleFacebookSignIn,
          //     type: "facebook",
          //     image: ImageResource.instance.facebookIcon,fromSignIn: fromSignIn,
          //     isLoading: controller.isFaceLoading.value
          // ),
          // Visibility(
          //   visible: Platform.isIOS,
          //   child: _buildGoogleLoginRow(controller.handleAppleSignIn,
          //       type: "apple",
          //       image: ImageResource.instance.appleIcon,
          //       fromSignIn: fromSignIn,
          //       isLoading: controller.isAppleLoading.value),
          // ),
        ],
      );
    });
  }

  Widget _buildGoogleLoginRow(Function() onTap,
      {required String type,
      required String image,
      required bool fromSignIn,
      required bool isLoading}) {
    return Card(
        elevation: 5,
        shadowColor: ColorResource.secondaryColor.withOpacity(0.2),
        margin:
            const EdgeInsets.only(bottom: DimensionResource.marginSizeLarge),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(DimensionResource.appDefaultRadius),
            side:
                const BorderSide(color: ColorResource.borderColor, width: 0.6)),
        color: ColorResource.white,
        child: SizedBox(
          height: 50,
          width: double.infinity,
          child: isLoading
              ? const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: CommonCircularIndicator(),
                )
              : MaterialButton(
                  onPressed: onTap,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          child: Image.asset(
                        image,
                        height: 20,
                      )),
                      Expanded(
                          flex: 9,
                          child: Center(
                              child: Text(
                            "Sign ${fromSignIn ? "In" : "Up"} with ${type.capitalize}",
                            style: StyleResource.instance.styleLight(
                                fontSize: DimensionResource.fontSizeDefault + 1,
                                color: ColorResource.textColor_6),
                          )))
                    ],
                  )),
        ));
  }
}
