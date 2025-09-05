import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stockpathshala_beta/service/utils/device_info_util.dart';

import '../../../model/utils/image_resource.dart';
import '../button_view/animated_box.dart';
import '../popup_view/my_dialog.dart';

class PermissionHandlerHelper {
  static permissionConfirmationDialog(
      {required BuildContext context, required Function onMethodCall}) async {
    showAnimatedDialog(
        context,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          description:
              "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary."
                  .capitalize,
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {
            PermissionStatus storagePermissionStatus =
                await Permission.camera.request();
            Get.back();
            if (storagePermissionStatus.isGranted) {
              onMethodCall();
            } else if (storagePermissionStatus.isDenied) {
              await Permission.camera.request().then((value) => onMethodCall());
            } else if (storagePermissionStatus.isPermanentlyDenied) {
              await openAppSettings();
            } else {
              await openAppSettings();
            }
          },
        ),
        dismissible: false,
        isFlip: true);
  }

  static permissionStorageConfirmationDialog(
      {required BuildContext context, required Function onMethodCall}) async {
    showAnimatedDialog(
        context,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          icon: const Icon(
            Icons.storage,
            color: Colors.white,
          ),
          description:
              "To allow you to download certificate please allow requested permission, this is necessary."
                  .capitalize,
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {
            // await Permission.storage.request();
            await Permission.storage.request();
            Get.back();
            var info =
                await DeviceInfoUtil.instance.deviceInfoPlugin.androidInfo;

            if (Platform.isAndroid && (info.version.sdkInt) <= 32) {
              PermissionStatus status = await Permission.storage.status;
              if (status == PermissionStatus.granted) {
                onMethodCall();
              } else if (status == PermissionStatus.permanentlyDenied) {
                openAppSettings();
              } else {
                if (await Permission.storage.request().isGranted) {
                  onMethodCall();
                }
              }
            } else if (Platform.isAndroid && (info.version.sdkInt) >= 33) {
              await Permission.storage.request().isGranted;
              onMethodCall();
            } else {
              await openAppSettings();
            }
          },
        ),
        dismissible: false,
        isFlip: true);
  }

// Future<void> createFolderAndDownloadFile({
  //   String? folderName,
  //   required String url, required String fileNameWithExtensions}) async {
  //   var info;
  //   if(Platform.isAndroid) {
  //     info = await DeviceInfoUtil.instance.deviceInfoPlugin.androidInfo;
  //   }
  //
  //   /*--------For create folder in memory
  //  Permission is required-------------*/
  //   else if (Platform.isAndroid && (info.version.sdkInt ?? 0) <= 32) {
  //
  //     PermissionStatus status = await Permission.storage.status;
  //     if(status == PermissionStatus.granted){
  //       onMethodCall();
  //     }
  //     else if(status == PermissionStatus.permanentlyDenied){
  //       openAppSettings();
  //     }
  //     else{
  //       if(await Permission.storage.request().isGranted){
  //         onMethodCall();
  //       }
  //     }
  //   }
  //   else if(Platform.isAndroid && (info.version.sdkInt ?? 0) <= 33){
  //     await Permission.storage.request().isGranted;
  //     onMethodCall();
  //   }
  //
  // }
}
