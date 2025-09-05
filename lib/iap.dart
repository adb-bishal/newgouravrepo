import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/subscription_controller/subscription_controller.dart';

import 'mentroship/controller/mentorship_detail_controller.dart';
import 'model/services/auth_service.dart';

class InAppPurchaseService {
  // List of product IDs
  static const List<String> _productIds = <String>[
    'com.stockpathshala.1month_plan',
    'com.stockpathshala.3months_plan',
    'com.stockpathshala.12months_plan',
    'com.stockpathshala.mentorship_plan_pack',
  ];

  final MentorshipDetailController service =
  Get.put(MentorshipDetailController());

  String token = Get.find<AuthService>().getUserToken();
  String orderId = '';

  // Fetch product details from the App Store
  Future<List<ProductDetails>> fetchProducts() async {
    final bool available = await InAppPurchase.instance.isAvailable();
    if (!available) {
      throw Exception('In-app purchases are not available on this device.');
    }

    final ProductDetailsResponse response =
        await InAppPurchase.instance.queryProductDetails(_productIds.toSet());
    if (response.error != null) {
      throw Exception('Error fetching products: ${response.error}');
    }

    return response.productDetails;
  }

  // Handle pending purchases
  // Future<void> checkAndHandlePendingPurchases(String productId) async {
  //   print('Checking for pending purchases for product: $productId');
  //
  //   try {
  //     InAppPurchase.instance.purchaseStream.listen(
  //         (List<PurchaseDetails> purchases) {
  //       for (var purchase in purchases) {
  //         if (purchase.productID == productId &&
  //             purchase.status == PurchaseStatus.purchased) {
  //           String receipt = purchase.verificationData.serverVerificationData;
  //
  //           print('Receipt1: $receipt');
  //
  //           sendReceiptToServer(
  //               token, receipt, Platform.isIOS ? "ios" : "android", productId);
  //           InAppPurchase.instance.completePurchase(purchase);
  //
  //         }
  //         if (purchase.productID == productId &&
  //             purchase.status == PurchaseStatus.pending) {
  //           InAppPurchase.instance.completePurchase(purchase);
  //         }if (purchase.productID == productId &&
  //             purchase.status == PurchaseStatus.error) {
  //           InAppPurchase.instance.completePurchase(purchase);
  //         }if (purchase.productID == productId &&
  //             purchase.status == PurchaseStatus.canceled) {
  //           InAppPurchase.instance.completePurchase(purchase);
  //         } else {
  //           print(
  //               'No pending purchase found for $productId, or status is not pending.');
  //         }
  //       }
  //     }, onError: (error) {
  //       print('Error while checking purchases: $error');
  //     });
  //   } catch (e) {
  //     print('Error in checkAndHandlePendingPurchases: $e');
  //   }
  // }

  Future<void> checkAndHandlePendingPurchases(String productId) async {
    print('Checking for pending purchases for product: $productId');

    try {
      // Listen to the purchase stream
      InAppPurchase.instance.purchaseStream.listen(
        (List<PurchaseDetails> purchases) {
          final purchase = purchases.firstWhere(
            (purchase) => purchase.productID == productId,
            // orElse: () => null,
          );

          if (purchase != null) {
            switch (purchase.status) {
              case PurchaseStatus.purchased:
                handlePurchasedStatus(purchase, productId);
                break;

              case PurchaseStatus.pending:
                handlePendingStatus(purchase, productId);
                break;

              case PurchaseStatus.error:
                handleErrorStatus(purchase, productId);
                break;

              case PurchaseStatus.canceled:
                handleCanceledStatus(purchase, productId);
                break;

              default:
                print(
                    'No relevant purchase status found for product: $productId');
            }
          } else {
            print('No pending purchase found for $productId.');
          }
        },
        onError: (error) {
          print('Error while checking purchases: $error');
        },
      );
    } catch (e) {
      print('Error in checkAndHandlePendingPurchases: $e');
    }
  }

