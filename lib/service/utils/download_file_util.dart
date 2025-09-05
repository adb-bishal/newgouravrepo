import 'dart:io';

import 'package:dio/dio.dart';
import 'package:dio_logging_interceptor/dio_logging_interceptor.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stockpathshala_beta/service/floor/entity/download.dart';
import 'package:stockpathshala_beta/service/models/downloaded_file_model.dart';
import 'package:stockpathshala_beta/service/utils/device_info_util.dart';
import 'package:stockpathshala_beta/service/utils/object_extension.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart' as youtube;

import '../../view_model/controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import '../../view_model/controllers/root_view_controller/video_course_detail_controller/video_course_detail_controller.dart';

permissionHandler({required Function() onPermissionAllow}) async {
  var info;
  if (Platform.isAndroid) {
    info = await DeviceInfoUtil.instance.deviceInfoPlugin.androidInfo;
  } else {
    info = await DeviceInfoUtil.instance.deviceInfoPlugin.iosInfo;
  }
  /*--------For create folder in memory
     Permission is required-------------*/
  if (Platform.isIOS) {
    onPermissionAllow();
  } else if (Platform.isAndroid && (info.version.sdkInt ?? 0) <= 32) {
    PermissionStatus status = await Permission.storage.status;
    status.printLog();
    if (status == PermissionStatus.granted) {
      onPermissionAllow();
    } else if (status == PermissionStatus.permanentlyDenied) {
      openAppSettings();
    } else {
      if (await Permission.mediaLibrary.request().isGranted) {
        onPermissionAllow();
      }
    }
  } else if (Platform.isAndroid && (info.version.sdkInt ?? 0) >= 32) {
    await Permission.mediaLibrary.request().isGranted;
    onPermissionAllow();
  }
}

bool isValidYoutubeUrl(String url) {
  if (url.startsWith("https://youtu.be/")) {
    return true;
  } else if (url.contains("youtube")) {
    return true;
  } else {
    return false;
  }
}

String? getVideoId(String url) {
  if (url.startsWith("https://youtu.be/")) {
    return url.replaceAll("https://youtu.be/", "");
  } else if (url.contains("v=")) {
    String videoID = url.split("v=")[1];
    int ampersandPosition = videoID.indexOf('&');
    if (ampersandPosition != -1) {
      videoID = videoID.substring(0, ampersandPosition);
    }
    return videoID;
  } else {
    return null;
  }
}

Map<String, dynamic> getAudioMap({
  String? folderName,
  required String fileUrl,
  required String fileName,
  required String type,
  String? catId,
  String? catName,
  String? courseId,
  String? courseName,
  String? courseImage,
  String? audioId,
  String? audioName,
  String? audioImage,
  String? downloadStatus,
  String? rating,
}) {
  return {
    "folderName": folderName,
    "fileUrl": fileUrl,
    "fileName": fileName,
    "type": type,
    "catId": catId,
    "catName": catName,
    "courseId": courseId,
    "courseName": courseName,
    "courseImage": courseImage,
    "audioId": audioId,
    "audioName": audioName,
    "audioImage": audioImage,
    "rating": rating,
    "downloadStatus": downloadStatus
  };
}

heyAudio(Map<String, dynamic> map,
    {required Function() onStart,
    required Function() onComplete,
    required Function() onError}) {
  DownloadUtil.downloadAudio(
    folderName: DateTime.now().microsecondsSinceEpoch.toString(),
    fileUrl: map['fileUrl'],
    fileName: "${DateTime.now().millisecondsSinceEpoch}.mp3",
    type: map['type'],
    onStart: onStart,
    onComplete: onComplete,
    onError: onError,
    catId: map['catId'],
    catName: map['catName'],
    courseId: map['courseId'],
    courseName: map['courseName'],
    courseImage: map['courseImage'],
    audioId: map['audioId'],
    audioName: map['audioName'],
    audioImage: map['audioImage'],
    rating: map['rating'],
  );
}

