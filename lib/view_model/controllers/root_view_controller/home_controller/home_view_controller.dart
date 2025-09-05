import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stockpathshala_beta/model/models/account_models/language_model.dart'
    as lang;
import 'package:stockpathshala_beta/model/models/home_data_model/home_data_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:stockpathshala_beta/model/utils/helper_util.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/home_continue_learning_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/live_batches_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/past_batch_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/past_webinar_classes.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/batch_controller/live_batch_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/profile_controller/profile_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart' hide DropDownData;
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stockpathshala_beta/model/models/account_models/language_model.dart'
as lang;
import 'package:stockpathshala_beta/model/models/account_models/level_model.dart'
as level;
import 'package:stockpathshala_beta/model/models/auth_models/sign_in.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/account_provider.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stockpathshala_beta/model/models/account_models/language_model.dart'
as lang;
import 'package:stockpathshala_beta/model/models/account_models/level_model.dart'
as level;
import 'package:stockpathshala_beta/model/models/auth_models/sign_in.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/account_provider.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../model/models/account_models/level_model.dart';
import '../../../../model/models/batch_models/all_batch_model.dart';
import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/home_data_model/continue_learning_model.dart'
    as cont;
import '../../../../model/models/home_data_model/notification_count.dart'
    as count;
import '../../../../model/network_calls/api_helper/provider_helper/account_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/utils/app_constants.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view/screens/root_view/home_view/widget/audio_course_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/audio_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/blogs_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/continue_learning_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/live_classes_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/quiz_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/scalps_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/text_course_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/top_past_live_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/trending_courses_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/video_course_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/videos_widget.dart';
import '../../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../../../view/screens/root_view/quiz_view/quiz_list.dart';
import '../../../../view/screens/root_view/web_view/open_web_view.dart';
import '../../../../view/widgets/image_provider/image_provider.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../../../../view/widgets/view_helpers/progress_dialog.dart';
import '../../../routes/app_pages.dart';
import '../course_detail_controller/course_detail_controller.dart';
import '../root_view_controller.dart';
import '../scalp_controller/scalp_controller.dart';




class HomeController extends GetxController {
  final Rx<GlobalKey<AnimatedListState>> listKey =
      GlobalKey<AnimatedListState>().obs;
  AccountProvider accountProvider = getIt();
  RxBool isDataLoading = false.obs;
  RxBool showFlicker = false.obs;
  HomeProvider homeProvider = getIt();
  Rx<LevelModel> levelData = LevelModel().obs;
  Rx<HomeDataModel> homeData = HomeDataModel().obs;
  Rx<HomeDataModelDatum> bannerData = HomeDataModelDatum().obs;
  Rx<cont.GetContinueData> continueData = cont.GetContinueData().obs;
  List continueDataList = <cont.Datum>[].obs;

  final GetStorage box = GetStorage();
  Rx<HomeDataModelDatum> trendingData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> scalpData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> liveData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> topData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> quizData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> videoCoursesData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> audioCoursesData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> textCoursesData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> videoData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> audioData = HomeDataModelDatum().obs;
  Rx<HomeDataModelDatum> blogData = HomeDataModelDatum().obs;
  Rx<Datum> selectedLevel = Datum(id: 1, level: "Beginner").obs;
  Rx<lang.LanguageModel> languageData = lang.LanguageModel().obs;
  Rx<count.NotificationCountModel> notificationCountData =
      count.NotificationCountModel().obs;
  RxBool isLevelLoading = false.obs;
  RxBool isLangLoading = false.obs;
  RxInt currentIndex = 0.obs;
  RxList<Widget> itemList = <Widget>[].obs;

  /// For Notification badge, changes to false on notification route.
  /// the logic is in the view of bell button.
  RxBool isShow = true.obs;
  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  // JustTheController justTheController = JustTheController();

  @override
  void onInit() async {
    if (Get.find<AuthService>().user.value.levelId != null) {
      selectedLevel.value = Datum(
          id: Get.find<AuthService>().user.value.levelId,
          level: Get.find<AuthService>().user.value.level?['level']);
    }

    await getHomeData();
    super.onInit();
  }

