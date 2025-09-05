
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import '../live_classes_controller/filter_controller/filter_controller.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/common_container_model/common_container_model.dart';
import 'package:stockpathshala_beta/model/models/live_class_model/live_class_model.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/service/utils/object_extension.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import '../../../../model/network_calls/api_helper/provider_helper/live_provider.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/services/pagination.dart';
import '../../../../view/screens/root_view/live_classes_view/live_class_detail/live_class_webview.dart';
import '../../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';
import '../root_view_controller.dart';

class LiveClassesController extends GetxController {
  LiveProvider liveProvider = getIt();
  Rx<LiveClassModel> liveData = LiveClassModel().obs;
  late Rx<PagingScrollController<CommonDatum>> dataPagingController;
  RxBool isDataLoading = false.obs;
  RxBool isOnTapAllowd = true.obs;
  RxBool isTabValueChange = false.obs;
  RxBool onRegisterWebinar = false.obs;
  RxString serverTime = ''.obs;

  // Timer related variables
  RxList<int> LiveClassTimeDifferences = <int>[].obs;
  RxList<Map<String, DateTime>> liveClassTimes = <Map<String, DateTime>>[].obs;
  RxList<int> isRegisterList = <int>[].obs;
  var isStartedClass = <int, bool>{}.obs;
  final Map<int, Timer?> _timers = {};
  var liveClassIndexTimers = <int, int>{}.obs;
  RxInt start = 0.obs;
  RxString time = "".obs;
  Timer? timer;
  RxBool timerTrue = false.obs;

  // Filter state variables
  RxString currentCategoryId = "".obs;
  RxString currentLangId = "".obs;
  RxString currentLevelId = "".obs;
  RxString currentDateFilter = "".obs;
  RxString currentDuration = "".obs;
  RxString currentRating = "".obs;
  RxString currentSubscriptionLevel = "".obs;
  RxString currentTeacherId = "".obs;

  // UI related variables
  RxString searchKey = "".obs;
  RxBool isClearLoading = false.obs;
  RxInt countValue = 0.obs;
  late TabController tabController;
  RxList<Tab> tabs = <Tab>[
    const Tab(text: 'LIVE Webinars'),
    const Tab(text: 'Recordings'),
  ].obs;
  Rx<TextEditingController> searchController = TextEditingController().obs;

  // Filter selection lists
  RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;
  RxList<DropDownData> selectedLevel = <DropDownData>[].obs;
  RxList<DropDownData> listofSelectedTeacher = <DropDownData>[].obs;
  RxList<RatingDataVal> selectedRating = <RatingDataVal>[].obs;
  Rx<DropDownData> selectedSub = DropDownData().obs;
  RxList<DropDownData> listOFSelectedDuration = <DropDownData>[].obs;
  RxList<DropDownData> listOFSelectedDate = <DropDownData>[].obs;

  final rootViewController = Get.find<RootViewController>();
  String token = Get.find<AuthService>().getUserToken();
  final Dio _dio = Dio();
  RxBool hasMore = false.obs;

  @override
  void onInit() async {

    dataPagingController = PagingScrollController<CommonDatum>(
      onLoadMore: (int page, int totalItemsCount) async {
        await getLiveData(pageNo: page);
      },
      getStartPage: () => 1,
      getThreshold: () => 0,
    ).obs;

    await getLiveData(pageNo: 1);
    super.onInit();
  }

  @override
  void onClose() {
    // Cancel all timers when controller is closed
    _timers.forEach((key, timer) {
      timer?.cancel();
    });
    super.onClose();
  }

  void showTooltiRegesterClass() async {
    if (dataPagingController.value.list.isNotEmpty) {
      final firstClass = dataPagingController.value.list.first;
      if (firstClass.isRegister == 0) {
        final toolTipList = await Get.find<AuthService>().getTrainingTooltips();
        if (!toolTipList.contains('registerClass')) {
          Future.delayed(const Duration(seconds: 1), () {
            rootViewController.toolTipcontroller.start(3);
          });
        }
      }
      showJoinToolTip();
    }
  }

