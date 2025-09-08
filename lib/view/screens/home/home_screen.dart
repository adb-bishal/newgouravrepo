import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
import '../../../model/utils/hex_color.dart';
import '../home/home_new_controller.dart';
import '../root_view/home_view/category_model.dart';
import '../../widgets/button_view/icon_button.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:stockpathshala_beta/model/models/home_data_model/home_data_model.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/progress_dialog.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:flutter/services.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quiz_list.dart';
import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../view/screens/root_view/live_classes_view/live_class_detail/live_class_webview.dart';
import 'package:intl/intl.dart';
import '../../screens/home/session_request_card.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:stockpathshala_beta/model/models/home_data_model/home_data_model.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/progress_dialog.dart';
import 'package:stockpathshala_beta/view_model/controllers/batch_controller/live_batch_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import 'package:stockpathshala_beta/view/screens/root_view/web_view/open_web_view.dart';
import 'package:stockpathshala_beta/model/utils/font_resource.dart';

class HomeScreen extends GetView<HomeNewController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   if (controller.scrollController.hasClients) {
    //     controller.scrollController.jumpTo(0);
    //   }
    //   controller.expansion.value = 1.0;
    //   controller.isTitleVisible.value = false;
    // });

    final screenWidth = MediaQuery.of(context).size.width;
    Get.put(HomeNewController());
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          statusBarIconBrightness: Brightness.light,
          statusBarColor: ColorResource.primaryColor,
        ),
        child: Scaffold(
          body: Obx(() {
            return Scaffold(
                backgroundColor: Colors.white,
                body: RefreshIndicator(
                    onRefresh: controller.onRefresh,
                    child: CustomScrollView(
                        controller: controller.scrollController,
                        slivers: [
                          SliverAppBar(
                            expandedHeight: screenWidth < 600 ? 250 : 280,
                            collapsedHeight: 45,
                            toolbarHeight: 45,
                            automaticallyImplyLeading: false,
                            titleSpacing: DimensionResource.marginSizeDefault,
                            centerTitle: true,
                            title: SizedBox(
                              height: 50,
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ActionCustomButton(
                                    onTap: () {
                                      Get.find<RootViewController>()
                                          .scaffoldKey
                                          .currentState
                                          ?.openDrawer();
                                    },
                                    icon: ImageResource.instance.drawerIcon,
                                    iconSize: screenWidth < 500 ? 14 : 20,
                                    isLeft: true,
                                  ),
                                  // Spacer(),
                                  Obx(() => AnimatedOpacity(
                                        opacity: controller.isTitleVisible.value
                                            ? 1.0
                                            : 0.0,
                                        duration:
                                            const Duration(milliseconds: 200),
                                        child: Text(
                                          'Choose Your Category',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            // Optional: make text take no space when hidden
                                            color:
                                                controller.isTitleVisible.value
                                                    ? Colors.white
                                                    : Colors.transparent,
                                          ),
                                        ),
                                      )),

                                  Obx(() {
                                    int? dotValue = controller
                                        .notificationCountData.value.count;
                                    return ActionCustomButton(
                                      onTap: () {
                                        if (!Get.find<AuthService>()
                                            .isGuestUser
                                            .value) {
                                          Get.toNamed(Routes.notificationView);
                                        } else {
                                          ProgressDialog()
                                              .showFlipDialog(isForPro: false);
                                        }
                                        controller.notificationCountData.value
                                            .count = 0;
                                        controller.isShow.value = false;
                                      },
                                      showGreenDot: dotValue != null &&
                                              controller.isShow.value
                                          ? controller.notificationCountData
                                                  .value.count !=
                                              0
                                          : false,
                                      iconSize: screenWidth < 500 ? 17 : 30,
                                      isLeft: false,
                                      greenDotValue: dotValue ?? 0,
                                      icon: ImageResource
                                          .instance.notificationIcon,
                                    );
                                  }),
                                ],
                              ),
                            ),
                            floating: false,
                            pinned: true,
                            backgroundColor: ColorResource.primaryColor,
                            elevation: 3,
                            flexibleSpace: FlexibleSpaceBar(
                              centerTitle: true,
                              title: controller.isTitleVisible.value
                                  ? Center(
                                      child: Text(
                                        "",
                                        style: TextStyle(
                                          fontSize: 14,
                                          // Optional: make text take no space when hidden
                                          color: controller.isTitleVisible.value
                                              ? Colors.white
                                              : Colors.transparent,
                                        ),
                                      ),
                                    )
                                  : Text(''),
                              collapseMode: CollapseMode.parallax,
                              background: Stack(
                                children: [
                                  Container(
                                    width: double.infinity,
                                    height: 305,
                                    color: ColorResource.white,
                                    child: Column(
                                      children: [
                                        controller.homeData.value.homepageUi
                                                    ?.bgImageUrl?.isEmpty ??
                                                true
                                            ? Image.asset(
                                                ImageResource.instance.homeBg,
                                                fit: BoxFit.cover,
                                                height: screenWidth < 500
                                                    ? 200
                                                    : 220,
                                                width: double.infinity,
                                              )
                                            : Image.network(
                                                controller.homeData.value
                                                    .homepageUi!.bgImageUrl!,
                                                fit: BoxFit.cover,
                                                height: screenWidth < 500
                                                    ? 200
                                                    : 220,
                                                width: double.infinity,
                                              )
                                      ],
                                    ),
                                  ),
                                  controller.bannerData.value.data != null
                                      ? Positioned(
                                          bottom: 0,
                                          left: 0,
                                          right: 0,
                                          child: Column(
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: screenWidth <
                                                            500
                                                        ? DimensionResource
                                                            .marginSizeDefault
                                                        : DimensionResource
                                                                .marginSizeLarge -
                                                            3),
                                                child: UserGreetingWidget(),
                                              ),
                                              SizedBox(
                                                height: screenWidth < 500
                                                    ? DimensionResource
                                                            .marginSizeSmall +
                                                        3
                                                    : DimensionResource
                                                            .marginSizeDefault -
                                                        15,
                                              ),
                                              Container(
                                                height: screenWidth < 500
                                                    ? 130
                                                    : 180,
                                                width: screenWidth < 500
                                                    ? double.infinity
                                                    : 700,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            15)),
                                                child: Stack(
                                                  fit: StackFit.expand,
                                                  children: [
                                                    Obx(() {
                                                      return controller
                                                                  .isLoading
                                                                  .value !=
                                                              true
                                                          ? CarouselSlider
                                                              .builder(
                                                              options:
                                                                  CarouselOptions(
                                                                aspectRatio: 1,
                                                                viewportFraction:
                                                                    1,
                                                                autoPlay: false,
                                                                enableInfiniteScroll:
                                                                    false, // No looping
                                                                scrollPhysics:
                                                                    NeverScrollableScrollPhysics(),
                                                                enlargeCenterPage:
                                                                    false,
                                                                disableCenter:
                                                                    false,
                                                                onPageChanged:
                                                                    (index,
                                                                        reason) {
                                                                  controller
                                                                      .setCurrentIndex(
                                                                          index);
                                                                },
                                                              ),
                                                              itemCount: controller
                                                                      .bannerData
                                                                      .value
                                                                      .data
                                                                      ?.length ??
                                                                  0,
                                                              itemBuilder:
                                                                  (context,
                                                                      index,
                                                                      _) {
                                                                DatumDatum dataAtIndex = controller
                                                                        .bannerData
                                                                        .value
                                                                        .data
                                                                        ?.elementAt(
                                                                            index) ??
                                                                    DatumDatum();
                                                                return InkWell(
                                                                  splashColor:
                                                                      Colors
                                                                          .transparent,
                                                                  // onTap: () {
                                                                  //   if (dataAtIndex
                                                                  //           .bannerType ==
                                                                  //       1) {
                                                                  //     switch (dataAtIndex
                                                                  //         .type) {
                                                                  //       case AppConstants
                                                                  //           .textCourse:
                                                                  //         Get.toNamed(
                                                                  //             Routes.textCourseDetail(id: dataAtIndex.bannerableId.toString()),
                                                                  //             arguments: [
                                                                  //               "",
                                                                  //               dataAtIndex.bannerableId.toString()
                                                                  //             ]);
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .audioCourse:
                                                                  //         Get.toNamed(
                                                                  //             Routes.audioCourseDetail(id: dataAtIndex.bannerableId.toString()),
                                                                  //             arguments: [
                                                                  //               CourseDetailViewType.audioCourse,
                                                                  //               dataAtIndex.bannerableId.toString(),
                                                                  //               "",
                                                                  //               ""
                                                                  //             ]);
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .counsellingCategories:
                                                                  //         Get.toNamed(
                                                                  //             Routes.mentorScreen,
                                                                  //             arguments: dataAtIndex.id);
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .counsellingPage:
                                                                  //         //     controller.scrollController.animateTo(
                                                                  //         // controller.scrollController.position.maxScrollExtent,
                                                                  //         // duration: Duration(milliseconds: 500),
                                                                  //         // curve: Curves.easeInOut);
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .audioRedirect:
                                                                  //         Get.toNamed(
                                                                  //             Routes.audioCourseDetail(id: dataAtIndex.bannerableId.toString()),
                                                                  //             arguments: [
                                                                  //               CourseDetailViewType.audio,
                                                                  //               dataAtIndex.bannerableId.toString(),
                                                                  //               "",
                                                                  //               ""
                                                                  //             ]);
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .videoRedirect:
                                                                  //         AppConstants
                                                                  //             .instance
                                                                  //             .singleCourseId
                                                                  //             .value = (dataAtIndex.bannerableId ??
                                                                  //                 "")
                                                                  //             .toString();
                                                                  //
                                                                  //         Get.toNamed(Routes.continueWatchScreen(id: dataAtIndex.bannerableId.toString()), arguments: [
                                                                  //           dataAtIndex.bannerableId.toString(),
                                                                  //           ""
                                                                  //         ])!
                                                                  //             .then((value) {
                                                                  //           Get.find<HomeController>().getContinueLearning(isFirst: true);
                                                                  //         });
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .liveClassBanner:
                                                                  //         AppConstants
                                                                  //             .instance
                                                                  //             .liveId
                                                                  //             .value = (dataAtIndex.bannerableId ??
                                                                  //                 "")
                                                                  //             .toString();
                                                                  //         Get.toNamed(
                                                                  //             Routes.liveClassDetail(id: dataAtIndex.bannerableId.toString()),
                                                                  //             arguments: [
                                                                  //               false,
                                                                  //               dataAtIndex.bannerableId.toString()
                                                                  //             ]);
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .batchClass:
                                                                  //         AppConstants
                                                                  //             .instance
                                                                  //             .batchId
                                                                  //             .value = (dataAtIndex.bannerableId ??
                                                                  //                 "")
                                                                  //             .toString();
                                                                  //
                                                                  //         Get.toNamed(
                                                                  //             Routes.batchClassDetails(id: dataAtIndex.bannerableId.toString()),
                                                                  //             arguments: [
                                                                  //               false,
                                                                  //               dataAtIndex.bannerableId.toString()
                                                                  //             ]);
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .upcomingBatch:
                                                                  //         final bannerableId =
                                                                  //             dataAtIndex.bannerableId;
                                                                  //         print(
                                                                  //             'Bannerable ID: $bannerableId');
                                                                  //
                                                                  //         if (bannerableId ==
                                                                  //             null) {
                                                                  //           print('Error: bannerableId is null.');
                                                                  //           return; // Exit early if `bannerableId` is null
                                                                  //         }
                                                                  //
                                                                  //         // Access the batch data from LiveBatchesController
                                                                  //         final displayList = Get.find<LiveBatchesController>()
                                                                  //             .batchData
                                                                  //             .value
                                                                  //             .data;
                                                                  //
                                                                  //         if (displayList == null ||
                                                                  //             displayList.isEmpty) {
                                                                  //           print('Error: No batch data available.');
                                                                  //           return; // Exit early if `displayList` is null or empty
                                                                  //         }
                                                                  //
                                                                  //         // Find the matching batch data based on the ID
                                                                  //         final matchingData =
                                                                  //             displayList.where((batchData) {
                                                                  //           return batchData.id.toString() ==
                                                                  //               bannerableId; // Ensure proper type comparison
                                                                  //         }).toList();
                                                                  //
                                                                  //         if (matchingData
                                                                  //             .isEmpty) {
                                                                  //           print('Error: No matching data found for bannerableId: $bannerableId');
                                                                  //           return; // Exit early if no matching data is found
                                                                  //         }
                                                                  //
                                                                  //         // Navigate to the batch details route with the matched data
                                                                  //         Get.toNamed(
                                                                  //           Routes.batchDetails,
                                                                  //           arguments: [
                                                                  //             matchingData.first, // Pass the first matched BatchData object
                                                                  //             false, // isPast flag
                                                                  //           ],
                                                                  //         );
                                                                  //
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .pastBatch:
                                                                  //         final bannerableId =
                                                                  //             dataAtIndex.bannerableId;
                                                                  //         print(
                                                                  //             'Bannerable ID: $bannerableId');
                                                                  //
                                                                  //         if (bannerableId ==
                                                                  //             null) {
                                                                  //           print('Error: bannerableId is null.');
                                                                  //           return; // Exit early if `bannerableId` is null
                                                                  //         }
                                                                  //
                                                                  //         // Access the batch data from PastClassesController
                                                                  //         final displayList = Get.find<PastClassesController>()
                                                                  //             .batchData
                                                                  //             .value
                                                                  //             .data;
                                                                  //
                                                                  //         if (displayList == null ||
                                                                  //             displayList.isEmpty) {
                                                                  //           print('Error: No batch data available.');
                                                                  //           return; // Exit early if `displayList` is null or empty
                                                                  //         }
                                                                  //
                                                                  //         // Find the matching batch data based on the ID
                                                                  //         final matchingData =
                                                                  //             displayList.where((batchData) {
                                                                  //           return batchData.id.toString() ==
                                                                  //               bannerableId; // Ensure proper type comparison
                                                                  //         }).toList();
                                                                  //
                                                                  //         if (matchingData
                                                                  //             .isEmpty) {
                                                                  //           print('Error: No matching data found for bannerableId: $bannerableId');
                                                                  //           return; // Exit early if no matching data is found
                                                                  //         }
                                                                  //
                                                                  //         // Navigate to the batch details route with the matched data
                                                                  //         Get.toNamed(
                                                                  //           Routes.batchDetails,
                                                                  //           arguments: [
                                                                  //             matchingData.first, // Pass the first matched BatchData object
                                                                  //             true, // isPast flag
                                                                  //           ],
                                                                  //         );
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .upcomingLiveClass:
                                                                  //         if (dataAtIndex.bannerableId !=
                                                                  //             null) {
                                                                  //           AppConstants.instance.batchId.value =
                                                                  //               (dataAtIndex.bannerableId.toString())!;
                                                                  //           Get.toNamed(Routes.batchClassDetails(id: dataAtIndex.bannerableId.toString()), arguments: [
                                                                  //             false,
                                                                  //             dataAtIndex.bannerableId.toString()
                                                                  //           ]);
                                                                  //         } else {
                                                                  //           AppConstants.instance.liveId.value =
                                                                  //               (dataAtIndex.bannerableId.toString())!;
                                                                  //           Get.toNamed(Routes.liveClassDetail(id: dataAtIndex.bannerableId.toString()), arguments: [
                                                                  //             false,
                                                                  //             dataAtIndex.bannerableId.toString()
                                                                  //           ]);
                                                                  //         }
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .pastLiveClass:
                                                                  //         if (dataAtIndex.bannerableId !=
                                                                  //             null) {
                                                                  //           AppConstants.instance.liveId.value =
                                                                  //               (dataAtIndex.bannerableId.toString());
                                                                  //           Get.toNamed(Routes.liveClassDetail(id: dataAtIndex.bannerableId.toString()), arguments: [
                                                                  //             true,
                                                                  //             dataAtIndex.bannerableId.toString()
                                                                  //           ]);
                                                                  //         } else {
                                                                  //           AppConstants.instance.liveId.value =
                                                                  //               (dataAtIndex.bannerableId.toString())!;
                                                                  //           Get.toNamed(Routes.liveClassDetail(id: dataAtIndex.bannerableId.toString()), arguments: [
                                                                  //             false,
                                                                  //             dataAtIndex.bannerableId.toString()
                                                                  //           ]);
                                                                  //         }
                                                                  //         break;
                                                                  //
                                                                  //       case AppConstants
                                                                  //           .blogRedirect:
                                                                  //         AppConstants
                                                                  //             .instance
                                                                  //             .blogId
                                                                  //             .value = (dataAtIndex.bannerableId ??
                                                                  //                 "")
                                                                  //             .toString();
                                                                  //
                                                                  //         Get.toNamed(
                                                                  //             Routes.blogsView(id: dataAtIndex.bannerableId.toString()),
                                                                  //             arguments: [
                                                                  //               dataAtIndex.bannerableId.toString(),
                                                                  //               ""
                                                                  //             ]);
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .quizRedirect:
                                                                  //         Get.toNamed(
                                                                  //             Routes.quizMainView,
                                                                  //             arguments: {
                                                                  //               "id": dataAtIndex.bannerableId.toString(),
                                                                  //               "??": "",
                                                                  //               "quiz_type": dataAtIndex.isScholarship == 1 ? QuizType.scholarship : QuizType.free,
                                                                  //               "is_timeup": false,
                                                                  //               "is_fromHome": true
                                                                  //             });
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .subscription:
                                                                  //         if (Platform
                                                                  //             .isAndroid) {
                                                                  //           Get.toNamed(Routes.subscriptionView);
                                                                  //         }
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .upcomingBatchClass:
                                                                  //         Get.find<RootViewController>()
                                                                  //             .selectedTab
                                                                  //             .value = 2;
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .pastBatchPage:
                                                                  //         Get.find<LiveBatchesController>()
                                                                  //             .isTabValueChange
                                                                  //             .value = true;
                                                                  //
                                                                  //         Get.find<RootViewController>()
                                                                  //             .selectedTab
                                                                  //             .value = 2;
                                                                  //         Get.find<LiveBatchesController>()
                                                                  //             .tabChange();
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .mentorshipClass:
                                                                  //         Get.toNamed(
                                                                  //           Routes.mentorshipDetail(
                                                                  //             id: dataAtIndex.bannerableId.toString(),
                                                                  //           ),
                                                                  //           arguments: {
                                                                  //             'id': dataAtIndex.bannerableId.toString(),
                                                                  //           },
                                                                  //         );
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .upcomingWebinarPage:
                                                                  //         Get.find<RootViewController>()
                                                                  //             .selectedTab
                                                                  //             .value = 3;
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .pastWebinarPage:
                                                                  //         Get.find<LiveClassesController>()
                                                                  //             .isTabValueChange
                                                                  //             .value = true;
                                                                  //
                                                                  //         Get.find<RootViewController>()
                                                                  //             .selectedTab
                                                                  //             .value = 3;
                                                                  //         Get.find<LiveClassesController>()
                                                                  //             .tabChange();
                                                                  //         Get.find<PastClassesController>()
                                                                  //             .onRefresh();
                                                                  //         break;
                                                                  //       case AppConstants
                                                                  //           .mentorshipPage:
                                                                  //         Get.find<RootViewController>()
                                                                  //             .selectedTab
                                                                  //             .value = 1;
                                                                  //         break;
                                                                  //
                                                                  //       default:
                                                                  //         AppConstants
                                                                  //             .instance
                                                                  //             .videoCourseId
                                                                  //             .value = (dataAtIndex.bannerableId ??
                                                                  //                 "")
                                                                  //             .toString();
                                                                  //         Get.toNamed(
                                                                  //             Routes.videoCourseDetail(id: dataAtIndex.bannerableId.toString()),
                                                                  //             arguments: [
                                                                  //               "",
                                                                  //               dataAtIndex.bannerableId.toString()
                                                                  //             ]);
                                                                  //         break;
                                                                  //     }
                                                                  //   } else {
                                                                  //     if (dataAtIndex
                                                                  //             .url !=
                                                                  //         null) {
                                                                  //       Navigator.of(Get.context!).push(MaterialPageRoute(
                                                                  //           builder: (context) =>
                                                                  //               OpenWebView(url: dataAtIndex.url ?? "", title: dataAtIndex.title ?? "")));
                                                                  //     }
                                                                  //   }
                                                                  // },
                                                                  child: Container(
                                                                      padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
                                                                      width: double.infinity,
                                                                      child: ClipRRect(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                        child:
                                                                            Stack(
                                                                          children: [
                                                                            Positioned(
                                                                              top: 0,
                                                                              bottom: 0,
                                                                              left: 0,
                                                                              right: 0,
                                                                              child: cachedNetworkImage(dataAtIndex.image ?? "", fit: BoxFit.fill),
                                                                            ),
                                                                            // Align(
                                                                            //   alignment: Alignment.bottomLeft,
                                                                            //   child: Container(
                                                                            //     margin: const EdgeInsets.only(
                                                                            //       bottom: DimensionResource.marginSizeDefault + 10,
                                                                            //       left: DimensionResource.marginSizeDefault,
                                                                            //       right: DimensionResource.marginSizeDefault,
                                                                            //     ),
                                                                            //     decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: ColorResource.white),
                                                                            //     padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                                            //     child: Text(
                                                                            //       dataAtIndex.title ?? "",
                                                                            //       style: StyleResource.instance.styleLight(fontSize: screenWidth < 500 ? DimensionResource.fontSizeExtraSmall : DimensionResource.fontSizeDefault),
                                                                            //       maxLines: 1,
                                                                            //       overflow: TextOverflow.ellipsis,
                                                                            //     ),
                                                                            //   ),
                                                                            // ),
                                                                            Visibility(
                                                                              visible: dataAtIndex.isPromotional != null && dataAtIndex.isPromotional == 1,
                                                                              child: Align(
                                                                                alignment: Alignment.topLeft,
                                                                                child: Container(
                                                                                  margin: const EdgeInsets.only(
                                                                                    top: DimensionResource.marginSizeDefault,
                                                                                    left: DimensionResource.marginSizeDefault,
                                                                                    right: DimensionResource.marginSizeDefault,
                                                                                  ),
                                                                                  decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: ColorResource.white),
                                                                                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                                                                                  child: Text(
                                                                                    "Promotional",
                                                                                    style: StyleResource.instance.styleLight(fontSize: DimensionResource.fontSizeExtraSmall - 2),
                                                                                    maxLines: 1,
                                                                                    overflow: TextOverflow.ellipsis,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      )),
                                                                );
                                                              },
                                                            )
                                                          : Padding(
                                                              padding: EdgeInsets.symmetric(
                                                                  horizontal: screenWidth <
                                                                          500
                                                                      ? DimensionResource
                                                                          .marginSizeDefault
                                                                      : DimensionResource
                                                                          .marginSizeLarge),
                                                              child: ShimmerEffect
                                                                  .instance
                                                                  .imageLoader(
                                                                      color: ColorResource
                                                                          .white),
                                                            );
                                                    }),
                                                    // Align(
                                                    //   alignment: Alignment
                                                    //       .bottomCenter,
                                                    //   child: Obx(() => Padding(
                                                    //         padding:
                                                    //             const EdgeInsets
                                                    //                 .only(
                                                    //                 bottom: 10),
                                                    //         child: Row(
                                                    //             mainAxisSize:
                                                    //                 MainAxisSize
                                                    //                     .min,
                                                    //             mainAxisAlignment:
                                                    //                 MainAxisAlignment
                                                    //                     .center,
                                                    //             children: List.generate(
                                                    //                 controller
                                                    //                         .bannerData
                                                    //                         .value
                                                    //                         .data
                                                    //                         ?.length ??
                                                    //                     controller
                                                    //                         .dummyImages
                                                    //                         .length,
                                                    //                 (index) {
                                                    //               return AnimatedContainer(
                                                    //                 margin: const EdgeInsets
                                                    //                     .symmetric(
                                                    //                     horizontal:
                                                    //                         2),
                                                    //                 duration: const Duration(
                                                    //                     milliseconds:
                                                    //                         300),
                                                    //                 height: controller.currentIndex.value ==
                                                    //                         index
                                                    //                     ? 10
                                                    //                     : 7,
                                                    //                 width: controller.currentIndex.value ==
                                                    //                         index
                                                    //                     ? 10
                                                    //                     : 7,
                                                    //                 decoration:
                                                    //                     BoxDecoration(
                                                    //                   borderRadius:
                                                    //                       BorderRadius.circular(
                                                    //                           15),
                                                    //                   color: controller.currentIndex.value ==
                                                    //                           index
                                                    //                       ? ColorResource
                                                    //                           .yellowColor
                                                    //                       : ColorResource
                                                    //                           .white,
                                                    //                 ),
                                                    //               );
                                                    //             })),
                                                    //       )),
                                                    // ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : const SizedBox.shrink(),
                                ],
                              ),
                            ),
                          ),
                          SliverList(
                            delegate: SliverChildListDelegate([
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 16.0, top: 24, bottom: 24, right: 16),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    controller.categoriesData.value
                                                    .waitedCounselling !=
                                                null &&
                                            controller.categoriesData.value
                                                .waitedCounselling!.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap:
                                                true, // so it doesn’t take infinite height
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(), // let parent scroll
                                            itemCount: controller
                                                .categoriesData
                                                .value
                                                .waitedCounselling!
                                                .length,
                                            itemBuilder: (context, index) {
                                              final counselling = controller
                                                  .categoriesData
                                                  .value
                                                  .waitedCounselling![index];

                                              return controller
                                                          .categoriesData
                                                          .value
                                                          .waitedCounselling?[
                                                              index]
                                                          .status !=
                                                      "approved"
                                                  ? SessionRequestCard(
                                                      userName: Get.find<
                                                              AuthService>()
                                                          .user
                                                          .value
                                                          .name
                                                          .toString()
                                                          .capitalize!,
                                                      controller: controller)
                                                  : const SizedBox.shrink();
                                            },
                                          )
                                        : const SizedBox.shrink(),

                                    controller.categoriesData.value
                                            .bookedCounselling.isNotEmpty
                                        ? ListView.builder(
                                            shrinkWrap: true,
                                            padding: EdgeInsets.zero,
                                            physics:
                                                const NeverScrollableScrollPhysics(),
                                            itemCount: controller.categoriesData
                                                .value.bookedCounselling.length,
                                            itemBuilder: (context, index) {
                                              final session = controller
                                                  .categoriesData
                                                  .value
                                                  .bookedCounselling[index];
                                              final item = session;

                                              double screenWidth =
                                                  MediaQuery.of(context)
                                                      .size
                                                      .width;
                                              double tileWidth =
                                                  screenWidth < 500
                                                      ? screenWidth - 20
                                                      : screenWidth / 2 - 20;

                                              return SizedBox(
                                                width: tileWidth,
                                                child: bookedCounsellingView(
                                                  index,
                                                  fontSize: DimensionResource
                                                          .marginSizeSmall +
                                                      3,
                                                  data: controller
                                                      .categoriesData
                                                      .value
                                                      .bookedCounselling[index],
                                                  serverTime: controller
                                                      .categoriesData
                                                      .value
                                                      .serverTime,
                                                  liveClassesController:
                                                      controller,
                                                  onItemTap: (data) {},
                                                ),
                                              );
                                            },
                                          )
                                        : const SizedBox.shrink(),
                                    // SizedBox(
                                    //     height: controller.categoriesData.value
                                    //             .bookedCounselling.isEmpty
                                    //         ? 10
                                    //         : 20),
                                    const Padding(
                                      padding: EdgeInsets.only(top: 8.0),
                                      child: Text(
                                        'Personalised Counselling Sessions',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    const Text(
                                      'Learn, trade, and grow with expert-guided sessions',
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.black45,
                                          fontWeight: FontWeight.w400),
                                    ),
                                    // SizedBox(height: 4),
                                    // Text(
                                    //   'Choose your subjects & get expert guidance',
                                    //   style: TextStyle(
                                    //       fontSize: 12, color: Colors.black54),
                                    // ),
                                    // SizedBox(height: 16),
                                    // categoryChip(controller,controller.categoriesData.value.categories ?? []),
                                  ],
                                ),
                              ),
                              categoryList(
                                  controller, controller.categoriesData.value)
                            ]),
                          ),
                        ])));
          }),
        ));
  }
}

