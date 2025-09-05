import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/explore_all_category/category_detail_model.dart';
import '../../../../model/network_calls/api_helper/provider_helper/courses_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../view/screens/root_view/home_view/widget/audio_course_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/audio_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/blogs_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/text_course_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/video_course_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/videos_widget.dart';
import '../../../routes/app_pages.dart';
import '../course_detail_controller/course_detail_controller.dart';

class CategoryDetailController extends GetxController {
  CourseProvider courseProvider = getIt();
  Rx<CategoryDetailModel> categoryDetailData = CategoryDetailModel().obs;
  RxBool isDataLoading = false.obs;
  RxString categoryType = "".obs;
  RxInt categoryId = 0.obs;
  final Rx<GlobalKey<AnimatedListState>> listKey =
      GlobalKey<AnimatedListState>().obs;

  /// This holds the items
  RxList<Widget> items = <Widget>[].obs;

  /// This holds the item count
  RxInt counter = 0.obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      categoryType.value = Get.arguments[0];
      categoryId.value = Get.arguments[1];
    }
    getCategoryDetail();
    super.onInit();
  }

  Future<void> onRefresh() async {
    items.clear();
    getCategoryDetail();
  }

  getCategoryDetail() async {
    isDataLoading.value = true;
    await courseProvider.getCategoryDetail(
        catId: categoryId.value.toString(),
        onError: (message, errorMap) {
          isDataLoading.value = false;
          toastShow(message: message);
        },
        onSuccess: (message, json) {
          categoryDetailData.value = CategoryDetailModel.fromJson(json!);
          if (categoryDetailData.value.data?.videos?.isNotEmpty ?? false) {
            items.add(VideosWidget(
              data: List<CommonDatum>.from(categoryDetailData
                  .value.data!.videos!
                  .map((x) => CommonDatum.fromJson(x.toJson()))),
              onTap: () {
                Get.toNamed(Routes.courseDetail, arguments: [
                  categoryType.value,
                  CourseDetailViewType.video,
                  categoryDetailData.value.data?.description ?? "",
                  categoryDetailData.value.data?.id
                ]);
              },
            ));
          }
          if (categoryDetailData.value.data?.audios?.isNotEmpty ?? false) {
            items.add(AudiosWidget(
              data: List<CommonDatum>.from(categoryDetailData
                  .value.data!.audios!
                  .map((x) => CommonDatum.fromJson(x.toJson()))),
              onTap: () {
                Get.toNamed(Routes.courseDetail, arguments: [
                  categoryType.value,
                  CourseDetailViewType.audio,
                  categoryDetailData.value.data?.description ?? "",
                  categoryDetailData.value.data?.id
                ]);
              },
            ));
          }
          if (categoryDetailData.value.data?.blogs?.isNotEmpty ?? false) {
            items.add(BlogsWidget(
              data: List<CommonDatum>.from(categoryDetailData.value.data!.blogs!
                  .map((x) => CommonDatum.fromJson(x.toJson()))),
              onTap: () {
                Get.toNamed(Routes.courseDetail, arguments: [
                  categoryType.value,
                  CourseDetailViewType.blogs,
                  categoryDetailData.value.data?.description ?? "",
                  categoryDetailData.value.data?.id
                ]);
              },
            ));
          }
          if (categoryDetailData.value.data?.courseVideos?.isNotEmpty ??
              false) {
            items.add(VideoCourseWidget(
              data: List<CommonDatum>.from(categoryDetailData
                  .value.data!.courseVideos!
                  .map((x) => CommonDatum.fromJson(x.toJson()))),
              onTap: () {
                Get.toNamed(Routes.courseDetail, arguments: [
                  categoryType.value,
                  CourseDetailViewType.videoCourse,
                  categoryDetailData.value.data?.description ?? "",
                  categoryDetailData.value.data?.id
                ]);
              },
            ));
          }
          if (categoryDetailData.value.data?.courseTexts?.isNotEmpty ?? false) {
            items.add(TextCourseWidget(
              categoryType: categoryType.value,
              data: List<CommonDatum>.from(categoryDetailData
                  .value.data!.courseTexts!
                  .map((x) => CommonDatum.fromJson(x.toJson()))),
              onTap: () {
                Get.toNamed(Routes.courseDetail, arguments: [
                  categoryType.value,
                  CourseDetailViewType.textCourse,
                  categoryDetailData.value.data?.description ?? "",
                  categoryDetailData.value.data?.id
                ]);
              },
            ));
          }
          if (categoryDetailData.value.data?.courseAudios?.isNotEmpty ??
              false) {
            items.add(AudioCourseWidget(
              data: List<CommonDatum>.from(categoryDetailData
                  .value.data!.courseAudios!
                  .map((x) => CommonDatum.fromJson(x.toJson()))),
              onSeeAll: () {
                Get.toNamed(Routes.courseDetail, arguments: [
                  categoryType.value,
                  CourseDetailViewType.audioCourse,
                  categoryDetailData.value.data?.description ?? "",
                  categoryDetailData.value.data?.id
                ]);
              },
            ));
          }
          isDataLoading.value = false;
        });
  }
}
