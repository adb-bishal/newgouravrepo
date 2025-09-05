import 'dart:async';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stockpathshala_beta/model/models/course_models/course_by_id_model.dart';
import 'package:stockpathshala_beta/model/models/course_models/single_audio_model.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/service/floor/entity/download.dart';
import 'package:stockpathshala_beta/service/models/downloaded_file_model.dart';
import 'package:stockpathshala_beta/service/utils/object_extension.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../model/models/course_models/course_by_id_model.dart' as i;
import '../../../../model/models/course_models/single_course_model.dart';
import '../../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../../model/network_calls/api_helper/provider_helper/courses_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/background_download/background_run_util.dart';
import '../../../../model/services/background_download/singleton_global.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../service/page_manager.dart';
import '../../../../service/utils/download_file_util.dart';
import '../../../../view/widgets/alert_dialog_popup.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../../../../view/widgets/view_helpers/progress_dialog.dart';
import '../course_detail_controller/course_detail_controller.dart';
import '../root_view_controller.dart';
import '../video_course_detail_controller/video_course_detail_controller.dart';

class AudioCourseDetailController extends GetxController {
  CourseProvider courseProvider = getIt();
  var categoryType = CourseDetailViewType.audio.obs;
  RxString audioId = ''.obs;
  RxString catID = ''.obs;
  RxBool isUploaded = true.obs;
  RxBool isDataLoading = false.obs;
  RxBool isManualSlide = false.obs;
  RxInt countVal = 0.obs;
  RxInt selectedIndex = 0.obs;
  var downloadStatus = DownloadingStatus.error.obs;
  Rx<SingleAudioModel> audioData = SingleAudioModel().obs;
  Rx<SingleCourseModel> moreLikeData = SingleCourseModel().obs;

  Audio? offlineAudioData;
  AudioCourseFolder? offlineAudioCourseData;
  List<AudioCourseFile>? offlineCourseContents;

  List<AudioCourseFile> courseDataList = <AudioCourseFile>[].obs;
  List<DownloadStatusList> statusOfFileDownload = <DownloadStatusList>[].obs;

  var playingMedia = const MediaItem(id: '', title: '').obs;

  StreamSubscription? playingMediaSubscription;
  StreamSubscription? currentPlayingMediaSubscription;

  Future<bool> checkIsCourseFileDownloading() async {
    final database = await DbInstance.instance();
    if (categoryType.value != CourseDetailViewType.audio) {
      List<DownloadQueue?> contents =
          await database.downloadQueDao.findCourseFile(audioId.value);
      if (contents.isNotEmpty) {
        logPrint("check true");
        downloadStatus.value = DownloadingStatus.started;
        return true;
      } else {
        logPrint("check false");
        downloadStatus.value = DownloadingStatus.error;
        return false;
      }
    } else {
      DownloadQueue? contents =
          await database.downloadQueDao.findAudioById(audioId.value);
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
    }
  }

  static argument(
      {required String audioId,
      required CourseDetailViewType categoryType,
      required String catId}) {
    return [categoryType, audioId, catId];
  }

  final pageManager = getIt<PageManager>();
  SingletonGlobal? singletonGlobal;

