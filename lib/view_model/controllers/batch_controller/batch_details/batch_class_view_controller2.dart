import 'dart:async';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/batch_models/batch_details_model.dart';
import 'package:stockpathshala_beta/model/models/batch_models/all_batch_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/batch_provider.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/animated_box.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/popup_view/my_dialog.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../model/network_calls/api_helper/provider_helper/live_provider.dart';
import '../../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../../model/services/auth_service.dart';
import '../../../../../model/services/pagination.dart';
import '../../../../../view/screens/root_view/live_classes_view/live_class_detail/live_class_webview.dart';
import '../../../../../view/widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../../../view/widgets/toast_view/showtoast.dart';
import '../../../../model/models/live_class_model/live_class_model.dart';
import '../../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';

class BatchClassViewController2 extends GetxController {
  BatchProvider batchProvider = getIt();
  LiveProvider liveProvider = getIt();
  RxInt countValue = 0.obs;
  RxList<RatingDataVal> selectedRating = <RatingDataVal>[].obs;
  Rx<LiveClassModel> liveData = LiveClassModel().obs;
  RxList<RxBool> isTrialList = <RxBool>[].obs;
  RxList<DropDownData>
  listofSelectedTeacher = <DropDownData>[].obs;

  Rx<TextEditingController> searchController = TextEditingController().obs;
  late Rx<PagingScrollController<CommonDatum>> dataPagingController;
  Rx<BatchClassViewModel> batchDetailData = BatchClassViewModel().obs;
  RxBool isDataLoading = false.obs;
  RxBool isPast = false.obs;


  var isSearchEnabled = true.obs; // Observable boolean

  RxString searchKey = "".obs;



  BatchData? batchData;
  int? batchDateId;

  @override
  void onInit() async {
    if (Get.arguments != null) {
      batchData = Get.arguments[0];
    }
    super.onInit();
  }

  Future<void> onRegister(
    String liveClassId,
    int index, {
    bool isUpdateScreen = false,
  }) async {
    Get.find<AuthService>().user.value.liveCount = 0;
    isDataLoading.value = false;
    await postVideoJoinStatus(true, index,
        liveClassId: liveClassId, isUpdateScreen: isUpdateScreen);
    Get.find<RootViewController>().getProfile();
    isDataLoading.value = false;
  }

  Future<void> onJoinLiveClass(
    String liveClassId,
    int index, {
    bool isUpdateScreen = false,
    String? liveClassTitle,
  }) async {
    Get.dialog(const CommonCircularIndicator());
    await postVideoJoinStatus(false, index,
        liveClassId: liveClassId, isUpdateScreen: isUpdateScreen);
    isDataLoading.value = false;
  }

  Future<void> postVideoJoinStatus(
    bool isRegister,
    int index, {
    required String liveClassId,
    bool isUpdateScreen = false,
    String? liveClassTitle,
  }) async {
    await liveProvider.postVideoJoinStatus(
        onError: (message, errorMap) {
          logPrint("on error method called ");

          toastShow(message: message);
        },
        onSuccess: (message, json) async {
          if (isRegister) {
            dataPagingController.value.list[index].isLoading = false;
            dataPagingController.value.list[index].isRegister = 1;
            isDataLoading.value = false;
            unawaited(getBatchDetails());
          } else {
            Get.back();
            if (json?['data']['participant_link'] != null) {
              Navigator.push(
                Get.context!,
                MaterialPageRoute(
                  builder: (context) => LiveClassLaunch(
                    title: liveClassTitle ?? '',
                    url: json?['data']['participant_link'],
                  ),
                ),
              );
            }
          }
        },
        onComplete: () {
          // Handle completion, equivalent to onComplete
          logPrint("on Complete method called");
          isDataLoading.value = false;
          dataPagingController.value.isDataLoading.value = false;
        },
        mapData: {
          "live_class_id": liveClassId,
          "type": isRegister ? "register" : "join",
          "device": "android"
        });
  }

  // onClassSearch(val) {
  //   EasyDebounce.debounce(
  //       countValue.value.toString(), const Duration(milliseconds: 1000),
  //           () async {
  //         getLiveData(
  //           pageNo: 1,
  //           searchKeyWord: val,
  //           teacherId: listofSelectedTeacher
  //               .map((element) => element.id)
  //               .toList()
  //               .toString()
  //               .replaceAll("[", "")
  //               .replaceAll("]", "")
  //               .removeAllWhitespace,
  //         );
  //         countValue.value++;
  //       });
  // }

