import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:carousel_slider/carousel_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockpathshala_beta/mentroship/controller/mentorship_detail_controller.dart';
import 'package:stockpathshala_beta/model/models/subscription_models/subscribed_plan.dart';
import 'package:stockpathshala_beta/model/models/subscription_models/subscription_description.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/home_provider.dart';
import 'package:stockpathshala_beta/model/services/transaction_service/transaction_service.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../enum/enum.dart';
import '../../../iap.dart';
import '../../../model/models/promocode_model/offer_applied_model.dart';
import '../../../model/models/subscription_models/offer_banner_model.dart';
import '../../../model/models/subscription_models/offer_code_model.dart'
    as offer;
import '../../../model/models/subscription_models/special_promo_model.dart';
import '../../../model/models/subscription_models/subscription_plan_model.dart'
    as plan;
import '../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../model/services/auth_service.dart';
import '../../../model/services/pagination.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../view/widgets/button_view/animated_box.dart';
import '../../../view/widgets/log_print/log_print_condition.dart';
import '../../../view/widgets/popup_view/my_dialog.dart';
import '../../../view/widgets/view_helpers/progress_dialog.dart';

class SubscriptionController extends GetxController {
  HomeProvider homeProvider = getIt();
  Rx<plan.Datum> selectedSubscription = plan.Datum().obs;
  Rx<CarouselSliderController> carouselController =
      CarouselSliderController().obs;
  RxBool isOfferDataLoading = true.obs;
  RxInt currentCarasouelIndex = 0.obs;
  RxBool isDataLoading = true.obs;
  RxBool isMentorDataLoading = false.obs;
  RxBool isPromoCodeLoading = false.obs;
  RxBool isBuyLoading = false.obs;
  Rx<TextEditingController> offerController = TextEditingController().obs;
  Rx<plan.SubscriptionTypeModel> subscriptionPlanData =
      plan.SubscriptionTypeModel().obs;
  Rx<SubscriptionDescriptionModel> subscriptionDescriptionData =
      SubscriptionDescriptionModel(description: []).obs;
  late RxList<RxList> descriptionPoints;
  Rx<SubscribedPlan> subscribedPlanData = SubscribedPlan().obs;
  Rx<OfferBannerModel> offerBannerData = OfferBannerModel().obs;
  Rx<SpecialOfferModel> specialOfferData = SpecialOfferModel().obs;
  Rx<offer.Datum> selectedOffer = offer.Datum().obs;
  Rx<offer.OfferCodeModel> offerData = offer.OfferCodeModel().obs;
  late Rx<PagingScrollController<offer.Datum>> dataPagingController;
  RxString afterOfferPrice = "".obs;
  RxInt currentIndex = 0.obs;
  var appliedOffer = ApplyOfferModel().obs;
  final MentorshipDetailController service =
      Get.put(MentorshipDetailController());
  //Rx<ApplyOfferModel> appliedOffer = ApplyOfferModel().obs;
  RxBool isOfferControllerHasValue = false.obs;
  RxInt countValue = 0.obs;

  RxBool isMentor = false.obs;

  TooltipController toolTipcontroller = TooltipController();

  Duration defDuration = const Duration(milliseconds: 150);
  RxBool isExpanded = false.obs;
  RxBool isPurchase = false.obs;
  RxInt selectedSubBatch = 0.obs;
  RxBool autoFocus = false.obs;
  final MentorshipDetailController mentorshipDetailController =
      Get.put(MentorshipDetailController());

  int? batchId;
  int? batchDateId;
  final InAppPurchaseService iapService = InAppPurchaseService();

  List<ProductDetails> productsList = [];

  //  Mentorship variables
  var afterOfferMentorshipPrice = '0'.obs;
  RxString tempMentorshipCouponCode = "".obs;
  RxString tempMentorshipCouponID = "".obs;
  RxBool isMentorValueShow = false.obs;

  //offer countdown
  var offerCountdown = ''.obs;
  Timer? _countdownTimer; // Store the Timer at the class level

  //offer countdown bool
  RxBool isPromocodeCountdown = false.obs;

