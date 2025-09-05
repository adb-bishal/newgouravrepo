// ignore_for_file: constant_identifier_names

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

class AppConstants {
  static AppConstants? _instance;
  static AppConstants get instance => _instance ??= AppConstants._init();
  AppConstants._init();
  final Duration fast = const Duration(milliseconds: 300);
  final Duration med = const Duration(milliseconds: 600);
  final Duration slow = const Duration(milliseconds: 1000);
  final Duration pageTransition = const Duration(milliseconds: 200);

  /// return live url for release mode, if in debug then depending on
  /// bool provided return dev or live
  String getHost() {
    String url;
     url = 'https://internal.stockpathshala.in'; // live link
     // url = 'https://dev2.stockpathshala.com'; // live link
    //url ='https://dev1.stockpathshala.com/';

    // url = 'https://sp-backend-beta.stockpathshala.com'; // beta link

    logPrint('server url: $url');
    return url;
  }

  String get hostName => getHost();
  String get baseUrl => "$hostName/api/v1/";
  String get baseTwoUrl => "$hostName/api/v2/";

  String get guestUserProfile => '$hostName/blank_user.png';

  String get privacyUrl => 'https://www.stockpathshala.com/privacy-policy/';
  String get certificateDownload => '${baseUrl}download-certificate';
  String get dynamicLink => 'https://stockpathshalaapp.page.link';
  String get fallBackUrl => "http://stockpathshala.in/";
  String get appStoreId => '6446473535';
  String get packageName => 'com.codeclinic.stockpathshala';
  // String get packageName => 'com.codeclinic.stockpathshala';
  String get bundleId => 'com.codeclinic.stockpathshala';
  // String get bundleId => 'com.codeclinic.stockpathshala';
  RxString valueListenerVar = "".obs;
  String get redirectWebUrl => 'stockpathshala';

  static const String APP_ID = "52a27e17-3132-4e8e-bf3e-9cfa430afc1d";
  static const String APP_KEY = "d5857052-d162-4a0c-9de4-eeb3b9e9839b";
  static const String DOMAIN = "msdk.in.freshchat.com";

  static const String encodingKey = "stockpathshala32";
  // razor pay key
  String get razorPaySecretKey => 'Gxu6t4E6v58Qd3U5A6CRW9DM';
  String get razorPayKey => 'rzp_test_ZL2kZDzjuMuBpN';
  static const String orderApiRazorpay = 'https://api.razorpay.com/v1/orders';

  /// chat bot
  String get kommunicateAppId => "1dfad1374202588cf8a2b796243d86de1";

  /// auth
  String get appVersion => Get.find<AuthService>().version.value;
  String get socialLogin => "social-login";
  String get counselling => "counselling/mentors";
  // String get mentorList => "counselling/mentorsList";
  String get mentorList => "counselling/all-mentor";
  String get mentorSlots => "counselling/mentor-slots";
  String get verifyPayment => "counselling-purchase-verify";
  String get socialLoginNumber => "firebase-login";
  String get socialLoginVerify => "firebase-login-verify";
  String get signIn => "login-register";
  String get updateUserDataForApp => "update_user_data_for_app";
  String get loginPageData => "login_page_data";
  String get signInVerify => "verify-login-register";
  String get signUp => "register";
  String get signUpVerify => "register-verify";

  /// container width
  double containerWidth = 104.5;
  double containerHeight = 104.5;

  RxString singleCourseId = "".obs;
  RxString blogId = "".obs;
  RxString liveId = "".obs;
  RxString batchId = ''.obs;
  RxString videoCourseId = "".obs;
  RxString upcomingBatchId = "".obs;
  RxString pastBatchId = "".obs;
  RxString upcomingLiveWebinarId = "".obs;
  RxString pastWebinarId = "".obs;
  RxString mentorshipId = "".obs;

  /// account
  String get language => "languages";
  String get counsellors => "/counselling/mentors";
  String get level => "levels";
  String get service => "setting/base/secret";
  String get tags => "tags";
  String get logOut => "logout";
  String get deleteAccount => "delete_account";
  String get referby => "referral-update";
  String get getProfile => "get-profile";
  String get profileUpdate => "profile-update";
  String get profileImageUpdate => "profile-image-update";
  static const String shareScalp = "scalp";
  static const String shareBlog = "blog";
  static const String shareDownload = "download";
  static const String shareAudio = "audio";
  static const String shareVideo = "video";
  static const String shareLiveClass = "live";
  static const String sharePastLiveClass = "past_live";
  static const String shareVideoCourse = "video_course";
  static const String shareAudioCourse = "audio_course";
  static const String shareTextCourse = "text_course";
  static const String promocodeShare = "promocode";

  /// Filter by Teacher
  String get filterbyTeacher => '${baseUrl}user_has_roles';

  /// Batches
  String get allBatches => 'all_batches';
  String get pastBatches => 'past_batches';
  String get batchData => 'all_batch_live_class';
  String get batchDates => 'all_batches_dates';
  String get createCounsellingOrder => 'create-counselling-order';
  String get allBatchPastLiveClass => 'all_batch_past_live_class';

