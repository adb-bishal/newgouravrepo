import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/courses_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/course_models/courses_model.dart' as course;
import '../../../../model/models/course_models/single_course_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../view/screens/root_view/courses_detail_view/course_detail_view.dart';
import '../../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../course_detail_controller/course_detail_controller.dart';
import '../live_classes_controller/filter_controller/filter_controller.dart';

class HomeSeeAllController extends GetxController {
  CourseProvider courseProvider = getIt();
  RxBool isDataLoading = false.obs;
  RxBool isClearLoading = false.obs;
  RxString categoryType = "".obs;
  RxString searchKey = "".obs;
  RxList<RatingDataVal> selectedRating = <RatingDataVal>[].obs;
  RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;
  Rx<DropDownData> selectedSubScriptioin = DropDownData().obs;
  RxString categoryHeadingType = "".obs;
  RxString titleCategoryType = "".obs;
  RxString noDataType = "".obs;
  Rx<SingleCourseModel> singleCourseData = SingleCourseModel().obs;
  Rx<course.CoursesModel> courseData = course.CoursesModel().obs;
  Rx<CourseDetailViewType> apiType = CourseDetailViewType.audio.obs;
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
     await getCourseData(pageNo: page, searchKeyWord: "");
      
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    getCourseData(pageNo: 1, searchKeyWord: "");
    filterCategory();
    super.onInit();
  }

  Future<void> onRefresh() async {
    getCourseData(pageNo: 1, searchKeyWord: searchKey.value);
  }

  getCourseData({
    required int pageNo,
    required String searchKeyWord,
    String? rating,
    String? categoryId,
    String? subscriptionLevel = "",
  }) async {
    searchKey.value = searchKeyWord;
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      dataPagingController.value.reset();
      dataPagingController.value.list.clear();
      isDataLoading.value = true;
    }
    await courseProvider.getCourseAllData(
      onError: (message, errorMap) {
        toastShow(message: message);
        isDataLoading.value = false;
        dataPagingController.value.isDataLoading.value = false;
      },
      onSuccess: (message, json) {
        if (apiType.value == CourseDetailViewType.audio ||
            apiType.value == CourseDetailViewType.video ||
            apiType.value == CourseDetailViewType.blogs) {
          singleCourseData.value = SingleCourseModel.fromJson(json!);
          if (singleCourseData.value.data?.data?.isNotEmpty ?? false) {
            dataPagingController.value.list.addAll(List<CommonDatum>.from(
                singleCourseData.value.data!.data!
                    .map((x) => CommonDatum.fromJson(x.toJson()))));
          } else {
            dataPagingController.value.isDataLoading.value = false;
          }
        } else {
          courseData.value = course.CoursesModel.fromJson(json!);
          if (courseData.value.data?.data?.isNotEmpty ?? false) {
            dataPagingController.value.list.addAll(List<CommonDatum>.from(
                courseData.value.data!.data!
                    .map((x) => CommonDatum.fromJson(x.toJson()))));
          } else {
            dataPagingController.value.isDataLoading.value = false;
          }
        }
        isDataLoading.value = false;
      },
      pageNo: pageNo,
      type: apiType.value,
      rating: selectedRating
          .map((element) => element.ratingValue)
          .toList()
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "")
          .removeAllWhitespace,
      subscriptionLevel: selectedSubScriptioin.value.optionName?.toLowerCase(),
      searchKeyWord: searchKey.value,
      catId: categoryId ?? "",
    );
    if (pageNo != 1) {
      //dataPagingController.value.isDataLoading.value = false;
    }
    isDataLoading.value = false;
  }

  filterCategory() {
    switch (categoryType.value) {
      case StringResource.singleVideo:
        noDataType.value = StringResource.listenVideoLesson;
        titleCategoryType.value = StringResource.videoLessons;
        categoryHeadingType.value = StringResource.videoHeadLessons;
        //return videoWrapList(List<single_course.Datum>.from(wishListData.value.data?.data?.map((x) => single_course.Datum.fromJson(x.model?.toJson()??{}))??[]));
        break;
      case StringResource.audioCourses:
        noDataType.value = StringResource.listenAudioCourse;
        titleCategoryType.value = categoryType.value;
        categoryHeadingType.value = categoryType.value;
        break;
      case StringResource.videoCourses:
        noDataType.value = StringResource.listenVideoCourse;
        titleCategoryType.value = categoryType.value;
        categoryHeadingType.value = categoryType.value;
        break;
      case StringResource.textCourses:
        noDataType.value = StringResource.readTextCourse;
        titleCategoryType.value = categoryType.value;
        categoryHeadingType.value = categoryType.value;
        break;
      case StringResource.blogsL:
        noDataType.value = StringResource.viewBlogContent;
        titleCategoryType.value = categoryType.value;
        categoryHeadingType.value = StringResource.blogHeadLessons;
        break;
      default:
        noDataType.value = StringResource.listenPodcasts;
        titleCategoryType.value = StringResource.audioLessons;
        categoryHeadingType.value = StringResource.audioHeadLessons;
        break;
    }
  }

  Widget get getWidget {
    logPrint("category video ${categoryType.value}");
    switch (categoryType.value) {
      case StringResource.singleVideo:
        titleCategoryType.value = StringResource.videoLessons;
        //return videoWrapList(List<single_course.Datum>.from(wishListData.value.data?.data?.map((x) => single_course.Datum.fromJson(x.model?.toJson()??{}))??[]));
        return videoWrapList(dataPagingController.value.list);
      case StringResource.audioCourses:
        titleCategoryType.value = categoryType.value;
        return audioCourseWrapList(
            categoryType: categoryType.value,
            data: dataPagingController.value.list);
      case StringResource.videoCourses:
        titleCategoryType.value = categoryType.value;
        return videoCourseWrapList(
            categoryType: categoryType.value,
            data: dataPagingController.value.list);
      case StringResource.textCourses:
        titleCategoryType.value = categoryType.value;
        return textCourseWrapList(
            categoryType: categoryType.value,
            data: dataPagingController.value.list);
      case StringResource.blogsL:
        titleCategoryType.value = categoryType.value;
        return blogWrapList(dataPagingController.value.list);
      default:
        titleCategoryType.value = StringResource.audioLessons;
        return audioWrapList(dataPagingController.value.list);
    }
  }

  onSearchChange(String? val) {
    EasyDebounce.debounce(
        countValue.value.toString(), const Duration(milliseconds: 1000),
        () async {
      getCourseData(pageNo: 1, searchKeyWord: val ?? "");
      countValue.value++;
    });
  }
}
