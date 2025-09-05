import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:stockpathshala_beta/model/models/common_container_model/common_container_model.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/blogs_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/filter_view/filter_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/text_course_detail_view/text_course_detail_view.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import '../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../widgets/bottom_sheet.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/log_print/log_print_condition.dart';
import '../../../widgets/search_widget/search_container.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';
import '../home_view/widget/audio_course_widget.dart';
import '../home_view/widget/scalps_widget.dart';
import '../home_view/widget/video_course_widget.dart';
import '../home_view/widget/videos_widget.dart';

class CourseDetailView extends StatelessWidget {
  const CourseDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      isTag: true,
      onAppBarTitleBuilder: (context, controller) => Obx(() {
        return TitleBarCentered(
          titleText: controller.categoryType.value,
        );
      }),
      onActionBuilder: (context, controller) => [
        InkWell(
            onTap: () {
              BottomSheetCommon(
                      child: Obx(() {
                        return LiveFilterScreen(
                          listOFSelectedCat: const [],
                          listOfSelectedTeacher: const [],
                          listOFSelectedDuration: const [],

                          selectedSubscription: controller.selectedSub.value,
                          listOFSelectedLang: const [],
                          listOFSelectedRating: controller.selectedRating,
                          listOFSelectedLevel: const [],
                          isPastFilter: false,
                          isHideCategory: true,
                          title: controller.viewType.value ==
                                  CourseDetailViewType.blogs
                              ? StringResource.blogsFilter
                              : StringResource.courseLevel,
                          isHideLanguage: true,
                          isHideLevel: true,
                          isHideTime: true,
                          isHideSubscription: false,
                          onApply: (val) {
                            logPrint("val $val");
                            controller.selectedRating.value = val['rating'];
                            controller.selectedSub.value = val['is_free'];
                            controller.getWidgetData(
                              1,
                              "",
                              rating: controller.selectedRating
                                  .map((element) => element.ratingValue)
                                  .toList()
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "")
                                  .removeAllWhitespace,
                              subscriptionLevel: val['is_free'].optionName,
                            );
                          },
                          onClear: (val) {
                            controller.isClearLoading.value = true;
                            Future.delayed(Duration.zero, () {
                              controller.isClearLoading.value = false;
                            });
                            controller.selectedSub.value = val['is_free'];
                            controller.selectedRating.value = val['rating'];
                            controller.getWidgetData(
                              1,
                              "",
                              rating: controller.selectedRating
                                  .map((element) => element.ratingValue)
                                  .toList()
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "")
                                  .removeAllWhitespace,
                              subscriptionLevel: val['is_free'].optionName,
                            );
                            Get.back();
                          }, listOFSelectedDays: [],
                        );
                      }),
                      isDismissible: true)
                  .present(context)
                  .then((value) {
                Get.delete<ClassesFilterController>();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.asset(
                ImageResource.instance.filterIcon,
                height: 18,
              ),
            ))
      ],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: CourseDetailController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, CourseDetailController controller) {
    return Obx(() {
      return RefreshIndicator(
        color: ColorResource.primaryColor,
        onRefresh: controller.onRefresh,
        child: CustomScrollView(
          controller: controller.dataPagingController.value.scrollController,
          slivers: [
            SliverAppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Colors.transparent,
              title: Padding(
                padding: const EdgeInsets.only(
                    top: DimensionResource.marginSizeExtraSmall),
                child: SearchWidget(
                  enableMargin: false,
                  textEditingController: controller.courseController.value,
                  onChange: controller.onCategorySearch,
                  onClear: () {
                    controller.onCategorySearch("");
                  },
                ),
              ),
              pinned: false,
            ),
            SliverToBoxAdapter(
              child: Wrap(
                children: [
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall,
                  ),
                  Visibility(
                    visible: controller.description.value != "",
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensionResource.marginSizeDefault,
                          vertical: DimensionResource.marginSizeSmall),
                      child:
                          descriptionReadMoreText( context ,controller.description.value),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        left: DimensionResource.marginSizeDefault,
                        top: DimensionResource.marginSizeExtraSmall,
                        bottom: DimensionResource.marginSizeExtraSmall),
                    child: Obx(() {
                      return exploreWidget(
                          title:
                              "${StringResource.exploreAll} ${controller.screenType.value}",
                          subTitle:
                              "${StringResource.viewAll} ${controller.screenType.value.toLowerCase()} ${StringResource.relateTo} ${controller.categoryType.value}",
                          cardText:
                              "${controller.singleCourseData.value.data?.pagination?.total ?? controller.courseData.value.data?.pagination?.total ?? 0} ${(controller.singleCourseData.value.data?.pagination?.total ?? controller.courseData.value.data?.pagination?.total ?? 0) > 1 ? controller.screenType.value : controller.screenType.value.toString().replaceRange(controller.screenType.value.toString().length - 1, controller.screenType.value.toString().length, "")}");
                    }),
                  ),
                  controller.isDataLoading.value
                      ? ShimmerEffect.instance.commonPageGridShimmer()
                      : controller.dataPagingController.value.list.isEmpty
                          ? SizedBox(
                              height: 400,
                              child: NoDataFound(
                                showText: true,
                                text:
                                    "${StringResource.seeAllText}${controller.noDataType.value}",
                              ))
                          : controller.getWidget,
                ],
              ),
            ),
          ],
        ),
      );
    });
  }
}