Map<String, dynamic> getVideoMap({
  String? folderName,
  required String fileUrl,
  required String fileName,
  required String type,
  String? catId,
  String? catName,
  String? courseId,
  String? courseName,
  String? courseImage,
  String? videoId,
  String? videoName,
  String? videoImage,
  String? videoDuration,
  String? downloadStatus,
  String? rating,
}) {
  return {
    "folderName": folderName,
    "fileUrl": fileUrl,
    "fileName": fileName,
    "type": type,
    "catId": catId,
    "catName": catName,
    "courseId": courseId,
    "courseName": courseName,
    "courseImage": courseImage,
    "videoId": videoId,
    "videoName": videoName,
    "videoImage": videoImage,
    "videoDuration": videoDuration,
    "rating": rating
  };
}

heyVideo(Map<String, dynamic> map,
    {required Function() onStart,
    required Function() onComplete,
    required Function() onError}) {
  DownloadUtil.downloadVideo(
    folderName: DateTime.now().microsecondsSinceEpoch.toString(),
    fileUrl: map['fileUrl'],
    fileName: DateTime.now().millisecondsSinceEpoch.toString(),
    type: map['type'],
    onStart: onStart,
    onComplete: onComplete,
    onError: onError,
    catId: map['catId'],
    catName: map['catName'],
    courseId: map['courseId'],
    courseName: map['courseName'],
    courseImage: map['courseImage'],
    videoId: map['videoId'],
    videoName: map['videoName'],
    videoImage: map['videoImage'],
    videoDuration: map['videoDuration'],
  );
}

enum DownloadingStatus { started, error, downloaded, inQueue, reDownload }

/*Dio? dio;
Dio? createDownloadDio() {
  dio ??= Dio();

  if(kDebugMode) {
    dio?.interceptors.add(
      DioLoggingInterceptor(
        level: Level.body,
        compact: false,
      ),
    );
  }
  return dio;
}*/

audioFileExif(
    {required String name,
    required String image,
    required String categoryName}) {
  return {
    'name': name,
    'image': image,
    'category_name': categoryName,
  };
}

folderExif({required String name, required String image}) {
  return {
    'name': name,
    'image': image,
  };
}

class DownloadUtil {

  static Dio dio = Dio();

  static CancelToken cancelToken = CancelToken(); // Add a cancel token

  static Future<void> downloadAudio({
    String? folderName,
    required String fileUrl,
    required String fileName,
    required String type,
    required Function() onStart,
    required Function() onComplete,
    required Function() onError,
    String? catId,
    String? catName,
    String? courseId,
    String? courseName,
    String? courseImage,
    String? audioId,
    String? audioName,
    String? audioImage,
    String? rating,
  }) async {
    // var info;
    // if (Platform.isAndroid) {
    //   info = await DeviceInfoUtil.instance.deviceInfoPlugin.androidInfo;
    // } else {
    //   info = await DeviceInfoUtil.instance.deviceInfoPlugin.iosInfo;
    // }

    /*--------For create folder in memory
     Permission is required-------------*/

    _downloadNonReadableAudioFile(
        onStart: onStart,
        onComplete: onComplete,
        onError: onError,
        folderName: folderName,
        fileUrl: fileUrl,
        fileName: fileName,
        type: type,
        catId: catId,
        catName: catName,
        courseId: courseId,
        courseName: courseName,
        courseImage: courseImage,
        audioId: audioId,
        audioName: audioName,
        audioImage: audioImage,
        rating: rating);
  }

