import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:stockpathshala_beta/model/models/account_models/language_model.dart'
    as lang;
import 'package:stockpathshala_beta/model/models/account_models/level_model.dart'
    as level;
import 'package:stockpathshala_beta/model/models/auth_models/sign_in.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/account_provider.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';

import '../../../feedback/web_socket_service.dart';
import '../../../model/models/explore_all_category/all_category_model.dart'
    as category;
import '../../../model/network_calls/api_helper/provider_helper/courses_provider.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../service/page_manager.dart';
import '../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../../view/widgets/button_view/animated_box.dart';
import '../../../view/widgets/button_view/common_button.dart';
import '../../../view/widgets/popup_view/my_dialog.dart';
import '../../../view/widgets/text_field_view/common_textfield.dart';

class ProfileController extends GetxController {
  AccountProvider accountProvider = getIt();
  CourseProvider courseProvider = getIt();
  Rx<lang.Datum> selectedLanguage = lang.Datum().obs;
  Rx<level.Datum> selectedLevel = level.Datum().obs;
  RxList<category.Datum> selectedTags = <category.Datum>[].obs;
  Rx<lang.LanguageModel> languageData = lang.LanguageModel().obs;
  Rx<category.AllCategoryModel> tagsData = category.AllCategoryModel().obs;
  Rx<level.LevelModel> levelData = level.LevelModel().obs;
  Rx<DateTime> selectedDoB = DateTime(1999).obs;

  final GlobalKey<FormState> profileFormKey = GlobalKey<FormState>();
  final GlobalKey<FormState> preferFormKey = GlobalKey<FormState>();
  Rx<TextEditingController> emailController = TextEditingController().obs;
  Rx<TextEditingController> nameController = TextEditingController().obs;
  Rx<TextEditingController> mobileController = TextEditingController().obs;
  Rx<TextEditingController> dobController = TextEditingController().obs;

  RxString emailError = "".obs;
  RxString mobileError = "".obs;
  RxString nameError = "".obs;
  RxString dobError = "".obs;
  RxString selectedImage = "".obs;

  RxBool isLangLoading = false.obs;
  RxBool isLevelLoading = false.obs;
  RxBool isTagLoading = false.obs;
  RxBool isPrefLoading = false.obs;
  RxBool isImageLoading = false.obs;
  RxBool isReferLoading = false.obs;
  RxBool isLogOutLoading = false.obs;

  GlobalKey<FormState> referFormKey = GlobalKey<FormState>();
  Rx<TextEditingController> referCodeController = TextEditingController().obs;
  RxString referError = "".obs;
  @override
  void onInit() {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    logPrint("profile controller");
    getLanguage();
    getLevel();
    getCurrentUserData();
    super.onInit();
  }

  void onLogOut(context) async {
    // await Get.find<AuthService>().logOut();
    // Get.offAllNamed(Routes.loginScreen);
    return showAnimatedDialog(
      context,
      MyDialog(
         
        title: "Logout",
        image: ImageResource.instance.logoutIcon,
        //icon: Icons.logout,
        description: "Are you sure\nyou want to logout?",
        isFailed: false,
        onPress: onConfirmLogOut,
      ),
      dismissible: false,
      isFlip: true,
    );
  }

  onConfirmLogOut() async {
    Get.back();
    isLogOutLoading.value = true;
    await accountProvider.logOut(onError: (val, errorMap) {
      toastShow(message: val);
      isLogOutLoading.value = false;
    }, onSuccess: (message, json) async {
      Get.find<SocketService>().disconnect();
      PageManager pageManager = getIt<PageManager>();
      await pageManager.stop();
      await pageManager.removeAll();
      pageManager.currentPlayingMedia.value =
          const MediaItem(id: "", title: "");
      // Get.find<LoginController>().emailController.text = "Enter phone number";

      await Get.find<AuthService>().logOut();
      Get.offAllNamed(Routes.loginScreen);
      isLogOutLoading.value = false;
    });
  }

