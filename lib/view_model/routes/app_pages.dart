import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/mentroship/view/mentorship_detail_screen.dart';
import 'package:stockpathshala_beta/mentroship/view/mentorship_screen.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/view/screens/auth_view/sign_up_screen.dart';
import 'package:stockpathshala_beta/view/screens/courses_view/courses_view.dart';
import 'package:stockpathshala_beta/view/screens/home/home_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/batch_details/batch_details.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/batch_details/batch_details_notification.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/batch_details/detail_tabs/batch_class_detail.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/live_batches.dart';
import 'package:stockpathshala_beta/view/screens/root_view/blogs_view/blogs_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/category_detail_list_view/category_detail_list_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/chat/chat_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/cooming_soon/coming_soon_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/courses_detail_view/course_detail_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/dashboard_view/dashboard_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/downloads/download_list_detail_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/downloads/downloaded_list_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/explore_all_category_view/all_category_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/faq_view/faq_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/home_see_all_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/my_live_class_view/my_live_class_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/notifiaction_screen/notifiaction_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/profile/profile_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/profile/setting_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/promocode_view/promo_code_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quiz_list.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quizzes.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/recommended_course.dart';
import 'package:stockpathshala_beta/view/screens/root_view/refer_and_earn/refer_and_earn_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/t&c_view/t_and_c_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/watch_later_view/watch_later_see_all_view.dart';
import 'package:stockpathshala_beta/view/screens/subscription_view/in_app_purchase.dart';
import 'package:stockpathshala_beta/view/screens/subscription_view/offer_view.dart';
import 'package:stockpathshala_beta/view_model/bindings/all_category_binding/all_category_binding.dart';
import 'package:stockpathshala_beta/view_model/bindings/chat_binding/chat_binding.dart';
import 'package:stockpathshala_beta/view_model/bindings/quiz_binding/quiz_binding.dart';
import 'package:stockpathshala_beta/view_model/bindings/root_binding/batches_binding.dart';
import 'package:stockpathshala_beta/view_model/bindings/root_binding/feedback_binding/feedback_binding.dart';
import '../../model/services/auth_service.dart';
import '../../view/screens/auth_view/login_screen.dart';
import '../../view/screens/auth_view/otp_verify_screen.dart';
import '../../view/screens/auth_view/permission_screen.dart';
import '../../view/screens/auth_view/select_prefer.dart';
import '../../view/screens/root_view/audio_course_detail_view/audio_course_detail_view.dart';
import '../../view/screens/root_view/continue_watch/continue_watch_view.dart';
import '../../view/screens/root_view/give_feedback/give_feedback.dart';
import '../../view/screens/root_view/live_classes_view/live_class_detail/live_class_detail.dart';
import '../../view/screens/root_view/past_classes/past_live_classes_view.dart';
import '../../view/screens/root_view/quiz_view/quiz_result_view.dart';
import '../../view/screens/root_view/root_view.dart';
import '../../view/screens/root_view/scalps_view/scalps_view.dart';
import '../../view/screens/root_view/text_course_detail_view/text_course_detail_view.dart';
import '../../view/screens/root_view/text_course_view/text_course_view.dart';
import '../../view/screens/root_view/video_course_detail_view/video_course_detail_view.dart';
import '../../view/screens/root_view/watch_later_view/watch_later_view.dart';
import '../../view/screens/subscription_view/new_subscription_view.dart';
import '../../view/screens/subscription_view/subscription_view.dart';
import '../bindings/auth_binding/auth_binding.dart';
import '../bindings/download_binding/download_binding.dart';
import '../bindings/root_binding/root_binding.dart';
import '../bindings/watch_later_binding/watch_later_binding.dart';
import '../../view/screens/mentor/mentor_screen.dart';

part 'app_routes.dart';

