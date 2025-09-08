import 'package:confetti/confetti.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/account_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:stockpathshala_beta/model/models/account_models/language_model.dart'
as lang;
import 'package:stockpathshala_beta/model/models/home_data_model/home_data_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'dart:async';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:stockpathshala_beta/model/services/transaction_service/transaction_service.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';

import '../../../model/services/auth_service.dart';
import '../../../view/widgets/view_helpers/progress_dialog.dart';
import 'dart:convert';
import '../../../../model/models/account_models/level_model.dart';
import '../../../../model/models/home_data_model/continue_learning_model.dart'
as cont;
import '../../../../model/models/home_data_model/notification_count.dart'
as count;
import '../root_view/home_view/category_model.dart';
import '../root_view/home_view/mentor_model.dart';
import 'package:stockpathshala_beta/api_service.dart';
import './mentor_slot_model.dart';

class MentorController extends GetxController {
  final AccountProvider accountProvider = getIt();
  // final Rx<GlobalKey<AnimatedListState>> listKey =
  //     GlobalKey<AnimatedListState>().obs;
  final RxBool isDataLoading = false.obs;
  final RxBool isBuyLoading = false.obs;
  final RxBool showFlicker = false.obs;
  final HomeProvider homeProvider = getIt();
  final Rx<LevelModel> levelData = LevelModel().obs;
  final Rx<HomeDataModel> homeData = HomeDataModel().obs;
  final Rx<HomeDataModelDatum> bannerData = HomeDataModelDatum().obs;
  final Rx<cont.GetContinueData> continueData = cont.GetContinueData().obs;
  final RxList<cont.Datum> continueDataList = <cont.Datum>[].obs;
  late ConfettiController confettiController;

  final GetStorage box = GetStorage();
  final Rx<HomeDataModelDatum> trendingData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> scalpData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> liveData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> topData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> quizData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> videoCoursesData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> audioCoursesData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> textCoursesData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> videoData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> audioData = HomeDataModelDatum().obs;
  final Rx<HomeDataModelDatum> blogData = HomeDataModelDatum().obs;
  final Rx<lang.LanguageModel> languageData = lang.LanguageModel().obs;
  final Rx<count.NotificationCountModel> notificationCountData =
      count.NotificationCountModel().obs;
  final RxBool isLevelLoading = false.obs;
  final RxBool isLangLoading = false.obs;
  final RxInt currentIndex = 0.obs;
  final RxList<Widget> itemList = <Widget>[].obs;
  final RxBool onRefreshLoading = false.obs;

  /// For Notification badge, changes to false on notification route.
  /// The logic is in the view of bell button.
  final RxBool isShow = true.obs;
  final RxBool isLoading = true.obs;
  final RxMap<int, RxBool> mentorLoadingMap = <int, RxBool>{}.obs;

  final Rx<MentorData> categoriesData = MentorData(
    totalMentors: 0,
    mentors: [],
    serverTime: '',
    counsellingPrice: 0,
  ).obs;
  final RxBool isOfferDataLoading = true.obs;

  final Rx<MentorData> filteredCategoriesData1 = MentorData(
    totalMentors: 0,
    mentors: [],
    serverTime: '',
    counsellingPrice: 0,
  ).obs;

  late int mentorId;
  late String mentorTitle;
  final RxList<int> selectedChip = <int>[].obs;

  void setCurrentIndex(int index) {
    currentIndex.value = index;
  }

  // bool isLoadingFor(int mentorId) {
  //   return mentorLoadingMap[mentorId]?.value ?? false;
  // }

  void setLoadingFor(int mentorId, bool value) {
    if (!mentorLoadingMap.containsKey(mentorId)) {
      mentorLoadingMap[mentorId] = false.obs;
    }
    mentorLoadingMap[mentorId]!.value = value;
  }
  @override
  void dispose() {
    confettiController.dispose();
    super.dispose();
  }
  @override
  void onInit() {
    super.onInit();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
    confettiController = ConfettiController(duration: const Duration(seconds: 3));
    // confettiController.play();
    final arguments = Get.arguments;
    if (arguments is CounsellingCategory) {
      mentorId = arguments.id;
      mentorTitle = arguments.title;
    } else {
      mentorId = 0; // Default value or handle error
      logPrint("Warning: Invalid mentorId argument: $arguments");
    }

    logPrint("mentorId $mentorId");
    getCategories(mentorId);
    TransactionService.instance
        .initServiceEvent(onPaymentEvent: onPaymentEvent);
  }

  void onPaymentEvent({required String message, required bool status}) {
    // Implementation commented out - uncomment and implement as needed
    // if (status) {
    //   showPaymentStatusDialog(isFailed: false);
    // } else {
    //   autoApplyCoupon();
    //   showPaymentStatusDialog();
    // }
  }

  Future<void> onRefresh() async {
    onRefreshLoading.value = true;
    try {
      await Future.delayed(const Duration(seconds: 1));
      await getCategories(mentorId);
    } catch (e) {
      logPrint("Error during refresh: $e");
      toastShow(message: 'Failed to refresh data');
    } finally {
      onRefreshLoading.value = false;
    }
  }

