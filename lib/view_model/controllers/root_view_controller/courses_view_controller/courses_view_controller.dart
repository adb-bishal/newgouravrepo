import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/courses_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../model/models/course_models/courses_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';
import '../../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../course_detail_controller/course_detail_controller.dart';
import '../live_classes_controller/filter_controller/filter_controller.dart';

class CoursesViewController extends GetxController {
  CourseProvider courseProvider = getIt();
  Rx<TextEditingController> searchController = TextEditingController().obs;
  Rx<CoursesModel> courseData = CoursesModel().obs;
  RxInt countValue = 0.obs;
  RxInt showIndex = 6.obs;
  RxString searchKeyWordVal = "".obs;
  RxBool isDataLoading = false.obs;
  late Rx<PagingScrollController<Datum>> dataPagingController;
  RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;
  RxList<RatingDataVal> selectedRating = <RatingDataVal>[].obs;
  RxList<DropDownData> selectedLevel = <DropDownData>[].obs;
  Rx<DropDownData> selectedSub = DropDownData(id: "0", optionName: "all").obs;

  Future<void> onRefresh() async {
    getCourseData(pageNo: 1, searchKeyWord: searchKeyWordVal.value);
  }

  getCourseData({
    required int pageNo,
    String? searchKeyWord,
    String? subscriptionLevel,
    String? categoryId,
    String? langId,
    String? rating,
    String? level,
  }) async {
    searchKeyWordVal.value = searchKeyWord ?? "";
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;

    } else {
      dataPagingController.value.reset();
      isDataLoading(true);
    }
    await courseProvider.getCourseData(
        rating: selectedRating
            .map((element) => element.ratingValue)
            .toList()
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .removeAllWhitespace,
        onError: (message, errorMap) {
          toastShow(message: message);
          isDataLoading(false);
        },
        searchKeyWord: searchKeyWordVal.value,
        onSuccess: (message, json) {
          // logPrint("data2 ${json}");
          courseData.value = CoursesModel.fromJson(json!);
          if (courseData.value.data?.data?.isNotEmpty ?? false) {
            dataPagingController.value.list
                .addAll(courseData.value.data?.data ?? []);
            if (pageNo == 1) {
              if ((courseData.value.data?.data?.length ?? 0) <=
                      showIndex.value &&
                  selectedSub.value.optionName?.toLowerCase() != "pro") {
                showIndex.value = courseData.value.data?.data?.length ?? 0;
                showIndex.value =
                    (courseData.value.data?.data?.length.isEven ?? false)
                        ? showIndex.value - 2
                        : showIndex.value - 1;
              }
            }
          }

          isDataLoading(false);
        },
        catId: listOFSelectedCat
            .map((element) => element.id)
            .toList()
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .removeAllWhitespace,
        subscriptionLevel: selectedSub.value.optionName,
        pageNo: pageNo,
        langId: langId,
        // level: selectedLevel
        //     .map((element) => element.id)
        //     .toList()
        //     .toString()
        //     .replaceAll("[", "")
        //     .replaceAll("]", "")
        //     .removeAllWhitespace,
        type: CourseDetailViewType.allCourses);
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = false;
    }
  }

  onCourseSearch(val) {
    // isSearchLoading(true);

    EasyDebounce.debounce(
        countValue.value.toString(), const Duration(milliseconds: 1000),
        () async {
      getCourseData(pageNo: 1, searchKeyWord: val);
      countValue.value++;
    });
  }

  @override
  void onInit() {
    dataPagingController = PagingScrollController<Datum>(
        onLoadMore: (int page, int totalItemsCount) async{
      logPrint("dsdfsdfdsvn sdvs $page");
     await getCourseData(pageNo: page);
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    getCourseData(pageNo: 1);
    super.onInit();
  }
}