  @override
  void onInit() async {
    final arguments = Get.arguments;
    isMentor.value = arguments?['isMentorShow'] ?? false;
    print("sdfsdf ${isMentor}");
    _loadProducts();
    dataPagingController = PagingScrollController<offer.Datum>(
        onLoadMore: (int page, int totalItemsCount) async {
      await getOfferData(page);
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;

    await getSubscriptionPlan();

    if (isMentor.value == true) {
      print("ghjf");
      //onAvailNow(mapData: Get.arguments);
    } else {
      print('dfgvdf');
      if (Get.arguments != null) {
        if (Get.arguments is List) {
          batchId = Get.arguments[0];
          batchDateId = Get.arguments[1];
        } else {
          onAvailNow(mapData: Get.arguments);
        }
      }
    }

    // logPrint(Get.find<AuthService>().user.value.name);

    // await getSpecialSubscriptionOffer();
    // await getOfferBanner();
    // await getOfferData(1);

    offerController.value.addListener(offerControllerListener);
    TransactionService.instance
        .initServiceEvent(onPaymentEvent: onPaymentEvent);
    selectedSubBatch.value =
        batchDateId ?? selectedSubscription.value.subBatch?.first.id ?? 0;

    super.onInit();
    showTooltip();
  }

  Future<void> _loadProducts() async {
    try {
      final products = await iapService.fetchProducts();

      productsList = products;
    } catch (e) {
      print('Error loading products: $e');
    }
  }

  void _onPurchaseUpdated(PurchaseDetails purchaseDetails) {
    if (purchaseDetails.status == PurchaseStatus.purchased) {
      // Handle successful purchase

      print('Purchase successful: ${purchaseDetails.productID}');
    } else if (purchaseDetails.status == PurchaseStatus.error) {
      // Handle purchase error

      print('Purchase error: ${purchaseDetails.error}');
    }
  }

  updateText(bool newText) {
    isMentor.value = newText;
    print("fsdf  Mentor ${isMentor.value}");
  }

  // void autoApplyCoupon() {
  //   if (Platform.isAndroid) {
  //     if (dataPagingController.value.list.isNotEmpty) {
  //       var data = offerData.value.specialSalePromo?.first;
  //       // if (appliedOffer.value.data?.id != data!.id) {
  //       //   selectedOffer.value = data;

  //       offerController.value.text = data!.code ?? "";

  //       if (offerData.value.specialSalePromo?.first?.expiredAt != null) {
  //         print("knjdfkjasnf");
  //         updateCountdown(offerData.value.specialSalePromo!.first
  //             .expiredAt); // Use `!` to assert it's non-null
  //       }
  //       print('sdfsdvcf ${data.code}');
  //       if (isMentor == true) {
  //         print("lkjhg Apply Mentor ${isMentor.value}");
  //         onApplyMentorShipCoupon();
  //       } else {
  //         print("lkjhg Apply  ${isMentor.value}");
  //         onApplyCoupon();
  //       }
  //     }
  //   }
  // }

  void autoApplyCoupon() {
    if (dataPagingController.value.list.isNotEmpty) {
      var data = dataPagingController.value.list.first;
      if (appliedOffer.value.data?.id != data.id) {
        selectedOffer.value = data;

        offerController.value.text = data.code ?? "";
        print('sdfsdvcf ${data.code}');
        if (isMentor == true) {
          print("lkjhg Apply Mentor ${isMentor.value}");
          onApplyMentorShipCoupon();
        } else {
          print("lkjhg Apply  ${isMentor.value}");
          onApplyCoupon();
        }
      }
    }
  }

  void showTooltip() async {
    final toolTipList = await Get.find<AuthService>().getTrainingTooltips();
    if (!toolTipList.contains('applyCoupon')) {
      toolTipcontroller.setStartWhen(
          (initializedWidgetLength) async => initializedWidgetLength == 1);
    }
  }

  onPaymentEvent({required String message, required bool status}) {
    if (status) {
      //Get.find<RootViewController>().getProfile();
      //toastShow(message: "Congratulation! Now you are a PRO",error: false);
      showPaymentStatusDialog(isFailed: false);
    } else {
      //toastShow(message: message);
      autoApplyCoupon();

      showPaymentStatusDialog();
    }
  }

  showPaymentStatusDialog({bool isFailed = true}) {
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
            child: Obx(() {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    isFailed
                        ? isBuyLoading.value
                            ? ""
                            : ImageResource.instance.paymentFailed
                        : Get.find<AuthService>().isPro.value
                            ? ImageResource.instance.paymentSuccess
                            : ImageResource.instance.paymentProcessing,
                    height: isFailed || Get.find<AuthService>().isPro.value
                        ? 150
                        : 180,
                  ),
                  // Visibility(
                  //     visible:  isFailed ||Get.find<AuthService>().isPro.value,
                  //     child: Text(isFailed ?StringResource.paymentFail : StringResource.paymentSuccess,style: StyleResource.instance.styleMedium(),textAlign: TextAlign.center,)),
                  Text(
                    isFailed
                        ? StringResource.failPayment
                        : Get.find<AuthService>().isPro.value
                            ? StringResource.successPayment
                            : StringResource.confirmPayment,
                    style: StyleResource.instance.styleMedium(),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: DimensionResource.marginSizeSmall),
                    child: TextButton(
                        onPressed: () {
                          isOfferDataLoading.value = false;
                          Get.back();
                        },
                        child: Text(
                          StringResource.goBack,
                          style: StyleResource.instance
                              .styleSemiBold(color: ColorResource.primaryColor),
                        )),
                  )
                ],
              );
            }),
          ),
        ),
        dismissible: false,
        isFlip: true);
  }

  offerControllerListener() {
    if (offerController.value.text.isEmpty) {
      isOfferControllerHasValue.value = false;
    } else {
      isOfferControllerHasValue.value = true;
    }
  }

  onRemoveCoupon() {
    selectedOffer.value = offer.Datum();
    appliedOffer.value = ApplyOfferModel();
    afterOfferPrice.value = "";
    print("offer code is ::: before ${offerController.value.text}");
    offerController.value.text = "";

    print("offer code is ::: ${offerController.value.text}");
    afterOfferMentorshipPrice.value = "";
    tempMentorshipCouponID.value = "";
    tempMentorshipCouponCode.value = "";
    selectedOffer.value.code = "";
    isPromocodeCountdown.value = false;
    selectedOffer.value.id = 0;
  }

  onAvailNow({Map<String, dynamic> mapData = const {}}) async {
    selectedOffer.value = offer.Datum.fromJson(mapData);
    print("selectedOffer is : ${selectedOffer.value}");
    offerController.value.text = selectedOffer.value.code ?? "";
    print("selectedOffer is : ${offerController.value.text}");
    isPromoCodeLoading.value = true;

    //Future.delayed(const Duration(seconds: 2), () {
    if (isMentor == true) {
      onApplyMentorShipCoupon();
    } else {
      onApplyCoupon();
    }
    //});
  }

  onApplyCoupon() async {
    print("onApplyCoupon started");
    // if (!Get.find<AuthService>().isGuestUser.value) {
    if (selectedSubscription.value.id != null &&
        offerController.value.text.isNotEmpty) {
      // String msg = "";
      // bool isError = false;
      // isOfferDataLoading.value = true;

      isPromoCodeLoading.value = true;
      isOfferControllerHasValue.value = true;
      await homeProvider.onApplyCoupon(
          mapData: {
            "promo_code": offerController.value.text,
            "promo_code_id": selectedOffer.value.id,
            "amount": selectedSubscription.value.price
          },
          onError: (message, errorMap) {
            int index = subscriptionPlanData.value.data?.indexWhere(
                    (element) => element == selectedSubscription.value) ??
                0;
            if (index < (subscriptionPlanData.value.data?.length ?? 0) - 1) {
              selectedSubscription.value =
                  subscriptionPlanData.value.data?[index + 1] ?? plan.Datum();
              onApplyCoupon();
              return;
            }
            toastShow(message: message, error: true);
            isPromoCodeLoading.value = false;
          },
          onSuccess: (message, json) {
            isOfferDataLoading.value = false;
            print("json is ${json}");

            appliedOffer.value = ApplyOfferModel.fromJson(json!);
            if (appliedOffer.value.data == null) {
              print("appliedOffer value is ${appliedOffer.value.data?.id}");
              toastShow(message: message, error: false);
            } else {
              print("hgfhjg");

              afterOfferPrice.value =
                  appliedOffer.value.data?.discountedAmount ?? "";
              toastShow(message: message);
            }
            updateCountdown(appliedOffer.value.data!.expiredAt);
            isPromoCodeLoading.value = false;
          });

      isOfferDataLoading.value = false;
    } else {
      toastShow(
          message: offerController.value.text.isEmpty
              ? StringResource.enterOfferCode
              : StringResource.selectASubscription);
      isPromoCodeLoading.value = false;
    }
  }

  onApplyMentorShipCoupon() async {
    print("onApplyMentorShipCoupon started");
    print("selectedOffer is : ${selectedOffer.value}");

    print("offer : ${offerController.value.text}");

    if (mentorshipDetailController.mentorshipDetailData.value?.price != null) {
      print("started:");
      isPromoCodeLoading.value = true;
      isOfferControllerHasValue.value = true;

      await homeProvider.onApplyCoupon(
        mapData: {
          "promo_code": offerController.value.text,
          "promo_code_id": selectedOffer.value.id,
          "amount":
              mentorshipDetailController.mentorshipDetailData.value?.price,
          "mentorship_id":
              mentorshipDetailController.mentorshipDetailData.value?.id,
        },
        onError: (message, errorMap) {
          print("Error occurred: $message");
          // If no further plans are available, show the error message
          toastShow(message: message, error: true);
          // Reset loading indicators
          isPromoCodeLoading.value = false;
          isOfferDataLoading.value = false;
        },
        onSuccess: (message, json) {
          isOfferDataLoading.value = false;
          print("json is $json");

          appliedOffer.value = ApplyOfferModel.fromJson(json!);
          if (appliedOffer.value.data == null) {
            print("No data in appliedOffer: ${appliedOffer.value.data?.id}");
            toastShow(message: message, error: false);
          } else {
            print("Offer applied successfully");
            afterOfferMentorshipPrice.value =
                appliedOffer.value.data!.discountedAmount.toString();
            tempMentorshipCouponID.value =
                appliedOffer.value.data!.id.toString();
            tempMentorshipCouponCode.value =
                appliedOffer.value.data!.code.toString();

            afterOfferPrice.value =
                appliedOffer.value.data?.discountedAmount ?? "";

            print(
                "afterOfferMentorshipPrice: ${afterOfferMentorshipPrice.value}");
            print("tempMentorshipCouponID: ${tempMentorshipCouponID.value}");
            print(
                "tempMentorshipCouponCode: ${tempMentorshipCouponCode.value}");

            toastShow(message: message);
          }

          print("kljlkjkljkj : ${selectedOffer.value.expiredAt.toString()}");
          isPromoCodeLoading.value = false;

          updateCountdown(appliedOffer.value.data!.expiredAt);
          // updateCountdown(selectedOffer.value.expiredAt);
        },
      );
    } else {
      // Handle case where mentorshipDetailData price is null or invalid
      toastShow(
        message: offerController.value.text.isEmpty
            ? StringResource.enterOfferCode
            : "",
      );
      isPromoCodeLoading.value = false;
    }
  }

  onBuyNow({String orderType = "be_a_pro"}) async {
    isOfferDataLoading.value = true;
    print("selectedOffer is onBuy : ${selectedSubscription.value.title}");
    double price;
    print("orderType is ${orderType}");
    if (orderType == "be_a_pro") {
      if (Platform.isIOS) {
        print("Selected offer is onBuy: ${selectedSubscription.value.title}");

        if (productsList.isNotEmpty) {
          final String title = selectedSubscription.value.title!.toLowerCase();

          // Switch-case-like logic for partial matching
          if (title.contains('12')) {
            print("Purchasing 12-month plan...");
            final ProductDetails? product = productsList.firstWhere(
              (product) => product.id == 'com.stockpathshala.12months_plan',
              // orElse: () => null,
            );
            if (product != null) {
              isOfferDataLoading.value = false;

              iapService.purchaseProduct(product);
            } else {
              print('12-month plan not found in the product list.');
            }
          } else if (title.contains('3')) {
            print("Purchasing 3-month plan...");
            final ProductDetails? product = productsList.firstWhere(
              (product) => product.id == 'com.stockpathshala.3months_plan',
              // orElse: () => null,
            );
            if (product != null) {
              isOfferDataLoading.value = false;

              iapService.purchaseProduct(product);
            } else {
              print('3-month plan not found in the product list.');
            }
          } else if (title.contains('1')) {
            print("Purchasing 1-month plan...");
            final ProductDetails? product = productsList.firstWhere(
              (product) => product.id == 'com.stockpathshala.1month_plan',
              // orElse: () => null,
            );
            if (product != null) {
              isOfferDataLoading.value = false;

              iapService.purchaseProduct(product);
            } else {
              print('1-month plan not found in the product list.');
            }
          } else {
            print("No matching subscription plan found.");
          }
        } else {
          print("Product list is empty.");
        }
      } else {
        if (appliedOffer.value.data?.discountType == 'Percentage') {
          price = ((appliedOffer.value.data?.discountValue ?? 0) *
                  double.parse(selectedSubscription.value.price.toString())) /
              100;
        } else {
          price = appliedOffer.value.data?.discountValue ?? 0.0;
        }

        if (Get.find<AuthService>().isGuestUser.value) {
          isOfferDataLoading.value = false;

          ProgressDialog().showFlipDialog(
              isForPro: false, name: CommonEnum.subscription.name, data: true);
        } else if (selectedSubscription.value.subBatch != null &&
            selectedSubBatch.value == 0) {
          toastShow(message: 'Please select sub batch first', error: true);
        } else {
          if (selectedSubscription.value.id != null) {
            isBuyLoading.value = true;
            try {
              await homeProvider.onBuyPackage(
                  onError: (message, errorMap) {
                    logPrint("razorpay sp-db error: $errorMap");
                    toastShow(message: message);
                    isBuyLoading.value = false;
                  },
                  onSuccess: (message, json) async {
                    if (json != null) {
                      createOrderId(
                          (double.parse(json['data']["pay_amount"].toString()) *
                                  100)
                              .toInt()
                              .toString(),
                          json['data']['order_ref_no'],
                          orderType, onData: (re) {
                        logPrint("Order ID $re");
                        try {
                          TransactionService.instance.openRazorPay(
                              onSuccess: () {},
                              optionData: {
                                "amount":
                                    json['data']["pay_amount"] * 100.toInt(),
                                "name": Get.find<AuthService>().user.value.name,
                                "email":
                                    Get.find<AuthService>().user.value.email,
                                "contact":
                                    Get.find<AuthService>().user.value.mobileNo,
                                "order_type": orderType,
                                "ord_id": re['id'],
                              },
                              onError: (e) {
                                logPrint("razorpay openRazorPay error: $e");
                                isBuyLoading.value = false;
                              });
                        } catch (e) {
                          logPrint("razorpay openRazorPay error: $e");
                        }
                      }, onError: (e) {
                        logPrint("razorpay createOrderId error: $e");
                        toastShow(message: e);
                        isBuyLoading.value = false;
                      });
                    }
                    Future.delayed(const Duration(seconds: 1), () {
                      isBuyLoading.value = false;
                    });
                  },
                  mapData: {
                    "subscription_id": selectedSubscription.value.id,
                    "amount": appliedOffer.value.data?.id != null
                        ? ((selectedSubscription.value.price ?? 0) - price)
                            .toString()
                        : selectedSubscription.value.price?.toString() ?? "0",
                    "promo_code": appliedOffer.value.data?.id == null
                        ? ""
                        : offerController.value.text,
                    "promo_code_id": selectedOffer.value.id,
                    'super_subscription': selectedSubscription.value.superSub,
                    "batch_start_date":
                        selectedSubscription.value.subBatch != null
                            ? selectedSubBatch.value
                            : null,
                    "batch_id": selectedSubscription.value.batchId,
                  });
            } catch (e) {
              Future.delayed(const Duration(seconds: 1), () {
                isBuyLoading.value = false;
              });
            }
          } else {
            toastShow(message: "Please select subscription type");
          }
        }
      }
    } else {
      if (Platform.isIOS) {
        print("Selected offer is onBuy: ${selectedSubscription.value.title}");

        if (productsList.isNotEmpty) {
          // final String title = selectedSubscription.value.title!.toLowerCase();
          //
          // // Switch-case-like logic for partial matching
          //
          //  if (title.contains('mentorship')) {
          //   print("Purchasing Mentorship Plan...");
          final ProductDetails? product = productsList.firstWhere(
            (product) =>
                product.id == 'com.stockpathshala.mentorship_plan_pack',
            // orElse: () => null,
          );
          if (product != null) {
            isOfferDataLoading.value = false;

            iapService.purchaseProduct(product);
          } else {
            print('Mentorship Plan not found in the product list.');
          }
          // }
          // else {
          //   print("No matching subscription plan found.");
          // }
        } else {
          print("Product list is empty.");
        }
      } else {
        if (offerController.value.text == "") {
          afterOfferMentorshipPrice.value =
              (mentorshipDetailController.mentorshipDetailData.value!.price);
          print(
              "afterOfferMentorshipPrice : ${afterOfferMentorshipPrice.value}");
        }

        if (appliedOffer.value.data?.discountType == 'Percentage' &&
            afterOfferPrice.value != "") {
          price = ((appliedOffer.value.data?.discountValue ?? 0) *
                  double.parse(mentorshipDetailController
                      .mentorshipDetailData.value!.price)) /
              100;
        } else {
          price = double.parse(mentorshipDetailController
                  .mentorshipDetailData.value!.price) ??
              0.0;
        }

        if (offerController.value.text != "") {
          tempMentorshipCouponCode.value = offerController.value.text;
        }

        if (Get.find<AuthService>().isGuestUser.value) {
          isOfferDataLoading.value = false;

          ProgressDialog().showFlipDialog(isForPro: false);
        } else {
          if (mentorshipDetailController.mentorshipDetailData.value!.id !=
              null) {
            print(
                "afterOfferMentorshipPrice: ${afterOfferMentorshipPrice.value}");
            print("offer price iss : ${offerController.value.text}");
            print(
                "offer price iss : temp mentorshipCouponCode is: ${afterOfferMentorshipPrice.value}");
            print(
                "offer price iss : tempMentorshipCouponID is: ${tempMentorshipCouponID.value}");
            isBuyLoading.value = true;
            try {
              await homeProvider.onBuyMentorship(
                  onError: (message, errorMap) {
                    logPrint("razorpay sp-db error: $errorMap");
                    toastShow(message: message);
                    isBuyLoading.value = false;
                  },
                  onSuccess: (message, json) async {
                    if (json != null) {
                      createOrderId(
                          (double.parse(json['data']["pay_amount"].toString()) *
                                  100)
                              .toInt()
                              .toString(),
                          json['data']['order_ref_no'],
                          orderType, onData: (re) {
                        logPrint("Order ID $re");
                        try {
                          TransactionService.instance.openRazorPay(
                              onSuccess: () async {
                                SharedPreferences mentorId =
                                    await SharedPreferences.getInstance();
                                String mentorIdValue =
                                    mentorId.getString('mId') ?? '';
                                print("paymenteddas");
                                service.fetchMentorshipData(mentorIdValue);
                                isPurchase.value = true;
                                update();
                              },
                              optionData: {
                                "amount":
                                    json['data']["pay_amount"] * 100.toInt(),
                                "name": Get.find<AuthService>().user.value.name,
                                "email":
                                    Get.find<AuthService>().user.value.email,
                                "contact":
                                    Get.find<AuthService>().user.value.mobileNo,
                                "order_type": orderType,
                                "ord_id": re['id'],
                              },
                              onError: (e) {
                                logPrint("razorpay openRazorPay error: $e");
                                isBuyLoading.value = false;
                              });
                        } catch (e) {
                          logPrint("razorpay openRazorPay error: $e");
                        }
                      }, onError: (e) {
                        logPrint("razorpay createOrderId error: $e");
                        toastShow(message: e);
                        isBuyLoading.value = false;
                      });
                    }
                    Future.delayed(const Duration(seconds: 1), () {
                      isBuyLoading.value = false;
                    });
                  },
                  mapData: {
                    "mentorship_id": mentorshipDetailController
                        .mentorshipDetailData.value?.id,
                    "amount":

                        // afterOfferMentorshipPrice.value,
                        appliedOffer.value.data?.id == null
                            // offerController.value.text == ""
                            ? mentorshipDetailController
                                .mentorshipDetailData.value!.price
                            : afterOfferMentorshipPrice.value ?? "0",
                    "promo_code": offerController.value.text == ""
                        ? ""
                        : tempMentorshipCouponCode.value,
                    // appliedOffer.value.data?.id == null
                    //     ? ""
                    //     : appliedOffer.value.data!.code,
                    "promo_code_id": offerController.value.text == ""
                        ? ""
                        : tempMentorshipCouponID.value
                    // selectedOffer.value.id,
                    // 'super_subscription': selectedSubscription.value.superSub,
                    // "batch_start_date":
                    //     selectedSubscription.value.subBatch != null
                    //         ? selectedSubBatch.value
                    //         : null,
                    // "batch_id": selectedSubscription.value.batchId,
                  });
            } catch (e) {
              Future.delayed(const Duration(seconds: 1), () {
                isBuyLoading.value = false;
              });
            }
          } else {
            toastShow(message: "Please select subscription type");
          }
        }
      }
    }
  }

  Future<void> getOfferData(int pageNo) async {
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      dataPagingController.value.reset();
      // isOfferDataLoading.value = true;
    }
    await homeProvider.getOfferData(
        pageNo: pageNo,
        onError: (message, errorMap) {
          toastShow(
            message: message,
          );
          // isOfferDataLoading.value = false;
        },
        onSuccess: (message, json) {
          offerData.value = offer.OfferCodeModel.fromJson(json!);
          if (offerData.value.data?.data?.isNotEmpty ?? false) {
            dataPagingController.value.list
                .addAll(offerData.value.data?.data ?? []);
          }
          // isOfferDataLoading.value = false;
        });
    autoApplyCoupon();
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = false;
    } else {
      isOfferDataLoading.value = false;
    }
  }

  String removeHtmlTags(String htmlString) {
    RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
    return htmlString.replaceAll(exp, '');
  }

  List<String> getDescriptionPoints(String description) {
    List<String> points = [];

    if (description.contains("\r\n")) {
      for (var item in description.split("\r\n")) {
        points.add(removeHtmlTags(item));
      }
    } else if (description.contains("<br>")) {
      for (var item in description.split("<br>")) {
        points.add(removeHtmlTags(item));
      }
    } else {
      return [description];
    }

    return points;
  }

  // Future<void> getSubscriptionDescription() async {
  //   await homeProvider.getSubscriptionDescription(onError: (message, errorMap) {
  //     toastShow(
  //       message: message,
  //     );
  //   }, onSuccess: (message, json) {
  //     subscriptionDescriptionData.value =
  //         SubscriptionDescriptionModel.fromJson(json!);

  //     subscriptionDescriptionData.value.description!
  //         .removeWhere((item) => item == null);
  //   });
  // }

  Future<void> getSubscriptionPlan() async {
    await homeProvider.getSubscriptionPlan(onError: (message, errorMap) {
      toastShow(
        message: message,
      );
    }, onSuccess: (message, json) {
      isOfferDataLoading.value = false;

      subscriptionPlanData.value =
          plan.SubscriptionTypeModel.fromJson(json ?? {});
      subscriptionDescriptionData.value =
          SubscriptionDescriptionModel.fromJson(json?['subsDesc']);

      subscribedPlanData.value =
          SubscribedPlan.fromJson(json!["subscription"] ?? {});

      offerData.value = offer.OfferCodeModel.fromJson2(json);
      if (offerData.value.data?.data?.isNotEmpty ?? false) {
        dataPagingController.value.list
            .addAll(offerData.value.data?.data ?? []);
      }
      if (subscriptionPlanData.value.data?.isNotEmpty ?? false) {
        if (batchId != null) {
          subscriptionPlanData.value.data?.removeWhere((element) =>
              (element.batchId != batchId && element.superSub == null));
        }
        selectedSubscription
            .value = subscriptionPlanData.value.data?.firstWhere(
                (element) =>
                    // (element.batchId == batchId ||
                    element.isStandard == 1,
                //  ),
                orElse: () =>
                    subscriptionPlanData.value.data?.first ?? plan.Datum()) ??
            subscriptionPlanData.value.data?.first ??
            plan.Datum();
      }
    });
    autoApplyCoupon();

    dataPagingController.value.isDataLoading.value = false;
  }

  // Future<void> getSubscribedPlan() async {
  //   isOfferDataLoading.value = true;
  //   await homeProvider.getSubscribedPlan(onError: (message, errorMap) {
  //     toastShow(
  //       message: message,
  //     );
  //   }, onSuccess: (message, json) {
  //     SubscribedPlan subscribedPlan = SubscribedPlan.fromJson(json ?? {});
  //     subscribedPlanData.value = subscribedPlan;
  //   });
  // }

  Future<void> getSpecialSubscriptionOffer() async {
    // isOfferDataLoading.value = true;
    await homeProvider.getSpecialSubscriptionOffer(
        onError: (message, errorMap) {
      toastShow(
        message: message,
      );
    }, onSuccess: (message, json) {
      logPrint("data : $json");
      specialOfferData.value = SpecialOfferModel.fromJson(json!);

      print("snfmsn : ${specialOfferData.value?.data?.expiredAt}");

      // Check if the offer has an expiration date
    });
  }

  void updateCountdown(DateTime? expirationTime) {
    if (expirationTime == null) {
      offerCountdown.value = 'Invalid expiration time';
      return;
    }

    // Cancel any existing timer before starting a new one
    _countdownTimer?.cancel();
    isPromocodeCountdown.value = true;

    // Start a new timer to update countdown every second
    _countdownTimer = Timer.periodic(Duration(seconds: 1), (timer) {
      final now = DateTime.now();
      final difference = expirationTime.difference(now);

      // If the offer has expired, stop the countdown
      if (difference.isNegative) {
        offerCountdown.value = 'Offer Expired';
        timer.cancel();
      } else if (difference.inHours >= 24) {
        // Show only days if more than 24 hours are remaining
        int days = difference.inDays;
        offerCountdown.value = '$days days';
      } else {
        // Show hours, minutes, and seconds if less than 24 hours are remaining
        String hours = difference.inHours.toString().padLeft(2, '0');
        String minutes = (difference.inMinutes % 60).toString().padLeft(2, '0');
        String seconds = (difference.inSeconds % 60).toString().padLeft(2, '0');
        offerCountdown.value = '$hours:$minutes:$seconds';
      }

      // Debugging output
      print('Countdown: ${offerCountdown.value}');
    });
  }

  // Method to dispose of the timer explicitly (e.g., when the controller is disposed)

  @override
  void onClose() {
    print("timer closed");
    _countdownTimer?.cancel(); // Cancel the timer if it's active
    _countdownTimer = null; // Dispose the timer
    super.onClose();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _countdownTimer = null; // Cancel the timer
    super.dispose();
  }

  Future<void> getOfferBanner() async {
    // isOfferDataLoading.value = true;
    await homeProvider.getOfferBanner(onError: (message, errorMap) {
      toastShow(
        message: message,
      );
    }, onSuccess: (message, json) {
      offerBannerData.value = OfferBannerModel.fromJson(json!);
    });
  }

  paymentConfirmation({
    required String amount,
    required String orderId,
    required String orderRefNo,
    required String orderType,
  }) async {
    await homeProvider.onPaymentConfirmation(
        mapData: {
          "amount": amount,
          "order_id": orderId,
          "order_ref_no": orderRefNo,
          "order_type": orderType
        },
        onError: (message, errorMap) {
          logPrint("razorpay onBuyPackage error: $errorMap");
          toastShow(message: message);
        },
        onSuccess: (message, json) {});
  }
}

