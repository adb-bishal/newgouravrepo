import 'dart:async';
import 'dart:io';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/courses_provider.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/service/floor/entity/download.dart';
import 'package:stockpathshala_beta/view/screens/root_view/widget/add_rating_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/widget_controllers/show_rating_controller.dart';

import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/course_models/course_by_id_model.dart';
import '../../../../model/models/course_models/course_history_model.dart';
import '../../../../model/models/course_models/course_status_model.dart';
import '../../../../model/models/course_models/courses_model.dart';
import '../../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/services/background_download/background_run_util.dart';
import '../../../../model/services/background_download/singleton_global.dart';
import '../../../../model/utils/app_constants.dart';
import '../../../../service/models/downloaded_file_model.dart';
import '../../../../service/utils/download_file_util.dart';
import '../../../../view/widgets/alert_dialog_popup.dart';
import '../../../../view/widgets/view_helpers/progress_dialog.dart';

class VideoCourseDetailController extends GetxController {
  late FlutterIsolate isolate;
  CourseProvider courseProvider = getIt();
  RxString categoryType = "".obs;
  RxString courseId = "".obs;
  RxString courseName = "".obs;
  RxInt videoIndex = 0.obs;
  RxInt countVal = 0.obs;
  RxBool isDataLoading = false.obs;
  RxBool isHistoryUpload = true.obs;
  RxBool isSelectedVideoChange = false.obs;
  RxBool downloadingLoader = false.obs;

  static RxBool courseIsTrail = false.obs;

  Rx<CourseByIdModel> courseData = CourseByIdModel().obs;
  RxList<CommonDatum> moreLikeData = <CommonDatum>[].obs;
  Rx<VideoTypePlayer> selectedVideo = VideoTypePlayer().obs;
  Rx<CourseHistoryModel> courseHistoryData = CourseHistoryModel().obs;
  Rx<CourseStatus> courseStatus = CourseStatus().obs;

  VideoCourseFolder? offlineVideoCourseData;
  List<VideoCourseFile> courseDataList = <VideoCourseFile>[].obs;
  List<DownloadStatusList> statusOfFileDownload = <DownloadStatusList>[].obs;

  var downloadStatus = DownloadingStatus.error.obs;

  //StreamSubscription? playingMediaSubscription;
  SingletonGlobal? singletonGlobal;

