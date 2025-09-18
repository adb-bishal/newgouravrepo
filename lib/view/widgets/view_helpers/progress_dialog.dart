import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lottie/lottie.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/animated_box.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/dashboard_controller/dashboard_controller.dart';

import '../../../enum/enum.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/string_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../view_model/routes/app_pages.dart';
import '../button_view/common_button.dart';
import '../popup_view/my_dialog.dart';

class ProgressDialog {
  bool isDialogShowing = false;

  ProgressDialog();

  Future<void> showProgressDialog() async {
    isDialogShowing = true;
    showDialog(
      context: Get.overlayContext!,
      barrierDismissible: false,
      builder: (_) => WillPopScope(
        onWillPop: () async => false,
        child: const Center(
          child: SizedBox(
            width: 60,
            height: 60,
            child: CircularProgressIndicator(
              color: ColorResource.primaryColor,
              strokeWidth: 2,
            ),
          ),
        ),
      ),
    );
  }

  Future<void> closeProgressDialog() async {
    if (isDialogShowing) {
      Navigator.of(Get.overlayContext!).pop();
    }
  }

  Future<void> showNoInternetDialog(BuildContext context) async {
    if (!isDialogShowing) {
      isDialogShowing = true;
      return showAnimatedDialog(
          context,
          MyDialog(
            title: "Permission Request",
            image: ImageResource.instance.permissionSettingsIcon,
            description:
                "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary.",
            isFailed: false,
            yesText: "Continue",
            noText: "Cancel",
            onPress: () async {},
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    StringResource.noInternetAccess,
                    style: StyleResource.instance.styleSemiBold(),
                    textAlign: TextAlign.center,
                  ),
                  Image.asset(
                    ImageResource.instance.noInternetIcon,
                    height: 130,
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall,
                  ),
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        StringResource.goBack,
                        style: StyleResource.instance
                            .styleSemiBold(color: ColorResource.primaryColor),
                      ))
                ],
              ),
            ),
          ),
          dismissible: false,
          isFlip: true);
    }
  }

  Future<void> showCommonDialog(BuildContext context,
      {required Widget child}) async {
    return showAnimatedDialog(
        context,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          description:
              "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary.",
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {},
          child: child,
        ),
        dismissible: false,
        isFlip: true);
  }

  Future<void> showRedeemDialog(
      {required Function() onDone,
      String? coins,
      String? title,
      String? buttonText}) async {
    return showAnimatedDialog(
        Get.context!,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          description:
              "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary.",
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {},
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  StringResource.redeemNow,
                  style: StyleResource.instance.styleSemiBold(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: DimensionResource.marginSizeDefault,
                ),
                Image.asset(
                  ImageResource.instance.coinsIcon,
                  height: 60,
                ),
                const SizedBox(
                  height: DimensionResource.marginSizeSmall,
                ),
                Text(
                  title ?? "${coins ?? ""} Points",
                  style: StyleResource.instance.styleSemiBold(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: DimensionResource.marginSizeSmall,
                ),
                Obx(() {
                  return CommonButton(
                    text: buttonText ?? StringResource.redeemNow,
                    onPressed: onDone,
                    loading:
                        Get.find<DashboardController>().isRedeemLoading.value,
                  );
                }),
                TextButton(
                    onPressed: () {
                      Get.back();
                    },
                    child: Text(
                      StringResource.cancel,
                      style: StyleResource.instance
                          .styleSemiBold(color: ColorResource.primaryColor),
                    ))
              ],
            ),
          ),
        ),
        dismissible: false,
        isFlip: true);
  }

  Future<void> showFlipDialog(
      {bool isForPro = true,
      String? title,
      String? actionTitle,
      bool showCancel = true,
      VoidCallback? onTap,
      dynamic? data, String? name}) async {
    return showAnimatedDialog(
        Get.context!,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          description:
              "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary.",
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {},
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ??
                      (isForPro
                          ? Platform.isIOS
                              ? ""
                              : StringResource.proRequireText
                          : StringResource.signInRequireText),
                  style: StyleResource.instance.styleSemiBold(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: DimensionResource.marginSizeSmall,
                ),
                if (isForPro && Platform.isIOS)
                  Lottie.asset(ImageResource.instance.comingSoonImage,
                      height: 150, fit: BoxFit.contain, width: double.infinity),
                if (isForPro && Platform.isAndroid)
                  Image.asset(
                    isForPro
                        ? ImageResource.instance.hello
                        : ImageResource.instance.caution,
                    height: 130,
                  ),
                SizedBox(
                  height:
                      (isForPro ? DimensionResource.marginSizeExtraSmall : 0) +
                          DimensionResource.marginSizeSmall,
                ),
                CommonButton(
                  text: actionTitle ??
                      (isForPro
                          ? Platform.isIOS
                              ? "Okay"
                              : StringResource.buyNowAgain
                          : StringResource.signIn),
                  //text: isForPro ? "Okay" :StringResource.signIn,
                  onPressed: onTap ??
                      () {
                        if (isForPro) {
                          Get.back();
                          if (Platform.isAndroid) {
                            Get.toNamed(Routes.subscriptionView);
                          }
                        } else {
                          print("showFlipDialog");
                          final box = GetStorage();
                          box.write('$name',data);
                          Get.put(LoginController());
                          Get.find<LoginController>().emailController.text =
                              "Enter phone number";
                          Get.offAllNamed(Routes.loginScreen);
                        }
                      },
                  loading: false,
                ),
                if (Platform.isAndroid && showCancel)
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        StringResource.cancel,
                        style: StyleResource.instance
                            .styleSemiBold(color: ColorResource.primaryColor),
                      ))
              ],
            ),
          ),
        ),
        dismissible: false,
        isFlip: true);
  }

  Future<void> showFlipDialogForMentor(
      {bool isForPro = true,
        String? title,
        String? actionTitle,
        bool showCancel = true,
        VoidCallback? onTap,
        dynamic? data, String? name, required String? categoryName}) async {
    return showAnimatedDialog(
        Get.context!,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          description:
          "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary.",
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {},
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ??
                      (isForPro
                          ? Platform.isIOS
                          ? ""
                          : StringResource.proRequireText
                          : StringResource.signInRequireText),
                  style: StyleResource.instance.styleSemiBold(),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: DimensionResource.marginSizeSmall,
                ),
                if (isForPro && Platform.isIOS)
                  Lottie.asset(ImageResource.instance.comingSoonImage,
                      height: 150, fit: BoxFit.contain, width: double.infinity),
                if (isForPro && Platform.isAndroid)
                  Image.asset(
                    isForPro
                        ? ImageResource.instance.hello
                        : ImageResource.instance.caution,
                    height: 130,
                  ),
                SizedBox(
                  height:
                  (isForPro ? DimensionResource.marginSizeExtraSmall : 0) +
                      DimensionResource.marginSizeSmall,
                ),
                CommonButton(
                  text: actionTitle ??
                      (isForPro
                          ? Platform.isIOS
                          ? "Okay"
                          : StringResource.buyNowAgain
                          : StringResource.signIn),
                  //text: isForPro ? "Okay" :StringResource.signIn,
                  onPressed: onTap ??
                          () {
                        if (isForPro) {
                          Get.back();
                          if (Platform.isAndroid) {
                            Get.toNamed(Routes.subscriptionView);
                          }
                        } else {
                          final box = GetStorage();
                          print("showFlipDialogForMentor $categoryName");
                          box.write('$name',data);
                          box.write("categoryName", categoryName);
                          Get.put(LoginController());
                          Get.find<LoginController>().emailController.text =
                          "Enter phone number";
                          Get.offAllNamed(Routes.loginScreen);
                        }
                      },
                  loading: false,
                ),
                if (Platform.isAndroid && showCancel)
                  TextButton(
                      onPressed: () {
                        Get.back();
                      },
                      child: Text(
                        StringResource.cancel,
                        style: StyleResource.instance
                            .styleSemiBold(color: ColorResource.primaryColor),
                      ))
              ],
            ),
          ),
        ),
        dismissible: false,
        isFlip: true);
  }


  Future<void> showConfirmFlipDialog(
      {String? title,
      required Function() onConfirm,
      Function()? onDecline,
      String? confirmText,
      String? declineText,
      Color? confirmColor,
      Color? declineColor}) async {
    return showAnimatedDialog(
        Get.context!,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          description:
              "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary.",
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {},
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title ?? "",
                  style: StyleResource.instance.styleSemiBold(),
                  textAlign: TextAlign.center,
                ),
                //Image.asset(isForPro ? ImageResource.instance.hello: ImageResource.instance.caution,height: 130,),
                const SizedBox(
                  height: DimensionResource.marginSizeLarge,
                ),
                SizedBox(
                  height: 40,
                  child: Row(
                    children: [
                      Expanded(
                        child: CommonButton(
                          text: confirmText ?? "Delete",
                          onPressed: onConfirm,
                          loading: false,
                          color: confirmColor ?? ColorResource.white,
                          style: StyleResource.instance.styleSemiBold(
                              color: confirmColor != null
                                  ? ColorResource.white
                                  : ColorResource.primaryColor),
                        ),
                      ),
                      const SizedBox(
                        width: DimensionResource.marginSizeSmall,
                      ),
                      Expanded(
                        child: CommonButton(
                          color: declineColor ?? ColorResource.secondaryColor,
                          text: declineText ?? StringResource.cancel,
                          style: StyleResource.instance.styleSemiBold(
                              color: declineColor != null
                                  ? ColorResource.primaryColor
                                  : ColorResource.white),
                          onPressed: onDecline ??
                              () {
                                Get.back();
                              },
                          loading: false,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        dismissible: false,
        isFlip: true);
  }

  Future<void> showInforDialog({
    required String? description,
    required BuildContext context,
    VoidCallback? onPressed,
  }) async {
    return showAnimatedDialog(
      Get.context!,
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: SizedBox(
          width: MediaQuery.of(context).size.width * .8,
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Positioned(
                top: -10,
                right: -10,
                child: Container(
                  height: 30,
                  width: 30,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: ColorResource.primaryColor,
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: ColorResource.white,
                      )),
                  child: InkWell(
                    onTap: Get.back,
                    child: const Icon(
                      Icons.close,
                      color: ColorResource.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      description ?? '',
                      style: StyleResource.instance.styleSemiBold(),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(
                      height: DimensionResource.marginSizeExtraLarge,
                    ),
                    CommonButton(
                      text: "Okay",
                      onPressed: onPressed ?? Get.back,
                      loading: false,
                      color: ColorResource.primaryColor,
                      style: StyleResource.instance
                          .styleSemiBold(color: ColorResource.white),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      dismissible: true,
      isFlip: true,
    );
  }

//   Row _buildContinueLine() {
//     return Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.center,
//       mainAxisSize: MainAxisSize.max,
//       children: [
//         Container(
//           height: 2,
//           width: 80,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 colors: [
//                   ColorResource.primaryColor,
//                   ColorResource.grey,
//                 ],
//                 begin: FractionalOffset(0.0, 0.0),
//                 end: FractionalOffset(1.0, 0.0),
//                 stops: [0.0, 1.0],
//                 tileMode: TileMode.decal),
//           ),
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         Text(
//           "or",
//           style: StyleResource.instance.styleRegular(
//               fontSize: DimensionResource.fontSizeSmall,
//               color: ColorResource.white),
//         ),
//         const SizedBox(
//           width: 10,
//         ),
//         Container(
//           height: 2,
//           width: 80,
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 colors: [
//                   ColorResource.primaryColor,
//                   ColorResource.grey,
//                 ],
//                 begin: FractionalOffset(1.0, 0.0),
//                 end: FractionalOffset(0.0, 0.0),
//                 stops: [0.0, 1.0],
//                 tileMode: TileMode.decal),
//           ),
//         ),
//       ],
//     );
//   }
}