  void onAccountDelete(context) async {
    // await Get.find<AuthService>().logOut();
    // Get.offAllNamed(Routes.loginScreen);
    return showAnimatedDialog(
      context,
      MyDialog(
        title: "Delete",
        image: ImageResource.instance.logoutIcon,
        icon: const Icon(
          Icons.delete,
          color: ColorResource.white,
        ),
        description: "Are you sure\nyou want to delete this account?",
        isFailed: false,
        onPress: onConfirmDelete,
      ),
      dismissible: false,
      isFlip: true,
    );
  }

  onConfirmDelete() async {
    Get.back();
    isLogOutLoading.value = true;

    await accountProvider.deleteAccount(onError: (val, errorMap) {
      toastShow(message: val);
      isLogOutLoading.value = false;
    }, onSuccess: (message, json) async {
      PageManager pageManager = getIt<PageManager>();
      await pageManager.stop();
      await pageManager.removeAll();
      pageManager.currentPlayingMedia.value =
          const MediaItem(id: "", title: "");
      Get.find<LoginController>().emailController.text = "Enter phone number";
      Get.offAllNamed(Routes.loginScreen);

      await Get.find<AuthService>().logOut();
      isLogOutLoading.value = false;
    });
  }

  Future<void> getCurrentUserData({isRoot = false}) async {
    // if (Get.find<AuthService>().user.value.languageId != null) {
    Data userData = Get.find<AuthService>().user.value;
    logPrint("user name ${Get.find<AuthService>().user.value.toJson()}");
    nameController.value.text = userData.name ?? "";
    emailController.value.text = userData.email ?? "";
    mobileController.value.text = userData.mobileNo ?? "";
    // dobController.value.text = userData.dob??"";
    selectedLanguage.value = lang.Datum(
        id: Get.find<AuthService>().user.value.languageId,
        languageName:
            Get.find<AuthService>().user.value.language?.languageName);
    await getTags();

    selectedTags.value = userData.categories
            ?.map((e) => category.Datum.fromJson(e.toJson()))
            .toList() ??
        [];
    if (userData.dob != null) {
      selectedDoB.value = DateTime.parse(userData.dob);
      dobController.value.text =
          DateFormat(StringResource.dobDateFormat).format(selectedDoB.value);
    }
    // }
  }

  onLanguageSelect(lang.Datum data) async {
    if (data.id == Get.find<AuthService>().user.value.languageId) {
      selectedLanguage.value = lang.Datum(
          id: Get.find<AuthService>().user.value.languageId,
          languageName:
              Get.find<AuthService>().user.value.language?.languageName);
      await getTags();
      selectedTags.value = Get.find<AuthService>()
              .user
              .value
              .categories
              ?.map((e) => category.Datum.fromJson(e.toJson()))
              .toList() ??
          [];
    } else {
      selectedLanguage.value = data;
      selectedTags.clear();
      await getTags();
    }
  }

  Future getLanguage() async {
    isLangLoading(true);
    await accountProvider.getLanguage(onError: (message, errorMap) {
      toastShow(message: message);
      isLangLoading(false);
    }, onSuccess: (message, map) {
      languageData.value = lang.LanguageModel.fromJson(map);

      onLanguageSelect(languageData.value.data![1]!);

      isLangLoading(false);
    });
  }

  Future getLevel() async {
    isLevelLoading(true);
    await accountProvider.getLevel(onError: (message, errorMap) {
      toastShow(message: message);
      isLevelLoading(false);
    }, onSuccess: (message, map) {
      levelData.value = level.LevelModel.fromJson(map);
      List<DropDownData> tempList = [];
      for (level.Datum? data in levelData.value.data ?? []) {
        tempList.add(
            DropDownData(id: data?.id.toString(), optionName: data?.level));
      }
      Get.find<AuthService>().levelData.value = tempList;
      isLevelLoading(false);
    });
  }

