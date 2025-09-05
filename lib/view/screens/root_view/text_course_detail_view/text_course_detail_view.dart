import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:readmore/readmore.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../../../model/models/course_models/course_by_id_model.dart';
import '../../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/services/download_service/download_file.dart';
import '../../../../model/utils/app_constants.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/helper_util.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../view_model/controllers/root_view_controller/text_course_detail_controller/text_course_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/widget_controllers/show_rating_controller.dart';
import '../../../widgets/button_view/animated_box.dart';
import '../../../widgets/button_view/common_button.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../../widgets/toast_view/showtoast.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';
import '../../../widgets/view_helpers/small_button.dart';
import '../../base_view/base_view_screen.dart';
import '../audio_course_detail_view/audio_course_detail_view.dart';
import '../courses_detail_view/course_detail_view.dart';
import '../home_view/home_view_screen.dart';
import '../home_view/widget/scalps_widget.dart';
import '../widget/add_rating_widget.dart';
import '../widget/show_rating_widget.dart';
import 'widget/more_like_this_widget.dart';

class TextCourseDetailView extends StatelessWidget {
  const TextCourseDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BaseView(
      isTag: true,
      onAppBarTitleBuilder: (context, controller) => Obx(() {
        return TitleBarCentered(
          titleText: controller.categoryType.value,
        );
      }),
      onActionBuilder: (context, controller) => [
        InkWell(
            onTap: () async {
              await HelperUtil.instance
                  .buildInviteLink(
                      isAppShare: false,
                      shareId:
                          "${controller.courseData.value.data?.id.toString()}/${controller.courseData.value.data?.courseCategory?.title ?? ""}",
                      type: AppConstants.shareTextCourse)
                  .then((value) async {
                await HelperUtil.share(
                        referCode: "", url: value.shortUrl.toString())
                    .then((value) {
                  // if(value != null && value){
                  //   Get.find<ScalpController>().onShare(data.id??0);
                  // }
                });
              });
            },
            child: Image.asset(
              ImageResource.instance.shareIcon,
              height: 18,
              color: ColorResource.white,
            )),
      ],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: TextCourseDetailController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, TextCourseDetailController controller) {
    return Obx(() {
      if (controller.isDataLoading.value) {
        return ShimmerEffect.instance.textCourseDetailLoader();
      } else {
        if (controller.courseData.value.data == null) {
          return SizedBox(
              height: Get.height * 0.65, child: const NoDataFound());
        } else {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: DimensionResource.marginSizeDefault,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.marginSizeDefault),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Obx(() {
                        return courseBox(
                            courseImage:
                                controller.courseData.value.data?.image ?? "",
                            courseName:
                                controller.courseData.value.data?.courseTitle ??
                                    "",
                            rating: controller.courseData.value.data?.avgRating
                                    .toString() ??
                                "",
                            extraWidget: Padding(
                              padding: const EdgeInsets.only(top: 3.0),
                              child: IconButtonLayout(
                                onTap: () async {
                                  await Get.find<RootViewController>()
                                      .saveToWatchLater(
                                          id: controller
                                                  .courseData.value.data?.id ??
                                              0,
                                          type: AppConstants.textCourse,
                                          response:
                                              (WishListSaveModel wishListData) {
                                            if (wishListData.data ?? false) {
                                              controller.courseData.value.data
                                                  ?.isWishlist?.value = 1;
                                            } else {
                                              controller.courseData.value.data
                                                  ?.isWishlist?.value = 0;
                                            }
                                            // if(onWishlist != null){
                                            //   onWishlist();
                                            // }
                                          });
                                },
                                bgColor: ColorResource.white,
                                secondImage: controller.courseData.value.data
                                            ?.isWishlist?.value ==
                                        1
                                    ? ImageResource.instance.filledLikeIcon
                                    : null,
                                image: ImageResource.instance.likeIcon,
                                iconSize: 12,
                                iconColor: ColorResource.redColor,
                              ),
                            ));
                      }),
                      const SizedBox(
                        height: DimensionResource.marginSizeDefault,
                      ),
                      Obx(() {
                        return Visibility(
                          visible:
                              controller.courseData.value.data?.description !=
                                  null,
                          child: descriptionReadMoreText(context ,controller
                                  .courseData.value.data?.description
                                  .toString()
                                  .capitalize ??
                              ""),
                        );
                      }),
                      const SizedBox(
                        height: DimensionResource.marginSizeSmall,
                      ),
                      Obx(() {
                        return getCertificateContainer(
                          title:
                              controller.courseData.value.data?.courseTitle ??
                                  "",
                          isLoading: controller.downloadingLoader.value,
                          onListen: (status) {
                            if (status == DownloadStatus.complete) {
                              controller.downloadingLoader.value = false;
                            } else if (status == DownloadStatus.start) {
                              controller.downloadingLoader.value = true;
                            } else {
                              controller.downloadingLoader.value = false;
                            }
                          },
                          url:
                              controller.courseData.value.data?.id.toString() ??
                                  "",
                          isDisable: ((controller
                                      .courseStatus.value.data?.isNotEmpty ??
                                  false)
                              ? controller.courseStatus.value.data?.first
                                      .quizCompleted ==
                                  0
                              : true),
                        );
                      }),
                    ],
                  ),
                ),
                Obx(() => Visibility(
                      visible: !controller.isDataLoading.value,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: DimensionResource.marginSizeSmall),
                        child: UserAccessWidget(
                            isPro:
                                controller.courseData.value.data?.isFree != 1),
                      ),
                    )),
                Padding(
                  padding: const EdgeInsets.only(
                      left: DimensionResource.marginSizeDefault,
                      top: DimensionResource.marginSizeDefault),
                  child: Obx(() {
                    return exploreWidget(
                        cardText:
                            "${controller.courseData.value.data?.courseDetailCount ?? 0} ${(controller.courseData.value.data?.courseDetailCount ?? 0) > 1 ? StringResource.courses : StringResource.chapter}",
                        title: StringResource.explore,
                        subTitle:
                            "${StringResource.viewAllChapter} ${controller.categoryType.value}");
                  }),
                ),
                const SizedBox(
                  height: DimensionResource.marginSizeSmall,
                ),
                Obx(() {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: List.generate(
                        controller
                                .courseData.value.data?.courseDetail?.length ??
                            0, (index) {
                      CourseDetail data = controller
                          .courseData.value.data!.courseDetail!
                          .elementAt(index);
                      return InkWell(
                        onTap: Get.find<AuthService>().isGuestUser.value ||
                                (!Get.find<AuthService>().isPro.value &&
                                    controller.courseData.value.data?.isFree !=
                                        1)
                            ? () {
                                ProgressDialog().showFlipDialog(
                                    isForPro: Get.find<AuthService>()
                                            .isGuestUser
                                            .value
                                        ? false
                                        : true);
                              }
                            : () {
                                Get.toNamed(
                                        Routes.textCourseView(
                                            id: data.id.toString()),
                                        arguments: [
                                      controller.categoryType.value,
                                      controller
                                          .courseData.value.data?.courseDetail,
                                      index,
                                      controller.courseData.value.data?.id
                                          .toString()
                                    ])!
                                    .then((value) {
                                  logPrint("message dsfsd ");
                                  controller.getCourseStatus();
                                });
                              },
                        child: Card(
                          color: ColorResource.primaryColor,
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.only(
                              bottom: 10,
                              left: DimensionResource.marginSizeDefault,
                              right: DimensionResource.marginSizeDefault),
                          child: SizedBox(
                            child: Row(
                              children: [
                                Expanded(
                                    flex: 6,
                                    child: Container(
                                      color: ColorResource.white,
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: DimensionResource
                                              .marginSizeDefault,
                                          vertical: DimensionResource
                                              .marginSizeSmall),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          // StarContainer(
                                          //   rating: controller.courseData.value.data?.avgRating.toString()??"",
                                          // ),
                                          const SizedBox(
                                            height: DimensionResource
                                                .marginSizeExtraSmall,
                                          ),
                                          CustomText(
                                            text: data.topicTitle
                                                    .toString()
                                                    .capitalize ??
                                                "",
                                          )
                                        ],
                                      ),
                                    )),
                                Expanded(
                                    flex: 1,
                                    child: Center(
                                        child: Image.asset(
                                      ImageResource.instance.translateImage,
                                      height: 30,
                                    ))),
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
                  );
                }),
                const SizedBox(
                  height: DimensionResource.marginSizeExtraSmall,
                ),
                Obx(() {
                  return quizBoxContainer(
                      onTap: () {
                        controller.getCourseStatus();
                      },
                      certificateCriteria: controller
                              .courseData.value.data?.certificateCriteria ??
                          0,
                      isDissable:
                          ((controller.courseStatus.value.data?.isNotEmpty ??
                                  false)
                              ? controller.courseStatus.value.data?.first
                                      .courseCompleted ==
                                  0
                              : true),
                      quiz: controller.courseData.value.data?.quiz ?? Quiz(),
                      courseId:
                          controller.courseData.value.data?.id.toString() ??
                              "");
                }),
                Obx(() {
                  return Visibility(
                    visible: controller.moreLikeData.isNotEmpty,
                    child: MoreLikeWidget(
                      onItemTap: (data) {
                        controller.categoryId.value = data.id.toString();
                        // controller.getTextCourseById();
                      },
                      onTap: () {
                        Get.toNamed(Routes.courseDetail, arguments: [
                          controller.courseData.value.data?.courseCategory
                                  ?.title ??
                              "",
                          CourseDetailViewType.textCourse,
                          "",
                          controller.courseData.value.data?.courseCategory?.id
                        ]);
                      },
                      dataList: controller.moreLikeData,
                    ),
                  );
                }),
                const SizedBox(
                  height: DimensionResource.marginSizeLarge,
                ),
                Obx(() {
                  if (controller.courseData.value.data?.id != null) {
                    return AllRatingAndReviews(
                      contest: context,
                      courseDatum: CourseDatum(
                          type: "course_text",
                          id: controller.courseData.value.data?.id.toString(),
                          name: controller.courseData.value.data?.courseTitle ??
                              "",
                          rating: controller.courseData.value.data?.avgRating
                                  .toString() ??
                              ""),
                    );
                  } else {
                    return const SizedBox();
                  }
                }),
                const SizedBox(
                  height: DimensionResource.marginSizeLarge,
                )
              ],
            ),
          );
        }
      }
    });
  }
}

