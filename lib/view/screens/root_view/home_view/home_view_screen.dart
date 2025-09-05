import 'dart:io';
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
import '../../../widgets/button_view/icon_button.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../chat/chat_view.dart';
import '../quiz_view/quiz_list.dart';
import '../web_view/open_web_view.dart';

class HomeViewScreen extends GetView<HomeController> {
  const HomeViewScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    Get.put(HomeController());

    return SafeArea(
      top: false,
      bottom: false,
      // bottom: Platform.isIOS ? true : false,
      child: Scaffold(
        backgroundColor: ColorResource.white,
        body:
        Container(
          margin: EdgeInsets.only(bottom: Platform.isIOS ? 24 : 0),
          child: Stack(
            children: [
              Obx(
                () => RefreshIndicator(
                  strokeWidth: 2,
                  color: ColorResource.primaryColor,
                  onRefresh: controller.getHomeData,
                  child:
                  CustomScrollView(
                    primary: true,
                    shrinkWrap: false,
                    physics: controller.isDataLoading.value
                        ? const NeverScrollableScrollPhysics()
                        : const ClampingScrollPhysics(),
                    slivers: [
                      SliverAppBar(
                        expandedHeight: screenWidth<500?250:280,
                        collapsedHeight: 45,
                        toolbarHeight: 45,
                        automaticallyImplyLeading: false,
                        titleSpacing: DimensionResource.marginSizeDefault,
                        title: SizedBox(
                          height: 50,
                          width: double.infinity,
                          child: Row(
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
                              const Spacer(),
                              const SizedBox(
                                width: DimensionResource.marginSizeSmall,
                              ),

                              /// Notificaton button
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

                                    /// Setting count to 0 so it doesnt show when notification closed.
                                    controller
                                        .notificationCountData.value.count = 0;

                                    /// changing the value to hide badge.
                                    controller.isShow.value = false;
                                  },
                                  showGreenDot: dotValue != null &&
                                          controller.isShow.value
                                      ? controller.notificationCountData.value
                                              .count !=
                                          0
                                      : false,

                                  iconSize: screenWidth < 500 ? 17 : 30,

                                  isLeft: false,

                                  /// Value of the badge
                                  greenDotValue: dotValue ?? 0,
                                  icon: ImageResource.instance.notificationIcon,
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
                                            height:
                                                screenWidth < 500 ? 200 : 220,
                                            width: double.infinity,
                                          )
                                        : Image.network(
                                            controller.homeData.value
                                                .homepageUi!.bgImageUrl!,

                                            fit: BoxFit.cover,
                                            height:
                                                screenWidth < 500 ? 200 : 220,

                                            width: double.infinity,
                                          )
                                  ],
                                ),
                              ),
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: screenWidth < 500
                                              ? DimensionResource
                                                  .marginSizeDefault
                                              : DimensionResource
                                                      .marginSizeLarge -
                                                  3),
                                      child: UserGreetingWidget(),
                                    ),
                                    SizedBox(
                                      height: screenWidth < 500
                                          ? DimensionResource.marginSizeSmall +
                                              3
                                          : DimensionResource
                                                  .marginSizeDefault -
                                              15,
                                    ),
                                    Container(

                                      height: screenWidth < 500 ? 130 : 180,
                                        width: screenWidth<500 ? double.infinity:700,

                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(15)),
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Obx(() {
                                            return controller.bannerData.value
                                                        .data?.isEmpty ??
                                                    true
                                                ? Padding(
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
                                                  )
                                                : CarouselSlider.builder(
                                                    options: CarouselOptions(
                                                      aspectRatio: 1,
                                                      viewportFraction: 1,
                                                      autoPlay: true,
                                                      enlargeCenterPage: false,
                                                      disableCenter: false,
                                                      onPageChanged:
                                                          (index, reason) {
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
                                                        (context, index, _) {
                                                      DatumDatum dataAtIndex =
                                                          controller.bannerData
                                                                  .value.data
                                                                  ?.elementAt(
                                                                      index) ??
                                                              DatumDatum();
                                                      return InkWell(
                                                        splashColor:
                                                            Colors.transparent,
                                                        onTap: () {
                                                          if (dataAtIndex
                                                                  .bannerType ==
                                                              1) {
                                                            switch (dataAtIndex
                                                                .type) {
                                                              case AppConstants
                                                                    .textCourse:
                                                                Get.toNamed(
                                                                    Routes.textCourseDetail(
                                                                        id: dataAtIndex.bannerableId.toString()),
                                                                    arguments: [
                                                                      "",
                                                                      dataAtIndex
                                                                          .bannerableId
                                                                          .toString()
                                                                    ]);
                                                                break;
                                                              case AppConstants
                                                                    .audioCourse:
                                                                Get.toNamed(
                                                                    Routes.audioCourseDetail(
                                                                        id: dataAtIndex.bannerableId.toString()),
                                                                    arguments: [
                                                                      CourseDetailViewType
                                                                          .audioCourse,
                                                                      dataAtIndex
                                                                          .bannerableId
                                                                          .toString(),
                                                                      "",
                                                                      ""
                                                                    ]);
                                                                break;
                                                              case AppConstants
                                                                    .audioRedirect:
                                                                Get.toNamed(
                                                                    Routes.audioCourseDetail(
                                                                        id: dataAtIndex.bannerableId.toString()),
                                                                    arguments: [
                                                                      CourseDetailViewType
                                                                          .audio,
                                                                      dataAtIndex
                                                                          .bannerableId
                                                                          .toString(),
                                                                      "",
                                                                      ""
                                                                    ]);
                                                                break;
                                                              case AppConstants
                                                                    .videoRedirect:
                                                                AppConstants
                                                                    .instance
                                                                    .singleCourseId
                                                                    .value = (dataAtIndex
                                                                            .bannerableId ??
                                                                        "")
                                                                    .toString();

                                                                Get.toNamed(
                                                                        Routes.continueWatchScreen(
                                                                            id: dataAtIndex.bannerableId.toString()),
                                                                        arguments: [
                                                                      dataAtIndex
                                                                          .bannerableId
                                                                          .toString(),
                                                                      ""
                                                                    ])!
                                                                    .then(
                                                                        (value) {
                                                                  Get.find<
                                                                          HomeController>()
                                                                      .getContinueLearning(
                                                                          isFirst:
                                                                              true);
                                                                });
                                                                break;
                                                              case AppConstants
                                                                    .liveClassBanner:
                                                                AppConstants
                                                                        .instance
                                                                        .liveId
                                                                        .value =
                                                                    (dataAtIndex.bannerableId ??
                                                                            "")
                                                                        .toString();
                                                                Get.toNamed(
                                                                    Routes.liveClassDetail(
                                                                        id: dataAtIndex.bannerableId.toString()),
                                                                    arguments: [
                                                                      false,
                                                                      dataAtIndex
                                                                          .bannerableId
                                                                          .toString()
                                                                    ]);
                                                                break;
                                                              case AppConstants
                                                                    .batchClass:
                                                                AppConstants
                                                                        .instance
                                                                        .batchId
                                                                        .value =
                                                                    (dataAtIndex.bannerableId ??
                                                                            "")
                                                                        .toString();

                                                                Get.toNamed(
                                                                    Routes.batchClassDetails(
                                                                        id: dataAtIndex.bannerableId.toString()),
                                                                    arguments: [
                                                                      false,
                                                                      dataAtIndex
                                                                          .bannerableId
                                                                          .toString()
                                                                    ]);
                                                                break;
                                                              case AppConstants
                                                                    .upcomingBatch:
                                                                final bannerableId =
                                                                    dataAtIndex
                                                                        .bannerableId;
                                                                print(
                                                                    'Bannerable ID: $bannerableId');

                                                                if (bannerableId ==
                                                                    null) {
                                                                  print(
                                                                      'Error: bannerableId is null.');
                                                                  return; // Exit early if `bannerableId` is null
                                                                }

                                                                // Access the batch data from LiveBatchesController
                                                                final displayList =
                                                                    Get.find<
                                                                            LiveBatchesController>()
                                                                        .batchData
                                                                        .value
                                                                        .data;

                                                                if (displayList ==
                                                                        null ||
                                                                    displayList
                                                                        .isEmpty) {
                                                                  print(
                                                                      'Error: No batch data available.');
                                                                  return; // Exit early if `displayList` is null or empty
                                                                }

                                                                // Find the matching batch data based on the ID
                                                                final matchingData =
                                                                    displayList
                                                                        .where(
                                                                            (batchData) {
                                                                  return batchData
                                                                          .id
                                                                          .toString() ==
                                                                      bannerableId; // Ensure proper type comparison
                                                                }).toList();

                                                                if (matchingData
                                                                    .isEmpty) {
                                                                  print(
                                                                      'Error: No matching data found for bannerableId: $bannerableId');
                                                                  return; // Exit early if no matching data is found
                                                                }

                                                                // Navigate to the batch details route with the matched data
                                                                Get.toNamed(
                                                                  Routes
                                                                      .batchDetails,
                                                                  arguments: [
                                                                    matchingData
                                                                        .first, // Pass the first matched BatchData object
                                                                    false, // isPast flag
                                                                  ],
                                                                );

                                                                break;
                                                              case AppConstants
                                                                    .pastBatch:
                                                                final bannerableId =
                                                                    dataAtIndex
                                                                        .bannerableId;
                                                                print(
                                                                    'Bannerable ID: $bannerableId');

                                                                if (bannerableId ==
                                                                    null) {
                                                                  print(
                                                                      'Error: bannerableId is null.');
                                                                  return; // Exit early if `bannerableId` is null
                                                                }

                                                                // Access the batch data from PastClassesController
                                                                final displayList =
                                                                    Get.find<
                                                                            PastClassesController>()
                                                                        .batchData
                                                                        .value
                                                                        .data;

                                                                if (displayList ==
                                                                        null ||
                                                                    displayList
                                                                        .isEmpty) {
                                                                  print(
                                                                      'Error: No batch data available.');
                                                                  return; // Exit early if `displayList` is null or empty
                                                                }

                                                                // Find the matching batch data based on the ID
                                                                final matchingData =
                                                                    displayList
                                                                        .where(
                                                                            (batchData) {
                                                                  return batchData
                                                                          .id
                                                                          .toString() ==
                                                                      bannerableId; // Ensure proper type comparison
                                                                }).toList();

                                                                if (matchingData
                                                                    .isEmpty) {
                                                                  print(
                                                                      'Error: No matching data found for bannerableId: $bannerableId');
                                                                  return; // Exit early if no matching data is found
                                                                }

                                                                // Navigate to the batch details route with the matched data
                                                                Get.toNamed(
                                                                  Routes
                                                                      .batchDetails,
                                                                  arguments: [
                                                                    matchingData
                                                                        .first, // Pass the first matched BatchData object
                                                                    true, // isPast flag
                                                                  ],
                                                                );
                                                                break;
                                                              case AppConstants
                                                                    .upcomingLiveClass:
                                                                if (dataAtIndex
                                                                        .bannerableId !=
                                                                    null) {
                                                                  AppConstants
                                                                          .instance
                                                                          .batchId
                                                                          .value =
                                                                      (dataAtIndex
                                                                          .bannerableId
                                                                          .toString())!;
                                                                  Get.toNamed(
                                                                      Routes.batchClassDetails(
                                                                          id: dataAtIndex.bannerableId.toString()),
                                                                      arguments: [
                                                                        false,
                                                                        dataAtIndex
                                                                            .bannerableId
                                                                            .toString()
                                                                      ]);
                                                                } else {
                                                                  AppConstants
                                                                          .instance
                                                                          .liveId
                                                                          .value =
                                                                      (dataAtIndex
                                                                          .bannerableId
                                                                          .toString())!;
                                                                  Get.toNamed(
                                                                      Routes.liveClassDetail(
                                                                          id: dataAtIndex.bannerableId.toString()),
                                                                      arguments: [
                                                                        false,
                                                                        dataAtIndex
                                                                            .bannerableId
                                                                            .toString()
                                                                      ]);
                                                                }
                                                                break;
                                                              case AppConstants
                                                                    .pastLiveClass:
                                                                if (dataAtIndex
                                                                        .bannerableId !=
                                                                    null) {
                                                                  AppConstants
                                                                          .instance
                                                                          .liveId
                                                                          .value =
                                                                      (dataAtIndex
                                                                          .bannerableId
                                                                          .toString())!;
                                                                  Get.toNamed(
                                                                      Routes.liveClassDetail(
                                                                          id: dataAtIndex.bannerableId.toString()),
                                                                      arguments: [
                                                                        true,
                                                                        dataAtIndex
                                                                            .bannerableId
                                                                            .toString()
                                                                      ]);
                                                                } else {
                                                                  AppConstants
                                                                          .instance
                                                                          .liveId
                                                                          .value =
                                                                      (dataAtIndex
                                                                          .bannerableId
                                                                          .toString())!;
                                                                  Get.toNamed(
                                                                      Routes.liveClassDetail(
                                                                          id: dataAtIndex.bannerableId.toString()),
                                                                      arguments: [
                                                                        false,
                                                                        dataAtIndex
                                                                            .bannerableId
                                                                            .toString()
                                                                      ]);
                                                                }
                                                                break;

                                                              case AppConstants
                                                                    .blogRedirect:
                                                                AppConstants
                                                                        .instance
                                                                        .blogId
                                                                        .value =
                                                                    (dataAtIndex.bannerableId ??
                                                                            "")
                                                                        .toString();

                                                                Get.toNamed(
                                                                    Routes.blogsView(
                                                                        id: dataAtIndex.bannerableId.toString()),
                                                                    arguments: [
                                                                      dataAtIndex
                                                                          .bannerableId
                                                                          .toString(),
                                                                      ""
                                                                    ]);
                                                                break;
                                                              case AppConstants
                                                                    .quizRedirect:
                                                                Get.toNamed(
                                                                    Routes
                                                                        .quizMainView,
                                                                    arguments: {
                                                                      "id": dataAtIndex
                                                                          .bannerableId
                                                                          .toString(),
                                                                      "??": "",
                                                                      "quiz_type": dataAtIndex.isScholarship == 1
                                                                          ? QuizType
                                                                              .scholarship
                                                                          : QuizType
                                                                              .free,
                                                                      "is_timeup":
                                                                          false,
                                                                      "is_fromHome":
                                                                          true
                                                                    });
                                                                break;
                                                              case AppConstants
                                                                    .subscription:
                                                                if (Platform
                                                                    .isAndroid) {
                                                                  Get.toNamed(Routes
                                                                      .subscriptionView);
                                                                }
                                                                break;
                                                              case AppConstants
                                                                    .upcomingBatchClass:
                                                                Get.find<
                                                                        RootViewController>()
                                                                    .selectedTab
                                                                    .value = 2;
                                                                break;
                                                              case AppConstants
                                                                    .pastBatchPage:
                                                                Get.find<
                                                                        LiveBatchesController>()
                                                                    .isTabValueChange
                                                                    .value = true;

                                                                Get.find<
                                                                        RootViewController>()
                                                                    .selectedTab
                                                                    .value = 2;
                                                                Get.find<
                                                                        LiveBatchesController>()
                                                                    .tabChange();
                                                                break;
                                                              case AppConstants
                                                                    .mentorshipClass:
                                                                Get.toNamed(
                                                                  Routes
                                                                      .mentorshipDetail(
                                                                    id: dataAtIndex
                                                                        .bannerableId
                                                                        .toString(),
                                                                  ),
                                                                  arguments: {
                                                                    'id': dataAtIndex
                                                                        .bannerableId
                                                                        .toString(),
                                                                  },
                                                                );
                                                                break;
                                                              case AppConstants
                                                                    .upcomingWebinarPage:
                                                                Get.find<
                                                                        RootViewController>()
                                                                    .selectedTab
                                                                    .value = 3;
                                                                break;
                                                              case AppConstants
                                                                    .pastWebinarPage:
                                                                Get.find<
                                                                        LiveClassesController>()
                                                                    .isTabValueChange
                                                                    .value = true;

                                                                Get.find<
                                                                        RootViewController>()
                                                                    .selectedTab
                                                                    .value = 3;
                                                                Get.find<
                                                                        LiveClassesController>()
                                                                    .tabChange();
                                                                Get.find<
                                                                        PastClassesController>()
                                                                    .onRefresh();
                                                                break;
                                                              case AppConstants
                                                                    .mentorshipPage:
                                                                Get.find<
                                                                        RootViewController>()
                                                                    .selectedTab
                                                                    .value = 1;
                                                                break;

                                                              default:
                                                                AppConstants
                                                                    .instance
                                                                    .videoCourseId
                                                                    .value = (dataAtIndex
                                                                            .bannerableId ??
                                                                        "")
                                                                    .toString();
                                                                Get.toNamed(
                                                                    Routes.videoCourseDetail(
                                                                        id: dataAtIndex.bannerableId.toString()),
                                                                    arguments: [
                                                                      "",
                                                                      dataAtIndex
                                                                          .bannerableId
                                                                          .toString()
                                                                    ]);
                                                                break;
                                                            }
                                                          } else {
                                                            if (dataAtIndex
                                                                    .url !=
                                                                null) {
                                                              Navigator.of(Get
                                                                      .context!)
                                                                  .push(MaterialPageRoute(
                                                                      builder: (context) => OpenWebView(
                                                                          url: dataAtIndex.url ??
                                                                              "",
                                                                          title:
                                                                              dataAtIndex.title ?? "")));
                                                            }
                                                          }
                                                        },
                                                        child: Container(
                                                            padding: const EdgeInsets
                                                                .symmetric(
                                                                horizontal:
                                                                    DimensionResource
                                                                        .marginSizeDefault),
                                                            width:
                                                                double.infinity,
                                                            child: ClipRRect(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          15),
                                                              child: Stack(
                                                                //fit: StackFit.expand,
                                                                children: [
                                                                  Positioned(
                                                                    top: 0,
                                                                    bottom: 0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    child: cachedNetworkImage(
                                                                        dataAtIndex.image ??
                                                                            "",
                                                                        fit: BoxFit
                                                                            .fill),
                                                                  ),
                                                                  Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomLeft,
                                                                    child:
                                                                        Container(
                                                                      margin: const EdgeInsets
                                                                          .only(
                                                                        bottom:
                                                                            DimensionResource.marginSizeDefault +
                                                                                10,
                                                                        left: DimensionResource
                                                                            .marginSizeDefault,
                                                                        right: DimensionResource
                                                                            .marginSizeDefault,
                                                                      ),
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              3),
                                                                          color:
                                                                              ColorResource.white),
                                                                      padding: const EdgeInsets
                                                                          .symmetric(
                                                                          horizontal:
                                                                              5,
                                                                          vertical:
                                                                              3),
                                                                      child:
                                                                          Text(
                                                                        dataAtIndex.title ??
                                                                            "",
                                                                        style: StyleResource
                                                                            .instance
                                                                            .styleLight(fontSize: screenWidth < 500 ? DimensionResource.fontSizeExtraSmall : DimensionResource.fontSizeDefault),
                                                                        maxLines:
                                                                            1,
                                                                        overflow:
                                                                            TextOverflow.ellipsis,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Visibility(
                                                                    visible: dataAtIndex.isPromotional !=
                                                                            null &&
                                                                        dataAtIndex.isPromotional ==
                                                                            1,
                                                                    child:
                                                                        Align(
                                                                      alignment:
                                                                          Alignment
                                                                              .topLeft,
                                                                      child:
                                                                          Container(
                                                                        margin:
                                                                            const EdgeInsets.only(
                                                                          top: DimensionResource
                                                                              .marginSizeDefault,
                                                                          left:
                                                                              DimensionResource.marginSizeDefault,
                                                                          right:
                                                                              DimensionResource.marginSizeDefault,
                                                                        ),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(3),
                                                                            color: ColorResource.white),
                                                                        padding: const EdgeInsets
                                                                            .symmetric(
                                                                            horizontal:
                                                                                5,
                                                                            vertical:
                                                                                3),
                                                                        child:
                                                                            Text(
                                                                          "Promotional",
                                                                          style: StyleResource
                                                                              .instance
                                                                              .styleLight(fontSize: DimensionResource.fontSizeExtraSmall - 2),
                                                                          maxLines:
                                                                              1,
                                                                          overflow:
                                                                              TextOverflow.ellipsis,
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            )),
                                                      );
                                                    },
                                                  );
                                          }),
                                          Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Obx(() => Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          bottom: 10),
                                                  child: Row(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: List.generate(
                                                          controller
                                                                  .bannerData
                                                                  .value
                                                                  .data
                                                                  ?.length ??
                                                              0, (index) {
                                                        return AnimatedContainer(
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            horizontal: 2,
                                                          ),
                                                          duration:
                                                              const Duration(
                                                                  milliseconds:
                                                                      300),
                                                          height: controller
                                                                      .currentIndex
                                                                      .value ==
                                                                  index
                                                              ? 10
                                                              : 7,
                                                          width: controller
                                                                      .currentIndex
                                                                      .value ==
                                                                  index
                                                              ? 10
                                                              : 7,
                                                          decoration:
                                                              BoxDecoration(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15),
                                                            color: controller
                                                                        .currentIndex
                                                                        .value ==
                                                                    index
                                                                ? ColorResource
                                                                    .yellowColor
                                                                : ColorResource
                                                                    .white,
                                                          ),
                                                        );
                                                      })),
                                                )),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SliverToBoxAdapter(
                        child: Obx(() => Stack(
                              children: [
                                // ?
                                AnimatedOpacity(
                                  duration: AppConstants.instance.slow,
                                  opacity:
                                      controller.isDataLoading.value ? 1 : 0,
                                  child: Center(
                                    child: ShimmerEffect.instance.homeLoader(),
                                  ),
                                ),
                                AnimatedOpacity(
                                  duration: AppConstants.instance.slow,
                                  opacity:
                                      controller.isDataLoading.value ? 0 : 1,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: screenWidth < 500
                                            ? DimensionResource
                                                .marginSizeExtraSmall
                                            : DimensionResource
                                                .marginSizeLarge),
                                    child: Wrap(
                                      children: controller.itemList,
                                    ),
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ],
                  ),
                ),
              ),
              Obx(() {
                return Visibility(
                  visible: controller.showFlicker.value,
                  //duration: const Duration(milliseconds: 300),
                  child: SizedBox(
                      height: Get.height,
                      width: Get.width,
                      child: Lottie.asset(
                        ImageResource.instance.partCelebrations,
                        fit: BoxFit.fill,
                      )),
                );
              })
            ],
          ),
        ),
      ),
    );
  }
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

Widget rowTile(
  Function()? onTap,
  String title, {
  bool showIcon = true,
  bool enablePadding = true,
  bool enableTopPadding = true,
  bool enableBottomPadding = true,
  TextStyle? labelStyle,
  bool isDark = false,
  Color splashColor = ColorResource.white,
  Widget? button,
  Widget? titleWidget,
}) {
  return InkWell(
    splashColor: splashColor,
    onTap: onTap,
    child: Padding(
      padding: EdgeInsets.only(
          left: enablePadding ? DimensionResource.marginSizeDefault : 0,
          right: enablePadding ? DimensionResource.marginSizeDefault : 0,
          top: enableTopPadding ? DimensionResource.marginSizeSmall + 3 : 0,
          bottom:
              enableBottomPadding ? DimensionResource.marginSizeSmall - 3 : 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          titleWidget ??
              Container(
                constraints: BoxConstraints(
                    maxWidth: MediaQuery.of(Get.context!).size.width * 0.7),
                child: Text(
                  title,
                  style: labelStyle ??
                      StyleResource.instance.styleSemiBold().copyWith(
                          fontSize: MediaQuery.of(Get.context!).size.width < 500
                              ? DimensionResource.fontSizeDefault - 1
                              : DimensionResource.fontSizeDoubleExtraLarge,
                          color: isDark
                              ? ColorResource.white
                              : ColorResource.secondaryColor,
                          letterSpacing: .3),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
              ),
          Visibility(
            visible: showIcon,
            child: button ??
                Row(
                  children: [
                    Text(
                      "SEE ALL",
                      style: StyleResource.instance.styleMedium(
                          fontSize: MediaQuery.of(Get.context!).size.width < 500
                              ? DimensionResource.marginSizeSmall + 1
                              : DimensionResource.marginSizeLarge - 2,
                          color: ColorResource.primaryColor),
                    ),
                    Icon(
                      Icons.arrow_forward_ios,
                      color: ColorResource.primaryColor,
                      size: MediaQuery.of(Get.context!).size.width < 500
                          ? 12
                          : 18,
                    )
                  ],
                ),
          ),
        ],
      ),
    ),
  );
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
