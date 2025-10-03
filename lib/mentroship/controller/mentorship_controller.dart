// import '../../../../model/models/common_container_model/common_container_model.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:dio/dio.dart';
// import 'package:stockpathshala_beta/mentroship/model/mentorList_model.dart';
// import 'package:stockpathshala_beta/mentroship/model/mentorshipCardList_model.dart';
// import 'package:stockpathshala_beta/mentroship/model/mentorship_model.dart';
// import 'package:stockpathshala_beta/model/utils/app_constants.dart';
// import 'package:stockpathshala_beta/model/utils/color_resource.dart';
// import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';
//
// import '../../../../model/models/live_class_model/live_class_model.dart';
// import '../../../../model/services/pagination.dart';
//
// class MentorshipController extends GetxController
//     with GetSingleTickerProviderStateMixin {
//   final Rx<MentorshipModel?> mentorshipData = Rx<MentorshipModel?>(null);
//   final RxBool isLoading = false.obs;
//   final RxList<MentorCardData> mentorshipList = <MentorCardData>[].obs;
//   final RxList<MentorData> mentorList = <MentorData>[].obs;
//   final RxBool isMentorListLoading = false.obs;
//   final RxString errorMessage = ''.obs;
//   final RxBool isListLoading = false.obs;
//   final RxInt currentPage = 1.obs;
//   final RxInt lastPage = 1.obs;
//   final RxBool hasMoreData = true.obs;
//   RxBool isClearLoading = false.obs;
//   RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;
//   RxList<DropDownData> listOFSelectedDate = <DropDownData>[].obs;
//   RxList<DropDownData> listOFMentorShip = <DropDownData>[].obs;
//
//   Rx<DropDownData> selectedSub = DropDownData().obs;
//   RxList<DropDownData> listOFSelectedDuration = <DropDownData>[].obs;
//   Rx<LiveClassModel> liveData = LiveClassModel().obs;
//   RxList<DropDownData> listofSelectedTeacher = <DropDownData>[].obs;
//   late Rx<PagingScrollController<CommonDatum>> dataPagingController;
//   static String basesUrl = '${AppConstants.instance.baseUrl}mentorship';
//   static String apiUrl = "${basesUrl}/list_ui";
//   static String urlMentor = "${basesUrl}/mentor_list";
//   var baseUrl = "${basesUrl}?type=running".obs;
//
//   final Dio _dio = Dio();
//
//   TabController? tabController;
//   var listHeight = 1000.0.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     tabController = TabController(length: 3, vsync: this);
//     tabController?.addListener(() {
//       onTabChanged();
//       updateListHeight();
//     });
//
//     getMentorshipData();
//     getCardDetails();
//     fetchMentorList();
//
//     fetchData(type: 'running').then((_) {
//       updateListHeight();
//     });
//
//     // Optional preload
//     fetchData(type: 'upcoming');
//     fetchData(type: 'past');
//
//     setStatusBarAppearance();
//   }
//
//   void updateListHeight() {
//     var currentList = tabController?.index == 0
//         ? runningList
//         : tabController?.index == 1
//             ? upcomingList
//             : pastList;
//     listHeight.value = (currentList.length * 510).toDouble();
//   }
//
//   Future<void> onRefresh() async {
//     if (tabController?.index == 0) {
//       fetchData(type: 'running');
//     } else if (tabController?.index == 1) {
//       fetchData(type: 'upcoming');
//     } else if (tabController?.index == 2) {
//       fetchData(type: 'past');
//     }
//     getCardDetails();
//     getMentorshipData();
//     fetchMentorList();
//   }
//
//   Future<void> onClearFilter() async {
//     if (tabController?.index == 0) {
//       fetchData(type: 'running');
//     } else if (tabController?.index == 1) {
//       fetchData(type: 'upcoming');
//     } else if (tabController?.index == 2) {
//       fetchData(type: 'past');
//     }
//
//   }
//
//
//
//   void setStatusBarAppearance() {
//     SystemChrome.setSystemUIOverlayStyle(
//       SystemUiOverlayStyle(
//         statusBarIconBrightness: Brightness.light,
//         statusBarColor: ColorResource.primaryColor,
//       ),
//     );
//   }
//
//   static String upcomingBaseUrl = "${basesUrl}?type=upcoming";
//   static String pastBaseUrl = "${basesUrl}?type=past";
//   static String runningBaseUrl = "${basesUrl}?type=running";
//   final RxList<MentorCardData> upcomingList = <MentorCardData>[].obs;
//   final RxInt upcomingCurrentPage = 1.obs;
//   final RxInt upcomingLastPage = 1.obs;
//   final RxBool upcomingHasMoreData = true.obs;
//   final RxBool isUpcomingLoading = false.obs;
//   final RxList<MentorCardData> pastList = <MentorCardData>[].obs;
//   final RxInt pastCurrentPage = 1.obs;
//   final RxInt pastLastPage = 1.obs;
//   final RxBool pastHasMoreData = true.obs;
//   final RxBool isPastLoading = false.obs;
//   final RxList<MentorCardData> runningList = <MentorCardData>[].obs;
//   final RxInt runningCurrentPage = 1.obs;
//   final RxInt runningLastPage = 1.obs;
//   final RxBool runningHasMoreData = true.obs;
//   final RxBool isRunningLoading = false.obs;
//
//   void onTabChanged() {
//
//     if (tabController?.index == 0 && runningList.isEmpty) {
//       fetchData(type: 'running');
//     } else if (tabController?.index == 1 && upcomingList.isEmpty) {
//       fetchData(type: 'upcoming');
//     } else if (tabController?.index == 2 && pastList.isEmpty) {
//       fetchData(type: 'past');
//     }
//   }
//
//   Future<void> fetchData({
//     required String type,
//     bool isPagination = false,
//     String? categoryId,
//     String? monthsFilter,
//     String? mentorType,
//   }) async {
//     try {
//       if (type == 'upcoming') {
//         if (isUpcomingLoading.value ||
//             (isPagination && !upcomingHasMoreData.value)) {
//           return;
//         }
//         isUpcomingLoading.value = true;
//
//         final response = await _dio.get(upcomingBaseUrl, queryParameters: {
//           "limit": 8,
//           "page": upcomingCurrentPage.value,
//           if (categoryId != null && categoryId.isNotEmpty) 'category_ids': categoryId,
//           if (monthsFilter != null && monthsFilter.isNotEmpty) 'months_filter': monthsFilter,
//           if (mentorType != null && mentorType.isNotEmpty) 'mentor_type': mentorType,
//         });
//
//         if (response.statusCode == 200) {
//           final mentorshipResponse = MentorshipCardList.fromJson(response.data);
//           upcomingLastPage.value = mentorshipResponse.pagination?.lastPage ?? 1;
//
//           if (mentorshipResponse.data != null) {
//             if (isPagination) {
//               upcomingList.addAll(mentorshipResponse.data!);
//             } else {
//               upcomingList.value = mentorshipResponse.data!;
//             }
//           }
//
//           upcomingHasMoreData.value =
//               upcomingCurrentPage.value < upcomingLastPage.value;
//         }
//       } else if (type == 'past') {
//         if (isPastLoading.value || (isPagination && !pastHasMoreData.value)) {
//           return;
//         }
//         isPastLoading.value = true;
//
//         final response = await _dio.get(pastBaseUrl, queryParameters: {
//           "limit": 8,
//           "page": pastCurrentPage.value,
//           if (categoryId != null && categoryId.isNotEmpty) 'category_ids': categoryId,
//           if (monthsFilter != null && monthsFilter.isNotEmpty) 'months_filter': monthsFilter,
//           if (mentorType != null && mentorType.isNotEmpty) 'mentor_type': mentorType,
//         });
//         print("past api url $pastBaseUrl");
//
//         if (response.statusCode == 200) {
//           final mentorshipResponse = MentorshipCardList.fromJson(response.data);
//           pastLastPage.value = mentorshipResponse.pagination?.lastPage ?? 1;
//
//           if (mentorshipResponse.data != null) {
//             if (isPagination) {
//               pastList.addAll(mentorshipResponse.data!);
//             } else {
//               pastList.value = mentorshipResponse.data!;
//             }
//           }
//
//           pastHasMoreData.value = pastCurrentPage.value < pastLastPage.value;
//         }
//       } else if (type == 'running') {
//         if (isRunningLoading.value ||
//             (isPagination && !runningHasMoreData.value)) {
//           return;
//         }
//         isRunningLoading.value = true;
//
//         final response = await _dio.get(runningBaseUrl, queryParameters: {
//           "limit": 8,
//           "page": runningCurrentPage.value,
//           if (categoryId != null && categoryId.isNotEmpty) 'category_ids': categoryId,
//           if (monthsFilter != null && monthsFilter.isNotEmpty) 'months_filter': monthsFilter,
//           if (mentorType != null && mentorType.isNotEmpty) 'mentor_type': mentorType,
//         });
//
//         if (response.statusCode == 200) {
//           final mentorshipResponse = MentorshipCardList.fromJson(response.data);
//           runningLastPage.value = mentorshipResponse.pagination?.lastPage ?? 1;
//
//           if (mentorshipResponse.data != null) {
//             if (isPagination) {
//               runningList.addAll(mentorshipResponse.data!);
//             } else {
//               runningList.value = mentorshipResponse.data!;
//             }
//           }
//
//           runningHasMoreData.value =
//               runningCurrentPage.value < runningLastPage.value;
//         }
//       }
//     } catch (e) {
//       // log error if needed
//     } finally {
//       if (type == 'upcoming') isUpcomingLoading.value = false;
//       if (type == 'past') isPastLoading.value = false;
//       if (type == 'running') isRunningLoading.value = false;
//     }
//   }
//
//   void loadMore(String type) {
//     if (type == 'upcoming' &&
//         upcomingHasMoreData.value &&
//         !isUpcomingLoading.value) {
//       upcomingCurrentPage.value++;
//       fetchData(type: 'upcoming', isPagination: true);
//     } else if (type == 'past' &&
//         pastHasMoreData.value &&
//         !isPastLoading.value) {
//       pastCurrentPage.value++;
//       fetchData(type: 'past', isPagination: true);
//     } else if (type == 'running' &&
//         runningHasMoreData.value &&
//         !isRunningLoading.value) {
//       runningCurrentPage.value++;
//       fetchData(type: 'running', isPagination: true);
//     }
//   }
//
//   Future<void> getMentorshipData(
//       {int? pageNo,
//       String? categoryId,
//       String? monthsFilter,
//       String? mentorType}) async {
//     try {
//       isLoading.value = true;
//       final response = await _dio.get(apiUrl);
//       if (response.statusCode == 200) {
//         mentorshipData.value = MentorshipModel.fromJson(response.data);
//       }
//     } catch (e) {
//       // handle
//     } finally {
//       isLoading.value = false;
//     }
//   }
//
//   // Future<void> getMentorshipData({
//   //   int pageNo = 1,
//   //   String? categoryId,
//   //   String? monthsFilter,
//   //   String? mentorType,
//   // }) async {
//   //   try {
//   //     isLoading.value = true;
//   //     errorMessage.value = '';
//   //
//   //     final Map<String, String> queryParams = {
//   //       'page': pageNo.toString(),
//   //     };
//   //
//   //     void addIfHasValue(String key, String? value) {
//   //       if (value != null && value.trim().isNotEmpty) {
//   //         queryParams[key] = value.trim();
//   //       }
//   //     }
//   //
//   //     addIfHasValue('category_ids', categoryId);
//   //     addIfHasValue('months_filter', monthsFilter);
//   //     addIfHasValue('mentor_type', mentorType);
//   //
//   //     print("API Request: $apiUrl?${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}");
//   //
//   //     final response = await _dio.get(
//   //       apiUrl,
//   //       queryParameters: queryParams,
//   //     );
//   //
//   //     if (response.statusCode == 200) {
//   //       mentorshipData.value = MentorshipModel.fromJson(response.data);
//   //     } else {
//   //       errorMessage.value = 'Server error occurred';
//   //     }
//   //   }  catch (e) {
//   //     errorMessage.value = 'Operation failed';
//   //   } finally {
//   //     isLoading.value = false;
//   //   }
//   // }
//
//   Future<void> getCardDetails({bool isPagination = false}) async {
//     if (isListLoading.value || (!hasMoreData.value && isPagination)) return;
//
//     isListLoading.value = true;
//
//     try {
//       final response = await _dio.get(baseUrl.value, queryParameters: {
//         "limit": 8,
//         "page": currentPage.value,
//       });
//
//       if (response.statusCode == 200) {
//         final mentorshipResponse = MentorshipCardList.fromJson(response.data);
//         lastPage.value = mentorshipResponse.pagination?.lastPage ?? 1;
//
//         if (mentorshipResponse.data != null) {
//           if (isPagination) {
//             mentorshipList.addAll(mentorshipResponse.data!);
//           } else {
//             mentorshipList.value = mentorshipResponse.data!;
//           }
//         }
//
//         hasMoreData.value = currentPage.value < lastPage.value;
//       }
//     } catch (e) {
//       // handle
//     } finally {
//       isListLoading.value = false;
//     }
//   }
//
//   Future<void> fetchMentorList() async {
//     if (isMentorListLoading.value) return;
//
//     isMentorListLoading.value = true;
//
//     try {
//       final response = await _dio.get(urlMentor);
//       if (response.statusCode == 200) {
//         final jsonResponse = response.data;
//         final MentorList mentorListData = MentorList.fromJson(jsonResponse);
//         mentorList.value = mentorListData.data;
//       } else {
//         errorMessage.value =
//             "Failed to fetch data. Status code: ${response.statusCode}";
//       }
//     } catch (e) {
//       errorMessage.value = "An error occurred: $e";
//     } finally {
//       isMentorListLoading.value = false;
//     }
//   }
// }
//
// // class DropDownData {
// //   final String? optionName;
// //   final String? id;
// //   final String? displayName;
// //
// //   DropDownData({this.optionName, this.id, this.displayName});
// // }
// //
// // class RatingDataVal {
// //   final String? ratingName;
// //   final String? ratingValue;
// //
// //   RatingDataVal({this.ratingName, this.ratingValue});
// // }


