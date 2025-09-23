import 'dart:ffi';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/auth_models/sign_in.dart';
import 'package:stockpathshala_beta/model/models/batch_models/all_batch_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/batch_provider.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/service/utils/Session.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/live_class_model/live_class_model.dart';
import '../../../../model/network_calls/api_helper/provider_helper/live_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';
import '../../../../view/widgets/log_print/log_print_condition.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../live_classes_controller/filter_controller/filter_controller.dart';

class PastClassesController extends GetxController {
  LiveProvider liveProvider = getIt();
  BatchProvider batchProvider = getIt();
  Rx<TextEditingController> searchController = TextEditingController().obs;

  RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;
  RxList<DropDownData> listOFSelectedDate = <DropDownData>[].obs;
  RxList<RatingDataVal> selectedRating = <RatingDataVal>[].obs;
  Rx<DropDownData> selectedSub = DropDownData().obs;
  RxList<DropDownData> listOFSelectedDuration = <DropDownData>[].obs;
  Rx<LiveClassModel> liveData = LiveClassModel().obs;
  RxList<DropDownData> listofSelectedTeacher = <DropDownData>[].obs;
  late Rx<PagingScrollController<CommonDatum>> dataPagingController;

  // Loading states
  RxBool isDataLoading = false.obs;
  RxBool isClearLoading = false.obs;
  RxBool isBatchesLoading = false.obs;

  // Filter state tracking
  RxString currentCategoryId = "".obs;
  RxString currentLangId = "".obs;
  RxString currentTeacherId = "".obs;
  RxString currentDateFilter = "".obs;
  RxString currentLevelId = "".obs;
  RxString currentDuration = "".obs;
  RxString currentRating = "".obs;
  RxString currentSubscriptionLevel = "".obs;

  // UI states
  RxBool isShow = false.obs;
  RxList<RxBool> isTrialList = <RxBool>[].obs;
  RxInt countValue = 0.obs;
  RxString searchKey = "".obs;

  // Pagination control
  RxBool hasMore = true.obs;
  RxInt currentPage = 1.obs;
  RxInt totalItems = 0.obs;
  RxInt itemsPerPage = 10.obs; // Adjust based on your API

  // Batch data
  RxList<BuyBatchData> userSub = <BuyBatchData>[].obs;
  RxList<BatchData> batchList = <BatchData>[].obs;
  RxList<BatchData> filteredBatchList = <BatchData>[].obs;
  Rx<AllBatchesModal> batchData = AllBatchesModal().obs;
  late TabController tabController;

  List<Tab> tabs = [
    const Tab(text: 'Batch Classes'),
    const Tab(text: 'Demo Classes')
  ];
  @override
  void onClose() {
    dataPagingController.value.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    dataPagingController = PagingScrollController<CommonDatum>(
        onLoadMore: (int page, int totalItemsCount) async {
          // Only load more if we have more data available
          if (hasMore.value && !isDataLoading.value) {
            await getLiveData(
              pageNo: page,
              searchKeyWord: searchKey.value,
              categoryId: currentCategoryId.value,
              langId: currentLangId.value,
              teacherId: currentTeacherId.value,
              dateFilter: currentDateFilter.value,
              levelId: currentLevelId.value,
              duration: currentDuration.value,
              rating: currentRating.value,
              subscriptionLevel: currentSubscriptionLevel.value,
            );
          } else {
            // Signal to pagination controller that no more data is available
            dataPagingController.value.isDataLoading.value = false;
          }
        },
        getStartPage: () => 1,
        getThreshold: () => 0).obs;

    getSubscrpitions();
    getBatches(pageNo: 1);
    filteredBatchList.assignAll(batchList);
    getLiveData(pageNo: 1);
    super.onInit();
  }

  Future<void> onRefresh() async {
    currentPage.value = 1;
    hasMore.value = true;
    totalItems.value = 0;

    isBatchesLoading.value = true;
    isTrialList.clear();
    dataPagingController.value.reset();

    await getSubscrpitions();
    await getBatches(pageNo: 1);
    await getLiveData(pageNo: 1);
  }

  getSubscrpitions() async {
    List<AllUserSubscription> userData =
        Get.find<AuthService>().user.value.allUserSubscription ?? [];

    userSub.value = List<BuyBatchData>.from(
        userData.map((e) => BuyBatchData.fromJson(e.toJson())));
  }

