import 'dart:convert';
import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:stockpathshala_beta/model/models/auth_models/sign_in.dart'
    as use;
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import '../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../enum/routing/routes/app_pages.dart';
import '../models/service_model/service_model.dart';
import '../network_calls/dio_client/dio_client.dart';

class AuthService extends GetxService {
  Rx<use.Data> user = use.Data().obs;
  RxString referId = "".obs;
  RxString courseType = "".obs;
  RxString categoryId = "".obs;
  RxString courseId = "".obs;
  RxString version = "".obs;

  final GetStorage box = GetStorage();
  RxList<DropDownData> levelData = <DropDownData>[].obs;
  RxList<DropDownData> selectedDates =<DropDownData>[].obs;
  RxString firebaseToken = "".obs;
  Rx<ServiceDataModel> serviceData = ServiceDataModel().obs;
  RxString fcmToken = "".obs;
  RxString proIcon = "".obs;
  RxString proExpIcon = "".obs;
  RxString trialIcon = "".obs;
  RxString trialExpIcon = "".obs;
  RxString freshIcon = "".obs;
  RxBool isGuestUser = false.obs;
  RxBool isFreshUser = false.obs;
  RxBool isPro = false.obs;
  RxBool isTrial = false.obs;
  RxBool isProExpired = false.obs;
  RxBool isTrialExpired = false.obs;
  RxString userRole = ''.obs;
  RxBool isLoader = false.obs;
  Future<AuthService> init() async {
    // disableCapture();
    getCurrentUserData();
    // Get.lazyPut(() => ProfileController());
    initDynamicLinks();
    getApplicationVersion();
    return this;
  }

  // Future<void> disableCapture() async {
  //   if (Platform.isAndroid) {
  //     await FlutterWindowManager.addFlags(FlutterWindowManager.FLAG_SECURE);
  //   }
  // }

  String navigationFun() {
    if (user.value.id != null) {
      // if (user.value.languageId == null ||
      //     user.value.language?.languageName == null) {
      //   return Routes.selectPrefer;
      // } else if (user.value.tags == null) {
      //   return Routes.selectPrefer;
      // } else {
      return Routes.rootView;
      // }
    } else {
      getDeviceToken();

      return Routes.loginScreen;
    }
  }

  void initDynamicLinks() async {
    Uri deepLink = Uri();
    try {
      final PendingDynamicLinkData? data =
          await FirebaseDynamicLinks.instance.getInitialLink();
      logPrint("PendingDynamicLinkData ${data?.link}");
      if (data != null) {
        deepLink = data.link;
      }
      final PendingDynamicLinkData? initialLink =
          await FirebaseDynamicLinks.instance.getDynamicLink(deepLink);
      if (initialLink != null) {
        logPrint("dynamica link ${initialLink.link}");
        trimShortUrl(initialLink.link.path);
      } else {
        logPrint("dynamica link else ${deepLink.path}");
        trimShortUrl(deepLink.path);
      }
    } catch (e) {
      logPrint("object were $e");
    }
  }

  trimShortUrl(String url) {
    List<String> splitString = url.split("/");

    if (splitString.length == 2) {
      referId.value = splitString[1];
    } else {
      if (splitString.isNotEmpty) {
        courseId.value = splitString[2].toString();
        courseType.value = splitString[1].toString();
        if (splitString.length > 3) {
          categoryId.value = splitString[3].toString();
        }
      }
    }
  }