Widget bookedCounsellingView(
  int index, {
  double fontSize = DimensionResource.fontSizeExtraSmall - 2,
  bool isPast = false,
  Function(CommonDatum data)? onItemTap,
  required BookedCounselling data,
  required HomeNewController liveClassesController,
  String? serverTime,
}) {
  DateTime serverDateTime = DateTime.parse(
      liveClassesController.categoriesData.value.serverTime.toString());
  final ui = liveClassesController.categoriesData.value.ui;
  // final data = liveClassesController.categoriesData.value;
  var time = timeDifferenceInSeconds(
    data.startDateTime.toString(),
    serverTime ?? DateTime.now().toString(),
  );

  //session confirmed

  return InkWell(
    child: Card(
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexToColor(ui.counsellingBookingSessionConfirmCardBgColor1),
          hexToColor(ui.counsellingBookingSessionConfirmCardBgColor2),
        ], begin: Alignment.bottomCenter, end: AlignmentGeometry.topCenter)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
              child: Container(
                width: double.infinity,
                color: ui.counsellingBookingSessionConfirmBgColor != null
                    ? HexColor(ui.counsellingBookingSessionConfirmBgColor!)
                    : Colors.green.withOpacity(0.05),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(42),
                          child: Container(
                            width:
                                MediaQuery.of(Get.context!).size.width * 0.12,
                            height:
                                MediaQuery.of(Get.context!).size.width * 0.12,
                            color: ColorResource.primaryColor,
                            child: data.mentor.imageUrl != null
                                ? Image.network(
                                    data.mentor.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            const Icon(Icons.error, size: 14),
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return const Center(
                                        child: SizedBox(
                                          width: 12,
                                          height: 12,
                                          child: CircularProgressIndicator(
                                              strokeWidth: 2),
                                        ),
                                      );
                                    },
                                  )
                                : const Icon(Icons.person, size: 14),
                          ),
                        ),
                        // ui.counsellingBookingSessionConfirm1Icon != null
                        //     ? Padding(
                        //   padding: const EdgeInsets.all(4.0),
                        //   child: Image.network(
                        //     ui.counsellingBookingSessionConfirm1Icon ?? '',
                        //     width:
                        //     MediaQuery.of(Get.context!).size.width * 0.1,
                        //     height:
                        //     MediaQuery.of(Get.context!).size.width * 0.1,
                        //   ),
                        // )
                        //     : const SizedBox.shrink(),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                ui.counsellingBookingSessionConfirmHeroTitle ??
                                    '',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: ui.counsellingBookingSessionConfirmHeroTitleColor !=
                                          null
                                      ? HexColor(ui
                                          .counsellingBookingSessionConfirmHeroTitleColor!)
                                      : ColorResource.greenDarkColor,
                                ),
                              ),
                              Text(
                                'With ${data.mentor.name}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                                softWrap: true,
                              ),
                              SizedBox(
                                height: 6,
                              ),
                              IntrinsicHeight(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(
                                          size: 18,
                                          Icons.calendar_month,
                                          color: ColorResource.black,
                                        ),
                                        const SizedBox(width: 8),
                                        Text(
                                          DateFormat('dd MMM yyyy')
                                              .format(data.startDateTime),
                                          style: const TextStyle(
                                            fontSize: 14,
                                            // fontWeight: FontWeight.w600,
                                            color: Colors.black,
                                          ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                    const VerticalDivider(
                                      width: 0.5,
                                      thickness: 0.3,
                                      color: Colors.grey,
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      size: 18,
                                      Icons.watch_later_outlined,
                                      color: ColorResource.black,
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      DateFormat('hh:mm a')
                                          .format(data.startDateTime),
                                      style: const TextStyle(
                                        fontSize: 14,
                                        // fontWeight: FontWeight.w600,
                                        color: Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              // const SizedBox(height: 4),
                              // RatingBarIndicator(
                              //   rating: data.mentor.ratings,
                              //   itemCount: 5,
                              //   itemSize: 12,
                              //   direction: Axis.horizontal,
                              //   itemBuilder: (context, index) => const Icon(
                              //     Icons.star,
                              //     color: Colors.amber,
                              //   ),
                              // ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            // const SizedBox(height: 16),
            Column(
              children: [
                // RichText(
                //   text: TextSpan(
                //     text: (liveClassesController.textParts.isNotEmpty
                //             ? liveClassesController.textParts[0]
                //             : '') ??
                //         '',
                //     style: TextStyle(
                //       color: hexToColor(
                //           ui.counsellingBookingSessionConfirmTitleColor ??
                //               "#000000"),
                //       fontSize: 13,
                //       fontFamily: FontResource.instance.mainFont,
                //     ),
                //     children: [
                //       TextSpan(
                //         text: (liveClassesController.placeholders.isNotEmpty
                //                 ? liveClassesController.placeholders[0]
                //                     .replaceAll(
                //                       liveClassesController.placeholders[0],
                //                       "${data.mentor.name.replaceAll('<br>', '\n') ?? ''} ",
                //                     )
                //                     .replaceAll('<br>', '\n')
                //                 : '') ??
                //             '',
                //         style: TextStyle(
                //           letterSpacing: 0.3,
                //           color: hexToColor(
                //               ui.counsellingBookingSessionConfirmTitleColor ??
                //                   "#000000"),
                //           fontSize: 13,
                //           fontFamily: FontResource.instance.mainFont,
                //           fontWeight: FontWeight.bold,
                //         ),
                //       ),
                //       TextSpan(
                //         text: (liveClassesController.textParts.length > 1
                //                 ? liveClassesController.textParts[1]
                //                     .replaceAll('<br>', '\n')
                //                 : '') ??
                //             '',
                //         style: TextStyle(
                //           color: hexToColor(
                //               ui.counsellingBookingSessionConfirmTitleColor ??
                //                   "#000000"),
                //           fontSize: 13,
                //           letterSpacing: 0.3,
                //           fontFamily: FontResource.instance.mainFont,
                //         ),
                //       ),
                //       // TextSpan(
                //       //   text: "${data.mentor.name.replaceAll('<br>', '\n') ?? ''} ",
                //       //   style: TextStyle(
                //       //     letterSpacing: 0.3,
                //       //     color: hexToColor(
                //       //         ui.counsellingBookingSessionConfirmTitleColor ?? "#000000"),
                //       //     fontSize: 13,
                //       //     fontFamily: FontResource.instance.mainFont,
                //       //     fontWeight: FontWeight.bold,
                //       //   ),
                //       // ),
                //       // TextSpan(
                //       //   text: (liveClassesController.textParts.length > 2
                //       //       ? liveClassesController.textParts[2]
                //       //       : 'is scheduled:'),
                //       //   style: TextStyle(
                //       //     color: hexToColor(
                //       //         ui.counsellingBookingSessionConfirmTitleColor ?? "#000000"),
                //       //     fontSize: 13,
                //       //     letterSpacing: 0.3,
                //       //     fontFamily: FontResource.instance.mainFont,
                //       //   ),
                //       // ),
                //     ],
                //   ),
                // ),
                // const SizedBox(height: 16),
                // Container(height: 0.1,color: Colors.grey,),

                // const SizedBox(height: 4),
                // Row(
                //   children: [
                //     const Text(
                //       '👉',
                //       style: TextStyle(fontSize: 20),
                //     ),
                //     const SizedBox(width: 8),
                //     Expanded(
                //       child: Text(
                //         liveClassesController.categoriesData.value.ui
                //                 .counsellingBookingSessionConfirmHeroPrepareTitle ??
                //             'Things to prepare:',
                //         style: TextStyle(
                //           fontSize: 14,
                //           fontWeight: FontWeight.bold,
                //           color: hexToColor(
                //             liveClassesController.categoriesData.value.ui
                //                     .counsellingBookingSessionConfirmHeroPrepareTitleColor ??
                //                 '#000000',
                //           ),
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 4),
                // ...List.generate(
                //   liveClassesController.categoriesData.value.ui
                //           .counsellingBookingThinkToPrepareTitle?.length ??
                //       0,
                //   (index) {
                //     var text = liveClassesController.categoriesData.value.ui
                //         .counsellingBookingThinkToPrepareTitle?[index];
                //
                //     if (text == null) return const SizedBox.shrink();
                //
                //     return Column(
                //       crossAxisAlignment: CrossAxisAlignment.start,
                //       children: [
                //         Row(
                //           crossAxisAlignment: CrossAxisAlignment.start,
                //           children: [
                //             Padding(
                //               padding:
                //                   const EdgeInsets.symmetric(vertical: 4.0),
                //               child: Image.asset(
                //                 ImageResource.instance.mentorCheckIcon,
                //                 width: 14,
                //                 height: 14,
                //                 color: ColorResource.grey_4,
                //               ),
                //             ),
                //             const SizedBox(width: 10),
                //             Expanded(
                //               child: Text(
                //                 text,
                //                 maxLines: 2,
                //                 textAlign: TextAlign.start,
                //                 overflow: TextOverflow.ellipsis,
                //                 style: const TextStyle(fontSize: 13),
                //               ),
                //             ),
                //           ],
                //         ),
                //         const SizedBox(height: 4),
                //       ],
                //     );
                //   },
                // ),
                // const SizedBox(height: 24),
                // Row(
                //   crossAxisAlignment: CrossAxisAlignment.start,
                //   children: [
                //     const SizedBox(width: 8),
                //     // Avatar
                //     ClipRRect(
                //       borderRadius: BorderRadius.circular(42),
                //       child: Container(
                //         width: MediaQuery.of(Get.context!).size.width * 0.1,
                //         height: MediaQuery.of(Get.context!).size.width * 0.1,
                //         color: ColorResource.primaryColor,
                //         child: data.mentor.imageUrl != null
                //             ? Image.network(
                //                 data.mentor.imageUrl!,
                //                 fit: BoxFit.cover,
                //                 errorBuilder: (context, error, stackTrace) =>
                //                     const Icon(Icons.error, size: 14),
                //                 loadingBuilder:
                //                     (context, child, loadingProgress) {
                //                   if (loadingProgress == null) return child;
                //                   return const Center(
                //                     child: SizedBox(
                //                       width: 12,
                //                       height: 12,
                //                       child: CircularProgressIndicator(
                //                           strokeWidth: 2),
                //                     ),
                //                   );
                //                 },
                //               )
                //             : const Icon(Icons.person, size: 14),
                //       ),
                //     ),
                //     const SizedBox(width: 12),
                //     Expanded(
                //       child: Column(
                //         crossAxisAlignment: CrossAxisAlignment.start,
                //         children: [
                //           Text(
                //             data.mentor.name,
                //             style: const TextStyle(
                //               fontSize: 13,
                //               fontWeight: FontWeight.w600,
                //             ),
                //             softWrap: true,
                //           ),
                //           const SizedBox(height: 4),
                //           RatingBarIndicator(
                //             rating: data.mentor.ratings,
                //             itemCount: 5,
                //             itemSize: 12,
                //             direction: Axis.horizontal,
                //             itemBuilder: (context, index) => const Icon(
                //               Icons.star,
                //               color: Colors.amber,
                //             ),
                //           ),
                //         ],
                //       ),
                //     ),
                //   ],
                // ),
                // const SizedBox(height: 8),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 8.0,vertical: 16),
                //   child: Container(
                //     width: double.infinity,
                //     padding: const EdgeInsets.symmetric(
                //         vertical: 4, horizontal: 12),
                //     decoration: BoxDecoration(
                //       color: time <= 0
                //           ? hexToColor(
                //               ui.bookedCounsellingSessionJoinButtonBgColor)
                //           : ColorResource.accentYellowColor,
                //     ),
                //     child: Center(
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: time <= 0
                //               ? hexToColor(ui
                //                   .bookedCounsellingSessionJoinButtonBgColor)
                //               : ColorResource.black,
                //           borderRadius: const BorderRadius.only(
                //             topRight: Radius.circular(5),
                //             topLeft: Radius.circular(5),
                //           ),
                //         ),
                //         padding: const EdgeInsets.symmetric(vertical: 3),
                //         child: Container(
                //           padding: const EdgeInsets.symmetric(
                //               vertical: 6, horizontal: 12),
                //           decoration: BoxDecoration(
                //             color: time <= 0
                //                 ? hexToColor(ui
                //                     .bookedCounsellingSessionJoinButtonBgColor)
                //                 : ColorResource.accentYellowColor,
                //             borderRadius: const BorderRadius.only(
                //               topRight: Radius.circular(5),
                //               topLeft: Radius.circular(5),
                //             ),
                //           ),
                //           child: time <= 0
                //               ? GestureDetector(
                //                   onTap: () {
                //                     if (data.participantLink != null) {
                //                       Navigator.push(
                //                         Get.context!,
                //                         MaterialPageRoute(
                //                           builder: (context) =>
                //                               LiveClassLaunch(
                //                             title: data.mentor.expertise
                //                                     .title ??
                //                                 '',
                //                             url: data.participantLink!,
                //                           ),
                //                         ),
                //                       );
                //                     }
                //                   },
                //                   child: SizedBox(
                //                     width: 100,
                //                     child: Row(
                //                       mainAxisAlignment:
                //                           MainAxisAlignment.center,
                //                       children: [
                //                         const Icon(
                //                           Icons.play_circle_outline_rounded,
                //                           color: Colors.white,
                //                           size: 16,
                //                         ),
                //                         const SizedBox(width: 6),
                //                         Text(
                //                           'Join Now',
                //                           style: TextStyle(
                //                             fontWeight: FontWeight.w600,
                //                             fontSize: 14,
                //                             color: hexToColor(
                //                               ui.bookedCounsellingSessionJoinButtonTextColor,
                //                             ),
                //                           ),
                //                         ),
                //                       ],
                //                     ),
                //                   ),
                //                 )
                //               : TimerCountDown(
                //                   isHrShow: false,
                //                   isHrs: true,
                //                   timeInSeconds: time,
                //                   fontStyle: StyleResource.instance.styleBold(
                //                     fontSize: 18,
                //                     fontWeight: FontWeight.w600,
                //                     color: Colors.black,
                //                   ),
                //                   remainingSeconds: (second) {
                //                     if (second <= 120) {
                //                       EasyDebounce.debounce(
                //                         data.id.toString() ?? 'default',
                //                         const Duration(seconds: 1),
                //                         () {
                //                           // Trigger your action
                //                         },
                //                       );
                //                     }
                //                   },
                //                 ),
                //         ),
                //       ),
                //     ),
                //   ),
                // ),
                // SizedBox(height: time > 0 ? 8 : 0),
                if (time <= 0)
                  // if (time > 0)
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8.0, vertical: 8),
                    child: GestureDetector(
                      onTap: () {
                        if (data.participantLink != null) {
                          Navigator.push(
                            Get.context!,
                            MaterialPageRoute(
                              builder: (context) => LiveClassLaunch(
                                title: data.mentor.expertise.title ?? '',
                                url: data.participantLink,
                              ),
                            ),
                          );
                        }
                      },
                      child: Container(
                        width: MediaQuery.of(Get.context!).size.width * 0.5,
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          color: hexToColor(
                              ui.bookedCounsellingSessionJoinButtonBgColor),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.play_circle_outline_rounded,
                              color: Colors.white,
                              size: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Join Now',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: hexToColor(ui
                                    .bookedCounsellingSessionJoinButtonTextColor),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                else
                  const SizedBox() // 👈 Renders nothing when condition is false
              ],
            ),
          ],
        ),
      ),
    ),
  );
}