createOrderId(String amount, String ordRefNum, String orderType,
    {required Function(Map<String, dynamic> result) onData,
    required Function(dynamic e) onError}) async {
  //var auth = 'Basic ' + base64Encode(utf8.encode('${AppConstants.instance.razorPayKey}:${AppConstants.instance.razorPaySecretKey}'));
  var auth =
      'Basic ${base64Encode(utf8.encode('${Get.find<AuthService>().serviceData.value.data?.razorpayAppId}:${Get.find<AuthService>().serviceData.value.data?.razorpayAppSecret}'))}';
  Map<String, String> headers = {
    'Authorization': auth,
    'Content-Type': 'application/json'
  };
  var body = {
    'amount': amount,
    'currency': 'INR',
    'receipt': 'order_trn_${DateTime.now().millisecond}',
    'payment_capture': true,
    'notes': {
      "user_id": "${Get.find<AuthService>().user.value.id}",
      "user_type": "customers",
      "t_type": "dw",
      "ord_ref_no": ordRefNum,
      "order_type": orderType
    },
  };
  http
      .post(Uri.parse(AppConstants.orderApiRazorpay),
          body: jsonEncode(body), headers: headers)
      .then((value) {
    var jsData = jsonDecode(value.body);
    onData(jsData);
  }).catchError((e) {
    onError(e);
  });
}
