import 'package:get/get.dart';
import 'package:stockpathshala_beta/view_model/controllers/download_controller/download_course_detail_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/download_controller/download_list_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/download_controller/download_list_detail_controller.dart';

class DownloadBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<DownloadCourseController>(() => DownloadCourseController());
    Get.lazyPut<DownloadListController>(() => DownloadListController());
    Get.lazyPut<DownloadDetailController>(() => DownloadDetailController());
  }
}