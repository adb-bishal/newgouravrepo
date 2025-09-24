import 'dart:math';

import 'package:better_player/better_player.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:stockpathshala_beta/api_service.dart';
import 'package:stockpathshala_beta/model/models/live_class_model/live_class_detail_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/network_info.dart';
import 'package:stockpathshala_beta/model/network_calls/connectivity_helper/connectivity_helper.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/service/utils/download_file_util.dart';
import 'package:stockpathshala_beta/service/video_hls_player/lecle_yoyo_player.dart';
import 'package:stockpathshala_beta/view/screens/root_view/widget/add_rating_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/widget_controllers/show_rating_controller.dart';
import '../../../../model/models/course_models/course_by_id_model.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/services/download_service/download_file.dart';
import '../../../../model/services/player/file_video_widget.dart';
import '../../../../model/services/player/video_player_widget.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/helper_util.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../service/floor/entity/download.dart';
import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/courses_view_controller/courses_view_controller.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import '../../../../view_model/controllers/root_view_controller/video_course_detail_controller/video_course_detail_controller.dart';
import '../../../../view_model/routes/app_pages.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';
import '../../base_view/video_base_view.dart';
import '../audio_course_detail_view/audio_course_detail_view.dart';
import '../home_view/widget/scalps_widget.dart';
import '../text_course_detail_view/text_course_detail_view.dart';
import '../text_course_detail_view/widget/more_like_this_widget.dart';

class VideoCourseDetailView extends StatefulWidget {
  const VideoCourseDetailView({super.key});

  @override
  State<VideoCourseDetailView> createState() => _VideoCourseDetailViewState();
}

