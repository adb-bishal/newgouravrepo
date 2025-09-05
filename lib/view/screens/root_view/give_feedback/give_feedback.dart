import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/text_field_view/common_textfield.dart';
import 'package:stockpathshala_beta/view/widgets/text_field_view/notes_text_field.dart';
import 'package:stockpathshala_beta/view/widgets/text_field_view/regex/regex.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view_model/controllers/root_view_controller/feedback_controller/feedback_controller.dart';
import '../../../widgets/button_view/icon_button.dart';
import '../../base_view/base_view_screen.dart';

class FeedbackScreen extends StatelessWidget {
  const FeedbackScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthView(
      leadingIcon: (BuildContext context, FeedbackController controller) {
        return SizedBox(
            width: 40,
            height: 40,
            child: ActionCustomButton(
              icon: ImageResource.instance.closeIcon,
              isLeft: false,
              padding: DimensionResource.marginSizeDefault,
              iconColor: ColorResource.white,
              onTap: () {
                Get.back();
              },
            ));
      },
      viewControl: FeedbackController(),
      onPageBuilder: (BuildContext context, FeedbackController controller) =>
          _buildLoginView(context, controller),
      backgroundImage: ImageResource.instance.signUpBg,
    );
  }

  Widget _buildLoginView(BuildContext context, FeedbackController controller) {
    final screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      height: MediaQuery.of(context).size.height - (MediaQuery.of(context).size.height * .237),
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
        child: Column(
          children: [
             SizedBox(
              height:screenWidth<500? DimensionResource.marginSizeExtraLarge:DimensionResource.marginSizeExtraLarge+20,
            ),
            Center(
                child: Text(
              "Hey ${Get.find<AuthService>().user.value.name.toString().capitalize}, Please Share Your Feedback.",
              style:screenWidth<500? StyleResource.instance.styleSemiBold(color: ColorResource.primaryColor):StyleResource.instance.styleSemiBoldFeedbackTab(color: ColorResource.primaryColor),
            )),
            const SizedBox(
              height: DimensionResource.marginSizeExtraSmall - 2,
            ),
            Center(
                child: Text(
              '"We would love to improve for you!"',
              style: StyleResource.instance.styleLight(
                color: ColorResource.lightTextColor,
                fontSize: screenWidth<500? DimensionResource.fontSizeExtraSmall:DimensionResource.fontSizeDefault,
              ),
            )),
             SizedBox(
              height:screenWidth<500? DimensionResource.marginSizeExtraLarge:DimensionResource.marginSizeExtraLarge+20,
            ),
            Form(
              key: controller.feedbackFormKey,
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CommonTextField(
                      readOnly: Get.find<AuthService>().user.value.name != null && Get.find<AuthService>().user.value.name != StringResource.guestUserName,
                      label: "Name",
                      controller: controller.nameController.value,
                      hintText: StringResource.enterName,
                      keyboardType: TextInputType.name,
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp("[A-Za-z ]"))
                      ],
                      validator: (value) {
                        if (value!.isEmpty) {
                          controller.nameError.value = "Please enter your name";
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
                      readOnly: Get.find<AuthService>().user.value.email != null,
                      label: "Email",
                      controller: controller.emailController.value,
                      hintText: StringResource.enterEmail,
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
                    NotesTextFormField(
                      cursorColor: ColorResource.textColor_6,
                      style: StyleResource.instance.styleLight(fontSize:screenWidth<500? DimensionResource.fontSizeSmall:DimensionResource.fontSizeLarge,color: ColorResource.textColor_6),
                      isMarginEnable: false,
                      controller: controller.feedBackController.value,
                      hintText: "Enter your feedback here!",
                      validator: (value) {
                        if (value!.isEmpty) {
                          controller.feedBackError.value =
                          "Please enter feedback";
                          return "";
                        } else {
                          controller.feedBackError.value = "";
                          return null;
                        }
                      },
                      errorText: controller.feedBackError.value,
                      border: Border.all(color: ColorResource.borderColor, width:0.6),
                    ),
                     SizedBox(
                      height:screenWidth<500? DimensionResource.marginSizeExtraSmall:DimensionResource.marginSizeLarge,
                    ),
                    CommonButton(text: "SUBMIT FEEDBACK", loading: controller.isPostLoading.value, onPressed: controller.postFeedback),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
