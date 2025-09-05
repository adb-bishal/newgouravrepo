import 'package:get/get.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/quiz_controller/quiz_controller.dart';

import '../../controllers/root_view_controller/quiz_controller/quiz_result_controller.dart';
import '../../controllers/root_view_controller/quiz_controller/recommended_controller.dart';

class QuizBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<QuizController>(() => QuizController());
    Get.lazyPut<QuizResultController>(() => QuizResultController());
    Get.lazyPut<RecommendedController>(() => RecommendedController());
  }

}