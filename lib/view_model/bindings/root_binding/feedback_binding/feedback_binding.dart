import 'package:get/get.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/feedback_controller/feedback_controller.dart';

class FeedbackBindings extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<FeedbackController>(() => FeedbackController());
  }

}