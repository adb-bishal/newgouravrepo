import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/services/notification_service.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../widgets/button_view/common_button.dart';
import '../../../widgets/button_view/icon_button.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';
import '../chat/chat_view.dart';

class DrawerView extends GetView<RootViewController> {
  const DrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: 320,
      color: ColorResource.white,
      child: ListView(
        physics: const ClampingScrollPhysics(),
        children: [
          GestureDetector(
            onTap: () {
              if (!Get.find<AuthService>().isGuestUser.value) {
                Get.toNamed(Routes.profileScreen);
              } else {
                ProgressDialog().showFlipDialog(isForPro: false);
              }
            },
            child: Padding(
              padding:
                  const EdgeInsets.all(DimensionResource.marginSizeDefault),
              child: Obx(() {
                return Row(
                  children: [
                    imageCircleContainer(
                        radius: 21,
                        url: Get.find<AuthService>().user.value.profileImage ??
                            ""),
                    const SizedBox(
                      width: DimensionResource.marginSizeSmall,
                    ),
                    Expanded(
                      child: ColoredBox(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  Get.find<AuthService>().user.value.name ==
                                          null
                                      ? "User"
                                      : Get.find<AuthService>()
                                          .user
                                          .value
                                          .name
                                          .toString()
                                          .capitalize!,
                                  style: StyleResource.instance
                                      .styleMedium()
                                      .copyWith(letterSpacing: 0.6),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Text(
                                  'My Profile',
                                  style: StyleResource.instance
                                      .styleMedium(
                                          fontSize: DimensionResource
                                              .fontSizeExtraSmall,
                                          color: ColorResource.primaryColor)
                                      .copyWith(letterSpacing: 0.6),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ActionCustomButton(
                        onTap: () {
                          Get.find<RootViewController>()
                              .scaffoldKey
                              .currentState
                              ?.closeDrawer();
                        },
                        morePadding: const EdgeInsets.all(12),
                        icon: ImageResource.instance.closeIcon,
                        iconSize: 14,
                        iconColor: ColorResource.primaryColor,
                        isLeft: false,
                      ),
                    ),
                  ],
                );
              }),
            ),
          ),
          ...List.generate(
            controller.drawerItems.length,
            (index) {
              final data = controller.drawerItems[index];

              return data.title == StringResource.pastLiveClasses
                  ? OverlayTooltipItem(
                      tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
                      tooltip: (p0) {
                        return Padding(
                          padding: const EdgeInsets.only(left: 10, top: 20),
                          child: Container(
                            width: size.width * 0.8,
                            padding: const EdgeInsets.all(
                              10,
                            ),
                            decoration: BoxDecoration(
                                color: ColorResource.white,
                                borderRadius: BorderRadius.circular(10)),
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Tap here to check RECORDINGS of previous classes.',
                                  textAlign: TextAlign.center,
                                  style: StyleResource.instance.styleMedium(
                                    color: ColorResource.black,
                                  ),
                                ),
                                const SizedBox(
                                  height: 20,
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    InkWell(
                                      onTap: () async {
                                        await Get.find<AuthService>()
                                            .saveTrainingTooltips(
                                                'classRecordings');
                                        controller.toolTipcontroller.dismiss();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 5,
                                          bottom: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: ColorResource.primaryColor,
                                          ),
                                        ),
                                        child: Text(
                                          'Skip',
                                          style: StyleResource.instance
                                              .styleMedium(
                                            color: ColorResource.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () async {
                                        await Get.find<AuthService>()
                                            .saveTrainingTooltips(
                                                'classRecordings');
                                        controller.toolTipcontroller.dismiss();
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        padding: const EdgeInsets.only(
                                          left: 20,
                                          right: 20,
                                          top: 5,
                                          bottom: 5,
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          border: Border.all(
                                            color: ColorResource.primaryColor,
                                          ),
                                        ),
                                        child: Text(
                                          'Got it',
                                          style: StyleResource.instance
                                              .styleMedium(
                                            color: ColorResource.black,
                                          ),
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      displayIndex: 2,
                      child: drawerListTile(
                        isLast: controller.drawerItems.length - 1 == index,
                        onTap: () {
                          controller.onDrawerListTile(data.linkType, context);
                        },
                        title: data.title ?? "",
                        icon: data.icon ?? '',
                      ),
                    )
                  : drawerListTile(
                      isLast: controller.drawerItems.length - 1 == index,
                      onTap: () {
                        controller.onDrawerListTile(data.linkType, context);
                      },
                      title: data.title ?? "",
                      icon: data.icon ?? '',
                    );
            },
          ),
          Padding(
            //color: Colors.red,
            padding: EdgeInsets.only(
                left: DimensionResource.marginSizeDefault,
                right: DimensionResource.marginSizeDefault,
                top: Get.find<AuthService>().isPro.value ? 5 : 15),
            child: Column(
              children: [
                Visibility(
                  visible:
                      Get.find<AuthService>().isPro.value && Platform.isAndroid,
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: DimensionResource.marginSizeDefault,
                        right: DimensionResource.marginSizeDefault,
                        bottom: 10),
                    child: RichText(
                        text: TextSpan(
                            style: StyleResource.instance.styleRegular(
                                color: ColorResource.secondaryColor,
                                fontSize: DimensionResource.fontSizeSmall - 2),
                            children: [
                          const TextSpan(
                            text: "Pro Plan Expire On: ",
                          ),
                          TextSpan(
                            text: AppConstants.formatDateInForm(
                                Get.find<AuthService>().user.value.proExpireAt),
                            style: StyleResource.instance.styleSemiBold(
                                color: ColorResource.secondaryColor,
                                fontSize: DimensionResource.fontSizeSmall - 2),
                          )
                        ])),
                  ),
                ),
                Visibility(
                  visible: Platform.isAndroid,
                  child: CommonButton(
                    text: "",
                    loading: false,
                    onPressed: () {
                      if (!Get.find<AuthService>().isGuestUser.value) {
                        Get.toNamed(Routes.subscriptionView);
                        // Get.back();
                        // Get.find<RootViewController>().selectedTab.value = 4;
                      } else {
                        Get.find<LoginController>().emailController.text =
                            "Enter phone number";
                        Get.offAllNamed(Routes.loginScreen);
                        //ProgressDialog().showFlipDialog(isForPro: false);
                      }
                    },
                    child: Get.find<AuthService>().isGuestUser.value
                        ? Text(
                            StringResource.signIn,
                            style: StyleResource.instance
                                .styleRegular(color: ColorResource.white),
                          )
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                          color: ColorResource.starColor
                                              .withOpacity(0.3),
                                          blurRadius: 10,
                                          spreadRadius: 2)
                                    ],
                                    color: ColorResource.starColor),
                                child: Image.asset(
                                    ImageResource.instance.proIcon,
                                    height: 14,
                                    color: ColorResource.white),
                              ),
                              const SizedBox(
                                width: DimensionResource.marginSizeSmall,
                              ),
                              Text(
                                Get.find<AuthService>().isPro.value
                                    ? StringResource.updatePlan
                                    : StringResource.buyNowAgain,
                                style: StyleResource.instance
                                    .styleRegular(color: ColorResource.white),
                              )
                            ],
                          ),
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              "v${AppConstants.instance.appVersion}",
              style: StyleResource.instance.styleMedium(
                  color: ColorResource.borderColor.withOpacity(0.5)),
            ),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          )
        ],
      ),
    );
  }

  InkWell drawerListTile(
      {required Function() onTap,
      required String title,
      required String icon,
      bool isLast = false}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
            color: Colors.white,
            border: isLast
                ? null
                : Border(
                    bottom: BorderSide(
                        color: ColorResource.borderColor.withOpacity(0.3),
                        width: 1.2))),
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault,
            vertical: DimensionResource.marginSizeDefault),
        child: Row(
          children: [
            Image.network(
              icon,
              height: 16,
            ),
            const SizedBox(
              width: DimensionResource.marginSizeSmall,
            ),
            Text(
              title,
              style: StyleResource.instance.styleRegular(),
            )
          ],
        ),
      ),
    );
  }
}
