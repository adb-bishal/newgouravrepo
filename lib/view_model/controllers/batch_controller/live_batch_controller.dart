import 'package:easy_debounce/easy_debounce.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stockpathshala_beta/model/models/batch_models/all_batch_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/batch_provider.dart';
import '../../../model/models/common_container_model/common_container_model.dart';
import '../../../model/models/live_class_model/live_class_model.dart';
import '../../../model/network_calls/api_helper/provider_helper/live_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../model/services/auth_service.dart';
import '../../../model/services/pagination.dart';
import '../../../model/utils/helper_util.dart';
import '../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../../view/widgets/toast_view/showtoast.dart';
import '../root_view_controller/root_view_controller.dart';
import 'package:flutter/material.dart';

class LiveBatchesController extends GetxController {
  BatchProvider batchProvider = getIt();
  Rx<AllBatchesModal> batchData = AllBatchesModal().obs;
  RxBool isDataLoading = false.obs;
  RxString searchKey = "".obs;
  RxBool isClearLoading = false.obs;
  RxBool isTabValueChange = false.obs;
  Rx<DropDownData> selectedSub = DropDownData().obs;
  var filteredBatchData = <BatchData>[].obs;
  var isSearchEnabled = true.obs;

  RxList<DropDownData> selectedLevel = <DropDownData>[].obs;

  RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;
  RxList<DropDownData> listOFSelectedDate = <DropDownData>[].obs;
  LiveProvider liveProvider = getIt();
  RxList<BatchData> originalData = <BatchData>[].obs;
  RxList<DropDownData> listofSelectedTeacher = <DropDownData>[].obs;
  RxString currentCategoryId = "".obs;
  RxString currentLangId = "".obs;
  RxString currentTeacherId = "".obs;
  RxString currentDateFilter = "".obs;
  RxString currentLevelId = "".obs;
  RxString currentDuration = "".obs;
  RxString currentRating = "".obs;
  RxString currentSubscriptionLevel = "".obs;
  late Rx<PagingScrollController<CommonDatum>> dataPagingController;
  Rx<LiveClassModel> liveData = LiveClassModel().obs;
  RxInt countValue = 0.obs;
  RxList<DropDownData> listOFSelectedDuration = <DropDownData>[].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  late TabController tabController;
  RxList<Tab> tabs = <Tab>[
    const Tab(text: 'Upcoming'),
    const Tab(text: 'Past Batches'),
  ].obs;
  @override
  void onInit() async {
    dataPagingController = PagingScrollController<CommonDatum>(
        onLoadMore: (int page, int totalItemsCount) async {
         await getBatchData(
            pageNo: page,
            categoryId: currentCategoryId.value,
            dateFilter: currentDateFilter.value,
          );
        }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;


    await getBatchData(pageNo:1);
    // filteredBatchData.value = batchData.value.data ?? []; // Initialize filtered data
    super.onInit();
  }

  void onClassSearch(val) {
    searchKey.value = val;

    EasyDebounce.debounce(
      'search-${countValue.value}', // Unique debounce key
      const Duration(milliseconds: 1000),
      () async {
        // Check if batchData is not null and contains data before filtering
        if (batchData.value?.data != null) {
          filteredBatchData.value = batchData.value!.data!
              .where((batch) =>
                  batch.title != null &&
                  batch.title!.toLowerCase().contains(val.toLowerCase()))
              .toList();
        } else {
          // Handle empty or null batchData
          filteredBatchData.value = [];
        }
      },
    );
  }

  Future<void> getLiveData({
    required int pageNo,
    String? searchKeyWord,
    String? categoryId,
    String? langId,
    String? levelId,
    String? duration,
    String? teacherId,
    String? rating,
    String? subscriptionLevel,
    bool callFromRegister = false,
  }) async {
    searchKey.value = searchKeyWord ?? "";
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      if (callFromRegister) {
        dataPagingController.value.isDataLoading.value = true;
      } else {
        dataPagingController.value.reset();
        isDataLoading.value = true;
      }
    }
    await liveProvider.getLiveData(
        onError: (message, errorMap) {
          toastShow(message: message);
          isDataLoading.value = false;
          dataPagingController.value.isDataLoading.value = false;
        },
        onSuccess: (message, json) {
          liveData.value = LiveClassModel.fromJson(json!);
          if (liveData.value.data?.data?.isNotEmpty ?? false) {
            if (callFromRegister) {
              dataPagingController.value.list.clear();
            }
            dataPagingController.value.list.addAll(
              List<CommonDatum>.from(
                liveData.value.data!.data!.map(
                  (x) => CommonDatum.fromJson(
                    x.toJson(),
                  ),
                ),
              ),
            );
          } else {
            dataPagingController.value.isDataLoading.value = false;
          }
          isDataLoading.value = false;
        },
        pageNo: pageNo,
        categoryId: listOFSelectedCat
            .map((element) => element.id)
            .toList()
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .removeAllWhitespace,
        langId: langId,
        levelId: selectedLevel
            .map((element) => element.id)
            .toList()
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .removeAllWhitespace,
        duration: listOFSelectedDuration
            .map((element) => element.optionName)
            .toList()
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .removeAllWhitespace,
        rating: rating,
        subscriptionLevel: selectedSub.value.optionName,
        searchKeyWord: searchKey.value);
    if (pageNo != 1) {
      // dataPagingController.value.isDataLoading.value = false;
    }
  }

  Future<void> onRefresh() async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      Get.find<RootViewController>().getProfile();
    }
    getBatchData();
  }

  void tabChange() {
    getBatchData();
  }

  Future<void> getBatchData({ String? dateFilter, int? pageNo, String? categoryId}) async {
    isDataLoading.value = true;
    await batchProvider.getAllBatches(dateFilter,pageNo,categoryId,
      onError: (message, errorMap) {
        toastShow(message: message);
        isDataLoading.value = false;
      },
      onSuccess: (message, json) {
        batchData.value = AllBatchesModal.fromJson(json!, false);
        if (batchData.value.data?.isNotEmpty ?? false) {}
        isDataLoading.value = false;

        if (isTabValueChange.value == true) {
          tabController.index = 1;
          isTabValueChange.value = false;
        } else {
          print("klhjjfklashfk");
          tabController.index = 0;
        }
      },
    );
    HelperUtil.checkForUpdate();
  }
}
