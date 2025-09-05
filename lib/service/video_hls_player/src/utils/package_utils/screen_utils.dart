import 'package:flutter/services.dart';

class ScreenUtils {
  static void toggleFullScreen(bool fullScreen) {
    if (fullScreen) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);
      //OrientationPlugin.forceOrientation(DeviceOrientation.portraitUp);
    } else {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeRight,
      ]);
      // OrientationPlugin.forceOrientation(DeviceOrientation.landscapeRight);
    }
  }
}
