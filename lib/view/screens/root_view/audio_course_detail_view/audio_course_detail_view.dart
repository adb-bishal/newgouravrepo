import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/course_models/single_course_model.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/service/floor/entity/download.dart';
import 'package:stockpathshala_beta/service/page_manager.dart';
import 'package:stockpathshala_beta/service/utils/download_file_util.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/audio_course_detail_controller/audio_course_detail_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';

import '../../../../model/services/auth_service.dart';
import '../../../../model/utils/app_constants.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../enum/routing/routes/app_pages.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';
import '../home_view/widget/scalps_widget.dart';
import '../text_course_detail_view/text_course_detail_view.dart';
import '../video_course_detail_view/video_course_detail_view.dart';
import '../widget/add_rating_widget.dart';

class AudioCourseDetailView extends GetView<AudioCourseDetailController> {
  const AudioCourseDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.secondaryColor,
      body: CustomScrollView(
        primary: true,
        shrinkWrap: false,
        physics: const ClampingScrollPhysics(),
        slivers: [
          SliverAppBar(
            automaticallyImplyLeading: false,
            expandedHeight: 405,
            collapsedHeight: 405,
            toolbarHeight: 45,
            titleSpacing: DimensionResource.marginSizeDefault,
            title: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      Get.back();
                    },
                    splashColor: Colors.transparent,
                    child: const SizedBox(
                        height: 45,
                        width: 50,
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Icon(
                              Icons.arrow_back_ios_sharp,
                              color: ColorResource.white,
                              size: 20,
                            ))),
                  ),
                ],
              ),
            ),
            floating: false,
            pinned: true,
            backgroundColor: ColorResource.secondaryColor,
            elevation: 5,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: true,
              collapseMode: CollapseMode.parallax,
              background: Container(
                width: double.infinity,
                //height: MediaQuery.of(context).size.height * .39,
                color: ColorResource.secondaryColor,
                child: Stack(
                  children: [
                    Image.asset(
                      ImageResource.instance.audioScreenLayer,
                      fit: BoxFit.cover,
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 85),
                      child: Align(
                        alignment: Alignment.center,
                        child: Obx(() {
                          return Column(
                            children: [
                              Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15),
                                ),
                                elevation: 10,
                                margin: EdgeInsets.zero,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: SizedBox(
                                    height: 120,
                                    width: 125,
                                    child: cachedNetworkImage(
                                        (controller
                                                        .pageManager
                                                        .currentPlayingMedia
                                                        .value
                                                        .extras?['thumbnail'] !=
                                                    null &&
                                                controller
                                                        .pageManager
                                                        .currentPlayingMedia
                                                        .value
                                                        .extras?['thumbnail'] !=
                                                    "")
                                            ? (controller
                                                    .pageManager
                                                    .currentPlayingMedia
                                                    .value
                                                    .extras?['thumbnail'] ??
                                                "")
                                            : controller.categoryType.value ==
                                                    CourseDetailViewType
                                                        .audioCourse
                                                ? controller.audioData.value
                                                        .data?.thumbnail ??
                                                    ""
                                                : '',
                                        fit: BoxFit.cover)),
                              ),
                              const SizedBox(
                                height: DimensionResource.marginSizeLarge,
                              ),
                              Container(
                                  constraints: BoxConstraints(
                                      maxWidth: Get.width * 0.65),
                                  child: Text(
                                    controller.pageManager.currentPlayingMedia
                                                .value.title !=
                                            ""
                                        ? controller.pageManager
                                            .currentPlayingMedia.value.title
                                        : controller.categoryType.value ==
                                                CourseDetailViewType.audioCourse
                                            ? controller.audioData.value.data
                                                    ?.courseTitle ??
                                                ""
                                            : '',
                                    style: StyleResource.instance.styleSemiBold(
                                        fontSize:
                                            DimensionResource.fontSizeLarge,
                                        color: ColorResource.white),
                                    textAlign: TextAlign.center,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              const SizedBox(
                                height: DimensionResource.marginSizeSmall,
                              ),
                              Text(
                                controller.pageManager.currentPlayingMedia.value
                                        .album ??
                                    (controller.categoryType.value ==
                                            CourseDetailViewType.audioCourse
                                        ? controller.audioData.value.data
                                                ?.courseCategory?.title ??
                                            ""
                                        : ''),
                                style: StyleResource.instance.styleSemiBold(
                                    fontSize:
                                        DimensionResource.fontSizeExtraSmall,
                                    color: ColorResource.lightTextColor),
                              ),
                              const SizedBox(
                                height: DimensionResource.marginSizeLarge,
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                      maintainState: true,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      visible: !controller.pageManager
                                          .isFirstSongNotifier.value,
                                      child: playIconButton(
                                          onTap: () {
                                            Get.find<AuthService>()
                                                        .isGuestUser
                                                        .value ||
                                                    (!Get.find<AuthService>()
                                                            .isPro
                                                            .value &&
                                                        controller
                                                                .audioData
                                                                .value
                                                                .data
                                                                ?.isFree !=
                                                            1)
                                                ? ProgressDialog().showFlipDialog(
                                                    isForPro:
                                                        Get.find<AuthService>()
                                                                .isGuestUser
                                                                .value
                                                            ? false
                                                            : true)
                                                : controller.pageManager
                                                    .previous();
                                          },
                                          icon: ImageResource
                                              .instance.previousIcon,
                                          height: 14,
                                          allPadding: 12,
                                          bgColor: ColorResource.secondaryColor,
                                          iconColor: ColorResource.white)),
                                  const SizedBox(
                                    width: DimensionResource.marginSizeLarge,
                                  ),
                                  if (controller.pageManager.playButtonNotifier
                                          .value ==
                                      ButtonState.loading)
                                    playLoaderButton(height: 20, allPadding: 16)
                                  else
                                    playIconButton(
                                        onTap: Get.find<AuthService>()
                                                    .isGuestUser
                                                    .value ||
                                                (!Get.find<AuthService>()
                                                        .isPro
                                                        .value &&
                                                    controller.audioData.value
                                                            .data?.isFree !=
                                                        1)
                                            ? () {
                                                ProgressDialog().showFlipDialog(
                                                    isForPro:
                                                        Get.find<AuthService>()
                                                                .isGuestUser
                                                                .value
                                                            ? false
                                                            : true);
                                              }
                                            : controller.playButtonClicked,
                                        icon: ImageResource.instance.playIcon,
                                        isPlaying: (controller.pageManager
                                                .playButtonNotifier.value ==
                                            ButtonState.playing),
                                        height: 20,
                                        allPadding: 16),
                                  const SizedBox(
                                    width: DimensionResource.marginSizeLarge,
                                  ),
                                  Visibility(
                                      maintainState: true,
                                      maintainSize: true,
                                      maintainAnimation: true,
                                      visible: !controller
                                          .pageManager.isLastSongNotifier.value,
                                      child: playIconButton(
                                          onTap: () {
                                            Get.find<AuthService>()
                                                        .isGuestUser
                                                        .value ||
                                                    (!Get.find<AuthService>()
                                                            .isPro
                                                            .value &&
                                                        controller
                                                                .audioData
                                                                .value
                                                                .data
                                                                ?.isFree !=
                                                            1)
                                                ? ProgressDialog().showFlipDialog(
                                                    isForPro:
                                                        Get.find<AuthService>()
                                                                .isGuestUser
                                                                .value
                                                            ? false
                                                            : true)
                                                : controller.pageManager.next();
                                          },
                                          icon: ImageResource.instance.nextIcon,
                                          height: 14,
                                          allPadding: 12,
                                          bgColor: ColorResource.secondaryColor,
                                          iconColor: ColorResource.white)),
                                ],
                              ),
                              const SizedBox(
                                height: DimensionResource.marginSizeDefault,
                              ),
                              songProgress(context, controller),
                            ],
                          );
                        }),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 35,
                          right: DimensionResource.marginSizeDefault),
                      child: Align(
                        alignment: Alignment.topRight,
                        child: Obx(() {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              if (controller.downloadStatus.value ==
                                  DownloadingStatus.downloaded)
                                IconButtonLayout(
                                  onTap: () {},
                                  iconSize: 16,
                                  allPadding: 10,
                                  image: ImageResource.instance.checkIcon,
                                  iconColor: ColorResource.primaryColor,
                                )
                              else if (controller.downloadStatus.value ==
                                      DownloadingStatus.error ||
                                  controller.downloadStatus.value ==
                                      DownloadingStatus.reDownload)
                                IconButtonLayout(
                                  onTap: controller.onDownloadClicked,
                                  iconSize: 16,
                                  allPadding: controller.downloadStatus.value ==
                                          DownloadingStatus.reDownload
                                      ? 0
                                      : 10,
                                  image: controller.downloadStatus.value ==
                                          DownloadingStatus.reDownload
                                      ? ImageResource.instance.restartIcon
                                      : ImageResource.instance.saveIcon,
                                  iconColor: ColorResource.primaryColor,
                                )
                              else if (controller.downloadStatus.value ==
                                  DownloadingStatus.started)
                                LoaderButtonLayout(
                                  onTap: () {},
                                  iconSize: 16,
                                  allPadding: 4,
                                  iconColor: ColorResource.primaryColor,
                                ),
                              const SizedBox(
                                height: DimensionResource.marginSizeSmall + 3,
                              ),
                              IconButtonLayout(
                                onTap: controller.onWatchLater,
                                iconSize: 16,
                                allPadding: 10,
                                secondImage: controller.audioData.value.data
                                            ?.isWishlist!.value ==
                                        1
                                    ? ImageResource.instance.filledLikeIcon
                                    : null,
                                image: ImageResource.instance.likeIcon,
                                iconColor: ColorResource.redColor,
                              ),
                            ],
                          );
                        }),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Wrap(children: [
              Obx(() {
                return Visibility(
                  visible:
                      controller.audioData.value.data?.description != null &&
                          controller.audioData.value.data?.description != "",
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.marginSizeDefault,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        rowTile(() => null, StringResource.description,
                            enablePadding: false,
                            showIcon: false,
                            isDark: true,
                            labelStyle: StyleResource.instance
                                .styleMedium()
                                .copyWith(
                                    fontSize:
                                        DimensionResource.fontSizeDefault - 1,
                                    color: ColorResource.white,
                                    letterSpacing: .3),
                            splashColor: ColorResource.secondaryColor),
                        descriptionReadMoreText(context ,
                          controller.audioData.value.data?.description
                                  .toString()
                                  .capitalize ??
                              "",
                          isDark: true,
                          fontSize: DimensionResource.fontSizeExtraSmall,
                        )
                      ],
                    ),
                  ),
                );
              }),
              Obx(() => Visibility(
                    visible: !controller.isDataLoading.value,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: DimensionResource.marginSizeDefault),
                      child: UserAccessWidget(
                        isPro: controller.audioData.value.data?.isFree != 1,
                        isDark: true,
                        color: ColorResource.mateGreenColor,
                      ),
                    ),
                  )),
              Obx(() {
                return Visibility(
                  visible:
                      (controller.moreLikeData.value.data?.data?.isNotEmpty ??
                              false) ||
                          (controller.courseDataList.isNotEmpty),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: DimensionResource.marginSizeDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        rowTile(
                            () => null,
                            controller.categoryType.value ==
                                    CourseDetailViewType.audio
                                ? StringResource.moreLike
                                : "${controller.courseDataList.length} ${StringResource.audios}",
                            enablePadding: false,
                            showIcon: false,
                            isDark: true,
                            labelStyle: StyleResource.instance
                                .styleMedium()
                                .copyWith(
                                    fontSize:
                                        DimensionResource.fontSizeDefault - 1,
                                    color: ColorResource.white,
                                    letterSpacing: .3),
                            splashColor: ColorResource.secondaryColor),
                        const SizedBox(
                          height: DimensionResource.marginSizeSmall,
                        ),
                        ...List.generate(
                            controller.moreLikeData.value.data?.data?.length ??
                                controller.courseDataList.length, (index) {
                          Datum? data = (controller.moreLikeData.value.data
                                      ?.data?.isNotEmpty ??
                                  false)
                              ? controller.moreLikeData.value.data!.data!
                                  .elementAt(index)
                              : null;
                          AudioCourseFile? courseFile =
                              controller.courseDataList.isNotEmpty
                                  ? controller.courseDataList.elementAt(index)
                                  : null;
                          logPrint(
                              "dataa list ${controller.statusOfFileDownload.length}");
                          return Padding(
                              padding: EdgeInsets.only(
                                  top: index == 0
                                      ? 0
                                      : DimensionResource.marginSizeDefault,
                                  right: DimensionResource.marginSizeDefault),
                              child: InkWell(
                                  onTap: Get.find<AuthService>()
                                              .isGuestUser
                                              .value ||
                                          (!Get.find<AuthService>()
                                                  .isPro
                                                  .value &&
                                              controller.audioData.value.data
                                                      ?.isFree !=
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
                                          if (controller
                                                  .courseDataList.isEmpty &&
                                              data != null) {
                                            controller.resetDataSingle(data);
                                            controller.getOfflineData();
                                          } else {
                                            controller.playCourseDetailFromList(
                                                index,
                                                controller
                                                    .courseDataList[index]);
                                            Future.delayed(Duration.zero, () {
                                              logPrint("dfsdfsd sdfsd");
                                              if (controller
                                                      .pageManager
                                                      .playButtonNotifier
                                                      .value !=
                                                  ButtonState.playing) {
                                                controller.pageManager.play();
                                              }
                                            });
                                          }
                                          if (controller.pageManager
                                                  .playButtonNotifier.value ==
                                              ButtonState.playing) {
                                            controller.pageManager.pause();
                                          } else {
                                            controller.pageManager.play();
                                          }
                                        },
                                  child: (data != null)
                                      ? audioCourseMoreLikeContainer(
                                          onPlayButton: Get.find<AuthService>()
                                                      .isGuestUser
                                                      .value ||
                                                  (!Get.find<AuthService>()
                                                          .isPro
                                                          .value &&
                                                      controller.audioData.value
                                                              .data?.isFree !=
                                                          1)
                                              ? () {
                                                  ProgressDialog().showFlipDialog(
                                                      isForPro: Get.find<
                                                                  AuthService>()
                                                              .isGuestUser
                                                              .value
                                                          ? false
                                                          : true);
                                                }
                                              : () {
                                                  if (controller
                                                      .courseDataList.isEmpty) {
                                                    controller
                                                        .resetDataSingle(data);
                                                    controller.getOfflineData();
                                                  } else {
                                                    controller
                                                        .playCourseDetailFromList(
                                                            index,
                                                            controller
                                                                    .courseDataList[
                                                                index]);
                                                  }
                                                  if (controller
                                                          .pageManager
                                                          .playButtonNotifier
                                                          .value ==
                                                      ButtonState.playing) {
                                                    controller.pageManager
                                                        .pause();
                                                  } else {
                                                    controller.pageManager
                                                        .play();
                                                  }
                                                },
                                          data: data,
                                          onDownload: () {
                                            controller.onSingleDownloadClicked(
                                                AudioCourseFile(
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                    "",
                                                    false),
                                                index,
                                                isAudio: true,
                                                audioDataVal: data);
                                          },
                                          isPlaying: data.id.toString() !=
                                              controller.pageManager
                                                  .currentPlayingMedia.value.id)
                                      : (courseFile != null)
                                          ? Obx(() {
                                              return audioCourseDetailContainer(
                                                  onPlayButton: Get.find<AuthService>()
                                                              .isGuestUser
                                                              .value ||
                                                          (!Get.find<AuthService>().isPro.value &&
                                                              controller
                                                                      .audioData
                                                                      .value
                                                                      .data
                                                                      ?.isFree !=
                                                                  1)
                                                      ? () {
                                                          ProgressDialog().showFlipDialog(
                                                              isForPro: Get.find<
                                                                          AuthService>()
                                                                      .isGuestUser
                                                                      .value
                                                                  ? false
                                                                  : true);
                                                        }
                                                      : () {
                                                          controller
                                                              .selectedIndex
                                                              .value = index;
                                                          if (controller
                                                                  .courseDataList
                                                                  .isEmpty &&
                                                              data != null) {
                                                            controller
                                                                .resetDataSingle(
                                                                    data);
                                                            controller
                                                                .getOfflineData();
                                                          } else {
                                                            controller
                                                                .playCourseDetailFromList(
                                                                    index,
                                                                    controller
                                                                            .courseDataList[
                                                                        index]);
                                                            Future.delayed(
                                                                Duration.zero,
                                                                () {
                                                              if (controller
                                                                      .pageManager
                                                                      .playButtonNotifier
                                                                      .value !=
                                                                  ButtonState
                                                                      .playing) {
                                                                controller
                                                                    .pageManager
                                                                    .play();
                                                              }
                                                            });
                                                          }
                                                          if (controller
                                                                  .pageManager
                                                                  .playButtonNotifier
                                                                  .value ==
                                                              ButtonState
                                                                  .playing) {
                                                            controller
                                                                .pageManager
                                                                .pause();
                                                          } else {
                                                            controller
                                                                .pageManager
                                                                .play();
                                                          }
                                                          logPrint("dsfds");
                                                          Future.delayed(
                                                              Duration.zero,
                                                              () {
                                                            logPrint(
                                                                "dfsdfsd sdfsd");
                                                            if (controller
                                                                    .pageManager
                                                                    .playButtonNotifier
                                                                    .value !=
                                                                ButtonState
                                                                    .playing) {
                                                              controller
                                                                  .pageManager
                                                                  .play();
                                                            }
                                                          });
                                                        },
                                                  onDownload: () {
                                                    controller
                                                        .onSingleDownloadClicked(
                                                            controller
                                                                    .courseDataList[
                                                                index],
                                                            index,
                                                            audioDataVal:
                                                                Datum());
                                                  },
                                                  isDownloading: controller
                                                          .statusOfFileDownload
                                                          .isNotEmpty
                                                      ? controller.statusOfFileDownload[index].chapterId ==
                                                              courseFile.id
                                                                  .toString()
                                                          ? controller.statusOfFileDownload[index].downloadStatus ??
                                                              DownloadingStatus
                                                                  .error
                                                          : DownloadingStatus
                                                              .error
                                                      : DownloadingStatus
                                                          .downloaded,
                                                  data: courseFile,
                                                  isPlaying:
                                                      courseFile.id.toString() !=
                                                          controller
                                                              .pageManager
                                                              .currentPlayingMedia
                                                              .value
                                                              .id);
                                            })
                                          : Container()));
                        })
                      ],
                    ),
                  ),
                );
              }),
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: DimensionResource.marginSizeSmall + 3),
                child: Obx(() {
                  logPrint(
                      "message   fdgf ${controller.audioData.value.data?.id?.toString()}");
                  if (!controller.isDataLoading.value &&
                      controller.audioData.value.data?.id != null) {
                    return AllRatingAndReviews(
                        contest: context,
                        enableVerticalMargin: true,
                        isDark: true,
                        fontSize: DimensionResource.fontSizeDefault - 2,
                        isCourse: controller.categoryType.value ==
                            CourseDetailViewType.audioCourse,
                        courseDatum: CourseDatum(
                            type: controller.categoryType.value ==
                                    CourseDetailViewType.audioCourse
                                ? AppConstants.audioCourse
                                : "audio",
                            id: controller.audioData.value.data?.id?.toString(),
                            name:
                                controller.audioData.value.data?.courseTitle ??
                                    controller.audioData.value.data?.title ??
                                    "",
                            rating: controller.audioData.value.data?.rating
                                    ?.toString() ??
                                ""));
                  } else {
                    return const SizedBox();
                  }
                }),
              ),
            ]),
          ),
        ],
      ),
    );
  }

  Widget audioCourseMoreLikeContainer(
      {bool isPlaying = true,
      required Datum data,
      Function()? onDownload,
      Function()? onPlayButton}) {
    return Card(
      margin: EdgeInsets.zero,
      color: ColorResource.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault,
            vertical: DimensionResource.marginSizeSmall),
        child: Row(
          children: [
            Expanded(
                flex: 7,
                child: Text(
                  data.title ?? data.topicTitle ?? "",
                  style: StyleResource.instance.styleSemiBold(
                      fontSize: DimensionResource.fontSizeDefault - 1,
                      color: ColorResource.primaryColor),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                )),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    !isPlaying
                        ? Text(
                            StringResource.nowPlaying,
                            style: StyleResource.instance.styleSemiBold(
                                fontSize:
                                    DimensionResource.fontSizeExtraSmall - 1,
                                color: ColorResource.lightYellowColor),
                          )
                        : SizedBox(
                            height: 23,
                            child: playIconButton(
                                bgColor: ColorResource.primaryColor,
                                iconColor: ColorResource.white,
                                onTap: onPlayButton,
                                allPadding: 6,
                                icon: ImageResource.instance.playIcon,
                                height: 14)),
                    const SizedBox(
                      height: DimensionResource.marginSizeSmall - 3,
                    ),
                    InkWell(
                      onTap: onDownload,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            StringResource.download,
                            style: StyleResource.instance.styleRegular(
                                fontSize:
                                    DimensionResource.fontSizeExtraSmall - 2,
                                color: isPlaying
                                    ? ColorResource.primaryColor
                                        .withOpacity(0.7)
                                    : ColorResource.primaryColor),
                          ),
                          const SizedBox(
                            width: DimensionResource.marginSizeExtraSmall - 3,
                          ),
                          Image.asset(
                            ImageResource.instance.arrowDownIcon,
                            height: 9,
                          )
                        ],
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget audioCourseDetailContainer(
      {bool isPlaying = true,
      required AudioCourseFile data,
      DownloadingStatus isDownloading = DownloadingStatus.error,
      Function()? onDownload,
      Function()? onPlayButton}) {
    return Card(
      margin: EdgeInsets.zero,
      color: ColorResource.white,
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault,
            vertical: DimensionResource.marginSizeSmall),
        child: Row(
          children: [
            Expanded(
                flex: 3,
                child: Text(
                  data.name,
                  style: StyleResource.instance.styleSemiBold(
                      fontSize: DimensionResource.fontSizeDefault - 1,
                      color: ColorResource.primaryColor),
                )),
            Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    !isPlaying
                        ? Text(
                            StringResource.nowPlaying,
                            style: StyleResource.instance.styleSemiBold(
                                fontSize:
                                    DimensionResource.fontSizeExtraSmall - 1,
                                color: ColorResource.lightYellowColor),
                          )
                        : SizedBox(
                            height: 23,
                            child: playIconButton(
                                bgColor: ColorResource.primaryColor,
                                iconColor: ColorResource.white,
                                onTap: onPlayButton,
                                allPadding: 6,
                                icon: ImageResource.instance.playIcon,
                                height: 14)),
                    const SizedBox(
                      height: DimensionResource.marginSizeSmall - 3,
                    ),
                    InkWell(
                      onTap: onDownload,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            isDownloading == DownloadingStatus.inQueue
                                ? StringResource.downloading
                                : isDownloading == DownloadingStatus.downloaded
                                    ? StringResource.downloaded
                                    : StringResource.download,
                            style: StyleResource.instance.styleRegular(
                                fontSize:
                                    DimensionResource.fontSizeExtraSmall - 2,
                                color: isPlaying
                                    ? ColorResource.primaryColor
                                        .withOpacity(0.7)
                                    : ColorResource.primaryColor),
                          ),
                          const SizedBox(
                            width: DimensionResource.marginSizeExtraSmall,
                          ),
                          isDownloading == DownloadingStatus.inQueue
                              ? const SizedBox(
                                  height: 9,
                                  width: 9,
                                  child: CircularProgressIndicator(
                                    color: ColorResource.mateGreenColor,
                                    strokeWidth: 1,
                                  ),
                                )
                              : Image.asset(
                                  isDownloading == DownloadingStatus.downloaded
                                      ? ImageResource.instance.checkIcon
                                      : ImageResource.instance.arrowDownIcon,
                                  height: 9,
                                )
                        ],
                      ),
                    )
                  ],
                )),
          ],
        ),
      ),
    );
  }

  Widget songProgress(
      BuildContext context, AudioCourseDetailController controller) {
    return Obx(() {
      return Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault),
        child: Row(
          children: <Widget>[
            SizedBox(
              width: 30,
              child: Center(
                child: Text(
                  formatDuration(
                      controller.progressAudioNotifier.value.total.inSeconds !=
                              0
                          ? controller.progressAudioNotifier.value.current
                          : const Duration(minutes: 0, seconds: 0)),
                  style: StyleResource.instance.styleMedium(
                      fontSize: DimensionResource.fontSizeExtraSmall,
                      color: ColorResource.white),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: audioSlider(context,
                    value: controller
                                .progressAudioNotifier.value.total.inSeconds !=
                            0
                        ? controller
                            .progressAudioNotifier.value.current.inSeconds
                            .toDouble()
                        : 0.0,
                    min: 0.0,
                    max: controller
                                .progressAudioNotifier.value.total.inSeconds !=
                            0
                        ? controller.progressAudioNotifier.value.total.inSeconds
                            .toDouble()
                        : 0.0,
                    onChanged: controller.onChange,
                    onChangedEnd: controller.onChangeEnd),
              ),
            ),
            Text(
              formatDuration(controller.progressAudioNotifier.value.total.inSeconds !=
                      0
                  ? controller.progressAudioNotifier.value.total
                  : Duration(
                      minutes: controller.categoryType.value ==
                              CourseDetailViewType.audio
                          ? (int.tryParse(controller.audioData.value.data?.duration ?? "0") ??
                              0)
                          : (int.tryParse(controller.audioData.value.data?.courseDetail?[controller.selectedIndex.value].duration ?? "0") ??
                              0),
                      seconds: controller.categoryType.value ==
                              CourseDetailViewType.audio
                          ? (int.tryParse(controller.audioData.value.data?.durationSec ?? "0") ??
                              0)
                          : (int.tryParse(controller
                                      .audioData
                                      .value
                                      .data
                                      ?.courseDetail?[controller.selectedIndex.value]
                                      .durationSec ??
                                  "0") ??
                              0))),
              style: StyleResource.instance.styleMedium(
                  fontSize: DimensionResource.fontSizeExtraSmall,
                  color: ColorResource.white),
            ),
          ],
        ),
      );
    });
  }
}

