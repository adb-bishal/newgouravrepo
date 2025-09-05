import 'package:get/get.dart';

import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/course_models/courses_model.dart';
import '../../../../model/network_calls/api_helper/provider_helper/courses_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../course_detail_controller/course_detail_controller.dart';

class RecommendedController extends GetxController{
  CourseProvider courseProvider = getIt();
  RxString courseId = "".obs;
  RxString categoryId = "".obs;
  RxString levelId = "".obs;
  RxString languageId = "".obs;
  RxString typeId = "".obs;
  RxDouble percent = 0.0.obs;
  RxDouble certificateCriteria = 0.0.obs;
  Rx<CourseDetailViewType> courseType = CourseDetailViewType.videoCourse.obs;
  Rx<CoursesModel> courseData = CoursesModel().obs;
  RxList<CommonDatum> dataPagingController = <CommonDatum>[].obs;
  RxBool isDataLoading = false.obs;
   @override
  void onInit() {
    if(Get.arguments != null){
      categoryId.value = Get.arguments[0].toString();
      languageId.value = Get.arguments[1].toString();
      levelId.value = Get.arguments[2].toString();
      typeId.value = Get.arguments[3].toString();
      courseId.value = Get.arguments[4].toString();
      percent.value = Get.arguments[5]??0.0;
      certificateCriteria.value = Get.arguments[6]??0.0;
    }
    if(typeId.value == "1"){
      courseType.value = CourseDetailViewType.textCourse;
    }else if(typeId.value == "2"){
      courseType.value = CourseDetailViewType.audioCourse;
    }else{
      courseType.value = CourseDetailViewType.videoCourse;
    }
    getRecommendedData();
    super.onInit();
  }

  getRecommendedData()async{
    isDataLoading.value = true;
    await courseProvider.getCourseData(
      criteria: certificateCriteria.value,
        onError: (message,errorMap) {
          toastShow(message: message);
          isDataLoading.value = false;
        },
        onSuccess: (message, json) {
          courseData.value = CoursesModel.fromJson(json!);
          dataPagingController.addAll(List<CommonDatum>.from(courseData.value.data!.data!.map((x) => CommonDatum.fromJson(x.toJson()))));
          isDataLoading.value = false;
        },
        percent: percent.value,

        catId: categoryId.value,
        langId: languageId.value,
        pageNo: 1,
        currentId:courseId.value,
        type: courseType.value);
  }

}