  static void _downloadNonReadableAudioFile({
    String? folderName,
    required String fileUrl,
    required String fileName,
    required String type,
    required Function() onStart,
    required Function() onComplete,
    required Function() onError,
    String? catId,
    String? catName,
    String? courseId,
    String? courseName,
    String? courseImage,
    String? audioId,
    String? audioName,
    String? audioImage,
    String? rating,
  }) async {
    //Path for creating your folder.

    final appDocumentsDir = await getTemporaryDirectory();
    final appDocumentPath = appDocumentsDir.absolute.path;

    // var tempDir = await getApplicationDocumentsDirectory();
    // var tempPath = tempDir.absolute.path;
    // tempPath.toString().printLog(message: "path: ");
    //
    // var path = Directory('$tempPath/stockpathshala');
    // final appDocumentPath = path.path;
    // appDocumentPath.toString().printLog(message: "path: ");

    final Directory savePath;
    if ((folderName ?? '').isNotEmpty) {
      savePath = Directory('$appDocumentPath/StContent/AudioCourses/$courseId');
    } else {
      savePath = Directory('$appDocumentPath/StContent/Audios/$audioId');
    }

    /// if folder exists in four phone memory.
    if ((await savePath.exists())) {
      logPrint(
          "path audion ${join(savePath.path, DateTime.now().millisecondsSinceEpoch.toString())}");
      //download call
      if (File(join(savePath.path, fileName)).existsSync()) {
        toastShow(message: 'File Already Downloaded');
      } else {
        _apiDownload(fileUrl, savePath.path, fileName.removeAllWhitespace,
            onStart: onStart,
            onComplete: onComplete,
            onError: onError,
            type: type,
            catId: catId,
            catName: catName,
            courseId: courseId,
            courseName: courseName,
            courseImage: courseImage,
            audioId: audioId,
            audioName: audioName,
            audioImage: audioImage,
            chapterId: audioId,
            rating: rating);
      }
    } else {
      /// Create folder in your memory.
      savePath.create(recursive: true).then((value) async {
        //download call
        logPrint("path audion 2 ${join(savePath.path, fileName)}");
        if (File(join(savePath.path, fileName)).existsSync()) {
          toastShow(message: 'File Already Downloaded');
        } else {
          _apiDownload(fileUrl, savePath.path, fileName.removeAllWhitespace,
              onStart: onStart,
              onComplete: onComplete,
              onError: onError,
              type: type,
              catId: catId,
              catName: catName,
              courseId: courseId,
              courseName: courseName,
              courseImage: courseImage,
              audioId: audioId,
              audioName: audioName,
              audioImage: audioImage,
              chapterId: audioId,
              rating: rating);
        }
      });
    }
  }

  static Future<void> downloadVideo(
      {String? folderName,
      required String fileUrl,
      required String fileName,
      required String type,
      required Function() onStart,
      required Function() onComplete,
      required Function() onError,
      String? catId,
      String? catName,
      String? courseId,
      String? courseName,
      String? courseImage,
      String? videoId,
      String? videoName,
      String? videoImage,
      String? videoDuration,
      String? rating}) async {
    // var info;
    // if (Platform.isAndroid) {
    //   info = await DeviceInfoUtil.instance.deviceInfoPlugin.androidInfo;
    // } else {
    //   info = await DeviceInfoUtil.instance.deviceInfoPlugin.iosInfo;
    // }
    /*--------For create folder in memory
     Permission is required-------------*/

    _downloadNonReadableVideoFile(
        onStart: onStart,
        onComplete: onComplete,
        onError: onError,
        folderName: folderName,
        fileUrl: fileUrl,
        fileName: fileName,
        type: type,
        catId: catId,
        catName: catName,
        courseId: courseId,
        courseName: courseName,
        courseImage: courseImage,
        videoId: videoId,
        videoName: videoName,
        videoImage: videoImage,
        videoDuration: videoDuration,
        rating: rating);
  }

  static void _downloadNonReadableVideoFile({
    String? folderName,
    required String fileUrl,
    required String fileName,
    required String type,
    required Function() onStart,
    required Function() onComplete,
    required Function() onError,
    String? catId,
    String? catName,
    String? courseId,
    String? courseName,
    String? courseImage,
    String? videoId,
    String? videoName,
    String? videoImage,
    String? videoDuration,
    String? rating,
  }) async {
    //Path for creating your folder.

    final appDocumentsDir = await getTemporaryDirectory();
    //final appDocumentsDir = await getExternalStorageDirectory();
    final appDocumentPath = appDocumentsDir.absolute.path;
    appDocumentPath.toString().printLog(message: "path: ");
    final Directory savePath;

    if ((folderName ?? '').isNotEmpty) {
      savePath = Directory(
          '$appDocumentPath/StContent/Video Courses${(folderName != null) ? '/$folderName' : ''}/');
    } else {
      savePath = Directory(
          '$appDocumentPath/StContent/Videos${(folderName != null) ? '/$folderName' : ''}/');
    }

    fileName.printLog(message: 'ffff');
    logPrint("savePath ${savePath.path}");
    logPrint("savePath fileUrl is ${fileUrl}");
    if ((await savePath.exists())) {
      logPrint("path ${join(savePath.path, fileName)}");

      //download call
      if (File(join(savePath.path, fileName)).existsSync()) {
        toastShow(message: 'File Already Downloaded');
      } else {
        _apiDownload(
            fileUrl, savePath.path, "${fileName.removeAllWhitespace}.mp4",
            onStart: onStart,
            onComplete: onComplete,
            onError: onError,
            type: type,
            catId: catId,
            catName: catName,
            courseId: courseId,
            courseName: courseName,
            courseImage: courseImage,
            audioId: videoId,
            audioName: videoName,
            audioImage: videoImage,
            audioDuration: videoDuration,
            chapterId: videoId,
            rating: rating);
      }
    } else {
      /// Create folder in your memory.
      savePath.create(recursive: true).then((value) async {
        //download call
        logPrint("savePath2 ${savePath.path}");
        logPrint("path2 ${join(savePath.path, fileName)}");
        if (File(join(savePath.path, fileName)).existsSync()) {
          toastShow(message: 'File Already Downloaded');
        } else {
          _apiDownload(
              fileUrl, savePath.path, "${fileName.removeAllWhitespace}.mp4",
              onStart: onStart,
              onComplete: onComplete,
              onError: onError,
              type: type,
              catId: catId,
              catName: catName,
              courseId: courseId,
              courseName: courseName,
              courseImage: courseImage,
              audioId: videoId,
              audioName: videoName,
              audioImage: videoImage,
              audioDuration: videoDuration,
              chapterId: videoId,
              rating: rating);
        }
      });
    }
  }