  Future getTags() async {
    isTagLoading(true);
    await courseProvider.getAllCategories(
        sort: "ASC",
        searchKeyWord: "",
        languageId: selectedLanguage.value.id == null
            ? '1'
            : selectedLanguage.value.id.toString(),
        onError: (message, errorMap) {
          toastShow(message: message);
          isTagLoading(false);
        },
        onSuccess: (message, map) {
          tagsData.value = category.AllCategoryModel.fromJson(map!);
          selectedTags.value = List.from(tagsData.value.data ?? []);

          // List<DropDownData> tempList = [];
          // for(category.Datum? data in tagsData.value.data??[]){
          //   tempList.add(DropDownData(
          //       id: data?.id.toString(),
          //       optionName: data?.title
          //   ));
          // }
          // Get.find<AuthService>().levelData.value = tempList;
          onSubmit();
          isTagLoading(false);
        });
  }
  Future<bool?> sendFile(XFile file, bool isImage) async {
    bool? returnValue;
    isImageLoading(true);

    await accountProvider.onPreferSubmit({}, file: file, onError: (message, errorMap) {
      toastShow(message: message);
      isImageLoading(false);
      returnValue = false;
    }, onSuccess: (message, map) async {
      await Get.find<AuthService>().saveUser(map["data"]);
      toastShow(message: StringResource.imageUpdateSuccess);
      returnValue = true;
      isImageLoading(false);
    });

    return returnValue;
  }
  Future<void> pickImageAndUpload() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      selectedImage.value = pickedFile.path;
      await sendFile(pickedFile, true);
    }
  }

  // Future<bool?> sendFile(XFile file, bool isImage) async {
  //   bool? returnValue;
  //   isImageLoading(true);
  //   await accountProvider.onPreferSubmit({}, file: file,
  //       onError: (message, errorMap) {
  //     toastShow(message: message);
  //     isImageLoading(false);
  //     returnValue = false;
  //   }, onSuccess: (message, map) async {
  //     logPrint(map);
  //     await Get.find<AuthService>().saveUser(map["data"]);
  //     toastShow(message: StringResource.imageUpdateSuccess);
  //     returnValue = true;
  //     isImageLoading(false);
  //   });
  //   return returnValue;
  // }


  // void onUpdate() {
  //   final isFormValid = profileFormKey.currentState?.validate() ?? false;
  //   final hasEnoughTags = selectedTags.length >= 2;
  //
  //   if (isFormValid && hasEnoughTags) {
  //     onPreferSubmit(isPrefer: false);
  //     Get.find<HomeController>().getHomeData();
  //
  //     // ✅ Success toast tabhi chalegi jab upar dono condition true ho
  //     toastShow(message: "Profile updated successfully");
  //
  //     // ✅ Navigate back after delay
  //     Future.delayed(Duration(seconds: 2), () {
  //       Get.back();
  //     });
  //   } else {
  //     // ❌ Error toast tabhi dikhani hai jab tags kam ho
  //     if (!hasEnoughTags) {
  //       print("Showing toast message: ${StringResource.emptyTagsError}");
  //       toastShow(message: StringResource.emptyTagsError, error: true);
  //     }
  //
  //     // ❌ Optionally, aur bhi validations ke messages yahaan add kar sakte ho
  //     // else if (!isFormValid) {
  //     //   toastShow(message: "Please fill all required fields", error: true);
  //     // }
  //   }
  // }

  void onUpdate() {
    if ((profileFormKey.currentState?.validate() ?? false) &&
        selectedTags.isNotEmpty &&
        selectedTags.length >= 2) {
      onPreferSubmit(isPrefer: false);
      Get.find<HomeController>().getHomeData();
      toastShow(message: "Profile updated successfully");
      Future.delayed(Duration(seconds: 2), () {
        Get.back();
      });

    } else {
      if (selectedTags.isEmpty || selectedTags.length < 2) {
        print("Showing toast message: ${StringResource.emptyTagsError}");
        toastShow(message: StringResource.emptyTagsError, error: true);
      }
    }
  }



  onSubmit() async {
    logPrint("i am called");
    logPrint("hi ${languageData.value.data?[0]?.languageName}");
    selectedLanguage.value.id = languageData.value.data?.elementAt(1)!.id;
    if (selectedTags.isNotEmpty && selectedTags.length >= 2) {
      onPreferSubmit(isPrefer: true);
    } else {
      if (selectedTags.isEmpty || selectedTags.length < 2) {
        toastShow(message: StringResource.emptyTagsError, error: true);
      }
    }
  }

  onPreferSubmit(
      {required bool isPrefer, int? levelId, Function()? onSuccess}) async {
    // isPrefLoading(true);
    List<int?> tempTagsList = [];
    for (category.Datum tag in selectedTags) {
      tempTagsList.add(tag.id);
    }
    Map<String, dynamic> data;
    if (isPrefer) {
      data = {
        "language_id": selectedLanguage.value.id,
        "category_ids": tempTagsList,
        if (!(selectedDoB.value.year == 1999 &&
            selectedDoB.value.month == 01 &&
            selectedDoB.value.day == 01))
          "dob":
              "${selectedDoB.value.year}-${selectedDoB.value.month}-${selectedDoB.value.day}"
      };
    } else {
      if (levelId != null) {
        data = {
          "level_id": levelId,
        };
      } else {
        data = {
          "name": nameController.value.text,
          "email": emailController.value.text,
          "mobile_no": mobileController.value.text,
          "language_id": selectedLanguage.value.id,
          "category_ids": tempTagsList,
          "dob":
              "${selectedDoB.value.year}-${selectedDoB.value.month}-${selectedDoB.value.day}"
        };
      }
    }
    await accountProvider.onPreferSubmit(data, onError: (message, errorMap) {
      if (errorMap?.isNotEmpty ?? false) {
        errorMap?.forEach((key, value) {
          if (key == "mobile_no") {
            if (value.isNotEmpty) {
              mobileError.value = value.first;
            }
          } else if (key == "email") {
            if (value.isNotEmpty) {
              emailError.value = value.first;
            }
          } else if (key == "name") {
            if (value.isNotEmpty) {
              nameError.value = value.first;
            }
          }
        });
      }
      toastShow(message: message);
      isPrefLoading(false);
    }, onSuccess: (message, map) async {
      await Get.find<AuthService>().saveUser(map["data"]);
      await Get.find<AuthService>().saveTrainingTooltips('');
      // if (isPrefer) {
      //   showReferByDialog();
      // } else {
      if (levelId != null) {
        toastShow(message: "Your level updated");
      } else {
        // toastShow(message: "Profile update successfully");
      }
      // Get.back();
      // Get.offAllNamed(Routes.rootView);
      // }
      if (onSuccess != null) {
        onSuccess();
      }
      isPrefLoading(false);
    });
  }

  onSubmitRefer() async {
    isReferLoading.value = true;
    await accountProvider.onSubmitRefer(
        {"referred_by": referCodeController.value.text.toUpperCase()},
        onError: (message, errorMap) {
      logPrint("error map $errorMap");
      if (errorMap?.isNotEmpty ?? false) {
        if (errorMap?['message'] != null) {
          referError.value = errorMap?['message'];
        } else {
          errorMap?.forEach((key, value) {
            if (key == "referred_by") {
              if (value.isNotEmpty) {
                referError.value = value.first;
              }
            }
          });
        }
      }

      //toastShow(message: message);
      isReferLoading.value = false;
    }, onSuccess: (message, map) async {
      await Get.find<AuthService>().saveUser(map["data"]);
      await Get.find<AuthService>().saveTrainingTooltips('');
      Get.back();
      Get.offAllNamed(Routes.rootView);
      isReferLoading.value = false;
    });
  }

  showReferByDialog() {
    referCodeController.value.text = Get.find<AuthService>().referId.value;
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
                  "Enter who Refer you",
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
                    key: referFormKey,
                    child: Obx(
                      () => CommonTextField(
                        showEdit: false,
                        label: "",
                        controller: referCodeController.value,
                        hintText: StringResource.enterReferCode,
                        keyboardType: TextInputType.text,
                        validator: (value) {
                          if (value!.isEmpty) {
                            referError.value = StringResource.emptyReferError;
                            return "";
                          } else {
                            referError.value = "";
                            return null;
                          }
                        },
                        errorText: referError.value,
                      ),
                    ),
                  ),
                ),
                Obx(() {
                  return CommonButton(
                    text: StringResource.submit,
                    onPressed: onSubmitRefer,
                    loading: isReferLoading.value,
                  );
                }),
                TextButton(
                    onPressed: () {
                      Get.back();
                      Get.offAllNamed(Routes.rootView);
                    },
                    child: Text(
                      StringResource.skip,
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
}
