import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

import '../auth_service.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

class TransactionService {
  static TransactionService? _instance;
  static TransactionService get instance =>
      _instance ??= TransactionService._init();
  TransactionService._init();

  late Razorpay razorpay;

  /// Called on successful payment
  Function()? onSuccess;

  /// Called with payment response if set
  Function(PaymentSuccessResponse response)? _onPaymentSuccess;

  /// Called for any message/status
  late Function({required String message, required bool status})
  _onMessageReceiveFunction;

  /// Init event for regular users
  Future<void> initServiceEvent({
    required Function({required String message, required bool status})
    onPaymentEvent,
  }) async {
    razorpay = Razorpay();
    _onMessageReceiveFunction = onPaymentEvent;
    _onPaymentSuccess = null;

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  /// Init event for mentor-specific payments
  Future<void> initServiceEventForMentor({
    required Function({required String message, required bool status})
    onPaymentEvent,
    Function(PaymentSuccessResponse response)? onPaymentSuccess,
  }) async {
    razorpay = Razorpay();
    _onMessageReceiveFunction = onPaymentEvent;
    _onPaymentSuccess = onPaymentSuccess;

    razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void openRazorPay({
    required Map<String, dynamic> optionData,
    required Function(dynamic error) onError,
    Function()? onSuccess,
    Function(PaymentSuccessResponse response)? onPaymentSuccess,
  }) {
    this.onSuccess = onSuccess;
    _onPaymentSuccess = onPaymentSuccess;

    final authService = Get.find<AuthService>();
    final razorpayKey = authService.serviceData.value.data?.razorpayAppId ?? '';

    var options = {
      'key': razorpayKey,
      'amount': optionData["amount"],
      'name': "Stock Pathshala",
      'description': 'To become a pro',
      'order_id': '${optionData['ord_id']}',
      'prefill': {
        'contact': optionData['contact'] ?? '',
        'email': optionData['email'] ?? '',
        'ord_ref_no': optionData['ord_ref_no'] ?? '',
        'order_type': optionData['order_type'] ?? '',
      },
      'theme': {"color": "#8276F4"},
    };

    try {
      razorpay.open(options);
    } catch (e) {
      logPrint('Razorpay open error: $e');
      onError(e);
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );

    logPrint(
        'Payment Success: paymentId=${response.paymentId}, orderId=${response.orderId}, signature=${response.signature}');

    _onPaymentSuccess?.call(response);
    _onMessageReceiveFunction(
        message: "Payment successful: ${response.paymentId}", status: true);
    onSuccess?.call();
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );

    logPrint("Payment Error: ${response.message}");
    _onMessageReceiveFunction(
        message: response.message ?? "Payment failed", status: false);
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.manual,
      overlays: [SystemUiOverlay.top],
    );

    logPrint("External wallet selected: ${response.walletName}");
    _onMessageReceiveFunction(
        message: "External wallet selected: ${response.walletName}",
        status: false);
  }

  void onDisconnect() {
    razorpay.clear();
  }
}