class BulletListWidget extends StatelessWidget {
  final String title;
  final List<String> dataList;
  final bool isDark;
  const BulletListWidget(
      {Key? key,
      required this.title,
      required this.dataList,
      this.isDark = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headlineText(title,
            fontColor:
                isDark ? ColorResource.white : ColorResource.secondaryColor),
        const SizedBox(
          height: DimensionResource.marginSizeExtraSmall,
        ),
        Column(
          children: List.generate(3, (index) {
            return Padding(
              padding: EdgeInsets.only(
                  bottom:
                      index == 2 ? 0 : DimensionResource.marginSizeExtraSmall),
              child: Row(
                children: [
                  const Icon(
                    Icons.circle,
                    color: ColorResource.primaryColor,
                    size: 9,
                  ),
                  const SizedBox(
                    width: DimensionResource.marginSizeExtraSmall,
                  ),
                  Expanded(
                      child: descriptionText(
                          "The Bank Nifty future is based on open interest.",
                          fontColor: isDark
                              ? ColorResource.white
                              : ColorResource.secondaryColor))
                ],
              ),
            );
          }),
        ),
      ],
    );
  }
}

Widget quizBoxContainer(
    {bool enableVerticalPadding = false,
    bool isDissable = false,
    required Quiz quiz,
    required String courseId,
    required double certificateCriteria,
    Function()? onTap}) {
  logPrint("quiz.title  ${quiz.title}");
  return InkWell(
    splashColor: ColorResource.white,
    onTap: () {
      if (!isDissable) {
        if (quiz.isAttempted == null || quiz.isAttempted == 0) {
          Get.toNamed(Routes.quizMainView, arguments: {
            "id": quiz.id.toString(),
            "course_id": courseId,
            "certificate_criteria": certificateCriteria
          })!
              .then((value) {
            logPrint("dsdfsdfds dsfsjdf vdsvj v $onTap");
            if (onTap != null) {
              onTap();
            }
          });
        } else {
          toastShow(message: StringResource.quizAttempted);
        }
      } else {
        toastShow(message: StringResource.onDownloadQuiz);
      }
    },
    child: Card(
      color: isDissable
          ? ColorResource.primaryColor.withOpacity(0.4)
          : ColorResource.primaryColor,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.only(
          left: DimensionResource.marginSizeDefault,
          right: DimensionResource.marginSizeDefault,
          top: enableVerticalPadding ? DimensionResource.marginSizeDefault : 0),
      child: Row(
        children: [
          Expanded(
              flex: 2,
              child: Center(
                  child: Text(
                "QUIZ",
                style: StyleResource.instance.styleSemiBold(
                    color: ColorResource.white,
                    fontSize: DimensionResource.fontSizeSmall - 1),
              ))),
          Expanded(
              flex: 8,
              child: Container(
                color: isDissable
                    ? ColorResource.secondaryColor.withOpacity(0.4)
                    : ColorResource.secondaryColor,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: DimensionResource.marginSizeSmall, top: 4),
                          child: Text(
                            "FINAL QUIZ",
                            style: StyleResource.instance.styleSemiBold(
                                color: ColorResource.greenColor,
                                fontSize: DimensionResource.fontSizeSmall),
                          ),
                        ),
                        Container(
                          decoration: const BoxDecoration(
                              color: ColorResource.white,
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(10),
                                  bottomLeft: Radius.circular(10))),
                          padding: const EdgeInsets.all(5),
                          child: Image.asset(
                            ImageResource.instance.topArrowIcon,
                            height: 14,
                            color: ColorResource.primaryColor,
                          ),
                        )
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          left: DimensionResource.marginSizeSmall,
                          right: DimensionResource.marginSizeSmall,
                          bottom: DimensionResource.marginSizeSmall),
                      child: Text(
                        quiz.title == null
                            ? ""
                            : quiz.title.toString().capitalize ?? "",
                        style: StyleResource.instance.styleRegular(
                            color: ColorResource.white,
                            fontSize: DimensionResource.fontSizeSmall + 1),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    )
                  ],
                ),
              ))
        ],
      ),
    ),
  );
}

