import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_screen/no_data_screen.dart';
import 'package:stockpathshala_beta/view_model/controllers/profile_controller/profile_controller.dart';

import '../../../model/models/explore_all_category/all_category_model.dart'
    as category;
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/string_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../widgets/button_view/common_button.dart';
import '../../widgets/text_field_view/common_textfield.dart';
import '../base_view/base_view_screen.dart';

class SelectPreferScreen extends StatelessWidget {
  const SelectPreferScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AuthView(
      viewControl: ProfileController(),
      onPageBuilder: (BuildContext context, ProfileController controller) =>
          _buildLoginView(context, controller),
      backgroundImage: ImageResource.instance.signUpBg,
    );
  }

  Widget _buildLoginView(BuildContext context, ProfileController controller) {
    controller.getTags();
    return Container(
      height: Get.height - Get.height * 0.235,
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault),
      child: Obx(() {
        return
            // (controller.levelData.value.data?.isEmpty ?? true) ||
            (controller.tagsData.value.data?.isEmpty ?? true)
                ? const NoDataFoundScreen()
                : MediaQuery.removePadding(
                    context: context,
                    removeTop: true,
                    removeBottom: true,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      // shrinkWrap: true,
                      children: [
                        const SizedBox(
                          height: DimensionResource.marginSizeExtraLarge,
                        ),
                        // Text(
                        //   "Select Your Level",
                        //   style: StyleResource.instance.styleMedium(
                        //       fontSize: DimensionResource.fontSizeDefault),
                        // ),
                        // const SizedBox(
                        //   height: DimensionResource.marginSizeExtraSmall - 3,
                        // ),
                        // Text(
                        //   '(Only one level can be select at once)',
                        //   style: StyleResource.instance.styleLight(
                        //       fontSize: DimensionResource.fontSizeSmall - 1.4),
                        // ),
                        // const SizedBox(
                        //   height: DimensionResource.marginSizeDefault - 3,
                        // ),
                        // Obx(() {
                        //   return Row(
                        //     children: !controller.isLevelLoading.value
                        //         ? List.generate(
                        //             controller.levelData.value.data?.length ?? 0,
                        //             (index) {
                        //             level.Datum data = controller
                        //                     .levelData.value.data!
                        //                     .elementAt(index) ??
                        //                 level.Datum();
                        //             return Expanded(
                        //               child: Padding(
                        //                 padding: EdgeInsets.only(
                        //                     right: index !=
                        //                             (controller.levelData.value.data
                        //                                     ?.length ??
                        //                                 0 - 1)
                        //                         ? DimensionResource.marginSizeSmall
                        //                         : 0),
                        //                 child: buildSelectedContainer(() {
                        //                   controller.selectedLevel.value = data;
                        //                 },
                        //                     controller.selectedLevel.value.id ==
                        //                         data.id,
                        //                     data.level ?? ""),
                        //               ),
                        //             );
                        //           })
                        //         : List.generate(3, (index) {
                        //             return Shimmer.fromColors(
                        //               baseColor: Colors.grey[300]!,
                        //               highlightColor: Colors.grey[100]!,
                        //               enabled: true,
                        //               child: Container(
                        //                 height: 45,
                        //                 width: 100,
                        //                 margin: EdgeInsets.only(
                        //                     right: index != 2
                        //                         ? DimensionResource.marginSizeSmall
                        //                         : 0),
                        //                 decoration: BoxDecoration(
                        //                     color: Colors.white,
                        //                     borderRadius: BorderRadius.circular(6),
                        //                     border: Border.all(
                        //                         color: ColorResource.borderColor)),
                        //               ),
                        //             );
                        //           }),
                        //   );
                        // }),
                        // const SizedBox(
                        //   height: DimensionResource.marginSizeDefault + 2,
                        // ),

                        Text(
                          "Choice of Interest",
                          style: StyleResource.instance.styleMedium(
                              fontSize: DimensionResource.fontSizeDefault),
                        ),
                        const SizedBox(
                          height: DimensionResource.marginSizeExtraSmall - 3,
                        ),
                        Text(
                          '(Any no. of Interests can be Selected)',
                          style: StyleResource.instance.styleLight(
                              fontSize: DimensionResource.fontSizeSmall - 1.4),
                        ),
                        const SizedBox(
                          height: DimensionResource.marginSizeDefault,
                        ),
                        Obx(
                          () {
                            return Wrap(
                              runSpacing: DimensionResource.marginSizeSmall,
                              spacing: DimensionResource.marginSizeSmall,
                              children: !controller.isTagLoading.value
                                  ? List.generate(
                                      controller.tagsData.value.data?.length ??
                                          0, (index) {
                                      category.Datum data = controller
                                          .tagsData.value.data![index];
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          buildSelectedContainer(() {
                                            if (controller.selectedTags.any(
                                                (element) =>
                                                    element.id == data.id)) {
                                              controller.selectedTags
                                                  .removeWhere((element) =>
                                                      element.id == data.id);
                                            } else {
                                              controller.selectedTags.add(data);
                                            }
                                          },
                                              controller.selectedTags.any(
                                                  (element) =>
                                                      element.id == data.id),
                                              data.title ?? ""),
                                        ],
                                      );
                                    })
                                  : List.generate(
                                      3,
                                      (index) {
                                        return Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          enabled: true,
                                          child: Container(
                                            height: 40,
                                            width: 75,
                                            margin: EdgeInsets.only(
                                                right: index != 2
                                                    ? DimensionResource
                                                        .marginSizeSmall
                                                    : 0),
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(6),
                                                border: Border.all(
                                                    color: ColorResource
                                                        .borderColor)),
                                          ),
                                        );
                                      },
                                    ),
                            );
                          },
                        ),
                        const SizedBox(
                          height: DimensionResource.marginSizeDefault,
                        ),
                        Row(
                          children: [
                            Text(
                              "Date of Birth",
                              style: StyleResource.instance.styleMedium(
                                  fontSize: DimensionResource.fontSizeDefault),
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            Text(
                              '(Optional)',
                              style: StyleResource.instance.styleLight(
                                  fontSize:
                                      DimensionResource.fontSizeSmall - 1.4),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: DimensionResource.marginSizeSmall,
                        ),
                        Form(
                          key: controller.preferFormKey,
                          child: CommonTextField(
                            padding: const EdgeInsets.only(
                                top: DimensionResource.marginSizeDefault,
                                bottom: DimensionResource.marginSizeDefault,
                                left: DimensionResource.marginSizeSmall),
                            label: "dob",
                            isLabel: false,
                            readOnly: true,
                            onTap: () async {
                              await showDatePicker(
                                      context: context,
                                      initialDate: DateTime(
                                          DateTime.now().year - 8, 01, 01),
                                      firstDate: DateTime(1960),
                                      lastDate: DateTime(
                                          DateTime.now().year - 8, 12, 31))
                                  .then((value) {
                                if (value != null) {
                                  controller.dobController.value.text =
                                      DateFormat(StringResource.dobDateFormat)
                                          .format(value);
                                  controller.selectedDoB.value = value;
                                }
                              });
                            },
                            controller: controller.dobController.value,
                            hintText:
                                StringResource.dobDateFormat.toLowerCase(),
                            keyboardType: TextInputType.phone,
                            suffix: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                ImageResource.instance.dateIcon,
                                color: ColorResource.grey_1,
                                height: 8,
                              ),
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            // validator: (value){
                            //   if(value!.isEmpty){
                            //     controller.dobError.value = StringResource.emptyDobError;
                            //     return "";
                            //   }
                            //   else{
                            //     controller.dobError.value ="";
                            //     return null;
                            //   }
                            // },
                            errorText: controller.dobError.value,
                          ),
                        ),
                        const Spacer(),
                        // const SizedBox(
                        //   height: DimensionResource.marginSizeDefault,
                        // ),
                        Visibility(
                            visible: controller.selectedTags.isNotEmpty,
                            child: CommonButton(
                                text: "Submit",
                                loading: controller.isPrefLoading.value,
                                onPressed: controller.onSubmit)),
                        const SizedBox(
                          height: DimensionResource.marginSizeDefault,
                        ),
                      ],
                    ),
                  );
      }),
    );
  }
}