  static void _apiDownload(
    String url,
    String folderPath,
    String fileNameWithExtension, {
    required Function() onStart,
    required Function() onComplete,
    required Function() onError,
    required String type,
    String? catId,
    String? catName,
    String? courseId,
    String? courseName,
    String? courseImage,
    String? audioId,
    String? audioName,
    String? audioImage,
    String? audioDuration,
    String? chapterId,
    required String? rating,
  }) async {
    onStart();
    if (isValidYoutubeUrl(url)) {
      logPrint("isValidYoutubeUrl from isolate");
      try {
        String? videoId = getVideoId(url);
        if (videoId != null) {
          var yt = youtube.YoutubeExplode();

          var manifest = await yt.videos.streamsClient.getManifest(videoId);
          var video = manifest.muxed.bestQuality;

          // Open the file to write.
          File file = File('$folderPath$fileNameWithExtension');
          var fileStream = file.openWrite();

          // Pipe all the content of the stream into our file.
          await yt.videos.streamsClient.get(video).pipe(fileStream);

          // Close the file.
          await fileStream.flush();
          await fileStream.close();
          yt.close();

          // save to db
          final database = await DbInstance.instance();
          if (type == Folder.audio) {
            final audioDao = database.audioDao;
            final audio = Audio(
                audioId ?? '',
                catId ?? '',
                audioName ?? '',
                catName ?? '',
                audioImage ?? '',
                file.absolute.path,
                url,
                rating ?? "");
            await audioDao.insert(audio);
          } else if (type == Folder.audioCourse) {
            final audioCourseFolderDao = database.audioCourseFolderDao;
            final audioCourseFolder = AudioCourseFolder(
                courseId ?? '',
                catId ?? '',
                courseName ?? '',
                catName ?? '',
                courseImage ?? '',
                file.parent.absolute.path,
                chapterId ?? "",
                courseId ?? "",
                rating ?? "");
            await audioCourseFolderDao.insert(audioCourseFolder);

            final audioCourseFileDao = database.audioCourseFileDao;
            final audioCourseFile = AudioCourseFile(
                audioId ?? '',
                catId ?? '',
                courseId ?? '',
                audioName ?? '',
                catName ?? '',
                courseName ?? '',
                audioImage ?? '',
                file.absolute.path,
                url,
                rating ?? "",
                true);
            await audioCourseFileDao.insert(audioCourseFile);
          } else if (type == Folder.video) {
            final videoDao = database.videoDao;
            final video = Video(
                audioId ?? '',
                catId ?? '',
                audioName ?? '',
                catName ?? '',
                audioImage ?? '',
                file.absolute.path,
                url,
                rating ?? "");
            await videoDao.insert(video);
          } else if (type == Folder.videoCourse) {
            final videoCourseFolderDao = database.videoCourseFolderDao;
            final videoCourseFolder = VideoCourseFolder(
                courseId ?? '',
                catId ?? '',
                courseName ?? '',
                catName ?? '',
                courseImage ?? '',
                file.parent.absolute.path,
                rating ?? "");
            await videoCourseFolderDao.insert(videoCourseFolder);

            final videoCourseFileDao = database.videoCourseFileDao;
            final videoCourseFile = VideoCourseFile(
                audioId ?? '',
                catId ?? '',
                courseId ?? '',
                audioName ?? '',
                catName ?? '',
                courseName ?? '',
                audioImage ?? '',
                audioDuration ?? '',
                file.absolute.path,
                url,
                rating ?? "");
            await videoCourseFileDao.insert(videoCourseFile);
          }
          onComplete();
        }
      } catch (e) {
        onError();
        e.printLog(message: 'error download');
      }
    } else {
      logPrint("else from isolate");
      // Dio? dio = Dio();

      if (kDebugMode) {
        dio.interceptors.add(
          DioLoggingInterceptor(
            level: Level.body,
            compact: false,
          ),
        );
      }

      try {
        // int receivedData = 0;
        // int totalData = 1;
        // int dateTimeMilisecond = DateTime.now().millisecond;

        File file;
        if (type == Folder.video || type == Folder.videoCourse) {
          file = File('$folderPath$fileNameWithExtension');
        } else {
          file = File('$folderPath$fileNameWithExtension');
        }

        print('wdcwec $url');
        dio.download(url, file.path,
            cancelToken: cancelToken, // Pass the cancelToken here
                options: Options(
                  responseType: ResponseType.bytes,
                  followRedirects: true,
                ),
          onReceiveProgress: (rec, total) {
            if (cancelToken.isCancelled) {
              print('Download cancelled during progress');
              return;
            }

            // Print progress in MB
            if (total != -1) { // -1 indicates unknown total
              double receivedMB = rec / (1024 * 1024); // Convert bytes to MB
              double totalMB = total / (1024 * 1024); // Convert bytes to MB

              // print("Downloaded: ${receivedMB.toStringAsFixed(2)} MB / ${totalMB.toStringAsFixed(2)} MB");
            }
          },
        )
            .then((value) async {
          if (value.statusCode == 200) {
            final database = await DbInstance.instance();

            if (type == Folder.audio) {
              final audioDao = database.audioDao;
              final audio = Audio(
                  audioId ?? '',
                  catId ?? '',
                  audioName ?? '',
                  catName ?? '',
                  audioImage ?? '',
                  file.absolute.path,
                  url,
                  rating ?? "");
              await audioDao.insert(audio);
              onComplete();
            } else if (type == Folder.audioCourse) {
              final audioCourseFolderDao = database.audioCourseFolderDao;
              final audioCourseFolder = AudioCourseFolder(
                  courseId ?? '',
                  catId ?? '',
                  courseName ?? '',
                  catName ?? '',
                  courseImage ?? '',
                  file.parent.absolute.path,
                  chapterId ?? "",
                  courseId ?? "",
                  rating ?? "");
              await audioCourseFolderDao.insert(audioCourseFolder);

              final audioCourseFileDao = database.audioCourseFileDao;
              final audioCourseFile = AudioCourseFile(
                  audioId ?? '',
                  catId ?? '',
                  courseId ?? '',
                  audioName ?? '',
                  catName ?? '',
                  courseName ?? '',
                  audioImage ?? '',
                  file.absolute.path,
                  url,
                  rating ?? "",
                  true);
              await audioCourseFileDao.insert(audioCourseFile);
              onComplete();
            } else if (type == Folder.video) {
              final videoDao = database.videoDao;
              final video = Video(
                  audioId ?? '',
                  catId ?? '',
                  audioName ?? '',
                  catName ?? '',
                  audioImage ?? '',
                  file.absolute.path,
                  url,
                  rating ?? "");
              await videoDao.insert(video);
              onComplete();
            } else if (type == Folder.videoCourse) {
              final videoCourseFolderDao = database.videoCourseFolderDao;
              final videoCourseFolder = VideoCourseFolder(
                  courseId ?? '',
                  catId ?? '',
                  courseName ?? '',
                  catName ?? '',
                  courseImage ?? '',
                  file.parent.absolute.path,
                  rating ?? "");
              await videoCourseFolderDao.insert(videoCourseFolder);

              final videoCourseFileDao = database.videoCourseFileDao;
              final videoCourseFile = VideoCourseFile(
                  audioId ?? '',
                  catId ?? '',
                  courseId ?? '',
                  audioName ?? '',
                  catName ?? '',
                  courseName ?? '',
                  audioImage ?? '',
                  audioDuration ?? '',
                  file.absolute.path,
                  url,
                  rating ?? "");
              await videoCourseFileDao.insert(videoCourseFile);
              onComplete();
            }
          }
        });
      } catch (e) {
        onError();
        e.printLog(message: 'error download');
      }
    }
  }