CommonContainer getCertificateContainer(
    {double? width,
    required String url,
    required String title,
    required bool isDisable,
    required bool isLoading,
    required Function(DownloadStatus) onListen}) {
  return CommonContainer(
    width: width,
    isDisable: isDisable,
    onPressed: () async {
      if (isDisable) {
        toastShow(message: StringResource.onDownloadButton);
      } else {
        await HelperUtil.instance.openUrlFunction(
            courseId: url, courseName: title, onListen: onListen);
      }
    },
    loading: false,
    child: Row(
      children: [
        Image.asset(ImageResource.instance.batchIcon, height: 20),
        const SizedBox(
          width: DimensionResource.marginSizeExtraSmall + 4,
        ),
        Text(
          "Download Certificate",
          style: StyleResource.instance.styleSemiBold(
              fontSize: DimensionResource.fontSizeDefault,
              color: ColorResource.white),
        ),
        const Spacer(),
        isLoading
            ? const SizedBox(
                height: 16,
                width: 16,
                child: CircularProgressIndicator(
                  strokeWidth: 1.5,
                  color: ColorResource.mateGreenColor,
                ),
              )
            : Image.asset(
                ImageResource.instance.arrowDownIcon,
                height: 14,
              ),
      ],
    ),
  );
}

class AllRatingAndReviews extends GetView<ShowRatingController> {
  final BuildContext contest;
  final bool enableVerticalMargin;
  final bool isDark;
  final bool isCourse;
  final double fontSize;

