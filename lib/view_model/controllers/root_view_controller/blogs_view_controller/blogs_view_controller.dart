import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/common_container_model/common_container_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/courses_provider.dart';

import '../../../../model/models/course_models/blog_detail_model.dart';
import '../../../../model/models/course_models/single_course_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../service/page_manager.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../../../../view/widgets/view_helpers/progress_dialog.dart';
import '../course_detail_controller/course_detail_controller.dart';
import '../video_course_detail_controller/video_course_detail_controller.dart';

class BlogsViewController extends GetxController {
  CourseProvider courseProvider = getIt();
  RxDouble blogHeight = 300.0.obs;
  RxBool isDataLoading = false.obs;
  RxBool isFullScreen = false.obs;
  RxString blogId = "".obs;
  RxString catId = "".obs;
  Rx<BlogDetailModel> blogData = BlogDetailModel().obs;
  RxList<CommonDatum> moreLikeData = <CommonDatum>[].obs;
  Rx<VideoTypePlayer> selectedVideo = VideoTypePlayer().obs;

  final pageManager = getIt<PageManager>();

  @override
  void onInit() {
    if (Get.arguments != null) {
      blogId.value = Get.arguments[0] ?? 0;
      catId.value = Get.arguments[1] ?? 0;
    }
    getBlogById();
    super.onInit();
  }

  @override
  void onClose() {
    pageManager.currentPlayingMedia.value = const MediaItem(id: "", title: "");
    pageManager.stop();
    pageManager.removeAll();
    super.onClose();
  }

  onPlayButton() async {
    if (Get.find<AuthService>().isGuestUser.value ||
        (!Get.find<AuthService>().isPro.value &&
            blogData.value.data?.isFree != 1)) {
      ProgressDialog().showFlipDialog(
          isForPro: Get.find<AuthService>().isGuestUser.value ? false : true);
    } else {
      if (pageManager.playButtonNotifier.value == ButtonState.playing) {
        pageManager.pause();
      } else {
        pageManager.play();
      }
    }
  }

  getBlogById() async {
    isDataLoading(true);
    await courseProvider.getBlogById(
        blogId: blogId.value,
        onError: (message, errorMap) {
          toastShow(message: message);
          isDataLoading(false);
        },
        onSuccess: (message, json) async {
          blogData.value = BlogDetailModel.fromJson(json!);
          isDataLoading(false);
          selectedVideo.value = VideoTypePlayer(
            id: blogData.value.data?.id.toString() ?? "",
            fileUrl: blogData.value.data?.videoUrl ?? "",
            fileType: blogData.value.data?.videoType ?? "",
          );
          if (blogData.value.data?.audioUrl != null) {
            pageManager.currentPlayingMedia.value =
                const MediaItem(id: "", title: "");
            pageManager.stop();
            await pageManager.playBlog(
                url: blogData.value.data?.audioUrl ?? '',
                title: blogData.value.data?.title ?? '',
                imageUrl: blogData.value.data?.image ?? "");
          }
          await courseProvider.getCourseMoreData(
              currentId: blogId.value,
              onError: (message, errorMap) {
                toastShow(message: message);
              },
              onSuccess: (message, json) {
                SingleCourseModel data = SingleCourseModel.fromJson(json!);
                if (data.data?.data?.isNotEmpty ?? false) {
                  moreLikeData.value = List<CommonDatum>.from(data.data!.data!
                      .map((x) => CommonDatum.fromJson(x.toJson())));
                }
              },
              catId: catId.value,
              type: CourseDetailViewType.blogs,
              pageNo: 1);
        });
  }
}
