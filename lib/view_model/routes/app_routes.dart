part of 'app_pages.dart';

abstract class Routes {
  /// auth view
  static const loginScreen = "/LoginScreen";
  static const signUpScreen = "/signUpScreen";
  static const otpScreen = "/otpScreen";
  static const permissionScreen = "/PermissionScreen";
  static const selectPrefer = "/selectPrefer";

  // mentorship view
  static mentorshipDetail({String? id}) => "/mentorshipDetail/${id ?? ""}";
  static const mentorship = "/mentorship";

  /// root view
  static const rootView = "/rootView";
  static const mentorScreen = "/mentor";
  static const comingSoon = "/comingSoon";
  static const allCategory = "/allCategory";
  static const categoryDetail = "/categoryDetail";
  static const courseDetail = "/courseDetail";
  static textCourseDetail({String? id}) => "/textCourseDetail/${id ?? ""}";
  static videoCourseDetail({String? id}) => "/videoCourseDetail/${id ?? ""}";
  static audioCourseDetail({String? id}) => "/audioCourseDetail/${id ?? ''}";
  static mentorDetailScreen({String? id}) => "/mentor/${id ?? ''}";

  /// live class
  static const pastLiveClass = "/pastLiveClass";
  static liveClassDetail({String? id}) => "/liveClassDetail/${id ?? ''}";

  /// Batches
  static const batchDetails = '/batchDetails';
  static const batchDetailsFromNotification = '/batchPage';
  static batchClassDetails({String? id}) => "/batchClassDetail/${id ?? ''}";
  static const batchClassView = '/batchClassView';
  static const liveBatches = '/liveBatches';

  /// home screen
  static const homeScreen = "/HomeScreen";
  static continueWatchScreen({String? id}) =>
      "/continueWatchScreen/${id ?? ''}";
  static blogsView({String? id}) => "/blogsView/${id ?? ""}";
  static textCourseView({String? id}) => "/textCourseView/${id ?? ""}";

  /// live webinar screen
  static const liveWebinar = "/liveWebinar";

  /// drawer
  static const myLiveClass = "/myLiveClass";
  static const promoCode = "/promoCode";
  static const faqScreen = "/faqScreen";
  static const tncScreen = "/tncScreen";
  static const notificationView = "/notificationView";
  static const quizzesView = "/quizzesView";
  static const quizMainView = "/quizMainView";
  static const quizResultView = "/quizResultView";
  static const settingViewScreen = "/SettingViewScreen";
  static const profileScreen = "/profileScreen";
  static const feedbackScreen = "/feedbackScreen";
  static const recommendedCourse = "/recommendedCourse";
  static const downloadListView = "/downloadListView";
  static const downloadDetailView = "/downloadDetailView";
  static const downloadCourseView = "/downloadCourseView";
  static const chatView = "/chatView";
  static const dashboardView = "/dashboardView";
  static const watchLaterView = "/watchLaterView";
  static const watchLaterSeeAllView = "/watchLaterSeeAllView";
  static const homeSeeAllView = "/homeSeeAllView";
  static const subscriptionView = "/subscriptionView2";
  static const subscriptionViewOld = "/subscriptionView";
  static const couponView = "/couponView";
  static const referAndEarn = "/referAndEarn";
  static const drawercourses = "/drawercourses";
  static const settingView = "/settingView";
  static const scalpScreen = '/scalps';

  //static const liveClassLaunch = "/liveClassLaunch";
}
