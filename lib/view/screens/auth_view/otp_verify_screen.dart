import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pin_code_text_field/pin_code_text_field.dart';
import 'package:sms_autofill/sms_autofill.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../view_model/controllers/auth_controllers/sign_up_controller.dart';
import '../base_view/base_view_screen.dart';

class OtpVerifyScreen extends StatefulWidget {
  const OtpVerifyScreen({Key? key}) : super(key: key);

  @override
  State<OtpVerifyScreen> createState() => _OtpVerifyScreenState();
}

class _OtpVerifyScreenState extends State<OtpVerifyScreen> with CodeAutoFill {
  final SignUpController controller = Get.put(SignUpController());

  @override
  void initState() {
    super.initState();
    listenForCode();
  }

  @override
  void codeUpdated() {
    if (code != null && code!.length == 4) {
      controller.otpController.value.text = code!;
      controller.onSubmitOtp();
    }
  }

  @override
  void dispose() {
    cancel(); // stop listening to code
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AuthView(
      viewControl: controller,
      onPageBuilder: (BuildContext context, SignUpController controller) =>
          _buildOtpView(context, controller),
      backgroundImage: ImageResource.instance.signUpBg,
    );
  }

  Widget _buildOtpView(BuildContext context, SignUpController controller) {
    return SingleChildScrollView(
      child: Column(
        children: [
          const SizedBox(height: DimensionResource.marginSizeExtraLarge),
          Image.asset(
            ImageResource.instance.otpImage,
            height: Get.height * 0.2,
          ),
          const SizedBox(height: DimensionResource.marginSizeOverExtraLarge - 5),
          Text(
            StringResource.enter4Digit,
            style: StyleResource.instance
                .styleLight(color: ColorResource.textColor_6),
            textAlign: TextAlign.center,
          ),
          Text(
            controller.emailController.value.text,
            style: StyleResource.instance
                .styleSemiBold(color: ColorResource.textColor_6),
            textAlign: TextAlign.center,
          ),
          Visibility(
            visible: controller.mobileController.value.text.isNotEmpty,
            child: Text(
              controller.mobileController.value.text,
              style: StyleResource.instance
                  .styleSemiBold(color: ColorResource.textColor_6),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(
            height: controller.mobileController.value.text.isNotEmpty
                ? DimensionResource.marginSizeExtraLarge + 5
                : DimensionResource.marginSizeExtraLarge + 20,
          ),
          PinCodeTextField(
            wrapAlignment: WrapAlignment.spaceEvenly,
            controller: controller.otpController.value,
            pinBoxOuterPadding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeSmall),
            isCupertino: true,
            autofocus: false,
            hideCharacter: false,
            highlight: true,
            highlightPinBoxColor: ColorResource.white,
            defaultBorderColor: ColorResource.borderColor,
            hasTextBorderColor: ColorResource.borderColor,
            maxLength: 4,
            pinBoxBorderWidth: 1,
            pinBoxRadius: 7,
            pinBoxWidth: 45,
            pinBoxHeight: 45,
            hasUnderline: false,
            pinBoxDecoration: (
                Color borderColor,
                Color pinBoxColor, {
                  double borderWidth = 2.0,
                  double radius = 5.0,
                }) {
              return BoxDecoration(
                border: Border.all(color: borderColor, width: borderWidth),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: borderColor.withOpacity(0.3),
                    offset: const Offset(4, 4),
                    blurRadius: 10.0,
                  ),
                ],
                color: pinBoxColor,
                borderRadius: BorderRadius.circular(radius),
              );
            },
            onTextChanged: (value) {},
            pinTextStyle: StyleResource.instance.styleRegular(
              fontSize: DimensionResource.fontSizeLarge,
              color: ColorResource.textColor_5,
            ),
            pinTextAnimatedSwitcherTransition:
            ProvidedPinBoxTextAnimation.defaultNoTransition,
            pinTextAnimatedSwitcherDuration: const Duration(milliseconds: 300),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: DimensionResource.marginSizeExtraLarge),
          Obx(() {
            return controller.isResend.value
                ? Text(
              "00:30",
              style: StyleResource.instance.styleSemiBold(
                color: ColorResource.primaryColor,
                fontSize:
                DimensionResource.fontSizeDoubleExtraLarge - 2,
              ),
              textAlign: TextAlign.center,
            )
                : controller.isTimeUp.value
                ? TextButton(
              onPressed: controller.resendOtp,
              child: Text(
                StringResource.resendCode,
                style: StyleResource.instance.styleMedium(
                  color: ColorResource.primaryColor,
                  fontSize: DimensionResource.fontSizeSmall,
                ),
              ),
            )
                : TweenAnimationBuilder<Duration>(
              duration:
              Duration(seconds: controller.second.value),
              tween: Tween(
                  begin: Duration(seconds: controller.second.value),
                  end: Duration.zero),
              onEnd: () {
                controller.isTimeUp.value = true;
              },
              builder: (BuildContext context, Duration value,
                  Widget? child) {
                final minutes = value.inMinutes
                    .remainder(60)
                    .toString()
                    .padLeft(2, '0');
                final seconds = value.inSeconds
                    .remainder(60)
                    .toString()
                    .padLeft(2, '0');
                return Text(
                  "$minutes:$seconds",
                  style: StyleResource.instance.styleSemiBold(
                    color: ColorResource.primaryColor,
                    fontSize:
                    DimensionResource.fontSizeDoubleExtraLarge -
                        2,
                  ),
                  textAlign: TextAlign.center,
                );
              },
            );
          }),
          const SizedBox(height: DimensionResource.marginSizeExtraLarge),
          Obx(() {
            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault,
              ),
              child: CommonButton(
                text: StringResource.verifyAndProcess,
                loading: controller.isOtpLoading.value,
                onPressed: controller.onSubmitOtp,
              ),
            );
          }),
          const SizedBox(height: DimensionResource.marginSizeLarge),
        ],
      ),
    );
  }
}
