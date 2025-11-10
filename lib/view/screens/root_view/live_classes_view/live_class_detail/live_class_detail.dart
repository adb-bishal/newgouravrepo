import 'dart:ffi';
import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stockpathshala_beta/enum/enum.dart';
import 'package:stockpathshala_beta/model/models/common_container_model/common_container_model.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/services/player/file_video_widget.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/text_course_detail_view/widget/more_like_this_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/widget/add_rating_widget.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/image_resource.dart';
import '../../../../../model/utils/string_resource.dart';
import '../../../../../service/utils/download_file_util.dart';
import '../../../../../videoplayer.dart';
import '../../../../../view_model/controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import '../../../../../view_model/controllers/root_view_controller/video_course_detail_controller/video_course_detail_controller.dart';
import '../../../../widgets/view_helpers/progress_dialog.dart';
import '../../../base_view/video_base_view.dart';
import '../../../subscription_view/example_blog.dart';
import '../../home_view/widget/scalps_widget.dart';
import '../../quiz_view/quiz_list.dart';
import '../../text_course_detail_view/text_course_detail_view.dart';
import '../../video_course_detail_view/video_course_detail_view.dart';

class LiveClassDetail extends StatefulWidget {
  const LiveClassDetail({Key? key}) : super(key: key);

  @override
  State<LiveClassDetail> createState() => _LiveClassDetailState();
}

class _LiveClassDetailState extends State<LiveClassDetail> {
  @override
  Widget build(BuildContext context) {
    Get.put(LiveClassDetailController());

    return VideoBaseView(
      screenType: AppConstants.liveClass,
      isDataLoading: false.obs,
      viewControl: LiveClassDetailController(),
      onBackClicked: (context, controller) {
        Get.back();
      },
      actionBuilder: (context, controller) => [],
      onVideoBuilder: (context, controller) => Obx(() {
        final authService = Get.find<AuthService>();

        bool canPlayVideo = false;
        bool isMatch = false;
        String? localVideoPath;

        if (authService.userRole.value == "pro_user") {
          canPlayVideo = true; // Pro user can play the video
        } else if (authService.userRole.value == "trial_user" &&
            controller.liveClassDetail.value.data?.isTrial == 1) {
          canPlayVideo =
              true; // Trial user with active trial can play the video
        }

        isMatch = controller.videos.any((video) =>
            video.title.trim().toLowerCase() ==
            controller.liveClassDetail.value.data?.title?.trim().toLowerCase());

        localVideoPath = isMatch
            ? controller.videos
                .firstWhere((video) =>
                    video.title.trim().toLowerCase() ==
                    controller.liveClassDetail.value.data?.title
                        ?.trim()
                        .toLowerCase())
                .path
            : null;

        // Render the video based on `canPlayVideo` and local video availability
        if (canPlayVideo && controller.isPast.value) {
          print(
              "imagefilw${controller.liveClassDetail.value.data?.image ?? ""}");
          return localVideoPath != null
              ? FileVideoWidget(
                  showQualityPicker: false,
                  url: localVideoPath!,
                  watchedTime:
                      controller.liveClassDetail.value.data?.lastWatchedSecond,
                  thumbnail: controller.liveClassDetail.value.data?.preview,
                  eventCallBack: (progress, totalDuration) {
                    print("progress $progress $totalDuration");
                    if (progress != 0 &&
                        progress < totalDuration &&
                        progress % 10 == 0) {
                      Future.sync(() {
                        controller.sendVideoTime(progress, totalDuration);
                      });
                    }

                    if (progress == totalDuration) {
                      Future.sync(() {
                        controller.sendVideoTime(progress, totalDuration);
                      });
                    }
                  },
                )
              : (controller.liveClassDetail.value.data?.fileUrl == null ||
                      controller.liveClassDetail.value.data?.fileUrl == "")
                  ? SizedBox(
                      width: double.infinity,
                      child: controller.liveClassDetail.value.data == null
                          ? ShimmerEffect.instance.imageLoader(
                              color: Colors.white, radius: BorderRadius.zero)
                          : cachedNetworkImage(
                              controller.liveClassDetail.value.data?.image ??
                                  "",
                            ),
                    )
                  : FileVideoWidget(
                      showQualityPicker: !controller.isPast.value,
                      url: controller.liveClassDetail.value.data?.fileUrl ?? "",
                      thumbnail: controller.liveClassDetail.value.data?.preview,
                      watchedTime: controller
                          .liveClassDetail.value.data?.lastWatchedSecond,
                      eventCallBack: (progress, totalDuration) {
                        print("progress $progress $totalDuration");
                        if (progress != 0 &&
                            progress < totalDuration &&
                            progress % 10 == 0) {
                          Future.sync(() {
                            controller.sendVideoTime(progress, totalDuration);
                          });
                        }

                        if (progress == totalDuration) {
                          Future.sync(() {
                            controller.sendVideoTime(progress, totalDuration);
                          });
                        }
                      },
                    );
        } else {
          return SizedBox(
            child: controller.liveClassDetail.value.data == null
                ? ShimmerEffect.instance
                    .imageLoader(color: Colors.white, radius: BorderRadius.zero)
                : cachedNetworkImage(
                    controller.liveClassDetail.value.data?.image ?? "",
                    fit: BoxFit.contain,
                  ),
          );
        }
      }),
      onPageBuilder: (context, controller) {
        return mainBodyBuilder(context, controller);
      },
    );
  }

