import 'dart:io';
import 'dart:ui';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/courses_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/service/models/downloaded_file_model.dart';
import 'package:stockpathshala_beta/view/widgets/alert_dialog_popup.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';

import '../../../../model/models/course_models/single_course_model.dart';
import '../../../../model/models/course_models/single_video_detail_model.dart';
import '../../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../../model/services/background_download/background_run_util.dart';
import '../../../../model/services/background_download/singleton_global.dart';
import '../../../../service/floor/entity/download.dart';
import '../../../../service/utils/download_file_util.dart';
import '../../../../view/widgets/log_print/log_print_condition.dart';
import '../../../../view/widgets/view_helpers/progress_dialog.dart';
import '../root_view_controller.dart';
import '../video_course_detail_controller/video_course_detail_controller.dart';

class ContinueWatchController extends GetxController {
  CourseProvider courseProvider = getIt();
  RxString videoId = "".obs;
  RxString tagId = "".obs;
  RxBool isYouTubeVideo = false.obs;
  RxBool isDataLoading = false.obs;
  RxBool isHistoryUpload = true.obs;
  // RxBool isDownloading = false.obs;
  Rx<SingleVideoModel> videoData = SingleVideoModel().obs;
  Rx<SingleCourseModel> moreLikeData = SingleCourseModel().obs;
  Rx<VideoTypePlayer> selectedVideo = VideoTypePlayer().obs;
  Rx<DownloadingStatus> downloadStatus = DownloadingStatus.error.obs;
  RxInt countVal = 0.obs;
  Video? offlineVideoData;

  SingletonGlobal? singletonGlobal;
  late final DownloadUtil downloadUtil = DownloadUtil();

  onDownloadClicked() async {
    if (Get.find<AuthService>().isPro.value) {
      if ((selectedVideo.value.fileUrl ?? '').isNotEmpty &&
          (selectedVideo.value.fileUrl ?? '').toString().startsWith('http')) {
        PermissionUtil.instance.permission(
            title: StringResource.askStoragePermission,
            message: "messa ",
            permission: Permission.storage,
            onPermissionGranted: () async {
              List<DownloadQueue> downloadQueuesList = [];
              if ((selectedVideo.value.fileUrl ?? '')
                  .toString()
                  .startsWith('http')) {
                downloadQueuesList.add(DownloadQueue(
                    fileType: "video",
                    fileUrl: videoData.value.data?.fileType == "File"
                        ? videoData.value.data?.fileUrlDownload ?? ""
                        : selectedVideo.value.fileUrl ?? '',
                    fileName: videoData.value.data?.title ?? '',
                    type: Folder.video,
                    catId: '${videoData.value.data?.categoryId ?? ''}',
                    catName: videoData.value.data?.category?.title ?? '',
                    videoId: '${videoData.value.data?.id ?? ''}',
                    contentId: '${videoData.value.data?.id ?? ''}',
                    videoName: videoData.value.data?.title ?? '',
                    videoImage: videoData.value.data?.thumbnail ?? '',
                    rating: (videoData.value.data?.rating ?? 0).toString()));
              }
              final database = await DbInstance.instance();
              final downloadDao = database.downloadQueDao;
              await downloadDao.insertAll(downloadQueuesList);
              downloadStatus.value = DownloadingStatus.started;
              permissionHandler(onPermissionAllow: () {
                DownloadQueueUtil.instance.onInitFunction("downloadQueue");
              });
            });
      }
    } else {
      ProgressDialog().showFlipDialog(
          title: Platform.isAndroid
              ? "Download All Premium Stock Market Content as a Pro User. Continue?"
              : null,
          isForPro: Get.find<AuthService>().isGuestUser.value ? false : true);
    }
  }

  static argument({required String videoId, required String catId}) {
    return [videoId, catId];
  }

  @override
  void onInit() {
    singletonGlobal = SingletonGlobal(onStart: (map) {
      downloadStatus.value = DownloadingStatus.started;
      logPrint("onStrart singleton");
    }, onDownload: (map) {
      logPrint("onDownload complete $map");
      findVideoDownloaded();
    }, onError: (map) {
      logPrint("onError singleton");
      toastShow(message: 'Error while downloading the file');
      downloadStatus.value = DownloadingStatus.error;
    });
    if (Get.arguments != null) {
      videoId.value = Get.arguments[0] ?? "";
      tagId.value = Get.arguments[1] ?? "";
    }
    getVideoById();

    super.onInit();
  }

