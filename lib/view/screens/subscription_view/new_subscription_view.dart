import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:intl/intl.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/font_resource.dart';
import 'package:stockpathshala_beta/model/utils/hex_color.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quiz_list.dart';
import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../mentroship/controller/mentorship_detail_controller.dart';
import '../../../model/services/auth_service.dart';
import '../../../model/utils/color_resource.dart';
import '../../../model/utils/string_resource.dart';
import '../../../model/models/subscription_models/subscription_plan_model.dart'
    as plan;
import '../../../view_model/controllers/subscription_controller/subscription_controller.dart';
import '../../../enum/routing/routes/app_pages.dart';
import '../../widgets/button_view/common_button.dart';
import '../../widgets/text_field_view/simple_text_field.dart';
import '../base_view/base_view_screen.dart';

class SubscriptionView2 extends StatelessWidget {
  const SubscriptionView2({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final arguments = Get.arguments;
    final bool isMentorShow = arguments?['isMentorShow'] ?? false;
    final String mentorTitle = arguments?['title'] ?? ''; // Default to 'Guest'
    final String mentorPrice = arguments?['price'] ?? ''; // Default to 'Guest'

    print("isMentorShow : $isMentorShow");
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => TitleBarCentered(
        titleColor: ColorResource.white,
        titleText: StringResource.subscription,
      ),
      onActionBuilder: (context, controller) => [],
      onBackClicked: (context, controller) => Get.back(),
      isBackShow: true,
      bodyColor: const Color(0xFFF8F7F7),
      viewControl: SubscriptionController(),
      onPageBuilder: (context, controller) => Container(
          margin:
              const EdgeInsets.only(top: DimensionResource.marginSizeDefault),
          child: _mainPageBuilder(context, controller)),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, SubscriptionController controller) {
    final arguments = Get.arguments;
    final bottomViewInset = MediaQuery.of(context).viewInsets.bottom;
    // Optional Parameters with Default Values
    final bool isMentorShow = arguments?['isMentorShow'] ?? false;
    final String mentorTitle = arguments?['title'] ?? ''; // Default to 'Guest'
    final String mentorPrice = arguments?['price'] ?? ''; // Default to 'Guest'
    final String mentorDayLeft =
        arguments?['daysleft'] ?? ''; // Default to 'Guest'
    print("isMentor value is $mentorPrice");
    final MentorshipDetailController service =
        Get.put(MentorshipDetailController());
    return SafeArea(
      child:
      Scaffold(
          backgroundColor: const Color(0xFFF8F7F7),
          bottomNavigationBar: Obx(
            () => !controller.isOfferDataLoading.value
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Card(

                      shape: const RoundedRectangleBorder(),
                      elevation: 100,
                      margin: EdgeInsets.zero,
                      child: Padding(
                        padding: const EdgeInsets.all(
                            DimensionResource.paddingSizeDefault / 2),
                        child: InkWell(
                          splashColor: Colors.black45,
                          onTap: () {
                            if ((controller.appliedOffer.value.data
                                            ?.minCartAmount ??
                                        0) >
                                    (controller
                                            .selectedSubscription.value.price ??
                                        0) &&
                                !Get.find<AuthService>().isGuestUser.value) {
                              controller.onRemoveCoupon();
                              controller.offerController.value.text = "";
                            }
                            if (isMentorShow == true) {
                              if (int.parse(mentorPrice) != 0) {
                                // if (controller
                                //         .selectedSubscription.value.disable ==
                                //     0) {
                                controller.onBuyNow(orderType: "mentorship");
                                // }
                              } else {
                                Get.find<RootViewController>().getPopUpDataNew();
                              }
                            } else {
                              if (controller.selectedSubscription.value.price !=
                                  0) {
                                if (controller
                                        .selectedSubscription.value.disable ==
                                    0) {
                                  controller.onBuyNow();
                                }
                              } else {
                                Get.find<RootViewController>().getPopUpData2();
                              }
                            }
                          },
                          child: Container(
                              height: 50,
                              color: controller
                                          .selectedSubscription.value.disable ==
                                      1
                                  ? isMentorShow != true
                                      ? const Color.fromARGB(255, 120, 120, 120)
                                      : HexColor(controller
                                              .subscriptionDescriptionData
                                              .value
                                              .buttonBgColor ??
                                          "#ffffff")
                                  : HexColor(controller
                                          .subscriptionDescriptionData
                                          .value
                                          .buttonBgColor ??
                                      "#ffffff"),
                              child: Center(
                                child: Text(
                                  Get.find<AuthService>().isPro.value
                                      ? StringResource.updatePlan
                                      : controller.subscriptionDescriptionData
                                              .value.buttonTitle ??
                                          "",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: controller.selectedSubscription.value
                                                  .disable ==
                                              1
                                          ? isMentorShow != true
                                              ? Color.fromARGB(255, 174, 174, 174)
                                              : ColorResource.white
                                          : ColorResource.white,
                                      fontSize: DimensionResource.fontSizeDefault,
                                      fontWeight: FontWeight.w500),
                                ),
                              )),
                        ),
                      ),
                    ),
                  )
                : ShimmerEffect.instance.becomeAPro(context),
          ),
          body: Obx(() => !controller.isOfferDataLoading.value
              ? ListView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.paddingSizeDefault),
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 16,
                        ),
                        Text(
                          controller.subscriptionDescriptionData.value.addTitle!
                              .replaceAll(
                                  '[first-name]',
                                  Get.find<AuthService>().isGuestUser.value
                                      ? ""
                                      : Get.find<AuthService>().user.value.name !=
                                              null
                                          ? Get.find<AuthService>()
                                              .user
                                              .value
                                              .name!
                                              .split(" ")[0]
                                          : ""),
                          textAlign: TextAlign.center,
                          style: StyleResource.instance.styleSemiBold(
                              // color: Colors.grey[850],
                              fontSize:
                                  DimensionResource.fontSizeDoubleExtraLarge),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 22),
                          child: const Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                color: ColorResource.grey_2,
                              )),
                              Text(
                                "   ",
                                style: TextStyle(
                                    fontSize:
                                        DimensionResource.borderRadiusExtraLarge),
                              ),
                              Expanded(
                                  child: Divider(
                                color: ColorResource.grey_2,
                              )),
                            ],
                          ),
                        ),
                        // Container(
                        //   color: Colors.black,
                        //   height: 300,
                        //   child: Stack(
                        //     alignment: Alignment.topCenter,
                        //     children: [
                        //       Image.asset(
                        //         ImageResource.instance.trading,
                        //       ),
                        //       Container(
                        //         color: const Color(0xFFF8F7F7).withOpacity(0.8),
                        //       ),
                        //       Column(
                        //         children: [],
                        //       ),
                        //     ],
                        //   ),
                        // ),
                        Center(
                          child: Text(
                            controller.subscriptionDescriptionData.value.title ??
                                '',
                            style: StyleResource.instance.styleSemiBold(
                                color: Colors.black,
                                fontSize: DimensionResource.fontSizeExtraLarge),
                          ),
                        ),
                        CarouselSlider(
                          options: CarouselOptions(
                            height: 125,
                            aspectRatio: 16 / 9,
                            viewportFraction: 1,
                            initialPage: 0,
                            enableInfiniteScroll: true,
                            reverse: false,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            autoPlayAnimationDuration:
                                const Duration(milliseconds: 800),
                            autoPlayCurve: Curves.fastOutSlowIn,
                            enlargeCenterPage: true,
                            enlargeFactor: 0.3,
                            onPageChanged: (i, o) {
                              controller.currentCarasouelIndex.value = i;
                            },
                            scrollDirection: Axis.horizontal,
                          ),
                          items: controller
                              .subscriptionDescriptionData.value.description!
                              .map((i) {
                            return Builder(
                              builder: (BuildContext context) {
                                return Column(
                                  children: [
                                    const SizedBox(
                                      height:
                                          DimensionResource.marginSizeExtraSmall,
                                    ),
                                    Expanded(
                                      child: Container(
                                        margin: const EdgeInsets.only(left: 65),
                                        height: controller
                                                .getDescriptionPoints(i)
                                                .length *
                                            25,
                                        child: ListView.builder(
                                          physics:
                                              const NeverScrollableScrollPhysics(),
                                          itemBuilder: (context, index) =>
                                              Padding(
                                            padding: const EdgeInsets.only(
                                                top: DimensionResource
                                                    .paddingSizeExtraSmall),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.check_rounded,
                                                  color: ColorResource
                                                      .mateGreenColor,
                                                  size: 20,
                                                ),
                                                const SizedBox(
                                                  width: DimensionResource
                                                      .marginSizeExtraSmall,
                                                ),
                                                Expanded(
                                                  child: Text(
                                                    controller
                                                        .getDescriptionPoints(
                                                            i)[index],
                                                    style: TextStyle(
                                                      fontSize: DimensionResource
                                                          .fontSizeSmall,
                                                      color: ColorResource.black,
                                                      fontFamily: FontResource
                                                          .instance.mainFont,
                                                      fontWeight: medium,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                          itemCount: controller
                                              .getDescriptionPoints(i)
                                              .length,
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          }).toList(),
                        ),
                        Center(
                          child: SizedBox(
                            width: controller.subscriptionDescriptionData.value
                                    .description!.length *
                                25,
                            height: 50,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 16.0),
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                physics: const NeverScrollableScrollPhysics(),
                                itemBuilder: (context, index) => Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 4),
                                    child: Obx(
                                      () => CircleAvatar(
                                        backgroundColor: controller
                                                    .currentCarasouelIndex
                                                    .value ==
                                                index
                                            ? ColorResource.primaryColor
                                                .withOpacity(0.5)
                                            : const Color.fromARGB(
                                                    255, 22, 19, 19)
                                                .withOpacity(0.25),
                                        radius: DimensionResource
                                            .marginSizeExtraSmall,
                                      ),
                                    )),
                                itemCount: controller.subscriptionDescriptionData
                                    .value.description?.length,
                              ),
                            ),
                          ),
                        ),
                        Row(
                          children: [
                            const Expanded(
                                child: Divider(
                              color: ColorResource.grey_2,
                            )),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      DimensionResource.paddingSizeExtraSmall,
                                  horizontal:
                                      DimensionResource.paddingSizeExtraLarge),
                              decoration: BoxDecoration(
                                border: Border.all(color: ColorResource.grey_2),
                                borderRadius: const BorderRadius.all(
                                    Radius.circular(
                                        DimensionResource.roundButtonRadius)),
                              ),
                              child: Text(
                                'Plans',
                                style: StyleResource.instance.styleSemiBold(),
                              ),
                            ),
                            const Expanded(
                                child: Divider(
                              color: ColorResource.grey_2,
                            )),
                          ],
                        ),
      //subscription tile Started
                        !isMentorShow
                            ? Column(
                                mainAxisSize: MainAxisSize.min,
                                children: List.generate(
                                  controller.subscriptionPlanData.value.data
                                          ?.length ??
                                      0,
                                  (index) {
                                    plan.Datum data = controller
                                        .subscriptionPlanData.value.data![index];

                                    return InkWell(
                                      splashColor: Colors.transparent,
                                      onTap: () {
                                        if (controller
                                                .subscribedPlanData.value.message!
                                                .contains("Expired") &&
                                            controller.subscribedPlanData.value
                                                    .subscriptionId ==
                                                data.id) {
                                          toastShow(message: 'Expired Plan');
                                        } else {
                                          controller.selectedSubscription.value =
                                              data;
                                        }
                                      }

                                      ,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                            top: DimensionResource
                                                .marginSizeSmall),
                                        child: Obx(() {
                                          double? price;
                                          if (controller.appliedOffer.value.data
                                                  ?.discountType ==
                                              'Percentage') {
                                            price = ((controller
                                                            .appliedOffer
                                                            .value
                                                            .data
                                                            ?.discountValue ??
                                                        0) *
                                                    double.parse(
                                                        data.price.toString())) /
                                                100;
                                          } else {
                                            price = controller.appliedOffer.value
                                                    .data?.discountValue ??
                                                0.0;
                                          }

                                          return _subscriptionBox(
                                              controller: controller,
                                              days:
                                                  controller.subscribedPlanData.value.days ??
                                                      0,
                                              created_date: controller
                                                      .subscribedPlanData
                                                      .value
                                                      .created_date ??
                                                  "",
                                              message: controller
                                                      .subscribedPlanData
                                                      .value
                                                      .message ??
                                                  "",
                                              subscribedId: controller
                                                      .subscribedPlanData
                                                      .value
                                                      .subscriptionId ??
                                                  0,
                                              context: context,
                                              isApplied: controller
                                                          .appliedOffer
                                                          .value
                                                          .data
                                                          ?.minCartAmount !=
                                                      null &&
                                                  (controller.appliedOffer.value.data?.minCartAmount ?? 0) <=
                                                      (data.price ?? 0),
                                              afterOfferPrice: price.toString(),
                                              data: data,
                                              isSelected: controller.selectedSubscription.value.disable == 0
                                                  ? controller.selectedSubscription.value.id == data.id
                                                  : controller.selectedSubscription.value.id == null,
                                              showEffectivePrice: index != 0);
                                        }),
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Padding(
                                padding: const EdgeInsets.only(top: 10.0),
                                child: LayoutBuilder(
                                  builder: (context, constraints) {
                                    final screenWidth =
                                        MediaQuery.of(context).size.width;
                                    final isSmallScreen = screenWidth <
                                        600; // Define breakpoint for small screens

                                    return Container(
                                      // width: screenWidth * 0.9,
                                      decoration: BoxDecoration(
                                        color: const Color(
                                            0xFFF5F2FF), // Light purple background color
                                        border: Border.all(
                                          width: 2,
                                          color: ColorResource
                                              .primaryColor, // Border color
                                        ),
                                        borderRadius: BorderRadius.circular(
                                            12), // Rounded corners
                                      ),
                                      child: Column(
                                        children: [
                                          Obx(() => controller.isPurchase.value ==
                                                  true
                                              ? Align(
                                                  alignment: Alignment.topRight,
                                                  child: Container(
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 8,
                                                        vertical: 4),
                                                    decoration: BoxDecoration(
                                                      color:
                                                          ColorResource.redColor,
                                                      borderRadius:
                                                          const BorderRadius.only(
                                                        bottomLeft:
                                                            Radius.circular(5),
                                                        // Rounded bottom-left corner
                                                        topRight: Radius.circular(
                                                            10), // Rounded top-right corner
                                                      ),
                                                    ),
                                                    child: Text(
                                                      "Expire in ${service.mentorshipDetailData.value?.daysLeft.toString() ?? '0'} days",
                                                      // Updated text
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: isSmallScreen
                                                            ? 10
                                                            : 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                )
                                              : Container()),
                                          Container(
                                            padding: EdgeInsets.all(
                                                isSmallScreen ? 12 : 16),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Container(
                                                      padding:
                                                          const EdgeInsets.all(6),
                                                      decoration:
                                                          const BoxDecoration(
                                                        color: Color(
                                                            0xFF7F6EFF), // Purple background
                                                        shape: BoxShape.circle,
                                                      ),
                                                      child: const Icon(
                                                        Icons.check,
                                                        color: Colors.white,
                                                        size: 14,
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Expanded(
                                                      child: Text(
                                                        mentorTitle,
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w600,
                                                          fontSize: isSmallScreen
                                                              ? 13
                                                              : 15,
                                                          color: Colors.black,
                                                        ),
                                                      ),
                                                    ),
                                                    const SizedBox(width: 10),
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment.end,
                                                      children: [
                                                        Obx(() => controller
                                                                    .afterOfferPrice
                                                                    .value !=
                                                                ""
                                                            ? Text(
                                                                '₹$mentorPrice',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      isSmallScreen
                                                                          ? 10
                                                                          : 12,
                                                                  color:
                                                                      Colors.grey,
                                                                  decoration:
                                                                      TextDecoration
                                                                          .lineThrough,
                                                                ),
                                                              )
                                                            : Container()),
                                                        const SizedBox(height: 3),
                                                        Obx(
                                                          () => controller
                                                                      .afterOfferPrice
                                                                      .value !=
                                                                  ""
                                                              ? Text(
                                                                  '₹${double.tryParse(controller.afterOfferMentorshipPrice.value) ?? 0}',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        isSmallScreen
                                                                            ? 12
                                                                            : 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                )
                                                              : Text(
                                                                  '₹$mentorPrice',
                                                                  style:
                                                                      TextStyle(
                                                                    fontSize:
                                                                        isSmallScreen
                                                                            ? 12
                                                                            : 14,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .w600,
                                                                    color: Colors
                                                                        .black,
                                                                  ),
                                                                ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 8),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.end,
                                                  children: [
                                                    Obx(
                                                      () => controller.isPurchase
                                                                  .value ==
                                                              true
                                                          ? Container()
                                                          : Obx(() => controller
                                                                          .afterOfferPrice
                                                                          .value !=
                                                                      ""
                                                                  ? Text(
                                                                      'You Saved ₹${((double.tryParse(mentorPrice) ?? 0) - (double.tryParse(controller.afterOfferMentorshipPrice.toString()) ?? 0)).toStringAsFixed(0)}',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            isSmallScreen
                                                                                ? 12
                                                                                : 14,
                                                                        color: Colors
                                                                            .green,
                                                                        fontWeight:
                                                                            FontWeight
                                                                                .w600,
                                                                      ),
                                                                    )
                                                                  : Container()
                                                              // Text(
                                                              //     'You Saved ₹${0}',
                                                              //     style:
                                                              //         TextStyle(

                                                              //       fontSize: isSmallScreen
                                                              //           ? 12
                                                              //           : 14,
                                                              //       color:
                                                              //           Colors.green,
                                                              //       fontWeight:
                                                              //           FontWeight.w600,
                                                              //     ),
                                                              //   ),
                                                              ),
                                                    ),
                                                    const SizedBox(width: 8),
                                                    Obx(
                                                      () => controller.isPurchase
                                                                  .value ==
                                                              true
                                                          ? Container()
                                                          : Obx(() => controller
                                                                          .afterOfferPrice
                                                                          .value !=
                                                                      ""
                                                                  ? Text(
                                                                      '(${(((double.tryParse(mentorPrice) ?? 0) - (double.tryParse(controller.afterOfferMentorshipPrice.value) ?? 0)) / (double.tryParse(mentorPrice) ?? 0) * 100).toStringAsFixed(0)}% Discount)',
                                                                      style:
                                                                          TextStyle(
                                                                        fontSize:
                                                                            isSmallScreen
                                                                                ? 12
                                                                                : 14,
                                                                        color: Colors
                                                                            .grey,
                                                                      ),
                                                                    )
                                                                  : Container()
                                                              // Text(
                                                              //     '(${0}% Discount)',
                                                              //     style:
                                                              //         TextStyle(
                                                              //       fontSize: isSmallScreen
                                                              //           ? 12
                                                              //           : 14,
                                                              //       color:
                                                              //           Colors.grey,
                                                              //       fontWeight:
                                                              //           FontWeight.w600,
                                                              //     ),
                                                              //   ),
                                                              ),
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                ),
                              ),
      //subscription tile ended
                        const SizedBox(
                          height: 4,
                        ),
                        const Divider(),
                        Platform.isIOS
                            ? Container()
                            : Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Obx(
                                    () => controller.isPurchase.value == true
                                        ? GestureDetector(
                                            onTap: () {},
                                            child: const Text(
                                              'Have a promo code?',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor: Colors.black,
                                                  decorationThickness: 2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: DimensionResource
                                                      .fontSizeSmall),
                                            ),
                                          )
                                        : InkWell(
                                            onTap: () {
                                              // if (Get.find<AuthService>().isGuestUser.value) {
                                              //   ProgressDialog().showFlipDialog(isForPro: false);
                                              // } else {

                                              isMentorShow == true
                                                  ? Get.toNamed(Routes.couponView,
                                                      arguments: {
                                                          'isMentorShow': true,
                                                        })
                                                  : Get.toNamed(
                                                      Routes.couponView);

                                              // }
                                            },
                                            child: const Text(
                                              'Have a promo code?',
                                              style: TextStyle(
                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor: Colors.black,
                                                  decorationThickness: 2,
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: DimensionResource
                                                      .fontSizeSmall),
                                            ),
                                          ),
                                  ),
                                  const SizedBox(
                                    height:
                                        DimensionResource.paddingSizeExtraSmall,
                                  ),
                                  Obx(
                                    () => controller
                                                .appliedOffer.value.data?.id ==
                                            null
                                        ? OverlayTooltipItem(
                                            displayIndex: 1,
                                            tooltipVerticalPosition:
                                                TooltipVerticalPosition.BOTTOM,
                                            tooltipHorizontalPosition:
                                                TooltipHorizontalPosition.CENTER,
                                            tooltip: (_) {
                                              return Container(
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                padding: const EdgeInsets.all(
                                                  10,
                                                ),
                                                decoration: const BoxDecoration(
                                                  color: ColorResource.white,
                                                ),
                                                child: Column(
                                                  mainAxisSize: MainAxisSize.min,
                                                  children: [
                                                    Text(
                                                      'Enter your ‘Coupon Code’ to avail Discount',
                                                      textAlign: TextAlign.center,
                                                      style: StyleResource
                                                          .instance
                                                          .styleMedium(
                                                        color:
                                                            ColorResource.black,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 20,
                                                    ),
                                                    Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceEvenly,
                                                      children: [
                                                        InkWell(
                                                          onTap: () async {
                                                            await Get.find<
                                                                    AuthService>()
                                                                .saveTrainingTooltips(
                                                                    'applyCoupon');
                                                            controller
                                                                .toolTipcontroller
                                                                .dismiss();
                                                          },
                                                          child: Container(
                                                            alignment:
                                                                Alignment.center,
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 20,
                                                              right: 20,
                                                              top: 5,
                                                              bottom: 5,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                color: ColorResource
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Skip',
                                                              style: StyleResource
                                                                  .instance
                                                                  .styleMedium(
                                                                color:
                                                                    ColorResource
                                                                        .black,
                                                              ),
                                                              textAlign: TextAlign
                                                                  .center,
                                                            ),
                                                          ),
                                                        ),
                                                        InkWell(
                                                          onTap: () async {
                                                            await Get.find<
                                                                    AuthService>()
                                                                .saveTrainingTooltips(
                                                                    'applyCoupon');
                                                            controller
                                                                .toolTipcontroller
                                                                .dismiss();
                                                          },
                                                          child: Container(
                                                            alignment:
                                                                Alignment.center,
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                              left: 20,
                                                              right: 20,
                                                              top: 5,
                                                              bottom: 5,
                                                            ),
                                                            decoration:
                                                                BoxDecoration(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          20),
                                                              border: Border.all(
                                                                color: ColorResource
                                                                    .primaryColor,
                                                              ),
                                                            ),
                                                            child: Text(
                                                              'Got it',
                                                              style: StyleResource
                                                                  .instance
                                                                  .styleMedium(
                                                                color:
                                                                    ColorResource
                                                                        .black,
                                                              ),
                                                              textAlign: TextAlign
                                                                  .center,
                                                            ),
                                                          ),
                                                        ),
                                                      ],
                                                    )
                                                  ],
                                                ),
                                              );
                                            },
                                            child: Container(
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  0.7,
                                              height: 40,
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: ColorResource.black,
                                                    width: 1),
                                                color: ColorResource.white,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                      child: SimpleTextField(
                                                    onClear:
                                                        controller.onRemoveCoupon,

                                                    hintText: StringResource
                                                        .applyCoupon,
                                                    autoFocus: controller
                                                        .autoFocus.value,
                                                    controller: controller
                                                        .offerController.value,
                                                    // contentPadding:
                                                    // const EdgeInsets.fromLTRB(
                                                    //     12.0, 7.0, 12.0, 7.0),
                                                    style: StyleResource.instance
                                                        .styleRegular(
                                                            fontSize:
                                                                DimensionResource
                                                                    .fontSizeSmall),
                                                  )),
                                                  Obx(() => controller.isPurchase.value ==
                                                          true
                                                      ? ContainerButton(
                                                          radius: 0,
                                                          isLoading: controller
                                                              .isPromoCodeLoading
                                                              .value,
                                                          text:
                                                              // isMentorShow ? "true ${isMentorShow}" : "false ${isMentorShow}",
                                                              StringResource
                                                                  .apply,
                                                          fontSize:
                                                              DimensionResource
                                                                  .fontSizeSmall,
                                                          color: controller
                                                                  .isOfferControllerHasValue
                                                                  .value
                                                              ? ColorResource
                                                                  .primaryColor
                                                              : ColorResource
                                                                  .primaryColor
                                                                  .withOpacity(
                                                                      0.4),
                                                          fontColor:
                                                              ColorResource.white,
                                                          // padding: const EdgeInsets.symmetric(
                                                          //     horizontal: 12, vertical: 3),
                                                          onPressed: () {})
                                                      : ContainerButton(
                                                          radius: 0,
                                                          isLoading: controller
                                                              .isPromoCodeLoading
                                                              .value,
                                                          text:
                                                              // isMentorShow ? "true ${isMentorShow}" : "false ${isMentorShow}",
                                                              StringResource.apply,
                                                          fontSize: DimensionResource.fontSizeSmall,
                                                          color: controller.isOfferControllerHasValue.value ? ColorResource.primaryColor : ColorResource.primaryColor.withOpacity(0.4),
                                                          fontColor: ColorResource.white,
                                                          // padding: const EdgeInsets.symmetric(
                                                          //     horizontal: 12, vertical: 3),
                                                          onPressed: isMentorShow ? controller.onApplyMentorShipCoupon : controller.onApplyCoupon)),
                                                ],
                                              ),
                                            ),
                                          )
                                        : Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                0.7,
                                            height: 40,
                                            decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: ColorResource.black,
                                                  width: 1),
                                              color: ColorResource.white,
                                            ),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                const SizedBox(
                                                  width: 8,
                                                ),
                                                Container(
                                                  decoration: const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    color: ColorResource
                                                        .mateGreenColor,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(3),
                                                  child: Image.asset(
                                                    ImageResource
                                                        .instance.checkIcon,
                                                    height: 8,
                                                    color: ColorResource.white,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Expanded(
                                                    child: Row(
                                                  children: [
                                                    Text(
                                                      controller.appliedOffer
                                                              .value.data?.code ??
                                                          "",
                                                      style: StyleResource
                                                          .instance
                                                          .styleBold(
                                                              fontSize:
                                                                  DimensionResource
                                                                          .fontSizeExtraSmall +
                                                                      1),
                                                    ),
                                                    Text(
                                                      " Applied",
                                                      style: StyleResource
                                                          .instance
                                                          .styleRegular(
                                                              fontSize:
                                                                  DimensionResource
                                                                      .fontSizeExtraSmall),
                                                    ),
                                                  ],
                                                )),
                                                ContainerButton(
                                                    radius: 00,
                                                    isLoading: controller
                                                        .isPromoCodeLoading.value,
                                                    text: StringResource.remove,
                                                    fontSize: DimensionResource
                                                        .fontSizeSmall,
                                                    color: ColorResource
                                                        .mateRedColor,
                                                    fontColor:
                                                        ColorResource.white,
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                        horizontal: 12,
                                                        vertical: 3),
                                                    onPressed:
                                                        controller.onRemoveCoupon ,


                                                )
                                              ],
                                            ),
                                          ),
                                  ),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  Obx(() => controller.isPromocodeCountdown.value
                                      ? Row(
                                          children: [
                                            Text(
                                              'Promo code expires in : ',
                                              style: const TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600),
                                            ),
                                            Text(
                                              ' ${controller.offerCountdown.value}',
                                              style:
                                                  const TextStyle(fontSize: 10),
                                            ),
                                          ],
                                        )
                                      : Container()),
                                  const Divider(),
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.only(
                            top: 2,
                          ),
                          child: Row(
                            children: [
                              Image.asset(
                                ImageResource.instance.filledHeartIcon,
                                height: 12,
                              ),
                              const SizedBox(
                                width: DimensionResource.marginSizeExtraSmall - 1,
                              ),
                              Text(
                                controller.subscriptionDescriptionData.value
                                        .bottomTitle ??
                                    "",
                                style: const TextStyle(
                                    fontSize: DimensionResource.fontSizeSmall,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w600),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 2,
                        ),
                        HtmlWidget(
                          controller.subscriptionDescriptionData.value
                                  .bottomDescription ??
                              "",
                          textStyle: const TextStyle(
                              fontSize: DimensionResource.fontSizeExtraSmall),
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                      ],
                    ),
                  ],
                )
              : ShimmerEffect.instance.subscriptionLoader(context))),
    );
  }

  Widget _subscriptionBox({
    String? afterOfferPrice,
    required int days,
    required String created_date,
    required SubscriptionController? controller,
    required bool isSelected,
    required int subscribedId,
    required String message,
    required bool isApplied,
    required plan.Datum data,
    required bool showEffectivePrice,
    required BuildContext context,
  }) {
    int price = (double.parse(data.price.toString()) -
            double.parse(
                afterOfferPrice == null ? "0" : afterOfferPrice.toString()))
        .toInt();

    Color activePrimary = ColorResource.primaryColorDark;
    Color activePrimaryContainer = const Color(0xFFE5E3FA);
    Color activeOnPrimary = Colors.grey[850]!;

    Color inactiveColor = ColorResource.grey_3;
    Color inactiveContainerColor = const Color(0xFFF8F7F7);

    return Container(
        width: double.infinity,
        padding: EdgeInsets.only(
          right:
              subscribedId == data.id ? 0 : DimensionResource.paddingSizeSmall,
          top: subscribedId == data.id ? 0 : DimensionResource.paddingSizeSmall,
          bottom: DimensionResource.paddingSizeSmall,
        ),
        decoration: BoxDecoration(
          color: isSelected ? activePrimaryContainer : inactiveContainerColor,
          border: Border.all(
              color: isSelected ? activePrimary : inactiveColor, width: 2),
          borderRadius: const BorderRadius.all(
            Radius.circular(DimensionResource.borderRadiusDefault),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (subscribedId == data.id)
              Container(
                margin: const EdgeInsets.only(bottom: 6),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    !message.contains("Expired")
                        ? Container(
                            padding: const EdgeInsets.only(left: 2, top: 4),
                            decoration: const BoxDecoration(
                              color: ColorResource.primaryColor,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(
                                    DimensionResource.borderRadiusDefault - 2),
                                bottomRight: Radius.circular(
                                    DimensionResource.borderRadiusDefault - 2),
                              ),
                            ),
                            height: 25,
                            width: 78,
                            child: const Text(
                              " Current Plan ",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: ColorResource.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          )
                        :
                        // : Row(
                        //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        //     children: [
                        //       Padding(
                        //         padding: const EdgeInsets.symmetric(
                        //             horizontal:
                        //                 DimensionResource.paddingSizeDefault),
                        //         child: CircleAvatar(
                        //           backgroundColor: isSelected
                        //               ? activePrimary
                        //               : inactiveColor,
                        //           radius: 12,
                        //           child: Icon(
                        //             Icons.check_rounded,
                        //             color: isSelected
                        //                 ? activePrimaryContainer
                        //                 : inactiveContainerColor,
                        //             size: 15,
                        //           ),
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding: const EdgeInsets.only(
                        //             right:
                        //                 DimensionResource.paddingSizeDefault),
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.start,
                        //           children: [
                        //             Text(
                        //               data.title ?? "",
                        //               style: StyleResource.instance
                        //                   .styleSemiBold(
                        //                       color: activeOnPrimary,
                        //                       fontSize: DimensionResource
                        //                           .fontSizeDefault),
                        //               maxLines: 2,
                        //               overflow: TextOverflow.ellipsis,
                        //             ),
                        //             const SizedBox(
                        //               height: DimensionResource
                        //                   .marginSizeExtraSmall,
                        //             ),
                        //             // Text(
                        //             //   '${((isApplied && afterOfferPrice != "" ? price : (data.price ?? 0)) / 365).toStringAsPrecision(3)}₹ Daily',
                        //             //   style: StyleResource.instance.styleSemiBold(
                        //             //       color: ColorResource.textLightGrey,
                        //             //       fontSize: DimensionResource.fontSizeSmall),
                        //             //   maxLines: 2,
                        //             //   overflow: TextOverflow.ellipsis,
                        //             // ),
                        //           ],
                        //         ),
                        //       ),
                        //       Padding(
                        //         padding: EdgeInsets.only(
                        //             right: subscribedId != data.id ? 0 : 8),
                        //         child: Column(
                        //           crossAxisAlignment: CrossAxisAlignment.end,
                        //           mainAxisAlignment: MainAxisAlignment.center,
                        //           children: [
                        //             if (data.price != 0)
                        //               Text(
                        //                 "₹${data.price}".seperateWithCommas,
                        //                 style: StyleResource.instance
                        //                     .styleSemiBold(
                        //                         color: isApplied
                        //                             ? ColorResource
                        //                                 .textLightGrey
                        //                             : activeOnPrimary,
                        //                         fontSize: isApplied &&
                        //                                 afterOfferPrice != ""
                        //                             ? DimensionResource
                        //                                     .fontSizeDefault -
                        //                                 1
                        //                             : DimensionResource
                        //                                     .fontSizeExtraLarge -
                        //                                 2)
                        //                     .copyWith(
                        //                         decoration: isApplied &&
                        //                                 afterOfferPrice != ""
                        //                             ? TextDecoration.lineThrough
                        //                             : TextDecoration.none),
                        //               ),
                        //             if (data.price != 0)
                        //               Visibility(
                        //                   visible: isApplied &&
                        //                       afterOfferPrice != "",
                        //                   child: Text(
                        //                     "₹$price",
                        //                     style: StyleResource.instance
                        //                         .styleSemiBold(
                        //                             color: activeOnPrimary,
                        //                             fontSize: DimensionResource
                        //                                     .fontSizeExtraLarge -
                        //                                 2),
                        //                   )),
                        //           ],
                        //         ),
                        //       ),
                        //     ],
                        //   ),
                        Container(),
                    Container(
                      padding: const EdgeInsets.only(left: 4, top: 0),
                      decoration: const BoxDecoration(
                        color: ColorResource.mateRedColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(
                              DimensionResource.borderRadiusDefault - 2),
                          bottomLeft: Radius.circular(
                              DimensionResource.borderRadiusDefault - 2),
                        ),
                      ),
                      height: 25,
                      width: days != 1 ? 108 : 140,
                      child: Center(
                        child: days != 1
                            ? Text(
                                message,
                                style: const TextStyle(
                                    fontSize: 10,
                                    color: ColorResource.white,
                                    fontWeight: FontWeight.w600),
                              )
                            : Row(
                                children: [
                                  const Text(
                                    " Expires in ",
                                    style: TextStyle(
                                        fontSize: 10,
                                        color: ColorResource.white,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  TimerCountDown(
                                    isHrShow: true,
                                    timeInSeconds: DateTime.parse(
                                            getNewDate(created_date, days))
                                        .difference(DateTime.now())
                                        .inSeconds,
                                    // controller.liveClassDetail
                                    //             .value.data?.startTime
                                    //             ?.difference(DateTime.now())
                                    //             .inSeconds
                                    //             .isNegative ??
                                    //         true
                                    //     ? 0
                                    //     : controller.liveClassDetail.value
                                    //             .data?.startTime
                                    //             ?.difference(DateTime.now())
                                    //             .inSeconds ??
                                    //         0,
                                    isHrs: true,
                                    fontStyle: StyleResource.instance.styleBold(
                                        fontSize:
                                            DimensionResource.fontSizeSmall - 2,
                                        color: ColorResource.white),
                                    remainingSeconds: (second) {
                                      if (second <= 120) {
                                        EasyDebounce.debounce(
                                            controller!.countValue.value
                                                .toString(),
                                            const Duration(milliseconds: 1000),
                                            () async {});
                                      }
                                    },
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.paddingSizeDefault),
                  child: CircleAvatar(
                    backgroundColor: isSelected ? activePrimary : inactiveColor,
                    radius: 12,
                    child: Icon(
                      Icons.check_rounded,
                      color: isSelected
                          ? activePrimaryContainer
                          : inactiveContainerColor,
                      size: 15,
                    ),
                  ),
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(
                        right: DimensionResource.paddingSizeDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          data.title ?? "",
                          style: StyleResource.instance.styleSemiBold(
                              color: activeOnPrimary,
                              fontSize: DimensionResource.fontSizeDefault),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(
                          height: DimensionResource.marginSizeExtraSmall,
                        ),
                        // Text(
                        //   '${((isApplied && afterOfferPrice != "" ? price : (data.price ?? 0)) / 365).toStringAsPrecision(3)}₹ Daily',
                        //   style: StyleResource.instance.styleSemiBold(
                        //       color: ColorResource.textLightGrey,
                        //       fontSize: DimensionResource.fontSizeSmall),
                        //   maxLines: 2,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                      EdgeInsets.only(right: subscribedId != data.id ? 0 : 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (data.price != 0)
                        Text(
                          "₹${data.price}".seperateWithCommas,
                          style: StyleResource.instance
                              .styleSemiBold(
                                  color: isApplied
                                      ? ColorResource.textLightGrey
                                      : activeOnPrimary,
                                  fontSize: isApplied && afterOfferPrice != ""
                                      ? DimensionResource.fontSizeDefault - 1
                                      : DimensionResource.fontSizeExtraLarge -
                                          2)
                              .copyWith(
                                  decoration: isApplied && afterOfferPrice != ""
                                      ? TextDecoration.lineThrough
                                      : TextDecoration.none),
                        ),
                      if (data.price != 0)
                        Visibility(
                            visible: isApplied && afterOfferPrice != "",
                            child: Text(
                              "₹$price",
                              style: StyleResource.instance.styleSemiBold(
                                  color: activeOnPrimary,
                                  fontSize:
                                      DimensionResource.fontSizeExtraLarge - 2),
                            )),
                    ],
                  ),
                ),
              ],
            ),
            Padding(
              padding:
                  EdgeInsets.only(right: subscribedId != data.id ? 0 : 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Visibility(
                      visible: isApplied && afterOfferPrice != "",
                      child: Text(
                        "You Saved ₹${((data.price ?? 0) - price)}",
                        style: StyleResource.instance.styleSemiBold(
                            color: ColorResource.greenDarkColor,
                            fontSize: DimensionResource.fontSizeSmall),
                      )),
                  const SizedBox(
                    width: 2,
                  ),
                  if (data.price != 0)
                    Visibility(
                        visible: isApplied && afterOfferPrice != "",
                        child: Text(
                          "(${((1 - (price / (data.price ?? 0))) * 100).ceil()}% Discount)",
                          style: StyleResource.instance.styleSemiBold(
                              color: ColorResource.textLightGrey,
                              fontSize: DimensionResource.fontSizeDefault - 1),
                        )),
                ],
              ),
            ),
          ],
        ));
  }

  String getNewDate(String dateTimeString, int days) {
    // Parse the string into a DateTime object
    DateTime dateTime = DateFormat("yyyy-MM-dd HH:mm:ss").parse(dateTimeString);

    // Add one day
    DateTime newDateTime = dateTime.add(Duration(days: days));

    // Format the new DateTime object back to a string
    return DateFormat("yyyy-MM-dd HH:mm:ss").format(newDateTime);
  }

  findDiff(String givenDateString) {
    // Adjust the format according to your string
    // Parse the given date string into a DateTime object
    DateTime givenDate = DateTime.parse(givenDateString);
    // Get the current date
    DateTime currentDate = DateTime.now();
    // Calculate the difference between the two dates
    Duration difference = currentDate.difference(givenDate);
    return difference.inDays;
  }
}
