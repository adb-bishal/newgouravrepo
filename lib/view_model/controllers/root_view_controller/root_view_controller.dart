import 'dart:async';
import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'dart:math';
import 'package:audio_service/audio_service.dart';
// import 'package:chat360_flutter_sdk/chat360_flutter_sdk.dart';
// import 'package:chat360_flutter_sdk/chat360_flutter_sdk_method_channel.dart';
import 'package:confetti/confetti.dart';
import 'package:dio/dio.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:path/path.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockpathshala_beta/model/models/account_models/language_model.dart'
    as lang;
import 'package:stockpathshala_beta/model/models/popup_model/pop_up_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/auth_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/live_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/root_provider.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/home/home_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quiz_list.dart';
import 'package:stockpathshala_beta/view/widgets/trial_dialog_sheet.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/profile_controller/profile_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/quiz_controller/quiz_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/scalp_controller/scalp_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/video_course_detail_controller/video_course_detail_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/widget_controllers/ask_for_rating_controller.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:win32/winsock2.dart';
import '../../../enum/enum.dart';
import '../../../feedback/web_socket_service.dart';
import '../../../main.dart';
import '../../../mentroship/controller/mentorship_controller.dart';
import '../../../model/models/course_models/course_by_id_model.dart';
import '../../../model/models/drawer_model/drawer_item_model.dart';
import '../../../model/models/service_model/service_model.dart';
import '../../../model/models/update_version/update_version_model.dart';
import '../../../model/models/wishlist_data_model/wishlist_response_model.dart';
import '../../../model/network_calls/api_helper/network_info.dart';
import '../../../model/network_calls/api_helper/provider_helper/account_provider.dart';
import '../../../model/network_calls/api_helper/provider_helper/wishlist_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../model/services/auth_service.dart';
import '../../../model/services/notification_service.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/helper_util.dart';
import '../../../model/utils/style_resource.dart';
import '../../../service/page_manager.dart';
import '../../../view/screens/home/home_new_controller.dart';
import '../../../view/screens/root_view/cooming_soon/coming_soon_screen.dart';
import '../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../../view/screens/root_view/root_view.dart';
import '../../../view/screens/root_view/widget/add_ask_rating_widget.dart';
import '../../../view/widgets/alert_dialog_popup.dart';
import '../../../view/widgets/custom_dialog_box.dart';
import '../../../view/widgets/button_view/animated_box.dart';
import '../../../view/widgets/button_view/common_button.dart';
import '../../../view/widgets/log_print/log_print_condition.dart';
import '../../../view/widgets/popup_view/my_dialog.dart';
import '../../../view/widgets/text_field_view/common_textfield.dart';
import '../../../view/widgets/toast_view/showtoast.dart';
import '../../../view/widgets/view_helpers/permission_handler_helper.dart';
import '../../../view/widgets/view_helpers/progress_dialog.dart';
import '../../../enum/routing/routes/app_pages.dart';
import 'course_detail_controller/course_detail_controller.dart';
import 'package:in_app_review/in_app_review.dart';

import 'live_classes_controller/live_class_detail/live_class_detail_controller.dart';

class RootViewController extends GetxController {
  LiveProvider liveProvider = getIt();
  final GlobalKey<FormState> signInFormKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  final GlobalKey<FormState> openAccountFormKey = GlobalKey<FormState>();
  RxList<CourseWishlist> videoData = <CourseWishlist>[].obs;
  RxList<CourseWishlist> videoCourseData = <CourseWishlist>[].obs;
  RxList<CourseWishlist> audioData = <CourseWishlist>[].obs;
  RxList<CourseWishlist> audioCourseData = <CourseWishlist>[].obs;
  RxList<CourseWishlist> textCourseData = <CourseWishlist>[].obs;
  RxList<CourseWishlist> blogsData = <CourseWishlist>[].obs;
  final AskForRatingController askForRatingController =
      Get.put(AskForRatingController());
  final LiveClassDetailController liveClassDetailController =
      Get.put(LiveClassDetailController());
  RxBool hasShownRating = false.obs;

  WishListProvider wishListProvider = getIt();
  AccountProvider accountProvider = getIt();
  RootProvider rootProvider = getIt();
  RxList<DropDownData> languageData = <DropDownData>[].obs;
  RxBool isAskRatingShow = false.obs;

  RxInt selectedTab = RxInt(2);

  RxBool isShow = true.obs;
  RxBool isAvailable = false.obs;

  // Add popUpModel as an observable
  Rx<PopUpModel?> popUpModel = Rx<PopUpModel?>(null);

  // Define promptData as an observable
  static RxMap<String, String> promptData = <String, String>{}.obs;
  static RxMap<String, String> bgData = <String, String>{}.obs;

  RxInt classDuration = 0.obs;
  RxBool isShowPop = true.obs;

  RxString classStartTime = "".obs;
  RxString classImage = "".obs;
  RxString classTitle = "".obs;

  RxString vendorReferId = "".obs;
  RxDouble slider = 0.0.obs;
  RxBool isLoading = false.obs;
  RxBool isChatLoading = false.obs;
  RxBool isShowFloatingButton = false.obs;

  RxBool showAudioBanner = false.obs;
  RxBool isPermissionAllow = false.obs;
  RxBool isOpenLoading = false.obs;
  DateTime? currentBackPressTime;
  var emailError = "".obs;
  final GetStorage box = GetStorage();

  final InAppReview inAppReview = InAppReview.instance;
  RxBool isLangLoading = false.obs;
  Rx<TextEditingController> userNameController = TextEditingController().obs;
  Rx<TextEditingController> numberController = TextEditingController().obs;
  RxString nameError = "".obs;
  RxString numError = "".obs;
  TextEditingController emailController = TextEditingController();

// drawer list
  RxList<DrawerItemModel> drawerItems = <DrawerItemModel>[].obs;

  // Rx<PopUpModel?> popUpPrefsData = Rx<PopUpModel?>(null);

  RxBool isManualSlide = false.obs;
  RxBool isTrial = false.obs;
  RxInt days = 0.obs;
  TooltipController toolTipcontroller = TooltipController();
  @override
  void onReady() async {
    super.onReady();
    // await GetStorage.init();

    final categoryId = int.tryParse(
            box.read(CommonEnum.mentorScreen.name)?.toString() ?? '0') ??
        0;
    final categoryName = box.read('categoryName')?.toString() ?? '';
    final mentorShipDetailId = int.tryParse(
            box.read(CommonEnum.mentorshipDetailScreen.name)?.toString() ??
                '0') ??
        0;
    final liveClassDetailId = int.tryParse(
            box.read(CommonEnum.liveClassDetail.name)?.toString() ?? '0') ??
        0;
    final isSubscribed = box.read(CommonEnum.subscription.name) == true;
    final isGuestUser = Get.find<AuthService>().isGuestUser.value;

    print('categoryId: $categoryId');
    print('mentorShipDetailId: $mentorShipDetailId');
    print('liveClassDetailId: $liveClassDetailId');
    print('isSubscribed: $isSubscribed');
    print('isGuestUser: $isGuestUser');

    if (categoryId != 0) {
      box.remove(CommonEnum.mentorScreen.name);
    }
    if (mentorShipDetailId != 0) {
      box.remove(CommonEnum.mentorshipDetailScreen.name);
    }
    if (liveClassDetailId != 0) {
      box.remove(CommonEnum.liveClassDetail.name);
    }

    if (!isGuestUser && isSubscribed) {
      selectedTab.value = 2;

      Get.toNamed(Routes.subscriptionView);
      box.write(CommonEnum.subscription.name, false);
      return;
    }

    if (categoryId != 0 && !isGuestUser) {
      selectedTab.value = 0;
      Get.toNamed(
        Routes.mentorScreen,
        arguments: [
          categoryId,
          categoryName,
        ],
      );
      box.write(CommonEnum.mentorScreen.name, 0);
      return;
    }

    if (mentorShipDetailId != 0 && !isGuestUser) {
      selectedTab.value = 1;
      Get.toNamed(
        Routes.mentorshipDetail(id: mentorShipDetailId.toString()),
        arguments: {'id': mentorShipDetailId.toString()},
      );
      box.write(CommonEnum.mentorshipDetailScreen.name, 0);
      return;
    }

    selectedTab.value = 2;
  }

  @override
  Future<void> onInit() async {
    super.onInit();
    Get.put(HomeNewController());
    Get.put(MentorshipController());
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    try {
      if (!Get.find<AuthService>().isGuestUser.value) {
        var data = Get.find<AuthService>().user.toJson();
        if (kDebugMode) {
          print("socketServicedata $data");
        }
        Get.find<SocketService>().connect(
          userData: data,
        );
      } else {
        print("socketServicedata user not login");
      }
    } catch (e) {
      print('socket error $e');
    }
    checkTime();
    logPrint("hi ${Get.find<AuthService>().isPro.value}");
    if (Get.find<AuthService>().user.value.name == null &&
        Get.find<AuthService>().isPro.value) {
      emailController.text = "Your Name Please";
      getTrialData(isRoot: true);
    } else {
      getPopUpData6();
    }
    isAvailable.value = await inAppReview.isAvailable();
    // Get.find<ProfileController>().getLanguage(isRoot: true);
    // Get.find<ProfileController>().getTags(isRoot: true);
    // Get.find<ProfileController>().getLevel();
    // Get.find<ProfileController>().getCurrentUserData();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    // if (Platform.isAndroid) {
    //   bottomIcon.add(
    //     BottomIcon(
    //         icon: ImageResource.instance.proIcon,
    //         title: StringResource.batchSub),
    //   );
    // }
    // NetworkInfo.checkConnectivity(Get.context!);
    getUpdateVersionCode();

    if (!Get.find<AuthService>().isGuestUser.value) {
      // getLiveClassesData();
      await Get.find<RootViewController>().getProfile(true);

      postUserActivity();
      getServiceData();
    }

    try {
      FirebaseMessaging.instance.getInitialMessage().then((value) {
        if (value?.data.isNotEmpty ?? false) {
          Map<String, dynamic> payloadData = value?.data ?? {};
          onRedirection(payloadData);
        } else {}
      }, onError: (v) {});
    } catch (v) {
      logPrint("error $v");
    }
    initDynamicLinks();
    onDynamicLinkRedirect();
    getLanguage();
    fetchDrawerItems();
    getIt<PageManager>().init();
    pageManager.progressNotifier.listen((p1) {
      if (!isManualSlide.value) {
        progressAudioNotifier.value = p1;
      }
    });
    // showTooltipForPro();

    // final args = Get.arguments as Map<String, dynamic>?;
    // if (args != null && args['selectedTab'] != null) {
    //   // selectedTab.value = args['selectedTab'];
    // } else {
    //   // selectedTab.value = 2;
    // }
    // if (args?['resetHome'] == true && args?['selectedTab'] == 0) {
    //   // Initialize home controller after navigation
    //   Future.microtask(() {
    //     if (Get.isRegistered<HomeNewController>()) {
    //       Get.delete<HomeNewController>();
    //     }
    //     Get.put(HomeNewController());
    //
    //     final homeController = Get.find<HomeNewController>();
    //     homeController.expansion.value = 1.0;
    //     homeController.isTitleVisible.value = false;
    //   });
    // }
  }

