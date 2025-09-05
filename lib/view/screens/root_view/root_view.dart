import 'dart:io';
import 'dart:math' as math;
// import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:stockpathshala_beta/mentroship/view/mentorship_screen.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/courses_view/courses_view.dart';
import 'package:stockpathshala_beta/view/screens/home/home_screen.dart' hide cachedNetworkImage;
import 'package:stockpathshala_beta/view/screens/root_view/batches/live_batches.dart';
import 'package:stockpathshala_beta/view/screens/root_view/drawer/drawer_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/video_course_detail_view/video_course_detail_view.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/profile_controller/profile_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../service/page_manager.dart';
import '../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../widgets/image_provider/image_provider.dart';
import '../base_view/video_base_view.dart';
import 'audio_course_detail_view/audio_course_detail_view.dart';
import '../mentor/mentor_screen.dart' hide cachedNetworkImage;

class RootView extends GetView<RootViewController> {
  const RootView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(RootViewController());

    if (!Get.find<AuthService>().isGuestUser.value) {
      Get.put(ProfileController());
    }

    var isShowFloatingButton = MediaQuery.of(context).viewInsets.bottom != 0;
    return OrientationChangeDetector(
      fromRoot: true,
      onPageBuilder: (context) => WillPopScope(
        onWillPop: controller.onWillPop,
        child: SafeArea(
          top: false,
          bottom: false,
          //bottom: Platform.isIOS ? true : false,
          child: isShowFloatingButton
              ? MainRootView()
              : OverlayTooltipScaffold(
              tooltipAnimationCurve: Curves.linear,
              tooltipAnimationDuration: const Duration(milliseconds: 1000),
              controller: controller.toolTipcontroller,
              preferredOverlay: Container(
                height: double.infinity,
                width: double.infinity,
                color: Colors.black.withOpacity(.8),
              ),
              builder: (context) {
                return MainRootView();
              }),
        ),
      ),
    );
  }
}

class MainRootView extends GetView<RootViewController> {
  MainRootView({super.key});

  final List<Widget> pages = [
    // const HomeViewScreen(),
    const HomeScreen(),
    // const MentorScreen(),
    const MentorshipScreen(),
    const LiveClassesView(),
    const LiveBatches(),
    const SizedBox(),
  ];

