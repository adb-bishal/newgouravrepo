import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';

import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class HomeRepo {
  final DioClient dioClient;
  final DioClient dioClientTwo;

  HomeRepo({
    required this.dioClient,
    required this.dioClientTwo,
  });

  Future<ApiResponse> getHomeData({String? levelId}) async {
    String url = "${AppConstants.instance.homeData}$levelId";
    print('swefsef $url');
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }
//
  Future<ApiResponse> getCounselling(dynamic categoryId,
dynamic isAvailable,) async {
    String url =  '${AppConstants.instance.baseUrl}${AppConstants.instance.mentorList}?category_ids=$categoryId&is_mentor_slot_available=$isAvailable';
    print('swefsef $url');
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }
  Future<ApiResponse> getFeedbackClose(dynamic userId) async {
    String url =  '${AppConstants.instance.baseUrl}${AppConstants.instance.skipApi}?user_id=$userId';
    print('swefsef $url');
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getQuestions() async {
    String url =  '${AppConstants.instance.baseUrl}${AppConstants.instance.questionList}';
    print('swefsef $url');
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }



  Future<ApiResponse> getContinueLearning() async {
    String url =
        "${AppConstants.instance.continueLearning}?limit=10&pages=1&status=0";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getSubscriptionPlan() async {
    String url = AppConstants.instance.subscriptionPlan;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getSubscribedPlan() async {
    String url = AppConstants.instance.subscribedPlan;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getSubscriptionDescription() async {
    String url = AppConstants.instance.subscriptionDescription;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getSpecialSubscriptionOffer() async {
    String url = AppConstants.instance.specialOffer;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getOfferBanner() async {
    String url = AppConstants.instance.offerBanner;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getOfferData({int? pageNo}) async {
    String url = AppConstants.instance.offerCode + pageNo.toString();
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> onApplyCoupon(
      {int? pageNo, required Map<String, dynamic> mapData}) async {
    String url = AppConstants.instance.applyCode;
    return dioClient.postResponse(
        url: url, dioClient: dioClient, data: mapData);
  }

  Future<ApiResponse> onBuyPackage(
      {int? pageNo, required Map<String, dynamic> mapData}) async {
    String url = AppConstants.instance.buyPackage;
    return dioClient.postResponse(
        url: url, dioClient: dioClient, data: mapData);
  }
  Future<ApiResponse> createCounsellingOrder(
      {int? pageNo, required Map<String, dynamic> mapData}) async {
    String url = AppConstants.instance.createCounsellingOrder;
    return dioClient.postResponse(
        url: url, dioClient: dioClient, data: mapData);
  }

  Future<ApiResponse> onBuyMentorship(
      {int? pageNo, required Map<String, dynamic> mapData}) async {
    String url = AppConstants.instance.buyMentorship;
    return dioClient.postResponse(
        url: url, dioClient: dioClient, data: mapData);
  }

  Future<ApiResponse> onPaymentConfirmation(
      {required Map<String, dynamic> mapData}) async {
    String url = AppConstants.instance.webHookUrl;
    Map<String, dynamic> data = {
      "entity": "event",
      "account_id": "acc_8p17sbhu23CQgV",
      "event": "order.paid",
      "contains": ["payment", "order"],
      "payload": {
        "payment": {
          "entity": {
            "id": "pay_LXhYgj3zdLgPnm",
            "entity": "payment",
            "amount": mapData['amount'],
            "currency": "INR",
            "status": "captured",
            "order_id": mapData['order_id'],
            "invoice_id": null,
            "international": true,
            "method": "card",
            "amount_refunded": 0,
            "refund_status": null,
            "captured": true,
            "description": "To become a pro",
            "card_id": "card_LXhYgmUAoyX55y",
            "card": {
              "id": "card_LXhYgmUAoyX55y",
              "entity": "card",
              "name": "cggg",
              "last4": "4242",
              "network": "Visa",
              "type": "credit",
              "issuer": null,
              "international": true,
              "emi": false,
              "sub_type": "consumer",
              "token_iin": null
            },
            "bank": null,
            "wallet": null,
            "vpa": null,
            "email": Get.find<AuthService>().user.value.email ?? "",
            "contact": Get.find<AuthService>().user.value.mobileNo ?? "",
            "notes": {
              "user_id": "${Get.find<AuthService>().user.value.id ?? ""}",
              "user_type": "customers",
              "t_type": "dw",
              "ord_ref_no": mapData['order_ref_no'],
              "order_type": mapData['order_type']
            },
            "fee": 1350,
            "tax": 0,
            "error_code": null,
            "error_description": null,
            "error_source": null,
            "error_step": null,
            "error_reason": null,
            "acquirer_data": {"auth_code": "233872"},
            "created_at": DateTime.now().millisecondsSinceEpoch
          }
        },
        "order": {
          "entity": {
            "id": mapData['order_id'],
            "entity": "order",
            "amount": mapData['amount'],
            "amount_paid": mapData["amount"],
            "amount_due": 0,
            "currency": "INR",
            "receipt": "order_trn_316",
            "offer_id": null,
            "status": "paid",
            "attempts": 1,
            "notes": {
              "user_id": "${Get.find<AuthService>().user.value.id ?? ""}",
              "user_type": "customers",
              "t_type": "dw",
              "ord_ref_no": mapData['order_ref_no'],
              "order_type": mapData['order_type']
            },
            "created_at": DateTime.now().millisecondsSinceEpoch
          }
        }
      },
      "created_at": DateTime.now().millisecondsSinceEpoch
    };
    return dioClient.postResponse(url: url, dioClient: dioClient, data: data);
  }
}
