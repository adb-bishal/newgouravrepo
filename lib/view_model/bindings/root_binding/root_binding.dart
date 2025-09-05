import 'package:get/get.dart';
import 'package:stockpathshala_beta/mentroship/controller/mentorship_controller.dart';
import 'package:stockpathshala_beta/mentroship/view/mentorship_screen.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/home_controller/home_see_all_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/notification_controller/notification_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/scalp_controller/scalp_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/widget_controllers/add_rating_controller.dart';

import '../../../mentroship/controller/mentorship_detail_controller.dart';
import '../../../service/floor/clientService.dart';
import '../../controllers/profile_controller/profile_controller.dart';
import '../../controllers/root_view_controller/courses_view_controller/courses_view_controller.dart';
import '../../controllers/root_view_controller/dashboard_controller/dashboard_controller.dart';
import '../../controllers/root_view_controller/faq_controller/faq_controller.dart';
import '../../controllers/root_view_controller/home_controller/home_view_controller.dart';
import '../../controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import '../../controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import '../../controllers/root_view_controller/my_live_class_controller/my_live_class_controller.dart';
import '../../controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
import '../../controllers/root_view_controller/promo_code_controller/promo_code_controller.dart';
import '../../controllers/root_view_controller/refer_and_earn_controller/refer_and_earn_controller.dart';
import '../../controllers/subscription_controller/subscription_controller.dart';

class RootBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ProfileController>(() => ProfileController());
    Get.lazyPut<RootViewController>(() => RootViewController());
    Get.lazyPut<GlobalService>(() => GlobalService());
    Get.lazyPut<HomeController>(() => HomeController());
    Get.lazyPut<CoursesViewController>(() => CoursesViewController());
    Get.lazyPut<LiveClassesController>(() => LiveClassesController());
    Get.lazyPut<LiveClassDetailController>(() => LiveClassDetailController());
    Get.lazyPut<PastClassesController>(() => PastClassesController());
    Get.lazyPut<AddRatingController>(() => AddRatingController());
    //  Get.lazyPut<ShowRatingController>(() => ShowRatingController(data: CourseDatum()));
    // Get.lazyPut<CommentController>(() => CommentController(data: CourseDatum()));
    Get.lazyPut<PromoCodeController>(() => PromoCodeController());
    Get.lazyPut<MyLiveClassController>(() => MyLiveClassController());
    Get.lazyPut<PromoCodeController>(() => PromoCodeController());
    Get.lazyPut<FaqController>(() => FaqController());
    Get.lazyPut<NotificationController>(() => NotificationController());
    // Get.lazyPut<ContinueWatchController>(() => ContinueWatchController());
    Get.lazyPut<DashboardController>(() => DashboardController());
    Get.lazyPut<SubscriptionController>(() => SubscriptionController());
    Get.lazyPut<ScalpController>(() => ScalpController());
    Get.lazyPut<ReferAndEarnController>(() => ReferAndEarnController());
    Get.lazyPut<HomeSeeAllController>(() => HomeSeeAllController());
    Get.lazyPut<MentorshipController>(() => MentorshipController());
    Get.lazyPut<MentorshipDetailController>(() => MentorshipDetailController());
  }
}