  void addEventToBuffer(Map<String, dynamic> classData) {}

  List<Widget> widgetOptions = <Widget>[
    const ComingSoonScreen(),
    const ComingSoonScreen(),
  ];
  AuthProvider authProvider = getIt();

  List<BottomIcon> bottomIcon = [
    BottomIcon(
        icon: ImageResource.instance.homeIcon, title: StringResource.home),
    BottomIcon(
        icon: ImageResource.instance.mentorshipIcon,
        title: StringResource.mentorship),
    BottomIcon(
        icon: ImageResource.instance.liveIcon, title: StringResource.webinar),
    BottomIcon(
        icon: ImageResource.instance.liveIcon, title: StringResource.batches),
    BottomIcon(
        icon: ImageResource.instance.proIcon, title: StringResource.buyPro),
  ];
  void changeTab(int index) {
    if (selectedTab.value == index) return; // Don't do anything if same tab
    selectedTab.value = index;
    // Reset home controller state immediately when switching to home tab
    if (index == 0) {
      // Assuming 0 is home tab
      if (Get.isRegistered<HomeNewController>()) {
        final homeController = Get.find<HomeNewController>();
        homeController.resetScrollStateImmediate();
      }
    }
  }

  void onRedirectHome(int index) {
    if (index == 0) {
      Get.offAllNamed(Routes.rootView,
          arguments: {'selectedTab': 0, 'resetHome': true});
    }
  }

// In your bottom navigation widget
  void onTabTapped(int index) {
    // Reset home state immediately before changing tab
    if (index == 0 && Get.isRegistered<HomeNewController>()) {
      final homeController = Get.find<HomeNewController>();
      homeController.expansion.value = 1.0;
      homeController.isTitleVisible.value = false;
    }

    // Then change the tab
    Get.find<RootViewController>().changeTab(index);
  }

  RootViewController([int? i]) {
    if (RootViewController.promptData.isEmpty &&
        RootViewController.bgData.isEmpty) {
      _initializePromptData();
    }
  }

  Future<void> _initializePromptData() async {
    try {
      await rootProvider.getPopUpData(
        onError: (e, m) {
          logPrint("Error initializing promptData: $e, $m");
        },
        onSuccess: (message, json) async {
          PopUpModel popUpModel = PopUpModel.fromJson(json!);
          isTrial.value = popUpModel.isTrial == 0 ? false : true;
          RootViewController.promptData.value =
              popUpModel.trialPromptData; // Update static promptData
          RootViewController.bgData.value =
              popUpModel.backgroundData; // Update static promptData

          // Save PopUpModel to SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          String popUpModelString = jsonEncode(popUpModel.toJson());
          await prefs.setString('popUpModel', popUpModelString);

          logPrint(
              "promptData set: ${RootViewController.promptData.toString()}");
        },
      );
    } catch (error) {
      logPrint("Unexpected error in _initializePromptData: $error");
    }
  }

  // Future<void> initializePopUpPrefsData() async {
  //   popUpPrefsData.value = await getPopUpModelFromPrefs();
  //   logPrint("popUpPrefsData.value : ${popUpPrefsData.value.toString()}");
  // }

  // Future<PopUpModel?> getPopUpModelFromPrefs() async {
  //   SharedPreferences prefs = await SharedPreferences.getInstance();
  //   String? popUpModelString = prefs.getString('popUpModel');
  //   if (popUpModelString != null) {
  //     Map<String, dynamic> popUpPrefsData = jsonDecode(popUpModelString);
  //     logPrint("popUpModelString : ${popUpPrefsData.toString()}");
  //     return PopUpModel.fromJson(popUpPrefsData);
  //   }

  //   return null;
  // }

  void showTooltip() async {
    final toolTipList = await Get.find<AuthService>().getTrainingTooltips();
    logPrint('trainToolTipList $toolTipList');
    if (!toolTipList.contains('classRecordings')) {
      await Future.delayed(const Duration(seconds: 1));
      toolTipcontroller.start(2);
    }
  }

  void showTooltipForPro() async {
    final toolTipList = await Get.find<AuthService>().getTrainingTooltips();
    logPrint('trainToolTipList $toolTipList');
    if (!toolTipList.contains('buyNow')) {
      toolTipcontroller.start(1);
    }
  }

  String? getUserIcon() {
    var userRoleIcons = Get.find<AuthService>().user.value.userRoleIcons;

    if (Get.find<AuthService>().getUserToken().toString().isEmpty) {
      return 'https://internal.stockpathshala.in/icons/guest_user_icon.png'; // Fallback URL for guest users
    } else {
      if (userRoleIcons == null) {
        print('efverfve');
        Get.find<RootViewController>().getProfile();
      }
    }

    // Determine the icon URL based on the user's role
    if (Get.find<AuthService>().isPro.value) {
      return userRoleIcons?.proUserIconUrl;
    } else if (Get.find<AuthService>().isTrial.value) {
      return userRoleIcons?.trialUserIconUrl;
    } else if (Get.find<AuthService>().isTrialExpired.value) {
      return userRoleIcons?.trialExpiredUserIconUrl;
    } else if (Get.find<AuthService>().isProExpired.value) {
      return userRoleIcons?.proExpiredUserIconUrl;
    } else {
      print('ervervrvc');
      return userRoleIcons?.freshUserIconUrl;
    }
  }

  // RxList<DrawerData> drawerData = <DrawerData>[
  //   // DrawerData(
  //   //   title: "Dashboard",
  //   //   icon: ImageResource.instance.dashboardIcon,
  //   // ),
  //   DrawerData(
  //     title: "My Live Classes",
  //     icon: ImageResource.instance.liveClassIcon,
  //   ),
  //   // DrawerData(
  //   //   title: "Class Recordings",
  //   //   icon: ImageResource.instance.pastLiveIcon,
  //   // ),
  //   DrawerData(
  //     title: "Watch Later",
  //     icon: ImageResource.instance.watchLaterIcon,
  //   ),
  //   // DrawerData(
  //   //   title: "Courses",
  //   //   icon: ImageResource.instance.videoCourseIcon,
  //   // ),
  //   DrawerData(
  //     title: "Quizzes",
  //     icon: ImageResource.instance.quizzesIcon,
  //   ),
  //   DrawerData(
  //     title: "Downloads",
  //     icon: ImageResource.instance.downloadDIcon,
  //   ),
  //   // DrawerData(
  //   //   title: "Promocodes",
  //   //   icon: ImageResource.instance.promoCodeIcon,
  //   // ),
  //   DrawerData(
  //     title: "Arrange a Callback",
  //     icon: ImageResource.instance.phoneIcon,
  //   ),

  //   // DrawerData(
  //   //   title: "Buy Pro",
  //   //   icon: ImageResource.instance.promoCodeIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "Text Courses",GET trial_period_flow
  //   //   icon: ImageResource.instance.textCourseIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "Audio Courses",
  //   //   icon: ImageResource.instance.audioCourseIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "Video Courses",
  //   //   icon: ImageResource.instance.videoCourseIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "Blogs",
  //   //   icon: ImageResource.instance.watchLaterIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "Videos",
  //   //   icon: ImageResource.instance.videoCourseIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "Audios",
  //   //   icon: ImageResource.instance.audioCourseIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "FAQ's",
  //   //   icon: ImageResource.instance.faqIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "Refer & Earn",
  //   //   icon: ImageResource.instance.referNEarnIcon,
  //   // ),

  //   // DrawerData(
  //   //   title: "Share App",
  //   //   icon: ImageResource.instance.shareAppIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "Give Feedback",
  //   //   icon: ImageResource.instance.feedbackIcon,
  //   // ),
  //   // DrawerData(
  //   //   title: "Terms & Conditions",
  //   //   icon: ImageResource.instance.tncIcon,
  //   // ),
  // ].obs;

  VoidCallback get checkPermission => () async {
        PermissionStatus camaraPermissionStatus =
            await Permission.camera.status;
        if (camaraPermissionStatus.isGranted) {
          ImagePicker()
              .getImage(source: ImageSource.camera, imageQuality: 30)
              .then((PickedFile? pickedFile) async {})
              .catchError((e) {
            logPrint(e);
          });
        } else {
          PermissionHandlerHelper.permissionConfirmationDialog(
              context: Get.context!, onMethodCall: checkPermission);
        }
      };