  Future<void> onBuyCounselling(
      String? slotId,
      String? amount, {
        String orderType = "be_a_pro",
        required void Function(PaymentSuccessResponse response, String razorpayOrderId) onPaymentSuccess,
      }) async {
    // Validate inputs
    // if (slotId == null || slotId.isEmpty) {
    //   toastShow(message: 'Slot ID is required');
    //   return;
    // }

    if (amount == null || amount.isEmpty) {
      toastShow(message: 'Amount is required');
      return;
    }

    if (Platform.isIOS) {
      // Handle iOS logic here if needed
      return;
    }

    if (Get.find<AuthService>().isGuestUser.value) {
      ProgressDialog().showFlipDialog(isForPro: false);
      return;
    }

    isBuyLoading.value = true;

    try {
      final amountInRupees = (int.parse(amount) / 100).toString();

      await homeProvider.createCounsellingOrders(
        mapData: {
          "slot_id": slotId,
          "amount": amountInRupees,
        },
        onError: (message, errorMap) {
          logPrint("razorpay sp-db error: $errorMap");
          toastShow(message: message);
        },
        onSuccess: (message, json) async {
          if (json == null) {
            toastShow(message: 'Invalid response from server');
            return;
          }

          try {
            final orderSummary = json['order_summary'];
            if (orderSummary == null) {
              toastShow(message: 'Invalid order summary');
              return;
            }

            final orderAmount = ((orderSummary["amount"] as num).toDouble() * 100).toInt();
            final rzOrderId = orderSummary['rz_order_id'] as String;

            await createOrderId(
              orderAmount.toString(),
              rzOrderId,
              orderType,
              onData: (response) {
                try {
                  final authService = Get.find<AuthService>();
                  TransactionService.instance.openRazorPay(
                    optionData: {
                      "amount": orderAmount,
                      "name": authService.user.value.name ?? 'User',
                      "email": authService.user.value.email ?? '',
                      "contact": authService.user.value.mobileNo ?? '',
                      "ord_id": rzOrderId,
                    },
                    onError: (e) {
                      logPrint("razorpay openRazorPay error: $e");
                      toastShow(message: 'Payment failed. Please try again.');
                    },
                    onPaymentSuccess: (response) {
                      onPaymentSuccess.call(response, rzOrderId);
                    },
                  );
                } catch (e) {
                  logPrint("razorpay openRazorPay error: $e");
                  toastShow(message: 'Failed to open payment gateway');
                }
              },
              onError: (e) {
                logPrint("razorpay createOrderId error: $e");
                toastShow(message: e.toString());
              },
            );
          } catch (e) {
            logPrint("Error processing order response: $e");
            toastShow(message: 'Failed to process order');
          }
        },
      );
    } catch (e) {
      logPrint("Error in onBuyCounselling: $e");
      toastShow(message: 'Failed to create order. Please try again.');
    } finally {
      // Add delay to prevent UI flickering
      await Future.delayed(const Duration(seconds: 1));
      isBuyLoading.value = false;
    }
  }

  Future<void> createOrderId(
      String amount,
      String ordRefNum,
      String orderType, {
        required Function(Map<String, dynamic> result) onData,
        required Function(dynamic e) onError,
      }) async {
    try {
      final authService = Get.find<AuthService>();
      final serviceData = authService.serviceData.value.data;

      if (serviceData?.razorpayAppId == null || serviceData?.razorpayAppSecret == null) {
        onError('Razorpay credentials not found');
        return;
      }

      final auth = 'Basic ${base64Encode(utf8.encode('${serviceData!.razorpayAppId}:${serviceData.razorpayAppSecret}'))}';

      final headers = {
        'Authorization': auth,
        'Content-Type': 'application/json'
      };

      final body = {
        'amount': amount,
        'currency': 'INR',
        'receipt': 'order_trn_${DateTime.now().millisecondsSinceEpoch}',
        'payment_capture': true,
        'notes': {
          "user_id": "${authService.user.value.id}",
          "user_type": "customers",
          "t_type": "dw",
          "ord_ref_no": ordRefNum,
          "order_type": orderType
        },
      };

      final response = await http.post(
        Uri.parse(AppConstants.orderApiRazorpay),
        body: jsonEncode(body),
        headers: headers,
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        onData(jsonData);
      } else {
        onError('HTTP ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      onError('Network error: $e');
    }
  }

  Future<void> getCategories(int mentorId) async {
    try {
      isLoading(true);

      final response = await getCounsellingMentors(mentorId);

      if (response['success'] == true && response['data'] != null) {
        print('Total mentors: ${categoriesData.value.totalMentors}');
        print('Mentors count: ${categoriesData.value.mentors.length}');
      } else {
        toastShow(message: response['message'] ?? 'Failed to fetch data');
      }
    } catch (e) {
      print('Error in getCategories: $e');
      toastShow(message: 'An error occurred while fetching data');
    } finally {
      isLoading(false);
    }
  }

  Future<Map<String, dynamic>> getCounsellingMentors(int mentorId) async {
    bool isAvailable = true;
    try {
      final String url =
          '${AppConstants.instance.baseUrl}${AppConstants.instance.mentorList}?category_ids=$mentorId&is_mentor_slot_available=$isAvailable';
          // 'https://dev2.stockpathshala.com/api/v1/counselling/all-mentor?category_ids=$mentorId';
      print("getCounsellingMentors url $url");

      final response = await ApiService.get(url);

      if (response['success'] == true) {
        final data = response['data']?['data'];
        if (data != null) {
          categoriesData.value = MentorData.fromJson(data);
        }
        return {
          'success': true,
          'data': response['data'],
        };
      } else {
        return {
          'success': false,
          'data': null,
          'message': response['message'] ?? 'Unknown error',
          'statusCode': response['statusCode'] ?? 0,
        };
      }
    } on http.ClientException catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Network error: ${e.message}',
        'statusCode': 0,
      };
    } catch (e) {
      return {
        'success': false,
        'data': null,
        'message': 'Unexpected error: $e',
        'statusCode': 0,
      };
    }
  }