class AppPages {
  //static String initial = Get.find<AuthService>().isLogin ? Get.find<AuthService>().isPermission == true ? Routes.rootView : Routes.permissionScreen : Routes.loginScreen;
  static String initial = Get.find<AuthService>().navigationFun();
  //static String initial =  Routes.rootView;
  static final routes = [
    /// auth view
    GetPage(
        name: Routes.loginScreen,
        page: () => const LoginScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.signUpScreen,
        page: () => const SignUpScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.otpScreen,
        page: () => const OtpVerifyScreen(),
        binding: AuthBinding()),
    GetPage(
        name: Routes.permissionScreen, page: () => const PermissionScreen()),
    GetPage(
        name: Routes.selectPrefer,
        page: () => const SelectPreferScreen(),
        binding: RootBinding()),

    // Mentorship view
    GetPage(
        name: Routes.mentorshipDetail(),
        page: () => MentorshipDetailScreen(),
        binding: RootBinding()),
    GetPage(
        name: Routes.mentorship,
        page: () => MentorshipScreen(),
        binding: RootBinding()),

    /// root view
    GetPage(
        name: Routes.rootView,
        page: () => const RootView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.mentorScreen,
        page: () => const MentorScreen(),
        binding: RootBinding()),
    GetPage(
        name: Routes.allCategory,
        page: () => const AllCategoryView(),
        binding: AllCategoryBinding()),
    GetPage(
        name: Routes.categoryDetail,
        page: () => const CategoryDetailView(),
        binding: AllCategoryBinding()),
    GetPage(
        name: Routes.courseDetail,
        page: () => const CourseDetailView(),
        binding: AllCategoryBinding()),
    GetPage(
        name: Routes.textCourseDetail(),
        page: () => const TextCourseDetailView(),
        binding: AllCategoryBinding()),
    //GetPage(name: Routes.videoCourseDetail(), page: ()=> VideoCourseDetailView(),binding: AllCategoryBinding()),
    GetPage(
        name: Routes.videoCourseDetail(),
        page: () => const VideoCourseDetailView()),
    GetPage(
        name: Routes.audioCourseDetail(),
        page: () => const AudioCourseDetailView(),
        binding: AllCategoryBinding()),
    GetPage(
        name: Routes.pastLiveClass,
        page: () => PastClassesView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.batchDetails,
        page: () => const BatchDetails(),
        binding: BatchesBindings()),
    GetPage(
        name: Routes.liveBatches,
        page: () => const LiveBatches(),
        binding: BatchesBindings()),
    GetPage(
        name: Routes.batchDetailsFromNotification,
        page: () => const BatchDetailsFromNotification(),
        binding: BatchesBindings()),
    GetPage(
        name: Routes.scalpScreen,
        page: () => const Material(child: ScalpView()),
        binding: RootBinding()),

    GetPage(
        name: Routes.batchClassDetails(),
        page: () => const BatchClassDetail(),
        binding: BatchesBindings()),
    GetPage(
        name: Routes.liveClassDetail(),
        page: () => const LiveClassDetail(),
        binding: RootBinding()),
    GetPage(
        name: Routes.myLiveClass,
        page: () => const MyLiveClassView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.liveWebinar,
        page: () => const LiveClassesView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.promoCode,
        page: () => const PromoCodeView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.faqScreen,
        page: () => const FaqView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.tncScreen,
        page: () => const TermsAndCondition(),
        binding: RootBinding()),
    GetPage(
        name: Routes.notificationView,
        page: () {
          AppConstants.trackScreen(screenName: Routes.notificationView);
          return const NotificationView();
        },
        binding: RootBinding()),
    GetPage(
        name: Routes.quizzesView,
        page: () => const QuizzesView(),
        binding: QuizBinding()),
    GetPage(
        name: Routes.quizMainView,
        page: () => const QuizMainScreen(),
        binding: QuizBinding()),
    GetPage(
        name: Routes.quizResultView,
        page: () => const QuizResultScreen(),
        binding: QuizBinding()),
    GetPage(
        name: Routes.feedbackScreen,
        page: () => const FeedbackScreen(),
        binding: FeedbackBindings()),
    GetPage(
        name: Routes.profileScreen,
        page: () => const ProfileView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.continueWatchScreen(),
        page: () => const ContinueWatchView()),
    GetPage(
        name: Routes.recommendedCourse,
        page: () => const RecommendedView(),
        binding: QuizBinding()),
    GetPage(
        name: Routes.downloadListView,
        page: () => const DownloadListView(),
        binding: DownloadBinding()),
    GetPage(
        name: Routes.downloadDetailView,
        page: () => const DownloadDetailView(),
        binding: DownloadBinding()),
    //GetPage(name: Routes.recommendedCourse, page: ()=>const RecommendedView(),binding: QuizBinding()),
    GetPage(
        name: Routes.chatView,
        page: () => const ChatViewScreen(),
        binding: ChatBinding()),
    GetPage(
        name: Routes.dashboardView,
        page: () => const DashBoardView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.watchLaterView,
        page: () => const WatchLaterView(),
        binding: WatchLaterBinding()),
    GetPage(
        name: Routes.textCourseView(),
        page: () => const TextCourseView(),
        binding: AllCategoryBinding()),
    GetPage(
        name: Routes.blogsView(),
        page: () => const BlogsView(),
        binding: AllCategoryBinding()),
    GetPage(
        name: Routes.watchLaterSeeAllView,
        page: () => const WatchLaterSeeAllView(),
        binding: WatchLaterBinding()),
    GetPage(
        name: Routes.homeSeeAllView,
        page: () => const HomeSeeAllView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.homeScreen,
        // page: () => const HomeViewScreen(),
        page: () =>  const HomeScreen(),
        binding: RootBinding()),
    GetPage(
        name: Routes.subscriptionView,
        page: () => const SubscriptionView2(),
        binding: RootBinding()),
    // GetPage(
    //    name: Routes.subscriptionView,
    //    page: () => MyApp2(),
    //    binding: RootBinding()),
    // GetPage(
    //     name: Routes.subscriptionViewOld,
    //     page: () => const SubscriptionView(),
    //     binding: RootBinding()),
    GetPage(
        name: Routes.couponView,
        page: () => const OfferView(),
        binding: RootBinding()),
    GetPage(
        name: Routes.referAndEarn,
        page: () => const ReferAndEarn(),
        binding: RootBinding()),
    GetPage(
        name: Routes.drawercourses,
        page: () => const CoursesView(),
        binding: RootBinding()),
    // GetPage(name: Routes.liveClassLaunch, page: ()=>const ),
    GetPage(name: Routes.comingSoon, page: () => const ComingSoonScreen()),

    GetPage(name: Routes.settingView, page: () => const SettingView()),
  ];
}