class _VideoCourseDetailViewState extends State<VideoCourseDetailView>
    with TickerProviderStateMixin {
  void downloadCertificate(String url, String title, bool isDisable,
      Function(DownloadStatus) onListen) async {
    if (isDisable) {
      toastShow(message: StringResource.onDownloadButton);
    } else {
      await HelperUtil.instance.openUrlFunction(
          courseId: url, courseName: title, onListen: onListen);
    }
  }

  // final NetworkInfo networkInfo = NetworkInfo(Connectivity());

  @override
  Widget build(BuildContext context) {
    TabController tabController = TabController(length: 2, vsync: this);

    final authService = Get.find<AuthService>();
    String userRole = authService.userRole.value;
    final isProuser = userRole == "pro_user";
    final isTrialUser = userRole == "trial_user";

    logPrint("------Is Pro user----" + isProuser.toString());
    final showRatingController = Get.put(ShowRatingController(
        data: CourseDatum(id: "course_id", type: "videoCourse")));
    Get.put(AuthService());
    // final VideoPlayerController controller2 = Get.put(VideoPlayerController());
    // VideoCourseDetailController controller = Get.put<VideoCourseDetailController>(VideoCourseDetailController(),tag: "${DateTime.now().microsecond}");
    return VideoBaseView(
      screenType: AppConstants.videoCourse,
      isDataLoading: false.obs,
      actionBuilder: (context, controller) => [],
      viewControl: VideoCourseDetailController(),
      onBackClicked: (context, controller) {
        Get.back();
      },
      onVideoBuilder: (context, controller) {
        return Obx(() {
          bool canPlayVideo = false;

          // Check if the video should play based on userRole and isTrial
          if (userRole == "pro_user") {
            // Pro user can play the video
            canPlayVideo = true;
          } else if (userRole == "trial_user" &&
              controller.courseData.value.data?.isTrialCourse == 1) {
            // Trial user with active trial can play the video
            canPlayVideo = true;
          }


          print('sdcwdcws ${controller.selectedVideo.value.courseContent?.fileUrl}');
          return controller.isSelectedVideoChange.value
              ? const CommonCircularIndicator()
              : canPlayVideo == false ||
                      (Get.find<AuthService>().isGuestUser.value) ||
                      //             (!Get.find<AuthService>().isPro.value &&
                      //                 controller.courseData.value.data?.isFree != 1
                      //             )
                      //                 ||
                      (
                          (controller.selectedVideo.value.courseContent?.fileUrl == null ||
                              controller.selectedVideo.value.courseContent?.fileUrl == "")

                      )
                  ? controller.courseData.value.data?.image == null
                      ? const CommonCircularIndicator()
                      : cachedNetworkImage(
                          controller.courseData.value.data?.image ?? "")
                  : controller.selectedVideo.value.fileType == "Url"
                      ? YouTubePlayerWidget(
                          url: controller.selectedVideo.value.fileUrl ?? "",
                          eventCallBack: (event, totalDuration) async {
                            if (totalDuration - 60 <= event &&
                                controller.selectedVideo.value.id != null) {
                              if (controller.isHistoryUpload.value) {
                                controller.postCourseHistory(
                                    subCourseId:
                                        controller.selectedVideo.value.id ??
                                            "");
                                controller.getCourseStatus();
                                controller.updateVideoStatus(status: "1");
                                controller.isHistoryUpload.value = false;
                              }
                            }
                            if (totalDuration - 80 <= event) {
                              controller.isHistoryUpload.value = true;
                            }
                            if (event >= 5 &&
                                controller.selectedVideo.value.id != null) {
                              if (controller.isHistoryUpload.value) {
                                controller.updateVideoStatus(status: "0");
                                controller.isHistoryUpload.value = false;
                              }
                            }
                          },
                        )
                      : FileVideoWidget(
                          isVideo: controller.downloadStatus.value !=
                              DownloadingStatus.downloaded,
                          showQualityPicker: controller.downloadStatus.value !=
                              DownloadingStatus.downloaded,
                          url: controller.selectedVideo.value.courseContent!.fileUrl,
                          eventCallBack: (progress, totalDuration) async {
                            if (controller.selectedVideo.value.id != null) {
                              int duration = Duration(
                                      minutes: controller
                                              .selectedVideo.value.duration ??
                                          0)
                                  .inSeconds;
                              if (duration - 60 <= progress) {
                                if (controller.isHistoryUpload.value) {
                                  controller.postCourseHistory(
                                      subCourseId:
                                          controller.selectedVideo.value.id ??
                                              "");

                                  controller.updateVideoStatus(status: "1");
                                  controller.isHistoryUpload.value = false;
                                }
                              }
                            }
                            if (totalDuration - 80 <= progress) {
                              controller.isHistoryUpload.value = true;
                            }
                            if (progress >= 5 &&
                                controller.selectedVideo.value.id != null) {
                              if (controller.isHistoryUpload.value) {
                                controller.updateVideoStatus(status: "0");
                                controller.isHistoryUpload.value = false;
                              }
                            }

                            // if (totalDuration - 2 <= progress) {
                            //   if ((controller.videoIndex.value + 1) ==
                            //       controller.courseDataList.length) {
                            //     logPrint("i am at last video");
                            //   } else {
                            //     if (controller.videoIndex.value <
                            //         controller.courseDataList.length) {
                            //       logPrint("i am called");
                            //       controller.videoIndex.value =
                            //           controller.videoIndex.value + 1;
                            //       controller.autoStartVideo();
                            //     } else {
                            //       logPrint("i am at last video");
                            //       //
                            //     }
                            //   }
                            // }
                          },
                        );
        });
      },
      onPageBuilder: (context, controller) =>
          mainBodyBuilder(context, controller, tabController),
    );
  }

  List<Widget> mainBodyBuilder(BuildContext context,
      VideoCourseDetailController controller, TabController tabController) {
    final authService = Get.find<AuthService>();
    final userRole = authService.userRole.value;
    final LiveClassDetailController liveClassDetailController =
        Get.put(LiveClassDetailController());
    final CoursesViewController coursesViewController =
        Get.put(CoursesViewController());

    return [
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault,
            vertical: DimensionResource.marginSizeSmall),
        child: Obx(() {
          return controller.courseDataList.isEmpty
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.70),
                      height: 36,
                      child: ShimmerEffect.instance.courseTileShimmer(),
                    ),
                    SizedBox(
                      width: 22,
                      height: 26,
                      child: ShimmerEffect.instance.courseTileShimmer(),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        controller.courseName.value,
                        // controller.courseData.value.data?.courseTitle ??
                        //     controller.offlineVideoCourseData?.name ??
                        //     "",
                        style: const TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16),
                      ),
                    ),
                    Obx(() => IconButton(
                        onPressed: () {
                          Get.find<AuthService>().isGuestUser.value
                              ? Get.find<RootViewController>().getPopUpData2()
                              : controller.onWatchLater();
                        },
                        icon: Icon(
                          controller.courseData.value.data?.isWishlist?.value ==
                                  1
                              ? Icons.bookmark
                              : Icons.bookmark_border,
                          color: Colors.black,
                        )))
                  ],
                );

          // courseBox(
          //     courseImage: controller.courseData.value.data?.thumbnails ??
          //         controller.offlineVideoCourseData?.imagePath ??
          //         "",
          //     courseName: controller.courseData.value.data?.courseTitle ??
          //         controller.offlineVideoCourseData?.name ??
          //         "",
          //     rating:
          //         controller.courseData.value.data?.avgRating.toString() ?? "");
        }),
      ),

      Obx(
        () => controller.courseDataList.isEmpty
            ? Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DimensionResource.marginSizeLarge,
                    vertical: DimensionResource.marginSizeSmall),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  height: 24,
                  child: ShimmerEffect.instance.courseTileShimmer(),
                ))
            : Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DimensionResource.marginSizeLarge,
                    vertical: DimensionResource.marginSizeSmall),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/icons/to-do-list.png",
                          color: ColorResource.primaryColor,
                          height: 20,
                        ),
                        Text(
                          " ${controller.courseData.value.data?.courseDetailCount} Videos",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/icons/clock.png",
                          height: 20,
                          color: ColorResource.primaryColor,
                        ),
                        Text(
                          " ${controller.courseData.value.data?.duration?.split("Duration")[1]}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Image.asset(
                          "assets/images/icons/language.png",
                          height: 22,
                          color: ColorResource.primaryColor,
                        ),
                        Text(
                          "  ${controller.courseData.value.data?.language?.languageName}",
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
      ),

      // const SizedBox(
      //   height: DimensionResource.marginSizeDefault,
      // ),

      Row(mainAxisAlignment: MainAxisAlignment.start, children: [
        Obx(() {
          return
              // Visibility(
              //   visible: controller.courseData.value.data?.description != null,
              //   child:
              controller.courseDataList.isEmpty
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensionResource.marginSizeLarge,
                          vertical: DimensionResource.marginSizeSmall),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width - 40,
                        height: 42,
                        child: ShimmerEffect.instance.courseTileShimmer(),
                      ))
                  : Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: DimensionResource.marginSizeDefault,
                            vertical: DimensionResource.marginSizeDefault),
                        child: descriptionReadMoreText(context , controller
                                .courseData.value.data?.description
                                .toString()
                                .capitalize ??
                            ""),
                      ),
                    );
          // );
        }),
      ]),

      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault,
            vertical: DimensionResource.fontSizeSmall),
        child: Obx(
          () => controller.courseDataList.isEmpty
              ? Row(
                  children: [
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: double.infinity,
                          height: 26,
                          child: ShimmerEffect.instance.courseTileShimmer(),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: SizedBox(
                          width: double.infinity,
                          height: 26,
                          child: ShimmerEffect.instance.courseTileShimmer(),
                        ),
                      ),
                    ),
                  ],
                )
              : Row(
                  children: [
                    // In your widget tree, use `Obx` to observe `downloadStatus`:
                    Obx(
                      () => controller
                                  .selectedVideo.value.courseContent?.fileUrl
                                  ?.toString()
                                  .endsWith(".mp4") ??
                              false
                          ? Expanded(
                              child: controller.downloadStatus.value ==
                                      DownloadingStatus.started
                                  ? LoaderButtonLayout(
                                      onTap: () {},
                                      iconSize: 16,
                                      allPadding: 4,
                                      iconColor: ColorResource.primaryColor,
                                    )
                                  : FunctionalityRowBuild(
                                      isRestart:
                                          controller.downloadStatus.value ==
                                              DownloadingStatus.reDownload,
                                      isPaid: controller
                                              .courseData.value.data?.isFree !=
                                          1,
                                      isDone: controller.downloadStatus.value ==
                                          DownloadingStatus.downloaded,
                                      bgColor: ColorResource.primaryColor,
                                      icon: ImageResource.instance.downloadIcon,
                                      title: StringResource.download,
                                      onTap: () {
                                        final isTrialCourse = controller
                                                .courseData
                                                .value
                                                .data
                                                ?.isTrialCourse ??
                                            0;
                                        final isProUser =
                                            Get.find<AuthService>().isPro.value;
                                        final isTrialUser =
                                            Get.find<AuthService>()
                                                .isTrial
                                                .value;
                                        final isGuestUser =
                                            Get.find<AuthService>()
                                                .isGuestUser
                                                .value;

                                        if (isTrialCourse == 1 || isProUser) {
                                          controller.onDownloadClicked();
                                        } else if (isTrialUser &&
                                            isTrialCourse == 0) {
                                          ProgressDialog().showFlipDialog(
                                            title:
                                                "Download All Premium Stock Market Content as a Pro User. Continue?",
                                            isForPro: !isGuestUser,
                                          );
                                        } else {
                                          print('fvsdcs ${controller.courseData.value.data?.expiredUserPopup?.title}');
                                          var expiredUserPopup = controller.courseData.value.data?.expiredUserPopup;
                                          Get.find<RootViewController>().getPopUpData2(title: expiredUserPopup?.title,subtitle: expiredUserPopup?.subtitle,buttonTitle: expiredUserPopup?.buttonTitle,imageUrl: expiredUserPopup?.imageUrl);

                                        }
                                      },
                                    ),
                            )
                          : Container(),
                    ),

                    // controller.selectedVideo.value.courseContent?.fileUrl
                    //             ?.toString()
                    //             .endsWith(".mp4") ??
                    //         false
                    //     ? Expanded(
                    //         child: controller.downloadStatus.value ==
                    //                 DownloadingStatus.started
                    //
                    //             ? LoaderButtonLayout(
                    //                 onTap: () {},
                    //                 iconSize: 16,
                    //                 allPadding: 4,
                    //                 iconColor: ColorResource.primaryColor,
                    //               )
                    //             : FunctionalityRowBuild(
                    //                 isRestart:
                    //                     controller.downloadStatus.value ==
                    //                         DownloadingStatus.reDownload,
                    //                 isPaid: controller
                    //                         .courseData.value.data?.isFree !=
                    //                     1,
                    //                 isDone: controller.downloadStatus.value ==
                    //                     DownloadingStatus.downloaded,
                    //                 bgColor: ColorResource.primaryColor,
                    //                 icon: ImageResource.instance.downloadIcon,
                    //                 title: StringResource.download,
                    //                 onTap: () {
                    //                   print(
                    //                       'secwec ${controller.courseData.value.data?.isTrialCourse}');
                    //                   if (controller.courseData.value.data
                    //                               ?.isTrialCourse ==
                    //                           1 ||
                    //                       Get.find<AuthService>().isPro.value) {
                    //                     controller.onDownloadClicked();
                    //                   } else if (Get.find<AuthService>()
                    //                           .isTrial
                    //                           .value &&
                    //                       controller.courseData.value.data
                    //                               ?.isTrialCourse ==
                    //                           0) {
                    //                     ProgressDialog().showFlipDialog(
                    //                         title:
                    //                             "Download All Premium Stock Market Content as a Pro User. Continue?",
                    //                         isForPro: Get.find<AuthService>()
                    //                                 .isGuestUser
                    //                                 .value
                    //                             ? false
                    //                             : true);
                    //                   } else {
                    //                     print('sewesve');
                    //                     Get.find<RootViewController>()
                    //                         .getPopUpData2();
                    //                   }
                    //                 },
                    //               ),
                    //       )
                    //     : Container(),

                    const SizedBox(
                      width: DimensionResource.marginSizeSmall,
                    ),

                    Expanded(
                        child: FunctionalityRowBuild(
                            isDownloadCertificate: true,
                            isPaid:
                                controller.courseData.value.data?.isFree != 1,
                            isDone: false,
                            // controller.courseData.value.data?.isWishlist?.value == 1,
                            bgColor: ColorResource.black.withOpacity(0.1),
                            icon: ImageResource.instance.batchIcon,
                            title: "Download Certificate",
                            onTap: () {
                              downloadCertificate(
                                  controller
                                          .courseData.value.data?.id
                                          .toString() ??
                                      "",
                                  controller.courseData.value.data?.courseTitle ??
                                      "",
                                  ((controller.courseStatus.value.data
                                              ?.isNotEmpty ??
                                          false)
                                      ? controller.courseStatus.value.data
                                              ?.first.quizCompleted ==
                                          0
                                      : true), (status) {
                                if (status == DownloadStatus.complete) {
                                  controller.downloadingLoader.value = false;
                                } else if (status == DownloadStatus.start) {
                                  controller.downloadingLoader.value = true;
                                } else {
                                  controller.downloadingLoader.value = false;
                                }
                              });
                            })),
                  ],
                ),
        ),
      ),


      // Padding(
      //   padding: const EdgeInsets.symmetric(
      //       horizontal: DimensionResource.marginSizeDefault,
      //       vertical: DimensionResource.marginSizeDefault),
      //   child: Obx(() {
      //     return getCertificateContainer(
      //         title: controller.courseData.value.data?.courseTitle ?? "",
      //         isLoading: controller.downloadingLoader.value,
      //         onListen: (status) {
      //           if (status == DownloadStatus.complete) {
      //             controller.downloadingLoader.value = false;
      //           } else if (status == DownloadStatus.start) {
      //             controller.downloadingLoader.value = true;
      //           } else {
      //             controller.downloadingLoader.value = false;
      //           }
      //         },
      //         url: controller.courseData.value.data?.id.toString() ?? "",
      //         isDisable: ((controller.courseStatus.value.data?.isNotEmpty ??
      //                 false)
      //             ? controller.courseStatus.value.data?.first.quizCompleted == 0
      //             : true));
      //   }),
      // ),

      Obx(() => Visibility(
            visible: !controller.isDataLoading.value,
            child: UserAccessWidget(
                isPro: controller.courseData.value.data?.isFree != 1),
          )),
      Padding(
        padding:
            const EdgeInsets.only(left: DimensionResource.marginSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Video Tag code

            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.center,
            //   children: [
            //     SizedBox(
            //         height: 22,
            //         width: 20,
            //         child: Stack(
            //           children: [
            //             Image.asset(
            //               ImageResource.instance.playIcon,
            //               height: 14,
            //               color: ColorResource.primaryColor.withOpacity(0.3),
            //             ),
            //             Positioned(
            //                 bottom: 3,
            //                 right: 3,
            //                 child: Image.asset(
            //                   ImageResource.instance.playIcon,
            //                   height: 17,
            //                   color: ColorResource.primaryColor,
            //                 )),
            //           ],
            //         )),
            //     const SizedBox(
            //       width: DimensionResource.marginSizeExtraSmall - 2,
            //     ),
            //     Text(
            //       "Videos",
            //       style: StyleResource.instance.styleSemiBold(
            //           fontSize: DimensionResource.fontSizeLarge - 2),
            //     ),
            //     const Spacer(),
            //     Obx(() {
            //       return ShadowContainer(
            //         onTap: () {},
            //         text: controller.courseData.value.data?.duration ?? "",
            //       );
            //     })
            //   ],
            // ),

            Column(
              children: [
                Obx(() => TabBar(
                        indicatorColor: controller.courseDataList.isEmpty
                            ? Colors.transparent
                            : ColorResource.primaryColor,
                        controller: tabController,
                        tabs: [
                          controller.courseDataList.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          DimensionResource.marginSizeLarge,
                                      vertical:
                                          DimensionResource.marginSizeSmall),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 24,
                                    child: ShimmerEffect.instance
                                        .courseTileShimmer(),
                                  ))
                              : Tab(
                                  child: Text(
                                    'Video Chapters(${controller.courseDataList.length})',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                          controller.courseDataList.isEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          DimensionResource.marginSizeLarge,
                                      vertical:
                                          DimensionResource.marginSizeSmall),
                                  child: SizedBox(
                                    width: double.infinity,
                                    height: 24,
                                    child: ShimmerEffect.instance
                                        .courseTileShimmer(),
                                  ))
                              : Tab(
                                  child: Text(
                                    'Reviews(${Get.find<ShowRatingController>().reviewData.value.data?.pagination?.count ?? 0})',
                                    style: const TextStyle(fontSize: 13),
                                  ),
                                ),
                        ])),
                const SizedBox(
                  height: 8,
                ),
                Obx(
                  () {
                    // final authService = Get.find<AuthService>();
                    // String userRole = authService.userRole.value;
                    return SizedBox(
                      height: controller.courseDataList.isEmpty
                          ? 240
                          : (70.0 * controller.courseDataList.length),
                      child: TabBarView(controller: tabController, children: [
                        controller.courseDataList.isEmpty
                            ? SizedBox(
                                height: 60.0 * 4,
                                child: ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  itemCount:
                                      4, // the number of items in the list
                                  itemBuilder: (context, index) {
                                    return Padding(
                                        padding: const EdgeInsets.only(
                                            top: DimensionResource
                                                .marginSizeDefault,
                                            right: DimensionResource
                                                .marginSizeDefault),
                                        child: SizedBox(
                                          width:
                                              MediaQuery.of(context).size.width,
                                          height: 60,
                                          child: ShimmerEffect.instance
                                              .courseTileShimmer(),
                                        ));
                                  },
                                ),
                              )
                            : Column(
                                children: List.generate(
                                    controller.courseDataList.length, (index) {
                                  VideoCourseFile data = controller
                                      .courseDataList
                                      .elementAt(index);
                                  return Padding(
                                    padding: const EdgeInsets.only(
                                        right: DimensionResource
                                            .marginSizeDefault),
                                    child: GestureDetector(
                                        onTap: Get.find<AuthService>()
                                                    .isGuestUser
                                                    .value ||
                                                (!Get.find<AuthService>().isPro.value &&
                                                    !Get.find<AuthService>()
                                                        .isTrial
                                                        .value &&
                                                    controller.courseData.value
                                                            .data?.isFree !=
                                                        1)
                                            ? () {
                                                // Get.find<RootViewController>()
                                                //     .getPopUpData2();

                                                // var data = controller
                                                //     .courseData
                                                //     .value
                                                //     .data
                                                //     ?.expiredUserPopup;
                                                // if (data != null) {
                                                //   liveClassDetailController
                                                //       .expireTrialPlanPopUp(
                                                //           data.imageUrl,
                                                //           data.title,
                                                //           data.subtitle,
                                                //           data.subtitle); // Explicitly unwrapping if you're sure it's not null
                                                // } else {
                                                // Handle the null case here, for example:
                                                print('Data is null!');
                                                // }
                                                // ProgressDialog().showFlipDialog(
                                                //     isForPro:
                                                //         Get.find<AuthService>()
                                                //                 .isGuestUser
                                                //                 .value
                                                //             ? false
                                                //             : true);
                                              }
                                            : () {
                                                if (controller.selectedVideo
                                                        .value.id !=
                                                    data.id.toString()) {
                                                  controller.videoIndex.value =
                                                      index;
                                                  controller
                                                          .selectedVideo.value =
                                                      VideoTypePlayer(
                                                          id: data.id
                                                              .toString(),
                                                          duration: int.parse(data
                                                                  .duration
                                                                  .isNotEmpty
                                                              ? data.duration
                                                              : "0"),
                                                          fileType:
                                                              isValidYoutubeUrl(data
                                                                      .fileLocalPath)
                                                                  ? 'Url'
                                                                  : "File",
                                                          fileUrl: data
                                                              .fileLocalPath,
                                                          courseContent: data);
                                                  controller
                                                      .isSelectedVideoChange
                                                      .value = true;
                                                  Future.delayed(
                                                      const Duration(
                                                          milliseconds: 50),
                                                      () {
                                                    controller
                                                        .isSelectedVideoChange
                                                        .value = false;
                                                  });

                                                  controller.isHistoryUpload
                                                      .value = true;
                                                }
                                              },
                                        child: videoCourseContainer2(
                                            index,
                                            controller,
                                            controller.statusOfFileDownload[index].chapterId ==
                                                    data.id
                                                ? controller
                                                        .statusOfFileDownload[index]
                                                        .downloadStatus ??
                                                    DownloadingStatus.error
                                                : DownloadingStatus.error,
                                            data,
                                            isPlaying: controller.selectedVideo.value.id == data.id.toString(),
                                            isFree: controller.courseData.value.data?.isTrialCourse != 1)),
                                  );
                                }),
                              ),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                  bottom: DimensionResource.marginSizeDefault),
                              child: Obx(() {
                                if (controller.courseData.value.data?.id !=
                                    null) {
                                  return AllRatingAndReviews(
                                    contest: context,
                                    enableVerticalMargin: true,
                                    courseDatum: CourseDatum(
                                        type: AppConstants.videoCourse,
                                        id: controller.courseData.value.data?.id
                                            .toString(),
                                        name: controller.courseData.value.data
                                                ?.courseTitle ??
                                            "",
                                        rating: controller.courseData.value.data
                                                ?.avgRating
                                                .toString() ??
                                            ""),
                                  );
                                } else {
                                  return const SizedBox();
                                }

                                // if(!controller.isDataLoading.value && controller.audioData.value.data?.id != null){
                                //   return AllRatingAndReviews(
                                //       contest: context,
                                //       enableVerticalMargin: true,
                                //       isDark: true,
                                //       fontSize: DimensionResource.fontSizeDefault - 2,
                                //       isCourse: controller.categoryType.value ==
                                //           CourseDetailViewType.audioCourse,
                                //       courseDatum: CourseDatum(
                                //           type: controller.categoryType.value ==
                                //               CourseDetailViewType.audioCourse
                                //               ? AppConstants.audioCourse
                                //               : "audio",
                                //           id: controller.audioData.value.data?.id?.toString(),
                                //           name: controller.audioData.value.data?.courseTitle ??
                                //               controller.audioData.value.data?.title ??
                                //               "",
                                //           rating: controller.audioData.value.data?.rating
                                //               ?.toString() ??
                                //               ""));
                                // }
                              }),
                            ),
                          ],
                        )
                      ]),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      Obx(() {
        return Padding(
          padding: const EdgeInsets.only(
              top: DimensionResource.marginSizeExtraSmall),
          child: controller.courseDataList.isEmpty
              ? Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.marginSizeSmall),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: 60,
                    child: ShimmerEffect.instance.courseTileShimmer(),
                  ),
                )
              : quizBoxContainer(
                  certificateCriteria:
                      controller.courseData.value.data?.certificateCriteria ??
                          0,
                  onTap: () {
                    controller.getCourseStatus();
                  },
                  isDissable:
                      ((controller.courseStatus.value.data?.isNotEmpty ?? false)
                          ? controller.courseStatus.value.data?.first
                                  .courseCompleted ==
                              0
                          : true),
                  enableVerticalPadding: true,
                  quiz: controller.courseData.value.data?.quiz ?? Quiz(),
                  courseId:
                      controller.courseData.value.data?.id.toString() ?? ""),
        );
      }),

      Container(
        height: 16,
      ),
      Obx(() {
        return Visibility(
          visible: controller.moreLikeData.isNotEmpty,
          child: MoreLikeWidget(
            onItemTap: (data) {
              controller.courseId.value = data.id.toString();
              // controller.getCourseById();
            },
            onTap: () {
              Get.toNamed(Routes.courseDetail, arguments: [
                controller.courseData.value.data?.courseCategory?.title ?? "",
                CourseDetailViewType.videoCourse,
                "",
                controller.courseData.value.data?.courseCategory?.id
              ]);
            },
            dataList: controller.moreLikeData,
            isVideo: true,
          ),
        );
      }),
      Container(
        height: 16,
      ),
    ];
  }
}

