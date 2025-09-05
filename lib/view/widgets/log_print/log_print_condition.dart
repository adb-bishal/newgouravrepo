import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

void logPrint(var message) {
  if (kDebugMode) {
    Get.log(message.toString());
  }
}
