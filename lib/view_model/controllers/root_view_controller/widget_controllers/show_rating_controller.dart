import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/rating_provider.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/widget/add_rating_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../../model/models/rating_model/rating_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';

class ShowRatingController extends GetxController {
  ShowRatingController({required CourseDatum data}) {
    courseData = data.obs;
  }
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;
  late Rx<CourseDatum> courseData;
  RatingProvider ratingProvider = getIt();
  RxString ratingType = "".obs;
  RxString ratingId = "".obs;
  RxString feedbackError = "".obs;
  RxBool isPostLoading = false.obs;
  RxDouble rating = 4.0.obs;
  Rx<GetReviewModel> reviewData = GetReviewModel().obs;
  TextEditingController feedbackController = TextEditingController();
  late Rx<PagingScrollController<Datum>> pagingController;

  onRatingChange(val) {
    rating.value = val;
  }

  @override
  void onInit() {
    super.onInit();
    pagingController = PagingScrollController<Datum>(
        onLoadMore: (int page, int totalItemsCount) async {
    await  getRating(page, type: ratingType.value, id: ratingId.value);
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    logPrint("course data ${courseData.value.id}");
    getRating(1,
        type: courseData.value.type ?? "", id: courseData.value.id ?? "");
  }

  Future getRating(
    int pageNo, {
    required String type,
    required String id,
  }) async {
    ratingType.value = type;
    ratingId.value = id;
    if (pageNo != 1) {
      pagingController.value.isDataLoading.value = true;
    } else {
      pagingController.value.reset();
    }

    await ratingProvider.getRating(
        id: id,
        pageNo: pageNo,
        type: type,
        onSuccess: (message, json) {
          reviewData.value = GetReviewModel.fromJson(json!);
          logPrint("i am $id");
          reviewData.value.data?.pagination?.count;
          if (reviewData.value.data?.data?.isNotEmpty ?? false) {
            pagingController.value.list.addAll(reviewData.value.data!.data!);
          } else {
            if (pageNo != 1) {
              pagingController.value.isDataLoading.value = false;
            }
          }
          // logPrint("hi ${pagingController.value.list.length}");
        },
        onError: (message, errorMap) {});
  }

  Future postRating({required String type, required String id}) async {
    logPrint("id $id");
    isPostLoading.value = true;
    await ratingProvider.postRating(
        onError: (message, errorMap) {
          isPostLoading.value = false;
          toastShow(message: message);
        },
        onSuccess: (message, map) {
          isPostLoading.value = false;
          Get.back();
          getRating(1, type: ratingType.value, id: courseData.value.id ?? "");
          feedbackController.clear();
          rating.value = 4.0;
          toastShow(message: StringResource.reviewAdded);
        },
        data: <String, dynamic>{
          "type": type,
          "reviewable_id": id,
          "comment": feedbackController.text,
          "rating": rating.value
        });
  }
}