  findVideoDownloaded() async {
    logPrint("findVideoDownloaded");
    try {
      final database = await DbInstance.instance();
      Video? contents = await database.videoDao.findById(videoId.value);
      logPrint("contents ${contents.toString()}");
      logPrint("contents ${contents.toString()}");
      if (contents != null) {
        logPrint("check true");
        logPrint("check true");
        downloadStatus.value = DownloadingStatus.downloaded;
        return true;
      } else {
        logPrint("check false");
        logPrint("check false");
        downloadStatus.value = DownloadingStatus.started;
        return false;
      }
    } catch (e) {
      logPrint("checking download $e");
    }
  }

  findIsVideoDownloading() async {
    logPrint("isInDownload");
    try {
      final database = await DbInstance.instance();
      DownloadQueue? contents =
          await database.downloadQueDao.findById(videoId.value);
      logPrint("contents ${contents.toString()}");
      if (contents != null) {
        logPrint("check true");
        downloadStatus.value = DownloadingStatus.started;
        return true;
      } else {
        logPrint("check false");
        downloadStatus.value = DownloadingStatus.error;
        return false;
      }
    } catch (e) {
      logPrint("checking download $e");
    }
  }

  getVideoById() async {
    isDataLoading(true);
    var database = await DbInstance.instance();
    var videoDao = database.videoDao;
    offlineVideoData = await videoDao.findById(videoId.value);
    if (offlineVideoData == null) {
      downloadStatus.value = DownloadingStatus.error;
      findIsVideoDownloading();
    } else {
      downloadStatus.value = DownloadingStatus.downloaded;
    }
    await courseProvider.getVideoById(
        videoId: videoId.value,
        onError: (message, errorMap) {
          toastShow(message: message);
          processVideo();
          //isDataLoading(false);
        },
        onSuccess: (message, json) async {
          videoData.value = SingleVideoModel.fromJson(json!);
          processVideo(videoData.value);

          // isDataLoading(false);
          await courseProvider.getCourseMoreData(
              currentId: videoId.value,
              onError: (message, errorMap) {
                toastShow(message: message);
              },
              onSuccess: (message, json) {
                moreLikeData.value = SingleCourseModel.fromJson(json!);
              },
              catId: tagId.value,
              type: CourseDetailViewType.video,
              pageNo: 1);
        });
    // more like data api
  }

  updateVideoStatus({String? status}) async {
    EasyDebounce.debounce(
        countVal.value.toString(), const Duration(milliseconds: 1000),
        () async {
      await courseProvider.updateVideoStatus(mapData: {
        "type": "video",
        "trackable_id": videoId.value.toString(),
        "status": status
      }, onError: (message, errorMap) {}, onSuccess: (message, json) async {});
    });
    // more like data api
  }

  VoidCallback get onWatchLater => () async {
        await Get.find<RootViewController>().saveToWatchLater(
            id: videoData.value.data?.id ?? 0,
            type: "video",
            response: (WishListSaveModel data) {
              if (data.data ?? false) {
                videoData.value.data?.isWishlist!.value = 1;
              } else {
                videoData.value.data?.isWishlist!.value = 0;
              }
            });
      };

  void processVideo([SingleVideoModel? videoData]) {
    if (offlineVideoData != null &&
        offlineVideoData?.fileLocalPath != null &&
        offlineVideoData?.fileLocalPath != "") {
      try {
        // File file = File(offlineVideoData?.fileLocalPath ?? "");
        // List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
      } catch (e) {
        if (e is PathNotFoundException) {
          offlineVideoData?.fileLocalPath = "";
          offlineVideoData = null;
          toastShow(message: StringResource.noFileFound);
          Future.delayed(const Duration(seconds: 1), () {
            downloadStatus.value = DownloadingStatus.reDownload;
            onDownloadClicked();
          });
        }
      }
    }

    if (videoData != null) {
      selectedVideo.value = VideoTypePlayer(
        id: videoData.data?.id.toString() ?? "",
        fileUrl: (offlineVideoData?.fileLocalPath ?? '').isNotEmpty
            ? offlineVideoData?.fileLocalPath ?? ''
            : videoData.data?.fileUrl ?? "",
        fileType: (offlineVideoData?.fileLocalPath ?? '').isNotEmpty
            ? 'File'
            : videoData.data?.fileType ?? "",
      );

      logPrint("process Video ${selectedVideo.value.fileUrl}");
    } else if (offlineVideoData != null) {
      selectedVideo.value = VideoTypePlayer(
        id: offlineVideoData?.id ?? "",
        fileUrl: offlineVideoData?.fileLocalPath ?? "",
        fileType: "File",
      );
    }
    isDataLoading(false);
  }

  @override
  void onClose() {
    singletonGlobal?.unbindBackgroundIsolate();
    super.onClose();
  }
}
