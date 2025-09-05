import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../../model/models/scalp_model/comment_model.dart';
import '../../../../model/network_calls/api_helper/provider_helper/comment_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';
import '../../../../view/screens/root_view/widget/add_rating_widget.dart';

class CommentController extends GetxController {
  CommentController({required CourseDatum data}) {
    courseData.value = data;
  }
  Rx<CourseDatum> courseData = CourseDatum().obs;
  CommentProvider commentProvider = getIt();
  // RxString ratingType = "".obs;
  RxBool isCommentLoading = false.obs;
  RxBool isCommentDataLoading = false.obs;
  RxDouble rating = 0.0.obs;
  Rx<CommentModel> commentData = CommentModel().obs;
  TextEditingController commentController = TextEditingController();
  late Rx<PagingScrollController<Datum>> pagingController;

  @override
  void onInit() {
    pagingController = PagingScrollController<Datum>(
        onLoadMore: (int page, int totalItemsCount) async {
     await getComment(page, id: courseData.value.id ?? "");
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    getComment(1, id: courseData.value.id ?? "");
    super.onInit();
  }

  Future getComment(int pageNo, {required String id}) async {
    // ratingType.value = id;
    if (pageNo != 1) {
      pagingController.value.isDataLoading.value = true;
    } else {
      pagingController.value.reset();
      isCommentDataLoading.value = true;
    }
    await commentProvider.getComment(
        pageNo: pageNo,
        id: id,
        onSuccess: (message, json) {
          commentData.value = CommentModel.fromJson(json!);
          if (commentData.value.data?.data?.isNotEmpty ?? false) {
            pagingController.value.list.addAll(commentData.value.data!.data!);
          } else {
            if (pageNo != 1) {
              pagingController.value.isDataLoading.value = false;
            }
          }
          isCommentDataLoading.value = false;
        },
        onError: (message, errorMap) {
          toastShow(message: message);
          isCommentDataLoading.value = false;
        });
  }

  Future postComment() async {
    isCommentLoading.value = true;
    await commentProvider.postComment(
        onError: (message, errorMap) {
          isCommentLoading.value = false;
        },
        onSuccess: (message, map) {
          getComment(1, id: courseData.value.id ?? "");
          commentController.clear();
          isCommentLoading.value = false;
        },
        data: <String, dynamic>{
          "short_id": courseData.value.id ?? "",
          "comment": commentController.text,
        });
  }
}