  final CourseDatum courseDatum;
  const AllRatingAndReviews(
      {Key? key,
      required this.courseDatum,
      required this.contest,
      this.isCourse = true,
      this.isDark = false,
      this.enableVerticalMargin = false,
      this.fontSize = DimensionResource.fontSizeLarge})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    Get.put(ShowRatingController(data: courseDatum));
    return Container(
      margin: EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault,
          vertical:
              enableVerticalMargin ? DimensionResource.marginSizeSmall : 0),
      decoration: BoxDecoration(
          color: isDark ? ColorResource.secondaryColor : ColorResource.white,
          image: DecorationImage(
              image: AssetImage(
                ImageResource.instance.quoteBanner,
              ),
              fit: BoxFit.contain,
              opacity: 0.04)),
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            rowTile(() {}, "${StringResource.courseRatingHeading}",
                isDark: isDark,
                showIcon: true,
                button: Visibility(
                  visible: courseDatum.rating != "0.0" &&
                      courseDatum.rating != null &&
                      courseDatum.rating != "null" &&
                      courseDatum.rating != "",
                  child: StarContainer(
                      rating: "${courseDatum.rating} / 5",
                      vertical: 4,
                      horizontal: 6,
                      isDark: isDark),
                ),
                enablePadding: false,
                enableTopPadding: false),
            const SizedBox(
              height: DimensionResource.marginSizeExtraSmall - 2,
            ),
            controller.pagingController.value.list.isEmpty
                ? Center(
                    child: Text(StringResource.noRatingFound),
                  )
                : ratingContainer(isDark, contest,
                    courseDatum: courseDatum,
                    userRatingModel: controller.pagingController.value.list.isEmpty
                        ? UserRatingModel()
                        : UserRatingModel(
                            userName: controller.pagingController.value.list.first
                                    .user?.name ??
                                "",
                            rating: controller
                                .pagingController.value.list.first.rating
                                .toString(),
                            comment: controller.pagingController.value.list.first.comment ??
                                "",
                            ratingDate: controller
                                .pagingController.value.list.first.createdAt,
                            replyDate: controller.pagingController.value.list
                                .first.reviewable?.updatedAt,
                            reply: controller
                                .pagingController.value.list.first.reply)),
            const SizedBox(
              height: DimensionResource.marginSizeLarge,
            ),
            CommonButton(
              text: controller.pagingController.value.list.isEmpty
                  ? StringResource.addReview
                  : StringResource.seeAllReview,
              loading: false,
              onPressed: () async {
                if (!Get.find<AuthService>().isGuestUser.value) {
                  await buildShowModalBottomSheet(
                          contest,
                          controller.pagingController.value.list.isEmpty
                              ? AddRatingWidget(
                                  courseDatum: courseDatum,
                                )
                              : ShowRatingWidget(
                                  courseDatum: courseDatum,
                                ),
                          isDismissible: true)
                      .then((value) async {
                    controller.feedbackController.clear();
                    controller.rating.value = 4.0;
                    controller.feedbackError.value = "";
                    //await Get.delete<ShowRatingController>();
                  });
                } else {
                  if (controller.pagingController.value.list.isNotEmpty) {
                    await buildShowModalBottomSheet(
                            contest,
                            controller.pagingController.value.list.isEmpty
                                ? AddRatingWidget(
                                    courseDatum: courseDatum,
                                  )
                                : ShowRatingWidget(
                                    courseDatum: courseDatum,
                                  ),
                            isDismissible: true)
                        .then((value) async {
                      controller.feedbackController.clear();
                      controller.rating.value = 4.0;
                      controller.feedbackError.value = "";

                      //await Get.delete<ShowRatingController>();
                    });
                  } else {
                    ProgressDialog().showFlipDialog(isForPro: false);
                  }
                }
              },
              color:
                  isDark ? ColorResource.white : ColorResource.secondaryColor,
              textColor:
                  isDark ? ColorResource.primaryColor : ColorResource.white,
              fontSize: fontSize,
            )
          ],
        );
      }),
    );
  }
}

