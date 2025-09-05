import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/widget_controllers/ask_for_rating_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/widget_controllers/show_rating_controller.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../widgets/button_view/common_button.dart';
import '../../../widgets/rating_bar/rating_bar.dart';
import '../../../widgets/text_field_view/notes_text_field.dart';

class AddAskRatingWidget extends StatelessWidget {
  // final CourseDatum courseDatum;
  const AddAskRatingWidget({
    Key? key,
    //  this.courseDatum
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AskForRatingController askForRatingController =
        Get.put(AskForRatingController());

    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          Obx(() {
            return Container(
                constraints: BoxConstraints(maxWidth: Get.width * 0.65),
                child: Text(
                  // "titile",
                  askForRatingController.askForRatingData.value.title ?? '',
                  style: StyleResource.instance.styleMedium(
                      fontSize: DimensionResource.fontSizeLarge - 1,
                      color: ColorResource.white),
                  textAlign: TextAlign.center,
                ));
          }),

          SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Obx(() {
            return Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.65),
              child: Text(
                askForRatingController.askForRatingData.value.subtitle ?? '',
                style: StyleResource.instance.styleLight(
                    fontSize: DimensionResource.fontSizeDefault - 2,
                    color: ColorResource.white.withOpacity(0.8)),
                textAlign: TextAlign.center,
              ),
            );
          }),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Obx(() {
            return StarRating(
              size: 25,
              rating: askForRatingController.rating.value,
              onRatingChanged: askForRatingController.onRatingChange,
            );
          }),

          const SizedBox(
            height: DimensionResource.marginSizeLarge,
          ),
          Form(
            key: askForRatingController.formKey.value,
            child: Obx(() {
              return NotesTextFormField(
                // inputFormatters: const [
                //   FilteringTextInputFormatter.allow(RegExp("[A-Za-z 0-9.]"))
                // ],
                errorText: askForRatingController.feedbackError.value,
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    askForRatingController.feedbackError.value =
                        StringResource.feedbackEmptyError;
                    return "";
                  } else if (!(val?.contains(RegExp(r'[A-Za-z]')) ?? false)) {
                    askForRatingController.feedbackError.value =
                        StringResource.feedbackCorrectError;
                    return "";
                  } else {
                    askForRatingController.feedbackError.value = "";
                    return null;
                  }
                },
                color: ColorResource.lightBlack,
                hintText: "Enter Your Feedback here",
                controller: askForRatingController.feedbackController,
                isMarginEnable: false,
              );
            }),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          // Obx(() {
          //   return
          CommonButton(
            text: "SUBMIT REVIEW",
            loading: askForRatingController.isPostLoading.value,
            onPressed: () {
              if (askForRatingController.formKey.value.currentState
                      ?.validate() ??
                  false) {
                askForRatingController.postRating(
                    type: "live_class",
                    id: askForRatingController
                        .askForRatingData.value.liveClassId
                        .toString());
              } else {
                logPrint('sdfsdf ');
              }
            },
            color: ColorResource.primaryColor,
            // );
            // }
          ),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
        ],
      ),
    );
  }
}

// class CourseDatum {
//   final String? name;
//   final String? rating;
//   CourseDatum({this.name, this.rating});
// }