Widget videoCourseContainer2(int index, VideoCourseDetailController controller,
    DownloadingStatus status, VideoCourseFile courseDetail,
    {required bool isPlaying, required bool isFree}) {
  print('rfvdvsc ${controller.courseData.value.data?.expiredUserPopup?.title}');
  return Material(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    color: isPlaying ? ColorResource.primaryColor : Colors.transparent,
    clipBehavior: Clip.antiAliasWithSaveLayer,

    child: Obx(() {
      return SizedBox(
          height: 70,
          width: double.infinity,
          child: Padding(
            padding: const EdgeInsets.only(
              left: DimensionResource.marginSizeSmall,
              right: DimensionResource.marginSizeDefault,
            ),
            child: Row(
              children: [
                playIconButton(
                    onTap: Get
                        .find<AuthService>()
                        .isGuestUser
                        .value ||
                        (!Get
                            .find<AuthService>()
                            .isPro
                            .value && isFree)
                        ? () {
                      Get.find<RootViewController>().getPopUpData2();
                      // ProgressDialog().showFlipDialog(
                      //     isForPro:
                      //         Get.find<AuthService>().isGuestUser.value
                      //             ? false
                      //             : true);
                    }
                        : null,
                    icon: Get
                        .find<AuthService>()
                        .isPro
                        .value || !isFree
                        ? ImageResource.instance.playIcon
                        : ImageResource.instance.lockIcon,
                    height: !Get
                        .find<AuthService>()
                        .isPro
                        .value ? 16 : 14,
                    allPadding: 0,
                    bgColor: isPlaying
                        ? ColorResource.white
                        : ColorResource.primaryColor,
                    iconColor: isPlaying
                        ? ColorResource.primaryColor
                        : ColorResource.white),
                const SizedBox(
                  width: DimensionResource.marginSizeDefault,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                        constraints: BoxConstraints(maxWidth: Get.width * 0.5),
                        child: Text(
                          courseDetail.name,
                          style: StyleResource.instance.styleSemiBold(
                              fontSize: DimensionResource.fontSizeSmall,
                              color: isPlaying
                                  ? ColorResource.white
                                  : ColorResource.black),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        )),
                    const SizedBox(
                      height: 4,
                    ),
                    Text(
                      "${courseDetail.duration} mins",
                      style: TextStyle(
                        color: isPlaying ? ColorResource.white : Colors.black,
                        fontSize: DimensionResource.fontSizeExtraSmall,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
                
                // (courseDetail.fileUrl.toString().endsWith(".mp4"))
                //     ? status == DownloadingStatus.started ||
                //     status == DownloadingStatus.inQueue
                //
                //     ? LoaderButtonLayout(
                //   onTap: () {},
                //   iconSize: 16,
                //   allPadding: 4,
                //   iconColor: ColorResource.primaryColor,
                // )
                //     : InkWell(
                //   onTap: () {
                //     if (controller
                //         .courseData.value.data?.isTrialCourse ==
                //         1 ||
                //         Get
                //             .find<AuthService>()
                //             .isPro
                //             .value) {
                //       controller.onSingleDownloadClicked(
                //           courseDetail, index);
                //     } else if (Get
                //         .find<AuthService>()
                //         .isTrial
                //         .value &&
                //         controller
                //             .courseData.value.data?.isTrialCourse ==
                //             0) {
                //       ProgressDialog().showFlipDialog(
                //           title:
                //           "Download All Premium Stock Market Content as a Pro User. Continue?",
                //           isForPro:
                //           Get
                //               .find<AuthService>()
                //               .isGuestUser
                //               .value
                //               ? false
                //               : true);
                //     } else {
                //       Get.find<RootViewController>().getPopUpData2();
                //     }
                //     // if (!Get.find<AuthService>().isGuestUser.value) {
                //     //   if (status == DownloadingStatus.error) {
                //     //
                //     //   }
                //     // } else {
                //     //   Get.find<RootViewController>().getPopUpData2();
                //     // }
                //   },
                //   child: Image.asset(
                //     status == DownloadingStatus.downloaded
                //         ? ImageResource.instance.checkIcon
                //         : ImageResource.instance.downloadIcon,
                //     height: 19,
                //     color: isPlaying
                //         ? ColorResource.white
                //         : ColorResource.primaryColor,
                //   ),
                // )
                //     : Container(),


                Obx(
                      () =>
                      (courseDetail.fileUrl.toString().endsWith(".mp4"))
                          ? controller.downloadStatus.value == DownloadingStatus.started ||
                          controller.downloadStatus.value == DownloadingStatus.inQueue

                          ? LoaderButtonLayout(
                        onTap: () {},
                        iconSize: 16,
                        allPadding: 4,
                        iconColor: ColorResource.primaryColor,
                      )
                          : InkWell(
                        onTap: () {
                          if (controller
                              .courseData.value.data?.isTrialCourse ==
                              1 ||
                              Get.find<AuthService>().isPro.value) {
                            controller.onSingleDownloadClicked(
                                courseDetail, index);
                          } else if (Get.find<AuthService>().isTrial.value &&
                              controller
                                  .courseData.value.data?.isTrialCourse ==
                                  0) {
                            ProgressDialog().showFlipDialog(
                                title:
                                "Download All Premium Stock Market Content as a Pro User. Continue?",
                                isForPro:
                                Get.find<AuthService>().isGuestUser.value
                                    ? false
                                    : true);
                          } else {
                            print('fvsdcs ${controller.courseData.value.data?.expiredUserPopup?.title}');
                            var expiredUserPopup = controller.courseData.value.data?.expiredUserPopup;
                            Get.find<RootViewController>().getPopUpData2(title: expiredUserPopup?.title,subtitle: expiredUserPopup?.subtitle,buttonTitle: expiredUserPopup?.buttonTitle,imageUrl: expiredUserPopup?.imageUrl);

                          }
                          // if (!Get.find<AuthService>().isGuestUser.value) {
                          //   if (status == DownloadingStatus.error) {
                          //
                          //   }
                          // } else {
                          //   Get.find<RootViewController>().getPopUpData2();
                          // }
                        },
                        child: Image.asset(
                          status == DownloadingStatus.downloaded
                              ? ImageResource.instance.checkIcon
                              : ImageResource.instance.downloadIcon,
                          height: 19,
                          color: isPlaying
                              ? ColorResource.white
                              : ColorResource.primaryColor,
                        ),
                      )
                          : Container(),
                ),


              ],
            ),
          ));
    }
    ),
  );
}

Widget videoCourseContainer(int index, VideoCourseDetailController controller,
    DownloadingStatus status, VideoCourseFile courseDetail,
    {required bool isPlaying, required bool isFree}) {
  return Material(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
    ),
    clipBehavior: Clip.antiAliasWithSaveLayer,
    color: ColorResource.white,
    child: SizedBox(
        height: 130,
        width: double.infinity,
        child: Stack(
          children: [
            Positioned(
                right: 0,
                left: 0,
                child: cachedNetworkImage(courseDetail.imagePath,
                    fit: BoxFit.fitWidth)),
            Positioned(
                right: 0,
                left: 0,
                child: Container(
                  height: 130,
                  color: ColorResource.black.withOpacity(0.25),
                )),
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: DimensionResource.marginSizeExtraLarge,
                  vertical: DimensionResource.marginSizeDefault),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: DimensionResource.marginSizeExtraSmall,
                  ),
                  Container(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.6),
                      child: Text(
                        courseDetail.name,
                        style: StyleResource.instance.styleSemiBold(
                            fontSize: DimensionResource.fontSizeDefault,
                            color: ColorResource.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )),
                  const Spacer(),
                  Row(
                    children: [
                      playIconButton(
                          onTap: Get.find<AuthService>().isGuestUser.value ||
                                  (!Get.find<AuthService>().isPro.value &&
                                      isFree)
                              ? () {

                            Get.find<RootViewController>()
                                      .getPopUpData2();

                                  // ProgressDialog().showFlipDialog(
                                  //     isForPro: Get.find<AuthService>()
                                  //             .isGuestUser
                                  //             .value
                                  //         ? false
                                  //         : true);
                                }
                              : null,
                          icon: ImageResource.instance.playIcon,
                          height: 13,
                          allPadding: 7),
                      const SizedBox(
                        width: DimensionResource.marginSizeExtraSmall + 2,
                      ),
                      Text(
                        isPlaying ? "Now Playing" : "Watch Now",
                        style: StyleResource.instance
                            .styleMedium(color: ColorResource.white),
                      ),
                      const Spacer(),
                      status == DownloadingStatus.started ||
                              status == DownloadingStatus.inQueue
                          ? LoaderButtonLayout(
                              onTap: () {},
                              iconSize: 16,
                              allPadding: 4,
                              iconColor: ColorResource.primaryColor,
                            )
                          : InkWell(
                              onTap: () {
                                if (status == DownloadingStatus.error) {
                                  controller.onSingleDownloadClicked(
                                      courseDetail, index);
                                }
                              },
                              child: Image.asset(
                                status == DownloadingStatus.downloaded
                                    ? ImageResource.instance.checkIcon
                                    : ImageResource.instance.downloadIcon,
                                height: 19,
                                color: ColorResource.white,
                              ),
                            )
                    ],
                  )
                ],
              ),
            )
          ],
        )),
  );
}

