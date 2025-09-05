import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../auth_service.dart';
import 'dart:async';
import 'dart:io';
import 'package:better_player/better_player.dart' as better;
import 'package:better_player/src/video_player/video_player_platform_interface.dart'
as video_event;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:screen_protector/screen_protector.dart';
import 'package:stockpathshala_beta/model/services/player/widgets/custom_controls_widget.dart';
import 'package:stockpathshala_beta/service/video_hls_player/video_view.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:video_player/video_player.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:wakelock_plus/wakelock_plus.dart';
import '../../../service/page_manager.dart';
import '../../network_calls/dio_client/get_it_instance.dart';
import '../../utils/color_resource.dart';

class TransactionService {
  static TransactionService? _instance;
  static TransactionService get instance =>
      _instance ??= TransactionService._init();
  TransactionService._init();

  Function()? onSuccess;

  late Razorpay razorpay;

  // Optional detailed success callback
  Function(PaymentSuccessResponse response)? _onPaymentSuccess;

  late Function({required String message, required bool status})
  _onMessageReceiveFunction;

  Future<void> initServiceEvent({
    required Function({required String message, required bool status})
    onPaymentEvent,
  }) async {
    razorpay = Razorpay();
    _onMessageReceiveFunction = onPaymentEvent;
    _onPaymentSuccess = null; // Clear detailed callback here

    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
      _handlePaymentError;
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentFailureResponse response) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
      _handlePaymentSuccess;

    });
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (PaymentFailureResponse response) {
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
      _handleExternalWallet;

    });
  }

  Future<void> initServiceEventForMentor({
    required Function({required String message, required bool status})
    onPaymentEvent,
    Function(PaymentSuccessResponse response)? onPaymentSuccess,
  }) async {
    razorpay = Razorpay();
    _onMessageReceiveFunction = onPaymentEvent;
    _onPaymentSuccess = onPaymentSuccess;

    // razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, (PaymentFailureResponse response) {
      // restore only status bar
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
      _handlePaymentError;
    });
    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, (PaymentFailureResponse response) {
      // restore only status bar
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
      _handlePaymentSuccess;
    });
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, (PaymentFailureResponse response) {
      // // restore only status bar
      SystemChrome.setEnabledSystemUIMode(
        SystemUiMode.manual,
        overlays: [SystemUiOverlay.top],
      );
      _handleExternalWallet;
    });
    // razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }
  void openRazorPay({
    required Map<String, dynamic> optionData,
    required Function(dynamic error) onError,
    Function()? onSuccess,
    Function(PaymentSuccessResponse response)? onPaymentSuccess,
  }) {
    this.onSuccess = onSuccess;
    _onPaymentSuccess = onPaymentSuccess;

    var options = {
      'key': Get.find<AuthService>().serviceData.value.data?.razorpayAppId ?? '',
      'amount': optionData["amount"],
      'name': "Stock Pathshala",
      'description': 'To become a pro',
      'order': {
        "id": '${optionData['ord_id']}',
        "entity": "order",
        "amount": optionData["amount"],
        "amount_paid": optionData["amount"],
        "amount_due": 0,
        "currency": "INR",
        "receipt": "Receipt #20",
        "status": "created",
        "attempts": 0,
        "notes": {"key1": "value1", "key2": "value2"},
        "created_at": DateTime.now().millisecondsSinceEpoch,
      },
      'order_id': '${optionData['ord_id']}',
      'prefill': {
        'contact': optionData['contact'] ?? '',
        'email': optionData['email'] ?? '',
        "ord_ref_no": optionData['ord_ref_no'] ?? '',
        "order_type": optionData['order_type'] ?? '',
      },
      "theme": {"color": "#8276F4"},
    };

    try {
      razorpay.open(options);
    } catch (e) {
      logPrint('Razorpay open error: $e');
      onError(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    logPrint('Payment Success: paymentId=${response.paymentId}, orderId=${response.orderId}, signature=${response.signature}');

    // Call detailed callback if set
    _onPaymentSuccess?.call(response);

    // Call generic message callback
    _onMessageReceiveFunction(message: "Payment successful: ${response.paymentId}", status: true);

    onSuccess?.call();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    logPrint("Payment Error: ${response.message}");
    _onMessageReceiveFunction(message: response.message ?? "Payment failed", status: false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    logPrint("External wallet selected: ${response.walletName}");
    _onMessageReceiveFunction(message: "External wallet selected: ${response.walletName}", status: false);
  }

  void sendMessage({String? message, String? fileType, String? fileName}) {
    // Your implementation if needed
  }

  void onDisconnect() {
    razorpay.clear();
  }
}