  void onClassSearch( query) {
    if (query.isEmpty) {
      // Clear search and reload the initial data
      dataPagingController.value.list.clear();
      getBatchDetails(); // Fetches the default data
      return;
    }
    // Perform search
    performSearch(query);
  }
  void performSearch(String query) {
    // Convert query to lowercase for case-insensitive matching
    final lowerCaseQuery = query.toLowerCase();

    final results = dataPagingController.value.list.where((item) {
      // Use null-aware operators to handle possible null values in title and description
      final title = item.title?.toLowerCase() ?? ''; // If title is null, use an empty string
      // final description = item.description?.toLowerCase() ?? ''; // If description is null, use an empty string

      // Check if the query is contained in either title or description
      return title.contains(lowerCaseQuery) ;
    }).toList();

    // Update the controller with the filtered results
    dataPagingController.value.list.assignAll(results);
  }


  Future<void> onRefresh() async {
    dataPagingController.value.list.clear();
    await getBatchDetails();
  }
  getLiveData(
      {required int pageNo,
        String? searchKeyWord,
        String? categoryId,
        String? langId,
        String? teacherId,
        String? levelId,
        String? duration,
        String? rating,
        String? subscriptionLevel}) async {
    searchKey.value = searchKeyWord ?? "";
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      dataPagingController.value.isDataLoading.value = false;
      dataPagingController.value.reset();
      isDataLoading.value = true;
    }
    await liveProvider.getLiveData(
        searchKeyWord: searchKey.value,
        onError: (message, errorMap) {
          toastShow(message: message);
          isDataLoading.value = false;
        },
        onSuccess: (message, json) {
          liveData.value = LiveClassModel.fromJson(json!);

          // logPrint('------------------json data is ----------'+json.toString());

          // Check `is_trial` from the JSON response
          // isTrial.value = json['data']['data'][0]['is_trial'] == 0;
          // logPrint('----------first item is_trial value ---------' +
          //     json['data']['data'][0]['is_trial'].toString());
          // logPrint('-------------istrail value---------' +
          //     (isTrial.value ? 'true' : 'false'));

          // Parse and store `is_trial` values for each item
          // isTrialList.clear();
          // for (var item in json['data']['data']) {
          //   bool isTrial = item['is_trial'] == 1; // true if is_trial == 1
          //   isTrialList.add(isTrial);
          // }

          List newItems = json['data']['data'];
          for (var item in newItems) {
            bool isTrial = item['is_trial'] == 1; // Check `is_trial` field
            isTrialList.add(RxBool(isTrial)); // Dynamically add new RxBool items
          }

          if (liveData.value.data?.data?.isNotEmpty ?? false) {
            logPrint(
                "----------------dfsdfs ${liveData.value.data?.data?.first.image}");
            dataPagingController.value.list.addAll(List<CommonDatum>.from(
                liveData.value.data!.data!
                    .map((x) => CommonDatum.fromJson(x.toJson()))));
          } else {
            dataPagingController.value.isDataLoading.value = false;
          }
          isDataLoading.value = false;
        },
        isPast: true,
        pageNo: pageNo,
        categoryId: categoryId,
        teacherId: teacherId,
        langId: langId,
        levelId: levelId,
        duration: duration,
        rating: selectedRating
            .map((element) => element.ratingValue)
            .toList()
            .toString()
            .replaceAll("[", "")
            .replaceAll("]", "")
            .removeAllWhitespace,
        subscriptionLevel: subscriptionLevel);
    if (pageNo != 1) {
      // dataPagingController.value.isDataLoading.value = false;
    }
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
          onPress: () async {
            Get.back();
          },
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
                Obx(() {
                  return CommonButton(
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
                  );
                }),
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
        dismissible: true,
        isFlip: true);
  }

  Future<void> getBatchDetails({int? pageNo}) async {
    if (pageNo == null) {
      dataPagingController.value.isDataLoading.value = true;
      isDataLoading.value = true;
    } else {
      dataPagingController.value.isDataLoading.value = false;
    }

    await batchProvider.getBatchData(
      batchStartDate: batchDateId ?? 0,
      batchId: batchData?.id ?? 0,
      isPast: isPast.value,
      pageNo: pageNo,
      onError: (message, errorMap) {
        toastShow(message: message);
        isDataLoading.value = false;
        dataPagingController.value.isDataLoading.value = false;
      },
      onSuccess: (message, json) {
        batchDetailData.value = BatchClassViewModel.fromJson(json!);

        if (batchDetailData.value.data?.data?.isNotEmpty ?? false) {
          dataPagingController.value.list.addAll(List<CommonDatum>.from(
            batchDetailData.value.data!.data!.map(
              (x) => CommonDatum.fromJson(
                x.toJson(),
              ),
            ),
          ));
        } else {
          // dataPagingController.value.isDataLoading.value = false;
        }
      },
    );
    isDataLoading.value = false;
  }
}