  void showJoinToolTip() async {
    final now = DateTime.now();
    final firstClass = dataPagingController.value.list.first;
    if (((!((firstClass.startTime ?? DateTime.now()) > now)) &&
        firstClass.isRegister == 1)) {
      final toolTipList = await Get.find<AuthService>().getTrainingTooltips();
      if (!toolTipList.contains('joinLiveClass')) {
        Future.delayed(const Duration(seconds: 1), () {
          rootViewController.toolTipcontroller.start(3);
        });
      }
    }
  }

  void onClassSearch(val) {
    EasyDebounce.debounce(
        countValue.value.toString(),
        const Duration(milliseconds: 1000),
            () async {
          searchKey.value = val;
          getLiveData(pageNo: 1, searchKeyWord: val);
          countValue.value++;
        }
    );
  }
  Future<void> onRefresh() async {
    try {
      dataPagingController.value.reset();
      await getLiveData(pageNo: 1, searchKeyWord: searchKey.value);
      if (!Get.find<AuthService>().isGuestUser.value) {
        await Get.find<RootViewController>().getProfile();
      }
    } catch (e) {
      print('Refresh error: $e');
    }
  }

  void tabChange() {
    getLiveData(pageNo: 1, searchKeyWord: searchKey.value);
  }

  Future<void> getLiveData({
    required int pageNo,
    String? searchKeyWord,
    String? categoryId,
    String? langId,
    String? levelId,
    String? dateFilter,
    String? duration,
    String? rating,
    String? subscriptionLevel,
    String? teacherId,
    bool callFromRegister = false,
  }) async {
    if (categoryId != null) currentCategoryId.value = categoryId;
    if (langId != null) currentLangId.value = langId;
    if (levelId != null) currentLevelId.value = levelId;
    if (dateFilter != null) currentDateFilter.value = dateFilter;
    if (duration != null) currentDuration.value = duration;
    if (rating != null) currentRating.value = rating;
    if (subscriptionLevel != null) currentSubscriptionLevel.value = subscriptionLevel;
    if (teacherId != null) currentTeacherId.value = teacherId;

    searchKey.value = searchKeyWord ?? searchKey.value;

    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      if (callFromRegister) {
        dataPagingController.value.isDataLoading.value = true;
      } else {
        dataPagingController.value.reset();
        isDataLoading.value = true;
        LiveClassTimeDifferences.clear();
        liveClassTimes.clear();
        isRegisterList.clear();
        liveClassIndexTimers.clear();
        isStartedClass.clear();
      }
    }

