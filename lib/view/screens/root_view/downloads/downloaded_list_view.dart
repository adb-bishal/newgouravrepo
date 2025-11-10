import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/service/floor/entity/download.dart' as db;
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/download_controller/download_list_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/audio_course_detail_controller/audio_course_detail_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/continue_watch_controller/continue_watch_controller.dart';

import '../../../../model/utils/app_constants.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../videoplayer.dart';
import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import '../../../../enum/routing/routes/app_pages.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../base_view/base_view_screen.dart';
import '../home_view/home_view_screen.dart';

class DownloadListView extends StatelessWidget {
  const DownloadListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: "Downloads",
      ),
      onActionBuilder: (context, controller) => [
        Visibility(
            visible: true,
            // kDebugMode,
            child: IconButton(
                onPressed: controller.onDeleteDownloads,
                icon: const Icon(
                  Icons.delete,
                  color: Colors.white,
                  size: 18,
                ))),
        //   IconButton(
        //       onPressed: (){
        //         Get.to(() => VideoListPage()
        //         );
        // },
        //       icon: const Icon(
        //         Icons.remove_red_eye,
        //         color: Colors.white,
        //         size: 18,
        //       ))
      ],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: DownloadListController(),
      onPageBuilder: (context, controller) =>
          _buildMainPage(context, controller),
    );
  }

  _buildMainPage(BuildContext context, DownloadListController controller) {
    final LiveClassDetailController liveClassDetailController =
    Get.put(LiveClassDetailController());
    return Obx(
          () =>
          SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: DimensionResource.marginSizeSmall),

                // Show message if no content exists
                if (controller.audio.isEmpty &&
                    controller.audioCourses.isEmpty &&
                    controller.video.isEmpty &&
                    controller.videoCourses.isEmpty &&
                    liveClassDetailController.downloadedVideos.isEmpty)

                  Center(
                    child: SizedBox(
                      height: 400,
                      child: Center(
                        child: Text(
                          "No Downloaded Content.\nGo ahead and Download now!",
                          style: StyleResource.instance.styleMedium(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),

                // Existing Sections for Video Courses, Audio, etc.
                // Add below a new section for downloaded videos

                if (liveClassDetailController.downloadedVideos.isNotEmpty) ...[
                  rowTile(() {
                    print('rtgrtbtr${liveClassDetailController.downloadedVideos}');
                    Get.toNamed(Routes.downloadDetailView, arguments: [
                      "Webinars",

                    ]);
                  },
                      'Webinars',
                      showIcon: true, enableTopPadding: false),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                      List.generate(liveClassDetailController.downloadedVideos.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index != 0
                                  ? DimensionResource.marginSizeSmall
                                  : 0),
                          child: GestureDetector(
                            onTap: () {
                              // Get.to(VideoPlayerScreen(
                              //     video: liveClassDetailController.downloadedVideos[index]));
                            },
                            child: webinarVideoContainer(
                              index,
                              liveClassDetailController.downloadedVideos[index],
                              width: AppConstants.instance.containerWidth,
                              height: AppConstants.instance.containerHeight,
                              isAudio: false,
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(height: DimensionResource.marginSizeSmall),
                ],

                if (controller.audio.isNotEmpty) ...[
                  rowTile(() {
                    Get.toNamed(Routes.downloadDetailView, arguments: [
                      "Audio",
                      CourseDetailViewType.audio,
                      controller.audio
                    ]);
                  }, StringResource.audios,
                      showIcon: true, enableTopPadding: false),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(controller.audio.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index != 0
                                  ? DimensionResource.marginSizeSmall
                                  : 0),
                          child: GestureDetector(
                              onTap: () {},
                              child: audioDownloadContainer(
                                  index, controller.audio[index],
                                  width: AppConstants.instance.containerWidth,
                                  height: 85,
                                  isAudio: true,
                                  fontSize: DimensionResource.fontSizeExtraSmall)),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall,
                  ),
                ],
                if (controller.audioCourses.isNotEmpty) ...[
                  rowTile(() {
                    Get.toNamed(Routes.downloadDetailView, arguments: [
                      "Audio",
                      CourseDetailViewType.audioCourse,
                      controller.audioCourses
                    ]);
                  }, StringResource.audioCourses,
                      showIcon: true, enableTopPadding: false),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                      List.generate(controller.audioCourses.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index != 0
                                  ? DimensionResource.marginSizeSmall
                                  : 0),
                          child: GestureDetector(
                            onTap: () {},
                            child: audioCourseDownloadContainer(
                                index, controller.audioCourses[index],
                                width: AppConstants.instance.containerWidth,
                                height: 78,
                                fontSize: DimensionResource.fontSizeExtraSmall),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall,
                  )
                ],
                if (controller.video.isNotEmpty) ...[
                  rowTile(() {
                    Get.toNamed(Routes.downloadDetailView, arguments: [
                      "Videos",
                      CourseDetailViewType.video,
                      controller.video
                    ]);
                  }, StringResource.videos,
                      showIcon: true, enableTopPadding: false),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(controller.video.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index != 0
                                  ? DimensionResource.marginSizeSmall
                                  : 0),
                          child: GestureDetector(
                            onTap: () {},
                            child: videoDownloadContainer(
                                index, controller.video[index],
                                width: AppConstants.instance.containerWidth,
                                height: AppConstants.instance.containerHeight,
                                isAudio: false),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall,
                  )
                ],
                if (controller.videoCourses.isNotEmpty) ...[
                  rowTile(() {
                    Get.toNamed(Routes.downloadDetailView, arguments: [
                      "Videos",
                      CourseDetailViewType.videoCourse,
                      controller.videoCourses
                    ]);
                  }, StringResource.videoCourses,
                      showIcon: true, enableTopPadding: false),
                  SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                      List.generate(controller.videoCourses.length, (index) {
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index != 0
                                  ? DimensionResource.marginSizeSmall
                                  : 0),
                          child: GestureDetector(
                            onTap: () {},
                            child: videoCourseDownloadContainer(
                                index, controller.videoCourses[index],
                                width: AppConstants.instance.containerWidth,
                                height: AppConstants.instance.containerWidth,
                                categoryType: "",
                                fontSize: DimensionResource.fontSizeExtraSmall),
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall,
                  )
                ]

              ],
            ),
          ),
    );
  }
}

audioDownloadContainer(int index, db.Audio content,
    {double height = 120,
      double width = 120,
      required bool isAudio,
      double fontSize = DimensionResource.fontSizeSmall}) {
  return InkWell(
    onTap: () {
      Get.toNamed(Routes.audioCourseDetail(id: content.id),
          arguments: AudioCourseDetailController.argument(
            audioId: content.id,
            categoryType: CourseDetailViewType.audio,
            catId: content.catId,
          ));
    },
    child: SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: cachedNetworkImage(
                  content.imagePath,
                  fit: BoxFit.cover,
                )),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.15),
                padding: const EdgeInsets.only(
                    top: DimensionResource.marginSizeExtraSmall + 2,
                    right: DimensionResource.marginSizeExtraSmall,
                    left: DimensionResource.marginSizeExtraSmall + 2,
                    bottom: DimensionResource.marginSizeSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 1,
                    ),
                    Text(
                      content.name,
                      style: StyleResource.instance.styleMedium(
                          fontSize: fontSize, color: ColorResource.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: isAudio ? TextAlign.left : TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isAudio,
              child: Align(
                alignment: Alignment.bottomRight,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(210 / 360),
                  child: Image.asset(
                    ImageResource.instance.volumeIcon,
                    height: 26,
                    color: ColorResource.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

audioCourseDownloadContainer(int index, db.AudioCourseFolder content,
    {double height = 87,
      double width = 132,
      double fontSize = DimensionResource.marginSizeSmall + 1}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: () {
      logPrint("audio Data ${content.id}");
      logPrint("audio Data ${content.courseId}");
      Get.toNamed(Routes.audioCourseDetail(id: content.id),
          arguments: AudioCourseDetailController.argument(
            audioId: content.id,
            categoryType: CourseDetailViewType.audioCourse,
            catId: content.catId,
          ));
    },
    child: Card(
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        height: height,
        width: width,
        decoration: BoxDecoration(
            color: ColorResource.parseHex(content.imagePath),
            borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.only(
            top: DimensionResource.marginSizeExtraSmall + 2,
            right: DimensionResource.marginSizeExtraSmall,
            left: DimensionResource.marginSizeExtraSmall + 2,
            bottom: DimensionResource.marginSizeSmall),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomRight,
              child: Image.asset(
                ImageResource.instance.volumeIcon,
                color: ColorResource.white.withOpacity(0.6),
                height: 18,
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 0,
                  ),
                  const Spacer(),
                  Text(
                    content.name,
                    style: StyleResource.instance.styleMedium(
                        fontSize: fontSize, color: ColorResource.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

videoDownloadContainer(int index, db.Video content,
    {double height = 120,
      double width = 120,
      required bool isAudio,
      double fontSize = DimensionResource.fontSizeSmall}) {
  return InkWell(
    onTap: () {
      AppConstants.instance.singleCourseId.value = (content.id.toString());

      Get.toNamed(Routes.continueWatchScreen(id: content.id),
          arguments: ContinueWatchController.argument(
              videoId: content.id, catId: content.catId));
    },
    child: SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: cachedNetworkImage(
                  content.imagePath,
                  fit: BoxFit.cover,
                )),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                color: Colors.black.withOpacity(0.15),
                padding: const EdgeInsets.only(
                    top: DimensionResource.marginSizeExtraSmall + 2,
                    right: DimensionResource.marginSizeExtraSmall,
                    left: DimensionResource.marginSizeExtraSmall + 2,
                    bottom: DimensionResource.marginSizeSmall),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 0,
                    ),
                    const Spacer(),
                    /*Obx(
                              () {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                (dataa.model?.avgRating == null || dataa.model?.avgRating == 0.0) && (dataa.avgRating == null || dataa.avgRating == 0.0)  ?const SizedBox():  StarContainer(
                                  rating: dataa.model?.avgRating == null ?dataa.avgRating.toString():dataa.model?.avgRating.toString()??"",
                                  bgColor: ColorResource.white,
                                  fontColor: ColorResource.secondaryColor,
                                ),
                                IconButtonLayout(
                                  onTap: ()async{
                                    await Get.find<RootViewController>().saveToWatchLater(id: dataa.id??0, type: isAudio ?"audio":"video", response: (WishListSaveModel wishListData){
                                      if(wishListData.data??false){
                                        if(dataa.model?.id != null){
                                          dataa.model?.isWishlist?.value = 1;
                                        }else{
                                          dataa.isWishlist!.value = 1;
                                        }
                                      }else {
                                        if(dataa.model?.id != null){
                                          dataa.model?.isWishlist?.value = 0;
                                        }else{
                                          dataa.isWishlist!.value = 0;
                                        }
                                      }
                                    });
                                  },
                                  secondImage: dataa.model?.id != null ? dataa.model?.isWishlist!.value == 1 ? ImageResource.instance.filledLikeIcon:null : dataa.isWishlist!.value == 1 ? ImageResource.instance.filledLikeIcon:null,
                                  image: ImageResource.instance.likeIcon,
                                  iconSize: 9,
                                  iconColor: ColorResource.redColor,
                                )
                              ],
                            );
                          }
                      )*/
                    /* Visibility(
                        visible: (dataa.isFree == 0 ? true:false),
                        child: const ProContainerButton(
                          isCircle: true,
                        ),
                      ),*/
                    Text(
                      content.name,
                      style: StyleResource.instance.styleMedium(
                          fontSize: fontSize, color: ColorResource.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 3,
                      textAlign: isAudio ? TextAlign.left : TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isAudio,
              child: Align(
                alignment: Alignment.bottomRight,
                child: RotationTransition(
                  turns: const AlwaysStoppedAnimation(210 / 360),
                  child: Image.asset(
                    ImageResource.instance.volumeIcon,
                    height: 26,
                    color: ColorResource.white.withOpacity(0.6),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

videoCourseDownloadContainer(int index, db.VideoCourseFolder content,
    {double height = 120,
      double width = 120,
      double fontSize = DimensionResource.fontSizeSmall,
      required String categoryType}) {
  return InkWell(
    splashColor: Colors.transparent,
    onTap: () {
      AppConstants.instance.videoCourseId.value = (content.id.toString());

      Get.toNamed(Routes.videoCourseDetail(id: content.id),
          arguments: [categoryType, content.id]);
    },
    child: SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: height,
                width: width,
                child: content.imagePath.isEmpty
                    ? Image.asset(
                  ImageResource.instance.cBg1Icon,
                  fit: BoxFit.cover,
                )
                    : cachedNetworkImage(
                  content.imagePath,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // height: height,
                // width: width,
                decoration: BoxDecoration(
                    color: ColorResource.redColor.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(
                    top: DimensionResource.marginSizeExtraSmall,
                    right: DimensionResource.marginSizeExtraSmall,
                    left: DimensionResource.marginSizeExtraSmall,
                    bottom: DimensionResource.marginSizeSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 0,
                    ),
                    const Spacer(),
                    /* Align(
                        alignment: Alignment.topRight,
                        child:
                        //dataa.avgRating == 0.0?const SizedBox():
                        (dataa.model?.avgRating == null || dataa.model?.avgRating == 0.0) && (dataa.avgRating == null || dataa.avgRating == 0.0)  ?const SizedBox():  StarContainer(
                          rating: dataa.model?.avgRating == null ?dataa.avgRating.toString():dataa.model?.avgRating.toString()??"",
                          bgColor: ColorResource.white,
                          fontColor: ColorResource.secondaryColor,
                        ),
                      ),*/
                    Text(
                      content.name.capitalize ?? "",
                      style: StyleResource.instance.styleMedium(
                          fontSize: fontSize, color: ColorResource.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  ],
                ),
              ),
            ),
            /*  Visibility(
                visible: (dataa.isFree == 0 ? true:false),
                child: const Center(
                  child: ProContainerButton(
                    isCircle: true,
                  ),
                ),
              ),*/
          ],
        ),
      ),
    ),
  );
}

webinarVideoContainer(
    int index,
    Video video, {
      required double width,
      required double height,
      double fontSize = DimensionResource.fontSizeSmall,

      bool isAudio = false,
    }) {
  final LiveClassDetailController liveClassDetailController =
  Get.put(LiveClassDetailController());

  return InkWell(
    onTap: (){
      Get.to(VideoPlayerScreen(
        videoPath: liveClassDetailController.downloadedVideos[index]));
    },
    child: SizedBox(
      width: width,
      height: height,
      child:
      Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: SizedBox(
                height: height,
                width: width,
                child: video.thumbnailPath.isEmpty
                    ? Image.asset(
                  ImageResource.instance.cBg1Icon,
                  fit: BoxFit.cover,
                )
                    : Image.file(
                  File(video.thumbnailPath),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                // height: height,
                // width: width,
                decoration: BoxDecoration(
                    color: ColorResource.redColor.withOpacity(0.24),
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.only(
                    top: DimensionResource.marginSizeExtraSmall,
                    right: DimensionResource.marginSizeExtraSmall,
                    left: DimensionResource.marginSizeExtraSmall,
                    bottom: DimensionResource.marginSizeSmall),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(
                      height: 0,
                    ),
                    const Spacer(),
                    /* Align(
                      alignment: Alignment.topRight,
                      child:
                      //dataa.avgRating == 0.0?const SizedBox():
                      (dataa.model?.avgRating == null || dataa.model?.avgRating == 0.0) && (dataa.avgRating == null || dataa.avgRating == 0.0)  ?const SizedBox():  StarContainer(
                        rating: dataa.model?.avgRating == null ?dataa.avgRating.toString():dataa.model?.avgRating.toString()??"",
                        bgColor: ColorResource.white,
                        fontColor: ColorResource.secondaryColor,
                      ),
                    ),*/
                    Text(
                      video.title ?? "",
                      style: StyleResource.instance.styleMedium(
                          fontSize: fontSize, color: ColorResource.white),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    )
                  ],
                ),
              ),
            ),
            InkWell(
                onTap: () {
                  liveClassDetailController.deleteVideo(video.id);
                  // dbHelper.deleteVideo(video.id!);
                },
                child
                    : Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: Icon(Icons.delete, color: Colors.white),
                )),


            /*  Visibility(
              visible: (dataa.isFree == 0 ? true:false),
              child: const Center(
                child: ProContainerButton(
                  isCircle: true,
                ),
              ),
            ),*/
          ],
        ),
      ),
    ),
  );
}