Widget buildSelectedContainer(
  Function() onTap,
  bool isSelected,
  String text,
) {
  return GestureDetector(
    onTap: onTap,
    child: SizedBox(
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isSmallScreen = constraints.maxWidth < 500; // Check screen width

          return Card(
            elevation: isSelected ? 1 : 0,
            margin: EdgeInsets.zero,
            color: isSelected ? ColorResource.primaryColor : Colors.transparent,
            clipBehavior: Clip.antiAliasWithSaveLayer,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                color: isSelected
                    ? ColorResource.primaryColor
                    : ColorResource.borderColor,
                width: .6,
              ),
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isSmallScreen
                    ? DimensionResource.marginSizeSmall // Adjust padding for small screens
                    : DimensionResource.marginSizeExtraSmall,
                vertical: DimensionResource.marginSizeSmall,
              ),
              child: Center(
                child: Row(
                  mainAxisSize: isSmallScreen
                      ? MainAxisSize.max // Adjust layout for small screens
                      : MainAxisSize.min,
                  children: [
                    if (isSelected)
                      Image.asset(
                        ImageResource.instance.checkIcon,
                        height: 14,
                        color: ColorResource.white,
                      ),
                    if (isSelected)
                      const SizedBox(
                        width: DimensionResource.marginSizeSmall - 5,
                      ),
                    Text(
                      text,
                      style: isSelected
                          ? StyleResource.instance.styleSemiBold(
                        fontSize: isSmallScreen
                            ? DimensionResource.marginSizeSmall - 2 // Adjust text size
                            : DimensionResource.marginSizeSmall+4,
                        color: ColorResource.white,
                      )
                          : StyleResource.instance.styleRegular(
                        fontSize: isSmallScreen
                            ? DimensionResource.marginSizeSmall - 2
                            : DimensionResource.marginSizeSmall,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    ),
  );

  // return GestureDetector(
  //   onTap: onTap,
  //   child: SizedBox(
  //     child: Card(
  //       elevation: isSelected ? 1 : 0,
  //       margin: EdgeInsets.zero,
  //       color: isSelected ? ColorResource.primaryColor : Colors.transparent,
  //       //  margin: EdgeInsets.only(right: index.isEven?DimensionResource.marginSizeDefault:0,left: index.isOdd?DimensionResource.marginSizeDefault:0,bottom: DimensionResource.marginSizeLarge),
  //       clipBehavior: Clip.antiAliasWithSaveLayer,
  //       shape: RoundedRectangleBorder(
  //           borderRadius: BorderRadius.circular(6),
  //           side: BorderSide(
  //               color: isSelected
  //                   ? ColorResource.primaryColor
  //                   : ColorResource.borderColor,
  //               width: .6)),
  //       child: Padding(
  //         padding:  EdgeInsets.symmetric(
  //             horizontal: DimensionResource.marginSizeExtraSmall,
  //             vertical: DimensionResource.marginSizeSmall),
  //         child: Center(
  //           child: Row(
  //             mainAxisSize: MainAxisSize.min,
  //             children: [
  //               Visibility(
  //                   visible: isSelected,
  //                   child: Image.asset(
  //                     ImageResource.instance.checkIcon,
  //                     height: 14,
  //                     color: ColorResource.white,
  //                   )),
  //               Visibility(
  //                 visible: isSelected,
  //                 child: const SizedBox(
  //                   width: DimensionResource.marginSizeSmall - 5,
  //                 ),
  //               ),
  //               Text(
  //                 text,
  //                 style: isSelected
  //                     ? StyleResource.instance.styleSemiBold(
  //                         fontSize: DimensionResource.marginSizeSmall,
  //                         color: ColorResource.white)
  //                     : StyleResource.instance.styleRegular(
  //                         fontSize: DimensionResource.marginSizeSmall,
  //                       ),
  //                 maxLines: 1,
  //                 overflow: TextOverflow.ellipsis,
  //               ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   ),
  // );
}