  static void cancelDownload() {
    if (!cancelToken.isCancelled) {
      cancelToken.cancel("Download was cancelled.");
      final VideoCourseDetailController videoCourseDetailController = Get.put(VideoCourseDetailController());

      videoCourseDetailController.downloadStatus.value = DownloadingStatus.downloaded;
      print("Download cancelled.${videoCourseDetailController.downloadStatus.value}");
    }
  }
  static void dispose() {
    // Cancel any ongoing downloads
    cancelDownload();

    // Close Dio instance to free resources
    dio.close();
    print("Dio instance closed.");


    // Reset or dispose of any other resources if necessary
    cancelToken = CancelToken(); // Recreate token if needed
    print("Cancel token disposed.");
    // Get.find<VideoCourseDetailController>().downloadStatus.value = DownloadingStatus.reDownload;
    // print('sdcdcs ${Get.find<VideoCourseDetailController>().downloadStatus.value}');
    // If you have any other resources (e.g., listeners, streams), dispose them here.
  }

  static Future<bool> isAudioFileExist(
      String? folderName, String fileName) async {
    //Path for creating your folder.
    final appDocumentsDir = await getTemporaryDirectory();
    final appDocumentPath = appDocumentsDir.absolute.path;
    appDocumentPath.toString().printLog(message: "path: ");

    final Directory audioPath;
    if ((folderName ?? '').isNotEmpty) {
      audioPath = Directory(
          '$appDocumentPath/StContent/Audio Courses${(folderName != null) ? '/$folderName' : ''}');
    } else {
      audioPath = Directory(
          '$appDocumentPath/StContent/Audios${(folderName != null) ? '/$folderName' : ''}');
    }
    File(join(audioPath.path, fileName))
        .existsSync()
        .printLog(message: 'isEXITSS');
    return File(join(audioPath.path, fileName)).existsSync();
  }

