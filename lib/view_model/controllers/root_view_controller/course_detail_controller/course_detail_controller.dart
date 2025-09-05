import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/common_container_model/common_container_model.dart';
import 'package:stockpathshala_beta/model/models/course_models/single_course_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/courses_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../../model/models/course_models/courses_model.dart' as course;
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../view/screens/root_view/courses_detail_view/course_detail_view.dart';
import '../../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../live_classes_controller/filter_controller/filter_controller.dart';

enum CourseDetailViewType {
  video,
  audio,
  blogs,
  webinars,
  audioCourse,
  videoCourse,
  textCourse,
  allCourses
}

class CourseDetailController extends GetxController {
  CourseProvider courseProvider = getIt();
  Rx<CourseDetailViewType> viewType = CourseDetailViewType.video.obs;
  Rx<TextEditingController> courseController = TextEditingController().obs;
  RxString categoryType = "".obs;
  RxString catId = "".obs;
  RxBool isClearLoading = false.obs;
  RxBool isDataLoading = false.obs;
  RxString description = "".obs;
  RxString screenType = "".obs;
  RxString searchKey = "".obs;
  RxString noDataType = "".obs;
  RxInt countValue = 0.obs;
  ScrollController scrollController = ScrollController();
  late PagingScrollController pScrollController;
  Rx<SingleCourseModel> singleCourseData = SingleCourseModel().obs;
  Rx<course.CoursesModel> courseData = course.CoursesModel().obs;
  late Rx<PagingScrollController<CommonDatum>> dataPagingController;
  RxList<CommonDatum> commonData = <CommonDatum>[].obs;
  RxList<RatingDataVal> selectedRating = <RatingDataVal>[].obs;
  Rx<DropDownData> selectedSub = DropDownData(id: "0", optionName: "all").obs;
  @override
  void onInit() {
    if (Get.arguments != null) {
      categoryType.value = Get.arguments[0] ?? "";
      viewType.value = Get.arguments[1] ?? "";
      description.value = Get.arguments[2] ?? "";
      catId.value = (Get.arguments[3] ?? '').toString();
      if (Get.arguments.length >= 4) {
        selectedSub.value = DropDownData(id: "1", optionName: "all");
      }
    }
    dataPagingController = PagingScrollController<CommonDatum>(
        onLoadMore: (int page, int totalItemsCount) async{
     await getWidgetData(page, "");
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;

    getWidgetData(1, "");
    super.onInit();
  }

  Future<void> onRefresh() async {
    getCourseData(
        pageNo: 1,
        catId: catId.value,
        typeId: viewType.value,
        searchKeyword: searchKey.value);
  }

  onCategorySearch(val) {
    EasyDebounce.debounce(
        countValue.value.toString(), const Duration(milliseconds: 1000),
        () async {
      logPrint("i am here $val");
      getWidgetData(1, val);
      countValue.value++;
    });
  }

  getCourseData(
      {required int pageNo,
      required String catId,
      required String searchKeyword,
      String? rating,
      String? subscriptionLevel,
      required CourseDetailViewType typeId}) async {
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      dataPagingController.value.reset();
      isDataLoading.value = true;
    }
    await courseProvider.getCourseData(
        rating: rating,
        subscriptionLevel: subscriptionLevel,
        searchKeyWord: searchKeyword,
        onError: (message, errorMap) {
          toastShow(message: message);
          isDataLoading.value = false;
        },
        onSuccess: (message, json) {
          if (typeId == CourseDetailViewType.audio ||
              typeId == CourseDetailViewType.video ||
              typeId == CourseDetailViewType.blogs) {
            singleCourseData.value = SingleCourseModel.fromJson(json!);
            if (singleCourseData.value.data?.data?.isNotEmpty ?? false) {
              dataPagingController.value.list.addAll(List<CommonDatum>.from(
                  singleCourseData.value.data!.data!
                      .map((x) => CommonDatum.fromJson(x.toJson()))));
            }
          } else {
            courseData.value = course.CoursesModel.fromJson(json!);
            dataPagingController.value.list.addAll(List<CommonDatum>.from(
                courseData.value.data!.data!
                    .map((x) => CommonDatum.fromJson(x.toJson()))));
          }
          isDataLoading.value = false;
        },
        catId: catId,
        pageNo: pageNo,
        type: typeId);
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = false;
    } else {
      isDataLoading.value = false;
    }
  }