  @override
  Widget build(BuildContext context) {
    var isShowFloatingButton = MediaQuery.of(context).viewInsets.bottom != 0;

    return Obx(() {
      return Stack(
        fit: StackFit.expand,
        children: [
          Scaffold(
            resizeToAvoidBottomInset: false,
            extendBody: true,
            backgroundColor: ColorResource.white,
            key: controller.scaffoldKey,
            drawer: const DrawerView(),
            onDrawerChanged: (isOpened) {
              if (isOpened) {
                // controller.showTooltip();
              }
              controller.isShowFloatingButton.value = isOpened;
            },
            body: Stack(
              fit: StackFit.passthrough,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60),
                  child: pages[controller.selectedTab.value],
                ),
                Visibility(
                  visible: controller.pageManager.playlistNotifier.isNotEmpty &&
                      controller.pageManager.currentPlayingMedia.value.title.isNotEmpty,
                  child: GestureDetector(
                    onTap: () {
                      if ((controller.pageManager.currentPlayingMedia.value.extras?.isNotEmpty ??
                          false) &&
                          (controller.pageManager.currentPlayingMedia.value.extras?['type'] ==
                              "course")) {
                        Get.toNamed(
                            Routes.audioCourseDetail(
                                id: controller.pageManager.currentPlayingMedia
                                    .value.extras?['course_id']
                                    .toString()),
                            arguments: [
                              CourseDetailViewType.audioCourse,
                              controller.pageManager.currentPlayingMedia.value
                                  .extras?['course_id']
                                  .toString(),
                              "",
                              ""
                            ]);
                      } else {
                        Get.toNamed(
                            Routes.audioCourseDetail(
                                id: controller.pageManager.currentPlayingMedia.value.id.toString()),
                            arguments: [
                              CourseDetailViewType.audio,
                              controller.pageManager.currentPlayingMedia.value.id.toString(),
                              "",
                              ""
                            ]);
                      }
                    },
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 70),
                        child: Card(
                          elevation: 3,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                          margin: const EdgeInsets.symmetric(
                              horizontal: DimensionResource.marginSizeDefault,
                              vertical: DimensionResource.marginSizeSmall),
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              children: [
                                Container(
                                  height: 55,
                                  width: 55,
                                  clipBehavior: Clip.antiAliasWithSaveLayer,
                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
                                  child: cachedNetworkImage(
                                      controller.pageManager.currentPlayingMedia.value
                                          .extras?['image'] ??
                                          ''),
                                ),
                                const SizedBox(width: DimensionResource.marginSizeExtraSmall),
                                Expanded(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            Expanded(
                                                child: Text(
                                                  controller.pageManager.currentPlayingMedia.value.title,
                                                  style: StyleResource.instance
                                                      .styleSemiBold(fontSize: DimensionResource.fontSizeSmall),
                                                  maxLines: 2,
                                                  overflow: TextOverflow.ellipsis,
                                                )),
                                            InkWell(
                                              onTap: controller.onAudioClose,
                                              child: const Padding(
                                                padding: EdgeInsets.only(bottom: 4, left: 5),
                                                child: Icon(
                                                  Icons.clear,
                                                  size: 18,
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Obx(() {
                                          return Row(
                                            children: [
                                              if (controller.progressAudioNotifier.value.total.inSeconds != 0)
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                                    child: audioSlider(context,
                                                        value: controller.progressAudioNotifier.value.current
                                                            .inSeconds
                                                            .toDouble(),
                                                        min: 0.0,
                                                        max: controller.progressAudioNotifier.value.total.inSeconds
                                                            .toDouble(),
                                                        onChanged: controller.onChange,
                                                        onChangedEnd: controller.onChangeEnd),
                                                  ),
                                                ),
                                              SizedBox(
                                                height: 20,
                                                width: 20,
                                                child: controller.pageManager.playButtonNotifier.value ==
                                                    ButtonState.loading
                                                    ? playLoaderButton(height: 14, allPadding: 4)
                                                    : playIconButton(
                                                    onTap: controller.playButtonClicked,
                                                    icon: ImageResource.instance.playIcon,
                                                    isPlaying: (controller.pageManager.playButtonNotifier
                                                        .value ==
                                                        ButtonState.playing),
                                                    height: 14,
                                                    allPadding: 4),
                                              ),
                                            ],
                                          );
                                        })
                                      ],
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            bottomNavigationBar: SafeArea(
              top: false, // This prevents the white space above the navbar
              bottom: true, // This maintains padding for system navigation bar
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: Platform.isIOS ? 110 : 90,
                    child: Stack(
                      children: <Widget>[
                        if (!isShowFloatingButton)
                          Obx(() {
                            return Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: Platform.isIOS ? 82 : 62,
                                padding: const EdgeInsets.only(top: 4),
                                decoration: const BoxDecoration(
                                    color: ColorResource.primaryColor,
                                    borderRadius: BorderRadius.only(
                                        topRight: Radius.circular(16), topLeft: Radius.circular(16))),
                                child: Container(
                                  padding: EdgeInsets.only(bottom: Platform.isIOS ? 20 : 0),
                                  decoration: BoxDecoration(
                                      color: Get.find<AuthService>().isProExpired.value
                                          ? ColorResource.redColor
                                          : ColorResource.secondaryColor,
                                      borderRadius: const BorderRadius.only(
                                          topRight: Radius.circular(16), topLeft: Radius.circular(16))),
                                  child: Obx(() {
                                    return Row(
                                      children: List.generate(
                                          controller.bottomIcon.length,
                                              (index) => Expanded(
                                            child: InkWell(
                                              onTap: () {
                                                if (index == 4) {
                                                  Get.toNamed(Routes.subscriptionView);
                                                } else {
                                                  controller.selectedTab.value = index;
                                                }
                                              },
                                              child: index != 4
                                                  ? Container(
                                                margin: const EdgeInsets.all(1),
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    if (index != 2)
                                                      Container(
                                                        padding: const EdgeInsets.all(4),
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          boxShadow: controller.bottomIcon[index]
                                                              .title ==
                                                              StringResource.batchSub
                                                              ? [
                                                            BoxShadow(
                                                                color: ColorResource
                                                                    .starColor
                                                                    .withOpacity(0.3),
                                                                blurRadius: 10,
                                                                spreadRadius: 2)
                                                          ]
                                                              : [],
                                                          color: Get.find<AuthService>()
                                                              .isProExpired
                                                              .value
                                                              ? ColorResource.redColor
                                                              : controller.bottomIcon[index].title ==
                                                              StringResource.batchSub
                                                              ? ColorResource.starColor
                                                              : ColorResource.secondaryColor,
                                                        ),
                                                        child: Image.asset(
                                                          controller.bottomIcon[index].icon!,
                                                          height: 14,
                                                          color: controller.selectedTab.value ==
                                                              index
                                                              ? Get.find<AuthService>()
                                                              .isProExpired
                                                              .value
                                                              ? ColorResource.black
                                                              : ColorResource.primaryColor
                                                              : ColorResource.white,
                                                        ),
                                                      ),
                                                    const Spacer(),
                                                    Text(
                                                      controller.bottomIcon[index].title!,
                                                      style: StyleResource.instance
                                                          .styleMedium()
                                                          .copyWith(
                                                        color: controller.selectedTab.value ==
                                                            index
                                                            ? Get.find<AuthService>()
                                                            .isProExpired
                                                            .value
                                                            ? ColorResource.black
                                                            : ColorResource.primaryColor
                                                            : ColorResource.white,
                                                        fontSize: DimensionResource
                                                            .fontSizeExtraSmall -
                                                            1,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              )
                                                  : Container(
                                                margin: const EdgeInsets.all(1),
                                                padding: const EdgeInsets.symmetric(vertical: 8),
                                                child: Column(
                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                  children: [
                                                    if (index != 2)
                                                      Container(
                                                        decoration: BoxDecoration(
                                                          shape: BoxShape.circle,
                                                          boxShadow: controller.bottomIcon[index]
                                                              .title ==
                                                              StringResource.batchSub &&
                                                              !Get.find<AuthService>().isPro.value
                                                              ? [
                                                            BoxShadow(
                                                                color: ColorResource.goldenColor
                                                                    .withOpacity(0.3),
                                                                blurRadius: 10,
                                                                spreadRadius: 2)
                                                          ]
                                                              : [],
                                                        ),
                                                        child: controller.getUserIcon() != null
                                                            ? Image.network(
                                                          controller.getUserIcon() ?? "",
                                                          height: 20,
                                                        )
                                                            : Container(),
                                                      ),
                                                    const Spacer(),
                                                    Text(
                                                      controller.bottomIcon[index].title ==
                                                          StringResource.batchSub ||
                                                          controller.bottomIcon[index].title ==
                                                              StringResource.batchSub2
                                                          ? Get.find<AuthService>().isPro.value
                                                          ? StringResource.batchSub2
                                                          : Get.find<AuthService>().isTrial.value
                                                          ? StringResource.trialUser
                                                          : Get.find<AuthService>()
                                                          .isTrialExpired
                                                          .value
                                                          ? StringResource
                                                          .trialExpiredUser
                                                          : Get.find<AuthService>()
                                                          .isProExpired
                                                          .value
                                                          ? StringResource
                                                          .proExpiredUser
                                                          : StringResource.batchSub
                                                          : controller.bottomIcon[index].title!,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: StyleResource.instance
                                                          .styleMedium()
                                                          .copyWith(
                                                        color: controller.selectedTab.value ==
                                                            index
                                                            ? ColorResource.primaryColor
                                                            : ColorResource.white,
                                                        fontSize: DimensionResource
                                                            .fontSizeExtraSmall -
                                                            1,
                                                      ),
                                                    )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          )),
                                    );
                                  }),
                                ),
                              ),
                            );
                          }),
                      ],
                    ),
                  ),
                  if (!isShowFloatingButton)
                    InkWell(
                      onTap: () {
                        controller.selectedTab.value = 2;
                      },
                      child: Stack(
                        alignment: Alignment.center,
                        clipBehavior: Clip.antiAlias,
                        children: [
                          Transform.rotate(
                            angle: -math.pi / 4,
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: ColorResource.white,
                                borderRadius: BorderRadius.circular(7),
                                border: Border.all(
                                  width: 3,
                                  color: ColorResource.primaryColor,
                                ),
                              ),
                              height: 55,
                              width: 55,
                            ),
                          ),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(50),
                            child: Image.asset(
                              ImageResource.instance.liveIconRed,
                              height: 47,
                              width: 47,
                            ),
                          )
                        ],
                      ),
                    )
                ],
              ),
            ),
          ),
          Obx(
                () => controller.selectedTab.value == 0 && !controller.isShowFloatingButton.value
                ? Positioned(
              bottom: (controller.pageManager.playlistNotifier.isNotEmpty &&
                  controller.pageManager.currentPlayingMedia.value.title.isNotEmpty)
                  ? 150
                  : 77,
              right: 17,
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    Get.toNamed(Routes.quizzesView);
                  },
                  child: CircleAvatar(
                      radius: 25,
                      backgroundColor: ColorResource.primaryColor,
                      child: Container(
                        padding: const EdgeInsets.all(2),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white),
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(50),
                          child: SvgPicture.asset(
                            ImageResource.instance.quizOne,
                          ),
                        ),
                      )),
                ),
              ),
            )
                : const SizedBox.shrink(),
          ),
        ],
      );
    });
  }
}

class BottomIcon {
  final String? icon;
  final String? title;

  BottomIcon({this.icon, this.title});
}