class UserAccessWidget extends StatelessWidget {
  const UserAccessWidget(
      {super.key, required this.isPro, this.isDark = false, this.color});

  final bool isPro;
  final bool isDark;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final authService = Get.find<AuthService>();
    Get.put(LoginController());
    String userRole = authService.userRole.value;
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault),
      child: Column(
        children: [
          Visibility(
            visible:
                // !Get.find<AuthService>().isPro.value &&
                //     isPro
                !Get.find<AuthService>().isGuestUser.value &&
                    userRole != 'pro_user',
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: DimensionResource.marginSizeSmall),
              child: CommonButton(
                text: StringResource.buyNowAgain,
                loading: false,
                onPressed: () {
                  if (Platform.isAndroid) {
                    // Get.find<RootViewController>().getPopUpData2();
                    Get.toNamed(Routes.subscriptionView);
                  }
                },
                color: ColorResource.primaryColor,
              ),
            ),
          ),
          Visibility(
            visible: Get.find<AuthService>().isGuestUser.value,
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: DimensionResource.marginSizeSmall),
              child: CommonButton(
                text: StringResource.signIn,
                loading: false,
                onPressed: () {
                  Get.find<LoginController>().emailController.text =
                      "Enter phone number";
                  Get.offAllNamed(Routes.loginScreen);
                },
                color: color ??
                    (isDark
                        ? ColorResource.primaryColor
                        : ColorResource.primaryColor),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

SliderTheme audioSlider(BuildContext context,
    {required double value,
    double? min,
    double? max,
    required Function(double) onChanged,
    required Function(double) onChangedEnd}) {
  return SliderTheme(
      data: SliderTheme.of(context).copyWith(
        trackHeight: 1,
        thumbColor: ColorResource.white,
        overlayColor: ColorResource.white,
        thumbShape: const RoundSliderThumbShape(
          disabledThumbRadius: 5,
          enabledThumbRadius: 8,
        ),
        overlayShape: const RoundSliderOverlayShape(
          overlayRadius: 8,
        ),
        activeTrackColor: ColorResource.greenColor,
        inactiveTrackColor: Colors.grey,
      ),
      child: Slider(
        min: min ?? 0.0,
        max: max ?? 1.0,
        value: value,
        onChanged: onChanged,
        onChangeEnd: onChangedEnd,
      ));
}

String formatDuration(Duration d) {
  int minute = d.inMinutes;
  int second = (d.inSeconds > 60) ? (d.inSeconds % 60) : d.inSeconds;
  String format =
      "${(minute < 10) ? "0$minute" : "$minute"}:${(second < 10) ? "0$second" : "$second"}";
  return format;
}
