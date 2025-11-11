import 'package:flash/flash.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import '../../model/utils/color_resource.dart';
import '../../model/utils/dimensions_resource.dart';
import '../../model/utils/image_resource.dart';
import '../../model/utils/style_resource.dart';
import 'log_print/log_print_condition.dart';

@immutable
class AlertDialogModel<bool> {
  final String? title;
  final String? message;
  final Map<String, bool> buttons;

  const AlertDialogModel({
    required this.title,
    required this.message,
    required this.buttons,
  });
}

@immutable
class PermissionAlertDialog extends AlertDialogModel<bool> {
  PermissionAlertDialog(
      {required String? title,
      required String? message,
      String? positiveButton,
      String? negativeButton})
      : super(
          title: title,
          message: message,
          buttons: {
            negativeButton ?? 'CANCEL'.tr: false,
            positiveButton ?? 'GRANT'.tr: true,
          },
        );
}

@immutable
class ShowToastFlash extends AlertDialogModel {
  ShowToastFlash(
      {required String title,
      required String message,
      String? positiveButton,
      String? negativeButton})
      : super(
          title: title,
          message: message,
          buttons: {
            negativeButton ?? 'CANCEL'.tr: false,
            positiveButton ?? 'CONFIRM'.tr: true,
          },
        );
}

extension PermissionDialogExtention on PermissionAlertDialog {
  Future<bool?> present(BuildContext context,
      {required Function() onPositiveAction}) {
    return showDialog<bool?>(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return Dialog(
          
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: ColorResource.white,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.marginSizeDefault,
                      vertical: DimensionResource.marginSizeLarge),
                  child: Text(
                    title ?? StringResource.shallArrangeCall,
                    style: StyleResource.instance.styleMedium(),
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                      border: Border(
                          top: BorderSide(
                              color: ColorResource.borderColor.withOpacity(0.4),
                              width: 1.3))),
                  child: IntrinsicHeight(
                    child: Row(
                      children: [
                        Expanded(
                            child: actionButton(() {
                          Get.back();
                        },
                                icon: ImageResource.instance.closeIcon,
                                text: StringResource.cancel,
                                isPositive: false)),
                        VerticalDivider(
                          color: ColorResource.borderColor.withOpacity(0.4),
                          thickness: 1.4,
                        ),
                        Expanded(
                            child: actionButton(onPositiveAction,
                                icon: ImageResource.instance.checkIcon,
                                text: StringResource.yes,
                                isPositive: true)),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        );
        // return AlertDialog(
        //   title: Text(
        //     title,
        //     style: StyleResource.instance.styleSemiBold(
        //         fontSize: DimensionResource.fontSizeLarge,
        //         color: ColorResource.black),
        //   ),
        //   content: Text(
        //     message,
        //     style: StyleResource.instance.styleRegular(
        //         fontSize: DimensionResource.fontSizeDefault,
        //         color: ColorResource.textColor_3),
        //   ),
        //   actions: buttons.entries.map(
        //     (entry) {
        //       if (entry.value) {
        //         return ElevatedButton(
        //           onPressed: () {
        //             Navigator.of(context).pop(
        //               entry.value,
        //             );
        //           },
        //           style: ElevatedButton.styleFrom(
        //               primary: ColorResource.primaryColor),
        //           child: Text(
        //             entry.key,
        //             style: StyleResource.instance.styleSemiBold(
        //                 fontSize: DimensionResource.fontSizeSmall,
        //                 color: ColorResource.white),
        //           ),
        //         );
        //       } else {
        //         return TextButton(
        //           child: Text(
        //             entry.key,
        //             style: StyleResource.instance.styleSemiBold(
        //                 fontSize: DimensionResource.fontSizeSmall,
        //                 color: ColorResource.primaryColor),
        //           ),
        //           onPressed: () {
        //             Navigator.of(context).pop(
        //               entry.value,
        //             );
        //           },
        //         );
        //       }
        //     },
        //   ).toList(),
        // );
      },
    );
  }
}

extension ShowToastExtention on ShowToastFlash {
  Future<bool?> present(BuildContext context,
      {required Function() onPositiveAction,
      Duration duration = const Duration(seconds: 2)}) {
    //Duration? duration = const Duration(seconds: 2);
    var flashStyle = FlashBehavior.floating;
    return showFlash(
      context: context,
      duration: duration,
      builder: (context, controller) {
        return FlashBar(
            margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(7),

            ),
            // borderRadius: BorderRadius.circular(7),
            controller: controller,
            behavior: flashStyle,
            position: FlashPosition.top,
            dismissDirections: [FlashDismissDirection.startToEnd],

            // boxShadows: kElevationToShadow[4],
            // horizontalDismissDirection: HorizontalDismissDirection.horizontal,
            content: InkWell(
              splashColor: Colors.transparent,
              onTap: onPositiveAction,
              child: Container(
                width: double.infinity,
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(6),
                        bottomRight: Radius.circular(6)),
                    color: ColorResource.primaryColor),
                padding: const EdgeInsets.symmetric(
                    vertical: DimensionResource.marginSizeSmall + 2),
                child: Text(
                  title ?? "",
                  textAlign: TextAlign.center,
                  style: StyleResource.instance.styleMedium(
                      fontSize: DimensionResource.fontSizeDefault,
                      color: ColorResource.white),
                ),
              ),
            ));
      },
    );
  }
}

InkWell actionButton(Function() onTap,
    {required String icon, required String text, required bool isPositive}) {
  return InkWell(
    onTap: onTap,
    child: Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeSmall,
          vertical: DimensionResource.marginSizeSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            icon,
            height: 13,
            color: isPositive
                ? ColorResource.mateGreenColor
                : ColorResource.mateRedColor,
          ),
          const SizedBox(
            width: DimensionResource.marginSizeExtraSmall,
          ),
          Text(
            text,
            style: StyleResource.instance.styleMedium(
                color: isPositive
                    ? ColorResource.mateGreenColor
                    : ColorResource.mateRedColor),
          ),
        ],
      ),
    ),
  );
}

class PermissionUtil {
  static PermissionUtil? _instance;
  static PermissionUtil get instance {
    _instance ??= PermissionUtil._init();
    return _instance!;
  }

  PermissionUtil._init();

  void permission(
      {required String title,
      required String message,
      required Permission permission,
      required Function() onPermissionGranted}) async {
    logPrint("permission");
    if (await checkPermission(permission)) {
      onPermissionGranted();
      return;
    }
    logPrint("permission 2");
    PermissionAlertDialog(
            title: title, message: message, positiveButton: 'GRANT'.tr)
        .present(Get.context!, onPositiveAction: () async {
      if (await _askPermission(permission)) {
        Get.back();
        onPermissionGranted();
      }
    }).then((value) async {
      if (value ?? false) {
        if (await _askPermission(permission)) {
          onPermissionGranted();
        }
      }
    });
  }

  Future<bool> _askPermission(Permission permission) async {
    PermissionStatus status = await permission.request();
    if (status == PermissionStatus.granted) {
      return true;
    } else if (status == PermissionStatus.permanentlyDenied) {
      await openAppSettings();
      return false;
    } else {
      return false;
    }
  }

  Future<bool> checkPermission(Permission permission) {
    return permission.isGranted;
  }
}