  static Future<List<DownloadedFileModel>> readFolderFile(String folder) async {
    //Path for creating your folder.

    final appDocumentsDir = await getTemporaryDirectory();
    final appDocumentPath = appDocumentsDir.absolute.path;
    appDocumentPath.toString().printLog(message: "path: ");

    if (folder == Folder.audio) {
      final path = Directory('$appDocumentPath/StContent/Audios');
      if (path.existsSync()) {
        List<FileSystemEntity> filesAndFolders = path.listSync();
        return getAllFiles(filesAndFolders);
      }
    } else if (folder == Folder.audioCourse) {
      final path = Directory('$appDocumentPath/StContent/Audio Courses');
      if (path.existsSync()) {
        List<FileSystemEntity> filesAndFolders = path.listSync();
        return getAllFiles(filesAndFolders);
      }
    } else {
      return [];
    }

    return [];
  }

  static Future<List<DownloadedFileModel>> getAllFiles(
      List<FileSystemEntity> filesAndFolders) async {
    List<DownloadedFileModel> list = [];
    for (var element in filesAndFolders) {
      if (await FileSystemEntity.isDirectory(element.path)) {
        ''.printLog(message: basename(element.path));

        final path = Directory(element.path);
        DownloadedFileModel file = DownloadedFileModel(
            name: (basename(element.path).split('.').isNotEmpty)
                ? basename(element.path).split('.').first
                : basename(element.path),
            imagePath: '',
            path: element.path,
            isFolder: true,
            folderFiles:
                path.existsSync() ? await getAllFiles(path.listSync()) : null);

        list.add(file);
      } else if (await FileSystemEntity.isFile(element.path)) {
        DownloadedFileModel file = DownloadedFileModel(
          name: (basename(element.path).split('.').isNotEmpty)
              ? basename(element.path).split('.').first
              : basename(element.path),
          imagePath: '',
          path: element.path,
          isFolder: false,
        );

        list.add(file);
      }
    }

    return list;
  }
}
