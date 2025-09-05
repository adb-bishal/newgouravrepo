import 'package:get/get.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/all_category_controller/all_category_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/blogs_view_controller/blogs_view_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/text_course_detail_controller/text_course_detail_controller.dart';

import '../../controllers/root_view_controller/audio_course_detail_controller/audio_course_detail_controller.dart';
import '../../controllers/root_view_controller/category_detail_controller/category_detail_controller.dart';
import '../../controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../controllers/root_view_controller/text_course_controller/text_course_controller.dart';
import '../../controllers/root_view_controller/video_course_detail_controller/video_course_detail_controller.dart';

class AllCategoryBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<AllCategoryController>(() => AllCategoryController());
    Get.lazyPut<CategoryDetailController>(() => CategoryDetailController());
    Get.lazyPut<CourseDetailController>(() => CourseDetailController());
    Get.lazyPut<TextCourseDetailController>(() => TextCourseDetailController());
    Get.lazyPut<VideoCourseDetailController>(() => VideoCourseDetailController(),tag: "001");
    Get.lazyPut<AudioCourseDetailController>(() => AudioCourseDetailController());
    Get.lazyPut<TextCourseController>(() => TextCourseController());
    Get.lazyPut<BlogsViewController>(() => BlogsViewController());
  }

}