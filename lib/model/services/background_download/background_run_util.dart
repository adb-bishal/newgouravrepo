import 'dart:convert';
import 'dart:ui';

import 'package:flutter_isolate/flutter_isolate.dart';
import 'package:stockpathshala_beta/service/utils/object_extension.dart';

import '../../../service/floor/entity/download.dart';
import '../../../service/utils/download_file_util.dart';
import '../../../view/widgets/log_print/log_print_condition.dart';

class BackgroundRunUtil {
  static BackgroundRunUtil? _instance;

  static BackgroundRunUtil get instance =>
      _instance ??= BackgroundRunUtil._init();
  BackgroundRunUtil._init();

  late FlutterIsolate isolate;

  static Function()? callIsolate;

  onInitFunction(Map<String, dynamic> map, bool isAudio) {
    logPrint("onInitFunction");
    startIsolate(map, isAudio);
  }

  void startIsolate(Map<String, dynamic> map, bool isAudio) async {
    logPrint("startIsolate");
    isolate = await FlutterIsolate.spawn<Map<String, dynamic>>(
        isAudio ? _isolateAudioEntry : _isolateVideoEntry, map);
  }

  @pragma('vm:entry-point')
  static void _isolateVideoEntry(Map<String, dynamic> map) {
    logPrint("isolateEntry");
    try {
      heyVideo(map, onStart: () {
        logPrint("onStart");
        IsolateNameServer.lookupPortByName('download')?.send('1');
      }, onComplete: () {
        logPrint("onComplete");
        IsolateNameServer.lookupPortByName('download')?.send("2");
      }, onError: () {
        logPrint("onError");
        IsolateNameServer.lookupPortByName('download')?.send("0");
      });
    } catch (e) {
      logPrint("_isolateVideoEntry error $e");
    }
  }

  @pragma('vm:entry-point')
  static void _isolateAudioEntry(Map<String, dynamic> map) {
    logPrint("isolateEntry");
    try {
      heyAudio(map, onStart: () {
        logPrint("onStart");
        IsolateNameServer.lookupPortByName('download')?.send('1');
      }, onComplete: () {
        logPrint("onComplete");
        IsolateNameServer.lookupPortByName('download')?.send("2");
      }, onError: () {
        logPrint("onError");
        IsolateNameServer.lookupPortByName('download')?.send("0");
      });
      //Get.find<VideoCourseDetailController>().onDownload();
    } catch (e) {
      logPrint("_isolateAudioEntry error $e");
    }
  }

  void stopIsolate() {
    'stopping isolat'.printLog();
    FlutterIsolate.current.kill();
  }
}

class DownloadQueueUtil {
  static DownloadQueueUtil? _instance;

  static DownloadQueueUtil get instance =>
      _instance ??= DownloadQueueUtil._init();
  DownloadQueueUtil._init();

  late FlutterIsolate isolate;
  static Function()? callIsolate;

  onInitFunction(String valueName) {
    logPrint("onInitFunction");
    startIsolate(valueName);
  }

  void startIsolate(String valueName) async {
    logPrint("startIsolate");
    isolate = await FlutterIsolate.spawn<String>(_isolateVideoEntry, valueName);
  }

  static downloadRecursion() async {
    final database = await DbInstance.instance();
    final downloadDao = database.downloadQueDao;
    List<DownloadQueue> downloadDataList = await downloadDao.findAllDownload();
    if (downloadDataList.isNotEmpty) {
      DownloadQueue firstData = downloadDataList.first;
      logPrint("download fileType ${firstData.fileType}");
      if (firstData.fileType == "video") {
        Map<String, dynamic> videoMap = getVideoMap(
            folderName: firstData.folderName ?? '',
            fileUrl: firstData.fileUrl ?? '',
            fileName: firstData.fileName ?? '',
            type: firstData.type ?? "",
            catId: firstData.catId ?? '',
            catName: firstData.catName ?? '',
            courseId: firstData.courseId ?? '',
            courseName: firstData.courseName ?? '',
            courseImage: firstData.courseImage ?? '',
            videoId: firstData.contentId,
            videoName: firstData.videoName ?? '',
            videoImage: firstData.videoImage ?? '',
            videoDuration: firstData.videoDuration ?? '',
            downloadStatus: "");
        logPrint("Video Map $videoMap");
        heyVideo(videoMap, onStart: () {
          logPrint("onStart");
          videoMap['downloadStatus'] = "1";
          String data = jsonEncode(videoMap);
          IsolateNameServer.lookupPortByName('download')?.send(data);
        }, onComplete: () async {
          logPrint("onComplete");
          videoMap['downloadStatus'] = "2";
          String data = jsonEncode(videoMap);
          await downloadDao.deletePerson(firstData);
          downloadRecursion();
          IsolateNameServer.lookupPortByName('download')?.send(data);
        }, onError: () async {
          logPrint("onError");
          videoMap['downloadStatus'] = "0";
          String data = jsonEncode(videoMap);
          await downloadDao.deletePerson(firstData);
          downloadRecursion();
          IsolateNameServer.lookupPortByName('download')?.send(data);
        });
      } else {
        Map<String, dynamic> audioMap = getAudioMap(
          fileUrl: firstData.fileUrl ?? '',
          fileName: firstData.fileName ?? "",
          type: firstData.type ?? "",
          catId: firstData.catId ?? '',
          catName: firstData.catName ?? '',
          audioId: firstData.audioId ?? "",
          audioName: firstData.audioName ?? "",
          audioImage: firstData.audioImage ?? '',
          folderName: firstData.folderName ?? "",
          courseId: firstData.courseId ?? '',
          courseName: firstData.courseName ?? '',
          courseImage: firstData.courseImage ?? '',
          downloadStatus: "",
        );
        logPrint("Audio Map $audioMap");
        heyAudio(audioMap, onStart: () {
          logPrint("onStart");
          audioMap['downloadStatus'] = "1";
          String data = jsonEncode(audioMap);
          IsolateNameServer.lookupPortByName('download')?.send(data);
        }, onComplete: () async {
          logPrint("onComplete");
          audioMap['downloadStatus'] = "2";
          String data = jsonEncode(audioMap);
          await downloadDao.deletePerson(firstData);
          downloadRecursion();
          IsolateNameServer.lookupPortByName('download')?.send(data);
        }, onError: () async {
          logPrint("onError");
          audioMap['downloadStatus'] = "0";
          String data = jsonEncode(audioMap);
          await downloadDao.deletePerson(firstData);
          downloadRecursion();
          IsolateNameServer.lookupPortByName('download')?.send(data);
        });
      }
    } else {
      logPrint("empty ");
    }
  }

  @pragma('vm:entry-point')
  static void _isolateVideoEntry(String valueName) {
    logPrint("isolateEntry");
    try {
      downloadRecursion();
    } catch (e) {
      logPrint("eee $e");
    }
  }

  void stopIsolate() {
    'stopping isolate run'.printLog();
    FlutterIsolate.current.kill();
  }
}
