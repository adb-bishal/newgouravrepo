import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/courses_provider.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';

import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/course_models/course_by_id_model.dart';
import '../../../../model/models/course_models/course_status_model.dart';
import '../../../../model/models/course_models/courses_model.dart';
import '../../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../root_view_controller.dart';

class TextCourseDetailController extends GetxController {
  CourseProvider courseProvider = getIt();
  RxString categoryType = "".obs;
  RxString categoryId = "".obs;
  RxBool isDataLoading = false.obs;
  RxBool downloadingLoader = false.obs;
  Rx<CourseByIdModel> courseData = CourseByIdModel().obs;
  RxList<CommonDatum> moreLikeData = <CommonDatum>[].obs;
  Rx<CourseStatus> courseStatus = CourseStatus().obs;

  @override
  void onInit() {
    if (Get.arguments != null) {
      categoryType.value = Get.arguments[0] ?? "";
      if (Get.arguments[1] is String) {
        categoryId.value = Get.arguments[1];
      }
    }
    logPrint("i am");
    getTextCourseById();
    getCourseStatus();

    AppConstants.instance.valueListenerVar.listen((p0) {
      if (p0 == "run") {
        getCourseStatus();
        AppConstants.instance.valueListenerVar.value = "";
      }
    });
    super.onInit();
  }

  onWatchLater() async {
    await Get.find<RootViewController>().saveToWatchLater(
        id: courseData.value.data?.id ?? 0,
        type: "course_text",
        response: (WishListSaveModel data) {
          if (data.data ?? false) {
            courseData.value.data?.isWishlist!.value = 1;
          } else {
            courseData.value.data?.isWishlist!.value = 0;
          }
        });
  }

  getCourseStatus() async {
    await courseProvider.getCourseStatus(
        onError: (message, errorMap) {
          // toastShow(message: message);
        },
        onSuccess: (message, json) {
          if (json?['data']?.isNotEmpty) {
            courseStatus.value = CourseStatus.fromJson(json ?? {});
          }
        },
        courseId: categoryId.value);
  }

  getTextCourseById() async {
    isDataLoading.value = true;
    await courseProvider.getCourseById(
      onError: (message, errorMap) {
        //toastShow(message: message, error: true);
        isDataLoading.value = false;
      },
      onSuccess: (message, json) async {
        courseData.value = CourseByIdModel.fromJson(json!);
        categoryType.value = courseData.value.data?.courseCategory?.title ?? "";
        isDataLoading.value = false;
        await courseProvider.getCourseMoreData(
            currentId: categoryId.value,
            onError: (message, errorMap) {
              toastShow(message: message);
            },
            onSuccess: (message, json) {
              CoursesModel data = CoursesModel.fromJson(json!);
              if (data.data?.data?.isNotEmpty ?? false) {
                moreLikeData.value = List<CommonDatum>.from(data.data!.data!
                    .map((x) => CommonDatum.fromJson(x.toJson())));
              }
            },
            catId: courseData.value.data?.categoryId.toString() ?? "",
            type: CourseDetailViewType.textCourse,
            pageNo: 1);
      },
      courseId: categoryId.value,
      type: CourseDetailViewType.textCourse,
    );
  }
}