ratingContainer(
  bool isDark,
  BuildContext context, {
  bool showAddIcon = true,
  bool showNameCircle = false,
  required CourseDatum courseDatum,
  required UserRatingModel userRatingModel,
}) {
  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Visibility(
        visible: showNameCircle,
        child: Padding(
          padding: const EdgeInsets.only(
              right: DimensionResource.marginSizeExtraSmall, top: 5),
          child: CircleAvatar(
            radius: 16,
            backgroundColor: ColorResource.lightContrastBlack,
            child: Text(
              userRatingModel.userName == ""
                  ? "S"
                  : userRatingModel.userName?.substring(0, 1).toUpperCase() ??
                      "",
              style: StyleResource.instance.styleSemiBold(
                  color: ColorResource.primaryColor,
                  fontSize: DimensionResource.fontSizeLarge),
            ),
          ),
        ),
      ),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      userRatingModel.userName?.capitalize ?? "",
                      style: StyleResource.instance.styleMedium(
                        fontSize: DimensionResource.fontSizeSmall,
                        color: isDark
                            ? ColorResource.white
                            : ColorResource.secondaryColor,
                      ),
                    ),
                    const SizedBox(
                      height: DimensionResource.marginSizeExtraSmall - 2,
                    ),
                    IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image.asset(
                            ImageResource.instance.starIcon,
                            height: 10,
                          ),
                          const SizedBox(
                            width: DimensionResource.marginSizeExtraSmall - 1,
                          ),
                          Text(
                            userRatingModel.rating ?? "",
                            style: StyleResource.instance.styleMedium(
                              fontSize: DimensionResource.fontSizeExtraSmall,
                              color: isDark
                                  ? ColorResource.white
                                  : ColorResource.secondaryColor,
                            ),
                          ),
                          VerticalDivider(
                            endIndent: 2.2,
                            indent: 2.2,
                            thickness: 1.2,
                            color: isDark
                                ? ColorResource.white
                                : ColorResource.secondaryColor,
                          ),
                          Text(
                            AppConstants.formatDate(userRatingModel.ratingDate),
                            style: StyleResource.instance.styleRegular(
                              fontSize: DimensionResource.fontSizeExtraSmall,
                              color: isDark
                                  ? ColorResource.white
                                  : ColorResource.secondaryColor,
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                Visibility(
                  visible: showAddIcon,
                  child: InkWell(
                    onTap: () async {
                      if (!Get.find<AuthService>().isGuestUser.value) {
                        await buildShowModalBottomSheet(
                                context,
                                AddRatingWidget(
                                  courseDatum: courseDatum,
                                ),
                                isDismissible: true)
                            .then((value) {
                          Get.find<ShowRatingController>()
                              .feedbackController
                              .clear();
                          Get.find<ShowRatingController>().rating.value = 4.0;
                          Get.find<ShowRatingController>().feedbackError.value =
                              "";
                        });
                      } else {
                        ProgressDialog().showFlipDialog(isForPro: false);
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.all(3),
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: ColorResource.primaryColor,
                          boxShadow: [
                            BoxShadow(
                                color: ColorResource.primaryColor,
                                spreadRadius: 2,
                                blurRadius: 10)
                          ]),
                      child: const Icon(
                        Icons.add,
                        color: ColorResource.white,
                        size: 19,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: DimensionResource.marginSizeExtraSmall + 1,
            ),
            Text(
              userRatingModel.comment.toString().capitalize ?? "",
              style: StyleResource.instance
                  .styleLight(
                      fontSize: DimensionResource.fontSizeExtraSmall,
                      color: isDark
                          ? ColorResource.white.withOpacity(0.6)
                          : ColorResource.lightTextColor)
                  .copyWith(letterSpacing: .4),
            ),
            Visibility(
              visible: (!showAddIcon &&
                  (userRatingModel.reply != "" &&
                      userRatingModel.reply != null)),
              child: Padding(
                padding: const EdgeInsets.only(
                    top: DimensionResource.marginSizeSmall),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: showNameCircle,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            right: DimensionResource.marginSizeExtraSmall,
                            top: 0),
                        child: CircleAvatar(
                          radius: 16,
                          backgroundColor: ColorResource.white,
                          child: Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: Image.asset(
                              ImageResource.instance.appLogo,
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                        child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Stockpathshala",
                                  style: StyleResource.instance.styleMedium(
                                    fontSize: DimensionResource.fontSizeSmall,
                                    color: isDark
                                        ? ColorResource.white
                                        : ColorResource.secondaryColor,
                                  ),
                                ),
                                const SizedBox(
                                  height:
                                      DimensionResource.marginSizeExtraSmall -
                                          2,
                                ),
                                Text(
                                  AppConstants.formatDate(
                                      userRatingModel.replyDate),
                                  style: StyleResource.instance.styleRegular(
                                    fontSize:
                                        DimensionResource.fontSizeExtraSmall,
                                    color: isDark
                                        ? ColorResource.white
                                        : ColorResource.secondaryColor,
                                  ),
                                )
                              ],
                            ),
                            const Spacer(),
                            Visibility(
                              visible: showAddIcon,
                              child: InkWell(
                                onTap: () async {
                                  await buildShowModalBottomSheet(
                                          context,
                                          AddRatingWidget(
                                            courseDatum: courseDatum,
                                          ),
                                          isDismissible: true)
                                      .then((value) async {
                                    //await Get.delete<AddRatingController>();
                                  });
                                },
                                child: Container(
                                  padding: const EdgeInsets.all(3),
                                  decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: ColorResource.primaryColor,
                                      boxShadow: [
                                        BoxShadow(
                                            color: ColorResource.primaryColor,
                                            spreadRadius: 2,
                                            blurRadius: 10)
                                      ]),
                                  child: const Icon(
                                    Icons.add,
                                    color: ColorResource.white,
                                    size: 19,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: DimensionResource.marginSizeExtraSmall + 1,
                        ),
                        Text(
                          userRatingModel.reply ?? "",
                          style: StyleResource.instance
                              .styleLight(
                                  fontSize:
                                      DimensionResource.fontSizeExtraSmall,
                                  color: isDark
                                      ? ColorResource.white.withOpacity(0.6)
                                      : ColorResource.lightTextColor)
                              .copyWith(letterSpacing: .4),
                        ),
                      ],
                    ))
                  ],
                ),
              ),
            )
          ],
        ),
      )
    ],
  );
}