  Future<void> getBatches(
      {String? dateFilter, int? pageNo, String? categoryId}) async {
    isBatchesLoading.value = true;
    try {
      await batchProvider.getPastBatches(
        dateFilter,
        pageNo,
        categoryId,
        onError: (message, json) {
          toastShow(message: message);
          isBatchesLoading.value = false;
          debugPrint("Error fetching batches: $message");
          debugPrint("Error response: ${json.toString()}");
        },
        onSuccess: (message, json) {
          try {
            debugPrint("Raw API response: ${json.toString()}");

            batchData.value = AllBatchesModal.fromJson(json ?? {}, true);
            debugPrint("Parsed batch data: ${batchData.value.toString()}");
            debugPrint("Data length: ${batchData.value.data?.length ?? 0}");

            if (batchData.value.data?.isNotEmpty ?? false) {
              batchList.value = batchData.value.data!;
              debugPrint("Batch list updated with ${batchList.length} items");
            } else {
              debugPrint("No batches found in response");
              batchList.clear();
            }
          } catch (e) {
            debugPrint("Error parsing batch data: $e");
            toastShow(message: "Error processing batch data");
            batchList.clear();
          }
        },
      );
    } catch (e) {
      debugPrint("Exception in getBatches: $e");
      toastShow(message: "Failed to load batches");
    } finally {
      isBatchesLoading.value = false;
    }
  }

  List<SubBatch>? filterSubBatches({required int batchId}) {
    return null;
  }

  void onFilterApply() {
    // Reset pagination when applying filters
    currentPage.value = 1;
    hasMore.value = true;
    dataPagingController.value.reset();

    getLiveData(
      pageNo: 1,
      categoryId: currentCategoryId.value,
      langId: currentLangId.value,
      levelId: currentLevelId.value,
      duration: currentDuration.value,
      rating: currentRating.value,
      subscriptionLevel: currentSubscriptionLevel.value,
      teacherId: currentTeacherId.value,
      dateFilter: currentDateFilter.value,
    );
  }

  void clearFilters() {
    isClearLoading.value = true;

    // Clear all filter selections
    listOFSelectedCat.clear();
    listOFSelectedDate.clear();
    selectedRating.clear();
    selectedSub.value = DropDownData();
    listOFSelectedDuration.clear();
    listofSelectedTeacher.clear();

    // Reset filter state
    currentCategoryId.value = "";
    currentLangId.value = "";
    currentTeacherId.value = "";
    currentDateFilter.value = "";
    currentLevelId.value = "";
    currentDuration.value = "";
    currentRating.value = "";
    currentSubscriptionLevel.value = "";
    searchKey.value = "";
    searchController.value.clear();

    // Reset pagination
    currentPage.value = 1;
    hasMore.value = true;
    dataPagingController.value.reset();

    // Reload data
    getLiveData(pageNo: 1);

    isClearLoading.value = false;
  }

  onClassSearch(val) {
    EasyDebounce.debounce(
        countValue.value.toString(), const Duration(milliseconds: 1000),
        () async {
      // Reset pagination for new search
      currentPage.value = 1;
      hasMore.value = true;

      getLiveData(
        pageNo: 1,
        searchKeyWord: val,
        categoryId: currentCategoryId.value,
        langId: currentLangId.value,
        teacherId: currentTeacherId.value,
        dateFilter: currentDateFilter.value,
        levelId: currentLevelId.value,
        duration: currentDuration.value,
        rating: currentRating.value,
        subscriptionLevel: currentSubscriptionLevel.value,
      );
      countValue.value++;
    });

    // Handle batch search filtering
    if (val.isEmpty) {
      filteredBatchList.clear();
    } else {
      filteredBatchList.assignAll(
        batchList
            .where((batch) =>
                batch.title?.toLowerCase().contains(val.toLowerCase()) ?? false)
            .toList(),
      );
    }
  }

