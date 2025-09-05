import 'dart:convert';
import 'dart:isolate';
import 'dart:ui';

import 'package:stockpathshala_beta/service/utils/object_extension.dart';

import '../../../view/widgets/log_print/log_print_condition.dart';

class SingletonGlobal {
  Function(Map<String, dynamic> map)? onStart;
  Function(Map<String, dynamic> map)? onDownload;
  Function(Map<String, dynamic> map)? onError;

  final _receivePort = ReceivePort();

  SingletonGlobal(
      {required this.onStart,
      required this.onError,
      required this.onDownload}) {
    _receivePort.listen((message) {
      Map<String, dynamic> messageData = json.decode(message);
      logPrint("recieve port 2 $messageData");
      logPrint("recieve port 2 $messageData");
      if (messageData["downloadStatus"] == '1') {
        onStart?.call(messageData);
      } else if (messageData["downloadStatus"] == '2') {
        onDownload?.call(messageData);
      } else if (messageData["downloadStatus"] == '0') {
        onError?.call(messageData);
      } else {
        logPrint("recieve port error $messageData");
      }
    });

    var val = IsolateNameServer.registerPortWithName(
        _receivePort.sendPort, 'download');
    val.printLog(message: 'port registered');
  }

  void unbindBackgroundIsolate() {
    var val = IsolateNameServer.removePortNameMapping('download');
    val.printLog(message: 'port unregistered');
  }
}
