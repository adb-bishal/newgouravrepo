import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stockpathshala_beta/main.dart';
import 'package:stockpathshala_beta/model/services/notification_service.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

enum DownloadStatus { start, error, complete }

class DownloadService {
  static DownloadService? _instance;
  static DownloadService get instance => _instance ??= DownloadService._init();
  DownloadService._init();

  Future downloadFile(String url, String filename, String title,
      {required Function(DownloadStatus) onListen}) async {
    String path = await getDownloadPath(
        folderName: "StockPathshala", fileNameWithExtension: "download.pdf");
    logPrint("download path $path");
    apiDownload(url, path, title, "$filename.pdf", onListen: onListen);
    logPrint("Download completed");
  }

  void apiDownload(
      String url, String folderPath, String title, String fileNameWithExtension,
      {required Function(DownloadStatus) onListen}) async {
    Dio dio = Dio();
    try {
      onListen(DownloadStatus.start);
      var response = await dio.get(
        url,
        onReceiveProgress: (received, total) {
          logPrint("Rec: $received , Total: $total");
        },
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: true,
            validateStatus: (status) {
              return status! < 500;
            }),
      );

      logPrint("response ${response.statusCode}");
      logPrint("response ${response.headers}");
      logPrint("response ${response.data}");

      if (response.statusCode == 200) {
        File file = File('$folderPath/$fileNameWithExtension');
        logPrint("file path ${file.path}");
        var raf = file.openSync(mode: FileMode.write);
        raf.writeFromSync(response.data);
        await raf.close();
        onListen(DownloadStatus.complete);
        MyNotification.showDownloadNotification(
            NotificationMessageData(
                title: title,
                body: "Your Certificate Downloaded Successfully",
                id: 23,
                filePath:
                    jsonEncode({"link_type": "pdf", "file_path": file.path})),
            flutterLocalNotificationsPlugin);
      } else {
        //onError();
        onListen(DownloadStatus.error);
      }
    } catch (e) {
      onListen(DownloadStatus.error);
      //onError();
      //e.printLog(message: 'error download');
    }
  }

  Future<String> getDownloadPath(
      {String? folderName, required String fileNameWithExtension}) async {
    Directory? tempDir;
    Directory path;
    String? tempPath;

    if (Platform.isAndroid) {
      tempDir = await getExternalStorageDirectory();
      tempPath = tempDir?.absolute.path
          .replaceAll('/Android/data/com.codeclinic.stockpathshala/files', '');
      path = Directory('$tempPath/Download/$folderName');

      /// if folder exists in four phone memory.
      if ((await path.exists())) {
        //download call
        return path.path;
      } else {
        /// Create folder in your memory.
        Directory? newPath = await path.create(recursive: true);
        return newPath.path;
      }
    } else {
      tempDir = await getApplicationDocumentsDirectory();
      tempPath = tempDir.absolute.path;
      path = Directory('$tempPath/Stockpathshala');

      /// if folder exists in four phone memory.
      if ((await path.exists())) {
        //download call
        return path.path;
      } else {
        /// Create folder in your memory.
        Directory? newPath = await path.create(recursive: true);
        return newPath.path;
      }
    }
  }
}