class FunctionalityRowBuild extends StatefulWidget {
  final Color bgColor;
  final String icon;
  final String title;
  final bool isDone;
  final bool isPaid;
  final bool isRestart;
  final bool isDownloadCertificate;
  final Function() onTap;

  const FunctionalityRowBuild(
      {Key? key,
      required this.bgColor,
      required this.icon,
      required this.title,
      required this.isPaid,
      required this.isDone,
      this.isDownloadCertificate = false,
      this.isRestart = false,
      required this.onTap})
      : super(key: key);

  @override
  State<FunctionalityRowBuild> createState() => _FunctionalityRowBuildState();
}

class _FunctionalityRowBuildState extends State<FunctionalityRowBuild> {
  @override
  Widget build(BuildContext context) {
    final CoursesViewController coursesViewController =
        Get.put(CoursesViewController());

    (coursesViewController.selectedSub.value.optionName == 'is_free')
        ? logPrint("fsfs ds s sg jks ssjk ${widget.isDone}")
        : print('erfgegrvr');

    return InkWell(
      onTap: widget.onTap,
      // widget.icon == ImageResource.instance.shareIcon
      //     ? widget.onTap
      //     : Get.find<AuthService>().isGuestUser.value ||
      //             (!Get.find<AuthService>().isPro.value && widget.isPaid)
      //         ? () {
      //             Get.find<RootViewController>().getPopUpData2();
      //
      // ProgressDialog().showFlipDialog(
      //     isForPro: Get.find<AuthService>().isGuestUser.value
      //         ? false
      //         : true);
      //           }
      //         : widget.onTap:widget.onTap,
      radius: 7,
      child: Container(
        decoration: BoxDecoration(
            border: Border.all(
                color: ColorResource.borderColor.withOpacity(0.2), width: 0.7),
            borderRadius: BorderRadius.circular(4)),
        padding: const EdgeInsets.symmetric(
            vertical: DimensionResource.marginSizeExtraSmall,
            horizontal: DimensionResource.marginSizeExtraSmall),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              // duration: const Duration(milliseconds: 2000),
              // curve: Curves.bounceInOut,
              decoration:
                  BoxDecoration(shape: BoxShape.circle, color: widget.bgColor),
              padding: EdgeInsets.all(widget.isRestart ? 0 : 5),
              child: Image.asset(
                widget.isRestart
                    ? ImageResource.instance.restartIcon
                    : widget.isDone
                        ? ImageResource.instance.checkIcon
                        : widget.icon,
                height: widget.isRestart ? 20 : 10,
              ),
            ),
            const SizedBox(
              width: DimensionResource.marginSizeSmall - 3,
            ),
            Text(
              widget.title,
              style: StyleResource.instance
                  .styleRegular(fontSize: DimensionResource.fontSizeSmall - 2),
            )
          ],
        ),
      ),
    );
  }
}