int timeDifferenceInSeconds(String startTimeString, String serverTimeString) {
  final DateTime startTime = DateTime.parse(startTimeString);
  final DateTime serverTime = DateTime.parse(serverTimeString);
  final diff = startTime.difference(serverTime);
  return diff.isNegative ? 0 : diff.inSeconds;
}

Widget categoryChip(
    HomeNewController controller, List<CounsellingCategory> list) {
  return SizedBox(
    height: 30,
    child: ListView.builder(
      scrollDirection: Axis.horizontal,
      itemCount: list.length,
      itemBuilder: (context, index) {
        return Column(
          children: [
            InkWell(
              onTap: () {
                if (controller.selectedChip.contains(list[index].id)) {
                  controller.selectedChip.remove(list[index].id);
                } else {
                  controller.selectedChip.add(list[index].id);
                }
                if (controller.selectedChip.isEmpty) {
                  controller.filteredCategoriesData.value =
                      controller.categoriesData.value;
                } else {
                  final filteredMentors = controller
                      .categoriesData.value.mentors
                      .where((item) =>
                          controller.selectedChip.contains(item.experienceId))
                      .toList();
                  controller.filteredCategoriesData.value = CounsellingData(
                    totalMentors: filteredMentors.length,
                    mentors: filteredMentors,
                    categories: controller.categoriesData.value.categories,
                    ui: controller.categoriesData.value.ui,
                    serverTime: controller.categoriesData.value.serverTime,
                    bookedCounselling: [],
                    counsellingPrice: 0,
                  );
                }
              },
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                margin: const EdgeInsets.only(right: 8.0),
                decoration: BoxDecoration(
                    color: controller.selectedChip.contains(list[index].id)
                        ? Colors.grey.shade200
                        : Colors.white,
                    border: Border.all(
                        color: Colors.black.withOpacity(0.2), width: 0.4),
                    borderRadius: BorderRadius.circular(10)),
                child: Text(
                  list[index].title ?? "fr",
                  style: const TextStyle(fontSize: 10),
                ),
              ),
            ),
            const SizedBox(
              width: 8,
            )
          ],
        );
      },
    ),
  );
}

