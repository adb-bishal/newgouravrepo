
import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
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

  // Add loading state to prevent concurrent API calls
  bool _isLoadingData = false;

  @override
  void onInit() async {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
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
    _cancelAllTimers();

    // Cancel search debounce
    EasyDebounce.cancel(countValue.value.toString());

    // Dispose controllers
    // searchController.value.dispose();

    super.onClose();
  }

  void _cancelAllTimers() {
    _timers.forEach((key, timer) {
      timer?.cancel();
    });
    _timers.clear();

    // Cancel main timer if exists
    timer?.cancel();
    timer = null;
  }

  void showTooltiRegesterClass() async {
    if (dataPagingController.value.list.isNotEmpty) {
      final firstClass = dataPagingController.value.list.first;
      if (firstClass.isRegister == 0) {
        final toolTipList = await Get.find<AuthService>().getTrainingTooltips();
        if (!toolTipList.contains('registerClass')) {
          Future.delayed(const Duration(seconds: 1), () {
            if (Get.isRegistered<RootViewController>()) {
              rootViewController.toolTipcontroller.start(3);
            }
          });
        }
      }
      showJoinToolTip();
    }
  }

  void showJoinToolTip() async {
    final now = DateTime.now();
    if (dataPagingController.value.list.isNotEmpty) {
      final firstClass = dataPagingController.value.list.first;
      if (((!((firstClass.startTime ?? DateTime.now()) > now)) &&
          firstClass.isRegister == 1)) {
        final toolTipList = await Get.find<AuthService>().getTrainingTooltips();
        if (!toolTipList.contains('joinLiveClass')) {
          Future.delayed(const Duration(seconds: 1), () {
            if (Get.isRegistered<RootViewController>()) {
              rootViewController.toolTipcontroller.start(3);
            }
          });
        }
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
    // Prevent concurrent API calls
    if (_isLoadingData && pageNo == 1) return;

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
      _isLoadingData = true;
      if (callFromRegister) {
        dataPagingController.value.isDataLoading.value = true;
      } else {
        dataPagingController.value.reset();
        isDataLoading.value = true;

        // Clear existing data and cancel timers
        _cancelAllTimers();
        LiveClassTimeDifferences.clear();
        liveClassTimes.clear();
        isRegisterList.clear();
        liveClassIndexTimers.clear();
        isStartedClass.clear();
      }
    }

    try {
      await liveProvider.getLiveData(
        onError: (message, errorMap) {
          toastShow(message: message);
          isDataLoading.value = false;
          dataPagingController.value.isDataLoading.value = false;
          hasMore.value = false;
          _isLoadingData = false;
        },
        onSuccess: (message, json) {
          try {
            hasMore.value = true;
            liveData.value = LiveClassModel.fromJson(json!);
            serverTime.value = liveData.value.serverTime!;

            // Process time data for each class
            List<dynamic> classes = json['data']['data'];
            DateTime serverDateTime = DateTime.parse(serverTime.value);

            for (int i = 0; i < classes.length; i++) {
              try {
                var liveClass = classes[i];
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

                // Use the actual index for the timer
                int classIndex = dataPagingController.value.list.length + i;
                startCountdownForClass(classIndex, timeDifference.inSeconds);

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
            _isLoadingData = false;
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
    } catch (e) {
      print("Error in getLiveData: $e");
      isDataLoading.value = false;
      dataPagingController.value.isDataLoading.value = false;
      _isLoadingData = false;
    }
  }

  void startCountdownForClass(int classIndex, int timeDifferenceInSeconds) {
    // Cancel any existing timer for this class
    _timers[classIndex]?.cancel();

    if (timeDifferenceInSeconds > 86400 * 2) {
      // More than 2 days left - show "Registered"
      liveClassIndexTimers[classIndex] = -1;
      isStartedClass[classIndex] = false;
    } else if (timeDifferenceInSeconds <= 86400 * 2 && timeDifferenceInSeconds > 0) {
      // Between now and 2 days - show countdown
      liveClassIndexTimers[classIndex] = timeDifferenceInSeconds;
      isStartedClass[classIndex] = false;

      _timers[classIndex] = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
        // Safe access with null check
        int? currentTime = liveClassIndexTimers[classIndex];
        if (currentTime == null || currentTime <= 0) {
          timer.cancel();
          _timers.remove(classIndex); // Clean up the timer reference
          isStartedClass[classIndex] = true;
        } else {
          liveClassIndexTimers[classIndex] = currentTime - 1;
        }
      });
    } else {
      // Class has already started or passed
      liveClassIndexTimers[classIndex] = 0;
      isStartedClass[classIndex] = true;
    }
  }

  Future<void> onJoinLiveClass(
      String liveClassId,
      int index, {
        bool isUpdateScreen = false,
        String? liveClassTitle,
      }) async {
    if (!isOnTapAllowd.value) return; // Prevent multiple taps

    isOnTapAllowd.value = false;
    Get.dialog(const CommonCircularIndicator());

    try {
      await postVideoJoinStatus(false, index,
          liveClassId: liveClassId, isUpdateScreen: isUpdateScreen);
    } catch (e) {
      print("Error joining live class: $e");
      Get.back(); // Close dialog on error
    } finally {
      isDataLoading.value = false;
      isOnTapAllowd.value = true;
    }
  }

  Future<void> onRegisterForLiveClass(int id, String type) async {
    if (onRegisterWebinar.value) return; // Prevent multiple calls

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


    try {
      await postVideoJoinStatus(
        true,
        index,
        liveClassId: liveClassId,
        isUpdateScreen: isUpdateScreen,
      );

      // Delay slightly to let backend apply trial activation
      await Future.delayed(const Duration(seconds: 1));

      // Re-fetch updated user profile
      await Get.find<RootViewController>().getProfile();
      // Get.offAllNamed(Routes.rootView);
      // Optionally: call update() or refresh manually
    } catch (e) {
      print("Error registering: $e");
    } finally {
      isDataLoading.value = false;
      isOnTapAllowd.value = true;
    }
  }

  // Future<void> onRegister(
  //     String liveClassId,
  //     int index, {
  //       bool isUpdateScreen = false,
  //     }) async {
  //
  //   isOnTapAllowd.value = false;
  //   isDataLoading.value = true;
  //
  //   try {
  //     await postVideoJoinStatus(
  //       true,
  //       index,
  //       liveClassId: liveClassId,
  //       isUpdateScreen: isUpdateScreen,
  //     );
  //
  //     await Get.find<RootViewController>().getProfile();
  //   } catch (e) {
  //     print("Error registering: $e");
  //   } finally {
  //     isDataLoading.value = false;
  //     isOnTapAllowd.value = true;
  //   }
  // }


  Future<void> postVideoJoinStatus(
      bool isRegister,
      int index, {
        required String liveClassId,
        bool isUpdateScreen = false,
        String? liveClassTitle,
      }) async {
    await liveProvider.postVideoJoinStatus(
      onError: (message, errorMap) {
        print("Error in postVideoJoinStatus: $message");
        Get.back(); // Close any open dialogs (assumes one is open)
      },

      onSuccess: (message, json) async {
        if (json?['status'] == true && (json?['data']?.containsKey('popup_data') ?? false)) {
          onRegisterPopUp(json);
        } else {
          if (isRegister) {
            if (index < dataPagingController.value.list.length) {
              dataPagingController.value.list[index].isLoading = false;
              dataPagingController.value.list[index].isRegister = 1;
            }
            // isOnTapAllowd.value = true;
            // isDataLoading.value = false;
            onRegisterPopUp(json);
          } else {
            Get.back();
            if (json?['data']?['participant_link'] != null && Get.context != null) {
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
        "device": Platform.isIOS ? "ios" : "android",
      },
    );
  }

  // onRegisterPopUp(json) {
  //   if (json == null || json['data'] == null || json['data']['popup_data'] == null) {
  //     return;
  //   }
  //
  //   logPrint("onRegister json value is ${json.toString()}");
  //
  //   final popupData = json['data']['popup_data'];
  //   final title = popupData['title'] ?? 'limit reached';
  //   final imageUrl = popupData['image_url'] ?? '';
  //   final description = popupData['description'] ?? 'limit';
  //   final titleColor = popupData['title_color'] ?? '#000000';
  //   final dismissButton = popupData['dismiss_button'] ?? 'default';
  //   final descriptionColor = popupData['description_color'] ?? '#000000';
  //   final dismissButtonColor = popupData['dismiss_button_color'] ?? '#000000';
  //   final dismissBtnTextColor = popupData['dismiss_btn_text_color'] ?? '#000000';
  //
  //   logPrint("Title of the popUP is $title");
  //
  //   // Show bottom sheet immediately (removed timer)
  //   Get.bottomSheet(
  //     Container(
  //       padding: const EdgeInsets.all(15),
  //       width: double.infinity,
  //       decoration: const BoxDecoration(
  //         color: Colors.white,
  //         borderRadius: BorderRadius.only(
  //           topLeft: Radius.circular(25.0),
  //           topRight: Radius.circular(25.0),
  //         ),
  //       ),
  //       child: SingleChildScrollView(
  //         child: Column(
  //           mainAxisSize: MainAxisSize.min,
  //           children: [
  //             Row(
  //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //               children: [
  //                 const SizedBox(),
  //                 IconButton(
  //                     onPressed: () {
  //                       Get.back();
  //                     },
  //                     icon: const Icon(Icons.close))
  //               ],
  //             ),
  //             if (imageUrl.isNotEmpty)
  //               Image.network(
  //                 imageUrl,
  //                 height: 100,
  //                 errorBuilder: (context, error, stackTrace) {
  //                   return const SizedBox(height: 100); // Fallback if image fails
  //                 },
  //               ),
  //             Text(
  //               title,
  //               style: TextStyle(
  //                   fontSize: 16,
  //                   fontWeight: FontWeight.w500,
  //                   color: Color(int.parse(titleColor.replaceAll('#', '0xff')))),
  //             ),
  //             Padding(
  //               padding: const EdgeInsets.symmetric(
  //                 horizontal: 8.0,
  //                 vertical: 2,
  //               ),
  //               child: Text(
  //                 description.replaceAll(RegExp(r'<[^>]*>'), ''),
  //                 textAlign: TextAlign.center,
  //                 style: TextStyle(
  //                     fontSize: 14,
  //                     color: Color(int.parse(
  //                         descriptionColor.replaceAll('#', '0xff')))),
  //               ),
  //             ),
  //             const SizedBox(height: 14),
  //             const SizedBox(height: 12),
  //             SizedBox(
  //               width: 120,
  //               height: 35,
  //               child: CommonButton(
  //                   color: Color(int.parse(
  //                       dismissButtonColor.replaceAll('#', '0xff'))),
  //                   text: dismissButton,
  //                   loading: false,
  //                   onPressed: () {
  //                     Get.back();
  //                     Get.toNamed(Routes.subscriptionView);
  //                   }),
  //             )
  //           ],
  //         ),
  //       ),
  //     ),
  //     barrierColor: Colors.black.withOpacity(0.5),
  //     isDismissible: true,
  //     shape: const RoundedRectangleBorder(
  //       borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
  //     ),
  //     enableDrag: true,
  //   );
  // }

  void onRegisterPopUp(dynamic json) {
    final popupData = json?['data']?['popup_data'];
    if (popupData == null) return;

    logPrint("onRegisterPopUp json: $json");

    final String title = popupData['title'] ?? 'Limit reached';
    final String imageUrl = popupData['image_url'] ?? '';
    final String description = popupData['description'] ?? 'Limit reached';
    final String dismissButton = popupData['dismiss_button'] ?? 'Close';

    final Color titleColor = _parseHexColor(popupData['title_color'], fallback: Colors.black);
    final Color descriptionColor = _parseHexColor(popupData['description_color'], fallback: Colors.black87);
    final Color dismissButtonColor = _parseHexColor(popupData['dismiss_button_color'], fallback: Colors.blue);
    final Color dismissBtnTextColor = _parseHexColor(popupData['dismiss_btn_text_color'], fallback: Colors.white);

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(15),
        width: double.infinity,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Get.back(),
                ),
              ),
              if (imageUrl.isNotEmpty)
                Image.network(
                  imageUrl,
                  height: 100,
                  errorBuilder: (_, __, ___) => const SizedBox(height: 100),
                ),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: titleColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                _stripHtml(description),
                style: TextStyle(
                  fontSize: 14,
                  color: descriptionColor,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: 120,
                height: 40,
                child: CommonButton(
                  color: dismissButtonColor,
                  textColor: dismissBtnTextColor,
                  text: dismissButton,
                  loading: false,
                  onPressed: () {
                    Get.back();
                    Get.toNamed(Routes.subscriptionView);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      barrierColor: Colors.black.withOpacity(0.5),
      isDismissible: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      enableDrag: true,
    );
  }

  String _stripHtml(String input) {
    return input.replaceAll(RegExp(r'<[^>]*>'), '');
  }

  Color _parseHexColor(String? hexColor, {Color fallback = Colors.black}) {
    if (hexColor == null || !hexColor.startsWith('#')) return fallback;
    try {
      return Color(int.parse(hexColor.replaceAll('#', '0xff')));
    } catch (_) {
      return fallback;
    }
  }

}