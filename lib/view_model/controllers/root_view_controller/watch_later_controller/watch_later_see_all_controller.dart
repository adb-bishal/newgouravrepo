import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/wishlist_data_model/wishlist_see_all_model.dart';
import '../../../../model/network_calls/api_helper/provider_helper/wishlist_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../view/screens/root_view/courses_detail_view/course_detail_view.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../live_classes_controller/filter_controller/filter_controller.dart';

class WatchLaterSeeAllController extends GetxController {
  WishListProvider wishListProvider = getIt();
  RxBool isDataLoading = false.obs;
  RxBool isClearLoading = false.obs;
  RxList<RatingDataVal> selectedRating = <RatingDataVal>[].obs;
  Rx<DropDownData> selectedSubScriptioin = DropDownData().obs;
  RxString categoryType = "".obs;
  RxString searchKey = "".obs;
  RxString apiType = "".obs;
  Rx<WishListSeeAllModel> wishListData = WishListSeeAllModel().obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;
  late Rx<PagingScrollController<CommonDatum>> dataPagingController;
  RxInt countValue = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      categoryType.value = Get.arguments[0];
      apiType.value = Get.arguments[1];
    }
    dataPagingController = PagingScrollController<CommonDatum>(
        onLoadMore: (int page, int totalItemsCount) async {
     await getWishlistsData(page, searchKeyWord: "");
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    getWishlistsData(1, searchKeyWord: "");
    super.onInit();
  }

  getWishlistsData(int pageNo,
      {required String searchKeyWord,
      String? rating,
      String? subscriptionLevel = ""}) async {
    isDataLoading.value = true;
    searchKey.value = searchKeyWord;
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      dataPagingController.value.reset();
    }
    await wishListProvider.getWishlistsTypeData(
        onError: (message, errorMap) {
          isDataLoading.value = false;
          toastShow(message: message);
          dataPagingController.value.isDataLoading.value = false;
        },
        onSuccess: (message, json) {
          wishListData.value = WishListSeeAllModel.fromJson(json!);
          if (wishListData.value.data?.data?.isNotEmpty ?? false) {
            dataPagingController.value.list.addAll(
                List<CommonDatum>.from(wishListData.value.data?.data?.map((x) {
                      logPrint("dataa ${x.toJson()}");
                      return CommonDatum.fromJson(x.toJson());
                    }) ??
                    {}));
          } else {
            dataPagingController.value.isDataLoading.value = false;
          }

          isDataLoading.value = false;
        },
        type: apiType.value,
        rating: rating,
        subscriptionLevel:
            selectedSubScriptioin.value.optionName?.toLowerCase(),
        pageNo: pageNo,
        searchKeyWord: searchKey.value);
    if (pageNo != 1) {
      //dataPagingController.value.isDataLoading.value = false;
    }
  }

  Widget get getWidget {
    switch (categoryType.value) {
      case StringResource.singleVideo:
        //return videoWrapList(List<single_course.Datum>.from(wishListData.value.data?.data?.map((x) => single_course.Datum.fromJson(x.model?.toJson()??{}))??[]));
        return videoWrapList(dataPagingController.value.list);
      case StringResource.audioCourses:
        return audioCourseWrapList(
            categoryType: categoryType.value,
            data: dataPagingController.value.list);
      case StringResource.videoCourses:
        return videoCourseWrapList(
            categoryType: categoryType.value,
            data: dataPagingController.value.list);
      case StringResource.textCourses:
        return textCourseWrapList(
            categoryType: categoryType.value,
            data: dataPagingController.value.list);
      default:
        return audioWrapList(dataPagingController.value.list);
    }
  }

  onSearchChange(String? val) {
    EasyDebounce.debounce(
        countValue.value.toString(), const Duration(milliseconds: 1000),
        () async {
      getWishlistsData(1, searchKeyWord: val ?? "");
      countValue.value++;
    });
  }
}