// class MatchBoxWidget extends StatelessWidget {
//   final MatchCriteria matchCriteria;

//   const MatchBoxWidget({Key? key, required this.matchCriteria})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Visibility(
//       visible: matchCriteria.criteria != null,
//       child: Card(
//         margin: const EdgeInsets.symmetric(
//             horizontal: DimensionResource.marginSizeDefault),
//         child: Padding(
//           padding: const EdgeInsets.symmetric(
//               horizontal: DimensionResource.marginSizeSmall,
//               vertical: DimensionResource.marginSizeExtraSmall),
//           child: RichText(
//             text: TextSpan(
//                 style: StyleResource.instance
//                     .styleMedium(fontSize: DimensionResource.fontSizeSmall),
//                 children: [
//                   TextSpan(
//                     text: "${matchCriteria.criteria}%",
//                     style: StyleResource.instance.styleMedium(
//                         color: ColorResource.greenColor,
//                         fontSize: DimensionResource.fontSizeSmall),
//                   ),
//                   TextSpan(
//                     text: " Matches with ",
//                     style: StyleResource.instance.styleMedium(
//                         color: ColorResource.secondaryColor,
//                         fontSize: DimensionResource.fontSizeSmall),
//                   ),
//                   TextSpan(
//                     text: matchCriteria.category?.title ?? "",
//                     style: StyleResource.instance.styleMedium(
//                         color: ColorResource.primaryColor,
//                         fontSize: DimensionResource.fontSizeSmall),
//                   ),
//                 ]),
//           ),
//         ),
//       ),
//     );
//   }
// }