    await liveProvider.getLiveData(
      onError: (message, errorMap) {
        toastShow(message: message);
        isDataLoading.value = false;
        dataPagingController.value.isDataLoading.value = false;
        hasMore.value = false;
      },
      onSuccess: (message, json) {
        try {

          hasMore.value = true;
          liveData.value = LiveClassModel.fromJson(json!);
          serverTime.value = liveData.value.serverTime!;

          // Process time data for each class
          List<dynamic> classes = json['data']['data'];
          DateTime serverDateTime = DateTime.parse(serverTime.value);

          for (var liveClass in classes) {
            try {
              String startTimeString = liveClass['start_datetime'];
              String endTimeString = liveClass['end_datetime'];

              DateTime startTime = DateTime.parse(startTimeString);
              DateTime endTime = DateTime.parse(endTimeString);

              Duration timeDifference = startTime.difference(serverDateTime);
              LiveClassTimeDifferences.add(timeDifference.inSeconds);

              liveClassTimes.add({
                'startTime': startTime,
                'endTime': endTime,
              });

              print("opdfvf ${LiveClassTimeDifferences.length}");
              startCountdownForClass(LiveClassTimeDifferences.length - 1);

              // Store registration status
              int isRegisterValue = liveClass['is_register'] ?? 0;
              isRegisterList.add(isRegisterValue);
            } catch (e) {
              print("Error processing class data: $e");
            }
          }

          // Update the list of classes
          if (liveData.value.data?.data?.isNotEmpty ?? false) {
            if (callFromRegister) {
              dataPagingController.value.list.clear();
            }

            dataPagingController.value.list.addAll(
                liveData.value.data!.data!.map((x) => CommonDatum.fromJson(x.toJson())).toList()
            );
          } else {
            dataPagingController.value.isDataLoading.value = false;
          }

          // Handle tab changes if needed
          if (isTabValueChange.value) {
            tabController.index = 1;
            isTabValueChange.value = false;
          } else {
            tabController.index = 0;
          }

        } catch (e) {
          print("Error processing response: $e");
          toastShow(message: "Error processing data");
          hasMore.value = false;
        } finally {
          hasMore.value = false;
          isDataLoading.value = false;
          dataPagingController.value.isDataLoading.value = false;
        }
      },
      pageNo: pageNo,
      searchKeyWord: searchKey.value,
      categoryId: currentCategoryId.value,
      langId: currentLangId.value,
      levelId: currentLevelId.value,
      dateFilter: currentDateFilter.value,
      duration: currentDuration.value,
      rating: currentRating.value,
      subscriptionLevel: currentSubscriptionLevel.value,
      teacherId: currentTeacherId.value,
    );
  }

  void startCountdownForClass(int classIndex) {
    int timeDifference = LiveClassTimeDifferences[classIndex];

    // Cancel any existing timer for this class
    _timers[classIndex]?.cancel();

    if (timeDifference > 86400 * 2) {
      // More than 2 days left - show "Registered"
      liveClassIndexTimers[classIndex] = -1;
      isStartedClass[classIndex] = false;
    } else if (timeDifference <= 86400 * 2 && timeDifference > 0) {
      // Between now and 2 days - show countdown
      liveClassIndexTimers[classIndex] = timeDifference;
      isStartedClass[classIndex] = false;

      _timers[classIndex] = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        if (liveClassIndexTimers[classIndex]! <= 0) {
          timer.cancel();
          isStartedClass[classIndex] = true;
        } else {
          liveClassIndexTimers[classIndex] = liveClassIndexTimers[classIndex]! - 1;
        }
      });
    } else {
      // Class has already started or passed
      liveClassIndexTimers[classIndex] = 0;
      isStartedClass[classIndex] = true;
    }
  }

  // Other methods remain the same...
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

  Future<void> onRegisterForLiveClass(int id, String type) async {
    onRegisterWebinar.value = true;
    String baseUrl = '${AppConstants.instance.baseUrl}live_classes';

    try {
      var body = {
        'live_class_id': id,
        'type': type,
      };

      final response = await _dio.post(
        baseUrl,
        data: jsonEncode(body),
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        onRegisterWebinar.value = false;
        update();
      } else {
        onRegisterWebinar.value = false;
        print('Error: ${response.data['message']}');
      }
    } catch (e) {
      onRegisterWebinar.value = false;
      print('Error: $e');
    }
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

  Future<void> postVideoJoinStatus(
      bool isRegister,
      int index, {
        required String liveClassId,
        bool isUpdateScreen = false,
        String? liveClassTitle,
      }) async {
    await liveProvider.postVideoJoinStatus(
      onError: (message, errorMap) {
        // Handle error
      },
      onSuccess: (message, json) async {
        if (json?['status'] == true && (json?['data'].containsKey('popup_data') ?? false)) {
          onRegisterPopUp(json);
        } else {
          if (isRegister) {
            dataPagingController.value.list[index].isLoading = false;
            dataPagingController.value.list[index].isRegister = 1;
            isOnTapAllowd.value = true;
            isDataLoading.value = false;
            onRegisterPopUp(json);
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
        }
      },
      onComplete: () {
        dataPagingController.value.isDataLoading.value = false;
        isOnTapAllowd.value = true;
        isDataLoading.value = false;
        update();
      },
      mapData: {
        "live_class_id": liveClassId,
        "type": isRegister ? "register" : "join",
        "device": Platform.isIOS ? "ios" : "android"
      },
    );
  }

  onRegisterPopUp(json) {
    // emailController.text = "Enter your name";
    // bool isName = Get.find<AuthService>().user.value.name == null;
    logPrint("onRegister json value is ${json.toString()}");
    final title = json?['data']['popup_data']['title'] ?? 'limit reached';
    logPrint(" Title of the popUP is ${title}");
    final imageUrl = json?['data']['popup_data']['image_url'] ?? '';
    final description = json?['data']['popup_data']['description'] ?? 'limit';
    final titleColor = json?['data']['popup_data']['title_color'] ?? '#000000';
    final dismissButton =
        json?['data']['popup_data']['dismiss_button'] ?? 'default';
    final descriptionColor =
        json?['data']['popup_data']['description_color'] ?? '#000000';
    final dismissButtonColor =
        json?['data']['popup_data']['dismiss_button_color'] ?? '#000000';
    final dismissBtnTextColor =
        json?['data']['popup_data']['dismiss_btn_text_color'] ?? '#000000';

    int time = -1;
    Timer(Duration(seconds: time), () {
      Get.bottomSheet(
        // showDialog(
        //     context: Get.context!,
        //     builder: (BuildContext context) {
        //       return WillPopScope(
        //         onWillPop: (() async => true),
        //         child: Dialog(
        //             shape: RoundedRectangleBorder(
        //               borderRadius: BorderRadius.circular(16.0),
        //             ),
        // child: SizedBox(
        // height:
        // isName ?
        // (Get.height / 2.5) + 16,
        //  : (Get.height / 2.75),
        Container(
          padding: EdgeInsets.all(15),
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(25.0),
              topRight: Radius.circular(25.0),
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
                Image.network(
                  imageUrl,
                  height: 100,
                ),
                Text(
                  title,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      color:
                      Color(int.parse(titleColor.replaceAll('#', '0xff')))),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 2,
                  ),
                  child: Text(
                    description.replaceAll(RegExp(r'<[^>]*>'), ''),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 14,
                        color: Color(int.parse(
                            descriptionColor.replaceAll('#', '0xff')))),
                  ),
                ),
                // isName?
                const SizedBox(
                  height: 14,
                ),
                // : const SizedBox(),
                // isName
                //     ? Padding(
                //         padding: const EdgeInsets.symmetric(
                //             horizontal: 12, vertical: 0),
                //         child: Obx(
                //           () => Form(
                //             key: signInFormKey,
                //             child: CommonTextField(
                //               showEdit: false,
                //               isSpace: true,
                //               isTrailPopUp: true,
                //               readOnly: isLoading.value,
                //               onTap: () {
                //                 emailController.text = "";
                //               },
                //               isLogin: false,
                //               isHint: false,
                //               controller: emailController,
                //               keyboardType: TextInputType.text,
                //               validator: (value) {
                //                 if (value == "Enter your name") {
                //                   emailError.value =
                //                       StringResource.nameInvalidError;
                //                   return "";
                //                 } else if (value!.length <= 3) {
                //                   emailError.value =
                //                       StringResource.nameInvalidError;
                //                   return "";
                //                 } else {
                //                   emailError.value = "";
                //                   return null;
                //                 }
                //               },
                //               errorText: emailError.value,
                //             ),
                //           ),
                //         ),
                //       )
                //     : Container(),
                const SizedBox(
                  height: 12,
                ),
                SizedBox(
                  width: 120,
                  height: 35,
                  child: CommonButton(
                      color: Color(int.parse(
                          dismissButtonColor.replaceAll('#', '0xff'))),
                      text: dismissButton,
                      loading: false,
                      onPressed: () {
                        Get.back();
                        Get.toNamed(Routes.subscriptionView);
                      }),
                )
              ],
            ),
          ),
        ),
        // )),
        // );
        // },
        barrierColor: Colors.black.withOpacity(0.5), // Optional
        isDismissible: true, // Optional
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
        ), // Optional
        enableDrag: true, // Optional
        // barrierDismissible: false
        // );
      );
    });
  }
}