  Future<void> getLiveData({
    required int pageNo,
    String? searchKeyWord,
    String? categoryId,
    String? langId,
    String? teacherId,
    String? dateFilter,
    String? levelId,
    String? duration,
    String? rating,
    String? subscriptionLevel,
  }) async {
    // Update current filter state
    if (categoryId != null) currentCategoryId.value = categoryId;
    if (langId != null) currentLangId.value = langId;
    if (teacherId != null) currentTeacherId.value = teacherId;
    if (dateFilter != null) currentDateFilter.value = dateFilter;
    if (levelId != null) currentLevelId.value = levelId;
    if (duration != null) currentDuration.value = duration;
    if (rating != null) currentRating.value = rating;
    if (subscriptionLevel != null)
      currentSubscriptionLevel.value = subscriptionLevel;

    searchKey.value = searchKeyWord ?? "";
    currentPage.value = pageNo;

    // Set loading states
    if (pageNo == 1) {
      dataPagingController.value.reset();
      isDataLoading.value = true;
      isTrialList.clear();
      hasMore.value = true; // Reset hasMore for fresh data
    } else {
      dataPagingController.value.isDataLoading.value = true;
    }

    await liveProvider.getLiveData(
      searchKeyWord: searchKey.value,
      isPast: true,
      pageNo: pageNo,
      categoryId:
          currentCategoryId.value.isEmpty ? null : currentCategoryId.value,
      teacherId: currentTeacherId.value.isEmpty ? null : currentTeacherId.value,
      dateFilter:
          currentDateFilter.value.isEmpty ? null : currentDateFilter.value,
      langId: currentLangId.value.isEmpty ? null : currentLangId.value,
      levelId: currentLevelId.value.isEmpty ? null : currentLevelId.value,
      duration: currentDuration.value.isEmpty ? null : currentDuration.value,
      rating: currentRating.value.isEmpty ? null : currentRating.value,
      subscriptionLevel: currentSubscriptionLevel.value.isEmpty
          ? null
          : currentSubscriptionLevel.value,
      onError: (message, errorMap) {
        toastShow(message: message);
        isDataLoading.value = false;
        dataPagingController.value.isDataLoading.value = false;
        hasMore.value = false; // No more data on error
        logPrint("Error loading live data: $message");
      },
      onSuccess: (message, json) {
        try {
          liveData.value = LiveClassModel.fromJson(json!);
          logPrint("liveData: ${liveData.value}");

          final List<dynamic> newItems = (json['data']?['data'] ?? []) as List;
          final int? totalCount =
              json['data']?['total']; // Assuming API returns total count
          final int? currentPageFromApi = json['data']?['current_page'];
          final int? lastPage = json['data']?['last_page'];

          // Add trial status for new items
          for (var item in newItems) {
            bool isTrial = item['is_trial'] == 1;
            isTrialList.add(RxBool(isTrial));
          }

          if (newItems.isNotEmpty) {
            // Determine if there's more data based on API response
            if (totalCount != null &&
                lastPage != null &&
                currentPageFromApi != null) {
              hasMore.value = currentPageFromApi < lastPage;
              totalItems.value = totalCount;
            } else {
              // Fallback: check if we received a full page of items
              hasMore.value = newItems.length >= itemsPerPage.value;
            }

            final items = liveData.value.data!.data!
                .map((x) => CommonDatum.fromJson(x.toJson()))
                .toList();

            if (pageNo == 1) {
              // Replace data for first page
              dataPagingController.value.list.clear();
              dataPagingController.value.list.addAll(items);
            } else {
              // Append data for subsequent pages
              dataPagingController.value.list.addAll(items);
            }

            logPrint("Loaded ${items.length} items for page $pageNo");
            logPrint(
                "Total items in list: ${dataPagingController.value.list.length}");
            logPrint("Has more data: ${hasMore.value}");
          } else {
            // No items received
            hasMore.value = false;
            if (pageNo == 1) {
              dataPagingController.value.list.clear();
            }
            logPrint("No items received for page $pageNo");
          }
        } catch (e) {
          hasMore.value = false;
          logPrint("Error parsing live data: $e");
          toastShow(message: "Something went wrong while processing data.");
        } finally {
          isDataLoading.value = false;
          dataPagingController.value.isDataLoading.value = false;
        }
      },
    );
  }

  bool canLoadMore() {
    return hasMore.value &&
        !isDataLoading.value &&
        !dataPagingController.value.isDataLoading.value;
  }

  Future<void> loadMoreData() async {
    if (canLoadMore()) {
      final nextPage = currentPage.value + 1;
      await getLiveData(
        pageNo: nextPage,
        searchKeyWord: searchKey.value,
        categoryId: currentCategoryId.value,
        langId: currentLangId.value,
        teacherId: currentTeacherId.value,
        dateFilter: currentDateFilter.value,
        levelId: currentLevelId.value,
        duration: currentDuration.value,
        rating: currentRating.value,
        subscriptionLevel: currentSubscriptionLevel.value,
      );
    }
  }

  void resetPagination() {
    currentPage.value = 1;
    hasMore.value = true;
    totalItems.value = 0;
    dataPagingController.value.reset();
    isTrialList.clear();
  }
}

class BuyBatchData {
  final int? id;
  final int? subBatch;
  final String? subBatchText;

  BuyBatchData(
      {required this.id, required this.subBatch, required this.subBatchText});

  factory BuyBatchData.fromJson(Map<String, dynamic> json) => BuyBatchData(
      id: json['batch_id'],
      subBatch: json['batch_start_date'],
      subBatchText: json['batches_dates']);

  Map<String, dynamic> toJson() => {
        'batch_id': id,
        'id': subBatch,
        'start_date': subBatchText,
      };
}