  getApplicationVersion() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
  }

  // Future<String?> getDeviceToken() async {
  //   String? deviceToken = await FirebaseMessaging.instance.getToken();
  //   // fcmToken.value = deviceToken??"";
  //   if (deviceToken != null) {
  //     logPrint('--------Device Token---------- $deviceToken');
  //   }
  //   return deviceToken;
  // }

  Future<String?> getDeviceToken() async {
    try {
      String? deviceToken = await FirebaseMessaging.instance.getToken();
      if (deviceToken != null) {
        logPrint('Device Token: $deviceToken');
        fcmToken.value = deviceToken; // Assign the token if found
      } else {
        logPrint('Device Token not found');
      }
      return deviceToken;
    } catch (e) {
      logPrint("Error retrieving device token: $e");
      return null;
    }
  }

  saveUser(Map<String, dynamic> map) async {
    try {
      await box.write(StringResource.instance.currentUser, jsonEncode(map));
    } catch (e) {
      logPrint('message  error $e');
    }
    user.value = use.Data.fromJson(map);
    isGuestUser.value = false;

    // Set `userRole` from the `user_role` key directly at the top level
    userRole.value = map["user_role"] ?? '';

    // Log to confirm `userRole` was set correctly
    logPrint("User role set to: ${userRole.value}");

    // Log to confirm `userRole`
    logPrint("User role set to: ${userRole.value}");

    await getCurrentUserData();
  }

  removeUserTime({bool isActive = true}) async {
    await box.remove(isActive
        ? StringResource.instance.activeTime
        : StringResource.instance.lastTime);
  }
  Future<void> saveUserTimes(List<DropDownData> selectedDates) async {
    final ids = selectedDates.map((e) => e.id).toList();
    print("Saving selected date filters: $ids");
    await box.write(StringResource.instance.selectedDatesKey, ids);
  }



    saveUserTime({bool isActive = true}) async {

      await box.write(
          isActive
              ? StringResource.instance.activeTime
              : StringResource.instance.lastTime,
          DateTime.now().toString());
    }

  Future<void> saveTrainingTooltips(String trainingTooltip) async {
    var trainingTooltipList = [];
    if (trainingTooltip.trim().isEmpty) {
      trainingTooltipList = [];
      await box.write(
          StringResource.instance.trainingTooltips, trainingTooltipList);
    } else {
      var list = await getTrainingTooltips();
      list.add(trainingTooltip);
      trainingTooltipList = list.toSet().toList();
      await box.write(
          StringResource.instance.trainingTooltips, trainingTooltipList);
    }
  }

  Future<List> getTrainingTooltips() async {
    return box.read<List>(StringResource.instance.trainingTooltips) ?? [];
  }

  Future<void> saveClassLevel(List<DropDownData> level) async {
    await box.write(StringResource.instance.classLevel, level);
  }

  Future<List<DropDownData>> getClassLevel() async {
    return box.read<List<DropDownData>>(StringResource.instance.classLevel) ??
        [];
  }

  Future<DateTime> getUserTime({bool isActive = true}) async {
    if (box.hasData(isActive
        ? StringResource.instance.activeTime
        : StringResource.instance.lastTime)) {
      return DateTime.parse(await box.read(isActive
          ? StringResource.instance.activeTime
          : StringResource.instance.lastTime));
    } else {
      return DateTime(1999);
    }
  }

  // saveIsGuestUser(bool map) async {
  //   await box.write(StringResource.instance.guestUser, map);
  //   user = use.Data(
  //     name: StringResource.guestUserName,
  //     profileImage: AppConstants.instance.guestUserProfile,
  //   ).obs;
  //   saveUser(user.value.toJson());
  //   isGuestUser.value = true;
  // }

  String _getUserIconUrl() {
    var userRoleIcons = Get.find<AuthService>().user.value.userRoleIcons;

    // Check if userRoleIcons is null, return a default guest URL
    if (userRoleIcons == null) {
      return 'https://internal.stockpathshala.in/icons/guest_user_icon.png';
    }

    // Check if user has a valid token
    if (Get.find<AuthService>().getUserToken().toString().isEmpty) {
      return 'https://internal.stockpathshala.in/icons/guest_user_icon.png'; // Fallback URL for guest users
    }

    // Determine the icon URL based on the user's role
    if (Get.find<AuthService>().isPro.value) {
      return userRoleIcons.proUserIconUrl ??
          'https://example.com/default_pro_icon_url';
    } else if (Get.find<AuthService>().isTrial.value) {
      return userRoleIcons.trialUserIconUrl ??
          'https://example.com/default_trial_icon_url';
    } else if (Get.find<AuthService>().isTrialExpired.value) {
      return userRoleIcons.trialExpiredUserIconUrl ??
          'https://example.com/default_trial_expired_icon_url';
    } else if (Get.find<AuthService>().isProExpired.value) {
      return userRoleIcons.proExpiredUserIconUrl ??
          'https://example.com/default_pro_expired_icon_url';
    } else {
      return userRoleIcons.freshUserIconUrl ??
          'https://example.com/default_fresh_user_icon_url';
    }
  }

  Future<void> getCurrentUserData() async {
    if (box.hasData(StringResource.instance.currentUser)) {
      try {
        isLoader.value = false;
        Map<String, dynamic> userData =
            jsonDecode(box.read(StringResource.instance.currentUser));
        // String userType = userData["user_role"];
        user = use.Data.fromJson(userData).obs;

        print('dfvsdsdgfsdfgdfhfdhdghswrysf ${userData["user_role"]}');

        if (userData["user_role"].toString() == 'trial_user') {
          // trialIcon.value = user.value.userRoleIcons!.trialUserIconUrl.toString();

          isTrial.value = true;
          isPro.value = false;
          isProExpired.value = false;
          isTrialExpired.value = false;
          isFreshUser.value = false;
          isGuestUser.value = false;
        } else if (userData["user_role"] == 'pro_user') {
          // proIcon.value = user.value.userRoleIcons!.proUserIconUrl.toString();

          isPro.value = true;
          isTrial.value = false;
          isProExpired.value = false;
          isTrialExpired.value = false;
          isFreshUser.value = false;
          isGuestUser.value = false;
        } else if (userData["user_role"] == 'trial_expired_user') {
          // trialExpIcon.value = user.value.userRoleIcons!.trialExpiredUserIconUrl.toString();

          isPro.value = false;
          isTrial.value = false;
          isProExpired.value = false;
          isTrialExpired.value = true;
          isFreshUser.value = false;
          isGuestUser.value = false;
        } else if (userData["user_role"] == 'fresh_user') {
          // trialExpIcon.value = user.value.userRoleIcons!.trialExpiredUserIconUrl.toString();

          isPro.value = false;
          isTrial.value = false;
          isProExpired.value = false;
          isTrialExpired.value = false;
          isFreshUser.value = true;
          isGuestUser.value = false;
        } else if (userData["user_role"] == 'pro_expired_user') {
          // proExpIcon.value = user.value.userRoleIcons!.proExpiredUserIconUrl.toString();

          isPro.value = false;
          isTrial.value = false;
          isProExpired.value = true;
          isTrialExpired.value = false;
          isFreshUser.value = false;
          isGuestUser.value = false;
        } else {
          // freshIcon.value = user.value.userRoleIcons!.freshUserIconUrl.toString();

          isProExpired.value = false;
          isTrialExpired.value = false;
          isTrial.value = false;
          isPro.value = false;
          isFreshUser.value = false;
          isGuestUser.value = true;
        }
        // if (user.value.userSubscription?.id != null) {
        //   DateTime endDate = user.value.userSubscription!.endDate!;
        //
        //   if (endDate.isAfter(DateTime.now())) {
        //     logPrint("i am in after ${user.value.userSubscription?.id}");
        //     isPro.value = true;
        //
        //   } else if (endDate.isBefore(DateTime(
        //       DateTime.now().year, DateTime.now().month, DateTime.now().day))) {
        //     logPrint("i am in before ${user.value.userSubscription?.id}");
        //     isPro.value = false;
        //   } else {
        //     logPrint("i am in same ${user.value.userSubscription?.id}");
        //
        //     isPro.value = true;
        //   }
        //   logPrint("endDate:${user.value.userSubscription?.endDate}");
        // } else {
        //   isPro.value = false;
        // }
        if (user.value.isGuest ?? false) {
          isGuestUser.value = true;
        }

        AppConstants.setUserToAnalytics();

        isLoader.value = true;
      } catch (e) {
        logPrint("User Data Error =>$e");
      }
    } else {
      user = use.Data().obs;
    }
  }

  bool getGuestUser() {
    if (box.hasData(StringResource.instance.guestUser)) {
      try {
        isGuestUser.value =
            box.read(StringResource.instance.currentUser) ?? false;
      } catch (e) {
        logPrint("User Data Error =>$e");
        isGuestUser.value = false;
      }
    } else {
      isGuestUser.value = false;
    }
    return isGuestUser.value;
  }

  Future<void> removeGuestUser() async {
    //user.value = UserModel();
    await box.remove(StringResource.instance.currentUser);
    await box.remove(StringResource.instance.guestUser);
  }

  Future<void> saveUserToken(String token, String id) async {
    final DioClient dioClient = getIt();
    dioClient.token = token;
    dioClient.dio.options.headers = {
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': 'Bearer $token'
    };
    try {
      await box.write(StringResource.instance.token, token);
      await box.write(StringResource.instance.fcmToken, id);
    } catch (e) {
      logPrint("token error $e");
      rethrow;
    }
  }

  Future<void> removeUserData() async {
    //user.value = UserModel();
    await box.remove(StringResource.instance.currentUser);
    logPrint("user data ${box.read(StringResource.instance.currentUser)}");
  }

  Future<void> removeToken() async {
    await box.remove(StringResource.instance.token);
    await box.remove(StringResource.instance.fcmToken);
    logPrint("user token ${box.read(StringResource.instance.token)}");
  }

  Future<void> removeIsRemember() async {
    await box.remove(StringResource.instance.remember);
  }

  removeClassLevel() async {
    await box.remove(
      StringResource.instance.classLevel,
    );
  }

  Future<void> logOut() async {
    await removeUserData();
    await removeToken();
    await removeIsRemember();
    await removeClassLevel();
    DioClient dio = getIt();
    dio.dio.options.headers = {
      'Content-Type': 'application/json',
    };
  }

  isRememberTap(String value) async {
    await box.write(StringResource.instance.remember, value);
  }

  String getUserToken() {
    return box.read(StringResource.instance.token) ?? "";
  }

  String getUserFcmToken() {
    return box.read(StringResource.instance.fcmToken) ?? "";
  }

  bool get isLogin => box.hasData(StringResource.instance.currentUser);
  bool get isPermission => box.hasData(StringResource.instance.isPermission);
}
