import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/course_models/single_course_model.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/helper_util.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/scalps_widget.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/services/player/file_video_widget.dart';
import '../../../../model/services/player/video_player_widget.dart';
import '../../../../service/utils/download_file_util.dart';
import '../../../widgets/image_provider/image_provider.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../view_model/controllers/root_view_controller/continue_watch_controller/continue_watch_controller.dart';
import '../../../widgets/log_print/log_print_condition.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';
import '../../base_view/video_base_view.dart';
import '../audio_course_detail_view/audio_course_detail_view.dart';
import '../home_view/home_view_screen.dart';
import '../text_course_detail_view/text_course_detail_view.dart';
import '../video_course_detail_view/video_course_detail_view.dart';
import '../widget/add_rating_widget.dart';

class ContinueWatchView extends StatelessWidget {
  const ContinueWatchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return VideoBaseView(
      screenType: AppConstants.videoRedirect,
      isDataLoading: false.obs,
      viewControl: ContinueWatchController(),
      onBackClicked: (context, controller) {
        Get.back();
      },
      actionBuilder: (context, controller) => [],
      onVideoBuilder: (context, controller) => Obx(() => controller
              .isDataLoading.value
          ? const CommonCircularIndicator()
          : controller.selectedVideo.value.fileUrl == null
              ? const CommonCircularIndicator()
              : (Get.find<AuthService>().isGuestUser.value) ||
                      (!Get.find<AuthService>().isPro.value &&
                          controller.videoData.value.data?.isFree != 1) ||
                      (controller.selectedVideo.value.fileType == null ||
                          controller.selectedVideo.value.fileType == "")
                  ? controller.videoData.value.data?.thumbnail == null
                      ? const CommonCircularIndicator()
                      : cachedNetworkImage(
                          controller.videoData.value.data?.thumbnail ?? "")
                  : controller.selectedVideo.value.fileType == "Url"
                      ? YouTubePlayerWidget(
                          // isFullScreen:(isFullScreen){
                          //   controller.isFullScreen.value = isFullScreen;
                          // },
                          url: controller.selectedVideo.value.fileUrl ?? "",
                          eventCallBack: (event, totalDuration) async {
                            if (totalDuration > 0 &&
                                totalDuration - 60 <= event &&
                                controller.selectedVideo.value.id != null) {
                              if (controller.isHistoryUpload.value) {
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
                          })
                      : FileVideoWidget(
                          isVideo: controller.downloadStatus.value !=
                              DownloadingStatus.downloaded,
                          showQualityPicker: controller.downloadStatus.value !=
                              DownloadingStatus.downloaded,
                          url: controller.selectedVideo.value.fileUrl ?? "",
                          eventCallBack: (progress, totalDuration) async {
                            if (totalDuration - 60 <= progress &&
                                controller.selectedVideo.value.id != null) {
                              if (controller.isHistoryUpload.value) {
                                controller.updateVideoStatus(status: "1");
                                controller.isHistoryUpload.value = false;
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
                          })),
      onPageBuilder: (context, controller) =>
          mainBodyBuilder(context, controller),
    );
  }

  List<Widget> mainBodyBuilder(
      BuildContext context, ContinueWatchController controller) {
    return [
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault,
            vertical: DimensionResource.marginSizeSmall),
        child: Obx(() {
          return courseBox(
              courseImage: controller.videoData.value.data?.thumbnail ??
                  controller.offlineVideoData?.imagePath ??
                  "",
              courseName: controller.videoData.value.data?.title ??
                  controller.offlineVideoData?.name ??
                  "",
              rating: controller.videoData.value.data?.rating.toString() ?? "");
        }),
      ),
      // Obx(() {
      //   return MatchBoxWidget(
      //     matchCriteria:
      //         controller.videoData.value.data?.matchCriteria ?? MatchCriteria(),
      //   );
      // }),
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: DimensionResource.marginSizeDefault,
                  vertical: DimensionResource.marginSizeDefault),
              child: Obx(() {
                return descriptionReadMoreText(context ,controller
                        .videoData.value.data?.description
                        .toString()
                        .capitalize ??
                    "");
              }),
            ),
          ),
        ],
      ),
      Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault),
        child: Row(
          children: [
            Obx(() {
              logPrint(
                  "controller.downloadStatus.value =====>  ${controller.downloadStatus.value}");
              return Expanded(
                  child: (Get.find<AuthService>().isGuestUser.value) ||
                          (!Get.find<AuthService>().isPro.value &&
                              controller.videoData.value.data?.isFree != 1) ||
                          (controller.selectedVideo.value.fileType == null ||
                              controller.selectedVideo.value.fileType == "")
                      ? FunctionalityRowBuild(
                          isPaid: controller.videoData.value.data?.isFree != 1,
                          isDone: controller.downloadStatus.value ==
                              DownloadingStatus.downloaded,
                          bgColor: ColorResource.primaryColor.withOpacity(0.6),
                          icon: ImageResource.instance.downloadIcon,
                          title: StringResource.download,
                          onTap: () {})
                      : controller.downloadStatus.value ==
                              DownloadingStatus.started
                          ? LoaderButtonLayout(
                              onTap: () {},
                              iconSize: 16,
                              allPadding: 4,
                              iconColor: ColorResource.primaryColor,
                            )
                          : FunctionalityRowBuild(
                              isRestart: controller.downloadStatus.value ==
                                  DownloadingStatus.reDownload,
                              isPaid:
                                  controller.videoData.value.data?.isFree != 1,
                              isDone: controller.downloadStatus.value ==
                                  DownloadingStatus.downloaded,
                              bgColor: ColorResource.primaryColor,
                              icon: ImageResource.instance.downloadIcon,
                              title: StringResource.download,
                              onTap: controller.downloadStatus.value !=
                                      DownloadingStatus.downloaded
                                  ? controller.onDownloadClicked
                                  : () {}));
            }),
            const SizedBox(
              width: DimensionResource.marginSizeSmall,
            ),
            Expanded(
                child: FunctionalityRowBuild(
                    isPaid: controller.videoData.value.data?.isFree != 1,
                    isDone: false,
                    bgColor: ColorResource.mateGreenColor,
                    icon: ImageResource.instance.shareIcon,
                    title: StringResource.share,
                    onTap: () async {
                      await HelperUtil.instance
                          .buildInviteLink(
                              isAppShare: false,
                              shareId:
                                  "${controller.videoData.value.data?.id.toString()}/${controller.videoData.value.data?.categoryId.toString()}",
                              type: AppConstants.shareVideo)
                          .then((value) async {
                        await HelperUtil.share(
                                referCode: "", url: value.shortUrl.toString())
                            .then((value) {
                          // if(value != null && value){
                          //   Get.find<ScalpController>().onShare(data.id??0);
                          // }
                        });
                      });
                    })),
            const SizedBox(
              width: DimensionResource.marginSizeSmall,
            ),
            Expanded(child: Obx(() {
              return FunctionalityRowBuild(
                  isPaid: controller.videoData.value.data?.isFree != 1,
                  isDone:
                      controller.videoData.value.data?.isWishlist?.value == 1,
                  bgColor: ColorResource.mateRedColor,
                  icon: ImageResource.instance.addIcon,
                  title: StringResource.watchLater,
                  onTap: controller.onWatchLater);
            })),
          ],
        ),
      ),
      Obx(() => Visibility(
            visible: !controller.isDataLoading.value,
            child: UserAccessWidget(
                isPro: controller.videoData.value.data?.isFree != 1),
          )),
      Obx(() {
        return Visibility(
            visible:
                controller.moreLikeData.value.data?.data?.isNotEmpty ?? false,
            child: rowTile(() {}, StringResource.moreLike,
                showIcon: false, enableTopPadding: false));
      }),
      Obx(() => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(
                controller.moreLikeData.value.data?.data?.length ?? 0, (index) {
              Datum dataa =
                  controller.moreLikeData.value.data!.data!.elementAt(index);
              return InkWell(
                splashColor: Colors.transparent,
                onTap: Get.find<AuthService>().isGuestUser.value ||
                        (!Get.find<AuthService>().isPro.value &&
                            controller.videoData.value.data?.isFree != 1)
                    ? () {
                        ProgressDialog().showFlipDialog(
                            isForPro: Get.find<AuthService>().isGuestUser.value
                                ? false
                                : true);
                      }
                    : () {
                        controller.isDataLoading.value = true;
                        controller.videoId.value = dataa.id.toString();
                        controller.tagId.value = dataa.categoryId.toString();
                        controller.getVideoById();
                        // Get.toNamed(Routes.continueWatchScreen(id: dataa.id.toString()),arguments: [dataa.id.toString(),dataa.categoryId.toString()]);
                        // controller.selectedVideo.value = VideoTypePlayer(
                        //   id: dataa.id.toString() ?? "",
                        //   fileUrl: dataa.fileUrl ?? "",
                        //   fileType: dataa.fileType ?? "",
                        // );
                        logPrint(
                            "selected url ${controller.selectedVideo.value.fileUrl}");
                        controller.isHistoryUpload.value = true;
                        //controller.isDataLoading.value = false;
                      },
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: ColorResource.borderColor.withOpacity(0.6),
                          width: 1),
                      borderRadius: BorderRadius.circular(12)),
                  margin: EdgeInsets.only(
                      left: DimensionResource.marginSizeDefault,
                      right: DimensionResource.marginSizeDefault,
                      bottom: DimensionResource.marginSizeSmall,
                      top: index == 0
                          ? DimensionResource.marginSizeExtraSmall - 2
                          : 0),
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.marginSizeSmall,
                      vertical: DimensionResource.marginSizeSmall - 2),
                  child: Row(
                    children: [
                      SizedBox(
                        height: 62,
                        width: 72,
                        child: Card(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          margin: EdgeInsets.zero,
                          child: cachedNetworkImage(dataa.thumbnail ?? ""),
                        ),
                      ),
                      const SizedBox(
                        width: DimensionResource.marginSizeSmall,
                      ),
                      Expanded(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            dataa.title ?? "",
                            style: StyleResource.instance
                                .styleMedium(
                                  fontSize: DimensionResource.fontSizeSmall,
                                )
                                .copyWith(letterSpacing: 0.87),
                          ),
                          const SizedBox(
                            height: DimensionResource.marginSizeExtraSmall,
                          ),
                          Row(
                            children: [
                              Text(
                                "${dataa.duration} min",
                                style: StyleResource.instance
                                    .styleRegular(
                                        fontSize: DimensionResource
                                                .fontSizeExtraSmall -
                                            1,
                                        color: ColorResource.lightTextColor)
                                    .copyWith(letterSpacing: 0.87),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(
                                    horizontal:
                                        DimensionResource.marginSizeSmall),
                                child: Icon(
                                  Icons.circle,
                                  size: 6,
                                  color: ColorResource.lightTextColor,
                                ),
                              ),
                              Text(
                                AppConstants.formatDate(dataa.createdAt),
                                style: StyleResource.instance
                                    .styleRegular(
                                        fontSize: DimensionResource
                                                .fontSizeExtraSmall -
                                            1,
                                        color: ColorResource.lightTextColor)
                                    .copyWith(letterSpacing: 0.87),
                              ),
                            ],
                          )
                        ],
                      )),
                      SizedBox(
                          height: 40,
                          width: 40,
                          child: playIconLoaderButton(
                              icon: ImageResource.instance.playIcon,
                              bgColor: ColorResource.primaryColor,
                              iconColor: ColorResource.white,
                              allPadding: 13,
                              height: 13)),
                      //playIconButton(icon: ImageResource.instance.playIcon,bgColor: ColorResource.primaryColor,iconColor: ColorResource.white,allPadding: 14,height: 14),
                    ],
                  ),
                ),
              );
            }),
          )),
      Obx(() {
        return controller.isDataLoading.value
            ? Center(
                child: SizedBox(
                  height: 40,
                  child: Center(
                    child: Text(
                      "Loading ...",
                      style: StyleResource.instance.styleLight(
                          color: ColorResource.textColor_6,
                          fontSize: DimensionResource.fontSizeSmall),
                    ),
                  ),
                ),
              )
            : AllRatingAndReviews(
                contest: context,
                isCourse: false,
                enableVerticalMargin: true,
                courseDatum: CourseDatum(
                    id: controller.videoData.value.data?.id.toString(),
                    type: "video",
                    name: controller.videoData.value.data?.title ?? "",
                    rating: controller.videoData.value.data?.rating.toString()),
              );
      }),
    ];
  }
}