  onDownloadClicked() async {
    if ((!Get.find<AuthService>().isGuestUser.value) &&
        (Get.find<AuthService>().isPro.value)) {
      if ((playingMedia.value.extras?['url'] ?? '').toString().isNotEmpty &&
          (playingMedia.value.extras?['url'] ?? '')
              .toString()
              .startsWith('http')) {
        PermissionUtil.instance.permission(
            title: StringResource.askStoragePermission,
            message: "messa ",
            permission: Permission.storage,
            onPermissionGranted: () async {
              if (categoryType.value == CourseDetailViewType.audio) {
                List<DownloadQueue> downloadQueuesList = [];
                if ((playingMedia.value.extras?['url'] ?? '')
                    .toString()
                    .startsWith('http')) {
                  downloadQueuesList.add(DownloadQueue(
                      fileType: "audio",
                      fileUrl: pageManager
                              .currentPlayingMedia.value.extras?['url'] ??
                          '',
                      fileName: pageManager.currentPlayingMedia.value.title,
                      type: Folder.audio,
                      catId: pageManager
                              .currentPlayingMedia.value.extras?['cat_id'] ??
                          '',
                      catName: pageManager
                              .currentPlayingMedia.value.extras?['cat_name'] ??
                          '',
                      audioId: pageManager.currentPlayingMedia.value.id,
                      contentId: pageManager.currentPlayingMedia.value.id,
                      audioName: pageManager.currentPlayingMedia.value.title,
                      audioImage: pageManager
                              .currentPlayingMedia.value.extras?['image'] ??
                          '',
                      rating: audioData.value.data?.avgRating.toString()));
                  // statusOfFileDownload[statusOfFileDownload.indexWhere((element) => element.chapterId == data.id)] = DownloadStatusList(
                  //     chapterId: data.id,
                  //     catId: data.catId,
                  //     downloadStatus:DownloadStatus.inQueue
                  // );
                }
                final database = await DbInstance.instance();
                final downloadDao = database.downloadQueDao;
                await downloadDao.insertAll(downloadQueuesList);

                // PLEASE CHECK IF ALREADY DOWNLOAD RUNNIG
                permissionHandler(onPermissionAllow: () {
                  DownloadQueueUtil.instance.onInitFunction("downloadQueue");
                });
              } else if (categoryType.value ==
                  CourseDetailViewType.audioCourse) {
                if (courseDataList.isNotEmpty) {
                  List<DownloadQueue> downloadQueuesList = [];
                  logPrint(
                      'Download courseDataList length ${courseDataList.length}');
                  for (AudioCourseFile data in courseDataList) {
                    if ((data.fileUrl).toString().startsWith('http')) {
                      if (statusOfFileDownload.any((element) =>
                          element.chapterId == data.id &&
                          (element.downloadStatus !=
                                  DownloadingStatus.downloaded ||
                              element.downloadStatus !=
                                  DownloadingStatus.inQueue))) {
                        downloadQueuesList.add(DownloadQueue(
                            fileType: 'audio',
                            folderName:
                                pageManager.currentPlayingMedia.value.album,
                            fileUrl: data.fileUrl,
                            fileName: data.name,
                            type: Folder.audioCourse,
                            catId: data.catId,
                            catName: data.catName,
                            courseId: data.courseId,
                            courseName: data.courseName,
                            courseImage: audioData.value.data?.themeColor,
                            contentId: data.id,
                            audioId: data.id,
                            audioName: data.name,
                            audioImage: data.imagePath,
                            rating:
                                audioData.value.data?.avgRating.toString()));
                        statusOfFileDownload[statusOfFileDownload.indexWhere(
                                (element) => element.chapterId == data.id)] =
                            DownloadStatusList(
                                chapterId: data.id,
                                catId: data.catId,
                                downloadStatus: DownloadingStatus.inQueue);
                      }
                    }
                  }

                  final database = await DbInstance.instance();
                  final downloadDao = database.downloadQueDao;
                  await downloadDao.insertAll(downloadQueuesList);
                  // PLEASE CHECK IF ALREADY DOWNLOAD RUNNIG
                  permissionHandler(onPermissionAllow: () {
                    DownloadQueueUtil.instance.onInitFunction("downloadQueue");
                  });
                }
              }
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

  postCourseHistory({required String subCourseId}) async {
    if (categoryType.value == CourseDetailViewType.audioCourse) {
      await courseProvider.postCourseHistory(
          mapData: {
            "course_id": audioId.value,
            "course_details_id": subCourseId
          },
          onError: (message, errorMap) {
            toastShow(message: message, error: true);
          },
          onSuccess: (message, json) async {
            logPrint("success z $json");
            //courseData.value = CourseByIdModel.fromJson(json!);
          });
    }
  }

  updateVideoStatus({String? status}) async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      EasyDebounce.debounce(
          countVal.value.toString(), const Duration(milliseconds: 1000),
          () async {
        await courseProvider.updateVideoStatus(
            mapData: {
              "type": categoryType.value == CourseDetailViewType.audio
                  ? "audio"
                  : "course_audio",
              "trackable_id": audioId.value,
              "status": status
            },
            onError: (message, errorMap) {},
            onSuccess: (message, json) async {});
      });
    }
  }

  Rx<ProgressBarState> progressAudioNotifier = const ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  ).obs;

  @override
  void onInit() {
    super.onInit();
    checkIsCourseFileDownloading();
    singletonGlobal = SingletonGlobal(onStart: (map) {
      downloadStatus.value = DownloadingStatus.started;
      logPrint("length ${statusOfFileDownload.length}");
      statusOfFileDownload[statusOfFileDownload.indexWhere((element) {
        logPrint("chapterId ${element.chapterId}");
        logPrint("catId ${element.catId}");
        logPrint("audioId ${map['audioId']}");
        return element.chapterId == map['audioId'];
      })] = DownloadStatusList(
          chapterId: map['audioId'],
          catId: map['catId'],
          downloadStatus: DownloadingStatus.inQueue);
    }, onError: (map) {
      toastShow(message: 'Error while downloading the file');
      logPrint("onError $map");
      logPrint("length onError ${statusOfFileDownload.length}");
      downloadStatus.value = DownloadingStatus.error;
      statusOfFileDownload[statusOfFileDownload
              .indexWhere((element) => element.chapterId == map['audioId'])] =
          DownloadStatusList(
              chapterId: map['audioId'],
              catId: map['catId'],
              downloadStatus: DownloadingStatus.downloaded);
    }, onDownload: (map) {
      logPrint("onDownload $map");
      toastShow(message: 'File downloaded successfully');
      logPrint("length onDownload ${statusOfFileDownload.length}");
      downloadStatus.value = DownloadingStatus.downloaded;
      statusOfFileDownload[statusOfFileDownload.indexWhere((element) {
        logPrint("onDownload chapterId ${element.chapterId}");
        logPrint("onDownload catId ${element.catId}");
        logPrint("onDownload audioId ${map['audioId']}");
        return element.chapterId == map['audioId'];
      })] = DownloadStatusList(
          chapterId: map['audioId'],
          catId: map['catId'],
          downloadStatus: DownloadingStatus.downloaded);
    });
    if (Get.arguments != null) {
      categoryType.value = Get.arguments[0];
      audioId.value = Get.arguments[1] ?? "";
    }
    playingMediaSubscription = playingMedia.listen((p0) {
      p0.toString().printLog(message: 'Hey I am playing');
      if ((p0.extras?['url'] ?? '').toString().isEmpty) {
        downloadStatus.value = DownloadingStatus.error;
      } else if (((p0.extras?['url'] ?? '').toString().startsWith('http'))) {
        downloadStatus.value = DownloadingStatus.error;
      } else {
        downloadStatus.value = DownloadingStatus.downloaded;
      }
    });

    pageManager.progressNotifier.listen((p1) {
      if (!isManualSlide.value) {
        progressAudioNotifier.value = p1;
      }
      if (p1.current.inSeconds < 5) {
        if (isUploaded.value) {
          updateVideoStatus(status: "0");
          isUploaded.value = false;
        }
      }
      if (p1.total.inSeconds - 65 <= p1.current.inSeconds) {
        isUploaded.value = true;
      }
      if (p1.total.inSeconds - 60 > p1.current.inSeconds) {
        if (isUploaded.value) {
          postCourseHistory(
              subCourseId: pageManager.currentPlayingMedia.value.id);
          updateVideoStatus(status: "1");
          isUploaded.value = false;
        }
      }
    });
    currentPlayingMediaSubscription =
        pageManager.currentPlayingMedia.listen((p0) {
      playingMedia.value = p0;
      p0.toString().printLog(message: 'current playing');
    });
    playingMedia.value = pageManager.currentPlayingMedia.value;
    getOfflineData();
  }

  @override
  void onClose() {
    currentPlayingMediaSubscription?.cancel();
    playingMediaSubscription?.cancel();
    singletonGlobal?.unbindBackgroundIsolate();
    super.onClose();
  }

  resetDataSingle(Datum data) {
    audioId.value = '${data.id ?? ''}';
    catID.value = '${data.categoryId ?? ''}';
  }

  Future<void> getOfflineData() async {
    var database = await DbInstance.instance();
    var audioDao = database.audioDao;
    var audioCourseDao = database.audioCourseFolderDao;
    var audioCourseFileDao = database.audioCourseFileDao;

    if (categoryType.value == CourseDetailViewType.audio) {
      offlineAudioData = await audioDao.findById(audioId.value);
      logPrint("offlineAudioData ${offlineAudioData?.fileUrl}");
      logPrint("offlineAudioData Url ${offlineAudioData?.fileLocalPath}");
    } else {
      offlineAudioCourseData = await audioCourseDao.findById(audioId.value);
      logPrint("offlineAudioCourseData ${offlineAudioCourseData?.name}");
      if (offlineAudioCourseData != null) {
        offlineCourseContents = await audioCourseFileDao
            .findCourseContent(offlineAudioCourseData?.id ?? '');
      }
    }
    getAudioById();
  }

  getAudioById() async {
    isDataLoading.value = true;
    categoryType.value == CourseDetailViewType.audio
        ? await courseProvider.getAudioById(
            audioId: audioId.value,
            onError: (message, errorMap) {
              toastShow(message: message);
              addDataToAudioQueue();
              isDataLoading.value = false;
            },
            onSuccess: (message, json) {
              audioData.value = SingleAudioModel.fromJson(json!);
              addDataToAudioQueue(audioData.value);
              statusOfFileDownload.clear();
              statusOfFileDownload.add(DownloadStatusList(
                  chapterId: '${audioData.value.data?.id ?? ''}',
                  catId: audioData.value.data!.categoryId.toString(),
                  downloadStatus: DownloadingStatus.error));
              isDataLoading.value = false;
            })
        : await courseProvider.getCourseById(
            type: categoryType.value,
            courseId: audioId.value,
            onError: (message, errorMap) {
              toastShow(message: message);
              addCourseDataToPlaylist();
              isDataLoading.value = false;
            },
            onSuccess: (message, json) {
              audioData.value = SingleAudioModel.fromJson(json!);

              statusOfFileDownload.clear();
              for (CourseDetail data
                  in audioData.value.data?.courseDetail ?? []) {
                statusOfFileDownload.add(DownloadStatusList(
                    chapterId: '${data.id ?? ''}',
                    catId: audioData.value.data!.categoryId.toString(),
                    downloadStatus: DownloadingStatus.error));
              }
              addCourseDataToPlaylist(audioData.value);
              isDataLoading.value = false;
            });

    if (categoryType.value == CourseDetailViewType.audio) {
      await courseProvider.getCourseMoreData(
          currentId: audioId.value,
          onError: (message, errorMap) {
            toastShow(message: message);
          },
          onSuccess: (message, json) {
            moreLikeData.value = SingleCourseModel.fromJson(json!);
            statusOfFileDownload.clear();
            for (Datum data in moreLikeData.value.data?.data ?? []) {
              logPrint("morelike Datra ${data.id}");
              statusOfFileDownload.add(DownloadStatusList(
                  chapterId: '${data.id ?? ''}',
                  catId: audioData.value.data!.categoryId.toString(),
                  downloadStatus: DownloadingStatus.error));
            }
          },
          catId: catID.value,
          type: categoryType.value,
          pageNo: 1);
    }
  }

  onWatchLater() async {
    await Get.find<RootViewController>().saveToWatchLater(
        id: audioData.value.data?.id ?? 0,
        type: categoryType.value == CourseDetailViewType.audio
            ? "audio"
            : "course_audio",
        response: (WishListSaveModel data) {
          if (data.data ?? false) {
            audioData.value.data?.isWishlist!.value = 1;
          } else {
            audioData.value.data?.isWishlist!.value = 0;
          }
        });
  }

  onChange(double value) {
    if (Get.find<AuthService>().isGuestUser.value ||
        (!Get.find<AuthService>().isPro.value &&
            audioData.value.data?.isFree != 1)) {
      ProgressDialog().showFlipDialog(
          isForPro: Get.find<AuthService>().isGuestUser.value ? false : true);
    } else {
      isManualSlide.value = true;
      final oldState = progressAudioNotifier.value;
      progressAudioNotifier.value = ProgressBarState(
        current: Duration(seconds: value.ceil()),
        buffered: oldState.buffered,
        total: oldState.total,
      );
    }
  }

  onChangeEnd(double value) {
    logPrint("kjhknk $value");
    EasyDebounce.debounce(value.toString(), const Duration(milliseconds: 50),
        () {
      isManualSlide.value = false;
      pageManager.seek(Duration(seconds: value.ceil()));
    });
  }

  playButtonClicked() async {
    logPrint("sdfsd");
    //await pageManager.playLocalFile();
    if (pageManager.playButtonNotifier.value == ButtonState.playing) {
      pageManager.pause();
    } else {
      pageManager.play();
    }
  }

  Future<void> addDataToAudioQueue([SingleAudioModel? audio]) async {
    String audioId = '';
    String audioType = 'single';
    String audioTitle = '';
    String audioFileUrl = '';
    String audioCategoryId = '';
    String audioCategoryTitle = '';
    String audioImage = '';

    if (offlineAudioData != null &&
        offlineAudioData?.fileLocalPath != null &&
        offlineAudioData?.fileLocalPath != "") {
      try {
        // File file = File(offlineAudioData?.fileLocalPath ?? "");
        // List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
      } catch (e) {
        if (e is PathNotFoundException) {
          offlineAudioData?.fileLocalPath = "";
          offlineAudioData = null;
          toastShow(message: StringResource.noFileFound);
          Future.delayed(const Duration(seconds: 1), () {
            downloadStatus.value = DownloadingStatus.reDownload;
            onDownloadClicked();
          });
        }
      }
    }

    if (audio != null) {
      logPrint("in online url ${offlineAudioData?.fileLocalPath}");
      audioId = '${audio.data?.id}';
      audioTitle = '${audio.data?.title}';
      audioFileUrl = (offlineAudioData != null)
          ? offlineAudioData?.fileLocalPath ?? ''
          : audio.data?.fileUrl ?? '';
      audioCategoryId = '${audio.data?.categoryId}';
      audioCategoryTitle = audio.data?.category?.title ?? '';
      audioImage = audio.data?.thumbnail ?? '';
    } else if (offlineAudioData != null) {
      logPrint("in offline url ");
      audioId = offlineAudioData?.id ?? '';
      audioTitle = offlineAudioData?.name ?? '';
      audioFileUrl = offlineAudioData?.fileLocalPath ?? '';
      audioCategoryId = offlineAudioData?.catId ?? '';
      audioCategoryTitle = offlineAudioData?.catName ?? '';
      audioImage = offlineAudioData?.imagePath ?? '';
    } else {
      pageManager.stop();
      pageManager.removeAll();
    }
    if ('single' != pageManager.currentPlayingMedia.value.extras?['type']) {
      logPrint('ddd single 1');
      pageManager.stop();
      await pageManager.playSingleCourse(
          audioId,
          audioType,
          audioTitle,
          audioFileUrl,
          audioImage,
          audioCategoryId,
          audioCategoryTitle,
          offlineAudioData?.fileLocalPath != null &&
              offlineAudioData?.fileLocalPath != "");

      statusOfFileDownload.add(DownloadStatusList(
          chapterId: audioId,
          catId: audioCategoryId,
          downloadStatus: DownloadingStatus.error));

      if ((audioFileUrl).isNotEmpty) {
        logPrint('ddd dong ');
        pageManager.seek(const Duration(seconds: 0));
        if (!(Get.find<AuthService>().isGuestUser.value ||
            (!Get.find<AuthService>().isPro.value &&
                audioData.value.data?.isFree != 1))) {
          pageManager.play();
          logPrint("player state ${pageManager.playButtonNotifier.value}");
          Future.delayed(const Duration(seconds: 1), () {
            if (pageManager.playButtonNotifier.value == ButtonState.playing) {
              //pageManager.pause();
              logPrint(
                  "IsNotPlaying  if ${pageManager.playButtonNotifier.value}");
            } else {
              pageManager.play();
              logPrint("IsPlaying if ${pageManager.playButtonNotifier.value}");
            }
          });
        }
      }
    } else if ('single' ==
            pageManager.currentPlayingMedia.value.extras?['type'] &&
        audioId == pageManager.currentPlayingMedia.value.id) {
      logPrint('ddd single 2');

      return;
    } else {
      logPrint('ddd single 3');

      pageManager.stop();
      await pageManager.playSingleCourse(
          audioId,
          audioType,
          audioTitle,
          audioFileUrl,
          audioImage,
          audioCategoryId,
          audioCategoryTitle,
          offlineAudioData?.fileLocalPath != null &&
              offlineAudioData?.fileLocalPath != "");
      statusOfFileDownload.add(DownloadStatusList(
          chapterId: audioId,
          catId: audioCategoryId,
          downloadStatus: DownloadingStatus.error));
      if ((audioFileUrl).isNotEmpty) {
        logPrint('ddd ding ');

        if (!(Get.find<AuthService>().isGuestUser.value ||
            (!Get.find<AuthService>().isPro.value &&
                audioData.value.data?.isFree != 1))) {
          pageManager.play();
          pageManager.seek(const Duration(seconds: 0));

          Future.delayed(const Duration(seconds: 1), () {
            if (pageManager.playButtonNotifier.value == ButtonState.playing) {
              // pageManager.pause();
              logPrint(
                  "IsNotPlaying  if ${pageManager.playButtonNotifier.value}");
            } else {
              pageManager.play();
              logPrint("IsPlaying if ${pageManager.playButtonNotifier.value}");
            }
          });
        }
      }
    }
  }

  onSingleDownloadClicked(AudioCourseFile data, int index,
      {bool isAudio = false, required Datum audioDataVal}) async {
    if (Get.find<AuthService>().isPro.value) {
      PermissionUtil.instance.permission(
          title: StringResource.askStoragePermission,
          message: "messa ",
          permission: Permission.storage,
          onPermissionGranted: () async {
            if (isAudio) {
              logPrint("isAudion Download");
              List<DownloadQueue> downloadQueuesList = [];
              if ((audioDataVal.fileUrl ?? '').toString().startsWith('http')) {
                downloadQueuesList.add(DownloadQueue(
                    fileType: "audio",
                    fileUrl: audioDataVal.fileUrl ?? '',
                    fileName: audioDataVal.title ?? "",
                    type: Folder.audio,
                    catId: (audioDataVal.categoryId ?? "").toString(),
                    catName: (audioDataVal.category?.title ?? "").toString(),
                    audioId: (audioDataVal.id ?? "").toString(),
                    contentId: (audioDataVal.id ?? "").toString(),
                    audioName: audioDataVal.title ?? "",
                    audioImage: audioDataVal.banner ?? "",
                    rating: audioData.value.data?.avgRating.toString()));

                statusOfFileDownload[statusOfFileDownload.indexWhere((element) {
                  logPrint("name ${element.chapterId}");
                  logPrint("chapterId ${element.chapterId}");
                  logPrint("data.id ${data.id}");
                  return element.chapterId == audioDataVal.id.toString();
                })] = DownloadStatusList(
                    chapterId: data.id,
                    catId: data.catId,
                    downloadStatus: DownloadingStatus.inQueue);
              }
              final database = await DbInstance.instance();
              final downloadDao = database.downloadQueDao;
              await downloadDao.insertAll(downloadQueuesList);
              permissionHandler(onPermissionAllow: () {
                DownloadQueueUtil.instance.onInitFunction("downloadQueue");
              });
            } else {
              if (courseDataList.isNotEmpty) {
                List<DownloadQueue> downloadQueuesList = [];
                logPrint("file url ${data.fileUrl}");
                if ((data.fileUrl).toString().startsWith('http')) {
                  downloadQueuesList.add(DownloadQueue(
                      fileType: 'audio',
                      folderName: data.courseName,
                      fileUrl: data.fileUrl,
                      fileName: data.name,
                      type: Folder.audioCourse,
                      catId: data.catId,
                      catName: data.catName,
                      courseId: data.courseId,
                      courseName: data.courseName,
                      courseImage: audioData.value.data?.themeColor ?? '',
                      contentId: data.id,
                      audioId: data.id,
                      audioName: data.name,
                      audioImage: data.imagePath,
                      rating: data.rating));
                  statusOfFileDownload[statusOfFileDownload.indexWhere(
                          (element) => element.chapterId == data.id)] =
                      DownloadStatusList(
                          chapterId: data.id,
                          catId: data.catId,
                          downloadStatus: DownloadingStatus.inQueue);
                } else {
                  logPrint("message");
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
            }
          });
    } else {
      ProgressDialog().showFlipDialog(
          title: Platform.isAndroid
              ? "Download All Premium Stock Market Content as a Pro User. Continue?"
              : null,
          isForPro: Get.find<AuthService>().isGuestUser.value ? false : true);
    }
  }

  Future<void> addCourseDataToPlaylist([SingleAudioModel? audioData]) async {
    // String audioType = 'course';
    String audioCategoryId = '';
    String audioCategoryTitle = '';
    String audioCourseId = '';
    String audioCourseTitle = '';
    // String audioCourseImage = '';

    var database = await DbInstance.instance();
    var audioCourseFileDao = database.audioCourseFileDao;

    courseDataList.clear();

    if (audioData != null) {
      audioCategoryId = '${audioData.data?.categoryId}';
      audioCategoryTitle = audioData.data?.courseCategory?.title ?? '';
      audioCourseId = '${audioData.data?.id}';
      audioCourseTitle = '${audioData.data?.courseTitle}';
      // audioCourseImage = '${audioData.data?.themeColor}';

      List<i.CourseDetail> courseDetailsList =
          audioData.data?.courseDetail ?? [];
      bool isFileNotFound = false;

      for (int index = 0; index < courseDetailsList.length; index++) {
        i.CourseDetail courseContent = courseDetailsList[index];
        AudioCourseFile? localFile = await audioCourseFileDao.findById(
            '${courseContent.id ?? ''}', audioCourseId);

        if (localFile != null && localFile.fileLocalPath != "") {
          try {
            // File file = File(localFile.fileLocalPath);
            // List<int> bytes = file.readAsBytesSync().buffer.asUint8List();
          } catch (e) {
            if (e is PathNotFoundException) {
              localFile.fileLocalPath = "";

              statusOfFileDownload.add(DownloadStatusList(
                  chapterId: '${courseContent.id ?? ''}',
                  catId: audioCategoryId,
                  downloadStatus: localFile.fileLocalPath == ""
                      ? DownloadingStatus.error
                      : DownloadingStatus.downloaded));
              isFileNotFound = true;
            }
          }
        }

        var audio = AudioCourseFile(
            '${courseContent.id ?? ''}',
            audioCategoryId,
            audioCourseId,
            courseContent.topicTitle ?? '',
            audioCategoryTitle,
            audioCourseTitle,
            courseContent.image ?? '',
            (localFile?.fileLocalPath ?? '').isNotEmpty
                ? (localFile?.fileLocalPath ?? '')
                : (courseContent.courseContent ?? ''),
            courseContent.courseContent ?? '',
            audioData.data?.avgRating.toString() ?? "",
            localFile?.fileLocalPath != null && localFile?.fileLocalPath != "");
        courseDataList.add(audio);
      }

      if (isFileNotFound) {
        toastShow(message: StringResource.noFileFound);
        Future.delayed(const Duration(seconds: 1), () {
          downloadStatus.value = DownloadingStatus.reDownload;
          logPrint("downloadStatus.value ${downloadStatus.value}");
          onDownloadClicked();
        });
      }
    } else if (offlineAudioCourseData != null) {
      audioCategoryId = offlineAudioCourseData?.catId ?? '';
      audioCategoryTitle = offlineAudioCourseData?.catName ?? '';
      audioCourseId = offlineAudioCourseData?.id ?? '';
      audioCourseTitle = offlineAudioCourseData?.name ?? '';
      // audioCourseImage = offlineAudioCourseData?.imagePath ?? '';
      List<AudioCourseFile>? files =
          await audioCourseFileDao.findCourseContent(audioCourseId);
      courseDataList.addAll(files ?? []);
    } else {
      pageManager.stop();
      pageManager.removeAll();
    }

    if (courseDataList.isEmpty) {
      pageManager.stop();
      pageManager.removeAll();
      return;
    }

    if ('course' != pageManager.currentPlayingMedia.value.extras?['type']) {
      logPrint('ddd curse 1');
      pageManager.stop();

      await pageManager.playCourse(
        type: 'course',
        courseContentList: courseDataList,
      );

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

      if ((courseDataList[0].fileLocalPath).isNotEmpty) {
        if (!(Get.find<AuthService>().isGuestUser.value ||
            (!Get.find<AuthService>().isPro.value &&
                audioData?.data?.isFree != 1))) {
          logPrint("IsBuffer");
          pageManager.seek(const Duration(seconds: 0));
          logPrint("IsPlaying ${pageManager.playButtonNotifier.value}");

          //pageManager.play();
          logPrint("IsPlaying ${pageManager.playButtonNotifier.value}");

          if (categoryType.value != CourseDetailViewType.audio) {
            Future.delayed(const Duration(milliseconds: 10), () {
              pageManager.pause();
            });
          }
          logPrint("IsPlaying ${pageManager.playButtonNotifier.value}");
          Future.delayed(const Duration(seconds: 1), () {
            if (pageManager.playButtonNotifier.value == ButtonState.playing) {
              //pageManager.pause();
              logPrint(
                  "IsNotPlaying  if ${pageManager.playButtonNotifier.value}");
            } else {
              // pageManager.play();
              if (categoryType.value != CourseDetailViewType.audio) {
                Future.delayed(const Duration(milliseconds: 10), () {
                  pageManager.pause();
                });
              }
              logPrint("IsPlaying if ${pageManager.playButtonNotifier.value}");
            }
          });
        }
      }
    } else if ('course' ==
            pageManager.currentPlayingMedia.value.extras?['type'] &&
        (courseDataList.firstWhereOrNull((element) =>
                (element.id == pageManager.currentPlayingMedia.value.id)) !=
            null)) {
      logPrint('ddd curse 2');
      return;
    } else {
      logPrint('ddd curse 3');
      pageManager.stop();
      await pageManager.playCourse(
          type: 'course', courseContentList: courseDataList);
      if ((courseDataList[0].fileLocalPath).isNotEmpty) {
        if (!(Get.find<AuthService>().isGuestUser.value ||
            (!Get.find<AuthService>().isPro.value &&
                audioData?.data?.isFree != 1))) {
          pageManager.seek(const Duration(seconds: 0));
          //pageManager.play();
          if (categoryType.value != CourseDetailViewType.audio) {
            Future.delayed(const Duration(milliseconds: 10), () {
              pageManager.pause();
            });
          }

          Future.delayed(const Duration(seconds: 1), () {
            if (pageManager.playButtonNotifier.value == ButtonState.playing) {
              //pageManager.pause();
              logPrint(
                  "IsNotPlaying  if ${pageManager.playButtonNotifier.value}");
            } else {
              // pageManager.play();
              if (categoryType.value != CourseDetailViewType.audio) {
                Future.delayed(const Duration(milliseconds: 10), () {
                  pageManager.pause();
                });
              }
              logPrint("IsPlaying if ${pageManager.playButtonNotifier.value}");
            }
          });
        }
      }
    }
  }

  void playCourseDetailFromList(int index, AudioCourseFile courseDetail) {
    if ((courseDetail.fileLocalPath).isNotEmpty) {
      pageManager.skipToQueueItem(index);
    } else {
      toastShow(message: 'Audio not found');
    }
  }
}