  void handlePurchasedStatus(PurchaseDetails purchase, String productId) {
    final String receipt = purchase.verificationData.serverVerificationData;
    print('Receipt: $receipt');

    // Send receipt to server
    sendReceiptToServer(
        token, receipt, Platform.isIOS ? "ios" : "android", productId);

    // Complete the purchase
    InAppPurchase.instance.completePurchase(purchase);
  }

  void handlePendingStatus(PurchaseDetails purchase, String productId) {
    print('Purchase is pending for product: $productId');
    _showToast("Purchase pending...", ColorResource.primaryColor);
    InAppPurchase.instance.completePurchase(purchase);
  }

  void handleErrorStatus(PurchaseDetails purchase, String productId) {
    print('Error in purchase for product: $productId');
    _showToast("Purchase error: ${purchase.error}", Colors.redAccent);

    InAppPurchase.instance.completePurchase(purchase);
  }

  void handleCanceledStatus(PurchaseDetails purchase, String productId) {
    print('Purchase was canceled for product: $productId');
    InAppPurchase.instance.completePurchase(purchase);
  }

  void _showToast(String message, Color color) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: color,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  Future<void> saveOrderIdToPrefs(String orderId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('orderId', orderId);
    print('Order ID saved to SharedPreferences: $orderId');
  }

// Retrieve the orderId from SharedPreferences
  Future<String?> getOrderIdFromPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    final orderId = prefs.getString('orderId');
    print('Order ID retrieved from SharedPreferences: $orderId');
    return orderId;
  }

  Future<void> initiatePurchase(String token, String productId) async {
    SharedPreferences mentorId = await SharedPreferences.getInstance();
    String mentorIdValue = mentorId.getString('mId') ?? '';
    const String url =
        'https://internal.stockpathshala.in/api/v1/app-store-iap/initiate';

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'product_id': productId,
      'mentorship_id': mentorIdValue,
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        orderId = data['data']['order_id'].toString(); // Set the orderId
        print('Order ID set to: $orderId');

        // Save the orderId in SharedPreferences
        await saveOrderIdToPrefs(orderId);
      } else {
        print('Failed to initiate purchase. Status: ${response.statusCode}');
        print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error occurred during initiatePurchase: $e');
    }
  }

  Future<void> sendReceiptToServer(
      String token, String receipt, String deviceType, String productId) async {
    SharedPreferences mentorId = await SharedPreferences.getInstance();
    String mentorIdValue = mentorId.getString('mId') ?? '';
    final url = Uri.parse(
        'https://internal.stockpathshala.in/api/v1/app-store-iap/paid');

    // Retrieve the orderId from SharedPreferences
    final storedOrderId = await getOrderIdFromPrefs();
    if (storedOrderId == null) {
      print('No order ID found in SharedPreferences. Cannot send receipt.');
      return;
    }

    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    final body = jsonEncode({
      'receipt': receipt,
      'device_type': deviceType,
      'order_id': storedOrderId, // Use the retrieved orderId
      'product_id': productId, // Use the retrieved orderId
      'mentorship_id': mentorIdValue,

    });

    print('sdsdc $body');

    try {
      final response = await http.post(url, headers: headers, body: body);

      if (response.statusCode == 200) {
        print('Successfully sent receipt to server.');
        _showToast("Purchase successful", Colors.green);
        service.fetchMentorshipData(mentorIdValue);
        Get.find<SubscriptionController>().onInit();


        Get.find<RootViewController>().getProfile();
      } else {
        print('Failed to send receipt. Status Code: ${response.statusCode}');
        // print('Response: ${response.body}');
      }
    } catch (e) {
      print('Error occurred during sendReceiptToServer: $e');
    }
  }

  // Future<void> initiatePurchase(String token, String productId) async {
  //   // Define the API URL
  //   const String url = 'https://internal.stockpathshala.in/api/v1/app-store-iap/initiate';
  //
  //   // Define the headers
  //   final headers = {
  //     'Authorization': 'Bearer $token',
  //     'Content-Type': 'application/json',
  //   };
  //
  //   // Define the body
  //   final body = jsonEncode({
  //     'product_id': productId,
  //   });
  //
  //   try {
  //     // Send the POST request
  //     final response = await http.post(
  //       Uri.parse(url),
  //       headers: headers,
  //       body: body,
  //     );
  //
  //     // Check the response status
  //     if (response.statusCode == 200) {
  //       // Parse the response
  //       final data = jsonDecode(response.body);
  //
  //        orderId = data['data']['order_id'].toString();
  //       print('sdcsdc $orderId');
  //
  //       print('Purchase initiated successfully: $data');
  //     } else {
  //       print('Failed to initiate purchase. Status: ${response.statusCode}');
  //       print('Response: ${response.body}');
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e');
  //   }
  // }
  //
  //
  // Future<void> sendReceiptToServer(
  //     String token, String receipt, String deviceType)
  // async {
  //   final url = Uri.parse(
  //       'https://internal.stockpathshala.in/api/v1/app-store-iap/paid');
  //
  //   print('sfvsdv ${orderId}');
  //   // Prepare the headers
  //   Map<String, String> headers = {
  //     'Authorization': 'Bearer $token', // Token in the Authorization header
  //     'Content-Type': 'application/json', // Sending data in JSON format
  //   };
  //
  //   // Prepare the body
  //   Map<String, String> body = {
  //     'receipt': receipt, // Receipt data
  //     'device_type': deviceType, // Device type (e.g., 'iOS', 'Android')
  //     'order_id': orderId, // Device type (e.g., 'iOS', 'Android')
  //   };
  //
  //   try {
  //     // Send the POST request
  //     final response =
  //         await http.post(url, headers: headers, body: json.encode(body));
  //
  //     // Handle the response
  //     if (response.statusCode == 200) {
  //       print('Successfully sent data to the server');
  //       Get.find<RootViewController>().getProfile();
  //       // Optionally, parse the response body if necessary
  //       // var responseData = json.decode(response.body);
  //     } else {
  //       print('Failed to send data. Status Code: ${response.statusCode}');
  //       // Handle error based on response
  //     }
  //   } catch (e) {
  //     print('Error occurred: $e');
  //   }
  // }

  // Purchase a product (for consumable products)
  Future<void> purchaseProduct(ProductDetails product) async {
    initiatePurchase(token, product.id);

    print('Initiating purchase for product: ${product.id}');

    try {
      // Check and handle pending purchases before initiating a new one
      print('Calling checkAndHandlePendingPurchases...');
      await checkAndHandlePendingPurchases(product.id);
      print('Pending purchases handled.');

      // Initiate a new purchase
      final PurchaseParam purchaseParam =
          PurchaseParam(productDetails: product);
      print('Attempting to buy consumable product: ${product.id}');
      await InAppPurchase.instance.buyConsumable(purchaseParam: purchaseParam);
      print('Purchase initiated for product: ${product.id}');
    } catch (e) {
      // Fluttertoast.showToast(
      //     msg: "You have already purchased this plan.",
      //     toastLength: Toast.LENGTH_SHORT);
      print('Error during purchase: $e');
    }
  }

  // Listen to purchase updates
  void listenToPurchases(
      void Function(PurchaseDetails purchaseDetails) onPurchaseUpdated) {
    InAppPurchase.instance.purchaseStream
        .listen((List<PurchaseDetails> purchases) {
      for (var purchase in purchases) {
        onPurchaseUpdated(purchase);
      }
    });
  }

  // Restore purchases (only useful for non-consumables)
  Future<void> restorePurchases() async {
    print('efvedvcde');
    await InAppPurchase.instance.restorePurchases();
  }
}
