import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/courses_provider.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../../model/models/explore_all_category/all_category_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/auth_service.dart';

class AllCategoryController extends GetxController {
  CourseProvider courseProvider = getIt();
  Rx<AllCategoryModel> allCategoryData = AllCategoryModel().obs;
  Rx<TextEditingController> categorySearchController =
      TextEditingController().obs;
  RxBool isCategoryLoading = false.obs;
  RxInt selectedFilter = 0.obs;
  RxInt countValue = 0.obs;
  RxString searchKey = ''.obs;
  RxList<String> filterList = <String>["A-Z", "Z-A"].obs;

  @override
  void onInit() {
    getAllCategory(searchKeyWord: "");
    super.onInit();
  }

  onCategorySearch(val) {
    // isSearchLoading(true);
    EasyDebounce.debounce(
        countValue.value.toString(), const Duration(milliseconds: 1000),
        () async {
      getAllCategory(searchKeyWord: val);
      countValue.value++;
    });
  }

  getAllCategory({String sort = "ASC", required String searchKeyWord}) async {
    isCategoryLoading.value = true;
    searchKey.value = searchKeyWord;
    await courseProvider.getAllCategories(
        languageId: Get.find<AuthService>().user.value.languageId != null
            ? Get.find<AuthService>().user.value.languageId.toString()
            : "",
        searchKeyWord: searchKey.value,
        onError: (message, errorMap) {
          isCategoryLoading.value = false;
          toastShow(message: message);
        },
        onSuccess: (message, json) {
          allCategoryData.value = AllCategoryModel.fromJson(json!);
          isCategoryLoading.value = false;
        },
        sort: sort);
  }
}