class UserRatingModel {
  final String? userName;
  final String? rating;
  final DateTime? ratingDate;
  final DateTime? replyDate;
  final String? reply;
  final String? comment;

  UserRatingModel(
      {this.userName,
      this.rating,
      this.comment,
      this.reply,
      this.ratingDate,
      this.replyDate});
}

Widget courseBox(
    {required String courseImage,
    required String courseName,
    required String rating,
    bool showShareIcon = false,
    Function()? onShareTap,
    Widget? extraWidget}) {
  return IntrinsicHeight(
    child: Builder(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height:screenWidth<500? 50:100,
              width:screenWidth<500? 50:100,
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  child: cachedNetworkImage(courseImage, fit: BoxFit.cover)),
            ),
            const SizedBox(
              width: DimensionResource.marginSizeSmall,
            ),
            Expanded(
                child: SizedBox(
              height: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    courseName,
                    style: StyleResource.instance
                        .styleSemiBold(fontSize: screenWidth<500 ?DimensionResource.fontSizeDefault:DimensionResource.fontSizeDoubleExtraLarge),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ],
              ),
            )),
            const SizedBox(
              width: DimensionResource.marginSizeExtraSmall,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                showShareIcon
                    ? Center(
                        child: SizedBox(
                          height: 20,
                          width: 20,
                          child: MaterialButton(
                            onPressed: onShareTap,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            color: ColorResource.mateGreenColor,
                            padding: EdgeInsets.zero,
                            child: Image.asset(
                              ImageResource.instance.shareIcon,
                              height: 11,
                              color: ColorResource.white,
                            ),
                          ),
                        ),
                      )
                    : Visibility(
                        visible: rating != "0" && rating != "" && rating != "null",
                        child: Padding(
                          padding: const EdgeInsets.only(
                            top: DimensionResource.marginSizeExtraSmall,
                          ),
                          child: StarContainer(
                            rating: rating,
                          ),
                        ),
                      ),
                extraWidget ??
                    const SizedBox(
                      height: 0,
                      width: 0,
                    )
              ],
            )
          ],
        );
      }
    ),
  );
}

