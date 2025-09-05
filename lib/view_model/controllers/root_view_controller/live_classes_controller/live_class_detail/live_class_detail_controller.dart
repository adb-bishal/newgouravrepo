import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:path/path.dart';
import 'package:stockpathshala_beta/model/models/batch_models/batch_details_model.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';

import '../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../model/models/live_class_model/live_class_detail_model.dart';
import '../../../../../model/models/popup_model/PopUpModel.dart';
import '../../../../../model/network_calls/api_helper/provider_helper/batch_provider.dart';
import '../../../../../model/network_calls/api_helper/provider_helper/live_provider.dart';
import '../../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/image_resource.dart';
import '../../../../../model/utils/string_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../videoplayer.dart';
import '../../../../../view/screens/root_view/live_classes_view/live_class_detail/live_class_webview.dart';
import '../../../../../view/widgets/button_view/common_button.dart';
import '../../../../../view/widgets/toast_view/showtoast.dart';
import '../../../../../view/widgets/view_helpers/progress_dialog.dart';
import '../../../../routes/app_pages.dart';
import '../live_classes_controller.dart';

import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class LiveClassDetailController extends GetxController {
  LiveProvider liveProvider = getIt();
  BatchProvider batchProvider = getIt();

  // Observables for various states
  RxBool isRegistered = false.obs;

  RxBool isDataLoading = false.obs;
  RxBool isContactLoading = false.obs;
  RxBool isPast = false.obs;
  RxBool isSeeAllEnable = false.obs;
  RxBool isBuyLoading = false.obs;

  RxBool isStarted = false.obs;
  RxInt start = 0.obs;
  RxInt countValue = 0.obs;
  RxString time = "".obs;
  RxString title = "".obs;
  RxString liveClassId = "".obs;

  Timer? timer;

  RxList<CommonDatum> moreLikeData = <CommonDatum>[].obs;
  Rx<LiveClassDetailModel> liveClassDetail = LiveClassDetailModel().obs;
  final liveClassesController = Get.lazyPut(() => LiveClassesController());

  int? batchId;
  int? batchDateId;
  int? pageNo;

  final String? toCheck;

  // Constructor
  LiveClassDetailController({this.toCheck});

  // Download state observables

  // var isDownloading = false.obs;
  // var downloadProgress = 0.0.obs;
  // var downloadStatus = ''.obs;
  // var isDownloaded = false.obs;

  // Controller variables to track download progress and state for each video
  RxMap<String, bool> isDownloadedMap = RxMap<String, bool>({});
  RxMap<String, double> downloadProgressMap = RxMap<String, double>({});
  RxMap<String, String> downloadStatusMap = RxMap<String, String>({});
  RxMap<String, bool> isDownloadingMap = RxMap<String, bool>({});

  RxBool isDownloading = false.obs;
  RxBool isDownloaded = false.obs;
  RxBool videoAlreadyDownloaded = false.obs;

  RxDouble downloadProgress = 0.0.obs;
  RxString downloadStatus = "".obs;

  var videos = <Video>[].obs; // Use an Rx list to hold the videos.
  var isLoading = true.obs;

// Store active download details to ensure state persistence
  String? currentFileName;
  String? currentFileUrl;

  var downloadedVideos = <Video>[].obs;
  final DatabaseHelper dbHelper = DatabaseHelper();

  // Load videos from the database
  Future<void> loadVideos() async {
    List<Video> videos = await dbHelper.getVideos();
    downloadedVideos.assignAll(videos);
  }

  Future<void> fetchVideos() async {
    isLoading(true); // Set loading to true while fetching.
    final dbHelper = DatabaseHelper();
    try {
      List<Video> videoList =
          await dbHelper.getVideos(); // Assume getVideos is async.
      videos.assignAll(videoList); // Update the reactive list.
    } catch (e) {
      print('Error fetching videos: $e');
    } finally {
      isLoading(false); // Set loading to false once the fetching is done.
    }
  }

  @override
  void onInit() async {
    fetchVideos();
    loadVideos();
    // if (currentFileUrl != null &&
    //     currentFileName != null &&
    //     isDownloading.value) {
    //   // UI state will reflect the ongoing download
    //   isDownloading.value = true;
    // }

    if (Get.arguments != null && Get.arguments[0] is bool) {
      isPast.value = Get.arguments[0];
      liveClassId.value = Get.arguments[1];

      if ((Get.arguments as List).length > 3) {
        batchId = Get.arguments[2];
        batchDateId = Get.arguments[3];
        pageNo = Get.arguments[4];
      }
    }
    await getLiveDataDetail();
    getDownloadState();
    Get.find<RootViewController>().getTrialData();
    super.onInit();
  }

// Assuming you have a map to track the downloaded state of videos by title (or videoUrl)

  Future<void> getDownloadState() async {
    try {
      // Retrieve the list of downloaded videos from the database
      List<Video> videos = await dbHelper.getVideos();
      print('Retrieved videos: ${videos.map((video) => video.title).toList()}');
      // Compare titles after trimming and converting to lowercase
      bool isMatch = videos.any((video) =>
          video.title.trim().toLowerCase() == title.trim().toLowerCase());
      print('Does the title match: $isMatch');
      print('Does the title match: ${title}');
      videoAlreadyDownloaded.value = isMatch;
      if (videoAlreadyDownloaded.value == true) {
        // If the video is already downloaded, show a toast message
        isDownloaded.value = true;
        print('Video already downloaded: $isDownloaded');
        toastShow(message: "Video is already downloaded.");
      } else {
        isDownloaded.value = false;
        print('Video not downloaded yet.');
      }
    } catch (e) {
      print('Error while checking download state: $e');
    }
  }

  // Future<void> getDownloadState() async {
  //   try {
  //     // Retrieve the list of downloaded videos from the database
  //     List<Video> videos = await dbHelper.getVideos();
  //     print('Retrieved videos: ${videos.map((video) => video.title).toList()}');
  //
  //     // Compare titles after trimming and converting to lowercase
  //     bool isMatch = videos.any((video) =>
  //     video.title.trim().toLowerCase() == title.trim().toLowerCase());
  //
  //     print('Does the title match: $isMatch');
  //
  //     videoAlreadyDownloaded.value = isMatch;
  //
  //     if (isMatch) {
  //       // If the video is already downloaded, show a toast message
  //       isDownloaded.value = true;
  //
  //       // Assuming you want to track by video title
  //       isDownloadedMap[title.trim().toLowerCase()] = true;  // Mark the video as downloaded in the map
  //
  //       print('Video already downloaded: $isDownloaded');
  //       toastShow(message: "Video is already downloaded.");
  //     } else {
  //       isDownloaded.value = false;
  //       // Video is not downloaded yet, mark as false in the map
  //       isDownloadedMap[title.trim().toLowerCase()] = false;
  //       print('Video not downloaded yet.');
  //     }
  //   } catch (e) {
  //     print('Error while checking download state: $e');
  //   }
  // }

  @override
  void onClose() async {
    // unawaited(Get.find<LiveClassesController>().getLiveData(
    //   pageNo: 1,
    //   callFromRegister: batchId != null ? false : true,
    // ));
    update();
    super.onClose();
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    if (start.value == 0) {
      timer?.cancel();
      start.value = 10;
      time.value = "10";
    }
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
          isStarted.value = true;
        } else {
          start--;
          time.value = start.value < 10 ? "0$start" : "$start";
        }
      },
    );
  }

  Future<void> getLiveDataDetail({bool fromPayment = false}) async {
    isDataLoading.value = true;
    await liveProvider.getLiveDataDetail(
      id: liveClassId.value,
      onError: (message, errorMap) {
        toastShow(message: message);
        isDataLoading.value = false;
      },
      onSuccess: (message, json) async {
        liveClassDetail.value = LiveClassDetailModel.fromJson(json!);
        isRegistered.value = liveClassDetail.value.data?.isRegister == 1;
        title.value = liveClassDetail.value.data!.title!;
        isDataLoading.value = false;
        print('sdsdc ${title}');
      },
    );
    if (batchId != null) {
      await getUpcommingClassData();
    }
  }

  Future<void> getUpcommingClassData() async {
    await batchProvider.getBatchData(
      batchId: liveClassDetail.value.data?.batchId ?? 0,
      batchStartDate: liveClassDetail.value.data?.batchStartDate ?? 0,
      isPast: isPast.value,
      pageNo: pageNo,
      onError: (message, errorMap) {
        toastShow(message: message);
      },
      onSuccess: (message, json) {
        BatchClassViewModel data = BatchClassViewModel.fromJson(json!);
        if (data.data?.data?.isNotEmpty ?? false) {
          data.data?.data?.removeWhere((element) =>
              element.batchId == null ||
              !(element.batchId == liveClassDetail.value.data?.batchId &&
                  element.batchStartDate ==
                      liveClassDetail.value.data?.batchStartDate) ||
              (DateTime.tryParse(element.startDatetime ?? '')?.isBefore(
                      liveClassDetail.value.data?.startTime
                              ?.add(const Duration(hours: 1)) ??
                          DateTime((int.parse(
                              liveClassDetail.value.serverTime.toString())))) ??
                  false));
          moreLikeData.value = List<CommonDatum>.generate(
              (data.data?.data?.length ?? 0) < 6
                  ? data.data?.data?.length ?? 0
                  : 6,
              (index) =>
                  CommonDatum.fromJson(data.data?.data?[index].toJson() ?? {}));
          isSeeAllEnable.value = true;
        }
      },
    );
  }

  Future<void> downloadVideo(
      String videoUrl, String fileName, String thumbnail) async {
    // Assuming videoUrl is unique for each video

    // Set the video as downloading
    isDownloadingMap[videoUrl] = true;
    downloadProgressMap[videoUrl] = 0.0;
    downloadStatusMap[videoUrl] = "Starting download...";

    try {
      Directory appDocDirectory = await getApplicationDocumentsDirectory();
      String videoSavePath =
          '${appDocDirectory.path}/video_${DateTime.now().millisecondsSinceEpoch}.mp4';
      String thumbnailSavePath =
          '${appDocDirectory.path}/thumbnail_${DateTime.now().millisecondsSinceEpoch}.jpg';

      Dio dio = Dio();
      await dio.download(
        videoUrl,
        videoSavePath,
        onReceiveProgress: (received, total) {
          if (total != -1) {
            downloadProgressMap[videoUrl] =
                received / total; // Update progress for the specific video
            double downloadedMb = received / (1024 * 1024);
            double totalMb = total / (1024 * 1024);
            downloadStatusMap[videoUrl] = "${totalMb.toStringAsFixed(2)} MB";
          }
        },
      );

      // Download the thumbnail
      await dio.download(thumbnail, thumbnailSavePath);
      print("Thumbnail downloaded: $thumbnailSavePath");

      // Create a Video object and insert it into the database
      Video video = Video(
        path: videoSavePath,
        title: fileName,
        thumbnailPath: thumbnailSavePath,
      );
      await dbHelper.insertVideo(video);
      downloadedVideos.add(video);
      toastShow(message: "Check Downloaded file in the Download Section.");

      // Mark as downloaded
      isDownloadingMap[videoUrl] = false; // Set downloading to false
      isDownloaded.value = true; // Set downloading to false
    } catch (e) {
      print('Download failed: $e');
      toastShow(message: "Download failed: $e");
      isDownloadingMap[videoUrl] = false;
    }
  }

  expireTrialPlanPopUp(
    String? imgUrl,
    String? title,
    String? subTitle,
    String? btTitle,
  ) {
    Get.bottomSheet(
      Container(
        width: double.infinity, // Full width
        decoration: const BoxDecoration(
          color: Colors.white, // Background color
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), // Rounded corners
            topRight: Radius.circular(25.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              (imgUrl != null && imgUrl.isNotEmpty)
                  ? Image.network(
                      imgUrl,
                      height: 100,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        ImageResource.instance.expiredIcon,
                        height: 100,
                      ),
                    )
                  : Image.asset(
                      ImageResource.instance.expiredIcon,
                      height: 100,
                    ),
              const SizedBox(height: 15),
              Text(
                title ?? "Oh! Your Plan has Expired",
                style:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2,
                ),
                child: Text(
                  subTitle ?? "Buy Pro to Continue Your Learning.",
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14),
                ),
              ),
              const SizedBox(height: 15),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: 120,
                  height: 35,
                  child: CommonButton(
                    color: ColorResource.primaryColor,
                    text: btTitle ?? "Buy Pro",
                    loading: false,
                    onPressed: () {
                      Get.back();
                      Get.toNamed(Routes.subscriptionView);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      enableDrag: true,
    );
  }

  Future<void> deleteVideo(int? id) async {
    await dbHelper.deleteVideo(id!);
    loadVideos();
    // loadVideos(); // Reload videos after deletion
  }

  void playOfflineVideo(String filePath) {
    if (File(filePath).existsSync()) {
      // Get.to(() => OfflineVideoPlayerScreen(videoFilePath: filePath));
    } else {
      toastShow(message: "File not found at $filePath");
    }
  }

  postVideoJoinStatus(bool isRegister,
      {Function(Map<String, dynamic>? map)? onSuccess}) async {
    await liveProvider.postVideoJoinStatus(
        onError: (message, errorMap) {
          logPrint("on error method called ::");

          toastShow(message: message);
        },
        onSuccess: (message, json) {
          int lastPage = 0;

          logPrint("json is ${json}");
          if (json?['status'] == true &&
              (json?['data'].containsKey('popup_data') ?? false)) {
            logPrint(" status is ${json?['status']}");
            logPrint(" status is ${json?['status']}");
            Get.find<LiveClassesController>().onRegisterPopUp(json!);
          } else {
            if (isRegister) {
              logPrint(" status is  ::${json?['status']}");
              if (json != null && json['data']['participant_link'] != null) {
                liveClassDetail.value.data?.participantLink?.value =
                    json['data']['participant_link'].toString();
              }


              Get.find<LiveClassesController>().update();
              // Get.find<LiveClassesController>()
              //     .dataPagingController
              //     .value
              //     .list
              //     .clear();

              // lastPage =
              //     Get.find<LiveClassesController>().lastVisitedPage.value;

              // print("sdkjbnkjwebrjbwe lastPage is : ${lastPage}");
              // for (int page = 1; page <= lastPage; page++) {
              //   print("sdkjbnkjwebrjbwe lastPagee is : ${page}");
              //   // Infinite loop, will break when no more data
              Get.find<LiveClassesController>().getLiveData(pageNo: 1);
              // Get.find<LiveClassesController>().onRefresh();
              // }

              // unawaited(Get.find<LiveClassesController>()
              //     .getLiveData(pageNo: 1, callFromRegister: true));

              isRegistered.value = true;
            }
            if (onSuccess != null) {
              onSuccess(json ?? {});
            }
          }
        },
        onComplete: () {
          // Handle completion, equivalent to onComplete
          logPrint("on Complete method called ::");
          isDataLoading.value = false;
          // dataPagingController.value.isDataLoading.value = false;
        },
        mapData: {
          "live_class_id": liveClassDetail.value.data?.id,
          "type": isRegister ? "register" : "join",
          "device": Platform.isIOS ? "ios" : "android"
        });
  }

  onRegister() {
    if (!isRegistered.value) {
      logPrint("isRegistered value is ${isRegistered.value}");
      postVideoJoinStatus(
        true,
      );
      logPrint("isRegistered value is bahar ${isRegistered.value}");
      Get.find<RootViewController>().getProfile();
    }
  }

  onJoinNow() async {
    // await _onRegister();
    postVideoJoinStatus(false, onSuccess: (json) {
      if (json?['data']['participant_link'] != null) {
        Navigator.push(
          Get.context!,
          MaterialPageRoute(
            builder: (context) => LiveClassLaunch(
              title: liveClassDetail.value.data?.title ?? "",
              url: json?['data']['participant_link'],
              // data: liveClassDetail.value
            ),
          ),
        );
      }
    });
  }

//
// void onRegister() {
//   if (!isRegistered.value) {
//     postVideoJoinStatus(true);
//     Get.find<RootViewController>().getProfile();
//   }
// }
//
// void onJoinNow() async {
//   postVideoJoinStatus(false, onSuccess: (json) {
//     if (json?['data']['participant_link'] != null) {
//       Navigator.push(
//         Get.context!,
//         MaterialPageRoute(
//           builder: (context) => LiveClassLaunch(
//             title: liveClassDetail.value.data?.title ?? "",
//             url: json?['data']['participant_link'],
//           ),
//         ),
//       );
//     }
//   });
// }
}