  Future<void> fetchDrawerItems() async {
    try {
      final response = await Dio().get(
          'https://internal.stockpathshala.in/api/v1/mobile-menus'); // replace with your actual API
      if (response.statusCode == 200 && response.data['status'] == true) {
        print("drawer api hitted");
        var dataList = response.data['data'] as List;
        drawerItems.value =
            dataList.map((e) => DrawerItemModel.fromJson(e)).toList();
      } else {
        print("API returned error: ${response.data}");
      }
    } catch (e) {
      print("Error fetching drawer items: $e");
    }
  }

  // onItemTapped(int index) {
  //   selectedTab.value = index;
  //   logPrint(selectedTab.value);
  //   print("selectedTab: ${selectedTab.value}");
  // }

  Future<bool> onWillPop() async {
    myInAppReview();
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      toastShow(message: "Press again to exit", error: false);
      selectedTab.value = 0;
      return Future.value(false);
    } else {
      return Future.value(true);
    }
  }

  // myInAppReview() async {
  //   if (isAvailable.value ) {
  //     logPrint("i am pressed");
  //     await inAppReview.requestReview();
  //   }
  // }

  myInAppReview() async {
    // Check if in-app review is available before requesting
    isAvailable.value = true;

    if (isAvailable.value) {
      logPrint(
          "--------------In-app review is available, request initiated.------------");
      await inAppReview.requestReview();
    } else {
      logPrint(
          "------------In-app review is not available on this device.-------------");
    }
  }

  dialogBoxForTrial(popUpModel) async {
    print("DialogBox for trial ::");
    if (popUpModel != null) {
      // Show dialog using the retrieved PopUpModel data
      showActivateTrialBottomSheet(popUpModel);
    } else {
      print("No PopUpModel data found in SharedPreferences");
    }
    // showDialog(
    //     context: Get.context!,
    //     builder: (BuildContext context) {
    //       return CustomDialog(
    //         days: popUpModel.days,
    //         context: context,
    //         heading: popUpModel.heading,
    //         description: popUpModel.description,
    //         title1: popUpModel.title1,
    //         subTitle1: popUpModel.subTitle1,
    //         title2: popUpModel.title2,
    //         subTitle2: popUpModel.subTitle2,
    //         image2: popUpModel.image2,
    //         image1: popUpModel.image1,
    //         descriptionColor: popUpModel.descriptionColor,
    //         titleColorAll: popUpModel.titleColorAll,
    //         titleColorText: popUpModel.titleColorText,
    //         headingColor: popUpModel.headingColor,
    //         onClose: () {
    //           Get.back();
    //         },
    //         onContinue: () {},
    //       );
    //     },
    //     barrierDismissible: false);
  }

  showActivateTrialBottomSheet(popUpModel) {
    print("trail bottomsheet activated ");
    if (isShow.value) {
      // List<String> points = getPoints(popUpModel.title1
      //     // json["navigation_flow"]["${str}_msg"]
      //     ??
      //     "");

      int time = 0;
      // json["navigation_flow"]["${str}_time"];
      Timer(Duration(seconds: time), () {
        Get.bottomSheet(
          TrialDialogSheet(
            days: popUpModel.days,
            // context: context,
            heading: popUpModel.heading,
            description: popUpModel.description,
            title1: popUpModel.title1,
            subTitle1: popUpModel.subTitle1,
            title2: popUpModel.title2,
            subTitle2: popUpModel.subTitle2,
            image2: popUpModel.image2,
            image1: popUpModel.image1,
            title3: popUpModel.title3,
            subTitle3: popUpModel.subTitle3,
            image3: popUpModel.image3,
            title4: popUpModel.title4,
            subTitle4: popUpModel.subTitle4,
            image4: popUpModel.image4,
            descriptionColor: popUpModel.descriptionColor,
            titleColorAll: popUpModel.titleColorAll,
            titleColorText: popUpModel.titleColorText,
            headingColor: popUpModel.headingColor,
            bgType: popUpModel.backgroundData['bgType'] ?? 'color',
            bgColor: popUpModel.backgroundData['bgColor'] ?? "#ffffff",
            bgImage: popUpModel.backgroundData['bgImage'] ?? '',
            // emailController: emailController,
            onClose: () {
              if (Get.find<LoginController>().isLoading.value == false &&
                  isLoading.value == false) {
                Get.back();
              } else {}
            },
            onContinue: () {}, emailController: emailController,
          ),
          barrierColor: Colors.black.withOpacity(0.5), // Optional
          isDismissible: true,
          isScrollControlled: true, // Optional
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ), // Optional
          enableDrag: true, // Optional
        );
      });
    }
  }

  getTrialData({isRoot = false, showName = false}) async {
    logPrint("i am in root ::::");

    if (isRoot) {
      if (isTrial.value == 1 &&
          Get.find<AuthService>().user.value.name == null) {
        Future(() async => showSucessDialog(
            // days.value == 1
            //     ?
            promptData,

            // "Trial Activated for ${popUpModel.days} Day!"
            //     : "Trial Activated for amit2 Day!",
            // "Trial Activated for ${popUpModel.days} Days!",
            true,
            bgData));
      }
    }
    if (showName) {
      if (Get.find<AuthService>().user.value.name == null) {
        Future(() async => showSucessDialog(
            // days.value == 1
            //     ?
            promptData,

            // "Trial Activated for ${popUpModel.days} Day!"
            //     : "Trial Activated for amit2 Day!",
            // "Trial Activated for ${popUpModel.days} Days!",
            true,
            bgData));
      }
    }
  }

  showSucessDialog(
    Map<String, String> trialPromptData,
    hasName,
    Map<String, String> backgroundData,
  ) {
    // Retrieve each prompt field from the trialPromptData map
    final confettiController =
        ConfettiController(duration: const Duration(seconds: 5));
    // confettiController.play();

    logPrint("-------Confetti mytrialPromptData is : $trialPromptData");

    final promptTitle =
        (trialPromptData['title'] ?? '').replaceAll(r'\n', '\n');
    final promptTitleColor = trialPromptData['titleColor'] ?? '#000000';
    final promptDescription =
        (trialPromptData['description'] ?? '').replaceAll(r'\n', '\n');
    final promptDescriptionColor =
        trialPromptData['descriptionColor'] ?? '#000000';
    final confirmButtonText =
        trialPromptData['confirmButtonText'] ?? 'Start Learning';
    final confirmButtonColor =
        trialPromptData['confirmButtonColor'] ?? '#000000';
    final confirmButtonTextColor =
        trialPromptData['confirmButtonTextColor'] ?? '#ffffff';
    final promptNameInputPlaceholder =
        trialPromptData['userNameInputPlaceholder'] ?? 'Your Name please';
    final promptImage_url = trialPromptData['image_url'] ?? '';
    final bgType = backgroundData['bgType'] ?? '';
    final bgColor = backgroundData['bgColor'] ?? "#ffffff";
    final bgImage = backgroundData['bgImage'] ?? '';

    emailController.text = promptNameInputPlaceholder;

    // Set a timer to prevent closing the BottomSheet until the confetti animation completes
    bool animationCompleted = false;
    Timer(const Duration(seconds: 10), () {
      animationCompleted = true;
      // Dispose of the confetti controller when the animation completes
      confettiController.stop();
    });

    Timer(
      const Duration(seconds: 0),
      () {
        Get.bottomSheet(
          WillPopScope(
            onWillPop: () async => animationCompleted,
            child: Stack(
              children: [
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: bgType == 'color'
                        ? Color(int.parse(bgColor.replaceFirst('#', '0xff')))
                        : Colors.transparent,
                    image: bgType == 'image'
                        ? DecorationImage(
                            image: NetworkImage(bgImage),
                            fit: BoxFit.cover,
                          )
                        : null,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(25.0),
                      topRight: Radius.circular(25.0),
                    ),
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        const SizedBox(height: 16),
                        // Display the image from promptImage_url
                        promptImage_url.isNotEmpty
                            ? Image.network(
                                promptImage_url,
                                height: 100,
                                errorBuilder: (context, error, stackTrace) {
                                  return const Icon(Icons.image_not_supported,
                                      size: 100);
                                },
                              )
                            : Image.asset(
                                ImageResource.instance.successIcon,
                                height: 100,
                              ),
                        SizedBox(height: 15),
                        Text(
                          promptTitle,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                            color: Color(int.parse(
                                promptTitleColor.replaceAll('#', '0xff'))),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 2),
                          child: Text(
                            promptDescription,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Color(int.parse(promptDescriptionColor
                                  .replaceAll('#', '0xff'))),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        Get.find<AuthService>().user.value.name == null
                            ? Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 0),
                                child: Obx(
                                  () => Form(
                                    key: signInFormKey,
                                    child: SizedBox(
                                      width: Get.width * 0.8,
                                      child: CommonTextField(
                                        showEdit: false,
                                        isTrailPopUp: true,
                                        readOnly: isLoading.value,
                                        onTap: () {
                                          emailController.text = "";
                                        },
                                        isLogin: false,
                                        isLabel: true,
                                        isHint: true,
                                        controller: emailController,
                                        keyboardType: TextInputType.text,
                                        validator: (value) {
                                          if (value ==
                                              promptNameInputPlaceholder) {
                                            emailError.value =
                                                StringResource.nameInvalidError;
                                            return "";
                                          } else if (value!.length <= 3) {
                                            emailError.value =
                                                StringResource.nameInvalidError;
                                            return "";
                                          } else {
                                            emailError.value = "";
                                            return null;
                                          }
                                        },
                                        errorText: emailError.value,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : Container(),
                        SizedBox(
                          width: Get.width * 0.8,
                          height: Get.height * 0.05,
                          child: CommonButton(
                            color: Color(int.parse(
                                confirmButtonColor.replaceAll('#', '0xff'))),
                            text: confirmButtonText,
                            textColor: Color(int.parse(confirmButtonTextColor
                                .replaceAll('#', '0xff'))),
                            loading: false,
                            onPressed: () {
                              if (hasName) {
                                if (signInFormKey.currentState!.validate() &&
                                    !isLoading.value) {
                                  confettiController.play();
                                  joinOnTap(emailController.text);
                                  // trailOnTap(true, false);
                                  emailController.text = "";
                                  Get.find<AuthService>().isPro.value = true;
                                  Get.find<ProfileController>()
                                      .getCurrentUserData();
                                  // Close the BottomSheet only after confetti animation completes
                                  confettiController.addListener(() {
                                    if (animationCompleted) {
                                      Get.back();
                                    }
                                  });
                                }
                              } else {
                                // Close the BottomSheet only after confetti animation completes

                                Get.back();
                              }
                            },
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ),
                // Positioned confetti widget inside the Stack
                Positioned.fill(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: ConfettiWidget(
                      confettiController: confettiController,
                      blastDirectionality: BlastDirectionality.explosive,
                      numberOfParticles: 50,
                      shouldLoop: false,
                      colors: [
                        Colors.blue,
                        Colors.red,
                        Colors.green,
                        Colors.yellow
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          barrierColor: Colors.black.withOpacity(0.5),
          isDismissible: true,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ),
          enableDrag: true,
        ).whenComplete(() => confettiController.dispose());
      },
    );
  }

  expireTrialPlanPopUp() {
    emailController.text = "Enter your name";
    bool isName = Get.find<AuthService>().user.value.name == null;

    Get.bottomSheet(
      // context: Get.context!,
      // builder: (BuildContext context) {
      //   return WillPopScope(
      //     onWillPop: (() async => true),
      //     child: Dialog(
      //         shape: RoundedRectangleBorder(
      //           borderRadius: BorderRadius.circular(16.0),
      //         ),
      //         child: SizedBox(
      //           height:
      //               isName ? (Get.height / 2.5) + 16 : (Get.height / 2.75),
      //           child:
      Container(
        width: double.infinity, // Make the BottomSheet take the full width
        decoration: const BoxDecoration(
          color: Colors.white, // Set the background color to white
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0), // Curved upper-left corner
            topRight: Radius.circular(25.0), // Curved upper-right corner
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(),
                  IconButton(
                      onPressed: () {
                        Get.back();
                      },
                      icon: const Icon(Icons.close))
                ],
              ),
              Image.asset(
                ImageResource.instance.expiredIcon,
                height: 100,
              ),
              SizedBox(
                height: 15,
              ),
              const Text(
                "Oh! Your Plan has Expired",
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: 8.0,
                  vertical: 2,
                ),
                child: Text(
                  "Buy Pro to Continue Learning.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                  ),
                ),
              ),
              isName
                  ? const SizedBox(
                      height: 14,
                    )
                  : const SizedBox(),
              isName
                  ? Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 0),
                      child: Obx(
                        () => Form(
                          key: signInFormKey,
                          child: CommonTextField(
                            showEdit: false,
                            isSpace: true,
                            isTrailPopUp: true,
                            readOnly: isLoading.value,
                            onTap: () {
                              emailController.text = "";
                            },
                            isLogin: false,
                            isHint: false,
                            controller: emailController,
                            keyboardType: TextInputType.text,
                            validator: (value) {
                              if (value == "Enter your name") {
                                emailError.value =
                                    StringResource.nameInvalidError;
                                return "";
                              } else if (value!.length <= 3) {
                                emailError.value =
                                    StringResource.nameInvalidError;
                                return "";
                              } else {
                                emailError.value = "";
                                return null;
                              }
                            },
                            errorText: emailError.value,
                          ),
                        ),
                      ),
                    )
                  : Container(),
              const SizedBox(
                height: 12,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 20.0),
                child: SizedBox(
                  width: 120,
                  height: 35,
                  child: CommonButton(
                      color: ColorResource.primaryColor,
                      text: isName ? 'Explore'.capitalize ?? "" : "Buy Pro",
                      loading: false,
                      onPressed: () {
                        if (isName) {
                          if (signInFormKey.currentState!.validate() &&
                              isLoading.value == false) {
                            Get.find<AuthService>().user.value.name =
                                emailController.text;

                            trailOnTap(true, false);
                            emailController.text = "";

                            Get.back();
                          } else {}
                        } else {
                          Get.back();
                          Get.toNamed(Routes.subscriptionView);
                        }
                      }),
                ),
              ),
            ],
          ),
        ),
      ),
      //       )
      //       ),
      // );
      // },
      barrierColor: Colors.black.withOpacity(0.5), // Optional
      isDismissible: true, // Optional
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ), // Optional
      enableDrag: true, // Optional
      // barrierDismissible: false
    );
  }

  Future<void> getPopUpData(data, int index) async {
    logPrint("Fetching popup data...");

    await rootProvider.getPopUpData(
      onError: (e, m) {
        logPrint(" Failed to fetch popup data: $e");
      },
      onSuccess: (message, json) async {
        final PopUpModel popUpModel = PopUpModel.fromJson(json!);
        logPrint(" Days: ${popUpModel.days}");

        final isTrial = popUpModel.isTrial == 1;
        final isPro = popUpModel.isPro == 1;
        final userName = Get.find<AuthService>().user.value.name;
        final hasName = userName != null && userName != 'null';

        final liveController = Get.find<LiveClassesController>();

        /// 🔹 Case 1: No trial or pro — show trial dialog
        if (!isTrial && !isPro) {
          dialogBoxForTrial(popUpModel);
        }

        /// 🔹 Case 2: Trial only — show expired dialog
        else if (isTrial && !isPro) {
          expireTrialPlanPopUp();
        }

        /// 🔹 Case 3: Trial or Pro is active
        else if (isPro || isTrial) {
          if (hasName) {
            liveController.isDataLoading.value = true;
            liveController.dataPagingController.value.list[index].isLoading =
                true;
            liveController.isOnTapAllowd.value = false;

            await liveController.onRegister(
              '${data.id ?? 0}',
              index,
              isUpdateScreen: false,
            );

            // liveController.isDataLoading.value = false;
          } else {
            showSucessDialog(
              popUpModel.trialPromptData,
              true,
              popUpModel.backgroundData,
            );
          }
        }
      },
    );
  }

  getPopUpData3() async {
    await rootProvider.getPopUpData(
        onError: (e, m) {},
        onSuccess: ((message, json) {
          PopUpModel popUpModel = PopUpModel.fromJson(json!);
          logPrint("days 3:${popUpModel.days}");

          if (popUpModel.isTrial == 0 && popUpModel.isPro == 0) {
            dialogBoxForTrial(popUpModel);
          } else if ((json['data'][0]['user']['is_pro'] == 0 &&
              popUpModel.isTrial == 1)) {
            // Get.toNamed(Routes.subscriptionView);
            // emailController.text = "Enter your name";
            expireTrialPlanPopUp();

            // if (Get.find<AuthService>().user.value.name == null &&
            //     popUpModel.isPro == 0) {
            //   expireTrialPlanPopUp();
            // } else {
            //   getProfile(true, true);
            // }
          } else if ((popUpModel.isPro == 1 && popUpModel.isTrial == 1) ||
              (popUpModel.isPro == 1 && popUpModel.isTrial == 0)) {
            // getProfile(true);
          }
        }));
  }

  getPopUpData4(data) async {
    await rootProvider.getPopUpData(
        onError: (e, m) {},
        onSuccess: ((message, json) {
          PopUpModel popUpModel = PopUpModel.fromJson(json!);
          logPrint("days 4:${popUpModel.days}");

          if (popUpModel.isTrial == 0 && popUpModel.isPro == 0) {
            dialogBoxForTrial(popUpModel);
          } else if ((popUpModel.isPro == 0 && popUpModel.isTrial == 1)) {
            // Get.toNamed(Routes.subscriptionView);
            // emailController.text = "Enter your name";
            expireTrialPlanPopUp();

            // if (Get.find<AuthService>().user.value.name == null &&
            //     popUpModel.isPro == 0) {
            //   expireTrialPlanPopUp();
            // } else {
            //   getProfile(true, true);
            // }
          } else if ((popUpModel.isPro == 1 && popUpModel.isTrial == 1) ||
              (popUpModel.isPro == 1 && popUpModel.isTrial == 0)) {
            if (data.isAttempted == null || data.isAttempted == 0) {
              Get.toNamed(Routes.quizMainView, arguments: {
                "id": data.id.toString(),
                "??": "",
                "quiz_type": data.isScholarship == 1
                    ? QuizType.scholarship
                    : QuizType.free,
                "is_timeup": false,
                "is_fromHome": true
              });
            } else {
              toastShow(message: StringResource.quizAttempted);
            }
            // getProfile(true);
          }
        }));
  }

  getPopUpData5(data, quizController) async {
    await rootProvider.getPopUpData(
        onError: (e, m) {},
        onSuccess: ((message, json) {
          PopUpModel popUpModel = PopUpModel.fromJson(json!);
          logPrint("days 5:${popUpModel.days}");

          if (popUpModel.isTrial == 0 && popUpModel.isPro == 0) {
            dialogBoxForTrial(popUpModel);
          } else if ((popUpModel.isPro == 0 && popUpModel.isTrial == 1)) {
            // Get.toNamed(Routes.subscriptionView);
            // emailController.text = "Enter your name";
            expireTrialPlanPopUp();

            // if (Get.find<AuthService>().user.value.name == null &&
            //     popUpModel.isPro == 0) {
            //   expireTrialPlanPopUp();
            // } else {
            //   getProfile(true, true);
            // }
          } else if ((popUpModel.isPro == 1 && popUpModel.isTrial == 1) ||
              (popUpModel.isPro == 1 && popUpModel.isTrial == 0)) {
            if (!Get.find<AuthService>().isGuestUser.value) {
              if (data.isAttempted == null || data.isAttempted == 0) {
                Get.toNamed(Routes.quizMainView, arguments: {
                  "id": data.id.toString(),
                })!
                    .then((value) {
                  quizController.getQuiz(
                    1,
                  );
                });
                Get.find<QuizController>().getQuizById(data.id.toString());
                Get.find<QuizController>().quizType.value =
                    data.isScholarship == 1
                        ? QuizType.scholarship
                        : QuizType.free;
                Get.find<QuizController>().isTimeUp.value = false;
              } else {
                toastShow(message: StringResource.quizAttempted);
              }
            } else {
              ProgressDialog().showFlipDialog(isForPro: false);
            }
            // getProfile(true);
          }
        }));
  }

  Future<void> getPopUpDataNew({
    String? title,
    String? subtitle,
    String? buttonTitle,
    String? imageUrl,
  }) async {
    final authService = Get.find<AuthService>();
    final profileController = Get.find<ProfileController>();
    final userRole = authService.userRole.value;
    final userName = authService.user.value.name;
    final isGuest = authService.isGuestUser.value;
    final isPro = authService.isPro.value;

    logPrint("Entering getPopUpData2");

    await rootProvider.getPopUpData(
      onError: (e, m) {
        logPrint("Failed to fetch popup data: $e");
      },
      onSuccess: (message, json) {
        final popUpModel = PopUpModel.fromJson(json!);
        isTrial.value = popUpModel.isTrial != 0;
        logPrint("Days 2: ${popUpModel.days}");

        if (isGuest) {
          ProgressDialog().showFlipDialog(isForPro: false);
          return;
        }

        if (isPro) {
          getProfile();
          profileController.getCurrentUserData();

          if (userName == null || userName == 'null') {
            logPrint("----Prompting Trial Activation---------");
            showSucessDialog(
              popUpModel.trialPromptData,
              true,
              popUpModel.backgroundData,
            );
          }
          return;
        }

        switch (userRole) {
          case "fresh_user":
            dialogBoxForTrial(popUpModel); // Popup with name
            break;

          case "pro_expired_user":
          case "trial_expired_user":
            logPrint("Showing expired trial popup");
            liveClassDetailController.expireTrialPlanPopUp(
                imageUrl, title, subtitle, buttonTitle);
            break;

          case "trial_user":
            if (popUpModel.isTrial == 1) {
              Get.toNamed(Routes.subscriptionView);
            }
            break;

          default:
            if ((popUpModel.isPro == 1 &&
                    (popUpModel.isTrial == 1 || popUpModel.isTrial == 0)) &&
                (userName == null || userName == 'null')) {
              getProfile();
              profileController.getCurrentUserData();
              logPrint("----Prompting Trial Activation---------");
              showSucessDialog(
                popUpModel.trialPromptData,
                true,
                popUpModel.backgroundData,
              );
            }
        }
      },
    );
  }

  Future<void> getPopUpData2({
    String? title,
    String? subtitle,
    String? buttonTitle,
    String? imageUrl,
  }) async {
    final authService = Get.find<AuthService>();
    final profileController = Get.find<ProfileController>();
    final userRole = authService.userRole.value;
    final userName = authService.user.value.name;
    final isGuest = authService.isGuestUser.value;
    final isPro = authService.isPro.value;

    logPrint("Entering getPopUpData2");

    await rootProvider.getPopUpData(
      onError: (e, m) {
        logPrint("Failed to fetch popup data: $e");
      },
      onSuccess: (message, json) {
        final popUpModel = PopUpModel.fromJson(json!);
        isTrial.value = popUpModel.isTrial != 0;
        logPrint("Days 2: ${popUpModel.days}");

        if (isGuest) {
          ProgressDialog().showFlipDialog(isForPro: false);
          return;
        }

        if (isPro) {
          getProfile();
          profileController.getCurrentUserData();

          if (userName == null || userName == 'null') {
            logPrint("----Prompting Trial Activation---------");
            showSucessDialog(
              popUpModel.trialPromptData,
              true,
              popUpModel.backgroundData,
            );
          }
          return;
        }

        switch (userRole) {
          case "fresh_user":
            dialogBoxForTrial(popUpModel); // Popup with name
            break;

          case "pro_expired_user":
          case "trial_expired_user":
            logPrint("Showing expired trial popup");
            liveClassDetailController.expireTrialPlanPopUp(
                imageUrl, title, subtitle, buttonTitle);
            break;

          case "trial_user":
            if (popUpModel.isTrial == 1) {
              Get.toNamed(Routes.subscriptionView);
            }
            break;

          default:
            if ((popUpModel.isPro == 1 &&
                    (popUpModel.isTrial == 1 || popUpModel.isTrial == 0)) &&
                (userName == null || userName == 'null')) {
              getProfile();
              profileController.getCurrentUserData();
              logPrint("----Prompting Trial Activation---------");
              showSucessDialog(
                popUpModel.trialPromptData,
                true,
                popUpModel.backgroundData,
              );
            }
        }
      },
    );
  }

  getPopUpData6([bool isBatch = false]) async {
    final authService = Get.find<AuthService>();
    final userRole = authService.userRole.value;

    logPrint("i am in pop 2 lkkd");
    print('sdcsdc ${authService.isGuestUser}');
    print('sdcsdc ${authService.userRole}');
    await rootProvider.getPopUpData(
        onError: (e, m) {},
        onSuccess: ((message, json) {
          PopUpModel popUpModel = PopUpModel.fromJson(json!);
          isTrial.value = popUpModel.isTrial == 0 ? false : true;
          logPrint("days 2:${popUpModel.days}");

          if (userRole == "fresh_user" ||
              Get.find<AuthService>().isGuestUser.value) {
            dialogBoxForTrial(popUpModel);
          }
        }));
  }

  onOpenTradingAccount(BuildContext context) async {
    isOpenLoading(true);
    await rootProvider.openTradingAccount(
        data: {
          "name": userNameController.value.text,
          "mobile_no": numberController.value.text
        },
        onError: (message, errorMap) {
          toastShow(message: message, error: true);
          isOpenLoading(false);
        },
        onSuccess: (message, json) {
          ShowToastFlash(
                  title: StringResource.callBackArrange,
                  message: "",
                  positiveButton: "",
                  negativeButton: "")
              .present(context, onPositiveAction: () {});
          isOpenLoading(false);
          userNameController.value.clear();
          numberController.value.clear();
        });
  }

  void onDrawerListTile(String linkType, BuildContext context) async {
    switch (linkType) {
      case 'dashboard':
        if (!Get.find<AuthService>().isGuestUser.value) {
          Get.toNamed(Routes.dashboardView);
        } else {
          ProgressDialog().showFlipDialog(isForPro: false);
        }
        break;
      case 'watch_later':
        if (!Get.find<AuthService>().isGuestUser.value) {
          Get.toNamed(Routes.watchLaterView);
        } else {
          ProgressDialog().showFlipDialog(isForPro: false);
        }
        break;
      case StringResource.arrangeCallback:
        if (Get.find<AuthService>().isGuestUser.value) {
          showOpenAccountDialog();
        } else {
          PermissionAlertDialog(
                  title: null,
                  message: null,
                  positiveButton: "Yes",
                  negativeButton: "no")
              .present(context, onPositiveAction: () {
            userNameController.value.text =
                Get.find<AuthService>().user.value.name ?? "";
            numberController.value.text =
                Get.find<AuthService>().user.value.mobileNo ?? "";
            onOpenTradingAccount(context);
            Get.back();
          });
        }
        break;
      case 'downloads':
        if ((!Get.find<AuthService>().isGuestUser.value) &&
                (Get.find<AuthService>().isPro.value) ||
            (Get.find<AuthService>().isTrial.value)) {
          Get.toNamed(Routes.downloadListView);
        } else {
          ProgressDialog().showFlipDialog(
              isForPro: !Get.find<AuthService>().isGuestUser.value);
        }
        break;
      case 'live_class_page':
        if (!Get.find<AuthService>().isGuestUser.value) {
          Get.toNamed(Routes.liveWebinar);
        } else {
          ProgressDialog().showFlipDialog(isForPro: false);
        }

        break;
      case 'past_live_classes_page':
        if (!Get.find<AuthService>().isGuestUser.value) {
          Get.toNamed(Routes.pastLiveClass);
        } else {
          ProgressDialog().showFlipDialog(isForPro: true);
        }

        break;
      case 'quiz_page':
        Get.toNamed(Routes.quizzesView);
        break;
      case StringResource.promoCodes:
        if (!Get.find<AuthService>().isGuestUser.value) {
          Get.toNamed(Routes.promoCode);
        } else {
          ProgressDialog().showFlipDialog(isForPro: false);
        }
        break;
      case StringResource.shareApp:
        await HelperUtil.instance.buildInviteLink().then((value) async {
          await HelperUtil.share(
              referCode: Get.find<AuthService>().user.value.referralCode ?? "",
              url: value.shortUrl.toString());
        });
        break;
      case StringResource.feedback:
        if (!Get.find<AuthService>().isGuestUser.value) {
          Get.toNamed(Routes.feedbackScreen);
        } else {
          ProgressDialog().showFlipDialog(isForPro: false);
        }
        // Get.toNamed(Routes.feedbackScreen);
        break;
      case StringResource.faq:
        Get.toNamed(Routes.faqScreen);
        break;
      case StringResource.tnc:
        Get.toNamed(Routes.tncScreen);
        break;
      case 'pro_page':
        Get.toNamed(Routes.subscriptionView);
        break;
      case 'home_page':
        Get.toNamed(Routes.homeScreen);
        break;

      case StringResource.textCourses:
        Get.toNamed(Routes.homeSeeAllView, arguments: [
          StringResource.textCourses,
          CourseDetailViewType.textCourse
        ]);
        break;
      case StringResource.drawerCourses:
        Get.toNamed(Routes.drawercourses);
        break;

      case StringResource.audioCourses:
        Get.toNamed(Routes.homeSeeAllView, arguments: [
          StringResource.audioCourses,
          CourseDetailViewType.audioCourse
        ]);
        break;
      case 'course_page':
        Get.toNamed(Routes.homeSeeAllView, arguments: [
          StringResource.videoCourses,
          CourseDetailViewType.videoCourse
        ]);
        break;
      case StringResource.blogsL:
        Get.toNamed(Routes.homeSeeAllView,
            arguments: [StringResource.blogs, CourseDetailViewType.blogs]);
        break;
      case StringResource.videoss:
        Get.toNamed(Routes.homeSeeAllView, arguments: [
          StringResource.singleVideo,
          CourseDetailViewType.video
        ]);
        break;
      case StringResource.audios:
        Get.toNamed(Routes.homeSeeAllView, arguments: [
          StringResource.singleAudio,
          CourseDetailViewType.audio
        ]);
        break;
      case 'mentorship_page':
        Get.toNamed(Routes.mentorship);
        break;
      case 'batch_page':
        Get.toNamed(Routes.liveBatches);
        break;

      default:
        //refer and earn
        if (!Get.find<AuthService>().isGuestUser.value) {
          Get.toNamed(Routes.referAndEarn);
        } else {
          ProgressDialog().showFlipDialog(isForPro: false);
        }

        break;
    }
  }

  showOpenAccountDialog() {
    return showAnimatedDialog(
        Get.context!,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          description:
              "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary.",
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {},
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  StringResource.openAccountText,
                  style: StyleResource.instance.styleSemiBold(),
                ),
                Image.asset(
                  ImageResource.instance.referNEarnPOPBG,
                  height: 180,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      top: DimensionResource.marginSizeDefault),
                  child: Form(
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    key: openAccountFormKey,
                    child: Obx(
                      () => Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          CommonTextField(
                            showEdit: false,
                            label: "",
                            controller: userNameController.value,
                            hintText: StringResource.enterName,
                            keyboardType: TextInputType.text,
                            maxLength: 24,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[A-Za-z ]"))
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                nameError.value = StringResource.emptyNameError;
                                return "";
                              } else {
                                nameError.value = "";
                                return null;
                              }
                            },
                            errorText: nameError.value,
                          ),
                          CommonTextField(
                            showEdit: false,
                            label: "",
                            maxLength: 10,
                            controller: numberController.value,
                            hintText: StringResource.enterMobile,
                            keyboardType: TextInputType.phone,
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                  RegExp("[0-9]")),
                            ],
                            validator: (value) {
                              if (value!.isEmpty) {
                                numError.value = StringResource.emptyPhoneError;
                                return "";
                              } else {
                                numError.value = "";
                                return null;
                              }
                            },
                            errorText: numError.value,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  return CommonButton(
                    text: StringResource.submit,
                    onPressed: () {
                      if (openAccountFormKey.currentState?.validate() ??
                          false) {
                        nameError.value = "";
                        numError.value = "";
                        onOpenTradingAccount(Get.context!);
                        Get.back();
                      }
                    },
                    loading: isOpenLoading.value,
                  );
                }),
                TextButton(
                    onPressed: () {
                      Get.back();
                      nameError.value = "";
                      numError.value = "";
                      userNameController.value.clear();
                      numberController.value.clear();
                    },
                    child: Text(
                      StringResource.cancel,
                      style: StyleResource.instance
                          .styleSemiBold(color: ColorResource.primaryColor),
                    ))
              ],
            ),
          ),
        ),
        dismissible: false,
        isFlip: true);
  }
  // void trailOnTap1(hasName, isFirst, [bool? isTrialSheet]) async {
  //   isLoading.value = true;
  //   try {
  //     await authProvider.updateUserDataForAppTap(
  //         signInBody: hasName ? {"name": emailController.text} : null,
  //         onError: (message, errorMap) {
  //           logPrint("error");
  //           if (errorMap?.isEmpty ?? false) {
  //             emailError.value = message ?? "";
  //           }
  //           if (errorMap?.isNotEmpty ?? false) {
  //             errorMap?.forEach((key, value) {
  //               if (key == "otp") {
  //                 if (value.isNotEmpty) {
  //                   emailError.value = value.first;
  //                 }
  //               }
  //             });
  //           }
  //           isLoading.value = false;
  //         },
  //         onSuccess: (message, data) async {
  //           if (data != null) {
  //             isLoading.value = true;
  //             // Get.toNamed(Routes.otpScreen, arguments: emailController.text);
  //             // Get.find<AuthService>().isPro.value = true;
  //             // Get.find<AuthService>().user.value.name = emailController.text;
  //
  //             Get.find<AuthService>().getCurrentUserData();
  //             Get.find<ProfileController>().getCurrentUserData();
  //
  //             // Get.find<RootViewController>().getProfile();
  //
  //             if (isTrialSheet == true) {
  //               Get.find<RootViewController>().joinOnTap(
  //                   Get.find<RootViewController>().emailController.text);
  //             }
  //
  //            getProfile();
  //
  //             // Get.back();
  //
  //             // if (isFirst) {
  //             //   logPrint("clicked123");
  //
  //             //   // Access promptData from RootViewController
  //             //   // var trialPromptData = promptData;
  //             //   // logPrint("Trial Prompt Data in LoginController: $trialPromptData");
  //             //   print("lkjfsdkjkljkljlkj ${LoginController.promptData}");
  //
  //             //   if (LoginController.promptData != null) {
  //             //     await showSucessDialog(
  //             //       // Get.find<RootViewController>().popUpModel.value?.trialPromptData ?? {},
  //             //       LoginController.promptData,
  //
  //             //       // days,
  //             //       // days == 1
  //             //       //     ? "Trial Activated for $days Day!"
  //             //       //     : "Trial Activated for $days Days!",
  //             //       Get.find<AuthService>().user.value.name == null,
  //             //       LoginController.bgData,
  //             //     );
  //             //   }
  //             // } else {
  //             //   emailController.text = "Enter your name";
  //             //   Get.back();
  //             // }
  //           }
  //           // isLoading.value = false;
  //         });
  //   } catch (e) {
  //     logPrint("Login error: $e");
  //     isLoading.value = false;
  //   }
  // }

  void trailOnTap(bool hasName, [bool showDialog = true]) async {
    isLoading.value = true;

    try {
      await authProvider.updateUserDataForAppTap(
        signInBody: hasName ? {"name": emailController.text.trim()} : null,
        onError: (message, errorMap) {
          if (errorMap?.isEmpty ?? false) {
            emailError.value = message ?? "";
          }
          if (errorMap?.isNotEmpty ?? false) {
            errorMap?.forEach((key, value) {
              if (key == "otp" && value.isNotEmpty) {
                emailError.value = value.first;
              }
            });
          }
          isLoading.value = false;
        },
        onSuccess: (message, data) async {
          isLoading.value = false;

          Get.back();

          await Get.find<RootViewController>().getProfile();

          if (showDialog) {
            showSucessDialog(
              promptData.value,
              hasName,
              bgData,
            );
          }
        },
      );
    } catch (e) {
      logPrint("Login error: $e");
      isLoading.value = false;
    }
  }

  void joinOnTap(String name) async {
    isLoading.value = true;
    try {
      await authProvider.updateUserDataForAppTap(
          signInBody: {"name": name},
          onError: (message, errorMap) {
            if (errorMap?.isEmpty ?? false) {
              emailError.value = message ?? "";
            }
            if (errorMap?.isNotEmpty ?? false) {
              errorMap?.forEach((key, value) {
                if (key == "otp") {
                  if (value.isNotEmpty) {
                    emailError.value = value.first;
                  }
                }
              });
            }
            isLoading.value = false;
          },
          onSuccess: (message, data) async {
            if (data != null) {
              isLoading.value = false;
              // Get.toNamed(Routes.otpScreen, arguments: emailController.text);
              Get.back();
            }
          });
    } catch (e) {
      logPrint("Login error: $e");
      isLoading.value = false;
    }
  }

  onDynamicLinkRedirect() {
    try {
      if (Get.find<AuthService>().courseType.value != "") {
        switch (Get.find<AuthService>().courseType.value) {
          case AppConstants.shareScalp:
            selectedTab.value = 3;
            Get.find<ScalpController>()
                .onSingleRedirectByID(Get.find<AuthService>().courseId.value);
            break;
          case AppConstants.shareDownload:
            Get.toNamed(Routes.downloadListView);
            break;
          case AppConstants.shareBlog:
            AppConstants.instance.blogId.value =
                Get.find<AuthService>().courseId.value;

            Get.toNamed(
                Routes.blogsView(id: Get.find<AuthService>().courseId.value),
                arguments: [
                  Get.find<AuthService>().courseId.value,
                  Get.find<AuthService>().categoryId.value
                ]);
            break;
          case AppConstants.shareAudio:
            Get.toNamed(
                Routes.audioCourseDetail(
                    id: Get.find<AuthService>().courseId.value),
                arguments: [
                  CourseDetailViewType.audio,
                  Get.find<AuthService>().courseId.value,
                  Get.find<AuthService>().categoryId.value,
                  ""
                ]);
            break;
          case AppConstants.shareVideo:
            AppConstants.instance.singleCourseId.value =
                Get.find<AuthService>().courseId.value;
            Get.toNamed(
                Routes.continueWatchScreen(
                    id: Get.find<AuthService>().courseId.value),
                arguments: [
                  Get.find<AuthService>().courseId.value,
                  Get.find<AuthService>().categoryId.value
                ]);
            break;
          case AppConstants.shareLiveClass:
            AppConstants.instance.liveId.value =
                Get.find<AuthService>().courseId.value;

            Get.toNamed(
                Routes.liveClassDetail(
                    id: Get.find<AuthService>().courseId.value),
                arguments: [false, Get.find<AuthService>().courseId.value]);
            break;
          case AppConstants.sharePastLiveClass:
            AppConstants.instance.liveId.value =
                Get.find<AuthService>().courseId.value;
            Get.toNamed(
                Routes.liveClassDetail(
                    id: Get.find<AuthService>().courseId.value),
                arguments: [true, Get.find<AuthService>().courseId.value]);
            break;
          case AppConstants.shareVideoCourse:
            AppConstants.instance.videoCourseId.value =
                Get.find<AuthService>().courseId.value;
            Get.toNamed(
                Routes.videoCourseDetail(
                    id: Get.find<AuthService>().courseId.value),
                arguments: ["", Get.find<AuthService>().courseId.value]);
            break;
          case AppConstants.shareAudioCourse:
            Get.toNamed(
                Routes.audioCourseDetail(
                    id: Get.find<AuthService>().courseId.value),
                arguments: [
                  CourseDetailViewType.audioCourse,
                  Get.find<AuthService>().courseId.value,
                  Get.find<AuthService>().categoryId.value,
                  ""
                ]);
            break;
          case AppConstants.promocodeShare:
            if (Platform.isAndroid) {
              Get.offNamed(Routes.subscriptionView,
                  arguments: {"code": Get.find<AuthService>().courseId.value});
            }
            break;
          default:

            ///share text course
            Get.toNamed(
                Routes.textCourseDetail(
                    id: Get.find<AuthService>().courseId.value),
                arguments: [
                  Get.find<AuthService>().categoryId.value,
                  Get.find<AuthService>().courseId.value
                ]);
            break;
        }
      }
    } catch (e) {
      throw Exception(e);
    }
  }

  void initDynamicLinks() async {
    try {
      FirebaseDynamicLinks.instance.onLink.listen(
          (PendingDynamicLinkData dynamicLink) async {
        final PendingDynamicLinkData? initialLink = await FirebaseDynamicLinks
            .instance
            .getDynamicLink(dynamicLink.link);
        if (initialLink != null) {
          Get.find<AuthService>().trimShortUrl(initialLink.link.path);
        } else {
          Get.find<AuthService>().trimShortUrl(dynamicLink.link.path);
        }
        onDynamicLinkRedirect();
      }, onError: (e) async {
        throw Exception(e);
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  saveToWatchLater(
      {required int id,
      required String type,
      required Function(WishListSaveModel data) response}) async {
    if (!Get.find<AuthService>().isGuestUser.value) {
      CourseWishlist courseWishlist = CourseWishlist();
      switch (type) {
        case "video":
          courseWishlist = Get.find<RootViewController>().videoData.firstWhere(
              (p0) => p0.id?.value == id,
              orElse: () => CourseWishlist());
          break;
        case "audio":
          courseWishlist = Get.find<RootViewController>().audioData.firstWhere(
              (p0) => p0.id?.value == id,
              orElse: () => CourseWishlist());
          break;
        case AppConstants.textCourse:
          courseWishlist = Get.find<RootViewController>()
              .textCourseData
              .firstWhere((p0) => p0.id?.value == id,
                  orElse: () => CourseWishlist());
          break;
        case AppConstants.videoCourse:
          courseWishlist = Get.find<RootViewController>()
              .videoCourseData
              .firstWhere((p0) => p0.id?.value == id,
                  orElse: () => CourseWishlist());
          break;
        case AppConstants.audioCourse:
          courseWishlist = Get.find<RootViewController>()
              .audioCourseData
              .firstWhere((p0) => p0.id?.value == id,
                  orElse: () => CourseWishlist());
          break;
        default:
          //blogs
          courseWishlist = Get.find<RootViewController>().blogsData.firstWhere(
              (p0) => p0.id?.value == id,
              orElse: () => CourseWishlist());
          break;
      }
      await wishListProvider.saveToWatchLater(
          onError: (message, errorMap) {
            toastShow(message: message, error: true);
          },
          onSuccess: (message, json) {
            toastShow(message: message, error: false);
            WishListSaveModel responseData = WishListSaveModel.fromJson(json!);
            response(responseData);
            if (responseData.data ?? false) {
              if (courseWishlist.id?.value != null) {
                courseWishlist.isWishList?.value = 1;
              }
            } else {
              if (courseWishlist.id?.value != null) {
                courseWishlist.isWishList?.value = 0;
              }
            }
          },
          data: {"model_id": id, "type": type});
    } else {
      toastShow(message: "Please login");
    }
  }

  RxString platformVersion = 'Unknown'.obs;
  String botId = "582c8103-70af-4af6-bb8a-b0850c100113";
/*  final chat360FlutterSdkPlugin = Chat360FlutterSdk();
  final chat360 = Chat360();

  Future<void> initPlatformState() async {
    String platformVersionString;
    try {
      platformVersionString =
          await chat360.getPlatformVersion() ?? 'Unknown platform version';
    } on PlatformException {
      platformVersionString = 'Failed to get platform version.';
    }
    platformVersion.value = platformVersionString;
    chat360.setBotId(botId);
  }*/

  onChat() async {
    logPrint("user gender ${Get.find<AuthService>().user.value.gender}");
    String userType;
    Get.find<AuthService>().isGuestUser.value
        ? userType = "is_guest"
        : Get.find<AuthService>().isPro.value
            ? userType = "pro_user"
            : userType = "non_pro_user";

    // if (Get.find<AuthService>().isGuestUser.value) {
    //   userType = "is_guest";
    // } else if (Get.find<AuthService>().isPro.value) {
    //   userType = "pro_user";
    // } else {
    //   userType = "non_pro_user";
    // }

    Map<String, String> meta = {
      "user_type": userType,
      "mobile_no": Get.find<AuthService>().user.value.mobileNo ?? "",
      "c_name": Get.find<AuthService>().user.value.name ?? "",
      "referral_code": Get.find<AuthService>().user.value.referralCode ?? ""
    };
    /*await chat360.startChatbot(
        botId == "" ? "582c8103-70af-4af6-bb8a-b0850c100113" : botId, meta);*/
  }

  PageManager pageManager = getIt<PageManager>();

  postUserActivity() async {
    // isDataLoading(true);
    DateTime activeTime =
        await Get.find<AuthService>().getUserTime(isActive: true);
    DateTime inActiveTime =
        await Get.find<AuthService>().getUserTime(isActive: false);
    String date = DateFormat("yyyy-MM-dd").format(activeTime);
    Duration duration = inActiveTime.difference(activeTime);

    if (activeTime.year != 1999 && duration.inMinutes > 0) {
      await rootProvider.postUserActivity(
          data: [
            {"date": date, "time": duration.inMinutes}
          ],
          onError: (message, errorMap) {},
          onSuccess: (message, json) async {
            await Get.find<AuthService>().removeUserTime(isActive: true);
            await Get.find<AuthService>().removeUserTime(isActive: false);
            await Get.find<AuthService>().saveUserTime(isActive: true);
          });
    }
  }

  void checkTime() {
    logPrint("i am called");

    DateTime date1 = DateTime.parse("2024-07-10 15:22:00");
    DateTime date2 = DateTime.parse("2024-07-10 16:00:00");
    if (date1.isBefore(DateTime.now()) && date2.isAfter(DateTime.now())) {
      logPrint("i am after");
    }
  }

  void showRating(BuildContext context) {
    buildShowModalBottomSheet(
      context,
      AddAskRatingWidget(
          // courseDatum: courseDatum,
          ),
      isDismissible: true,
    );
  }

  showReferByDialog() {
    return showAnimatedDialog(
        Get.context!,
        MyDialog(
          title: "Permission Request",
          image: ImageResource.instance.permissionSettingsIcon,
          description:
              "To allow you to capture photos from your camera, In order to create receipts and expense reports, this is necessary.",
          isFailed: false,
          yesText: "Continue",
          noText: "Cancel",
          onPress: () async {},
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "Enter your mobile number",
                  style: StyleResource.instance.styleSemiBold(),
                ),
                Image.asset(
                  ImageResource.instance.referNEarnPOPBG,
                  height: 180,
                ),
                CommonButton(
                  text: StringResource.submit,
                  onPressed: () {
                    // if (mobileFormKey.currentState?.validate() ?? false) {
                    //   if (isMobileVerify.value) {
                    //     socialLoginVerify(firebaseData: firebaseData);
                    //   } else {
                    //     onSocialLoginNumber(firebaseData: firebaseData);
                    //   }
                    // }
                  },
                  loading: false,
                ),
                TextButton(
                    onPressed: () {
                      Get.back();
                      // isMobileVerify.value = false;
                      // mobileController.clear();
                      // otpController.clear();
                      // mobileError.value = "";
                      // otpError.value = "";
                      // isSocialLoading.value = false;
                    },
                    child: Text(
                      StringResource.cancel,
                      style: StyleResource.instance
                          .styleSemiBold(color: ColorResource.primaryColor),
                    ))
              ],
            ),
          ),
        ),
        isFlip: true);
  }

  VoidCallback get onAudioClose => () async {
        pageManager.stop();
        await pageManager.removeAll();
        pageManager.currentPlayingMedia.value =
            const MediaItem(id: "", title: "");
        logPrint("playlist notifire ${pageManager.playlistNotifier.length}");

        logPrint(pageManager.currentPlayingMedia.value.id);
        logPrint("close");
      };

  VoidCallback get playButtonClicked => () {
        if (pageManager.playButtonNotifier.value == ButtonState.playing) {
          pageManager.pause();
        } else {
          pageManager.play();
        }
      };

  Rx<ProgressBarState> progressAudioNotifier = const ProgressBarState(
    current: Duration.zero,
    buffered: Duration.zero,
    total: Duration.zero,
  ).obs;

  onChange(double value) {
    isManualSlide.value = true;
    final oldState = progressAudioNotifier.value;
    progressAudioNotifier.value = ProgressBarState(
      current: Duration(seconds: value.ceil()),
      buffered: oldState.buffered,
      total: oldState.total,
    );
  }

  onChangeEnd(double value) {
    logPrint("kjhknk $value");
    EasyDebounce.debounce(value.toString(), const Duration(milliseconds: 50),
        () {
      isManualSlide.value = false;
      pageManager.seek(Duration(seconds: value.ceil()));
    });
  }

  /// getUpdateVersion
  Rx<UpdateVersionModel> updateVersionData = UpdateVersionModel().obs;

  Rx<VersionData> versionData = VersionData().obs;

  void getUpdateVersionCode() async {
    try {
      await rootProvider.getUpdateVersionCode({
        "version": Get.find<AuthService>().version.value,
        "device_type": Platform.isAndroid ? "android" : "ios"
      }, onError: (message, errorMap) {}, onSuccess: (message, json) {
        updateVersionData.value = UpdateVersionModel.fromJson(json ?? {});
        versionData.value = updateVersionData.value.data ?? VersionData();
      });
    } catch (e) {
      logPrint(e.toString());
    }
  }

  void onUpdateLaterClick() {
    if (Platform.isAndroid || Platform.isIOS) {
      final appId =
          Platform.isAndroid ? 'com.codeclinic.stockpathshala' : '6446473535';
      try {
        launchUrl(Uri.parse("market://details?id=$appId"));
      } on PlatformException {
        if (Platform.isAndroid) {
          launchUrl(Uri.parse(
              "https://play.google.com/store/apps/details?id=$appId"));
        } else {
          launchUrl(Uri.parse(
              "https://apps.apple.com/in/app/stock-pathshala/id$appId"));
        }
      } catch (e) {
        logPrint('link redirect error: $e');
      }
    }
  }

  @override
  void onClose() {
    onAudioClose();
    getIt<PageManager>().onDisposeListener();
    //getIt<PageManager>().stop();
    super.onClose();
  }

  Future getLanguage() async {
    logPrint("i am here 2");
    isLangLoading(true);
    await accountProvider.getLanguage(onError: (message, errorMap) {
      toastShow(message: message);
      isLangLoading(false);
    }, onSuccess: (message, map) {
      lang.LanguageModel data = lang.LanguageModel.fromJson(map);
      for (lang.Datum? data in data.data ?? []) {
        languageData.add(DropDownData(
            id: data?.id.toString(), optionName: data?.languageName));
      }
      isLangLoading(false);
    });
  }

  Future<void> getProfile([bool isRoot = false, isPro = false]) async {
    await accountProvider.getProfile(
        onError: (message, errorMap) {},
        onSuccess: (message, json) async {
          try {
            logPrint("---------------json[data] IS--------------");
            await Get.find<AuthService>().saveUser(json["data"]);
            // WidgetsBinding.instance.addPostFrameCallback((_) {
            // if (askForRatingController.isShow.value == true &&
            //     !hasShownRating.value) {
            //   showRating(Get.context!);
            //   hasShownRating.value =
            //   true; // Set the flag to true after showing the rating
            // }
            // isAskRatingShow.value =
            // askForRatingController.isShow.value == true ? true : false;
            // print("isAskRatingShow value  : ${isAskRatingShow.value}");
            // print(
            //     "isAskRatingShow value is : ${askForRatingController.isShow.value}");
            // });
            // Check if rating_popup is true and call myInAppReview()
            if (json["data"]["rating_popup"] == true) {
              logPrint("---------------App Review Started---------------");
              // Get.find<RootViewController>().myInAppReview();
            }
            if (isRoot) {
              // showNavigationFlowSheet(json["data"], isPro);
            }
          } catch (e) {
            logPrint("----------------save data--------------------$e");
          }
          userNameController.value.text =
              Get.find<AuthService>().user.value.name ?? "";
          numberController.value.text =
              Get.find<AuthService>().user.value.mobileNo ?? "";
        });
  }

  String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  List<String> getPoints(String description) {
    List<String> points = [];

    if (description.contains("\r\n")) {
      for (var item in description.split("\r\n")) {
        points.add(removeHtmlTags(item));
      }
    } else if (description.contains("<br>")) {
      for (var item in description.split("<br>")) {
        points.add(removeHtmlTags(item));
      }
    } else {
      return [description];
    }

    return points;
  }

  void getLiveClassesData() async {
    await liveProvider.getLiveData(
        onError: (e, m) {},
        onSuccess: (str, map) {
          classStartTime.value = map?["data"]["data"][0]['start_datetime'];
          classDuration.value = map?["data"]["data"][0]['duration'];
          // classImage.value=map?["data"]["data"][0]['image'];
          // classTitle.value=map?["data"]["data"][0]['title'];

          getProfile();
        },
        pageNo: 1);
  }

  void showNavigationFlowSheet(Map<String, dynamic> json, bool isPro) {
    if (isPro) {
      showMyBottomSheet(json, "pro");
      return;
    } else {
      if (json['total_register'] == 0) {
        showMyBottomSheet(json, "register");
        return;
      } else if (json['total_joined'] == 0) {
        DateTime currentDateTime = DateTime.now();
        DateTime dateTimeFromString = DateTime.parse(classStartTime.value);

        DateTime sixtyMinutesFromNow =
            currentDateTime.add(Duration(minutes: classDuration.value));
        bool isWithinNextSixtyMinutes =
            currentDateTime.isAfter(dateTimeFromString) &&
                dateTimeFromString.isBefore(sixtyMinutesFromNow);

        DateTime fiveMinutesBefore =
            dateTimeFromString.subtract(const Duration(minutes: 5));
        bool isWithinFiveMinutesBefore =
            currentDateTime.isAfter(fiveMinutesBefore) &&
                currentDateTime.isBefore(dateTimeFromString);
        if (isWithinFiveMinutesBefore || isWithinNextSixtyMinutes) {
          // selectedTab.value=3;

          showMyBottomSheet(json, "joined");
          return;
        }
      } else {
        return;
      }
    }
  }

  showMyBottomSheet(json, str) {
    if (isShow.value) {
      List<String> points =
          getPoints(json["navigation_flow"]["${str}_msg"] ?? "");

      int time = json["navigation_flow"]["${str}_time"];
      Timer(Duration(seconds: time), () {
        Get.bottomSheet(
          Container(
            height: 225 + (40.0 * points.length),
            color: Colors.white,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(left: 50, top: 16),
                        child: CircleAvatar(
                          backgroundColor: Colors.deepPurple,
                          radius: 36,
                          child: CircleAvatar(
                            radius: 35,
                            backgroundImage: NetworkImage(
                              json["navigation_flow"]["${str}_image"] ?? "",
                            ),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(Icons.close_rounded))
                  ],
                ),
                const SizedBox(
                  height: 8,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          json["navigation_flow"]["${str}_title"].replaceAll(
                                  '[first-name]',
                                  json['name'].length >= 10
                                      ? json['name'].split(" ")[0]
                                      : json['name']) ??
                              "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: DimensionResource.fontSizeLarge,
                              color: Color(0xFF1A2330),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                Container(
                  height: points.length <= 4 ? 42.0 * points.length : 160,
                  padding: const EdgeInsets.symmetric(horizontal: 12),
                  child: ListView.builder(
                    physics: points.length <= 4
                        ? const NeverScrollableScrollPhysics()
                        : const BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 4,
                          horizontal: 8,
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  radius: 10,
                                  backgroundColor: Colors.deepPurple,
                                  child: Padding(
                                    padding: const EdgeInsets.all(2.0),
                                    child: CircleAvatar(
                                      radius: 10,
                                      backgroundColor: Colors.white,
                                      child: Text(
                                        "${index + 1}",
                                        style: const TextStyle(
                                            fontSize: DimensionResource
                                                .fontSizeExtraSmall,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(
                                  width: 14,
                                ),
                                Expanded(
                                    child: Text(
                                        points[index].replaceAll(
                                            '[first-name]',
                                            json['name'].length >= 10
                                                ? json['name'].split(" ")[0]
                                                : json['name']),
                                        style: const TextStyle(
                                            color: ColorResource.black,
                                            fontSize:
                                                DimensionResource.fontSizeSmall,
                                            fontWeight: FontWeight.w500))),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                    itemCount: points.length,
                  ),
                ),
                const SizedBox(
                  height: 8,
                ),
                InkWell(
                  onTap: () {
                    int value = json["navigation_flow"]["${str}_navigation"];
                    switch (value) {
                      case 5:
                        Get.back();
                        Get.toNamed(Routes.subscriptionView);

                        break;
                      // case 4:
                      //   Get.back();
                      //   selectedTab.value=value-1;
                      //   break;
                      // case 3:
                      //   Get.back();
                      //   Get.toNamed(Routes.subscriptionView);
                      //   break;
                      // case 2:
                      //   Get.back();
                      //   Get.toNamed(Routes.subscriptionView);
                      //   break;
                      // case 1:
                      //   Get.back();
                      //   Get.toNamed(Routes.subscriptionView);
                      //   break;
                      default:
                        Get.back();
                        selectedTab.value = value - 1;
                        break;
                    }
                  },
                  child: Container(
                      decoration: const BoxDecoration(
                        color: Colors.deepPurple,
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      ),
                      margin: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 4),
                      height: 50,
                      child: Center(
                        child: Text(
                          json["navigation_flow"]["${str}_button"] ?? "",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w500),
                        ),
                      )),
                ),
              ],
            ),
          ),
          barrierColor: Colors.black.withOpacity(0.5), // Optional
          isDismissible: true, // Optional
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
          ), // Optional
          enableDrag: true, // Optional
        );
      });
    }
  }

  getServiceData() async {
    await accountProvider.getServiceData(
        onError: (message, errorMap) {},
        onSuccess: (message, json) async {
          try {
            ServiceDataModel data = ServiceDataModel.fromJson(json);
            Get.find<AuthService>().serviceData.value = data;
          } catch (e) {
            logPrint("service datat error $e");
          }
          //kommunicateLogin();
        });
  }
}

class DrawerData {
  final String? title;
  final String? icon;

  DrawerData({this.title, this.icon});
}

class CourseWishlist {
  final RxInt? id;
  final RxInt? isWishList;

  CourseWishlist({this.id, this.isWishList});
}