Row exploreWidget(
    {required String title,
    required String subTitle,
    required String cardText}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: StyleResource.instance
                .styleSemiBold(fontSize: DimensionResource.fontSizeDefault - 1)
                .copyWith(letterSpacing: .2),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeExtraSmall - 5,
          ),
          Container(
            constraints: BoxConstraints(maxWidth: Get.width * 0.6),
            child: Text(
              "($subTitle)",
              style: StyleResource.instance
                  .styleLight(
                      fontSize: DimensionResource.fontSizeExtraSmall,
                      color: ColorResource.lightSecondaryColor)
                  .copyWith(letterSpacing: .15),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      clipContainer(cardText, onTap: () {})
    ],
  );
}

Widget commonGridViewList(
    {required Widget Function(int index, CommonDatum data) child,
    required int itemCount,
    required bool isRectangle,
    double aspectRatio = 1}) {
  return Padding(
    padding: const EdgeInsets.only(
        left: DimensionResource.marginSizeDefault,
        right: DimensionResource.marginSizeDefault,
        top: DimensionResource.marginSizeSmall),
    child: GridView.builder(
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: DimensionResource.marginSizeSmall,
            mainAxisSpacing: DimensionResource.marginSizeSmall,
            childAspectRatio: isRectangle ? 1.8 : aspectRatio),
        itemCount: itemCount,
        itemBuilder: (context, index) {
          return child(index, CommonDatum());
        }),
  );
}

