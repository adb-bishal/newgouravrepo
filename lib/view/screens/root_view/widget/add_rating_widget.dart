import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/widget_controllers/show_rating_controller.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../widgets/button_view/common_button.dart';
import '../../../widgets/rating_bar/rating_bar.dart';
import '../../../widgets/text_field_view/notes_text_field.dart';

class AddRatingWidget extends GetView<ShowRatingController> {
  final CourseDatum courseDatum;
  const AddRatingWidget({Key? key, required this.courseDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          Container(
              constraints: BoxConstraints(maxWidth: Get.width * 0.65),
              child: Text(
                courseDatum.name ?? "",
                style: StyleResource.instance.styleMedium(
                    fontSize: DimensionResource.fontSizeLarge - 1,
                    color: ColorResource.white),
                textAlign: TextAlign.center,
              )),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Obx(() {
            return StarRating(
              size: 25,
              rating: controller.rating.value,
              onRatingChanged: controller.onRatingChange,
            );
          }),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Text(
            "Your feedback would help us to improve Stock Pathshala Content for You.",
            style: StyleResource.instance.styleLight(
                fontSize: DimensionResource.fontSizeDefault - 2,
                color: ColorResource.white.withOpacity(0.8)),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimensionResource.marginSizeLarge,
          ),
          Form(
            key: controller.formKey.value,
            child: Obx(() {
              return NotesTextFormField(
                inputFormatters: const [
                  //FilteringTextInputFormatter.allow(RegExp("[A-Za-z 0-9.]"))
                ],
                errorText: controller.feedbackError.value,
                validator: (val) {
                  if (val?.isEmpty ?? true) {
                    controller.feedbackError.value =
                        StringResource.feedbackEmptyError;
                    return "";
                  } else if (!(val?.contains(RegExp(r'[A-Za-z]')) ?? false)) {
                    controller.feedbackError.value =
                        StringResource.feedbackCorrectError;
                    return "";
                  } else {
                    controller.feedbackError.value = "";
                    return null;
                  }
                },
                color: ColorResource.lightBlack,
                hintText: "Enter Your Feedback here",
                controller: controller.feedbackController,
                isMarginEnable: false,
              );
            }),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Obx(() {
            return CommonButton(
              text: "SUBMIT REVIEW",
              loading: controller.isPostLoading.value,
              onPressed: () {
                if (controller.formKey.value.currentState?.validate() ??
                    false) {
                  controller.postRating(
                      type: courseDatum.type ?? "", id: courseDatum.id ?? "");
                } else {
                  logPrint('sdfsdf ');
                }
              },
              color: ColorResource.primaryColor,
            );
          }),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
        ],
      ),
    );
  }
}

class CourseDatum {
  final String? name;
  final String? id;
  final String? type;
  final String? rating;

  CourseDatum({this.name, this.id, this.type, this.rating});
}
