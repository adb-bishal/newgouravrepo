import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/text_course_detail_view/widget/more_like_this_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/widget/add_rating_widget.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import '../../../../../../model/services/player/file_video_widget.dart';
import '../../../../../../model/utils/color_resource.dart';
import '../../../../../../model/utils/dimensions_resource.dart';
import '../../../../../../view_model/controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import '../../../../../widgets/view_helpers/progress_dialog.dart';
import '../../../../base_view/video_base_view.dart';
import '../../../../subscription_view/example_blog.dart';
import '../../../quiz_view/quiz_list.dart';
import '../../../text_course_detail_view/text_course_detail_view.dart';

class BatchClassDetail extends StatelessWidget {
  const BatchClassDetail({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(LiveClassesController());
    Get.put(LiveClassDetailController());
    final authService = Get.find<AuthService>();
    final isProuser = authService.userRole.value ==
        "pro_user"; // New condition for trial user
    print('dfvfver${authService.userRole.value}');
    return VideoBaseView(
      screenType: AppConstants.batchClass,
      isDataLoading: false.obs,
      viewControl: LiveClassDetailController(),
      onBackClicked: (context, controller) {
        Get.back();
      },
      actionBuilder: (context, controller) => [],
      onVideoBuilder: (context, controller) => Obx(
        () => authService.userRole.value == "trial_user" &&
                controller.liveClassDetail.value.data?.isTrial == 1
            ? FileVideoWidget(
                showQualityPicker: !controller.isPast.value,
                url: controller.liveClassDetail.value.data?.fileUrl ?? "",
                eventCallBack: (progress, totalDuration) {},
              )
            : isProuser && controller.isPast.value
                ? (!Get.find<AuthService>().isPro.value ||
                        controller.liveClassDetail.value.data?.fileUrl ==
                            null ||
                        controller.liveClassDetail.value.data?.fileUrl == "")
                    ? SizedBox(
                        width: double.infinity,
                        child: cachedNetworkImage(
                          controller.liveClassDetail.value.data?.image ?? "",
                        ),
                      )
                    : FileVideoWidget(
                        showQualityPicker: !controller.isPast.value,
                        url: controller.liveClassDetail.value.data?.fileUrl ??
                            "",
                        eventCallBack: (progress, totalDuration) {},
                      )
                : SizedBox(
                    child: controller.liveClassDetail.value.data == null
                        ? ShimmerEffect.instance.imageLoader(
                            color: Colors.white, radius: BorderRadius.zero)
                        : cachedNetworkImage(
                            controller.liveClassDetail.value.data?.image ?? "",
                            fit: BoxFit.contain,
                          ),
                  ),
      ),
      onPageBuilder: (context, controller) {
        return mainBodyBuilder(context, controller);
      },
    );
  }

  List<Widget> mainBodyBuilder(
      BuildContext context, LiveClassDetailController controller) {
    final screenWidth = MediaQuery.of(context).size.width;
    logPrint("hissds ${Get.find<RootViewController>().isTrial.value}");

    final LiveClassDetailController liveClassDetailController =
        Get.put(LiveClassDetailController());

    // final LiveClassDetailController ccontroller = Get.find<LiveClassDetailController>();
    print("Downloading... ${liveClassDetailController.isDownloading.value}");

    final authService = Get.find<AuthService>();
    final userType = authService.userRole.value;

    final userRole = authService.userRole.value;
    return [
      Obx(
        () => controller.liveClassDetail.value.data == null
            ? ShimmerEffect.instance.liveClassDetailLoader()
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Course Box
                  Flexible(
                    flex: 8,
                    child: CourseBoxWithDate(
                      showShare: false,
                      dateAndTime: AppConstants.formatDateAndTime(
                          controller.liveClassDetail.value.data?.startTime),
                      courseImage:
                          controller.liveClassDetail.value.data?.preview ?? "",
                      courseName:
                          controller.liveClassDetail.value.data?.title ?? "",
                      rating: controller.liveClassDetail.value.data?.rating
                              .toString() ??
                          "",
                    ),
                  ),
                  // Download Section
                  controller.liveClassDetail.value.data?.fileUrl != null &&
                          controller.liveClassDetail.value.data?.fileUrl != ""
                      ? Flexible(
                          flex: 2,
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: DimensionResource.marginSizeDefault,
                                vertical: DimensionResource.marginSizeSmall),
                            child: Obx(() {
                              print(
                                  "fileUrl${controller.liveClassDetail.value.data!.fileUrl}");
                              String videoUrl = controller
                                  .liveClassDetail.value.data!.fileUrl
                                  .toString();
                              // String videoUrl = controller.liveClassDetail.value.data!.title.toString();

                              // Check if the current video is being downloaded or is already downloaded
                              bool isDownloading = liveClassDetailController
                                      .isDownloadingMap[videoUrl] ??
                                  false;
                              // bool isDownloaded = liveClassDetailController.isDownloadedMap[videoUrl] ?? false;
                              double progress = liveClassDetailController
                                      .downloadProgressMap[videoUrl] ??
                                  0.0;
                              String status = liveClassDetailController
                                      .downloadStatusMap[videoUrl] ??
                                  "";

                              return isDownloading
                                  ? Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        // Circular Progress Indicator
                                        Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            // CircularProgressIndicator
                                            CircularProgressIndicator(
                                              value: progress,
                                              strokeWidth: 3,
                                              color: ColorResource.primaryColor,
                                              backgroundColor:
                                                  Colors.grey.shade300,
                                            ),
                                            // Percentage text in the center of the progress indicator
                                            Text(
                                              "${(progress * 100).toStringAsFixed(0)}%",
                                              style: TextStyle(
                                                color:
                                                    ColorResource.primaryColor,
                                                fontSize: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.030,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.01,
                                        ),
                                        // Download Status
                                        Text(
                                          status,
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                            color: Colors.grey.shade600,
                                            fontSize: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.030,
                                          ),
                                        ),
                                      ],
                                    )
                                  : controller.isDownloaded.value
                                      ? Container(
                                          padding: EdgeInsets.all(10),
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color:
                                                  ColorResource.primaryColor),
                                          child: Image.asset(
                                            color: ColorResource.white,
                                            ImageResource.instance.checkIcon,
                                            height: MediaQuery.of(context)
                                                    .size
                                                    .height *
                                                0.02,
                                            fit: BoxFit.contain,
                                          ),
                                        )
                                      : GestureDetector(
                                          onTap: () {
                                            final isTrialCourse = controller
                                                    .liveClassDetail
                                                    .value
                                                    .data
                                                    ?.isTrial ??
                                                0;
                                            final isProUser =
                                                Get.find<AuthService>()
                                                    .isPro
                                                    .value;

                                            if (isTrialCourse == 1 ||
                                                isProUser) {
                                              liveClassDetailController
                                                  .downloadVideo(
                                                controller.liveClassDetail.value
                                                    .data!.fileUrl
                                                    .toString(),
                                                controller.liveClassDetail.value
                                                    .data!.title
                                                    .toString(),
                                                controller.liveClassDetail.value
                                                    .data!.preview
                                                    .toString(),
                                              );
                                            } else {
                                              ProgressDialog().showFlipDialog(
                                                title:
                                                    "Download All Premium Stock Market Content as a Pro User. Continue?",
                                                isForPro:
                                                    !Get.find<AuthService>()
                                                        .isGuestUser
                                                        .value,
                                              );
                                            }
                                          },
                                          child: Container(
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color:
                                                    ColorResource.primaryColor),
                                            child: Image.asset(
                                              ImageResource
                                                  .instance.downloadIcon,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .height *
                                                  0.02,
                                              fit: BoxFit.contain,
                                            ),
                                          ),
                                        );
                            }),
                          ),
                        )
                      : Container(),
                ],
              ),
      ),
      Obx(() {
        return Visibility(
          visible:
              controller.liveClassDetail.value.data?.shortDescription != null,
          child: Padding(
            padding: EdgeInsets.only(
                left: DimensionResource.marginSizeDefault,
                right: DimensionResource.marginSizeDefault,
                top: DimensionResource.marginSizeSmall,
                bottom: controller.isPast.value
                    ? 0
                    : DimensionResource.marginSizeSmall),
            child: descriptionReadMoreText(context,
                controller.liveClassDetail.value.data?.shortDescription ?? ""),
          ),
        );
      }),
      Obx(() {
        // Get `userRole` from `AuthService`
        final authService = Get.find<AuthService>();
        final userRole = authService.userRole.value;
        final isTrailUser = authService.userRole.value ==
            "trial_user"; // New condition for trial user

        DateTime serverDateTime = DateTime.parse(
            controller.liveClassDetail.value.serverTime.toString());

        print("sdkhljfhbjklahuk : ${serverDateTime}");

        return Visibility(
          visible:
              (!controller.isPast.value) && (!controller.isDataLoading.value),
          child: Builder(builder: (context) {
            /// user subscription value
            // UserSubscription? userSub =
            //     Get.find<AuthService>().user.value.userSubscription;

            /// if the user has bought that specific batch.
            // bool isPro = (controller.batchId != null &&
            //             controller.batchDateId != null) &&
            //         (userSub?.batchId == controller.batchId &&
            //             userSub?.batchStartDate == controller.batchDateId) ||
            //     (userSub?.pastSubscription == 1 || userSub?.superSub == 1);
            return Padding(
                padding: EdgeInsets.only(
                    left: DimensionResource.marginSizeDefault,
                    right: DimensionResource.marginSizeDefault,
                    top: 5,
                    bottom: Platform.isIOS
                        ? DimensionResource.marginSizeDefault
                        : 0),
                child: Obx(() => (Get.find<AuthService>().isPro.value &&
                            controller.isRegistered.value) &&
                        !controller.isStarted.value
                    ? CommonContainer(
                        radius: 8,
                        height: 40,
                        color: ColorResource.primaryColor,
                        isDisable: false,
                        loading: controller.isContactLoading.value,
                        onPressed: Get.find<AuthService>().isGuestUser.value
                            ? () =>
                                ProgressDialog().showFlipDialog(isForPro: false)
                            : controller.isStarted.value
                                ? controller.onJoinNow
                                : null,
                        child: controller.isStarted.value
                            ? const Text(
                                "JOIN NOW",
                                style: TextStyle(color: ColorResource.white),
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Starting in ",
                                    style: StyleResource.instance.styleMedium(
                                        fontSize:
                                            DimensionResource.fontSizeLarge - 1,
                                        color: ColorResource.white),
                                  ),
                                  TimerCountDown(
                                    isHrShow: true,
                                    timeInSeconds: controller.liveClassDetail
                                                .value.data?.startTime
                                                ?.difference(serverDateTime)
                                                .inSeconds
                                                .isNegative ??
                                            true
                                        ? 0
                                        : controller.liveClassDetail.value.data
                                                ?.startTime
                                                ?.difference(serverDateTime)
                                                .inSeconds ??
                                            0,
                                    isHrs: true,
                                    fontStyle: StyleResource.instance.styleBold(
                                        fontSize:
                                            DimensionResource.fontSizeDefault +
                                                1,
                                        color: ColorResource.white),
                                    remainingSeconds: (second) {
                                      if (second <= 120) {
                                        EasyDebounce.debounce(
                                            controller.countValue.value
                                                .toString(),
                                            const Duration(milliseconds: 1000),
                                            () async {
                                          controller.isStarted.value = true;
                                        });
                                      }
                                    },
                                  ),
                                ],
                              ))
                    : isTrailUser ||
                            userRole == "pro_expired_user" ||
                            userRole == "trial_expired_user" ||
                            userRole ==
                                "fresh_user" // Condition to show only "Be a Pro" button for trial users
                        ? CommonButton(
                            radius: 8,
                            height: 40,
                            text: "Be a Pro".toUpperCase(),
                            loading: controller.isContactLoading.value,
                            onPressed: () {
                              Get.toNamed(Routes.subscriptionView);
                            },
                            elevation: 3,
                            color: ColorResource.primaryColor,
                          )
                        : CommonButton(
                            radius: 8,
                            height: 40,
                            text: Get.find<AuthService>().isGuestUser.value
                                ? "Sign In Now"
                                : Get.find<AuthService>().isPro.value
                                    ? controller.isStarted.value
                                        ? "JOIN NOW"
                                        : "REGISTER NOW"
                                    : Get.find<RootViewController>()
                                            .isTrial
                                            .value
                                        ? 'be a pro'.toUpperCase()
                                        : 'REGISTER NOW'.toUpperCase(),
                            loading: controller.isContactLoading.value,
                            onPressed: Get.find<AuthService>().isGuestUser.value
                                ? () {
                                    Get.find<LoginController>()
                                        .emailController
                                        .text = "Enter phone number";
                                    Get.offAllNamed(Routes.loginScreen);
                                  }
                                : Get.find<AuthService>().isPro.value &&
                                        Get.find<AuthService>()
                                                .user
                                                .value
                                                .name !=
                                            null
                                    ? controller.isStarted.value
                                        ? controller.onJoinNow
                                        : controller.onRegister
                                    : () {
                                        logPrint("i am kunal");
                                        // Get.toNamed(Routes.subscriptionView,

                                        //     /// to goto batchSubscription
                                        //     arguments: [
                                        //       controller.liveClassDetail.value.data
                                        //           ?.batchId,
                                        //       controller.liveClassDetail.value.data
                                        //           ?.batchStartDate,
                                        //     ]);
                                        Get.find<RootViewController>().getPopUpData2();
                                        // Get.toNamed(Routes.subscriptionView);
                                      },
                            elevation: 3,
                            color: ColorResource.primaryColor,
                          )));
          }),
        );
      }),
      Obx(() {
        Get.put(LoginController());
        return Visibility(
          visible:
              !Get.find<AuthService>().isPro.value && controller.isPast.value,
          child: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  left: DimensionResource.marginSizeDefault,
                  right: DimensionResource.marginSizeDefault,
                  top: 5,
                  bottom:
                      Platform.isIOS ? DimensionResource.marginSizeDefault : 0),
              child: CommonButton(
                radius: 8,
                height: 40,
                text: Get.find<AuthService>().isGuestUser.value
                    ? "Sign In Now"
                    : "Buy now".toUpperCase(),
                loading: controller.isContactLoading.value,
                onPressed: Get.find<AuthService>().isGuestUser.value
                    ? () {
                        Get.find<LoginController>().emailController.text =
                            "Enter phone number";

                        Get.offAllNamed(Routes.loginScreen);
                      }
                    : () => Get.toNamed(Routes.subscriptionView),
                elevation: 3,
                color: ColorResource.primaryColor,
              ),
            );
          }),
        );
      }),
      Obx(() {
        double fontSize = screenWidth < 500 ? 11.0 : 20.0;
        return Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: DimensionResource.marginSizeDefault - 5,
              vertical: DimensionResource.marginSizeExtraSmall + 4),
          child: HtmlCommonWidget(
            fontSize: fontSize,
            htmlData: controller.liveClassDetail.value.data?.description ?? "",
            isDark: false,
          ),
        );
      }),
      Obx(() {
        return Visibility(
          visible: controller.moreLikeData.isNotEmpty,
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: DimensionResource.marginSizeLarge, top: 3),
            child: MoreLikeWidget(
              title: 'Other Past Classes',
              onTap: () {
                if (controller.isPast.value) {
                  Get.back();
                }
                // controller.liveClassId.value = data.id.toString();
                // controller.getCourseById();
              },
              isPast: controller.isPast.value,
              isSeeAllEnable:
                  controller.isPast.value && controller.isSeeAllEnable.value,
              enableTopPadding: false,
              isLiveVideo: true,
              dataList: controller.moreLikeData,
              onItemTap: (data) {
                controller.liveClassId.value = data.id.toString();
                // controller.getLiveDataDetail();
              },
            ),
          ),
        );
      }),
      Obx(() {
        logPrint("id i am 1 hi ${controller.liveClassDetail.value.data?.id}");
        return Visibility(
          visible: controller.isPast.value &&
              controller.liveClassDetail.value.data?.id != null,
          child: Padding(
            padding: const EdgeInsets.only(
                bottom: DimensionResource.marginSizeDefault),
            child: AllRatingAndReviews(
              contest: context,
              courseDatum: CourseDatum(
                  type: "live_class",
                  id: controller.liveClassDetail.value.data?.id.toString() ??
                      "",
                  name: controller.liveClassDetail.value.data?.title ?? "",
                  rating:
                      controller.liveClassDetail.value.data?.rating.toString()),
            ),
          ),
        );
      })
    ];
  }
}