  Future<MentorSlotModel?> getMentorSlot(int mentorId) async {
    setLoadingFor(mentorId, true);

    final String url =
        '${AppConstants.instance.baseUrl}${AppConstants.instance.mentorSlots}?mentor_id=$mentorId';

    try {
      final response = await ApiService.get(url);

      if (response['success'] == true && response['data'] != null) {
        final data = MentorSlotModel.fromJson(response['data']);
        print("Mentor slot loaded: ${response['data']}");
        return data;
      } else {
        print("No data or response unsuccessful: $response");
        return null;
      }
    } catch (e, stack) {
      print("Error fetching mentor slot: $e");
      print("Stacktrace: $stack");
      return null;
    } finally {
      setLoadingFor(mentorId, false);
      print("Mentor slot request completed");
    }
  }

  Future<void> verifyPayment(
      PaymentSuccessResponse paymentSuccessResponse,
      String razorpayOrderId,
      Function(CounsellingPaymentResponse data) onSuccess,
      Function(String error)? onFailure,
      ) async {
    final String url =
        '${AppConstants.instance.baseUrl}${AppConstants.instance.verifyPayment}';

    final deviceToken = Get.find<AuthService>().getUserFcmToken();
    final deviceType = Platform.isIOS ? 'ios' : 'android';

    print("🔁 Starting payment verification...");
    print("🔗 URL: $url");
    print("📦 Request Body:");
    print("  - order_id: $razorpayOrderId");
    print("  - razorpay_order_id: ${paymentSuccessResponse.orderId}");
    print("  - razorpay_payment_id: ${paymentSuccessResponse.paymentId}");
    print("  - razorpay_signature: ${paymentSuccessResponse.signature}");
    print("  - device_token: $deviceToken");
    print("  - device_type: $deviceType");

    try {
      final requestBody = {
        "order_id": razorpayOrderId,
        "razorpay_order_id": paymentSuccessResponse.orderId ?? razorpayOrderId,
        "razorpay_payment_id": paymentSuccessResponse.paymentId,
        "razorpay_signature": paymentSuccessResponse.signature,
        "device_token": deviceToken,
        "device_type": deviceType,
      };
      print("📤 Request Body: $requestBody");

      await accountProvider.verifyPayment(
        body: requestBody,
        onSuccess: (String? message, Map<String, dynamic> map) {
          print("✅ Server Success: $message");
          print("🗂 Response Data: $map");

          try {
            final data = CounsellingPaymentResponse.fromJson(map);
            print("✅ Parsed Response: $data");
            onSuccess(data);
          } catch (e) {
            print("❌ Failed to parse success response: $e");
            onFailure?.call("Something went wrong while parsing response.");
          }
        },
        onError: (String? message, Map<String, dynamic>? errorMap) {
          final errorMsg = message ?? 'Payment verification failed.';
          print("❌ Server Error: $errorMsg");
          print("📛 Error Map: $errorMap");
          onFailure?.call(errorMsg);
        },
      );
    } catch (e, stack) {
      print("🚨 Exception during verifyPayment: $e");
      print("🪵 Stacktrace:\n$stack");
      onFailure?.call("Unexpected error occurred during payment verification.");
    } finally {
      print("🔚 verifyPayment finished.");
    }
  }
}

class CounsellingPaymentResponse {
  final bool status;
  final String message;
  final Counselling counselling;

  const CounsellingPaymentResponse({
    required this.status,
    required this.message,
    required this.counselling,
  });

  factory CounsellingPaymentResponse.fromJson(Map<String, dynamic> json) {
    return CounsellingPaymentResponse(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      counselling: Counselling.fromJson(json['counselling'] ?? {}),
    );
  }

  @override
  String toString() {
    return 'CounsellingPaymentResponse{status: $status, message: $message, counselling: $counselling}';
  }
}

class Counselling {
  final int id;
  final String status;

  const Counselling({
    required this.id,
    required this.status,
  });

  factory Counselling.fromJson(Map<String, dynamic> json) {
    return Counselling(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
    );
  }

  @override
  String toString() {
    return 'Counselling{id: $id, status: $status}';
  }
}