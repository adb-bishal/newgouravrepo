import 'dart:io';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:in_app_update/in_app_update.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stockpathshala_beta/model/services/download_service/download_file.dart';
import '../../service/utils/device_info_util.dart';
import '../../view/widgets/log_print/log_print_condition.dart';
import '../../view/widgets/toast_view/showtoast.dart';
import '../../view/widgets/view_helpers/permission_handler_helper.dart';
import '../services/auth_service.dart';
import 'app_constants.dart';
import 'package:share_plus/share_plus.dart';

class HelperUtil {
  static HelperUtil? _instance;

  static HelperUtil get instance => _instance ??= HelperUtil._init();

  HelperUtil._init();

  static Future copyToClipBoard({required String textToBeCopied}) async {
    await Clipboard.setData(ClipboardData(text: textToBeCopied)).then(
        (value) => toastShow(message: "$textToBeCopied copied", error: false),
        onError: (e, stack) {
      logPrint("Error while copy $e");
    });
  }

  /// Check for app updates in play store.
  static Future<void> checkForUpdate() async {
    logPrint('checking for updates');
    InAppUpdate.checkForUpdate().then((info) async {
      if (info.updateAvailability == UpdateAvailability.updateAvailable) {
        AppUpdateResult result = await InAppUpdate.performImmediateUpdate();
        if (result == AppUpdateResult.userDeniedUpdate) {
          toastShow(message: "clicked");
        }
      }
    }).catchError((e) {
      Get.log(e.toString());
    });
  }

  /// Showing a feedback so that user doesnt click continuesly on button.
  /// a progres indicator on top of page.
  void _shareButtonFeedback() {
    var route = GetPageRoute(
        opaque: false,
        page: () => Material(
              color: Colors.black.withOpacity(0.2),
              child: const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ));
    navigator?.push(route);
    Future.delayed(const Duration(seconds: 1))
        .then((value) => Get.removeRoute(route));
  }

  static Future<void> share({
    required String referCode,
    required String url,
  }) async {
     Share.share(
        referCode.isEmpty
            ? url.toString()
            : "Hey, I am recommending you Stock Pathshala for learning the Stock Market.\n\nUse my referral code $referCode to signup and get 200 credit points.\n\nThank me later! 🙂 ",
        subject: "Share Stockpathshala"
    );

    // return FlutterShare.share(
    //       title: 'Stockpathshala ',
    //       text: referCode == ""?"":"Hey, I am recommending you Stock Pathshala for learning Stock Market.\n\nUse my referral code $referCode to signup and get 200 credit points.\n\nThank me later! 🙂 ",
    //       linkUrl: url.toString(),
    //       chooserTitle: "Share Stockpathshala");
  }

  Future<ShortDynamicLink> buildInviteLink(
      {bool isAppShare = true, String? shareId, String? type}) async {
    /// calling function, to disable multiple clicks.
    _shareButtonFeedback();
    String link =
        "${AppConstants.instance.dynamicLink}/${isAppShare ? Get.find<AuthService>().user.value.referralCode : "$type/$shareId"}";
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: AppConstants.instance.dynamicLink,
      link: Uri.parse(link),
      androidParameters: AndroidParameters(
        fallbackUrl: Uri.parse(AppConstants.instance.fallBackUrl),
        packageName: AppConstants.instance.packageName,
        minimumVersion: 0,
      ),

      /// ios bundle name
      iosParameters: IOSParameters(
        minimumVersion: "0",
        appStoreId: AppConstants.instance.appStoreId,
        bundleId: AppConstants.instance.bundleId,
      ),
    );
    final ShortDynamicLink data =
        await FirebaseDynamicLinks.instance.buildShortLink(parameters);

    return data;
  }

  Future<dynamic> openUrlFunction(
      {String? courseId,
      String? courseName,
      required Function(DownloadStatus) onListen}) async {
    logPrint(
        "download url ${"${AppConstants.instance.certificateDownload}/${courseId ?? ""}/${Get.find<AuthService>().user.value.id ?? ""}"}");
    String url =
        "${AppConstants.instance.certificateDownload}/${courseId ?? ""}/${Get.find<AuthService>().user.value.id ?? ""}";
    if (Platform.isAndroid) {
      var info = await DeviceInfoUtil.instance.deviceInfoPlugin.androidInfo;
      PermissionStatus status = await Permission.storage.status;
      if (info.version.sdkInt <= 33 && status == PermissionStatus.granted) {
        DownloadService.instance.downloadFile(
            url, courseName ?? "", courseName ?? "",
            onListen: onListen);
      } else {
        PermissionHandlerHelper.permissionStorageConfirmationDialog(
            context: Get.context!,
            onMethodCall: () async {
              DownloadService.instance.downloadFile(
                  url, courseName ?? "", courseName ?? "",
                  onListen: onListen);
            });
      }
    } else {
      DownloadService.instance.downloadFile(
          url, courseName ?? "", courseName ?? "",
          onListen: onListen);
    }
    // await launch("${AppConstants.instance.certificateDownload}/${courseId??""}/${Get.find<AuthService>().user.value.id??""}").onError((error, stackTrace) {
    //   return false;
    // }).then((value) {
    //   toastShow(message: "File Downloaded !");
    //   return true;
    // });
  }
}
