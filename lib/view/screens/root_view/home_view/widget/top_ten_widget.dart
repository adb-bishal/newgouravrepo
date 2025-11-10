import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/scalps_widget.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../../../../model/utils/color_resource.dart';
import '../../../../../../../model/utils/dimensions_resource.dart';
import '../../../../../../../model/utils/image_resource.dart';
import '../../../../../../../model/utils/style_resource.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../../../model/services/auth_service.dart';
import '../../../../../model/utils/app_constants.dart';
import '../../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import '../../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../../enum/routing/routes/app_pages.dart';
import '../../../../widgets/view_helpers/small_button.dart';
import '../home_view_screen.dart';

class TopTenWidget extends StatelessWidget {
  final HomeDataModelDatum homeDataModelDatum;
  const TopTenWidget({Key? key, required this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(() {}, homeDataModelDatum.title ?? StringResource.topTen,
            showIcon: false, enableTopPadding: false),
        SizedBox(
          height: 145,
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            itemCount: homeDataModelDatum.data?.length ?? 0,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DatumDatum data = homeDataModelDatum.data!.elementAt(index);
              CourseWishlist courseWishlist;
              switch (data.typeId) {
                case 1:
                  courseWishlist = Get.find<RootViewController>()
                      .textCourseData
                      .firstWhere((p0) => p0.id?.value == (data.id),
                          orElse: () => CourseWishlist());
                  break;
                case 2:
                  courseWishlist = Get.find<RootViewController>()
                      .audioCourseData
                      .firstWhere((p0) => p0.id?.value == (data.id),
                          orElse: () => CourseWishlist());
                  break;
                default:
                  courseWishlist = Get.find<RootViewController>()
                      .videoCourseData
                      .firstWhere((p0) => p0.id?.value == (data.id),
                          orElse: () => CourseWishlist());
                  break;
              }
              return InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  //logPrint("dataa ${data.toJson()}");
                  switch (data.typeId) {
                    case 1:
                      Get.toNamed(
                              Routes.textCourseDetail(id: data.id.toString()),
                              arguments: [
                            data.category?.title,
                            data.id.toString()
                          ])!
                          .then((value) {
                        Get.find<HomeController>()
                            .getContinueLearning(isFirst: true);
                      });
                      break;
                    case 2:
                      Get.toNamed(
                              Routes.audioCourseDetail(id: data.id.toString()),
                              arguments: [
                            CourseDetailViewType.audioCourse,
                            data.id.toString(),
                            data.tagId.toString(),
                            data.courseTitle
                          ])!
                          .then((value) {
                        Get.find<HomeController>()
                            .getContinueLearning(isFirst: true);
                      });
                      break;
                    default:
                      AppConstants.instance.videoCourseId.value =
                          (data.id.toString());

                      Get.toNamed(
                              Routes.videoCourseDetail(id: data.id.toString()),
                              arguments: [
                            data.category?.title,
                            data.id.toString()
                          ])!
                          .then((value) {
                        Get.find<HomeController>()
                            .getContinueLearning(isFirst: true);
                      });
                      break;
                  }
                },
                child: Padding(
                  padding: EdgeInsets.only(
                      left: index != 0
                          ? DimensionResource.marginSizeExtraSmall + 1
                          : 0),
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 140,
                        width: 135,
                        child: Card(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin: const EdgeInsets.only(
                            left: DimensionResource.marginSizeSmall,
                            bottom: 4,
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Stack(
                            children: [
                              Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: cachedNetworkImage(
                                    data.thumbnail ?? data.image ?? '',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: ColorResource.black.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(10)),
                                padding: const EdgeInsets.only(
                                    top: DimensionResource.marginSizeSmall,
                                    left: DimensionResource.marginSizeSmall,
                                    bottom: DimensionResource.marginSizeSmall),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        StarContainer(
                                          rating: data.avgRating.toString(),
                                          fontColor:
                                              ColorResource.secondaryColor,
                                          bgColor: ColorResource.white,
                                        ),
                                        Visibility(
                                            visible: data.isFree != 1,
                                            child: const ProContainerButton())
                                      ],
                                    ),
                                    const SizedBox(
                                      height: DimensionResource.marginSizeSmall,
                                    ),
                                    Container(
                                        constraints: BoxConstraints(
                                            maxWidth: Get.width * 0.4),
                                        child: Text(
                                          data.courseTitle ?? data.title ?? "",
                                          style: StyleResource.instance
                                              .styleSemiBold(
                                                  fontSize: DimensionResource
                                                      .fontSizeSmall,
                                                  color: ColorResource.white),
                                        )),
                                    const Spacer(),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: DimensionResource
                                                  .marginSizeSmall),
                                          child: Obx(() {
                                            logPrint(
                                                "trending course ${courseWishlist.isWishList?.value}");
                                            logPrint(
                                                "trending type ${data.typeId}");
                                            return IconButtonLayout(
                                              onTap: () {
                                                Get.find<RootViewController>()
                                                    .saveToWatchLater(
                                                        id: data.id ?? 0,
                                                        type: data.typeId == 1
                                                            ? "course_text"
                                                            : data.typeId == 2
                                                                ? "course_audio"
                                                                : "course_video",
                                                        response:
                                                            (WishListSaveModel
                                                                wishListData) {
                                                          if (wishListData
                                                                  .data ??
                                                              false) {
                                                            data.isWishlist!
                                                                .value = 1;
                                                          } else {
                                                            data.isWishlist!
                                                                .value = 0;
                                                          }
                                                        });
                                              },
                                              secondImage: courseWishlist.id !=
                                                      null
                                                  ? courseWishlist.isWishList
                                                              ?.value ==
                                                          1
                                                      ? ImageResource.instance
                                                          .filledLikeIcon
                                                      : null
                                                  : data.isWishlist!.value == 1
                                                      ? ImageResource.instance
                                                          .filledLikeIcon
                                                      : null,
                                              image: ImageResource
                                                  .instance.likeIcon,
                                              iconSize: 9,
                                              iconColor: ColorResource.redColor,
                                            );
                                          })),
                                    )
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: -17,
                        child: Stack(
                          children: <Widget>[
                            Text(
                              '${index + 1}',
                              style: StyleResource.instance
                                  .styleSemiBold(fontSize: 62)
                                  .copyWith(
                                      foreground: Paint()
                                        ..style = PaintingStyle.stroke
                                        ..strokeWidth = 3.5
                                        ..color = ColorResource.primaryColor),
                            ),
                            // Solid text as fill.
                            Text(
                              '${index + 1}',
                              style: StyleResource.instance.styleSemiBold(
                                  fontSize: 62, color: ColorResource.white),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        )
      ],
    );
  }
}

class ProContainerButton extends StatelessWidget {
  final bool isCircle;
  final bool? isShow;
  const ProContainerButton({
    this.isCircle = false,
    this.isShow,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isShow ?? !Get.find<AuthService>().isPro.value,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(10),
                bottomLeft: const Radius.circular(10),
                topRight: Radius.circular(isCircle ? 10 : 0),
                bottomRight: Radius.circular(isCircle ? 10 : 0)),
            color: ColorResource.starColor),
        padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(ImageResource.instance.starIcon,
                height: 8, color: ColorResource.white),
            const SizedBox(
              width: 3,
            ),
            Text(
              "PRO",
              style: StyleResource.instance
                  .styleMedium(fontSize: 8, color: ColorResource.white),
            )
          ],
        ),
      ),
    );
  }
}