/*
Widget categoryList(
    HomeNewController controller, CounsellingData counsellingData) {
  return Obx(() => controller.isDataLoading.value
      ? MediaQuery.of(Get.context!).size.width < 600
      ? ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForMobile()
      : ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForTab()
      : counsellingData.categories.isEmpty
      ? const Center(
    child: Padding(
      padding: EdgeInsets.all(24.0),
      child: Text("No category found"),
    ),
  )
      :
  GridView.builder(
    shrinkWrap: true,
    physics: const NeverScrollableScrollPhysics(),
    padding: const EdgeInsets.symmetric(horizontal: 12),
    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
      crossAxisCount: 2,
      crossAxisSpacing: 12.0,
      mainAxisSpacing: 12.0,
      childAspectRatio: 0.85,
    ),
    itemCount: counsellingData.categories.length,
    itemBuilder: (context, index) {
      var data = counsellingData.categories[index];
      return GestureDetector(
        onTap: () {
          Get.toNamed(Routes.mentorScreen,
              arguments: counsellingData.categories[index]);
        },
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey.shade200),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Image at the top
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(8.0),
                    child: Image.network(
                      data.imageUrl,
                      width: double.infinity,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(
                            width: double.infinity,
                            color: Colors.grey.shade200,
                            child: const Icon(
                              Icons.category,
                              color: Colors.grey,
                              size: 30,
                            ),
                          ),
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          width: double.infinity,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(
                              strokeWidth: 2),
                        );
                      },
                    ),
                  ),
                ),

                const SizedBox(height: 8),

                // Title
                Expanded(
                  flex: 1,
                  child: Column(
                    children: [
                      Text(
                        data.title,
                        style: const TextStyle(
                          fontSize: 12,
                          color: ColorResource.lightSecondaryColor,
                          fontWeight: FontWeight.w600,
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const Spacer(),
                      // Arrow icon like in the image
                      const Icon(
                        Icons.arrow_forward_ios,
                        size: 12,
                        color: Color(0xFF4854FE),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  ));
}*/
Widget categoryList1(
    HomeNewController controller, CounsellingData counsellingData) {
  return Obx(() => controller.isDataLoading.value
      ? MediaQuery.of(Get.context!).size.width < 600
          ? ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForMobile()
          : ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForTab()
      : counsellingData.categories.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(24.0),
                child: Text("No category found"),
              ),
            )
          : ListView.builder(
              // controller: controller.scrollController,
              itemCount: counsellingData.categories.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                var data = counsellingData.categories[index];
                return GestureDetector(
                  onTap: () {
                    Get.toNamed(Routes.mentorScreen,
                            arguments: counsellingData.categories[index])
                        ?.then((value) {
                      if (value == 'payment') {
                        controller.onRefresh();
                      }
                    });
                  },
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 12, top: 0, right: 12, bottom: 12),
                    child: Container(
                      margin: EdgeInsets.only(bottom: 12),
                      constraints: BoxConstraints(
                          minHeight: MediaQuery.of(context).size.height * 0.15),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade200),
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 6,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: IntrinsicHeight(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Image
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Card(
                                color: Colors.white,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(8.0),
                                  child: Image.network(
                                    data.imageUrl,
                                    height: 90.0,
                                    width: 90.0,
                                    fit: BoxFit.contain,
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Container(
                                      height: 90.0,
                                      width: 90.0,
                                      color: Colors.grey.shade200,
                                      child: const Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: 40,
                                      ),
                                    ),
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                      if (loadingProgress == null) return child;
                                      return Container(
                                        height: 90.0,
                                        width: 90.0,
                                        alignment: Alignment.center,
                                        child: const CircularProgressIndicator(
                                            strokeWidth: 2),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),

                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      data.title,
                                      style: const TextStyle(
                                          fontSize: 15,
                                          color:
                                              ColorResource.lightSecondaryColor,
                                          fontWeight: FontWeight.w600),
                                    ),
                                    const SizedBox(height: 6),
                                    Expanded(
                                      child: Text(
                                        data.description,
                                        maxLines: 2,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey.shade700),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Wrap(
                                      children: _buildInfoChip(tags: data.tags),
                                    ),
                                    const Align(
                                      alignment: Alignment.centerRight,
                                      child: Icon(Icons.arrow_forward_rounded,
                                          size: 18, color: Color(0xFF4854FE)),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ));
}

Widget categoryList(
    HomeNewController controller, CounsellingData counsellingData) {

  double screenWidth = MediaQuery.of(Get.context!).size.width;

  // Determine crossAxisCount based on screen width
  int crossAxisCount = 3;

  return Obx(() => controller.isDataLoading.value
      ? MediaQuery.of(Get.context!).size.width < 600
      ? ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForMobile()
      : ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForTab()
      : counsellingData.categories.isEmpty
      ? const Center(
    child: Padding(
      padding: EdgeInsets.all(24.0),
      child: Text("No category found"),
    ),
  )
      : Padding(
    padding: const EdgeInsets.all(8.0),
    child: GridView.builder(
        physics: NeverScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: counsellingData.categories.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          crossAxisSpacing: crossAxisCount == 2 ? 15 : 10,
          mainAxisSpacing: crossAxisCount == 2 ? 15 : 10,
          childAspectRatio: crossAxisCount == 2 ? 1.1 : 1,
        ),
        itemBuilder: (context, index) {
          var data = counsellingData.categories[index];
          return GestureDetector(
            onTap: () {
              Get.toNamed(Routes.mentorScreen, arguments: data)
                  ?.then((value) {
                if (value == 'payment') {
                  controller.onRefresh();
                }
              });
            },
            child: Stack(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: ColorResource.white,
                    border: Border.all(
                        color: ColorResource.grey_4,
                        width: 0.2
                    ),
                    borderRadius: BorderRadius.all(
                        Radius.circular(crossAxisCount == 2 ? 12 : 10)
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: EdgeInsets.all(crossAxisCount == 2 ? 12.0 : 8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: crossAxisCount == 2 ? 3 : 2,
                          child: SizedBox(
                            width: double.infinity,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  crossAxisCount == 2 ? 10.0 : 8.0
                              ),
                              child: Image.network(
                                data.imageUrl,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                      decoration: BoxDecoration(
                                        color: Colors.grey.shade200,
                                        borderRadius: BorderRadius.circular(
                                            crossAxisCount == 2 ? 10.0 : 8.0
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.grey,
                                        size: crossAxisCount == 2 ? 48 : 40,
                                      ),
                                    ),
                                loadingBuilder: (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return Container(
                                    alignment: Alignment.center,
                                    child: CircularProgressIndicator(
                                        strokeWidth: crossAxisCount == 2 ? 2.5 : 2
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                        ),

                        // Spacing
                        SizedBox(height: crossAxisCount == 2 ? 12 : 8),

                        // Title
                        Expanded(
                          flex: crossAxisCount == 2 ? 2 : 1,
                          child: SizedBox(
                            width: double.infinity,
                            child: Text(
                              data.title,
                              maxLines: crossAxisCount == 2 ? 3 : 2,
                              overflow: TextOverflow.ellipsis,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w500,
                                fontSize: crossAxisCount == 2
                                    ? MediaQuery.of(context).size.height * 0.018
                                    : MediaQuery.of(context).size.height * 0.014,
                                height: 1.2,
                                color: Colors.black87,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Arrow Icon
                Positioned(
                  top: crossAxisCount == 2 ? 12 : 8,
                  right: crossAxisCount == 2 ? 12 : 8,
                  child: Container(
                    padding: EdgeInsets.all(crossAxisCount == 2 ? 4 : 2),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: crossAxisCount == 2 ? 18 : 16,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ),
              ],
            ),
          );
        }),
  ));
}

List<Widget> _buildInfoChip({List<String>? tags}) {
  if (tags == null || tags.isEmpty) return [];

  return List.generate(tags.length, (index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tags[index] ?? "",
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade700,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  });
}

List<Widget> buildInfoChip({List<String>? tags}) {
  if (tags == null || tags.isEmpty) return [];

  return List.generate(tags.length, (index) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.error,
            size: 14,
            color: Colors.grey.shade400,
          ),
          const SizedBox(
            width: 8,
          ),
          const Text(
            'Scheduling Awaited',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 4),
        ],
      ),
    );
  });
}

class UserGreetingWidget extends StatelessWidget {
  final String? title;
  final double titleFontSize;
  final double subTitleFontSize;

  UserGreetingWidget({
    this.title,
    this.titleFontSize = DimensionResource.fontSizeSmall - 1,
    this.subTitleFontSize = DimensionResource.fontSizeExtraLarge - 1,
    super.key,
  });

  HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() {
      return Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title ?? greeting(),
                style: StyleResource.instance.styleLight(
                    color: hexToColor(homeController
                        .homeData.value.homepageUi?.userGreetingColor),
                    fontSize: screenWidth < 500
                        ? titleFontSize
                        : DimensionResource.fontSizeLarge),
              ),
              Text(
                Get.find<AuthService>().user.value.name == null
                    ? "User"
                    : Get.find<AuthService>()
                        .user
                        .value
                        .name
                        .toString()
                        .capitalize!,
                style: StyleResource.instance.styleMedium(
                    color: hexToColor(homeController
                        .homeData.value.homepageUi?.userNameColor),
                    fontSize: screenWidth < 500
                        ? subTitleFontSize
                        : DimensionResource.fontSizeOverLarge),
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              if (!Get.find<AuthService>().isGuestUser.value) {
                Get.toNamed(Routes.profileScreen);
              } else {
                ProgressDialog().showFlipDialog(isForPro: false);
              }
            },
            child: imageCircleContainer(
                radius: screenWidth < 500 ? 19 : 25,
                url: Get.find<AuthService>().user.value.profileImage ?? ""),
          ),
        ],
      );
    });
  }

  String greeting() {
    var hour = DateTime.now().hour;
    if (hour < 12) {
      return StringResource.goodMorning;
    }
    if (hour < 17) {
      return StringResource.goodAfternoon;
    }
    return StringResource.goodEvening;
  }
}

Color hexToColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) {
    return Colors.white; // Default fallback color
  }
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor"; // Add alpha value if not provided
  }
  try {
    return Color(int.parse("0x$hexColor"));
  } catch (e) {
    print("Invalid hex color: $hexColor");
    return Colors.transparent; // Default fallback color
  }
}

CachedNetworkImage cachedNetworkImage(String url,
    {BoxFit fit = BoxFit.cover,
    Color? color,
    bool imageLoader = false,
    Alignment? alignment}) {
  return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      placeholder: (context, url) => imageLoader
          ? const CommonCircularIndicator()
          : ShimmerEffect.instance.imageLoader(color: color),
      errorWidget: (context, url, error) {
        if (kDebugMode) {
          logPrint('network image error: $error');
        }
        return imageLoader
            ? const CommonCircularIndicator()
            : Container(
                color: color ?? ColorResource.imageBackground,
                padding: const EdgeInsets.all(22.0),
                child: Image.asset(
                  ImageResource.instance.errorImage,
                  fit: BoxFit.contain,
                ),
              );
      });
}

