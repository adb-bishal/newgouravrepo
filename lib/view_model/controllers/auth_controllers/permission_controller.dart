import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../model/services/auth_service.dart';
import '../../../model/utils/string_resource.dart';
import '../../../view/widgets/log_print/log_print_condition.dart';
import '../../routes/app_pages.dart';

class PermissionController extends GetxController {
  VoidCallback get onPermissionAllow => () async {
        try {
          PermissionStatus camaraPermissionStatus =
              await Permission.camera.status;
          logPrint(camaraPermissionStatus);
          if (camaraPermissionStatus.isGranted) {
            Get.find<AuthService>()
                .box
                .write(StringResource.instance.isPermission, true)
                .then((value) => Get.toNamed(Routes.rootView));
          } else if (camaraPermissionStatus.isDenied) {
            try {
              await Permission.camera
                  .request()
                  .then((PermissionStatus value) async {
                if (value.isGranted) {
                  Get.find<AuthService>()
                      .box
                      .write(StringResource.instance.isPermission, true)
                      .then((value) => Get.toNamed(Routes.rootView));
                } else if (value.isPermanentlyDenied) {
                  await openAppSettings();
                } else {
                  logPrint("Something want wrong here.");
                }
              });
            } catch (e) {
              logPrint(e);
            }
          } else if (camaraPermissionStatus.isPermanentlyDenied) {
            await openAppSettings();
          } else {
            logPrint("Something want wrong here.");
          }
        } catch (e) {
          logPrint(e);
        }
      };
  VoidCallback get ignoreTap => () {
        Get.find<AuthService>()
            .box
            .write(StringResource.instance.isPermission, true)
            .then((value) => Get.toNamed(Routes.rootView));
      };
}