import '../../../../model/models/common_container_model/common_container_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:stockpathshala_beta/mentroship/model/mentorList_model.dart';
import 'package:stockpathshala_beta/mentroship/model/mentorshipCardList_model.dart';
import 'package:stockpathshala_beta/mentroship/model/mentorship_model.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';

import '../../../../model/models/live_class_model/live_class_model.dart';
import '../../../../model/services/pagination.dart';

class MentorshipController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final Rx<MentorshipModel?> mentorshipData = Rx<MentorshipModel?>(null);
  final RxBool isLoading = false.obs;
  final RxList<MentorCardData> mentorshipList = <MentorCardData>[].obs;
  final RxList<MentorData> mentorList = <MentorData>[].obs;
  final RxBool isMentorListLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isListLoading = false.obs;
  final RxInt currentPage = 1.obs;
  final RxInt lastPage = 1.obs;
  final RxBool hasMoreData = true.obs;
  RxBool isClearLoading = false.obs;
  RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;
  RxList<DropDownData> listOFSelectedDate = <DropDownData>[].obs;
  RxList<DropDownData> listOFMentorShip = <DropDownData>[].obs;

  Rx<DropDownData> selectedSub = DropDownData().obs;
  RxList<DropDownData> listOFSelectedDuration = <DropDownData>[].obs;
  Rx<LiveClassModel> liveData = LiveClassModel().obs;
  RxList<DropDownData> listofSelectedTeacher = <DropDownData>[].obs;
  late Rx<PagingScrollController<CommonDatum>> dataPagingController;

  // URL Management
  static String basesUrl = '${AppConstants.instance.baseUrl}mentorship';
  static String apiUrl = "${basesUrl}/list_ui";
  static String urlMentor = "${basesUrl}/mentor_list";
  static String upcomingBaseUrl = "${basesUrl}?type=upcoming";
  static String pastBaseUrl = "${basesUrl}?type=past";
  static String runningBaseUrl = "${basesUrl}?type=running";
  var baseUrl = "${basesUrl}?type=running".obs;

  final Dio _dio = Dio();

  TabController? tabController;
  var listHeight = 2000.0.obs;

  // Tab-specific lists and pagination
  final RxList<MentorCardData> upcomingList = <MentorCardData>[].obs;
  final RxInt upcomingCurrentPage = 1.obs;
  final RxInt upcomingLastPage = 1.obs;
  final RxBool upcomingHasMoreData = true.obs;
  final RxBool isUpcomingLoading = false.obs;

  final RxList<MentorCardData> pastList = <MentorCardData>[].obs;
  final RxInt pastCurrentPage = 1.obs;
  final RxInt pastLastPage = 1.obs;
  final RxBool pastHasMoreData = true.obs;
  final RxBool isPastLoading = false.obs;

  final RxList<MentorCardData> runningList = <MentorCardData>[].obs;
  final RxInt runningCurrentPage = 1.obs;
  final RxInt runningLastPage = 1.obs;
  final RxBool runningHasMoreData = true.obs;
  final RxBool isRunningLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    printAllUrls(); // Debug: Print all URLs on initialization

    tabController = TabController(length: 3, vsync: this);
    tabController?.addListener(() {
      onTabChanged();
        updateListHeight();
    });

    getMentorshipData();
    getCardDetails();
    fetchMentorList();

    fetchData(type: 'running').then((_) {
      updateListHeight();
    });

    // Optional preload
    fetchData(type: 'upcoming');
    fetchData(type: 'past');

    // setStatusBarAppearance();
  }

  // Debug function to print all URLs
  void printAllUrls() {
    print("=== MENTORSHIP CONTROLLER URLs ===");
    print("Base URL: $basesUrl");
    print("API URL: $apiUrl");
    print("Mentor URL: $urlMentor");
    print("Running URL: $runningBaseUrl");
    print("Upcoming URL: $upcomingBaseUrl");
    print("Past URL: $pastBaseUrl");
    print("Current Base URL: ${baseUrl.value}");
    print("=====================================");
  }

  void updateListHeight() {
    var currentList = tabController?.index == 0
        ? runningList
        : tabController?.index == 1
        ? upcomingList
        : pastList;

    double cardHeight = 600;
    double bottomPadding = Get.height * 0.1;

    listHeight.value = (currentList.length * cardHeight) + bottomPadding;
  }

  Future<void> onRefresh() async {

    print("🔄 Refreshing data for tab: ${tabController?.index}");
    if (tabController?.index == 0) {
      fetchData(type: 'running');
    } else if (tabController?.index == 1) {
      fetchData(type: 'upcoming');
    } else if (tabController?.index == 2) {
      fetchData(type: 'past');
    }
    getCardDetails();
    getMentorshipData();
    fetchMentorList();
    updateListHeight();
  }

  Future<void> onClearFilter() async {
    print("🧹 Clearing filters for tab: ${tabController?.index}");
    if (tabController?.index == 0) {
      fetchData(type: 'running');
    } else if (tabController?.index == 1) {
      fetchData(type: 'upcoming');
    } else if (tabController?.index == 2) {
      fetchData(type: 'past');
    }
  }

  // void setStatusBarAppearance() {
  //   SystemChrome.setSystemUIOverlayStyle(
  //     SystemUiOverlayStyle(
  //       statusBarIconBrightness: Brightness.light,
  //       statusBarColor: ColorResource.primaryColor,
  //     ),
  //   );
  // }

  void onTabChanged() {
    print("📱 Tab changed to: ${tabController?.index}");

    if (tabController?.index == 0 && runningList.isEmpty) {
      print("Loading running mentorships...");
      fetchData(type: 'running');

    } else if (tabController?.index == 1 && upcomingList.isEmpty) {
      print("Loading upcoming mentorships...");
      fetchData(type: 'upcoming');
    } else if (tabController?.index == 2 && pastList.isEmpty) {
      print("Loading past mentorships...");
      fetchData(type: 'past');
    }
  }

  Future<void> fetchData({
    required String type,
    bool isPagination = false,
    String? categoryId,
    String? monthsFilter,
    String? mentorType,
  }) async {
    try {
      String currentUrl;
      RxList<MentorCardData> targetList;
      RxBool loadingState;
      RxInt currentPageState;
      RxInt lastPageState;
      RxBool hasMoreDataState;

      // Setup variables based on type
      if (type == 'upcoming') {
        if (isUpcomingLoading.value || (isPagination && !upcomingHasMoreData.value)) {
          return;
        }
        currentUrl = upcomingBaseUrl;
        targetList = upcomingList;
        loadingState = isUpcomingLoading;
        currentPageState = upcomingCurrentPage;
        lastPageState = upcomingLastPage;
        hasMoreDataState = upcomingHasMoreData;
      } else if (type == 'past') {
        if (isPastLoading.value || (isPagination && !pastHasMoreData.value)) {
          return;
        }
        currentUrl = pastBaseUrl;
        targetList = pastList;
        loadingState = isPastLoading;
        currentPageState = pastCurrentPage;
        lastPageState = pastLastPage;
        hasMoreDataState = pastHasMoreData;
      } else if (type == 'running') {
        if (isRunningLoading.value || (isPagination && !runningHasMoreData.value)) {
          return;
        }
        currentUrl = runningBaseUrl;
        targetList = runningList;
        loadingState = isRunningLoading;
        currentPageState = runningCurrentPage;
        lastPageState = runningLastPage;
        hasMoreDataState = runningHasMoreData;
      } else {
        print("❌ Invalid type: $type");
        return;
      }

      loadingState.value = true;

      // Build query parameters
      Map<String, dynamic> queryParams = {
        "limit": 8,
        "page": currentPageState.value,
      };

      if (categoryId != null && categoryId.isNotEmpty) {
        queryParams['category_ids'] = categoryId;
      }
      if (monthsFilter != null && monthsFilter.isNotEmpty) {
        queryParams['months_filter'] = monthsFilter;
      }
      if (mentorType != null && mentorType.isNotEmpty) {
        queryParams['mentor_type'] = mentorType;
      }

      String debugUrl = "$currentUrl&${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}";
      print("🌐 Fetching $type data from: $debugUrl");

      final response = await _dio.get(currentUrl, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final mentorshipResponse = MentorshipCardList.fromJson(response.data);
        lastPageState.value = mentorshipResponse.pagination?.lastPage ?? 1;

        if (mentorshipResponse.data != null) {
          if (isPagination) {
            targetList.addAll(mentorshipResponse.data!);
            print("📄 Added ${mentorshipResponse.data!.length} items to $type list (pagination)");
          } else {
            targetList.value = mentorshipResponse.data!;
            print("📄 Loaded ${mentorshipResponse.data!.length} items to $type list");
          }
        }

        hasMoreDataState.value = currentPageState.value < lastPageState.value;
        print("📊 $type - Page: ${currentPageState.value}/${lastPageState.value}, Has more: ${hasMoreDataState.value}");
      } else {
        print("❌ Failed to fetch $type data. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching $type data: $e");
    } finally {
      if (type == 'upcoming') isUpcomingLoading.value = false;
      if (type == 'past') isPastLoading.value = false;
      if (type == 'running') isRunningLoading.value = false;
    }
  }

  void loadMore(String type) {
    print("📜 Loading more $type data...");

    if (type == 'upcoming' && upcomingHasMoreData.value && !isUpcomingLoading.value) {
      upcomingCurrentPage.value++;
      fetchData(type: 'upcoming', isPagination: true);
    } else if (type == 'past' && pastHasMoreData.value && !isPastLoading.value) {
      pastCurrentPage.value++;
      fetchData(type: 'past', isPagination: true);
    } else if (type == 'running' && runningHasMoreData.value && !isRunningLoading.value) {
      runningCurrentPage.value++;
      fetchData(type: 'running', isPagination: true);
    }
  }

  Future<void> getMentorshipData({
    int? pageNo,
    String? categoryId,
    String? monthsFilter,
    String? mentorType
  }) async {
    try {
      isLoading.value = true;
      print("🎯 Fetching mentorship UI data from: $apiUrl");

      final response = await _dio.get(apiUrl);
      if (response.statusCode == 200) {
        mentorshipData.value = MentorshipModel.fromJson(response.data);
        print("✅ Mentorship UI data loaded successfully");
      } else {
        print("❌ Failed to fetch mentorship UI data. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching mentorship UI data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getCardDetails({bool isPagination = false}) async {
    if (isListLoading.value || (!hasMoreData.value && isPagination)) return;

    isListLoading.value = true;

    try {
      Map<String, dynamic> queryParams = {
        "limit": 8,
        "page": currentPage.value,
      };

      String debugUrl = "${baseUrl.value}&${queryParams.entries.map((e) => '${e.key}=${e.value}').join('&')}";
      print("🃏 Fetching card details from: $debugUrl");

      final response = await _dio.get(baseUrl.value, queryParameters: queryParams);

      if (response.statusCode == 200) {
        final mentorshipResponse = MentorshipCardList.fromJson(response.data);
        lastPage.value = mentorshipResponse.pagination?.lastPage ?? 1;

        if (mentorshipResponse.data != null) {
          if (isPagination) {
            mentorshipList.addAll(mentorshipResponse.data!);
            print("🃏 Added ${mentorshipResponse.data!.length} card items (pagination)");
          } else {
            mentorshipList.value = mentorshipResponse.data!;
            print("🃏 Loaded ${mentorshipResponse.data!.length} card items");
          }
        }

        hasMoreData.value = currentPage.value < lastPage.value;
        print("📊 Cards - Page: ${currentPage.value}/${lastPage.value}, Has more: ${hasMoreData.value}");
      } else {
        print("❌ Failed to fetch card details. Status: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Error fetching card details: $e");
    } finally {
      isListLoading.value = false;
    }
  }

  Future<void> fetchMentorList() async {
    if (isMentorListLoading.value) return;

    isMentorListLoading.value = true;

    try {
      print("👨‍🏫 Fetching mentor list from: $urlMentor");

      final response = await _dio.get(urlMentor);
      if (response.statusCode == 200) {
        final jsonResponse = response.data;
        final MentorList mentorListData = MentorList.fromJson(jsonResponse);
        mentorList.value = mentorListData.data;
        print("✅ Loaded ${mentorList.length} mentors");
      } else {
        errorMessage.value = "Failed to fetch mentor data. Status code: ${response.statusCode}";
        print("❌ Failed to fetch mentors. Status: ${response.statusCode}");
      }
    } catch (e) {
      errorMessage.value = "An error occurred: $e";
      print("❌ Error fetching mentors: $e");
    } finally {
      isMentorListLoading.value = false;
    }
  }
}