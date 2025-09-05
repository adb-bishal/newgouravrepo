import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../model/models/common_container_model/common_container_model.dart';
import '../../../model/models/wishlist_data_model/wishlist_data_model.dart';
import '../../../model/network_calls/api_helper/provider_helper/wishlist_provider.dart';

import '../../../model/services/auth_service.dart';
import '../../../model/utils/app_constants.dart';
import '../../../model/utils/string_resource.dart';
import '../../../service/floor/entity/download.dart' as db;
import '../../../videoplayer.dart';
import '../../../view/screens/root_view/home_view/widget/audio_course_widget.dart';
import '../../../view/screens/root_view/home_view/widget/audio_widget.dart';
import '../../../view/screens/root_view/home_view/widget/text_course_widget.dart';
import '../../../view/screens/root_view/home_view/widget/video_course_widget.dart';
import '../../../view/screens/root_view/home_view/widget/videos_widget.dart';
import '../../../view/widgets/toast_view/showtoast.dart';
import '../../routes/app_pages.dart';
import '../root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';

class DownloadListController extends GetxController {
  RxString categoryType = "".obs;
  WishListProvider wishListProvider = getIt();
  RxBool isDataLoading = false.obs;
  Rx<WishListDataModel> wishListData = WishListDataModel().obs;
  List<Widget> items = <Widget>[].obs;

  List<db.Audio> audio = <db.Audio>[].obs;
  List<db.AudioCourseFolder> audioCourses = <db.AudioCourseFolder>[].obs;

  List<db.Video> video = <db.Video>[].obs;
  List<db.VideoCourseFolder> videoCourses = <db.VideoCourseFolder>[].obs;

  final LiveClassDetailController liveClassDetailController =
  Get.put(LiveClassDetailController());

  final DatabaseHelper dbHelper = DatabaseHelper();

  final isProExpUser =
      Get.find<AuthService>().isProExpired.value;
  final isTriaExplUser =
      Get.find<AuthService>()
          .isTrialExpired
          .value;



  @override
  void onInit() {
    super.onInit();
    getAllContent();
    liveClassDetailController.loadVideos();
    deleteContent();
  }

  deleteContent(){
    print('swdfwdce');
    if(isProExpUser || isTriaExplUser){
      print('swdfwdce');
      onDeleteDownloads();
      dbHelper.deleteAllVideos();
      liveClassDetailController.loadVideos();

      audio.clear();
      audioCourses.clear();
      video.clear();
      videoCourses.clear();
    }
  }

  onDeleteDownloads() async {
    var database = await db.DbInstance.instance();
    await database.videoDao.clearAllVideo();
    await database.audioDao.clearAllAudio();
    await database.videoCourseFileDao.clearAllVideoCourseFile();
    await database.videoCourseFolderDao.clearAllVideoCourseFolder();
    await database.downloadQueDao.clearAllDownload();
    await database.audioCourseFileDao.clearAllAudioCourseFile();
    await database.audioCourseFolderDao.clearAllAudioCourseFolder();
    getAllContent();
  }

  void getAllContent() async {


    audio.clear();
    audioCourses.clear();

    video.clear();
    videoCourses.clear();



    var database = await db.DbInstance.instance();

    database.audioDao.findAllAudio().then((value) {
      logPrint("audio ${value.length}");
      audio.addAll(value);
    });

    database.audioCourseFolderDao.findAllAudioFolder().then((value) {
      logPrint("audioCourse ${value.length}");
      audioCourses.addAll(value);
    });

    database.videoDao.findAllVideo().then((value) {
      logPrint("video ${value.length}");
      video.addAll(value);

    });

    database.videoCourseFolderDao.findAllVideoFolder().then((value) {
      logPrint("videoCourse ${value.length}");
      videoCourses.addAll(value);
    });
  }

  getWishlistsData() async {
    isDataLoading.value = true;
    await wishListProvider.getWishlistsData(onError: (message, errorMap) {
      isDataLoading.value = false;
      toastShow(message: message);
    }, onSuccess: (message, json) {
      wishListData.value = WishListDataModel.fromJson(json!);
      if (wishListData.value.data?.video?.isNotEmpty ?? false) {
        items.add(VideosWidget(
          data: List<CommonDatum>.from(wishListData.value.data!.video!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onTap: () {
            Get.toNamed(Routes.watchLaterSeeAllView,
                arguments: [StringResource.singleVideo, "video"]);
          },
        ));
      }
      if (wishListData.value.data?.audio?.isNotEmpty ?? false) {
        items.add(AudiosWidget(
          data: List<CommonDatum>.from(wishListData.value.data!.audio!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onTap: () {
            Get.toNamed(Routes.watchLaterSeeAllView, arguments: [
              StringResource.singleAudio,
              "audio",
            ]);
          },
        ));
      }
      // if(wishListData.value.data?.blog?.isNotEmpty??false){
      //   items.add(BlogsWidget(
      //     data: List<CommonDatum>.from(wishListData.value.data!.blog!.map((x) => CommonDatum.fromJson(x.model?.toJson()??{}))),
      //     onTap: (){
      //       Get.toNamed(Routes.watchLaterSeeAllView,arguments: [StringResource.,"video"]);          },
      //   ));
      //   count++;
      // }
      if (wishListData.value.data?.courseVideo?.isNotEmpty ?? false) {
        items.add(VideoCourseWidget(
          data: List<CommonDatum>.from(wishListData.value.data!.courseVideo!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onTap: () {
            Get.toNamed(Routes.watchLaterSeeAllView, arguments: [
              StringResource.videoCourses,
              AppConstants.videoCourse
            ]);
          },
        ));
      }
      if (wishListData.value.data?.courseText?.isNotEmpty ?? false) {
        items.add(TextCourseWidget(
          categoryType: StringResource.watchLater,
          data: List<CommonDatum>.from(wishListData.value.data!.courseText!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onTap: () {
            Get.toNamed(Routes.watchLaterSeeAllView, arguments: [
              StringResource.textCourses,
              AppConstants.textCourse
            ]);
          },
        ));
      }
      if (wishListData.value.data?.courseAudio?.isNotEmpty ?? false) {
        items.add(AudioCourseWidget(
          data: List<CommonDatum>.from(wishListData.value.data!.courseAudio!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onSeeAll: () {
            Get.toNamed(Routes.watchLaterSeeAllView, arguments: [
              StringResource.audioCourses,
              AppConstants.audioCourse
            ]);
          },
        ));
      }
      isDataLoading.value = false;
    });
  }
}