  updateVideoStatus({String? status}) async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      EasyDebounce.debounce(
          countVal.value.toString(), const Duration(milliseconds: 1000),
          () async {
        await courseProvider.updateVideoStatus(
            mapData: {
              "type": "course_video",
              "trackable_id": courseData.value.data?.id.toString(),
              "status": status
            },
            onError: (message, errorMap) {},
            onSuccess: (message, json) async {});
      });
    }
  }

  VoidCallback get onDownloadClicked => () async {
    PermissionUtil.instance.permission(
      title: StringResource.askStoragePermission,
      message: "messa ",
      permission: Permission.mediaLibrary,
      onPermissionGranted: () async {

        if (courseDataList.isNotEmpty) {
          List<DownloadQueue> downloadQueuesList = [];
          for (VideoCourseFile data in courseDataList) {
            logPrint("file url: ${data.fileUrl}");

            if ((data.fileUrl).toString().endsWith('mp4')) {
              downloadStatus.value = DownloadingStatus.started;

              // Check if the download status is not already "downloaded" or "inQueue"
              if (statusOfFileDownload.any((element) =>
              element.chapterId == data.id &&
                  (element.downloadStatus != DownloadingStatus.downloaded &&
                      element.downloadStatus != DownloadingStatus.inQueue))) {

                // Add the download task to the queue
                downloadQueuesList.add(DownloadQueue(
                  fileType: 'video',
                  folderName: data.name,
                  fileUrl: data.fileUrl,
                  fileName: data.name,
                  type: Folder.videoCourse,
                  catId: data.catId,
                  catName: data.catName,
                  courseId: data.courseId,
                  courseName: data.courseName,
                  courseImage: courseData.value.data?.thumbnails ??
                      offlineVideoCourseData?.imagePath ??
                      '',
                  contentId: data.id,
                  videoId: data.id,
                  videoName: data.name,
                  videoImage: data.imagePath,
                  videoDuration: data.duration,
                  rating: data.rating,
                ));

                // Update status to "inQueue"

                statusOfFileDownload[statusOfFileDownload.indexWhere(
                        (element) => element.chapterId == data.id)] =
                    DownloadStatusList(
                      chapterId: data.id,
                      catId: data.catId,
                      downloadStatus: DownloadingStatus.inQueue,
                    );

              }
            } else {
              // Show a warning dialog if the file is not an MP4
              await Get.dialog(
                AlertDialog(
                  title: Text("Unsupported File Format"),
                  content: Text(
                      "The file '${data.fileUrl}' is not an MP4 file and cannot be downloaded."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Get.back(); // Close the dialog
                      },
                      child: Text("OK"),
                    ),
                  ],
                ),
              );
              break; // Exit loop or continue as needed
            }
          }

          // Insert download queue into the database
          final database = await DbInstance.instance();
          final downloadDao = database.downloadQueDao;
          await downloadDao.insertAll(downloadQueuesList);

          // Start the download process
          permissionHandler(onPermissionAllow: () {
            DownloadQueueUtil.instance.onInitFunction("downloadQueue");
          });
        } else {
          logPrint("No courses available for download.");
        }
      },
    );
  };

  Function(VideoCourseFile data, int index) get onSingleDownloadClicked =>
      (VideoCourseFile data, int index) async {
        // if (Get.find<AuthService>().isPro.value) {
          PermissionUtil.instance.permission(
              title: StringResource.askStoragePermission,
              message: "messa ",
              permission: Permission.mediaLibrary,
              onPermissionGranted: () async {
                if (courseDataList.isNotEmpty) {
                  List<DownloadQueue> downloadQueuesList = [];
                  if ((data.fileUrl).toString().endsWith('mp4')) {
                    downloadQueuesList.add(DownloadQueue(
                        fileType: "video",
                        folderName: data.courseName,
                        fileUrl: data.fileUrl,
                        fileName: data.name,
                        type: Folder.videoCourse,
                        catId: data.catId,
                        catName: data.catName,
                        courseId: data.courseId,
                        courseName: data.courseName,
                        courseImage: courseData.value.data?.thumbnails ??
                            offlineVideoCourseData?.imagePath ??
                            '',
                        contentId: data.id,
                        videoId: data.id,
                        videoName: data.name,
                        videoImage: data.imagePath,
                        videoDuration: data.duration,
                        rating: data.rating));
                    statusOfFileDownload[statusOfFileDownload.indexWhere(
                            (element) => element.chapterId == data.id)] =
                        DownloadStatusList(
                            chapterId: data.id,
                            catId: data.catId,
                            downloadStatus: DownloadingStatus.inQueue);
                  }else {
                    // Show a warning dialog if the file is not an MP4
                    await Get.dialog(
                      AlertDialog(
                        title: Text("Unsupported File Format"),
                        content: Text(
                            "The file '${data.fileUrl}' is not an MP4 file and cannot be downloaded."),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Get.back(); // Close the dialog
                            },
                            child: Text("OK"),
                          ),
                        ],
                      ),
                    );
                  }

                  final database = await DbInstance.instance();
                  final downloadDao = database.downloadQueDao;
                  await downloadDao.insertAll(downloadQueuesList);

                  // PLEASE CHECK IF ALREADY DOWNLOAD RUNNIG
                  permissionHandler(onPermissionAllow: () {
                    DownloadQueueUtil.instance.onInitFunction("downloadQueue");
                  });
                } else {
                  logPrint("sdfsdf");
                }
              });
        // } else {
        //   ProgressDialog().showFlipDialog(
        //       title: Platform.isAndroid
        //           ? "Download All Premium Stock Market Content as a Pro User. Continue?"
        //           : null,
        //       isForPro:
        //           Get.find<AuthService>().isGuestUser.value ? false : true);
        // }
      };

  Future<bool> checkIsCourseFileDownloading() async {
    final database = await DbInstance.instance();
    List<DownloadQueue?> contents =
        await database.downloadQueDao.findCourseFile(courseId.value);
    if (contents.isNotEmpty) {
      logPrint("check true");
      downloadStatus.value = DownloadingStatus.started;
      return true;
    } else {
      logPrint("check false");
      downloadStatus.value = DownloadingStatus.error;
      return false;
    }
  }

  @override
  void onInit() {
    // checkIsCourseFileDownloading();

    singletonGlobal = SingletonGlobal(onStart: (map) async {
      logPrint("onStart singleton $map");
      statusOfFileDownload[statusOfFileDownload
              .indexWhere((element) => element.chapterId == map['videoId'])] =
          DownloadStatusList(
              chapterId: map['videoId'],
              catId: map['catId'],
              downloadStatus: DownloadingStatus.inQueue);
      if (await checkIsCourseFileDownloading() &&
          downloadStatus.value != DownloadingStatus.started) {
        downloadStatus.value = DownloadingStatus.started;
        logPrint("khggfxgddfhgk");
        logPrint(downloadStatus.value.toString());
      }
    }, onDownload: (map) async {
      logPrint("onDownloaded singleton");
      statusOfFileDownload[statusOfFileDownload
              .indexWhere((element) => element.chapterId == map['videoId'])] =
          DownloadStatusList(
              chapterId: map['videoId'],
              catId: map['catId'],
              downloadStatus: DownloadingStatus.downloaded);
      if (!(await checkIsCourseFileDownloading()) &&
          downloadStatus.value != DownloadingStatus.downloaded) {
        downloadStatus.value = DownloadingStatus.downloaded;
        logPrint(downloadStatus.value.toString());
        toastShow(message: 'Files downloaded successfully');
      }
    }, onError: (map) async {
      logPrint("onError singleton");
      statusOfFileDownload[statusOfFileDownload
              .indexWhere((element) => element.chapterId == map['videoId'])] =
          DownloadStatusList(
              chapterId: map['videoId'],
              catId: map['catId'],
              downloadStatus: DownloadingStatus.downloaded);
      if (!(await checkIsCourseFileDownloading()) &&
          downloadStatus.value != DownloadingStatus.error &&
          downloadStatus.value != DownloadingStatus.downloaded) {
        toastShow(message: 'Error while downloading the course file');
        var database = await DbInstance.instance();
        var videoCourseFileDao = database.videoCourseFileDao;
        List<VideoCourseFile>? files =
            await videoCourseFileDao.findCourseContent(courseId.value);
        if ((files ?? []).isNotEmpty) {
          downloadStatus.value = DownloadingStatus.downloaded;
        } else {
          downloadStatus.value = DownloadingStatus.error;
        }

        logPrint(downloadStatus.value.toString());
      }
    });

    if (Get.arguments != null && Get.arguments is List && Get.arguments.length >= 2) {
      categoryType.value = Get.arguments[0] ?? "";
      courseId.value = Get.arguments[1] ?? "";
    } else {
      // Handle the case where arguments are not in the expected format
      categoryType.value = "";
      courseId.value = "";
    }

    // if (Get.arguments != null) {
    //   categoryType.value = Get.arguments[0] ?? "";
    //   courseId.value = Get.arguments[1] ?? "";
    // }
    checkDownloadingStatus();
    /*playingMediaSubscription =  selectedVideo.listen((p0) {
      if((p0.courseContent?.fileLocalPath??'').toString().isEmpty){
        downloadStatus.value = DownloadStatus.error;
      }
      else if((p0.courseContent?.fileLocalPath??'').toString().toString().startsWith('http')){
        downloadStatus .value = DownloadStatus.error;
      }
      else{
        downloadStatus .value = DownloadStatus.downloaded;
      }

    });*/
    getCourseById();
    getCourseStatus();
    AppConstants.instance.valueListenerVar.listen((p0) {
      if (p0 == "run") {
        getCourseStatus();
        AppConstants.instance.valueListenerVar.value = "";
      }
    });
    super.onInit();
  }

  checkDownloadingStatus() {
    checkIsCourseFileDownloading().then((value) async {
      if (value) {
        downloadStatus.value = DownloadingStatus.started;
      } else {
        var database = await DbInstance.instance();
        var videoCourseFileDao = database.videoCourseFileDao;
        List<VideoCourseFile>? files =
            await videoCourseFileDao.findCourseContent(courseId.value);
        if ((files ?? []).isNotEmpty) {
          downloadStatus.value = DownloadingStatus.downloaded;
        } else {
          downloadStatus.value = DownloadingStatus.error;
        }
      }
    });
  }

  @override
  void onClose() {
    //playingMediaSubscription?.cancel();
    singletonGlobal?.unbindBackgroundIsolate();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    super.onClose();
  }

  getCourseStatus() async {
    await courseProvider.getCourseStatus(
        onError: (message, errorMap) {
          toastShow(message: message);
        },
        onSuccess: (message, json) {
          if (json?['data']?.isNotEmpty) {
            courseStatus.value = CourseStatus.fromJson(json ?? {});
          }
        },
        courseId: courseId.value);
  }

  getCourseById() async {
    isDataLoading(true);
    await courseProvider.getCourseById(
        onError: (message, errorMap) {
          toastShow(message: message, error: true);
          isDataLoading(false);
          processVideo();
        },
        onSuccess: (message, json) async {
          courseData.value = CourseByIdModel.fromJson(json!);
          processVideo(courseData.value);

          courseName.value = courseData.value.data?.courseTitle ?? "";

          Get.put(ShowRatingController(
              data: CourseDatum(
                  type: AppConstants.videoCourse,
                  id: courseData.value.data?.id.toString(),
                  name: courseData.value.data?.courseTitle ?? "",
                  rating: courseData.value.data?.avgRating.toString() ?? "")));

          await courseProvider.getCourseMoreData(
              currentId: courseId.value,
              onError: (message, errorMap) {
                toastShow(message: message);
              },
              onSuccess: (message, json) {
                CoursesModel data = CoursesModel.fromJson(json!);

                if (data.data?.data?.isNotEmpty ?? false) {
                  moreLikeData.value = List<CommonDatum>.from(data.data!.data!
                      .map((x) => CommonDatum.fromJson(x.toJson())));
                }
              },
              catId: courseData.value.data?.categoryId.toString() ?? "",
              type: CourseDetailViewType.videoCourse,
              pageNo: 1);
          isDataLoading(false);
        },
        courseId: courseId.value,
        type: CourseDetailViewType.videoCourse);
  }

  VoidCallback get onWatchLater => () async {
        logPrint("onWatchLaterClicked");
        await Get.find<RootViewController>().saveToWatchLater(
            id: courseData.value.data?.id ?? 0,
            type: "course_video",
            response: (WishListSaveModel wishListSaveModel) {
              if (wishListSaveModel.data ?? false) {
                courseData.value.data?.isWishlist!.value = 1;
              } else {
                courseData.value.data?.isWishlist!.value = 0;
              }
            });
      };

  // getCourseHistory()async{
  //   await courseProvider.getCourseHistory(courseId: courseId.value,
  //       onError: (message){
  //     toastShow(message: message,error: true);
  //   }, onSuccess: (message,json) async {
  //   courseHistoryData.value = CourseHistoryModel.fromJson(json!);
  //   }
  //   );
  // }

  postCourseHistory({required String subCourseId}) async {
    await courseProvider.postCourseHistory(
        mapData: {
          "course_id": courseId.value,
          "course_details_id": subCourseId
        },
        onError: (message, errorMap) {
          toastShow(message: message, error: true);
        },
        onSuccess: (message, json) async {
          logPrint("success z $json");
          getCourseStatus();
          //courseData.value = CourseByIdModel.fromJson(json!);
        });
  }

  Future<void> processVideo([CourseByIdModel? videoData]) async {
    logPrint("offlineVideoCourseData }");

    var database = await DbInstance.instance();
    var videoCourseFileDao = database.videoCourseFileDao;
    var videoCourseDao = database.videoCourseFolderDao;

    offlineVideoCourseData = await videoCourseDao.findById(courseId.value);
    logPrint("offlineVideoCourseData ${offlineVideoCourseData?.name}");
    logPrint("offlineVideoCourseData $offlineVideoCourseData");
    courseDataList.clear();
    statusOfFileDownload.clear();
    if (videoData != null) {
      selectedVideo.value = VideoTypePlayer(
        fileType: courseData.value.data?.teaserType ?? "",
        fileUrl: courseData.value.data?.teaserUrl ?? "",
        //duration: int.parse(courseData.value.data?.duration??"0")
      );

      String videoCategoryId = '${videoData.data?.categoryId}';
      String videoCategoryTitle = videoData.data?.courseCategory?.title ?? '';
      String videoCourseId = '${videoData.data?.id}';
      String videoCourseTitle = '${videoData.data?.courseTitle}';
      //String videoCourseImage = '${videoData.data?.image}';

      List<CourseDetail> courseDetailsList = videoData.data?.courseDetail ?? [];
      logPrint("i am here");
      bool isFileNotFound = false;

      for (int index = 0; index < courseDetailsList.length; index++) {
        CourseDetail courseContent = courseDetailsList[index];

        VideoCourseFile? localFile = await videoCourseFileDao.findById(
            '${courseContent.id ?? ''}', videoCourseId);

        if (localFile != null && localFile.fileLocalPath != "") {
          try {
            // File file = File(localFile.fileLocalPath);
            // List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
          } catch (e) {
            if (e is PathNotFoundException) {
              localFile.fileLocalPath = "";

              statusOfFileDownload.add(DownloadStatusList(
                  chapterId: '${courseContent.id ?? ''}',
                  catId: videoCategoryId,
                  downloadStatus: localFile.fileLocalPath == ""
                      ? DownloadingStatus.error
                      : DownloadingStatus.downloaded));
              isFileNotFound = true;
            }
          }
        }

        var video = VideoCourseFile(
            '${courseContent.id ?? ''}',
            videoCategoryId,
            videoCourseId,
            courseContent.topicTitle ?? '',
            videoCategoryTitle,
            videoCourseTitle,
            courseContent.banner ?? '',
            courseContent.duration ?? '0',
            (localFile?.fileLocalPath ?? '').isNotEmpty
                ? (localFile?.fileLocalPath ?? '')
                : (courseContent.courseContent ?? ''),
            courseContent.courseContentDownload ?? '',
            videoData.data?.avgRating.toString() ?? "");

        logPrint("videoCourseFile1");
        courseDataList.add(video);
        statusOfFileDownload.add(DownloadStatusList(
            chapterId: '${courseContent.id ?? ''}',
            catId: videoCategoryId,
            downloadStatus: localFile?.fileLocalPath == null
                ? DownloadingStatus.error
                : DownloadingStatus.downloaded));
      }

      if (isFileNotFound) {
        toastShow(message: StringResource.noFileFound);
        Future.delayed(const Duration(seconds: 1), () {
          downloadStatus.value = DownloadingStatus.reDownload;
          onDownloadClicked();
          logPrint("downloadStatus.value ${downloadStatus.value}");
        });
      }
    } else if (offlineVideoCourseData != null) {
      String videoCourseId = offlineVideoCourseData?.id ?? '';

      List<VideoCourseFile>? files =
          await videoCourseFileDao.findCourseContent(videoCourseId);
      logPrint("videoCourseFile2 ${files?.length}");

      courseDataList.addAll(files ?? []);

      if (courseDataList.isNotEmpty) {
        logPrint("videoCourseFile3");
        List<bool> checkFileExist = [];
        for (VideoCourseFile videoCourseFile in courseDataList) {
          if (videoCourseFile.fileLocalPath != "") {
            try {
              // File file = File(videoCourseFile.fileLocalPath);
              // List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
            } catch (e) {
              if (e is PathNotFoundException) {
                checkFileExist.add(false);
              }
            }
          }
        }

        logPrint("checkFileExist $checkFileExist");

        if (checkFileExist.any((element) => element == false)) {
          toastShow(message: StringResource.noFileFound);
          selectedVideo.value = VideoTypePlayer(
            fileType: courseData.value.data?.teaserType ?? "",
            fileUrl: courseData.value.data?.teaserUrl ?? "",
            //duration: int.parse(courseData.value.data?.duration??"0")
          );

          String videoCategoryId = '${videoData?.data?.categoryId}';
          String videoCategoryTitle =
              videoData?.data?.courseCategory?.title ?? '';
          String videoCourseId = '${videoData?.data?.id}';
          String videoCourseTitle = '${videoData?.data?.courseTitle}';
          //String videoCourseImage = '${videoData.data?.image}';

          List<CourseDetail> courseDetailsList =
              videoData?.data?.courseDetail ?? [];

          bool isFileNotFound = false;

          for (int index = 0; index < courseDetailsList.length; index++) {
            CourseDetail courseContent = courseDetailsList[index];

            VideoCourseFile? localFile = await videoCourseFileDao.findById(
                '${courseContent.id ?? ''}', videoCourseId);

            if (localFile != null && localFile.fileLocalPath != "") {
              try {
                // File file = File(localFile.fileLocalPath);
                // List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
              } catch (e) {
                if (e is PathNotFoundException) {
                  localFile.fileLocalPath = "";

                  isFileNotFound = true;
                }
              }
            }

            var video = VideoCourseFile(
                '${courseContent.id ?? ''}',
                videoCategoryId,
                videoCourseId,
                courseContent.topicTitle ?? '',
                videoCategoryTitle,
                videoCourseTitle,
                courseContent.banner ?? '',
                courseContent.duration ?? '0',
                (localFile?.fileLocalPath ?? '').isNotEmpty
                    ? (localFile?.fileLocalPath ?? '')
                    : (courseContent.courseContent ?? ''),
                courseContent.courseContentDownload ?? '',
                videoData?.data?.avgRating.toString() ?? "");

            logPrint("videoCourseFile1");
            courseDataList.add(video);
            statusOfFileDownload.add(DownloadStatusList(
                chapterId: '${courseContent.id ?? ''}',
                catId: videoCategoryId,
                downloadStatus: localFile?.fileLocalPath == null
                    ? DownloadingStatus.error
                    : DownloadingStatus.downloaded));

            if (isFileNotFound) {
              toastShow(message: StringResource.noFileFound);
              Future.delayed(const Duration(seconds: 1), () {
                downloadStatus.value = DownloadingStatus.reDownload;
                logPrint("downloadStatus.value ${downloadStatus.value}");
              });
            }
          }
        } else {
          isSelectedVideoChange.value = true;
          selectedVideo.value = VideoTypePlayer(
              id: courseDataList[0].id.toString(),
              duration: int.parse(courseDataList[0].duration.isNotEmpty
                  ? courseDataList[0].duration
                  : "0"),
              fileType: isValidYoutubeUrl(courseDataList[0].fileLocalPath)
                  ? 'Url'
                  : "File",
              fileUrl: courseDataList[0].fileLocalPath,
              courseContent: courseDataList[0]);
          Future.delayed(const Duration(milliseconds: 50), () {
            isSelectedVideoChange.value = false;
          });
          isHistoryUpload.value = true;
        }
      }
    }

    for (var data in courseDataList) {
      if (data.fileUrl != data.fileLocalPath) {
        statusOfFileDownload.add(DownloadStatusList(
            chapterId: data.courseId,
            catId: data.catId,
            downloadStatus: DownloadingStatus.downloaded));
      } else {
        statusOfFileDownload.add(DownloadStatusList(
            chapterId: data.courseId,
            catId: data.catId,
            downloadStatus: DownloadingStatus.error));
      }
    }
    autoStartVideo();
  }

  void autoStartVideo() {
    logPrint("i am clicked");
    isSelectedVideoChange.value = true;
    selectedVideo.value = VideoTypePlayer(
        id: courseDataList[videoIndex.value].id.toString(),
        duration: int.parse(courseDataList[videoIndex.value].duration.isNotEmpty
            ? courseDataList[videoIndex.value].duration
            : "0"),
        fileType:
            isValidYoutubeUrl(courseDataList[videoIndex.value].fileLocalPath)
                ? 'Url'
                : "File",
        fileUrl: courseDataList[videoIndex.value].fileLocalPath,
        courseContent: courseDataList[videoIndex.value]);
    Future.delayed(const Duration(milliseconds: 50), () {
      isSelectedVideoChange.value = false;
    });
    isHistoryUpload.value = true;
  }
}

class DownloadStatusList {
  final DownloadingStatus? downloadStatus;
  final String? chapterId;
  final String? catId;

  DownloadStatusList({this.downloadStatus, this.chapterId, this.catId});
}

class VideoTypePlayer {
  final String? id;
  final String? fileType;
  final String? fileUrl;
  final int? duration;
  final VideoCourseFile? courseContent;

  VideoTypePlayer(
      {this.fileType,
      this.fileUrl,
      this.id,
      this.duration,
      this.courseContent});
}