class ShadowContainer extends StatelessWidget {
  final Color color;
  final Color textColor;
  final bool isCircle;
  final String text;
  final Function() onTap;

  const ShadowContainer(
      {Key? key,
      this.isCircle = false,
      this.color = ColorResource.primaryColor,
      this.textColor = ColorResource.primaryColor,
      required this.onTap,
      required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.only(
                topLeft: const Radius.circular(15),
                bottomLeft: const Radius.circular(15),
                bottomRight: Radius.circular(isCircle ? 15 : 0),
                topRight: Radius.circular(isCircle ? 15 : 0)),
            color: color),
        child: Container(
          margin: const EdgeInsets.only(
              left: DimensionResource.marginSizeExtraSmall),
          padding: const EdgeInsets.symmetric(
              vertical: DimensionResource.marginSizeExtraSmall,
              horizontal: DimensionResource.marginSizeSmall),
          decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15)),
              color: Colors.white.withOpacity(0.87)),
          child: Center(
            child: Text(
              text,
              style: StyleResource.instance.styleMedium(
                  fontSize: DimensionResource.fontSizeExtraSmall,
                  color: textColor),
            ),
          ),
        ),
      ),
    );
  }
}

Widget playIconButton(
    {required Function()? onTap,
    double allPadding = 5,
    double height = 21,
    required String icon,
    Color bgColor = ColorResource.primaryColor,
    Color iconColor = ColorResource.white,
    bool isPlaying = false}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: onTap,
    child: CircleAvatar(
      radius: 16,
      backgroundColor: bgColor,
      child: Padding(
        padding: const EdgeInsets.only(left: 3.0),
        child: Center(
          child: Image.asset(
            isPlaying ? ImageResource.instance.pauseIcon : icon,
            color: iconColor,
            height: height,
          ),
        ),
      ),
    ),
    // Container(
    //   decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
    //   padding: EdgeInsets.all(allPadding),
    //   child: Image.asset(
    //     isPlaying ? ImageResource.instance.pauseIcon : icon,
    //     color: iconColor,
    //     height: height,
    //     width: height,
    //   ),
    // ),
  );
}

Widget playLoaderButton(
    {double allPadding = 5,
    double height = 21,
    Color bgColor = Colors.white,
    Color iconColor = ColorResource.primaryColor}) {
  return InkWell(
    child: Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
      padding: EdgeInsets.all(allPadding),
      child: SizedBox(
          height: height,
          width: height,
          child: CircularProgressIndicator(
            color: iconColor,
            strokeWidth: 2,
          )),
    ),
  );
}

Widget playIconLoaderButton(
    {double allPadding = 5,
    double height = 21,
    required String icon,
    Color bgColor = Colors.white,
    Color iconColor = ColorResource.primaryColor}) {
  return CircularPercentIndicator(
    radius: 18.0,
    lineWidth: 3.0,
    percent: 0.8,
    center: Container(
      decoration: BoxDecoration(shape: BoxShape.circle, color: bgColor),
      padding: EdgeInsets.all(allPadding),
      child: Image.asset(
        icon,
        color: iconColor,
        height: height,
      ),
    ),
    backgroundColor: ColorResource.borderColor,
    progressColor: ColorResource.primaryColor,
  );
}

