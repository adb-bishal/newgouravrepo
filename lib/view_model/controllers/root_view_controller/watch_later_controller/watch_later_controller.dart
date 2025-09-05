import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/wishlist_provider.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';

import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/wishlist_data_model/wishlist_data_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../view/screens/root_view/home_view/widget/audio_course_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/audio_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/text_course_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/video_course_widget.dart';
import '../../../../view/screens/root_view/home_view/widget/videos_widget.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../../../routes/app_pages.dart';
import '../root_view_controller.dart';

class WatchLaterController extends GetxController {
  WishListProvider wishListProvider = getIt();
  RxBool isDataLoading = false.obs;
  Rx<WishListDataModel> wishListData = WishListDataModel().obs;
  RxList<Widget> items = <Widget>[].obs;

  @override
  void onInit() {
    getWishlistsData();
    super.onInit();
  }

  getWishlistsData() async {
    isDataLoading.value = true;
    items.clear();
    await wishListProvider.getWishlistsData(onError: (message, errorMap) {
      isDataLoading.value = false;
      toastShow(message: message);
    }, onSuccess: (message, json) {
      wishListData.value = WishListDataModel.fromJson(json!);
      if (wishListData.value.data?.video?.isNotEmpty ?? false) {
        items.add(VideosWidget(
          data: List<CommonDatum>.from(wishListData.value.data!.video!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onTap: () {
            Get.toNamed(Routes.watchLaterSeeAllView,
                    arguments: [StringResource.singleVideo, "video"])!
                .then((value) {
              getWishlistsData();
            });
          },
          // onWishlist: (){
          //   getWishlistsData();
          // },
        ));
        for (Audio dataaa in wishListData.value.data?.video ?? []) {
          if (!Get.find<RootViewController>().videoData.any((element) =>
              element.id?.value.toString() == dataaa.id.toString())) {
            Get.find<RootViewController>().videoData.add(CourseWishlist(
                id: RxInt(dataaa.id ?? 0),
                isWishList: RxInt(dataaa.isWishList ?? 0)));
          }
        }
      }
      if (wishListData.value.data?.audio?.isNotEmpty ?? false) {
        items.add(AudiosWidget(
          data: List<CommonDatum>.from(wishListData.value.data!.audio!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onTap: () {
            Get.toNamed(Routes.watchLaterSeeAllView, arguments: [
              StringResource.singleAudio,
              "audio",
            ])!
                .then((value) {
              getWishlistsData();
            });
          },
        ));
        for (Audio dataaa in wishListData.value.data?.audio ?? []) {
          if (!Get.find<RootViewController>().audioData.any((element) =>
              element.id?.value.toString() == dataaa.id.toString())) {
            Get.find<RootViewController>().audioData.add(CourseWishlist(
                id: RxInt(dataaa.id ?? 0),
                isWishList: RxInt(dataaa.isWishList ?? 0)));
          }
        }
      }
      // if(wishListData.value.data?.blog?.isNotEmpty??false){
      //   items.add(BlogsWidget(
      //     data: List<CommonDatum>.from(wishListData.value.data!.blog!.map((x) => CommonDatum.fromJson(x.model?.toJson()??{}))),
      //     onTap: (){
      //       Get.toNamed(Routes.watchLaterSeeAllView,arguments: [StringResource.,"video"]);          },
      //   ));
      //   count++;
      // }
      if (wishListData.value.data?.courseVideo?.isNotEmpty ?? false) {
        items.add(VideoCourseWidget(
          data: List<CommonDatum>.from(wishListData.value.data!.courseVideo!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onTap: () {
            Get.toNamed(Routes.watchLaterSeeAllView, arguments: [
              StringResource.videoCourses,
              AppConstants.videoCourse
            ])!
                .then((value) {
              getWishlistsData();
            });
          },
        ));
        for (Course dataaa in wishListData.value.data?.courseVideo ?? []) {
          if (!Get.find<RootViewController>().videoCourseData.any((element) =>
              element.id?.value.toString() == dataaa.id.toString())) {
            Get.find<RootViewController>().videoCourseData.add(CourseWishlist(
                id: RxInt(dataaa.id ?? 0),
                isWishList: RxInt(dataaa.isWishList ?? 0)));
          }
        }
      }
      if (wishListData.value.data?.courseText?.isNotEmpty ?? false) {
        items.add(TextCourseWidget(
          categoryType: StringResource.watchLater,
          data: List<CommonDatum>.from(wishListData.value.data!.courseText!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onTap: () {
            Get.toNamed(Routes.watchLaterSeeAllView, arguments: [
              StringResource.textCourses,
              AppConstants.textCourse
            ])!
                .then((value) {
              getWishlistsData();
            });
          },
        ));
        for (Course dataaa in wishListData.value.data?.courseText ?? []) {
          if (!Get.find<RootViewController>().textCourseData.any((element) =>
              element.id?.value.toString() == dataaa.id.toString())) {
            Get.find<RootViewController>().textCourseData.add(CourseWishlist(
                id: RxInt(dataaa.id ?? 0),
                isWishList: RxInt(dataaa.isWishList ?? 0)));
          }
        }
      }
      if (wishListData.value.data?.courseAudio?.isNotEmpty ?? false) {
        items.add(AudioCourseWidget(
          data: List<CommonDatum>.from(wishListData.value.data!.courseAudio!
              .map((x) => CommonDatum.fromJson(x.model?.toJson() ?? {}))),
          onSeeAll: () {
            Get.toNamed(Routes.watchLaterSeeAllView, arguments: [
              StringResource.audioCourses,
              AppConstants.audioCourse
            ])!
                .then((value) {
              getWishlistsData();
            });
          },
        ));
        for (Course dataaa in wishListData.value.data?.courseAudio ?? []) {
          if (!Get.find<RootViewController>().audioCourseData.any((element) =>
              element.id?.value.toString() == dataaa.id.toString())) {
            Get.find<RootViewController>().audioCourseData.add(CourseWishlist(
                id: RxInt(dataaa.id ?? 0),
                isWishList: RxInt(dataaa.isWishList ?? 0)));
          }
        }
      }
      isDataLoading.value = false;
    });
  }
}
