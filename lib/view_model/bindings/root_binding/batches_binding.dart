import 'package:get/get.dart';
import 'package:stockpathshala_beta/view_model/controllers/batch_controller/live_batch_controller.dart';
import '../../controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';

class BatchesBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LiveBatchesController>(() => LiveBatchesController());
    // Get.lazyPut<BatchDetailsController>(() => BatchDetailsController());
    // Get.lazyPut<BatchClassViewController>(() => BatchClassViewController());
    Get.lazyPut<LiveClassDetailController>(() => LiveClassDetailController());
  }
}