  Future getContinueLearning({bool isFirst = false}) async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      isLangLoading(true);
      await homeProvider.getContinueLearning(onError: (message, errorMap) {
        //toastShow(message: message);
        isLangLoading(false);
      }, onSuccess: (message, map) {
        continueData.value = cont.GetContinueData.fromJson(map!);
        if (continueData.value.data?.data?.isNotEmpty ?? false) {
          continueDataList.clear();
          continueDataList.addAll(continueData.value.data?.data ?? []);
          if (!isFirst) {
            if (continueData.value.data?.data?.isNotEmpty ?? false) {
              itemList.insert(
                  itemList.length, const CountinueLearningContainerWidget());
            }
          }
        }
        isLangLoading(false);
      });
    }
  }

  Future<void> getHomeData() async {
    logPrint("user token ${box.read(StringResource.instance.token)}");

    isDataLoading.value = true;
    itemList.clear();

    // if (!Get.find<AuthService>().isGuestUser.value) {
    //   Get.find<RootViewController>().getProfile();
    // }

    await homeProvider.getHomeData(
        levelId: selectedLevel.value.id.toString(),
        onError: (message, errorMap) {
          toastShow(message: message);
          isDataLoading.value = false;
          logPrint("error in home");
        },
        onSuccess: (message, json) async {
          homeData.value = HomeDataModel.fromJson(json ?? {});
          Future.delayed(const Duration(milliseconds: 2500), () {
            showFlicker.value = false;
          });
          bannerData.value = homeData.value.data?.firstWhere(
                  (element) => element.key == 'banner_carousel',
                  orElse: () => HomeDataModelDatum()) ??
              HomeDataModelDatum();
          for (HomeDataModelDatum homeDataModelDatum
              in homeData.value.data ?? []) {
            if (homeDataModelDatum.key == 'banner_carousel' &&
                homeDataModelDatum.isActive == 1) {
              bannerData.value = homeDataModelDatum;
            } else if (homeDataModelDatum.key == 'banner_middle' &&
                homeDataModelDatum.isActive == 1) {
              print("lfkjlkwdjfkldwjfkljfg");
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(GestureDetector(
                  onTap: () {
                    if (homeDataModelDatum.data?.first.bannerableId == null) {
                      if (homeDataModelDatum.data?.first.type ==
                              "upcoming_batch_page" &&
                          homeDataModelDatum.data?.first.pageType ==
                              "upcoming") {
                        Get.find<RootViewController>().selectedTab.value = 3;
                      } else if (homeDataModelDatum.data?.first.type ==
                              "past_batch_page" &&
                          homeDataModelDatum.data?.first.pageType == "past") {
                        // print(
                        //     "sdlkjfjksdhfkj ${homeDataModelDatum.data?.first.type}");

                        // print(
                        //     "sdlkjfjksdhfkj ${homeDataModelDatum.data?.first.type}");
                        Get.find<LiveBatchesController>()
                            .isTabValueChange
                            .value = true;

                        Get.find<RootViewController>().selectedTab.value = 3;
                        Get.find<LiveBatchesController>().tabChange();
                      } else if (homeDataModelDatum.data?.first.type ==
                              "upcoming_webinar_page" &&
                          homeDataModelDatum.data?.first.pageType ==
                              "upcoming") {
                        print(
                            "sdlkjfjksdhfkj ${homeDataModelDatum.data?.first.type}");
                        Get.find<RootViewController>().selectedTab.value = 2;
                      } else if (homeDataModelDatum.data?.first.type ==
                              "past_webinar_page" &&
                          homeDataModelDatum.data?.first.pageType == "past") {
                        Get.find<LiveClassesController>()
                            .isTabValueChange
                            .value = true;

                        Get.find<RootViewController>().selectedTab.value = 2;
                        Get.find<LiveClassesController>().tabChange();
                        Get.find<PastClassesController>().onRefresh();
                      } else if (homeDataModelDatum.data?.first.type ==
                          "mentorship_page") {
                        print(
                            "sdlkjfjksdhfkj ${homeDataModelDatum.data?.first.type}");
                        Get.find<RootViewController>().selectedTab.value = 1;
                      }
                    } else {
                      if (homeDataModelDatum.data?.first.bannerableType ==
                              "App\\Models\\Batch" &&
                          homeDataModelDatum.data?.first.bannerableId != null) {
                        final bannerableId =
                            homeDataModelDatum.data?.first.bannerableId;

                        if (homeDataModelDatum.data?.first.type ==
                            "upcoming_batch") {
                          final bannerableId =
                              homeDataModelDatum.data?.first.bannerableId;
                          print('Bannerable ID: $bannerableId');

                          if (bannerableId == null) {
                            print('Error: bannerableId is null.');
                            return; // Exit early if `bannerableId` is null
                          }

                          // Access the batch data from LiveBatchesController
                          final displayList = Get.find<LiveBatchesController>()
                              .batchData
                              .value
                              .data;

                          if (displayList == null || displayList.isEmpty) {
                            print('Error: No batch data available.');
                            return; // Exit early if `displayList` is null or empty
                          }

                          // Find the matching batch data based on the ID
                          final matchingData = displayList.where((batchData) {
                            return batchData.id.toString() ==
                                bannerableId; // Ensure proper type comparison
                          }).toList();

                          if (matchingData.isEmpty) {
                            print(
                                'Error: No matching data found for bannerableId: $bannerableId');
                            return; // Exit early if no matching data is found
                          }

                          // Navigate to the batch details route with the matched data
                          Get.toNamed(
                            Routes.batchDetails,
                            arguments: [
                              matchingData
                                  .first, // Pass the first matched BatchData object
                              false, // isPast flag
                            ],
                          );
                        } else if (homeDataModelDatum.data?.first.type ==
                            "past_batch") {
                          final bannerableId =
                              homeDataModelDatum.data?.first.bannerableId;
                          print('Bannerable ID: $bannerableId');

                          if (bannerableId == null) {
                            print('Error: bannerableId is null.');
                            return; // Exit early if `bannerableId` is null
                          }

                          // Access the batch data from PastClassesController
                          final displayList = Get.find<PastClassesController>()
                              .batchData
                              .value
                              .data;

                          if (displayList == null || displayList.isEmpty) {
                            print('Error: No batch data available.');
                            return; // Exit early if `displayList` is null or empty
                          }

                          // Find the matching batch data based on the ID
                          final matchingData = displayList.where((batchData) {
                            return batchData.id.toString() ==
                                bannerableId; // Ensure proper type comparison
                          }).toList();

                          if (matchingData.isEmpty) {
                            print(
                                'Error: No matching data found for bannerableId: $bannerableId');
                            return; // Exit early if no matching data is found
                          }

                          // Navigate to the batch details route with the matched data
                          Get.toNamed(
                            Routes.batchDetails,
                            arguments: [
                              matchingData
                                  .first, // Pass the first matched BatchData object
                              true, // isPast flag
                            ],
                          );
                        }
                      } else if ((homeDataModelDatum
                                  .data?.first.bannerableType ==
                              "App\\Models\\LiveClass" &&
                          homeDataModelDatum.data?.first.bannerableId !=
                              "null")) {
                        if (homeDataModelDatum.data?.first.type ==
                            "upcoming_live_class") {
                          if (homeDataModelDatum.data?.first.bannerableId !=
                              null) {
                            AppConstants.instance.batchId.value =
                                (homeDataModelDatum.data?.first.bannerableId
                                    .toString())!;
                            Get.toNamed(
                                Routes.batchClassDetails(
                                    id: homeDataModelDatum
                                        .data?.first.bannerableId
                                        .toString()),
                                arguments: [
                                  false,
                                  homeDataModelDatum.data?.first.bannerableId
                                      .toString()
                                ]);
                          } else {
                            AppConstants.instance.liveId.value =
                                (homeDataModelDatum.data?.first.bannerableId
                                    .toString())!;
                            Get.toNamed(
                                Routes.liveClassDetail(
                                    id: homeDataModelDatum
                                        .data?.first.bannerableId
                                        .toString()),
                                arguments: [
                                  false,
                                  homeDataModelDatum.data?.first.bannerableId
                                      .toString()
                                ]);
                          }
                        } else if (homeDataModelDatum.data?.first.type ==
                            "past_live_class") {
                          if (homeDataModelDatum.data?.first.bannerableId !=
                              null) {
                            AppConstants.instance.liveId.value =
                                (homeDataModelDatum.data?.first.bannerableId
                                    .toString())!;
                            Get.toNamed(
                                Routes.liveClassDetail(
                                    id: homeDataModelDatum
                                        .data?.first.bannerableId
                                        .toString()),
                                arguments: [
                                  true,
                                  homeDataModelDatum.data?.first.bannerableId
                                      .toString()
                                ]);
                          } else {
                            AppConstants.instance.liveId.value =
                                (homeDataModelDatum.data?.first.bannerableId
                                    .toString())!;
                            Get.toNamed(
                                Routes.liveClassDetail(
                                    id: homeDataModelDatum
                                        .data?.first.bannerableId
                                        .toString()),
                                arguments: [
                                  true,
                                  homeDataModelDatum.data?.first.bannerableId
                                      .toString()
                                ]);
                          }
                        }
                      } else if ((homeDataModelDatum
                                  .data?.first.bannerableType ==
                              "App\\Models\\Mentorship" &&
                          homeDataModelDatum.data?.first.bannerableId !=
                              "null")) {
                        if (homeDataModelDatum.data?.first.type ==
                            "mentorship") {
                          Get.toNamed(
                            Routes.mentorshipDetail(
                              id: homeDataModelDatum.data?.first.bannerableId
                                  .toString(),
                            ),
                            arguments: {
                              'id': homeDataModelDatum.data?.first.bannerableId
                                  .toString(),
                            },
                          );
                        }
                      }
                    }

                    // _gotoBanner(homeDataModelDatum.data?.first ?? DatumDatum());
                  },
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      left: DimensionResource.marginSizeDefault,
                      right: DimensionResource.marginSizeDefault,
                      bottom: DimensionResource.marginSizeSmall + 5,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: cachedNetworkImage(
                              homeDataModelDatum.data?.first.image ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Visibility(
                            visible: homeDataModelDatum
                                        .data?.first.isPromotional !=
                                    null &&
                                homeDataModelDatum.data?.first.isPromotional ==
                                    1,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: DimensionResource.marginSizeDefault,
                                  left: DimensionResource.marginSizeDefault,
                                  right: DimensionResource.marginSizeDefault,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: ColorResource.white),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                child: Text(
                                  'Promotional',
                                  style: StyleResource.instance.styleLight(
                                      fontSize:
                                          DimensionResource.fontSizeExtraSmall -
                                              2),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
              }
            } else if (homeDataModelDatum.key == 'banner_bottom' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(GestureDetector(
                  onTap: () {
                    if (homeDataModelDatum.data?.first.bannerableId == null) {
                      print("lfkjlkwdjfkldwjfklj");
                      if (homeDataModelDatum.data?.first.type ==
                              "upcoming_batch_page" &&
                          homeDataModelDatum.data?.first.pageType ==
                              "upcoming") {
                        Get.find<RootViewController>().selectedTab.value = 2;
                      } else if (homeDataModelDatum.data?.first.type ==
                              "past_batch_page" &&
                          homeDataModelDatum.data?.first.pageType == "past") {
                        // print(
                        //     "sdlkjfjksdhfkj ${homeDataModelDatum.data?.first.type}");

                        // print(
                        //     "sdlkjfjksdhfkj ${homeDataModelDatum.data?.first.type}");
                        Get.find<LiveBatchesController>()
                            .isTabValueChange
                            .value = true;

                        Get.find<RootViewController>().selectedTab.value = 2;
                        Get.find<LiveBatchesController>().tabChange();
                      } else if (homeDataModelDatum.data?.first.type ==
                              "upcoming_webinar_page" &&
                          homeDataModelDatum.data?.first.pageType ==
                              "upcoming") {
                        print(
                            "sdlkjfjksdhfkj ${homeDataModelDatum.data?.first.type}");
                        Get.find<RootViewController>().selectedTab.value = 3;
                      } else if (homeDataModelDatum.data?.first.type ==
                              "past_webinar_page" &&
                          homeDataModelDatum.data?.first.pageType == "past") {
                        Get.find<LiveClassesController>()
                            .isTabValueChange
                            .value = true;

                        Get.find<RootViewController>().selectedTab.value = 3;
                        Get.find<LiveClassesController>().tabChange();
                        Get.find<PastClassesController>().onRefresh();
                      } else if (homeDataModelDatum.data?.first.type ==
                          "mentorship_page") {
                        print(
                            "sdlkjfjksdhfkj ${homeDataModelDatum.data?.first.type}");
                        Get.find<RootViewController>().selectedTab.value = 1;
                      }
                    } else {
                      if (homeDataModelDatum.data?.first.bannerableType ==
                              "App\\Models\\Batch" &&
                          homeDataModelDatum.data?.first.bannerableId != null) {
                        final bannerableId =
                            homeDataModelDatum.data?.first.bannerableId;

                        if (homeDataModelDatum.data?.first.type ==
                            "upcoming_batch") {
                          final bannerableId =
                              homeDataModelDatum.data?.first.bannerableId;
                          print('Bannerable ID: $bannerableId');

                          if (bannerableId == null) {
                            print('Error: bannerableId is null.');
                            return; // Exit early if `bannerableId` is null
                          }

                          // Access the batch data from LiveBatchesController
                          final displayList = Get.find<LiveBatchesController>()
                              .batchData
                              .value
                              .data;

                          if (displayList == null || displayList.isEmpty) {
                            print('Error: No batch data available.');
                            return; // Exit early if `displayList` is null or empty
                          }

                          // Find the matching batch data based on the ID
                          final matchingData = displayList.where((batchData) {
                            return batchData.id.toString() ==
                                bannerableId; // Ensure proper type comparison
                          }).toList();

                          if (matchingData.isEmpty) {
                            print(
                                'Error: No matching data found for bannerableId: $bannerableId');
                            return; // Exit early if no matching data is found
                          }

                          // Navigate to the batch details route with the matched data
                          Get.toNamed(
                            Routes.batchDetails,
                            arguments: [
                              matchingData
                                  .first, // Pass the first matched BatchData object
                              false, // isPast flag
                            ],
                          );
                        } else if (homeDataModelDatum.data?.first.type ==
                            "past_batch") {
                          final bannerableId =
                              homeDataModelDatum.data?.first.bannerableId;
                          print('Bannerable ID: $bannerableId');

                          if (bannerableId == null) {
                            print('Error: bannerableId is null.');
                            return; // Exit early if `bannerableId` is null
                          }

                          // Access the batch data from PastClassesController
                          final displayList = Get.find<PastClassesController>()
                              .batchData
                              .value
                              .data;

                          if (displayList == null || displayList.isEmpty) {
                            print('Error: No batch data available.');
                            return; // Exit early if `displayList` is null or empty
                          }

                          // Find the matching batch data based on the ID
                          final matchingData = displayList.where((batchData) {
                            return batchData.id.toString() ==
                                bannerableId; // Ensure proper type comparison
                          }).toList();

                          if (matchingData.isEmpty) {
                            print(
                                'Error: No matching data found for bannerableId: $bannerableId');
                            return; // Exit early if no matching data is found
                          }

                          // Navigate to the batch details route with the matched data
                          Get.toNamed(
                            Routes.batchDetails,
                            arguments: [
                              matchingData
                                  .first, // Pass the first matched BatchData object
                              true, // isPast flag
                            ],
                          );
                        }
                      } else if ((homeDataModelDatum
                                  .data?.first.bannerableType ==
                              "App\\Models\\LiveClass" &&
                          homeDataModelDatum.data?.first.bannerableId !=
                              "null")) {
                        if (homeDataModelDatum.data?.first.type ==
                            "upcoming_live_class") {
                          if (homeDataModelDatum.data?.first.bannerableId !=
                              null) {
                            AppConstants.instance.batchId.value =
                                (homeDataModelDatum.data?.first.bannerableId
                                    .toString())!;
                            Get.toNamed(
                                Routes.batchClassDetails(
                                    id: homeDataModelDatum
                                        .data?.first.bannerableId
                                        .toString()),
                                arguments: [
                                  false,
                                  homeDataModelDatum.data?.first.bannerableId
                                      .toString()
                                ]);
                          } else {
                            AppConstants.instance.liveId.value =
                                (homeDataModelDatum.data?.first.bannerableId
                                    .toString())!;
                            Get.toNamed(
                                Routes.liveClassDetail(
                                    id: homeDataModelDatum
                                        .data?.first.bannerableId
                                        .toString()),
                                arguments: [
                                  false,
                                  homeDataModelDatum.data?.first.bannerableId
                                      .toString()
                                ]);
                          }
                        } else if (homeDataModelDatum.data?.first.type ==
                            "past_live_class") {
                          if (homeDataModelDatum.data?.first.bannerableId !=
                              null) {
                            AppConstants.instance.liveId.value =
                                (homeDataModelDatum.data?.first.bannerableId
                                    .toString())!;
                            Get.toNamed(
                                Routes.liveClassDetail(
                                    id: homeDataModelDatum
                                        .data?.first.bannerableId
                                        .toString()),
                                arguments: [
                                  true,
                                  homeDataModelDatum.data?.first.bannerableId
                                      .toString()
                                ]);
                          } else {
                            AppConstants.instance.liveId.value =
                                (homeDataModelDatum.data?.first.bannerableId
                                    .toString())!;
                            Get.toNamed(
                                Routes.liveClassDetail(
                                    id: homeDataModelDatum
                                        .data?.first.bannerableId
                                        .toString()),
                                arguments: [
                                  true,
                                  homeDataModelDatum.data?.first.bannerableId
                                      .toString()
                                ]);
                          }
                        }
                      } else if ((homeDataModelDatum
                                  .data?.first.bannerableType ==
                              "App\\Models\\Mentorship" &&
                          homeDataModelDatum.data?.first.bannerableId !=
                              "null")) {
                        if (homeDataModelDatum.data?.first.type ==
                            "mentorship") {
                          Get.toNamed(
                            Routes.mentorshipDetail(
                              id: homeDataModelDatum.data?.first.bannerableId
                                  .toString(),
                            ),
                            arguments: {
                              'id': homeDataModelDatum.data?.first.bannerableId
                                  .toString(),
                            },
                          );
                        }
                      }
                    }

                    // _gotoBanner(homeDataModelDatum.data?.first ?? DatumDatum());
                  },
                  child: Container(
                    height: 110,
                    width: double.infinity,
                    margin: const EdgeInsets.only(
                      left: DimensionResource.marginSizeDefault,
                      right: DimensionResource.marginSizeDefault,
                      bottom: DimensionResource.marginSizeSmall + 5,
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Stack(
                        children: [
                          Positioned(
                            top: 0,
                            bottom: 0,
                            left: 0,
                            right: 0,
                            child: cachedNetworkImage(
                              homeDataModelDatum.data?.first.image ?? "",
                              fit: BoxFit.cover,
                            ),
                          ),
                          Visibility(
                            visible: homeDataModelDatum
                                        .data?.first.isPromotional !=
                                    null &&
                                homeDataModelDatum.data?.first.isPromotional ==
                                    1,
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Container(
                                margin: const EdgeInsets.only(
                                  top: DimensionResource.marginSizeDefault,
                                  left: DimensionResource.marginSizeDefault,
                                  right: DimensionResource.marginSizeDefault,
                                ),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(3),
                                    color: ColorResource.white),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 3),
                                child: Text(
                                  'Promotional',
                                  style: StyleResource.instance.styleLight(
                                      fontSize:
                                          DimensionResource.fontSizeExtraSmall -
                                              2),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ));
              }
            } else if (homeDataModelDatum.key == 'continue_watch' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(HomeContinueLearningWidget(
                    homeDataModelDatum: homeDataModelDatum));
              }
            } else if (homeDataModelDatum.key == 'trending_courses' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(TrendingCoursesWidget(
                    homeDataModelDatum: homeDataModelDatum));
              }
            } else if (homeDataModelDatum.key == 'live_class' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(
                  LiveClassesWidget(homeDataModelDatum: homeDataModelDatum),
                );
              }
            } else if (homeDataModelDatum.key == 'past_webinars' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(
                  PastWebinarClassesWidget(
                      homeDataModelDatum: homeDataModelDatum),
                );
              }
            } else if (homeDataModelDatum.key == 'past_batches' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(
                  PastBatchesWidget(homeDataModelDatum: homeDataModelDatum),
                );
              }
            } else if (homeDataModelDatum.key == 'live_batch' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(
                  LiveBatchesWidget(homeDataModelDatum: homeDataModelDatum),
                );
              }
            } else if (homeDataModelDatum.key == 'shorts' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(
                  ScalpsWidget(homeDataModelDatum: homeDataModelDatum),
                );
                Get.put(ScalpController());
              }
            } else if (homeDataModelDatum.key == 'top_past_live_classes' &&
                homeDataModelDatum.isActive == 1) {
              itemList.add(
                TopPastLiveWidget(
                  homeDataModelDatum: homeDataModelDatum,
                  onTap: () {
                    if (Get.find<AuthService>().isPro.value &&
                        !Get.find<AuthService>().isGuestUser.value) {
                      Get.toNamed(Routes.pastLiveClass);
                    } else {
                      ProgressDialog().showFlipDialog(isForPro: true);
                    }
                  },
                ),
              );
            }

            else if (homeDataModelDatum.key == 'video_courses' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(VideoCourseWidget(
                    onTap: () {
                      Get.toNamed(Routes.homeSeeAllView, arguments: [
                        StringResource.videoCourses,
                        CourseDetailViewType.videoCourse
                      ]);
                    },
                    data: [CommonDatum()],
                    homeDataModelDatum: homeDataModelDatum));
              }
            } else if (homeDataModelDatum.key == 'text_courses' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(TextCourseWidget(
                    onTap: () {
                      Get.toNamed(Routes.homeSeeAllView, arguments: [
                        StringResource.textCourses,
                        CourseDetailViewType.textCourse
                      ]);
                    },
                    data: [CommonDatum()],
                    homeDataModelDatum: homeDataModelDatum));
              }
            } else if (homeDataModelDatum.key == 'audio_courses' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(AudioCourseWidget(
                    onSeeAll: () {
                      Get.toNamed(Routes.homeSeeAllView, arguments: [
                        StringResource.audioCourses,
                        CourseDetailViewType.audioCourse
                      ]);
                    },
                    data: [CommonDatum()],
                    homeDataModelDatum: homeDataModelDatum));
              }
            } else if (homeDataModelDatum.key == 'blogs' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(BlogsWidget(
                    onTap: () {
                      Get.toNamed(Routes.homeSeeAllView, arguments: [
                        StringResource.blogs,
                        CourseDetailViewType.blogs
                      ]);
                    },
                    data: [CommonDatum()],
                    homeDataModelDatum: homeDataModelDatum));
              }
            } else if (homeDataModelDatum.key == 'quizzes' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList
                    .add(QuizWidget(homeDataModelDatum: homeDataModelDatum));
              }
            } else if (homeDataModelDatum.key == 'videos' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(VideosWidget(
                    onTap: () {
                      Get.toNamed(Routes.homeSeeAllView, arguments: [
                        StringResource.singleVideo,
                        CourseDetailViewType.video
                      ]);
                    },
                    data: [CommonDatum()],
                    homeDataModelDatum: homeDataModelDatum));
              }
            } else if (homeDataModelDatum.key == 'audios' &&
                homeDataModelDatum.isActive == 1) {
              if (homeDataModelDatum.data?.isNotEmpty ?? false) {
                itemList.add(
                  Padding(
                    padding: const EdgeInsets.only(
                        bottom: DimensionResource.marginSizeLarge),
                    child: AudiosWidget(
                        onTap: () {
                          Get.toNamed(Routes.homeSeeAllView, arguments: [
                            StringResource.singleAudio,
                            CourseDetailViewType.audio
                          ]);
                        },
                        data: [CommonDatum()],
                        homeDataModelDatum: homeDataModelDatum),
                  ),
                );
              }
            }
          }
          // await getContinueLearning(isFirst: false);
          // itemList.insert(
          //     itemList.length ~/ 2,
          //     GestureDetector(
          //       onTap: () {
          //         Get.toNamed(Routes.allCategory);
          //       },
          //       child: Container(
          //           width: double.infinity,
          //           margin: const EdgeInsets.only(
          //               left: DimensionResource.marginSizeDefault,
          //               bottom: DimensionResource.marginSizeDefault,
          //               right: DimensionResource.marginSizeDefault),
          //           decoration: BoxDecoration(
          //             color: ColorResource.secondaryColor,
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //           padding: const EdgeInsets.symmetric(
          //               horizontal: DimensionResource.marginSizeSmall + 2,
          //               vertical: DimensionResource.marginSizeSmall - 2),
          //           child: DottedBorder(
          //             borderType: BorderType.RRect,
          //             dashPattern: const [6, 2],
          //             radius: const Radius.circular(5),
          //             padding: const EdgeInsets.all(6),
          //             color: ColorResource.primaryColor,
          //             child: ClipRRect(
          //               borderRadius:
          //                   const BorderRadius.all(Radius.circular(5)),
          //               child: Row(
          //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //                 children: [
          //                   const SizedBox(),
          //                   Text(
          //                     StringResource.exploreAllCategory,
          //                     style: StyleResource.instance.styleSemiBold(
          //                         color: ColorResource.primaryColor),
          //                   ),
          //                   Image.asset(
          //                     ImageResource.instance.arrowCircleIcon,
          //                     height: 18,
          //                   )
          //                 ],
          //               ),
          //             ),
          //           )),
          //     ));
          isDataLoading.value = false;
        });
    Future.delayed(const Duration(seconds: 1)).then((value) async {
      await getLevel();
      await getLanguage();
    });

    HelperUtil.checkForUpdate();
  }

  Future getLevel() async {
    isLevelLoading(true);
    await accountProvider.getLevel(onError: (message, errorMap) {
      toastShow(message: message);
      isLevelLoading(false);
    }, onSuccess: (message, map) {
      levelData.value = LevelModel.fromJson(map);
      List<DropDownData> tempList = [];
      for (Datum? data in levelData.value.data ?? []) {
        tempList.add(
            DropDownData(id: data?.id.toString(), optionName: data?.level));
      }
      Get.find<AuthService>().levelData.value = tempList;

      isLevelLoading(false);
    });
  }

  Future getLanguage() async {
    isLangLoading(true);
    await accountProvider.getLanguage(onError: (message, errorMap) {
      toastShow(message: message);
      isLangLoading(false);
    }, onSuccess: (message, map) {
      languageData.value = lang.LanguageModel.fromJson(map);
      isLangLoading(false);
    });
  }

  Future getNotificationCount() async {
    /// to reset show value at every call
    isShow.value = true;
    await accountProvider.getNotificationCount(
        onError: (message, errorMap) {},
        onSuccess: (message, map) {
          notificationCountData.value =
              count.NotificationCountModel.fromJson(map);
        });
  }

  Future updateLevel() async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      if (!Get.put(ProfileController()).initialized) {
        Get.put(ProfileController());
      }
      final profileController = Get.find<ProfileController>();
      await profileController.onPreferSubmit(
          isPrefer: false,
          levelId: selectedLevel.value.id,
          onSuccess: () {
            showFlicker.value = true;
            getHomeData();
          });
    } else {
      getHomeData();
    }
  }
}