  Widget get getWidget {
    switch (viewType.value) {
      case CourseDetailViewType.video:
        return videoWrapList(dataPagingController.value.list);
      case CourseDetailViewType.blogs:
        return blogWrapList(dataPagingController.value.list);
      case CourseDetailViewType.audioCourse:
        return audioCourseWrapList(
            categoryType: categoryType.value,
            data: dataPagingController.value.list);
      case CourseDetailViewType.videoCourse:
        return videoCourseWrapList(
            categoryType: categoryType.value,
            data: dataPagingController.value.list);
      case CourseDetailViewType.textCourse:
        return textCourseWrapList(
            categoryType: categoryType.value,
            data: dataPagingController.value.list);
      default:
        return audioWrapList(dataPagingController.value.list);
    }
  }

  getWidgetData(int page, String? searchKeyword,
      {String? rating, String? subscriptionLevel = ""}) {
    searchKey.value = searchKeyword ?? searchKey.value;
    logPrint("i am here $searchKeyword");
    subscriptionLevel = selectedSub.value.optionName.toString().toLowerCase();
    logPrint(subscriptionLevel);
    rating = selectedRating
        .map((element) => element.ratingValue)
        .toList()
        .toString()
        .replaceAll("[", "")
        .replaceAll("]", "")
        .removeAllWhitespace;
    logPrint(rating);

    switch (viewType.value) {
      case CourseDetailViewType.video:
        screenType.value = "Videos";
        noDataType.value = StringResource.listenVideoLesson;
        getCourseData(
            pageNo: page,
            catId: catId.value,
            typeId: viewType.value,
            searchKeyword: searchKey.value,
            rating: rating,
            subscriptionLevel: subscriptionLevel);
        break;
      case CourseDetailViewType.blogs:
        screenType.value = "Blogs";
        noDataType.value = StringResource.viewBlogContent;
        getCourseData(
            pageNo: page,
            catId: catId.value,
            typeId: viewType.value,
            searchKeyword: searchKey.value,
            rating: rating,
            subscriptionLevel: subscriptionLevel);
        break;
      case CourseDetailViewType.audioCourse:
        screenType.value = "Audios";
        noDataType.value = StringResource.listenAudioCourse;
        getCourseData(
            pageNo: page,
            catId: catId.value,
            typeId: viewType.value,
            searchKeyword: searchKey.value,
            rating: rating,
            subscriptionLevel: subscriptionLevel);
        break;
      case CourseDetailViewType.videoCourse:
        screenType.value = "Videos";
        noDataType.value = StringResource.listenVideoCourse;
        getCourseData(
            pageNo: page,
            catId: catId.value,
            typeId: viewType.value,
            searchKeyword: searchKey.value,
            rating: rating,
            subscriptionLevel: subscriptionLevel);
        break;
      case CourseDetailViewType.textCourse:
        screenType.value = "Texts";
        noDataType.value = StringResource.readTextCourse;
        getCourseData(
            pageNo: page,
            catId: catId.value,
            typeId: viewType.value,
            searchKeyword: searchKey.value,
            rating: rating,
            subscriptionLevel: subscriptionLevel);
        break;
      default:
        screenType.value = "Audios";
        noDataType.value = StringResource.listenPodcasts;
        getCourseData(
            pageNo: page,
            catId: catId.value,
            typeId: viewType.value,
            searchKeyword: searchKey.value,
            rating: rating,
            subscriptionLevel: subscriptionLevel);
        break;
    }
  }
}