Widget audioWrapList(List<CommonDatum> data) {
  return commonGridViewList(
      child: (index, d) {
        CommonDatum dataa = data.elementAt(index);
        CourseWishlist courseWishlist = Get.find<RootViewController>()
            .audioData
            .firstWhere((p0) => p0.id?.value == (dataa.model?.id ?? dataa.id),
                orElse: () => CourseWishlist());
        return InkWell(
          onTap: () {
            logPrint(dataa.toJson());
            Get.toNamed(
                Routes.audioCourseDetail(
                    id: dataa.model?.id != null
                        ? dataa.model?.id.toString()
                        : dataa.id.toString()),
                arguments: [
                  CourseDetailViewType.audio,
                  dataa.model?.id != null
                      ? dataa.model?.id.toString()
                      : dataa.id.toString(),
                  dataa.model?.categoryId != null
                      ? dataa.model?.categoryId.toString()
                      : dataa.categoryId.toString(),
                  dataa.title
                ]);
          },
          child: Card(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            margin: EdgeInsets.zero,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: SizedBox(
              height: Get.height * 0.12,
              width: Get.width * 0.42,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: cachedNetworkImage(
                        dataa.model?.thumbnail ?? dataa.thumbnail ?? "",
                        fit: BoxFit.cover),
                  ),
                  Align(
                    alignment: Alignment.bottomRight,
                    child: RotationTransition(
                      turns: const AlwaysStoppedAnimation(210 / 360),
                      child: Image.asset(
                        ImageResource.instance.volumeIcon,
                        height: 26,
                        color: ColorResource.white.withOpacity(0.5),
                      ),
                    ),
                  ),
                  Container(
                    color: ColorResource.black.withOpacity(0.05),
                    padding:
                        const EdgeInsets.all(DimensionResource.marginSizeSmall),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            (dataa.model?.avgRating == null ||
                                        dataa.model?.avgRating == 0.0) &&
                                    (dataa.avgRating == null ||
                                        dataa.avgRating == 0.0)
                                ? const SizedBox()
                                : StarContainer(
                                    rating: dataa.model?.avgRating == null
                                        ? dataa.avgRating.toString()
                                        : dataa.model?.avgRating.toString() ??
                                            "",
                                    bgColor: ColorResource.white,
                                    fontColor: ColorResource.secondaryColor,
                                  ),
                            Obx(() => IconButtonLayout(
                                  onTap: () async {
                                    await Get.find<RootViewController>()
                                        .saveToWatchLater(
                                            id: (dataa.model?.id != null
                                                ? dataa.model?.id ?? 0
                                                : dataa.id ?? 0),
                                            type: "audio",
                                            response: (WishListSaveModel
                                                wishListData) {
                                              if (wishListData.data ?? false) {
                                                if (dataa.model?.id != null) {
                                                  dataa.model?.isWishlist
                                                      ?.value = 1;
                                                } else {
                                                  dataa.isWishlist!.value = 1;
                                                }
                                              } else {
                                                if (dataa.model?.id != null) {
                                                  dataa.model?.isWishlist
                                                      ?.value = 0;
                                                } else {
                                                  dataa.isWishlist!.value = 0;
                                                }
                                              }
                                            });
                                  },
                                  secondImage: courseWishlist.id != null
                                      ? courseWishlist.isWishList?.value == 1
                                          ? ImageResource
                                              .instance.filledLikeIcon
                                          : null
                                      : dataa.model?.id != null
                                          ? dataa.model?.isWishlist!.value == 1
                                              ? ImageResource
                                                  .instance.filledLikeIcon
                                              : null
                                          : dataa.isWishlist!.value == 1
                                              ? ImageResource
                                                  .instance.filledLikeIcon
                                              : null,
                                  image: ImageResource.instance.likeIcon,
                                  iconSize: 9,
                                  iconColor: ColorResource.redColor,
                                ))
                          ],
                        ),
                        const Spacer(),
                        Text(
                          dataa.model?.title ?? dataa.title ?? "",
                          style: StyleResource.instance.styleMedium(
                              fontSize: DimensionResource.fontSizeSmall,
                              color: ColorResource.white),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )
                      ],
                    ),
                  ),
                  Visibility(
                    visible: (dataa.isFree == 0 ? true : false),
                    child: const Center(
                      child: ProContainerButton(
                        isCircle: true,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
      itemCount: data.length,
      isRectangle: true);
}

Widget videoWrapList(List<CommonDatum> data) {
  return commonGridViewList(
      child: (index, d) {
        CommonDatum dataa = data.elementAt(index);
        return InkWell(
            onTap: () {
              //logPrint("idddd ${dataa.id}");
              AppConstants.instance.singleCourseId.value =
                  (dataa.model?.id != null
                          ? dataa.model?.id.toString()
                          : dataa.id.toString()) ??
                      "";
              Get.toNamed(
                  Routes.continueWatchScreen(
                      id: dataa.model?.id != null
                          ? dataa.model?.id.toString()
                          : dataa.id.toString()),
                  arguments: [
                    dataa.model?.id != null
                        ? dataa.model?.id.toString()
                        : dataa.id.toString(),
                    dataa.model?.categoryId != null
                        ? dataa.model?.categoryId.toString()
                        : dataa.categoryId.toString()
                  ]);
            },
            child: videoContainer(0, dataa, isAudio: false));
      },
      itemCount: data.length,
      isRectangle: false,
      aspectRatio: 1.4);
}

Widget blogWrapList(List<CommonDatum> data) {
  return commonGridViewList(
      child: (index, d) {
        CommonDatum dataa = data.elementAt(index);
        return GestureDetector(
            onTap: () {
              AppConstants.instance.blogId.value = (dataa.model?.id != null
                      ? dataa.model?.id.toString()
                      : dataa.id.toString()) ??
                  "";
              Get.toNamed(
                  Routes.blogsView(
                      id: dataa.model?.id != null
                          ? dataa.model?.id.toString()
                          : dataa.id.toString()),
                  arguments: [
                    dataa.model?.id != null
                        ? dataa.model?.id.toString()
                        : dataa.id.toString(),
                    dataa.model?.categoryId != null
                        ? dataa.model?.categoryId.toString()
                        : dataa.categoryId.toString()
                  ]);
            },
            child: blogsContainer(dataa));
      },
      itemCount: data.length,
      isRectangle: false);
}

Widget audioCourseWrapList(
    {required String categoryType, required List<CommonDatum> data}) {
  return commonGridViewList(
      child: (index, d) {
        CommonDatum dataa = data.elementAt(index);
        logPrint("message ds  ${dataa.themeColor}");
        return audioCourseContainer(index, dataa,
            categoryType: categoryType, height: 95, width: 160);
      },
      itemCount: data.length,
      aspectRatio: 1.8,
      isRectangle: false);
}

Widget videoCourseWrapList(
    {required String categoryType, required List<CommonDatum> data}) {
  return commonGridViewList(
      child: (index, d) {
        CommonDatum dataa = data.elementAt(index);
        logPrint("Commmon Dat ${dataa.toJson()}");
        return videoCourseContainer(index, dataa,
            categoryType: categoryType,
            height: 145,
            width: 157,
            fontSize: DimensionResource.fontSizeSmall);
      },
      itemCount: data.length,
      isRectangle: false);
}

Widget textCourseWrapList(
    {required String categoryType, required List<CommonDatum> data}) {
  return commonGridViewList(
      child: (index, d) {
        CommonDatum dataa = data.elementAt(index);
        return GestureDetector(
            onTap: () {
              Get.offNamed(
                  Routes.textCourseDetail(
                      id: dataa.model?.id != null
                          ? dataa.model?.id.toString()
                          : dataa.id.toString()),
                  arguments: [
                    categoryType,
                    dataa.model?.id != null
                        ? dataa.model?.id.toString()
                        : dataa.id.toString()
                  ]);
            },
            child: textCourseContainer(index,
                height: 165,
                width: 157,
                fontSize: DimensionResource.fontSizeSmall,
                data: dataa));
      },
      itemCount: data.length,
      isRectangle: false);
}

Widget textCourseContainer(
  int index, {
  double height = 120,
  double width = 120,
  double fontSize = DimensionResource.fontSizeSmall - 1,
  CommonDatum? data,
}) {
  return SizedBox(
    height: height,
    width: width,
    child: Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      color: ColorResource.primaryColor,
      child: Padding(
        padding: EdgeInsets.all(height <= 120 ? 4 : 6.0),
        child: Column(
          children: [
            Expanded(
              flex: 3,
              // aspectRatio: 3/2,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  children: [
                    SizedBox(
                      height: height,
                      width: width,
                      child: cachedNetworkImage(
                          data?.model?.thumbnails ??
                              data?.model?.thumbnail ??
                              data?.thumbnails ??
                              data?.thumbnail ??
                              "",
                          fit: BoxFit.cover),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(6),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              (data?.model?.avgRating == null ||
                                          data?.model?.avgRating == 0.0) &&
                                      (data?.avgRating == null ||
                                          data?.avgRating == 0.0)
                                  ? const SizedBox()
                                  : StarContainer(
                                      rating: data?.model?.avgRating == null
                                          ? data?.avgRating.toString() ?? ""
                                          : data?.model?.avgRating.toString() ??
                                              "",
                                      bgColor: ColorResource.white,
                                      fontColor: ColorResource.secondaryColor,
                                    ),
                              Obx(() {
                                CourseWishlist courseWishlist =
                                    Get.find<RootViewController>()
                                        .textCourseData
                                        .firstWhere(
                                            (p0) =>
                                                p0.id?.value ==
                                                (data?.model?.id ?? data?.id),
                                            orElse: () => CourseWishlist());
                                return IconButtonLayout(
                                  onTap: () {
                                    Get.find<RootViewController>()
                                        .saveToWatchLater(
                                            id: (data?.model?.id != null
                                                ? data?.model?.id ?? 0
                                                : data?.id ?? 0),
                                            type: "course_text",
                                            response: (WishListSaveModel
                                                wishListData) {
                                              if (wishListData.data ?? false) {
                                                if (data?.model?.id != null) {
                                                  data?.model?.isWishlist
                                                      ?.value = 1;
                                                } else {
                                                  data?.isWishlist!.value = 1;
                                                }
                                              } else {
                                                if (data?.model?.id != null) {
                                                  data?.model?.isWishlist
                                                      ?.value = 0;
                                                } else {
                                                  data?.isWishlist!.value = 0;
                                                }
                                              }
                                            });
                                  },
                                  image: ImageResource.instance.likeIcon,
                                  iconSize: 9,
                                  secondImage: courseWishlist.id != null
                                      ? courseWishlist.isWishList?.value == 1
                                          ? ImageResource
                                              .instance.filledLikeIcon
                                          : null
                                      : data?.model?.id != null
                                          ? data?.model?.isWishlist!.value == 1
                                              ? ImageResource
                                                  .instance.filledLikeIcon
                                              : null
                                          : data?.isWishlist!.value == 1
                                              ? ImageResource
                                                  .instance.filledLikeIcon
                                              : null,
                                  shadowColor: Colors.white,
                                  bgColor: ColorResource.white,
                                  iconColor: ColorResource.redColor,
                                );
                              })
                            ],
                          ),
                        ),
                        const Spacer(),
                        data?.isFree == 0
                            ? const ProContainerButton()
                            : const SizedBox(),
                        const SizedBox(
                          height: DimensionResource.marginSizeSmall,
                        )
                      ],
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: DimensionResource.marginSizeExtraSmall,
                    ),
                    Text(
                      data?.model?.courseTitle ??
                          data?.model?.title ??
                          data?.courseTitle ??
                          "",
                      style: StyleResource.instance.styleMedium(
                          fontSize: height <= 120
                              ? DimensionResource.fontSizeExtraSmall - 1
                              : fontSize,
                          color: ColorResource.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    const Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${data?.courseDetailCount} ${StringResource.chapters}",
                          style: StyleResource.instance.styleRegular(
                              fontSize: height <= 120
                                  ? 6
                                  : DimensionResource.fontSizeExtraSmall - 2.8,
                              color: ColorResource.white),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                        LinearPercentIndicator(
                          padding: EdgeInsets.zero,
                          width: 35,
                          animation: true,
                          barRadius: const Radius.circular(10),
                          animationDuration: 1000,
                          lineHeight: height <= 120 ? 4 : 5.0,
                          percent: 0.6,
                          linearStrokeCap: LinearStrokeCap.butt,
                          progressColor: ColorResource.starColor,
                          backgroundColor: Colors.white,
                        )
                      ],
                    ),
                    const SizedBox(
                      height: DimensionResource.marginSizeExtraSmall - 2,
                    ),
                  ],
                ))
          ],
        ),
      ),
    ),
  );
}

Widget clipContainer(String cardText, {required Function() onTap}) {
  return InkWell(
    onTap: onTap,
    child: Card(
      elevation: 3,
      shadowColor: ColorResource.primaryColor,
      margin: EdgeInsets.zero,
      color: ColorResource.secondaryColor,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        topLeft: Radius.circular(15),
        bottomLeft: Radius.circular(15),
      )),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeSmall,
            vertical: DimensionResource.marginSizeExtraSmall),
        child: Text(
          cardText,
          style: StyleResource.instance.styleMedium(
              color: ColorResource.white,
              fontSize: DimensionResource.fontSizeSmall),
        ),
      ),
    ),
  );
}