Widget imageCircleContainer(
    {required double radius,
    String url = ImageResource.defaultUser,
    bool showDot = false}) {
  return Stack(
    children: [
      CircleAvatar(
        radius: radius,
        backgroundImage: NetworkImage(url),
        onBackgroundImageError: (e, s) {},
        // child:  ClipRRect(
        //   clipBehavior: Clip.antiAliasWithSaveLayer,
        //     borderRadius: BorderRadius.circular(0),
        //     child: cachedNetworkImage(url,fit: BoxFit.fill)),
      ),
      Visibility(
        visible: showDot,
        child: const Positioned(
            bottom: 0,
            right: 0,
            child: Icon(
              Icons.circle,
              color: ColorResource.greenColor,
              size: 11,
            )),
      )
    ],
  );
}

// import 'dart:io';
//
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_rating_bar/flutter_rating_bar.dart';
// import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
// import 'package:stockpathshala_beta/model/utils/image_resource.dart';
// import 'package:stockpathshala_beta/model/utils/color_resource.dart';
// import 'package:get/get.dart';
// import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
// import '../home/home_new_controller.dart';
// import '../root_view/home_view/category_model.dart';
// import '../../widgets/button_view/icon_button.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:stockpathshala_beta/model/models/home_data_model/home_data_model.dart';
// import 'package:stockpathshala_beta/model/utils/string_resource.dart';
// import 'package:stockpathshala_beta/model/utils/style_resource.dart';
// import 'package:stockpathshala_beta/view/widgets/view_helpers/progress_dialog.dart';
// import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
// import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
// import '../../../../model/services/auth_service.dart';
// import '../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/foundation.dart';
// import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
// import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
// import 'package:flutter/services.dart';
// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quiz_list.dart';
// import '../../../../model/models/common_container_model/common_container_model.dart';
// import '../../../../view/screens/root_view/live_classes_view/live_class_detail/live_class_webview.dart';
// import 'package:intl/intl.dart';
// import '../../screens/home/session_request_card.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:lottie/lottie.dart';
// import 'package:stockpathshala_beta/model/models/home_data_model/home_data_model.dart';
// import 'package:stockpathshala_beta/model/utils/app_constants.dart';
// import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
// import 'package:stockpathshala_beta/model/utils/image_resource.dart';
// import 'package:stockpathshala_beta/model/utils/string_resource.dart';
// import 'package:stockpathshala_beta/model/utils/style_resource.dart';
// import 'package:stockpathshala_beta/view/widgets/view_helpers/progress_dialog.dart';
// import 'package:stockpathshala_beta/view_model/controllers/batch_controller/live_batch_controller.dart';
// import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
// import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
// import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
// import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
// import '../../../../model/services/auth_service.dart';
// import '../../../../model/utils/color_resource.dart';
// import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
// import '../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
// import 'package:stockpathshala_beta/view/screens/root_view/web_view/open_web_view.dart';
// import 'package:stockpathshala_beta/model/utils/font_resource.dart';
//
// class HomeScreen extends GetView<HomeNewController> {
//   const HomeScreen({super.key});
//   void scrollToItem(int id) {
//     final index = controller.categoriesData.value.mentors
//         .indexWhere((item) => item.id == id);
//     if (index != -1) {
//       // Use item height or a known offset to scroll
//       controller.scrollController.animateTo(
//         10.0 * index, // if fixed height
//         duration: const Duration(milliseconds: 500),
//         curve: Curves.easeInOut,
//       );
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     Get.put(HomeNewController());
//
//     return AnnotatedRegion<SystemUiOverlayStyle>(
//         value: const SystemUiOverlayStyle(
//           statusBarIconBrightness: Brightness.light,
//           statusBarColor: ColorResource.primaryColor,
//         ),
//         child: Scaffold(
//           body: Obx(() {
//             return Scaffold(
//                 backgroundColor: Colors.white,
//                 body: RefreshIndicator(
//                     onRefresh: controller.onRefresh,
//                     child: CustomScrollView(slivers: [
//                       SliverAppBar(
//                         expandedHeight: screenWidth < 500 ? 250 : 280,
//                         collapsedHeight: 45,
//                         toolbarHeight: 45,
//                         automaticallyImplyLeading: false,
//                         titleSpacing: DimensionResource.marginSizeDefault,
//                         title: SizedBox(
//                           height: 50,
//                           width: double.infinity,
//                           child: Row(
//                             children: [
//                               ActionCustomButton(
//                                 onTap: () {
//                                   Get.find<RootViewController>()
//                                       .scaffoldKey
//                                       .currentState
//                                       ?.openDrawer();
//                                 },
//                                 icon: ImageResource.instance.drawerIcon,
//                                 iconSize: screenWidth < 500 ? 14 : 20,
//                                 isLeft: true,
//                               ),
//                               const Spacer(),
//                               const SizedBox(
//                                 width: DimensionResource.marginSizeSmall,
//                               ),
//                               Obx(() {
//                                 int? dotValue = controller
//                                     .notificationCountData.value.count;
//                                 return ActionCustomButton(
//                                   onTap: () {
//                                     if (!Get.find<AuthService>()
//                                         .isGuestUser
//                                         .value) {
//                                       Get.toNamed(Routes.notificationView);
//                                     } else {
//                                       ProgressDialog()
//                                           .showFlipDialog(isForPro: false);
//                                     }
//                                     controller
//                                         .notificationCountData.value.count = 0;
//                                     controller.isShow.value = false;
//                                   },
//                                   showGreenDot: dotValue != null &&
//                                           controller.isShow.value
//                                       ? controller.notificationCountData.value
//                                               .count !=
//                                           0
//                                       : false,
//                                   iconSize: screenWidth < 500 ? 17 : 30,
//                                   isLeft: false,
//                                   greenDotValue: dotValue ?? 0,
//                                   icon: ImageResource.instance.notificationIcon,
//                                 );
//                               }),
//                             ],
//                           ),
//                         ),
//                         floating: false,
//                         pinned: true,
//                         backgroundColor: ColorResource.primaryColor,
//                         elevation: 3,
//                         flexibleSpace: FlexibleSpaceBar(
//                           centerTitle: true,
//                           collapseMode: CollapseMode.parallax,
//                           background: Stack(
//                             children: [
//                               Container(
//                                 width: double.infinity,
//                                 height: 305,
//                                 color: ColorResource.white,
//                                 child: Column(
//                                   children: [
//                                     controller.homeData.value.homepageUi
//                                                 ?.bgImageUrl?.isEmpty ??
//                                             true
//                                         ? Image.asset(
//                                             ImageResource.instance.homeBg,
//                                             fit: BoxFit.cover,
//                                             height:
//                                                 screenWidth < 500 ? 200 : 220,
//                                             width: double.infinity,
//                                           )
//                                         : Image.network(
//                                             controller.homeData.value
//                                                 .homepageUi!.bgImageUrl!,
//                                             fit: BoxFit.cover,
//                                             height:
//                                                 screenWidth < 500 ? 200 : 220,
//                                             width: double.infinity,
//                                           )
//                                   ],
//                                 ),
//                               ),
//                               controller.bannerData.value.data != null
//                                   ? Positioned(
//                                       bottom: 0,
//                                       left: 0,
//                                       right: 0,
//                                       child: Column(
//                                         children: [
//                                           Padding(
//                                             padding: EdgeInsets.symmetric(
//                                                 horizontal: screenWidth < 500
//                                                     ? DimensionResource
//                                                         .marginSizeDefault
//                                                     : DimensionResource
//                                                             .marginSizeLarge -
//                                                         3),
//                                             child: UserGreetingWidget(),
//                                           ),
//                                           SizedBox(
//                                             height: screenWidth < 500
//                                                 ? DimensionResource
//                                                         .marginSizeSmall +
//                                                     3
//                                                 : DimensionResource
//                                                         .marginSizeDefault -
//                                                     15,
//                                           ),
//                                           Container(
//                                             height:
//                                                 screenWidth < 500 ? 130 : 180,
//                                             width: screenWidth < 500
//                                                 ? double.infinity
//                                                 : 700,
//                                             decoration: BoxDecoration(
//                                                 borderRadius:
//                                                     BorderRadius.circular(15)),
//                                             child: Stack(
//                                               fit: StackFit.expand,
//                                               children: [
//                                                 Obx(() {
//                                                   return controller.isLoading
//                                                               .value !=
//                                                           true
//                                                       ? CarouselSlider.builder(
//                                                           options:
//                                                               CarouselOptions(
//                                                             aspectRatio: 1,
//                                                             viewportFraction: 1,
//                                                             autoPlay: true,
//                                                             enlargeCenterPage:
//                                                                 false,
//                                                             disableCenter:
//                                                                 false,
//                                                             onPageChanged:
//                                                                 (index,
//                                                                     reason) {
//                                                               controller
//                                                                   .setCurrentIndex(
//                                                                       index);
//                                                             },
//                                                           ),
//                                                           itemCount: controller
//                                                                   .bannerData
//                                                                   .value
//                                                                   .data
//                                                                   ?.length ??
//                                                               0,
//                                                           itemBuilder: (context,
//                                                               index, _) {
//                                                             DatumDatum
//                                                                 dataAtIndex =
//                                                                 controller
//                                                                         .bannerData
//                                                                         .value
//                                                                         .data
//                                                                         ?.elementAt(
//                                                                             index) ??
//                                                                     DatumDatum();
//                                                             return InkWell(
//                                                               splashColor: Colors
//                                                                   .transparent,
//                                                               onTap: () {
//                                                                 if (dataAtIndex
//                                                                         .bannerType ==
//                                                                     1) {
//                                                                   switch (
//                                                                       dataAtIndex
//                                                                           .type) {
//                                                                     case AppConstants
//                                                                         .textCourse:
//                                                                       Get.toNamed(
//                                                                           Routes.textCourseDetail(
//                                                                               id: dataAtIndex.bannerableId.toString()),
//                                                                           arguments: [
//                                                                             "",
//                                                                             dataAtIndex.bannerableId.toString()
//                                                                           ]);
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .audioCourse:
//                                                                       Get.toNamed(
//                                                                           Routes.audioCourseDetail(
//                                                                               id: dataAtIndex.bannerableId.toString()),
//                                                                           arguments: [
//                                                                             CourseDetailViewType.audioCourse,
//                                                                             dataAtIndex.bannerableId.toString(),
//                                                                             "",
//                                                                             ""
//                                                                           ]);
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .counsellingCategories:
//                                                                       Get.toNamed(
//                                                                           Routes
//                                                                               .mentorScreen,
//                                                                           arguments:
//                                                                               dataAtIndex.id);
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .counsellingPage:
//                                                                       //     controller.scrollController.animateTo(
//                                                                       // controller.scrollController.position.maxScrollExtent,
//                                                                       // duration: Duration(milliseconds: 500),
//                                                                       // curve: Curves.easeInOut);
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .audioRedirect:
//                                                                       Get.toNamed(
//                                                                           Routes.audioCourseDetail(
//                                                                               id: dataAtIndex.bannerableId.toString()),
//                                                                           arguments: [
//                                                                             CourseDetailViewType.audio,
//                                                                             dataAtIndex.bannerableId.toString(),
//                                                                             "",
//                                                                             ""
//                                                                           ]);
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .videoRedirect:
//                                                                       AppConstants
//                                                                           .instance
//                                                                           .singleCourseId
//                                                                           .value = (dataAtIndex.bannerableId ??
//                                                                               "")
//                                                                           .toString();
//
//                                                                       Get.toNamed(
//                                                                               Routes.continueWatchScreen(id: dataAtIndex.bannerableId.toString()),
//                                                                               arguments: [
//                                                                             dataAtIndex.bannerableId.toString(),
//                                                                             ""
//                                                                           ])!
//                                                                           .then(
//                                                                               (value) {
//                                                                         Get.find<HomeController>().getContinueLearning(
//                                                                             isFirst:
//                                                                                 true);
//                                                                       });
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .liveClassBanner:
//                                                                       AppConstants
//                                                                           .instance
//                                                                           .liveId
//                                                                           .value = (dataAtIndex.bannerableId ??
//                                                                               "")
//                                                                           .toString();
//                                                                       Get.toNamed(
//                                                                           Routes.liveClassDetail(
//                                                                               id: dataAtIndex.bannerableId.toString()),
//                                                                           arguments: [
//                                                                             false,
//                                                                             dataAtIndex.bannerableId.toString()
//                                                                           ]);
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .batchClass:
//                                                                       AppConstants
//                                                                           .instance
//                                                                           .batchId
//                                                                           .value = (dataAtIndex.bannerableId ??
//                                                                               "")
//                                                                           .toString();
//
//                                                                       Get.toNamed(
//                                                                           Routes.batchClassDetails(
//                                                                               id: dataAtIndex.bannerableId.toString()),
//                                                                           arguments: [
//                                                                             false,
//                                                                             dataAtIndex.bannerableId.toString()
//                                                                           ]);
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .upcomingBatch:
//                                                                       final bannerableId =
//                                                                           dataAtIndex
//                                                                               .bannerableId;
//                                                                       print(
//                                                                           'Bannerable ID: $bannerableId');
//
//                                                                       if (bannerableId ==
//                                                                           null) {
//                                                                         print(
//                                                                             'Error: bannerableId is null.');
//                                                                         return; // Exit early if `bannerableId` is null
//                                                                       }
//
//                                                                       // Access the batch data from LiveBatchesController
//                                                                       final displayList = Get.find<
//                                                                               LiveBatchesController>()
//                                                                           .batchData
//                                                                           .value
//                                                                           .data;
//
//                                                                       if (displayList ==
//                                                                               null ||
//                                                                           displayList
//                                                                               .isEmpty) {
//                                                                         print(
//                                                                             'Error: No batch data available.');
//                                                                         return; // Exit early if `displayList` is null or empty
//                                                                       }
//
//                                                                       // Find the matching batch data based on the ID
//                                                                       final matchingData =
//                                                                           displayList
//                                                                               .where((batchData) {
//                                                                         return batchData.id.toString() ==
//                                                                             bannerableId; // Ensure proper type comparison
//                                                                       }).toList();
//
//                                                                       if (matchingData
//                                                                           .isEmpty) {
//                                                                         print(
//                                                                             'Error: No matching data found for bannerableId: $bannerableId');
//                                                                         return; // Exit early if no matching data is found
//                                                                       }
//
//                                                                       // Navigate to the batch details route with the matched data
//                                                                       Get.toNamed(
//                                                                         Routes
//                                                                             .batchDetails,
//                                                                         arguments: [
//                                                                           matchingData
//                                                                               .first, // Pass the first matched BatchData object
//                                                                           false, // isPast flag
//                                                                         ],
//                                                                       );
//
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .pastBatch:
//                                                                       final bannerableId =
//                                                                           dataAtIndex
//                                                                               .bannerableId;
//                                                                       print(
//                                                                           'Bannerable ID: $bannerableId');
//
//                                                                       if (bannerableId ==
//                                                                           null) {
//                                                                         print(
//                                                                             'Error: bannerableId is null.');
//                                                                         return; // Exit early if `bannerableId` is null
//                                                                       }
//
//                                                                       // Access the batch data from PastClassesController
//                                                                       final displayList = Get.find<
//                                                                               PastClassesController>()
//                                                                           .batchData
//                                                                           .value
//                                                                           .data;
//
//                                                                       if (displayList ==
//                                                                               null ||
//                                                                           displayList
//                                                                               .isEmpty) {
//                                                                         print(
//                                                                             'Error: No batch data available.');
//                                                                         return; // Exit early if `displayList` is null or empty
//                                                                       }
//
//                                                                       // Find the matching batch data based on the ID
//                                                                       final matchingData =
//                                                                           displayList
//                                                                               .where((batchData) {
//                                                                         return batchData.id.toString() ==
//                                                                             bannerableId; // Ensure proper type comparison
//                                                                       }).toList();
//
//                                                                       if (matchingData
//                                                                           .isEmpty) {
//                                                                         print(
//                                                                             'Error: No matching data found for bannerableId: $bannerableId');
//                                                                         return; // Exit early if no matching data is found
//                                                                       }
//
//                                                                       // Navigate to the batch details route with the matched data
//                                                                       Get.toNamed(
//                                                                         Routes
//                                                                             .batchDetails,
//                                                                         arguments: [
//                                                                           matchingData
//                                                                               .first, // Pass the first matched BatchData object
//                                                                           true, // isPast flag
//                                                                         ],
//                                                                       );
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .upcomingLiveClass:
//                                                                       if (dataAtIndex
//                                                                               .bannerableId !=
//                                                                           null) {
//                                                                         AppConstants
//                                                                             .instance
//                                                                             .batchId
//                                                                             .value = (dataAtIndex.bannerableId.toString())!;
//                                                                         Get.toNamed(
//                                                                             Routes.batchClassDetails(id: dataAtIndex.bannerableId.toString()),
//                                                                             arguments: [
//                                                                               false,
//                                                                               dataAtIndex.bannerableId.toString()
//                                                                             ]);
//                                                                       } else {
//                                                                         AppConstants
//                                                                             .instance
//                                                                             .liveId
//                                                                             .value = (dataAtIndex.bannerableId.toString())!;
//                                                                         Get.toNamed(
//                                                                             Routes.liveClassDetail(id: dataAtIndex.bannerableId.toString()),
//                                                                             arguments: [
//                                                                               false,
//                                                                               dataAtIndex.bannerableId.toString()
//                                                                             ]);
//                                                                       }
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .pastLiveClass:
//                                                                       if (dataAtIndex
//                                                                               .bannerableId !=
//                                                                           null) {
//                                                                         AppConstants
//                                                                             .instance
//                                                                             .liveId
//                                                                             .value = (dataAtIndex.bannerableId.toString())!;
//                                                                         Get.toNamed(
//                                                                             Routes.liveClassDetail(id: dataAtIndex.bannerableId.toString()),
//                                                                             arguments: [
//                                                                               true,
//                                                                               dataAtIndex.bannerableId.toString()
//                                                                             ]);
//                                                                       } else {
//                                                                         AppConstants
//                                                                             .instance
//                                                                             .liveId
//                                                                             .value = (dataAtIndex.bannerableId.toString())!;
//                                                                         Get.toNamed(
//                                                                             Routes.liveClassDetail(id: dataAtIndex.bannerableId.toString()),
//                                                                             arguments: [
//                                                                               false,
//                                                                               dataAtIndex.bannerableId.toString()
//                                                                             ]);
//                                                                       }
//                                                                       break;
//
//                                                                     case AppConstants
//                                                                         .blogRedirect:
//                                                                       AppConstants
//                                                                           .instance
//                                                                           .blogId
//                                                                           .value = (dataAtIndex.bannerableId ??
//                                                                               "")
//                                                                           .toString();
//
//                                                                       Get.toNamed(
//                                                                           Routes.blogsView(
//                                                                               id: dataAtIndex.bannerableId.toString()),
//                                                                           arguments: [
//                                                                             dataAtIndex.bannerableId.toString(),
//                                                                             ""
//                                                                           ]);
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .quizRedirect:
//                                                                       Get.toNamed(
//                                                                           Routes
//                                                                               .quizMainView,
//                                                                           arguments: {
//                                                                             "id":
//                                                                                 dataAtIndex.bannerableId.toString(),
//                                                                             "??":
//                                                                                 "",
//                                                                             "quiz_type": dataAtIndex.isScholarship == 1
//                                                                                 ? QuizType.scholarship
//                                                                                 : QuizType.free,
//                                                                             "is_timeup":
//                                                                                 false,
//                                                                             "is_fromHome":
//                                                                                 true
//                                                                           });
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .subscription:
//                                                                       if (Platform
//                                                                           .isAndroid) {
//                                                                         Get.toNamed(
//                                                                             Routes.subscriptionView);
//                                                                       }
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .upcomingBatchClass:
//                                                                       Get.find<
//                                                                               RootViewController>()
//                                                                           .selectedTab
//                                                                           .value = 2;
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .pastBatchPage:
//                                                                       Get.find<
//                                                                               LiveBatchesController>()
//                                                                           .isTabValueChange
//                                                                           .value = true;
//
//                                                                       Get.find<
//                                                                               RootViewController>()
//                                                                           .selectedTab
//                                                                           .value = 2;
//                                                                       Get.find<
//                                                                               LiveBatchesController>()
//                                                                           .tabChange();
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .mentorshipClass:
//                                                                       Get.toNamed(
//                                                                         Routes
//                                                                             .mentorshipDetail(
//                                                                           id: dataAtIndex
//                                                                               .bannerableId
//                                                                               .toString(),
//                                                                         ),
//                                                                         arguments: {
//                                                                           'id': dataAtIndex
//                                                                               .bannerableId
//                                                                               .toString(),
//                                                                         },
//                                                                       );
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .upcomingWebinarPage:
//                                                                       Get.find<
//                                                                               RootViewController>()
//                                                                           .selectedTab
//                                                                           .value = 3;
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .pastWebinarPage:
//                                                                       Get.find<
//                                                                               LiveClassesController>()
//                                                                           .isTabValueChange
//                                                                           .value = true;
//
//                                                                       Get.find<
//                                                                               RootViewController>()
//                                                                           .selectedTab
//                                                                           .value = 3;
//                                                                       Get.find<
//                                                                               LiveClassesController>()
//                                                                           .tabChange();
//                                                                       Get.find<
//                                                                               PastClassesController>()
//                                                                           .onRefresh();
//                                                                       break;
//                                                                     case AppConstants
//                                                                         .mentorshipPage:
//                                                                       Get.find<
//                                                                               RootViewController>()
//                                                                           .selectedTab
//                                                                           .value = 1;
//                                                                       break;
//
//                                                                     default:
//                                                                       AppConstants
//                                                                           .instance
//                                                                           .videoCourseId
//                                                                           .value = (dataAtIndex.bannerableId ??
//                                                                               "")
//                                                                           .toString();
//                                                                       Get.toNamed(
//                                                                           Routes.videoCourseDetail(
//                                                                               id: dataAtIndex.bannerableId.toString()),
//                                                                           arguments: [
//                                                                             "",
//                                                                             dataAtIndex.bannerableId.toString()
//                                                                           ]);
//                                                                       break;
//                                                                   }
//                                                                 } else {
//                                                                   if (dataAtIndex
//                                                                           .url !=
//                                                                       null) {
//                                                                     Navigator.of(Get.context!).push(MaterialPageRoute(
//                                                                         builder: (context) => OpenWebView(
//                                                                             url: dataAtIndex.url ??
//                                                                                 "",
//                                                                             title:
//                                                                                 dataAtIndex.title ?? "")));
//                                                                   }
//                                                                 }
//                                                               },
//                                                               child: Container(
//                                                                   padding: const EdgeInsets
//                                                                       .symmetric(
//                                                                       horizontal:
//                                                                           DimensionResource
//                                                                               .marginSizeDefault),
//                                                                   width: double
//                                                                       .infinity,
//                                                                   child:
//                                                                       ClipRRect(
//                                                                     borderRadius:
//                                                                         BorderRadius.circular(
//                                                                             15),
//                                                                     child:
//                                                                         Stack(
//                                                                       children: [
//                                                                         Positioned(
//                                                                           top:
//                                                                               0,
//                                                                           bottom:
//                                                                               0,
//                                                                           left:
//                                                                               0,
//                                                                           right:
//                                                                               0,
//                                                                           child: cachedNetworkImage(
//                                                                               dataAtIndex.image ?? "",
//                                                                               fit: BoxFit.fill),
//                                                                         ),
//                                                                         Align(
//                                                                           alignment:
//                                                                               Alignment.bottomLeft,
//                                                                           child:
//                                                                               Container(
//                                                                             margin:
//                                                                                 const EdgeInsets.only(
//                                                                               bottom: DimensionResource.marginSizeDefault + 10,
//                                                                               left: DimensionResource.marginSizeDefault,
//                                                                               right: DimensionResource.marginSizeDefault,
//                                                                             ),
//                                                                             decoration:
//                                                                                 BoxDecoration(borderRadius: BorderRadius.circular(3), color: ColorResource.white),
//                                                                             padding:
//                                                                                 const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                                                                             child:
//                                                                                 Text(
//                                                                               dataAtIndex.title ?? "",
//                                                                               style: StyleResource.instance.styleLight(fontSize: screenWidth < 500 ? DimensionResource.fontSizeExtraSmall : DimensionResource.fontSizeDefault),
//                                                                               maxLines: 1,
//                                                                               overflow: TextOverflow.ellipsis,
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                         Visibility(
//                                                                           visible:
//                                                                               dataAtIndex.isPromotional != null && dataAtIndex.isPromotional == 1,
//                                                                           child:
//                                                                               Align(
//                                                                             alignment:
//                                                                                 Alignment.topLeft,
//                                                                             child:
//                                                                                 Container(
//                                                                               margin: const EdgeInsets.only(
//                                                                                 top: DimensionResource.marginSizeDefault,
//                                                                                 left: DimensionResource.marginSizeDefault,
//                                                                                 right: DimensionResource.marginSizeDefault,
//                                                                               ),
//                                                                               decoration: BoxDecoration(borderRadius: BorderRadius.circular(3), color: ColorResource.white),
//                                                                               padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
//                                                                               child: Text(
//                                                                                 "Promotional",
//                                                                                 style: StyleResource.instance.styleLight(fontSize: DimensionResource.fontSizeExtraSmall - 2),
//                                                                                 maxLines: 1,
//                                                                                 overflow: TextOverflow.ellipsis,
//                                                                               ),
//                                                                             ),
//                                                                           ),
//                                                                         ),
//                                                                       ],
//                                                                     ),
//                                                                   )),
//                                                             );
//                                                           },
//                                                         )
//                                                       : Padding(
//                                                           padding: EdgeInsets.symmetric(
//                                                               horizontal: screenWidth <
//                                                                       500
//                                                                   ? DimensionResource
//                                                                       .marginSizeDefault
//                                                                   : DimensionResource
//                                                                       .marginSizeLarge),
//                                                           child: ShimmerEffect
//                                                               .instance
//                                                               .imageLoader(
//                                                                   color:
//                                                                       ColorResource
//                                                                           .white),
//                                                         );
//                                                 }),
//                                                 Align(
//                                                   alignment:
//                                                       Alignment.bottomCenter,
//                                                   child: Obx(() => Padding(
//                                                         padding:
//                                                             const EdgeInsets
//                                                                 .only(
//                                                                 bottom: 10),
//                                                         child: Row(
//                                                             mainAxisSize:
//                                                                 MainAxisSize
//                                                                     .min,
//                                                             mainAxisAlignment:
//                                                                 MainAxisAlignment
//                                                                     .center,
//                                                             children: List.generate(
//                                                                 controller
//                                                                         .bannerData
//                                                                         .value
//                                                                         .data
//                                                                         ?.length ??
//                                                                     controller
//                                                                         .dummyImages
//                                                                         .length,
//                                                                 (index) {
//                                                               return AnimatedContainer(
//                                                                 margin: const EdgeInsets
//                                                                     .symmetric(
//                                                                     horizontal:
//                                                                         2),
//                                                                 duration:
//                                                                     const Duration(
//                                                                         milliseconds:
//                                                                             300),
//                                                                 height: controller
//                                                                             .currentIndex
//                                                                             .value ==
//                                                                         index
//                                                                     ? 10
//                                                                     : 7,
//                                                                 width: controller
//                                                                             .currentIndex
//                                                                             .value ==
//                                                                         index
//                                                                     ? 10
//                                                                     : 7,
//                                                                 decoration:
//                                                                     BoxDecoration(
//                                                                   borderRadius:
//                                                                       BorderRadius
//                                                                           .circular(
//                                                                               15),
//                                                                   color: controller
//                                                                               .currentIndex
//                                                                               .value ==
//                                                                           index
//                                                                       ? ColorResource
//                                                                           .yellowColor
//                                                                       : ColorResource
//                                                                           .white,
//                                                                 ),
//                                                               );
//                                                             })),
//                                                       )),
//                                                 ),
//                                               ],
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     )
//                                   : const SizedBox.shrink(),
//                             ],
//                           ),
//                         ),
//                       ),
//                       SliverList(
//                         delegate: SliverChildListDelegate([
//                           Padding(
//                             padding: const EdgeInsets.only(
//                                 left: 24.0, top: 24, bottom: 24, right: 16),
//                             child: Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 controller.categoriesData.value
//                                                 .waitedCounselling !=
//                                             null &&
//                                         controller.categoriesData.value
//                                             .waitedCounselling!.isNotEmpty
//                                     ? ListView.builder(
//                                         shrinkWrap:
//                                             true, // so it doesn’t take infinite height
//                                         padding: EdgeInsets.zero,
//                                         physics:
//                                             const NeverScrollableScrollPhysics(), // let parent scroll
//                                         itemCount: controller.categoriesData
//                                             .value.waitedCounselling!.length,
//                                         itemBuilder: (context, index) {
//                                           final counselling = controller
//                                               .categoriesData
//                                               .value
//                                               .waitedCounselling![index];
//
//                                           return controller
//                                                       .categoriesData
//                                                       .value
//                                                       .waitedCounselling?[index]
//                                                       .status !=
//                                                   "approved"
//                                               ? SessionRequestCard(
//                                                   userName:
//                                                       Get.find<AuthService>()
//                                                           .user
//                                                           .value
//                                                           .name
//                                                           .toString()
//                                                           .capitalize!)
//
//                                               // Column(
//                                               //         children: [
//                                               //           Card(
//                                               //             color:
//                                               //                 ColorResource.white,
//                                               //             margin: const EdgeInsets
//                                               //                 .symmetric(
//                                               //                 vertical: 6),
//                                               //             child: Padding(
//                                               //               padding:
//                                               //                   const EdgeInsets
//                                               //                       .symmetric(
//                                               //                       vertical: 8.0),
//                                               //               child: SizedBox(
//                                               //                 width:
//                                               //                     double.infinity,
//                                               //                 child: Column(
//                                               //                   crossAxisAlignment:
//                                               //                       CrossAxisAlignment
//                                               //                           .center,
//                                               //                   children: [
//                                               //                     Padding(
//                                               //                       padding:
//                                               //                           const EdgeInsets
//                                               //                               .all(
//                                               //                               16.0),
//                                               //                       child: Column(
//                                               //                         children: [
//                                               //                           Text(
//                                               //                             'Thank you ${Get.find<AuthService>().user.value.name.toString().capitalize!}',
//                                               //                             textAlign:
//                                               //                                 TextAlign
//                                               //                                     .center,
//                                               //                             style:
//                                               //                                 const TextStyle(
//                                               //                               fontSize:
//                                               //                                   16,
//                                               //                               fontWeight:
//                                               //                                   FontWeight.w600,
//                                               //                             ),
//                                               //                           ),
//                                               //                           const Text(
//                                               //                             'for booking a counselling session.\n We will assign a mentor soon.',
//                                               //                             textAlign:
//                                               //                                 TextAlign
//                                               //                                     .center,
//                                               //                             style:
//                                               //                                 TextStyle(
//                                               //                               fontSize:
//                                               //                                   11,
//                                               //                             ),
//                                               //                           ),
//                                               //                           const SizedBox(
//                                               //                               height:
//                                               //                                   16),
//                                               //                           Wrap(
//                                               //                             children:
//                                               //                                 buildInfoChip(
//                                               //                                     tags: [
//                                               //                                   counselling.bookingStatus ??
//                                               //                                       'Scheduling Awaited'
//                                               //                                 ]),
//                                               //                           )
//                                               //                         ],
//                                               //                       ),
//                                               //                     ),
//                                               //                     const SizedBox(
//                                               //                         height: 8),
//                                               //                   ],
//                                               //                 ),
//                                               //               ),
//                                               //             ),
//                                               //           ),
//                                               //         ],
//                                               //       )
//                                               : const SizedBox.shrink();
//                                         },
//                                       )
//                                     : const SizedBox.shrink(),
//
//                                 controller.categoriesData.value
//                                         .bookedCounselling.isNotEmpty
//                                     ? ListView.builder(
//                                         shrinkWrap: true,
//                                         padding: EdgeInsets.zero,
//                                         physics:
//                                             const NeverScrollableScrollPhysics(),
//                                         itemCount: controller.categoriesData
//                                             .value.bookedCounselling.length,
//                                         itemBuilder: (context, index) {
//                                           final session = controller
//                                               .categoriesData
//                                               .value
//                                               .bookedCounselling[index];
//                                           final item = session;
//
//                                           double screenWidth =
//                                               MediaQuery.of(context).size.width;
//                                           double tileWidth = screenWidth < 500
//                                               ? screenWidth - 20
//                                               : screenWidth / 2 - 20;
//
//                                           return SizedBox(
//                                             width: tileWidth,
//                                             child: bookedCounsellingView(
//                                               index,
//                                               fontSize: DimensionResource
//                                                       .marginSizeSmall +
//                                                   3,
//                                               data: controller
//                                                   .categoriesData
//                                                   .value
//                                                   .bookedCounselling[index],
//                                               serverTime: controller
//                                                   .categoriesData
//                                                   .value
//                                                   .serverTime,
//                                               liveClassesController: controller,
//                                               onItemTap: (data) {},
//                                             ),
//                                           );
//                                         },
//                                       )
//                                     : const SizedBox.shrink(),
//                                 SizedBox(
//                                     height: controller.categoriesData.value
//                                             .bookedCounselling.isEmpty
//                                         ? 0
//                                         : 20),
//                                 const Text(
//                                   'Choose Your Category',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.w600),
//                                 ),
//                                 const Text(
//                                   'Get matched with a mentor who fits your goals',
//                                   style: TextStyle(
//                                       fontSize: 12,
//                                       color: Colors.black45,
//                                       fontWeight: FontWeight.w400),
//                                 ),
//                                 // SizedBox(height: 4),
//                                 // Text(
//                                 //   'Choose your subjects & get expert guidance',
//                                 //   style: TextStyle(
//                                 //       fontSize: 12, color: Colors.black54),
//                                 // ),
//                                 // SizedBox(height: 16),
//                                 // categoryChip(controller,controller.categoriesData.value.categories ?? []),
//                               ],
//                             ),
//                           ),
//                           categoryList(
//                               controller, controller.categoriesData.value)
//                         ]),
//                       ),
//                     ])));
//           }),
//         ));
//   }
// }
//
// Widget bookedCounsellingView(
//   int index, {
//   double fontSize = DimensionResource.fontSizeExtraSmall - 2,
//   bool isPast = false,
//   Function(CommonDatum data)? onItemTap,
//   required BookedCounselling data,
//   required HomeNewController liveClassesController,
//   String? serverTime,
// }) {
//   DateTime serverDateTime = DateTime.parse(
//       liveClassesController.categoriesData.value.serverTime.toString());
//   final ui = liveClassesController.categoriesData.value.ui!;
//   // final data = liveClassesController.categoriesData.value;
//   var time = timeDifferenceInSeconds(
//     data.startDateTime.toString(),
//     serverTime ?? DateTime.now().toString(),
//   );
//   return InkWell(
//     child: Card(
//       child: Container(
//         color: ColorResource.primaryColor.withOpacity(0.01),
//         child: Column(
//           children: [
//             ClipRRect(
//               borderRadius: const BorderRadius.only(
//                 topLeft: Radius.circular(12),
//                 topRight: Radius.circular(12),
//               ),
//               child: Container(
//                 width: double.infinity,
//                 color: Colors.green.withOpacity(0.05),
//                 padding: const EdgeInsets.all(12),
//                 child: Row(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     Icon(
//                       Icons.check_circle,
//                       color: Colors.green,
//                       size: MediaQuery.of(Get.context!).size.width * 0.10,
//                     ),
//                     const SizedBox(width: 12),
//                     const Expanded(
//                       child: Text(
//                         'Session Confirmed!',
//                         style: TextStyle(
//                           fontSize: 16,
//                           fontWeight: FontWeight.bold,
//                           color: ColorResource.greenDarkColor,
//                         ),
//                       ),
//                     ),
//                     Padding(
//                       padding: const EdgeInsets.all(4.0),
//                       child: Image.asset(
//                         ImageResource.instance.enjoy,
//                         width: MediaQuery.of(Get.context!).size.width * 0.1,
//                         height: MediaQuery.of(Get.context!).size.width * 0.1,
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 children: [
//                   RichText(
//                     text: TextSpan(
//                       text: 'Dear ',
//                       style: TextStyle(
//                         color: Colors.black,
//                         fontSize: 13,
//                         fontFamily: FontResource.instance.mainFont,
//                       ),
//                       children: [
//                         TextSpan(
//                           text:
//                               '${Get.find<AuthService>().user.value.name.toString().capitalize},' ??
//                                   'User',
//                           style: TextStyle(
//                             letterSpacing: 0.3,
//                             color: Colors.black,
//                             fontSize: 13,
//                             fontFamily: FontResource.instance.mainFont,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "\nYour counselling with ",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 13,
//                             letterSpacing: 0.3,
//                             fontFamily: FontResource.instance.mainFont,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "${data.mentor.name} ",
//                           style: TextStyle(
//                             letterSpacing: 0.3,
//                             color: Colors.black,
//                             fontSize: 13,
//                             fontFamily: FontResource.instance.mainFont,
//                             fontWeight: FontWeight.bold,
//                           ),
//                         ),
//                         TextSpan(
//                           text: "is scheduled:",
//                           style: TextStyle(
//                             color: Colors.black,
//                             fontSize: 13,
//                             letterSpacing: 0.3,
//                             fontFamily: FontResource.instance.mainFont,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   IntrinsicHeight(
//                     child: Container(
//                       decoration: BoxDecoration(
//                           border:
//                               Border.all(color: ColorResource.grey, width: 0.2),
//                           borderRadius: BorderRadius.circular(10)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.start,
//                         children: [
//                           Padding(
//                             padding: const EdgeInsets.all(8.0),
//                             child: Row(
//                               children: [
//                                 const Icon(
//                                   Icons.calendar_month,
//                                   color: ColorResource.black,
//                                 ),
//                                 const SizedBox(width: 8),
//                                 Text(
//                                   DateFormat('dd MMM yyyy')
//                                       .format(data.startDateTime),
//                                   style: const TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black),
//                                 ),
//                               ],
//                             ),
//                           ),
//                           const SizedBox(width: 8),
//                           Row(
//                             children: [
//                               Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Container(
//                                   width: 0.3,
//                                   color: Colors.grey,
//                                 ),
//                               ),
//                             ],
//                           ),
//                           const SizedBox(width: 8),
//                           const Icon(
//                             Icons.watch_later_outlined,
//                             color: ColorResource.black,
//                           ),
//                           const SizedBox(width: 8),
//                           Text(
//                             DateFormat('hh:mm a').format(data.startDateTime),
//                             style: const TextStyle(
//                                 fontWeight: FontWeight.w600,
//                                 color: Colors.black),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 16),
//                   const Row(
//                     children: [
//                       Text(
//                         '👉',
//                         style: TextStyle(fontSize: 20),
//                       ),
//                       SizedBox(width: 8),
//                       Expanded(
//                         child: Text(
//                           'Things to prepare:',
//                           style: TextStyle(
//                               fontSize: 14, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 4),
//                   Padding(
//                     padding: const EdgeInsets.all(4.0),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Bullet 1
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Image.asset(
//                               ImageResource.instance.mentorCheckIcon,
//                               width: 14,
//                               height: 14,
//                               color: ColorResource.grey_4,
//                             ),
//                             const SizedBox(width: 10),
//                             const Expanded(
//                               child: Text(
//                                 'Note down 2-3 trading challenges.',
//                                 style: TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Image.asset(
//                               ImageResource.instance.mentorCheckIcon,
//                               width: 14,
//                               height: 14,
//                               color: ColorResource.grey_4,
//                             ),
//                             const SizedBox(width: 10),
//                             const Expanded(
//                               child: Text(
//                                 'Be ready to share your goals.',
//                                 style: TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           ],
//                         ),
//                         const SizedBox(height: 4),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment
//                               .start, // changed to center here too
//                           children: [
//                             Image.asset(
//                               ImageResource.instance.mentorCheckIcon,
//                               width: 14,
//                               height: 14,
//                               color: ColorResource.grey_4,
//                             ),
//                             const SizedBox(width: 10),
//                             const Expanded(
//                               child: Text(
//                                 'List questions for a productive discussion.',
//                                 style: TextStyle(fontSize: 13),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(height: 24),
//                   Row(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       const SizedBox(width: 8),
//
//                       /// Avatar
//                       ClipRRect(
//                         borderRadius:
//                             BorderRadius.circular(42), // Circular avatar
//                         child: Container(
//                           width: MediaQuery.of(Get.context!).size.width * 0.1,
//                           height: MediaQuery.of(Get.context!).size.width * 0.1,
//                           color: ColorResource.primaryColor,
//                           child: Image.network(
//                             data.mentor.imageUrl,
//                             fit: BoxFit.cover,
//                             errorBuilder: (context, error, stackTrace) =>
//                                 const Icon(Icons.error, size: 14),
//                             loadingBuilder: (context, child, loadingProgress) {
//                               if (loadingProgress == null) return child;
//                               return const Center(
//                                 child: SizedBox(
//                                   width: 12,
//                                   height: 12,
//                                   child:
//                                       CircularProgressIndicator(strokeWidth: 2),
//                                 ),
//                               );
//                             },
//                           ),
//                         ),
//                       ),
//
//                       const SizedBox(width: 12),
//                       Expanded(
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             Text(
//                               data.mentor.name,
//                               style: const TextStyle(
//                                   fontSize: 13, fontWeight: FontWeight.w600),
//                               softWrap: true,
//                             ),
//                             // const SizedBox(height: 4),
//                             Text(
//                               data.mentor.expertise.title,
//                               style: const TextStyle(
//                                   fontSize: 12, fontWeight: FontWeight.w600),
//                               softWrap: true,
//                             ),
//                             // const SizedBox(height: 4),
//                             RatingBarIndicator(
//                               rating: data.mentor.ratings,
//                               itemCount: 5,
//                               itemSize: 12,
//                               direction: Axis.horizontal,
//                               itemBuilder: (context, index) => const Icon(
//                                 Icons.star,
//                                 color: Colors.amber,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: Container(
//                       width: double.infinity,
//                       padding: const EdgeInsets.symmetric(
//                           vertical: 4, horizontal: 12),
//                       decoration: BoxDecoration(
//                         color: time <= 0
//                             ? hexToColor(
//                                 ui.bookedCounsellingSessionJoinButtonBgColor)
//                             : ColorResource.accentYellowColor,
//                       ),
//                       child: Center(
//                         child: Container(
//                           decoration: BoxDecoration(
//                               color: time <= 0
//                                   ? hexToColor(ui
//                                       .bookedCounsellingSessionJoinButtonBgColor)
//                                   : ColorResource
//                                       .black, // Black background effect
//                               borderRadius: const BorderRadius.only(
//                                   topRight: Radius.circular(5),
//                                   topLeft: Radius.circular(5))),
//                           padding: const EdgeInsets.symmetric(
//                               vertical:
//                                   3), // Inner padding to separate yellow from black
//                           child: Container(
//                             padding: const EdgeInsets.symmetric(
//                                 vertical: 6, horizontal: 12),
//                             decoration: BoxDecoration(
//                                 color: time <= 0
//                                     ? hexToColor(ui
//                                         .bookedCounsellingSessionJoinButtonBgColor)
//                                     : ColorResource.accentYellowColor,
//                                 borderRadius: const BorderRadius.only(
//                                     topRight: Radius.circular(5),
//                                     topLeft: Radius.circular(5))),
//                             child: time <= 0
//                                 ? GestureDetector(
//                                     onTap: () {
//                                       Navigator.push(
//                                         Get.context!,
//                                         MaterialPageRoute(
//                                           builder: (context) => LiveClassLaunch(
//                                             title:
//                                                 data.mentor.expertise.title ??
//                                                     '',
//                                             url: data.participantLink,
//                                           ),
//                                         ),
//                                       );
//                                     },
//                                     child: SizedBox(
//                                       width: 100,
//                                       child: Row(
//                                         mainAxisAlignment:
//                                             MainAxisAlignment.center,
//                                         children: [
//                                           const Icon(
//                                             Icons.play_circle_outline_rounded,
//                                             color: Colors.white,
//                                             size: 16,
//                                           ),
//                                           const SizedBox(width: 6),
//                                           Text(
//                                             'Join Now',
//                                             style: TextStyle(
//                                               fontWeight: FontWeight.w600,
//                                               fontSize: 14,
//                                               color: hexToColor(ui
//                                                   .bookedCounsellingSessionJoinButtonTextColor),
//                                             ),
//                                           ),
//                                         ],
//                                       ),
//                                     ),
//                                   )
//                                 : TimerCountDown(
//                                     isHrShow: false,
//                                     isHrs: true,
//                                     timeInSeconds: time,
//                                     fontStyle: StyleResource.instance.styleBold(
//                                       fontSize: 18,
//                                       fontWeight: FontWeight.w600,
//                                       color: Colors.black,
//                                     ),
//                                     remainingSeconds: (second) {
//                                       if (second <= 120) {
//                                         EasyDebounce.debounce(
//                                           data.id.toString(),
//                                           const Duration(seconds: 1),
//                                           () {
//                                             // Trigger your action
//                                           },
//                                         );
//                                       }
//                                     },
//                                   ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 8),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     ),
//   );
// }
//
// int timeDifferenceInSeconds(String startTimeString, String serverTimeString) {
//   final DateTime startTime = DateTime.parse(startTimeString);
//   final DateTime serverTime = DateTime.parse(serverTimeString);
//   final diff = startTime.difference(serverTime);
//   return diff.isNegative ? 0 : diff.inSeconds;
// }
//
// Widget categoryChip(
//     HomeNewController controller, List<CounsellingCategory> list) {
//   return SizedBox(
//     height: 30,
//     child: ListView.builder(
//       scrollDirection: Axis.horizontal,
//       itemCount: list.length ?? 1,
//       itemBuilder: (context, index) {
//         return Column(
//           children: [
//             InkWell(
//               onTap: () {
//                 if (controller.selectedChip.contains(list[index].id)) {
//                   controller.selectedChip.remove(list[index].id);
//                 } else {
//                   controller.selectedChip.add(list[index].id);
//                 }
//                 if (controller.selectedChip.isEmpty) {
//                   controller.filteredCategoriesData.value =
//                       controller.categoriesData.value;
//                 } else {
//                   final filteredMentors = controller
//                       .categoriesData.value.mentors
//                       .where((item) =>
//                           controller.selectedChip.contains(item.experienceId))
//                       .toList();
//                   controller.filteredCategoriesData.value = CounsellingData(
//                     totalMentors: filteredMentors.length,
//                     mentors: filteredMentors,
//                     categories: controller.categoriesData.value.categories,
//                     ui: controller.categoriesData.value.ui,
//                     serverTime: controller.categoriesData.value.serverTime,
//                     bookedCounselling: [],
//                     counsellingPrice: 0,
//                   );
//                 }
//               },
//               child: Container(
//                 padding:
//                     const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
//                 margin: const EdgeInsets.only(right: 8.0),
//                 decoration: BoxDecoration(
//                     color: controller.selectedChip.contains(list[index].id)
//                         ? Colors.grey.shade200
//                         : Colors.white,
//                     border: Border.all(
//                         color: Colors.black.withOpacity(0.2), width: 0.4),
//                     borderRadius: BorderRadius.circular(10)),
//                 child: Text(
//                   list[index].title ?? "fr",
//                   style: const TextStyle(fontSize: 10),
//                 ),
//               ),
//             ),
//             const SizedBox(
//               width: 8,
//             )
//           ],
//         );
//       },
//     ),
//   );
// }
//
// Widget categoryList(
//     HomeNewController controller, CounsellingData counsellingData) {
//   return Obx(() => controller.isDataLoading.value
//       ? MediaQuery.of(Get.context!).size.width < 600
//           ? ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForMobile()
//           : ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForTab()
//       : counsellingData.categories.isEmpty
//           ? const Center(
//               child: Padding(
//                 padding: EdgeInsets.all(24.0),
//                 child: Text("No category found"),
//               ),
//             )
//           : ListView.builder(
//               controller: controller.scrollController,
//               itemCount: counsellingData.categories.length,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               itemBuilder: (context, index) {
//                 var data = counsellingData.categories[index];
//                 return GestureDetector(
//                   onTap: () {
//                     Get.toNamed(Routes.mentorScreen,
//                         arguments: counsellingData.categories[index].id);
//                   },
//                   child: Padding(
//                     padding:
//                         const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                     child: Container(
//                       constraints: BoxConstraints(
//                           minHeight: MediaQuery.of(context).size.height * 0.15),
//                       decoration: BoxDecoration(
//                         color: Colors.white,
//                         border: Border.all(color: Colors.grey.shade200),
//                         borderRadius: BorderRadius.circular(16),
//                         boxShadow: [
//                           BoxShadow(
//                             color: Colors.black.withOpacity(0.05),
//                             blurRadius: 6,
//                             offset: const Offset(0, 2),
//                           ),
//                         ],
//                       ),
//                       child: IntrinsicHeight(
//                         child: Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             // Image
//                             Padding(
//                               padding: const EdgeInsets.all(8.0),
//                               child: Card(
//                                 color: Colors.white,
//                                 child: ClipRRect(
//                                   borderRadius: BorderRadius.circular(8.0),
//                                   child: Image.network(
//                                     data.imageUrl,
//                                     height: 90.0,
//                                     width: 90.0,
//                                     fit: BoxFit.contain,
//                                     errorBuilder:
//                                         (context, error, stackTrace) =>
//                                             Container(
//                                       height: 90.0,
//                                       width: 90.0,
//                                       color: Colors.grey.shade200,
//                                       child: const Icon(
//                                         Icons.person,
//                                         color: Colors.grey,
//                                         size: 40,
//                                       ),
//                                     ),
//                                     loadingBuilder:
//                                         (context, child, loadingProgress) {
//                                       if (loadingProgress == null) return child;
//                                       return Container(
//                                         height: 90.0,
//                                         width: 90.0,
//                                         alignment: Alignment.center,
//                                         child: const CircularProgressIndicator(
//                                             strokeWidth: 2),
//                                       );
//                                     },
//                                   ),
//                                 ),
//                               ),
//                             ),
//
//                             Expanded(
//                               child: Padding(
//                                 padding: const EdgeInsets.all(12),
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       data.title,
//                                       style: const TextStyle(
//                                           fontSize: 15,
//                                           color:
//                                               ColorResource.lightSecondaryColor,
//                                           fontWeight: FontWeight.w600),
//                                     ),
//                                     const SizedBox(height: 6),
//                                     Expanded(
//                                       child: Text(
//                                         data.description,
//                                         maxLines: 2,
//                                         overflow: TextOverflow.ellipsis,
//                                         style: TextStyle(
//                                             fontSize: 12,
//                                             fontWeight: FontWeight.w500,
//                                             color: Colors.grey.shade700),
//                                       ),
//                                     ),
//                                     const SizedBox(height: 8),
//                                     Wrap(
//                                       children: _buildInfoChip(tags: data.tags),
//                                     ),
//                                     const Align(
//                                       alignment: Alignment.centerRight,
//                                       child: Icon(Icons.arrow_forward_rounded,
//                                           size: 18, color: Color(0xFF4854FE)),
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 );
//               },
//             ));
// }
//
// List<Widget> _buildInfoChip({List<String>? tags}) {
//   if (tags == null || tags.isEmpty) return [];
//
//   return List.generate(tags.length, (index) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Text(
//             tags[index] ?? "",
//             style: TextStyle(
//               fontSize: 10,
//               fontWeight: FontWeight.w500,
//               color: Colors.grey.shade700,
//             ),
//           ),
//           const SizedBox(width: 4),
//         ],
//       ),
//     );
//     ;
//   });
// }
//
// List<Widget> buildInfoChip({List<String>? tags}) {
//   if (tags == null || tags.isEmpty) return [];
//
//   return List.generate(tags.length, (index) {
//     return Container(
//       padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//       decoration: BoxDecoration(
//         color: Colors.grey.shade100,
//         borderRadius: BorderRadius.circular(8),
//       ),
//       child: Row(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           Icon(
//             Icons.error,
//             size: 14,
//             color: Colors.grey.shade400,
//           ),
//           const SizedBox(
//             width: 8,
//           ),
//           const Text(
//             'Scheduling Awaited',
//             style: TextStyle(
//               fontSize: 11,
//               fontWeight: FontWeight.w500,
//             ),
//           ),
//           const SizedBox(width: 4),
//         ],
//       ),
//     );
//     ;
//   });
// }
//
// class UserGreetingWidget extends StatelessWidget {
//   final String? title;
//   final double titleFontSize;
//   final double subTitleFontSize;
//
//   UserGreetingWidget({
//     this.title,
//     this.titleFontSize = DimensionResource.fontSizeSmall - 1,
//     this.subTitleFontSize = DimensionResource.fontSizeExtraLarge - 1,
//     super.key,
//   });
//
//   HomeController homeController = Get.put(HomeController());
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Obx(() {
//       return Row(
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 title ?? greeting(),
//                 style: StyleResource.instance.styleLight(
//                     color: hexToColor(homeController
//                         .homeData.value.homepageUi?.userGreetingColor),
//                     fontSize: screenWidth < 500
//                         ? titleFontSize
//                         : DimensionResource.fontSizeLarge),
//               ),
//               Text(
//                 Get.find<AuthService>().user.value.name == null
//                     ? "User"
//                     : Get.find<AuthService>()
//                         .user
//                         .value
//                         .name
//                         .toString()
//                         .capitalize!,
//                 style: StyleResource.instance.styleMedium(
//                     color: hexToColor(homeController
//                         .homeData.value.homepageUi?.userNameColor),
//                     fontSize: screenWidth < 500
//                         ? subTitleFontSize
//                         : DimensionResource.fontSizeOverLarge),
//                 overflow: TextOverflow.ellipsis,
//               ),
//             ],
//           ),
//           const Spacer(),
//           InkWell(
//             onTap: () {
//               if (!Get.find<AuthService>().isGuestUser.value) {
//                 Get.toNamed(Routes.profileScreen);
//               } else {
//                 ProgressDialog().showFlipDialog(isForPro: false);
//               }
//             },
//             child: imageCircleContainer(
//                 radius: screenWidth < 500 ? 19 : 25,
//                 url: Get.find<AuthService>().user.value.profileImage ?? ""),
//           ),
//         ],
//       );
//     });
//   }
//
//   String greeting() {
//     var hour = DateTime.now().hour;
//     if (hour < 12) {
//       return StringResource.goodMorning;
//     }
//     if (hour < 17) {
//       return StringResource.goodAfternoon;
//     }
//     return StringResource.goodEvening;
//   }
// }
//
// Color hexToColor(String? hexColor) {
//   if (hexColor == null || hexColor.isEmpty) {
//     return Colors.white; // Default fallback color
//   }
//   hexColor = hexColor.replaceAll("#", "");
//   if (hexColor.length == 6) {
//     hexColor = "FF$hexColor"; // Add alpha value if not provided
//   }
//   try {
//     return Color(int.parse("0x$hexColor"));
//   } catch (e) {
//     print("Invalid hex color: $hexColor");
//     return Colors.transparent; // Default fallback color
//   }
// }
//
// CachedNetworkImage cachedNetworkImage(String url,
//     {BoxFit fit = BoxFit.cover,
//     Color? color,
//     bool imageLoader = false,
//     Alignment? alignment}) {
//   return CachedNetworkImage(
//       imageUrl: url,
//       fit: fit,
//       alignment: alignment ?? Alignment.center,
//       placeholder: (context, url) => imageLoader
//           ? const CommonCircularIndicator()
//           : ShimmerEffect.instance.imageLoader(color: color),
//       errorWidget: (context, url, error) {
//         if (kDebugMode) {
//           logPrint('network image error: $error');
//         }
//         return imageLoader
//             ? const CommonCircularIndicator()
//             : Container(
//                 color: color ?? ColorResource.imageBackground,
//                 padding: const EdgeInsets.all(22.0),
//                 child: Image.asset(
//                   ImageResource.instance.errorImage,
//                   fit: BoxFit.contain,
//                 ),
//               );
//       });
// }
//
// Widget imageCircleContainer(
//     {required double radius,
//     String url = ImageResource.defaultUser,
//     bool showDot = false}) {
//   return Stack(
//     children: [
//       CircleAvatar(
//         radius: radius,
//         backgroundImage: NetworkImage(url),
//         onBackgroundImageError: (e, s) {},
//         // child:  ClipRRect(
//         //   clipBehavior: Clip.antiAliasWithSaveLayer,
//         //     borderRadius: BorderRadius.circular(0),
//         //     child: cachedNetworkImage(url,fit: BoxFit.fill)),
//       ),
//       Visibility(
//         visible: showDot,
//         child: const Positioned(
//             bottom: 0,
//             right: 0,
//             child: Icon(
//               Icons.circle,
//               color: ColorResource.greenColor,
//               size: 11,
//             )),
//       )
//     ],
//   );
// }