  //code for the course detail
  List<Widget> mainBodyBuilder(
      BuildContext context, LiveClassDetailController controller) {
    final screenWidth = MediaQuery.of(context).size.width;

    final LiveClassDetailController liveClassDetailController =
        Get.put(LiveClassDetailController());

    var expiredPopup =
        Get.find<LiveClassesController>().liveData.value.data?.expiredUserPopup;

    final ui = Get.find<LiveClassesController>().liveData.value?.cardUi;

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
        print(
            "descrptions ${controller.liveClassDetail.value.data?.shortDescription ?? ""}");
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
      // Obx(
      //         () {
      //       return Visibility(
      //         visible:(!controller.isPast.value) && (!Get.find<AuthService>().isGuestUser.value && (Get.find<AuthService>().user.value.liveCount != null && Get.find<AuthService>().user.value.liveCount != 0) && !Get.find<AuthService>().isPro.value),
      //         child: Padding(
      //           padding: const EdgeInsets.only(
      //               top: 15),
      //           child: UserAccessWidget(isPro: !Get.find<AuthService>().isPro.value,)
      //         ),
      //       );
      //     }
      // ),
      Obx(() {
        Get.put(LoginController());

        return Visibility(
          visible:
              (!controller.isPast.value) && (!controller.isDataLoading.value),
          child: Builder(builder: (context) {
            return Padding(
              padding: EdgeInsets.only(
                  left: screenWidth < 500
                      ? DimensionResource.marginSizeDefault
                      : DimensionResource.marginSizeOverExtraLarge,
                  right: screenWidth < 500
                      ? DimensionResource.marginSizeDefault
                      : DimensionResource.marginSizeOverExtraLarge,
                  top: screenWidth < 500 ? 5 : 20,
                  bottom:
                      Platform.isIOS ? DimensionResource.marginSizeDefault : 0),
              child: Obx(() => controller.isRegistered.value &&
                      !controller.isStarted.value
                  ? CommonContainer(
                      radius: 8,
                      height: screenWidth < 500 ? 40 : 50,
                      color: Get.find<AuthService>().isGuestUser.value
                          ? ColorResource.primaryColor
                          : (userRole == "pro_user" || userRole == "trial_user")
                              ? controller.isStarted.value
                                  ? hexToColor(ui?.joinButtonColor)
                                  : hexToColor(ui?.timerButtonColor)
                              : !['trial_user', 'pro_user', 'fresh_user']
                                      .contains(userRole)
                                  ? hexToColor(ui?.unlockButtonColor)
                                  : hexToColor(ui?.registerButtonColor),
                      isDisable: false,
                      loading: controller.isContactLoading.value,
                      onPressed: Get.find<AuthService>().isGuestUser.value
                          ? () {
                              print("classs ${controller.liveClassId.value}");
                              ProgressDialog().showFlipDialog(
                                  isForPro: false,
                                  name: CommonEnum.liveClassDetail.name,
                                  data: controller.liveClassId.value);
                            }
                          : controller.isStarted.value
                              ? controller.onJoinNow
                              : () {},
                      child: (userRole == "pro_user" ||
                              userRole == "trial_user")
                          ? controller.isStarted.value
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
                                              DimensionResource.fontSizeLarge -
                                                  1,
                                          color: ColorResource.white),
                                    ),
                                    TimerCountDown(
                                      isHrShow: true,
                                      timeInSeconds: controller.liveClassDetail
                                                  .value.data?.startTime
                                                  ?.difference(DateTime.parse(
                                                      controller.liveClassDetail
                                                          .value.serverTime
                                                          .toString()))
                                                  .inSeconds
                                                  .isNegative ??
                                              true
                                          ? 0
                                          : controller.liveClassDetail.value
                                                  .data?.startTime
                                                  ?.difference(DateTime.parse(
                                                      controller.liveClassDetail
                                                          .value.serverTime
                                                          .toString()))
                                                  .inSeconds ??
                                              0,
                                      isHrs: true,
                                      fontStyle: StyleResource.instance
                                          .styleBold(
                                              fontSize: DimensionResource
                                                      .fontSizeDefault +
                                                  1,
                                              color: ColorResource.white),
                                      remainingSeconds: (second) {
                                        if (second <= 120) {
                                          EasyDebounce.debounce(
                                              controller.countValue.value
                                                  .toString(),
                                              const Duration(
                                                  milliseconds: 1000),
                                              () async {
                                            controller.isStarted.value = true;
                                          });
                                        }
                                      },
                                    ),
                                  ],
                                )
                          : CommonButton(
                              radius: 15,
                              height: 40,
                              text: Get.find<AuthService>().isGuestUser.value
                                  ? "Sign In Now"
                                  : (userRole == "pro_user" ||
                                          userRole == "trial_user")
                                      ? controller.isStarted.value
                                          ? "JOIN NOW"
                                          : "REGISTER NOW"
                                      : ![
                                          'trial_user',
                                          'pro_user',
                                          'fresh_user'
                                        ].contains(userRole)
                                          ? 'UNLOCK IT'.toUpperCase()
                                          : 'REGISTER NOW'.toUpperCase(),
                              loading: controller.isContactLoading.value,
                              onPressed: Get.find<AuthService>()
                                      .isGuestUser
                                      .value
                                  ? () {
                                      print(
                                          "classs ${controller.liveClassId.value}");
                                      ProgressDialog().showFlipDialog(
                                          isForPro: false,
                                          name: CommonEnum.liveClassDetail.name,
                                          data: controller.liveClassId.value);
                                      // Get.find<LoginController>()
                                      //     .emailController
                                      //     .text = "Enter phone number";
                                      // Get.offAllNamed(Routes.loginScreen);
                                    }
                                  : controller.isStarted.value
                                      ? controller.onJoinNow
                                      // : ,
                                      : () {
                                          (userRole != "trial_user" ||
                                                  userRole != "pro_user")
                                              ? Get.find<RootViewController>()
                                                  .getPopUpData2(
                                                      title:
                                                          expiredPopup?.title,
                                                      subtitle: expiredPopup
                                                          ?.subtitle,
                                                      imageUrl: expiredPopup
                                                          ?.imageUrl,
                                                      buttonTitle: expiredPopup
                                                          ?.buttonTitle)
                                              : controller.onRegister();
                                        },
                              // elevation: 3,
                              color: Get.find<AuthService>().isGuestUser.value
                                  ? ColorResource.primaryColor
                                  : (userRole == "pro_user" ||
                                          userRole == "trial_user")
                                      ? controller.isStarted.value
                                          ? hexToColor(ui?.joinButtonColor)
                                          : hexToColor(ui?.registerButtonColor)
                                      : ![
                                          'trial_user',
                                          'pro_user',
                                          'fresh_user'
                                        ].contains(userRole)
                                          ? hexToColor(ui?.unlockButtonColor)
                                          : hexToColor(ui?.registerButtonColor),
                              icon: Get.find<AuthService>().isGuestUser.value
                                  ? Icons.person
                                  : (userRole == "pro_user" ||
                                          userRole == "trial_user")
                                      ? controller.isStarted.value
                                          ? Icons.play_circle_outline_rounded
                                          : Icons.thumb_up_sharp
                                      : ![
                                          'trial_user',
                                          'pro_user',
                                          'fresh_user'
                                        ].contains(userRole)
                                          ? Icons.lock_outline_rounded
                                          : Icons.thumb_up_sharp))
                  : CommonButton(
                      radius: 8,
                      height: 40,
                      text: Get.find<AuthService>().isGuestUser.value
                          ? "Sign In Now"
                          : (userRole == "pro_user" || userRole == "trial_user")
                              ? controller.isStarted.value
                                  ? "JOIN NOW"
                                  : "REGISTER NOW"
                              : !['trial_user', 'pro_user', 'fresh_user']
                                      .contains(userRole)
                                  ? 'UNLOCK IT'.toUpperCase()
                                  : 'REGISTER NOW'.toUpperCase(),
                      loading: controller.isContactLoading.value,
                      onPressed: Get.find<AuthService>().isGuestUser.value
                          ? () {
                              print("classs ${controller.liveClassId.value}");
                              // ProgressDialog().showFlipDialog(isForPro: false,name: CommonEnum.liveClassDetail.name
                              //     ,data: controller.liveClassId.value);
                              final box = GetStorage();
                              box.write(CommonEnum.liveClassDetail.name,
                                  controller.liveClassId.value);
                              Get.put(LoginController());
                              Get.find<LoginController>().emailController.text =
                                  "Enter phone number";
                              Get.offAllNamed(Routes.loginScreen);
                              //
                              // Get.find<LoginController>().emailController.text =
                              //     "Enter phone number";
                              // Get.offAllNamed(Routes.loginScreen);
                            }
                          : controller.isStarted.value
                              ? controller.onJoinNow
                              // : ,
                              : () => {
                                    (userRole != "trial_user" &&
                                            userRole != "pro_user")
                                        ? Get.find<RootViewController>()
                                            .getPopUpData2(
                                                title: expiredPopup?.title,
                                                subtitle:
                                                    expiredPopup?.subtitle,
                                                imageUrl:
                                                    expiredPopup?.imageUrl,
                                                buttonTitle:
                                                    expiredPopup?.buttonTitle)
                                        : Get.find<AuthService>()
                                                    .user
                                                    .value
                                                    .name ==
                                                null
                                            ? Get.find<RootViewController>()
                                                .getPopUpData2(
                                                    title: expiredPopup?.title,
                                                    subtitle:
                                                        expiredPopup?.subtitle,
                                                    imageUrl:
                                                        expiredPopup?.imageUrl,
                                                    buttonTitle: expiredPopup
                                                        ?.buttonTitle)
                                            // Get.find<RootViewController>()
                                            //     .showSucessDialog(
                                            //         RootViewController
                                            //             .promptData,
                                            //         true,
                                            //         RootViewController.bgData)
                                            : controller.onRegister()
                                  },
                      // elevation: 3,
                      color: Get.find<AuthService>().isGuestUser.value
                          ? ColorResource.primaryColor
                          : (userRole == "pro_user" || userRole == "trial_user")
                              ? controller.isStarted.value
                                  ? hexToColor(ui?.joinButtonColor)
                                  : hexToColor(ui?.registerButtonColor)
                              : !['trial_user', 'pro_user', 'fresh_user']
                                      .contains(userRole)
                                  ? hexToColor(ui?.unlockButtonColor)
                                  : hexToColor(ui?.registerButtonColor),
                      icon: Get.find<AuthService>().isGuestUser.value
                          ? Icons.person
                          : (userRole == "pro_user" || userRole == "trial_user")
                              ? controller.isStarted.value
                                  ? Icons.play_circle_outline_rounded
                                  : Icons.thumb_up_sharp
                              : !['trial_user', 'pro_user', 'fresh_user']
                                      .contains(userRole)
                                  ? Icons.lock_outline_rounded
                                  : Icons.thumb_up_sharp)),
            );
          }),
        );
      }),

      Obx(() {
        // Get the `userRole` from AuthService
        final authService = Get.find<AuthService>();
        String userRole = authService.userRole.value;

        return Visibility(
          // visible:
          //     !Get.find<AuthService>().isPro.value && controller.isPast.value ,
          visible: userRole != "pro_user" && controller.isPast.value,
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
                      : (userRole != "pro_user" ? "UNLOCK" : ""),
                  loading: controller.isContactLoading.value,
                  onPressed: Get.find<AuthService>().isGuestUser.value
                      ? () => Get.offAllNamed(Routes.loginScreen)
                      : () => Get.find<RootViewController>().getPopUpData2(
                          title: expiredPopup?.title,
                          subtitle: expiredPopup?.subtitle,
                          imageUrl: expiredPopup?.imageUrl,
                          buttonTitle: expiredPopup?.buttonTitle),
                  // elevation: 3,
                  color: Get.find<AuthService>().isGuestUser.value
                      ? ColorResource.primaryColor
                      : (userRole == "pro_user" || userRole == "trial_user")
                          ? controller.isStarted.value
                              ? hexToColor(ui?.joinButtonColor)
                              : hexToColor(ui?.registerButtonColor)
                          : !['trial_user', 'pro_user', 'fresh_user']
                                  .contains(userRole)
                              ? hexToColor(ui?.unlockButtonColor)
                              : hexToColor(ui?.registerButtonColor),
                  icon: Get.find<AuthService>().isGuestUser.value
                      ? Icons.person
                      : (userRole == "pro_user" || userRole == "trial_user")
                          ? controller.isStarted.value
                              ? Icons.play_circle_outline_rounded
                              : Icons.thumb_up_sharp
                          : !['trial_user', 'pro_user', 'fresh_user']
                                  .contains(userRole)
                              ? Icons.lock_outline_rounded
                              : Icons.thumb_up_sharp),
            );
          }),
        );
      }),

      Obx(() {
        print(
            "objectdescription: ${controller.liveClassDetail.value.data?.description ?? ""}");
        // Dynamically determine font size based on screen width
        double fontSize = screenWidth < 500 ? 11.0 : 20.0;

        return Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth < 500
                ? DimensionResource.marginSizeDefault - 5
                : DimensionResource.marginSizeExtraLarge,
            vertical: screenWidth < 500
                ? DimensionResource.marginSizeExtraSmall + 4
                : DimensionResource.marginSizeLarge,
          ),
          child: HtmlCommonWidget(
            htmlData: controller.liveClassDetail.value.data?.description ?? "",
            isDark: false,
            fontSize: fontSize, // Pass the calculated font size
          ),
        );
      }),

      SizedBox(height: 30),

      Obx(() {
        final screenWidth = MediaQuery.of(context).size.width;

        final teacher = controller.liveClassDetail.value.data?.teacher;
        final uiData = controller.liveClassDetail.value.data?.ui_data;

        // Logs for debugging
        print("Trading Style: ${teacher?.tradingStyle}");
        print("Tutor Detail Title: ${uiData?.tutor_detail_title}");

        return Card(
          color: Colors.white,
          child: Padding(
            padding: EdgeInsets.all(screenWidth < 500 ? 8.0 : 10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Text(
                    uiData?.tutor_detail_title ?? "Meet your tutor",
                    style: TextStyle(
                      fontSize: screenWidth < 500 ? 18 : 28,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: screenWidth < 500 ? 8 : 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Profile Image with proper null handling
                    Container(
                      width: (screenWidth > 500 ? 60 : 50) * 2,
                      height: (screenWidth > 500 ? 70 : 50) * 2,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.grey[300], // Fallback color
                        image: (teacher?.profileImage != null &&
                                teacher!.profileImage!.isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(teacher.profileImage!),
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: (teacher?.profileImage == null ||
                              teacher!.profileImage!.isEmpty)
                          ? Icon(Icons.person,
                              size: screenWidth > 500 ? 40 : 30,
                              color: Colors.grey[600])
                          : null,
                    ),
                    SizedBox(width: screenWidth < 500 ? 10 : 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Teacher Name
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              teacher?.name ?? "",
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: screenWidth > 500 ? 20 : 14,
                              ),
                            ),
                          ),
                          SizedBox(height: 3),
                          // Experience
                          Row(
                            children: [
                              Icon(Icons.check_circle_outlined,
                                  color: Colors.green, size: 15),
                              SizedBox(width: 5),
                              Text(
                                "${teacher?.totalExperience ?? ""}+ Years Trading Experience",
                                style: TextStyle(
                                  fontSize: screenWidth > 500 ? 18 : 12,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                          // Expertise (if available)
                          if ((teacher?.expertise ?? "").isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.check_circle_outlined,
                                    color: Colors.green, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  teacher!.expertise!,
                                  style: TextStyle(
                                    fontSize: screenWidth > 500 ? 18 : 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          // Teaching Hours (if available)
                          if (teacher?.teachingHours != null)
                            Row(
                              children: [
                                Icon(Icons.check_circle_outlined,
                                    color: Colors.green, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  "${teacher!.teachingHours}+ Hours of Teaching",
                                  style: TextStyle(
                                    fontSize: screenWidth > 500 ? 18 : 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          // Trading Style (if available)
                          if ((teacher?.tradingStyle ?? "").isNotEmpty)
                            Row(
                              children: [
                                Icon(Icons.check_circle_outlined,
                                    color: Colors.green, size: 15),
                                SizedBox(width: 5),
                                Text(
                                  teacher!.tradingStyle!,
                                  style: TextStyle(
                                    fontSize: screenWidth > 500 ? 18 : 12,
                                    fontWeight: FontWeight.w400,
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(height: 5),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
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
              onTap: () {
                if (controller.isPast.value) {
                  Get.offNamed(Routes.pastLiveClass);
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
        logPrint("id i am 1 ${controller.liveClassDetail.value.data?.id}");
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

// class AutoRotateChecker {
//     static const platform = MethodChannel("system_settings_channel");
//     static Future<bool?> checkAutoRotateStatus() async {
//         try{
//           final bool result = await platform.invokeMethod('checkAutoRotateToggle');
//           return result;
//         } on PlatformException catch (e) {
//           print("Failed to get auto-rotate status: '${e.message}'");
//           return null;
//         }
//     }
// }
class CourseBoxWithDate extends StatelessWidget {
  final String courseName;
  final String courseImage;
  final String rating;
  final bool showShare;
  final Widget? extraWidget;
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
    final screenWidth = MediaQuery.of(context).size.width;
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
          SizedBox(
            height: screenWidth < 500
                ? DimensionResource.marginSizeSmall
                : DimensionResource.marginSizeDefault,
          ),
          Text(
            dateAndTime,
            style: StyleResource.instance
                .styleMedium(
                    fontSize: screenWidth < 500
                        ? DimensionResource.fontSizeSmall - 1
                        : DimensionResource.fontSizeLarge,
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