class CustomText extends StatelessWidget {
  final String text;
  final TextStyle? style;
  const CustomText({Key? key, required this.text, this.style})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: style ??
          StyleResource.instance
              .styleMedium(fontSize: DimensionResource.fontSizeDefault),
      overflow: TextOverflow.ellipsis,
      maxLines: 2,
    );
  }
}

Widget descriptionReadMoreText(BuildContext context,String text,
        {bool isDark = false,
        double fontSize = DimensionResource.fontSizeSmall - 1,}){
      final screenWidth = MediaQuery.of(context).size.width;

      return ReadMoreText(text,
      trimLines: 2,
      colorClickableText: ColorResource.primaryColor,
      style: StyleResource.instance
          .styleLight(
        fontSize: screenWidth<500? fontSize:DimensionResource.fontSizeExtraLarge,
        color:
        isDark ? ColorResource.white : ColorResource.secondaryColor,
      )
          .copyWith(letterSpacing: .2),
      trimMode: TrimMode.Line,
      trimCollapsedText: 'read more',
      trimExpandedText: '  show less',
      lessStyle: StyleResource.instance
          .styleLight(
        fontSize:screenWidth<500?10:14,
        color: ColorResource.mateRedColor,
      )
          .copyWith(letterSpacing: .2),
      moreStyle: StyleResource.instance
          .styleLight(
        fontSize: screenWidth<500?10:14,
        color: ColorResource.primaryColor,
      )
          .copyWith(letterSpacing: .2),
      textAlign: TextAlign.start);
}


Text descriptionText(String text,
        {Color fontColor = ColorResource.secondaryColor}) =>
    Text(
      text,
      style: StyleResource.instance
          .styleLight(
              fontSize: DimensionResource.fontSizeSmall - 1, color: fontColor)
          .copyWith(letterSpacing: .2),
    );

Text headlineText(String text,
        {Color fontColor = ColorResource.secondaryColor}) =>
    Text(
      text,
      style: StyleResource.instance.styleSemiBold(color: fontColor),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