class FreeContainerButton extends StatelessWidget {
  final bool isCircle;
  final RxBool? isShow;
  const FreeContainerButton({
    this.isCircle = false,
    this.isShow,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();

    // Display FreeContainerButton only if userRole is 'trial_user'
    // final showFreeButton = authService.userRole.value == "trial_user";

    return Visibility(
      visible: isShow?.value ?? authService.isPro.value,
      child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(10),
                  bottomLeft: const Radius.circular(10),
                  topRight: Radius.circular(isCircle ? 10 : 0),
                  bottomRight: Radius.circular(isCircle ? 10 : 0)),
              color: ColorResource.greenColor),
          padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
          child: Padding(
            padding: const EdgeInsets.all(2.0),
            child: Text(
              "Included in Trial",
              style: StyleResource.instance
                  .styleMedium(fontSize: 8, color: ColorResource.white),
            ),
          )),
    );
  }
}

// class FreeContainerButton extends StatelessWidget {
//   final bool isCircle;
//   final RxBool? isShow;
//   const FreeContainerButton({
//     this.isCircle = false,
//     this.isShow,
//     Key? key,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final authService = Get.find<AuthService>();
//
//     // Display FreeContainerButton only if userRole is 'trial_user'
//     final showFreeButton = authService.userRole.value == "trial_user";
//
//     return Visibility(
//         visible: showFreeButton, // Hide if user is guest or pro
//       child: Obx(() {
//         final showStatus = isShow?.value ?? false; // Set a default value if null
//         // final displayText = showFreeButton
//         //     ? (showStatus ? "trial" : "pro") // Empty text if guest or pro
//         //     : "";
//
//         return Container(
//           // decoration: BoxDecoration(
//           //   borderRadius: BorderRadius.only(
//           //     topLeft: const Radius.circular(10),
//           //     bottomLeft: const Radius.circular(10),
//           //     topRight: Radius.circular(isCircle ? 10 : 0),
//           //     bottomRight: Radius.circular(isCircle ? 10 : 0),
//           //   ),
//           //   color: showStatus
//           //       ? ColorResource.accentYellowColor
//           //       : ColorResource.greenColor,
//           // ),
//           padding: const EdgeInsets.only(top: 1.5, bottom: 3, left: 5, right: 5),
//           child:
//           // Text(
//           //   displayText,
//           //   style: StyleResource.instance
//           //       .styleMedium(fontSize: 8, color: ColorResource.white),
//           // ),
//
//           showStatus
//               ?
//
//           Text("Free",style: TextStyle(
//               color: Colors.green
//           ),)
//
//           // Image.asset(
//           //   ImageResource.instance.starIcon,
//           //   height: 8,
//           //   color: ColorResource.white,
//           // )
//               :  ProContainerButton(
//             isCircle: true,
//           )
//           // Image.asset(
//           //   ImageResource.instance.proIcon,
//           //   height: 18,
//           //   color: ColorResource.primaryContainer,
//           // ),
//         );
//       })
//     );
//   }
// }