class CourseBoxWithDate extends StatelessWidget {
  final String courseName;
  final String courseImage;
  final String rating;
  final Widget? extraWidget;
  final bool showShare;
  final String dateAndTime;
  final Function()? onShareTap;
  const CourseBoxWithDate({
    required this.rating,
    this.extraWidget,
    this.showShare = true,
    required this.courseImage,
    required this.courseName,
    required this.dateAndTime,
    this.onShareTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault,
          vertical: DimensionResource.marginSizeSmall),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          courseBox(
              courseImage: courseImage,
              courseName: courseName,
              rating: rating,
              showShareIcon: showShare,
              extraWidget: extraWidget,
              onShareTap: onShareTap),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          Text(
            dateAndTime,
            style: StyleResource.instance
                .styleMedium(
                    fontSize: DimensionResource.fontSizeSmall - 1,
                    color: ColorResource.lightDarkColor)
                .copyWith(letterSpacing: .4),
          ),
        ],
      ),
    );
  }
}

class DescriptionWithLabel extends StatelessWidget {
  final String title;
  final String description;
  const DescriptionWithLabel(
      {Key? key, required this.title, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        headlineText(title),
        const SizedBox(
          height: DimensionResource.marginSizeExtraSmall,
        ),
        descriptionText(description),
      ],
    );
  }
}