  /// courses
  static const String getAllCategories = "categories";
  static const String category = "category/";
  static const String singleVideo = "videos?category_id=";
  static const String singleAllVideo = "videos?";
  static const String singleVideoByTag = "videos?category_id=";
  static const String singleAudioByTag = "audios?category_id=";
  static const String singleAudio = "audios?category_id=";
  static const String singleAllAudio = "audios?";
  static const String blog = "blogs?category_id=";
  static const String blogAll = "blogs?";
  static const String blogById = "blog/";
  static const String course = "courses?";
  static const String video = "video/";
  static const String audio = "audio/";
  static const String courseById = "course/";
  static const String openTradingAccount = "open-trading-account";

  /// course endpoint
  static const String textCourse = "course_text";
  static const String videoCourse = "course_video";
  static const String audioCourse = "course_audio";
  static const String counsellingCategories = "counselling_categories";
  static const String counsellingPage = "counselling_page";

  static const String subscription = "subscription";
  static const String quizRedirect = "quiz";
  static const String audioRedirect = "audio";
  static const String blogRedirect = "blog";
  static const String videoRedirect = "video";
  static const String liveClass = "live_classes_slug";
  static const String liveClassBanner = "live_class";
  static const String batchClass = 'batch_class';
  static const String upcomingBatchClass = 'upcoming_batch_page';
  static const String pastBatchPage = 'past_batch_page';
  static const String upcomingWebinarPage = 'upcoming_webinar_page';
  static const String pastWebinarPage = 'past_webinar_page';
  static const String mentorshipPage = 'mentorship_page';
  static const String upcomingBatch = 'upcoming_batch';
  static const String pastBatch = 'past_batch';
  static const String upcomingLiveClass = 'upcoming_live_class';
  static const String pastLiveClass = 'past_live_class';
  static const String mentorshipClass = 'mentorship';

  /// chat
  String get chatBotQuestion => "chatbots";

  /// webhook
  String get webHookUrl => "razorpay/webhook/order/paid";

  /// live
  String get live => "live_classes";
  String get postLiveCallStatus => "open-trading-account-for-pro";
  String get pastLive => "past_live_classes";
  String get buyLivePackage => "buy-live-class";
  String get myClassLive => "my_live_classes";

  /// t&c
  String get termsAndCondition => "setting/terms_and_condition";

  /// wishlist
  String get wishlist => "wishlists";

  /// quiz
  String get quiz => "quizzes?limit=20&page=";
  String get quizById => "quizzes";

  /// reviews
  String get reviews => "reviews";

  /// scalps comment
  String get getComment => "short-comments/";
  String get postComment => "short-comment";
  String get onLike => "short-like";
  String get onShare => "short-share";

  /// course history
  String get courseHistory => "courses/history";
  String get continueLearning => "continue_learnings";

  /// drawer
  String get feedback => "feedback";
  String get userAvgTime => "user-average-times";
  String get onRedeem => "redeem-now";
  String get versionHistories => "version_histories";
  String get faq => "faqs";
  String get dashboard => "dashboard";
  String get popUp => "trial_period_flow";
  String get promocode => "user_promo_codes?limit=10&page=";
  String get notification => "notifications?limit=20&page=";
  String get notificationCount => "notifications/count";
  String get scalps => "shorts?limit=10&page=";
  String get setGoal => "set-goals";
  String get shortHistory => "shorts";

  /// home data
  String get homeData => "home?level_id=";

  /// home data
  String get subscriptionPlan => "subscriptions";
  String get subscribedPlan => "subscribed-package";
  String get subscriptionDescription => "subscription_description";
  String get specialOffer => "promo_codes/special_sale";
  String get offerBanner => "subscription_banners";
  String get offerCode => "promo_codes?limit=10&page=";
  String get applyCode => "promo_code/apply";
  String get buyPackage => "buy-package";
  String get buyMentorship => "buy-mentorship";

  static String formatDate(DateTime? date) {
    if (date?.year == 1999 || date == null) {
      return "";
    } else {
      return DateFormat("MMM dd, yyyy").format(date.toLocal());
    }
  }

  static String formatDateInForm(DateTime? date) {
    if (date?.year == 1999 || date == null) {
      return "";
    } else {
      return DateFormat("dd MMM yyyy").format(date.toLocal());
    }
  }

  static String formatSmallDate(DateTime date) =>
      DateFormat("dd MMM").format(date.toLocal());

  static String formatDateAndTime(DateTime? date) {
    if (date?.year == 1999 || date == null) {
      return "June 12, 2021 | 04:50 PM";
    } else {
      return DateFormat("MMM dd, yyyy | hh:mm aa").format(date.toLocal());
    }
  }
  static Future setUserToAnalytics() async {
    try {
      logPrint(
          "user id ddd ${Get.find<AuthService>().user.value.id.toString()}");
      await FirebaseAnalytics.instance.setUserId(
          id: (Get.find<AuthService>().user.value.id ?? "").toString());
    } catch (e) {
      logPrint(e.toString());
    }
  }

  static Future trackScreen({required String screenName}) async {
    try {
      await FirebaseAnalytics.instance.setCurrentScreen(screenName: screenName);
    } catch (e) {
      logPrint(e.toString());
    }
  }
}
