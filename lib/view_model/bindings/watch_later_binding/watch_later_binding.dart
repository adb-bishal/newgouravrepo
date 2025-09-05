import 'package:get/get.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/watch_later_controller/watch_later_controller.dart';

import '../../controllers/root_view_controller/watch_later_controller/watch_later_see_all_controller.dart';

class WatchLaterBinding extends Bindings{
  @override
  void dependencies() {
    Get.lazyPut<WatchLaterController>(() => WatchLaterController());
    Get.lazyPut<WatchLaterSeeAllController>(() => WatchLaterSeeAllController());
  }

}