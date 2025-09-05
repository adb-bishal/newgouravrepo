import 'dart:io';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import '../../../model/models/subscription_models/offer_banner_model.dart'
    as banner;
import '../../../model/models/subscription_models/offer_code_model.dart'
    as offer;
import '../../../model/models/subscription_models/subscription_plan_model.dart'
    as plan;
import '../../../model/utils/app_constants.dart';
import '../../../view_model/controllers/subscription_controller/subscription_controller.dart';
import '../../../view_model/routes/app_pages.dart';
import '../../widgets/image_provider/image_provider.dart';
import '../../widgets/text_field_view/simple_text_field.dart';
import '../../widgets/view_helpers/progress_dialog.dart';
import '../base_view/base_view_screen.dart';
import '../root_view/quiz_view/quiz_list.dart';

class SubscriptionView extends StatelessWidget {
  const SubscriptionView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(SubscriptionController());
    return OverlayTooltipScaffold(
        tooltipAnimationCurve: Curves.linear,
        tooltipAnimationDuration: const Duration(milliseconds: 1000),
        controller: Get.find<SubscriptionController>().toolTipcontroller,
        overlayColor: ColorResource.black,
        preferredOverlay: Container(
          height: double.infinity,
          width: double.infinity,
          color: Colors.black.withOpacity(.8),
        ),
        builder: (context) {
          return BaseView(
            onAppBarTitleBuilder: (context, controller) => TitleBarCentered(
              titleText: StringResource.subscription,
            ),
            onActionBuilder: (context, controller) => [],
            onBackClicked: (context, controller) {
              Get.back();
            },
            bodyColor: ColorResource.secondaryColor,
            isBackShow: true,
            viewControl: SubscriptionController(),
            onPageBuilder: (context, controller) =>
                _mainPageBuilder(context, controller),
          );
        });
  }

  Widget _mainPageBuilder(
      BuildContext context, SubscriptionController controller) {
    final size = MediaQuery.of(context).size;
    return ClipRRect(
      borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20), topLeft: Radius.circular(20)),
      child: Obx(() => Scaffold(
            backgroundColor: ColorResource.secondaryColor,
            bottomNavigationBar:

                //Animated Code
                //     Padding(
                //   padding: const EdgeInsets.all(16.0),
                //   child: FillingBox(),
                // ),
                Padding(
              padding: EdgeInsets.only(
                  left: DimensionResource.marginSizeDefault,
                  top: DimensionResource.marginSizeSmall,
                  right: DimensionResource.marginSizeDefault,
                  bottom: DimensionResource.marginSizeSmall +
                      5 +
                      (Platform.isIOS ? 10 : 0)),
              child: CommonButton(
                height: 40,
                text: Get.find<AuthService>().isPro.value
                    ? StringResource.updatePlan
                    : StringResource.buyNowAgain,
                loading: controller.isBuyLoading.value,
                onPressed: controller.onBuyNow,
                textColor: ColorResource.black,
                fontSize: DimensionResource.fontSizeExtraLarge,
                // Prev code
                // color: ColorResource.greenColor,
                color: ColorResource.greenColor,
              ),
            ),
            body: controller.isOfferDataLoading.value
                ? const CommonCircularIndicator()
                : Stack(
                    fit: StackFit.expand,
                    children: [
                      ListView(
                        shrinkWrap: true,
                        children: [
                          Obx(
                            () {
                              return Visibility(
                                  visible:
                                      controller.specialOfferData.value.data !=
                                              null &&
                                          controller.specialOfferData.value.data
                                                  ?.code !=
                                              null,
                                  child: const Column(
                                    children: [
                                      SizedBox(
                                        height:
                                            DimensionResource.marginSizeDefault,
                                      ),
                                      SpecialOfferBox(),
                                    ],
                                  ));
                            },
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: DimensionResource.marginSizeDefault,
                                vertical: DimensionResource.marginSizeDefault),
                            child: Text(
                              StringResource.offerAndBeneifits,
                              style: StyleResource.instance
                                  .styleSemiBold(color: ColorResource.white),
                            ),
                          ),
                          Obx(
                            () => controller.appliedOffer.value.data?.id == null
                                ? OverlayTooltipItem(
                                    displayIndex: 1,
                                    tooltipVerticalPosition:
                                        TooltipVerticalPosition.BOTTOM,
                                    tooltipHorizontalPosition:
                                        TooltipHorizontalPosition.CENTER,
                                    tooltip: (_) {
                                      return Container(
                                        margin: const EdgeInsets.only(top: 10),
                                        width: size.width * 0.8,
                                        padding: const EdgeInsets.all(
                                          10,
                                        ),
                                        decoration: BoxDecoration(
                                            color: ColorResource.white,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Text(
                                              'Enter your ‘Coupon Code’ to avail Discount',
                                              textAlign: TextAlign.center,
                                              style: StyleResource.instance
                                                  .styleMedium(
                                                color: ColorResource.black,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                InkWell(
                                                  onTap: () async {
                                                    await Get.find<
                                                            AuthService>()
                                                        .saveTrainingTooltips(
                                                            'applyCoupon');
                                                    controller.toolTipcontroller
                                                        .dismiss();
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 5,
                                                      bottom: 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                            ColorResource.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
                                                    ),
                                                  ),
                                                ),
                                                InkWell(
                                                  onTap: () async {
                                                    await Get.find<
                                                            AuthService>()
                                                        .saveTrainingTooltips(
                                                            'applyCoupon');
                                                    controller.toolTipcontroller
                                                        .dismiss();
                                                  },
                                                  child: Container(
                                                    alignment: Alignment.center,
                                                    padding:
                                                        const EdgeInsets.only(
                                                      left: 20,
                                                      right: 20,
                                                      top: 5,
                                                      bottom: 5,
                                                    ),
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
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
                                                            ColorResource.black,
                                                      ),
                                                      textAlign:
                                                          TextAlign.center,
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
                                      height: 40,
                                      decoration: BoxDecoration(
                                          color: ColorResource.white,
                                          borderRadius:
                                              BorderRadius.circular(4)),
                                      child: Row(
                                        children: [
                                          Expanded(
                                              child: SimpleTextField(
                                            onClear: controller.onRemoveCoupon,
                                            hintText:
                                                StringResource.applyCoupon,
                                            autoFocus:
                                                controller.autoFocus.value,
                                            controller: controller
                                                .offerController.value,
                                            contentPadding:
                                                const EdgeInsets.fromLTRB(
                                                    12.0, 7.0, 12.0, 7.0),
                                            style: StyleResource.instance
                                                .styleRegular(
                                                    fontSize: DimensionResource
                                                        .fontSizeSmall),
                                          )),
                                          Padding(
                                            padding: const EdgeInsets.all(5.0),
                                            child: ContainerButton(
                                                radius: 5,
                                                isLoading: controller
                                                    .isPromoCodeLoading.value,
                                                text: StringResource.apply,
                                                fontSize: DimensionResource
                                                    .fontSizeSmall,
                                                color: controller
                                                        .isOfferControllerHasValue
                                                        .value
                                                    ? ColorResource.primaryColor
                                                    : ColorResource.primaryColor
                                                        .withOpacity(0.4),
                                                fontColor: ColorResource.white,
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 3),
                                                onPressed:
                                                    controller.onApplyCoupon),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : Container(
                                    //height: 40,
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: DimensionResource
                                            .marginSizeDefault),
                                    decoration: BoxDecoration(
                                        color: ColorResource.white,
                                        borderRadius: BorderRadius.circular(4)),
                                    padding: const EdgeInsets.symmetric(
                                        vertical: DimensionResource
                                                .marginSizeExtraSmall -
                                            2),
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
                                            color: ColorResource.mateGreenColor,
                                          ),
                                          padding: const EdgeInsets.all(3),
                                          child: Image.asset(
                                            ImageResource.instance.checkIcon,
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
                                              controller.appliedOffer.value.data
                                                      ?.code ??
                                                  "",
                                              style: StyleResource.instance
                                                  .styleBold(
                                                      fontSize: DimensionResource
                                                              .fontSizeExtraSmall +
                                                          1),
                                            ),
                                            Text(
                                              " Applied",
                                              style: StyleResource.instance
                                                  .styleRegular(
                                                      fontSize: DimensionResource
                                                          .fontSizeExtraSmall),
                                            ),
                                          ],
                                        )),
                                        Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: ContainerButton(
                                              radius: 5,
                                              isLoading: controller
                                                  .isPromoCodeLoading.value,
                                              text: StringResource.remove,
                                              fontSize: DimensionResource
                                                  .fontSizeSmall,
                                              color: ColorResource.mateRedColor,
                                              fontColor: ColorResource.white,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 12,
                                                      vertical: 3),
                                              onPressed:
                                                  controller.onRemoveCoupon),
                                        )
                                      ],
                                    ),
                                  ),
                          ),
                          const SizedBox(
                              height: DimensionResource.marginSizeExtraSmall),
                          Visibility(
                            visible: controller
                                .dataPagingController.value.list.isNotEmpty,
                            child: InkWell(
                              onTap: () {
                                if (Get.find<AuthService>().isGuestUser.value) {
                                  ProgressDialog()
                                      .showFlipDialog(isForPro: false);
                                } else {
                                  Get.toNamed(Routes.couponView);
                                }
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal:
                                      DimensionResource.marginSizeDefault,
                                  vertical: DimensionResource.marginSizeSmall,
                                ),
                                child: Row(
                                  children: [
                                    Text(
                                      StringResource.viewMoreOffers,
                                      style: StyleResource.instance
                                          .styleSemiBold(
                                              color: ColorResource.greenColor),
                                    ),
                                    Container(
                                      margin: const EdgeInsets.only(left: 5),
                                      decoration: const BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: ColorResource.white),
                                      padding: const EdgeInsets.all(3),
                                      child: Image.asset(
                                        ImageResource.instance.topArrowIcon,
                                        height: 10,
                                        color: ColorResource.mateGreenColor,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Obx(() {
                            return Visibility(
                                visible: controller
                                    .dataPagingController.value.list.isNotEmpty,
                                child: Column(
                                  children: [
                                    couponCodeContainer(
                                        controller.dataPagingController.value
                                                .list.isEmpty
                                            ? offer.Datum()
                                            : controller.dataPagingController
                                                .value.list.first,
                                        controller: controller),
                                    const SizedBox(
                                      height: DimensionResource
                                          .marginSizeExtraSmall,
                                    ),
                                  ],
                                ));
                          }),
                          Visibility(
                            visible: Get.find<AuthService>().isPro.value,
                            child: Center(
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: DimensionResource.marginSizeDefault,
                                    right: DimensionResource.marginSizeDefault,
                                    bottom: 5,
                                    top: 10),
                                child: RichText(
                                    text: TextSpan(
                                        style: StyleResource.instance
                                            .styleRegular(
                                                color:
                                                    ColorResource.primaryColor,
                                                fontSize: DimensionResource
                                                        .fontSizeSmall -
                                                    2),
                                        children: [
                                      const TextSpan(
                                        text: "Pro Plan Expire On: ",
                                      ),
                                      TextSpan(
                                        text: AppConstants.formatDateInForm(
                                            Get.find<AuthService>()
                                                .user
                                                .value
                                                .proExpireAt),
                                        style: StyleResource.instance
                                            .styleSemiBold(
                                                color: ColorResource.white,
                                                fontSize: DimensionResource
                                                        .fontSizeSmall -
                                                    2),
                                      )
                                    ])),
                              ),
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: DimensionResource.marginSizeDefault,
                            ),
                            child: Divider(
                              color: ColorResource.textColor_8,
                            ),
                          ),
                          Obx(
                            () => Column(
                              children: List.generate(
                                controller.subscriptionPlanData.value.data
                                        ?.length ??
                                    0,
                                (index) {
                                  plan.Datum data = controller
                                      .subscriptionPlanData.value.data![index];

                                  return InkWell(
                                    splashColor: Colors.transparent,
                                    onTap: controller
                                                .appliedOffer.value.data?.id ==
                                            null
                                        ? () {
                                            controller.selectedSubscription
                                                .value = data;
                                          }
                                        : (controller.appliedOffer.value.data
                                                        ?.minCartAmount ??
                                                    0) <=
                                                (data.price ?? 0)
                                            ? () {
                                                controller.selectedSubscription
                                                    .value = data;
                                              }
                                            : null,
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

                                        return subscriptionBox2(
                                            context: context,
                                            isStandard: data.isStandard == 1,
                                            isApplied: controller
                                                        .appliedOffer
                                                        .value
                                                        .data
                                                        ?.minCartAmount !=
                                                    null &&
                                                (controller
                                                            .appliedOffer
                                                            .value
                                                            .data
                                                            ?.minCartAmount ??
                                                        0) <=
                                                    (data.price ?? 0),
                                            afterOfferPrice: price.toString(),
                                            data: data,
                                            isSelected: controller
                                                    .selectedSubscription
                                                    .value
                                                    .id ==
                                                data.id,
                                            showEffectivePrice: index != 0);
                                      }),
                                    ),
                                  );
                                },
                              ),
                            ),
                          ),
                          if (controller.subscriptionPlanData.value.data
                                  ?.isNotEmpty ??
                              false)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Visibility(
                                  visible: false,
                                  child: Column(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            left: DimensionResource
                                                .marginSizeDefault),
                                        child: Text(
                                          StringResource.chooseBatch,
                                          style: StyleResource.instance
                                              .styleSemiBold(
                                                  fontSize: DimensionResource
                                                      .fontSizeLarge,
                                                  color: ColorResource.white),
                                        ),
                                      ),
                                      const SizedBox(
                                        height:
                                            DimensionResource.marginSizeDefault,
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                const BorderRadius.all(Radius
                                                    .circular(DimensionResource
                                                        .borderRadiusDefault)),
                                            border: Border.all(
                                                color: ColorResource.white)),
                                        margin: const EdgeInsets.symmetric(
                                            horizontal: DimensionResource
                                                .paddingSizeDefault),
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(
                                              DimensionResource
                                                  .borderRadiusDefault),
                                          child: Obx(
                                            () => ExpansionPanelList(
                                                elevation: 12,
                                                expandedHeaderPadding:
                                                    EdgeInsets.zero,
                                                expandIconColor:
                                                    ColorResource.primaryColor,
                                                expansionCallback:
                                                    (index, isOpen) {
                                                  controller.isExpanded.value =
                                                      !controller
                                                          .isExpanded.value;
                                                },
                                                children: [
                                                  ExpansionPanel(
                                                      isExpanded: controller
                                                          .isExpanded.value,
                                                      backgroundColor:
                                                          ColorResource.white,
                                                      headerBuilder:
                                                          (context, isOpen) {
                                                        return GestureDetector(
                                                          onTap: () {
                                                            controller
                                                                    .isExpanded
                                                                    .value =
                                                                !controller
                                                                    .isExpanded
                                                                    .value;
                                                          },
                                                          child: Container(
                                                            decoration: BoxDecoration(
                                                                image: DecorationImage(
                                                                    image: AssetImage(ImageResource
                                                                        .instance
                                                                        .selectedSubscriptionBoxBG))),
                                                            margin:
                                                                const EdgeInsets
                                                                    .symmetric(
                                                              horizontal:
                                                                  DimensionResource
                                                                      .marginSizeDefault,
                                                            ),
                                                            alignment: Alignment
                                                                .centerLeft,
                                                            child: Text(
                                                              controller
                                                                      .selectedSubscription
                                                                      .value
                                                                      .title ??
                                                                  '',
                                                              style: const TextStyle(
                                                                  color:
                                                                      ColorResource
                                                                          .black,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600),
                                                            ),
                                                          ),
                                                        );
                                                      },
                                                      body: Container(
                                                        decoration: const BoxDecoration(
                                                            border: Border(
                                                                top: BorderSide(
                                                                    color: ColorResource
                                                                        .black))),
                                                        child: Column(
                                                          mainAxisSize:
                                                              MainAxisSize.min,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .start,
                                                          children:
                                                              List.generate(
                                                            controller
                                                                    .subscriptionPlanData
                                                                    .value
                                                                    .data
                                                                    ?.length ??
                                                                0,
                                                            (index) =>
                                                                ColoredBox(
                                                              color:
                                                                  ColorResource
                                                                      .mateBlack,
                                                              child: InkWell(
                                                                onTap: () {
                                                                  controller
                                                                      .selectedSubscription
                                                                      .value = controller
                                                                          .subscriptionPlanData
                                                                          .value
                                                                          .data?[index] ??
                                                                      plan.Datum();
                                                                  // if (controller
                                                                  //         .batchDateId ==
                                                                  //     null) {
                                                                  controller
                                                                      .selectedSubBatch
                                                                      .value = controller
                                                                          .selectedSubscription
                                                                          .value
                                                                          .subBatch
                                                                          ?.first
                                                                          .id ??
                                                                      0;
                                                                  // } else {
                                                                  //   controller
                                                                  //       .selectedSubBatch
                                                                  //       .value = 0;
                                                                  // }
                                                                  Future.delayed(
                                                                          controller
                                                                              .defDuration)
                                                                      .then((value) => controller
                                                                          .isExpanded
                                                                          .value = false);
                                                                },
                                                                child:
                                                                    Container(
                                                                  width: double
                                                                      .infinity,
                                                                  alignment:
                                                                      Alignment
                                                                          .centerLeft,
                                                                  margin: const EdgeInsets
                                                                      .symmetric(
                                                                      vertical:
                                                                          12,
                                                                      horizontal:
                                                                          DimensionResource
                                                                              .marginSizeDefault),
                                                                  child: Text(
                                                                    controller
                                                                            .subscriptionPlanData
                                                                            .value
                                                                            .data?[index]
                                                                            .title ??
                                                                        '',
                                                                    style: const TextStyle(
                                                                        color: ColorResource
                                                                            .white,
                                                                        fontSize:
                                                                            DimensionResource.fontSizeDefault -
                                                                                1,
                                                                        fontWeight:
                                                                            FontWeight.w600),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ),
                                                      )),
                                                ]),
                                          ),
                                        ),
                                      ),
                                      Obx(() {
                                        bool isApplied = controller
                                                    .appliedOffer
                                                    .value
                                                    .data
                                                    ?.minCartAmount !=
                                                null &&
                                            (controller.appliedOffer.value.data
                                                        ?.minCartAmount ??
                                                    0) <=
                                                (controller.selectedSubscription
                                                        .value.price ??
                                                    0);
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
                                                  double.parse(controller
                                                      .selectedSubscription
                                                      .value
                                                      .price
                                                      .toString())) /
                                              100;
                                        } else {
                                          price = controller.appliedOffer.value
                                                  .data?.discountValue ??
                                              0.0;
                                        }
                                        int? offerPrice = ((double.tryParse(
                                                        controller
                                                            .selectedSubscription
                                                            .value
                                                            .price
                                                            .toString()) ??
                                                    price) -
                                                price)
                                            .toInt();
                                        return Container(
                                          margin: const EdgeInsets.only(
                                              top: DimensionResource
                                                  .marginSizeDefault,
                                              left: DimensionResource
                                                  .marginSizeDefault,
                                              right: DimensionResource
                                                  .marginSizeDefault),
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  bottom: DimensionResource
                                                      .marginSizeDefault,
                                                ),
                                                child: Text(
                                                  StringResource.batchDetails,
                                                  style: StyleResource.instance
                                                      .styleSemiBold(
                                                          fontSize:
                                                              DimensionResource
                                                                  .fontSizeSmall,
                                                          color: ColorResource
                                                              .white),
                                                ),
                                              ),
                                              Padding(
                                                padding: const EdgeInsets
                                                    .symmetric(
                                                    horizontal: DimensionResource
                                                        .marginSizeExtraSmall),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      controller
                                                              .selectedSubscription
                                                              .value
                                                              .description ??
                                                          '',
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500,
                                                          color: ColorResource
                                                              .subTextColorLight,
                                                          fontSize:
                                                              DimensionResource
                                                                      .fontSizeSmall -
                                                                  1),
                                                    ),
                                                    Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .end,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          "₹${controller.selectedSubscription.value.price}"
                                                              .seperateWithCommas,
                                                          style: TextStyle(
                                                                  color: isApplied
                                                                      ? ColorResource
                                                                          .subTextColorLight
                                                                      : ColorResource
                                                                          .white,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  fontSize: isApplied
                                                                      ? DimensionResource.fontSizeDefault -
                                                                          1
                                                                      : DimensionResource.fontSizeLarge -
                                                                          1)
                                                              .copyWith(
                                                                  decorationColor:
                                                                      ColorResource
                                                                          .redColor,
                                                                  decoration: isApplied
                                                                      ? TextDecoration
                                                                          .lineThrough
                                                                      : TextDecoration
                                                                          .none),
                                                        ),
                                                        Visibility(
                                                            visible: isApplied,
                                                            child: Text(
                                                              "₹$offerPrice"
                                                                  .seperateWithCommas,
                                                              style: const TextStyle(
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                  color:
                                                                      ColorResource
                                                                          .white,
                                                                  fontSize:
                                                                      DimensionResource
                                                                          .fontSizeLarge),
                                                            )),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              SizedBox(
                                                height: controller
                                                            .selectedSubscription
                                                            .value
                                                            .subBatch ==
                                                        null
                                                    ? DimensionResource
                                                        .paddingSizeDefault
                                                    : 0,
                                              ),
                                              if (controller
                                                      .selectedSubscription
                                                      .value
                                                      .subBatch !=
                                                  null)
                                                Padding(
                                                  padding: const EdgeInsets
                                                      .only(
                                                      top: DimensionResource
                                                          .paddingSizeDefault),
                                                  child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.min,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Expanded(
                                                            flex: 3,
                                                            child: Text(
                                                              StringResource
                                                                  .subBatch,
                                                              style: StyleResource
                                                                  .instance
                                                                  .styleSemiBold(
                                                                      fontSize:
                                                                          DimensionResource
                                                                              .fontSizeLarge,
                                                                      color: ColorResource
                                                                          .white),
                                                            ),
                                                          ),
                                                          if (controller
                                                                  .selectedSubscription
                                                                  .value
                                                                  .subBatch
                                                                  ?.length ==
                                                              1)
                                                            Flexible(
                                                              flex: 2,
                                                              child: Container(
                                                                decoration:
                                                                    const BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius.all(
                                                                          Radius.circular(
                                                                              DimensionResource.borderRadiusDefault)),
                                                                  color: ColorResource
                                                                      .mateBlack,
                                                                ),
                                                                margin:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  vertical:
                                                                      DimensionResource
                                                                          .marginSizeSmall,
                                                                ),
                                                                padding:
                                                                    const EdgeInsets
                                                                        .symmetric(
                                                                  horizontal:
                                                                      DimensionResource
                                                                          .paddingSizeSmall,
                                                                ),
                                                                child:
                                                                    RadioMenuButton(
                                                                  style:
                                                                      _radioBtnStyle(),
                                                                  value: controller
                                                                      .selectedSubscription
                                                                      .value
                                                                      .subBatch?[
                                                                          0]
                                                                      .id,
                                                                  groupValue:
                                                                      controller
                                                                          .selectedSubBatch
                                                                          .value,
                                                                  onChanged:
                                                                      (value) {
                                                                    controller
                                                                            .selectedSubBatch
                                                                            .value =
                                                                        value ??
                                                                            0;
                                                                    controller.batchDateId = controller
                                                                        .selectedSubscription
                                                                        .value
                                                                        .subBatch?[
                                                                            0]
                                                                        .id;
                                                                  },
                                                                  child: Text(
                                                                    AppConstants.formatSmallDate(DateTime.parse(controller
                                                                            .selectedSubscription
                                                                            .value
                                                                            .subBatch?[0]
                                                                            .startDate ??
                                                                        '')),
                                                                    style: const TextStyle(
                                                                        // color: ColorResource.white,
                                                                        fontWeight: FontWeight.w600,
                                                                        fontSize: DimensionResource.fontSizeDefault - 1),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                        ],
                                                      ),
                                                      if ((controller
                                                                  .selectedSubscription
                                                                  .value
                                                                  .subBatch
                                                                  ?.length ??
                                                              0) >
                                                          1)
                                                        Container(
                                                          width:
                                                              double.infinity,
                                                          decoration:
                                                              const BoxDecoration(
                                                            borderRadius: BorderRadius.all(
                                                                Radius.circular(
                                                                    DimensionResource
                                                                        .borderRadiusDefault)),
                                                            color: ColorResource
                                                                .mateBlack,
                                                          ),
                                                          margin:
                                                              const EdgeInsets
                                                                  .symmetric(
                                                            vertical:
                                                                DimensionResource
                                                                    .marginSizeSmall,
                                                          ),
                                                          padding: const EdgeInsets
                                                              .fromLTRB(
                                                              DimensionResource
                                                                  .paddingSizeDefault,
                                                              0,
                                                              DimensionResource
                                                                  .paddingSizeDefault,
                                                              0),
                                                          child:
                                                              SingleChildScrollView(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            child: Row(
                                                              children: List.generate(
                                                                  controller.selectedSubscription.value.subBatch?.length ?? 0,
                                                                  (index) => RadioMenuButton(
                                                                      style: _radioBtnStyle(),
                                                                      value: controller.selectedSubscription.value.subBatch?[index].id,
                                                                      groupValue: controller.selectedSubBatch.value,
                                                                      onChanged: (value) {
                                                                        controller
                                                                            .selectedSubBatch
                                                                            .value = value ?? 0;
                                                                        controller.batchDateId = controller
                                                                            .selectedSubscription
                                                                            .value
                                                                            .subBatch?[index]
                                                                            .id;
                                                                      },
                                                                      child: Text(
                                                                        AppConstants.formatSmallDate(DateTime.parse(controller.selectedSubscription.value.subBatch?[index].startDate ??
                                                                            '')),
                                                                        style: const TextStyle(
                                                                            fontWeight:
                                                                                FontWeight.w600,
                                                                            fontSize: DimensionResource.fontSizeDefault - 1),
                                                                      ))),
                                                            ),
                                                          ),
                                                        ),
                                                    ],
                                                  ),
                                                )
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                Obx(() {
                                  int? price;
                                  if (controller.appliedOffer.value.data
                                          ?.discountType ==
                                      'Percentage') {
                                    price = (((controller.appliedOffer.value
                                                        .data?.discountValue ??
                                                    0) *
                                                (controller.selectedSubscription
                                                        .value.price ??
                                                    0)) /
                                            100)
                                        .ceil();
                                  } else {
                                    price = controller.appliedOffer.value.data
                                            ?.discountValue
                                            ?.toInt() ??
                                        0;
                                  }
                                  return Visibility(
                                    visible: controller
                                            .selectedSubscription.value.id !=
                                        null,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Padding(
                                          padding: EdgeInsets.only(
                                            left: DimensionResource
                                                .marginSizeDefault,
                                            right: DimensionResource
                                                .marginSizeDefault,
                                            bottom: DimensionResource
                                                .marginSizeSmall,
                                          ),
                                          child: Divider(
                                            color: ColorResource.textColor_8,
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                            left: DimensionResource
                                                .marginSizeDefault,
                                            bottom: DimensionResource
                                                .marginSizeDefault,
                                          ),
                                          child: Text(
                                            StringResource.paymentSummery,
                                            style: StyleResource.instance
                                                .styleSemiBold(
                                                    fontSize: DimensionResource
                                                        .fontSizeSmall,
                                                    color: ColorResource.white),
                                          ),
                                        ),
                                        textRow(
                                            StringResource.subTotal,
                                            controller.selectedSubscription
                                                    .value.price
                                                    ?.toString()
                                                    .seperateWithCommas ??
                                                "0"),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        textRow(
                                          StringResource.discount,
                                          price.toString().seperateWithCommas,
                                          textColor:
                                              ColorResource.subTextColorLight,
                                          isShowNegative: price != 0.0,
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: DimensionResource
                                                .marginSizeDefault,
                                          ),
                                          child: Divider(
                                            color: ColorResource.textColor_8,
                                          ),
                                        ),
                                        Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          children: [
                                            textRow(
                                                StringResource.totalPayable,
                                                controller.appliedOffer.value.data?.id != null
                                                    ? ((controller
                                                                    .selectedSubscription
                                                                    .value
                                                                    .price ??
                                                                0) -
                                                            price)
                                                        .toString()
                                                        .seperateWithCommas
                                                    : (controller
                                                                .selectedSubscription
                                                                .value
                                                                .price ??
                                                            0)
                                                        .toString()
                                                        .seperateWithCommas,
                                                style: StyleResource.instance.styleSemiBold(
                                                    color: ColorResource.white,
                                                    fontSize: DimensionResource
                                                        .fontSizeLarge),
                                                styleTitle: StyleResource.instance
                                                    .styleSemiBold(
                                                        color: ColorResource.white,
                                                        fontSize: DimensionResource.fontSizeDefault)),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: DimensionResource
                                                    .marginSizeDefault,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.end,
                                                children: [
                                                  Image.asset(
                                                    ImageResource
                                                        .instance.paymentRefund,
                                                    color: ColorResource.white,
                                                    height: 12,
                                                  ),
                                                  const SizedBox(
                                                    width: DimensionResource
                                                        .paddingSizeSmall,
                                                  ),
                                                  const Text(
                                                    '100% refund policy for 2 days',
                                                    style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: DimensionResource
                                                                .fontSizeSmall -
                                                            2),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  );
                                }),
                              ],
                            ),
                          const SizedBox(
                            height: DimensionResource.marginSizeDefault,
                          ),
                          Visibility(
                            visible: controller
                                    .offerBannerData.value.data?.isNotEmpty ==
                                true,
                            child: Obx(() {
                              return SizedBox(
                                height: 180,
                                width: double.infinity,
                                child: Stack(
                                  fit: StackFit.expand,
                                  children: [
                                    Positioned(
                                      top: 0,
                                      bottom: 0,
                                      left: 0,
                                      right: 0,
                                      child: CarouselSlider.builder(
                                        carouselController:
                                            controller.carouselController.value,
                                        options: CarouselOptions(
                                          aspectRatio: 1,
                                          viewportFraction: 1,
                                          autoPlay: controller.offerBannerData
                                                      .value.data?.length ==
                                                  1
                                              ? false
                                              : true,
                                          enlargeCenterPage: false,
                                          disableCenter: false,
                                          onPageChanged: (index, reason) {
                                            controller.currentIndex.value =
                                                index;
                                          },
                                        ),
                                        itemCount: controller.offerBannerData
                                                .value.data?.length ??
                                            0,
                                        itemBuilder: (context, index, _) {
                                          banner.Datum dataAtIndex = controller
                                              .offerBannerData
                                              .value
                                              .data![index];

                                          return Stack(
                                            fit: StackFit.expand,
                                            children: [
                                              Stack(
                                                fit: StackFit.expand,
                                                children: [
                                                  cachedNetworkImage(
                                                      dataAtIndex.image ?? '',
                                                      fit: BoxFit.cover),
                                                  Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                      gradient: LinearGradient(
                                                        colors: [
                                                          Colors.transparent,
                                                          Colors.black,
                                                        ],
                                                        begin:
                                                            Alignment.topCenter,
                                                        end: Alignment
                                                            .bottomCenter,
                                                        tileMode:
                                                            TileMode.mirror,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Container(
                                                    margin: const EdgeInsets
                                                        .symmetric(
                                                        horizontal:
                                                            DimensionResource
                                                                .marginSizeDefault),
                                                    constraints: BoxConstraints(
                                                      maxWidth:
                                                          MediaQuery.of(context)
                                                                  .size
                                                                  .width *
                                                              0.7,
                                                    ),
                                                    child: Column(
                                                      mainAxisSize:
                                                          MainAxisSize.min,
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      children: [
                                                        Text(
                                                          dataAtIndex.title ??
                                                              "",
                                                          style: StyleResource
                                                              .instance
                                                              .styleRegular(
                                                                  fontSize:
                                                                      DimensionResource
                                                                          .fontSizeLarge,
                                                                  color:
                                                                      ColorResource
                                                                          .white),
                                                        ),
                                                        Text(
                                                          dataAtIndex
                                                                  .description ??
                                                              "",
                                                          style: StyleResource
                                                              .instance
                                                              .styleRegular(
                                                                  fontSize:
                                                                      DimensionResource
                                                                          .fontSizeSmall,
                                                                  color:
                                                                      ColorResource
                                                                          .white),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              )
                                            ],
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                          // Container(
                          //   padding: const EdgeInsets.symmetric(
                          //       horizontal:
                          //           DimensionResource.paddingSizeDefault,
                          //       vertical:
                          //           DimensionResource.paddingSizeExtraSmall),
                          //   color: ColorResource.lightContrastBlack,
                          //   child: DefaultTextStyle(
                          //     style: TextStyle(
                          //         fontFamily: FontResource.instance.mainFont,
                          //         color: ColorResource.white),
                          //     child: Column(
                          //       children: [
                          //         Row(
                          //           children: [
                          //             Image.asset(
                          //               ImageResource.instance.paymentRefund,
                          //               color: ColorResource.white,
                          //               height: 18,
                          //             ),
                          //             const SizedBox(
                          //               width:
                          //                   DimensionResource.paddingSizeSmall,
                          //             ),
                          //             const Text(
                          //               '100% refund policy for 2 days',
                          //               style: TextStyle(
                          //                   fontWeight: FontWeight.w600,
                          //                   fontSize: DimensionResource
                          //                       .fontSizeSmall),
                          //             ),
                          //           ],
                          //         ),
                          //         const SizedBox(
                          //             height: DimensionResource
                          //                 .paddingSizeExtraSmall),
                          //         const Row(
                          //           mainAxisAlignment: MainAxisAlignment.end,
                          //           children: [
                          //             Icon(
                          //               Icons.security_sharp,
                          //               color: ColorResource.white,
                          //               size: DimensionResource.fontSizeDefault,
                          //             ),
                          //             SizedBox(
                          //               width: DimensionResource
                          //                   .paddingSizeExtraSmall,
                          //             ),
                          //             Text(
                          //               'Secure Payments',
                          //               style: TextStyle(
                          //                   fontSize: DimensionResource
                          //                       .fontSizeExtraSmall),
                          //             ),
                          //           ],
                          //         )
                          //       ],
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      Visibility(
                        visible: controller.isBuyLoading.value,
                        child: Container(
                          color: ColorResource.white.withOpacity(0.4),
                          child: const CommonCircularIndicator(),
                        ),
                      )
                    ],
                  ),
          )),
    );
  }

  Widget iconTitleBuild(banner.Datum dataAtIndex,
      {required bool isCurrentBanner, required bool isLast}) {
    return Padding(
      padding: EdgeInsets.only(right: isLast ? 0 : 5.0),
      child: SizedBox(
        height: 52,
        width: 55,
        child: Column(
          children: [
            Container(
              height: 26,
              width: 26,
              decoration: BoxDecoration(
                  color: Colors.transparent,
                  shape: BoxShape.circle,
                  border: Border.all(
                      width: 1.3,
                      color: isCurrentBanner
                          ? ColorResource.white
                          : ColorResource.white.withOpacity(0.4))),
              padding: const EdgeInsets.all(3),
              child: ClipRRect(
                  borderRadius: BorderRadius.circular(30),
                  child: cachedNetworkImage(dataAtIndex.icon ?? "")),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              dataAtIndex.iconTitle ?? "",
              style: StyleResource.instance.styleRegular(
                  fontSize: DimensionResource.fontSizeSmall - 2.5,
                  color: isCurrentBanner
                      ? ColorResource.white
                      : ColorResource.white.withOpacity(0.4)),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }

  Widget textRow(
    String title,
    String price, {
    bool isShowNegative = false,
    Color? textColor,
    TextStyle? styleTitle,
    TextStyle? style,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: DimensionResource.marginSizeDefault,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: styleTitle ??
                StyleResource.instance.styleRegular(
                    color: textColor ?? ColorResource.textColor_8,
                    fontSize: DimensionResource.fontSizeSmall),
          ),
          Text(
            isShowNegative ? "- ₹ $price" : "₹ $price",
            style: style ??
                StyleResource.instance.styleRegular(
                    color: textColor ?? ColorResource.textColor_8,
                    fontSize: DimensionResource.fontSizeSmall),
          ),
        ],
      ),
    );
  }

  Widget subscriptionBox2({
    String? afterOfferPrice,
    required bool isSelected,
    required bool isStandard,
    required bool isApplied,
    required plan.Datum data,
    required bool showEffectivePrice,
    required BuildContext context,
  }) {
    String price = (double.parse(data.price.toString()) -
            double.parse(
                afterOfferPrice == null ? "0" : afterOfferPrice.toString()))
        .toString();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? ColorResource.white : ColorResource.mateBlack,
          image: DecorationImage(
              image: AssetImage(isSelected
                  ? ImageResource.instance.unSelectedSubscriptionBoxBG
                  : ImageResource.instance.selectedSubscriptionBoxBG))),
      margin: const EdgeInsets.symmetric(
        horizontal: DimensionResource.marginSizeDefault,
      ),
      child: Stack(
        children: [
          IntrinsicHeight(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeSmall,
                vertical: DimensionResource.marginSizeDefault,
              ), // DimensionResource.marginSizeDefault),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: Get.width * 0.5),
                    child: Text(
                      data.title ?? "",
                      style: StyleResource.instance.styleSemiBold(
                          color: isSelected
                              ? ColorResource.primaryColor
                              : ColorResource.white,
                          fontSize: DimensionResource.fontSizeDefault + 0),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "₹${data.price}".seperateWithCommas,
                            style: StyleResource.instance
                                .styleSemiBold(
                                    color: isSelected
                                        ? ColorResource.primaryColor
                                        : ColorResource.white,
                                    fontSize: isApplied && afterOfferPrice != ""
                                        ? DimensionResource.fontSizeDefault - 1
                                        : DimensionResource.fontSizeExtraLarge -
                                            2)
                                .copyWith(
                                    decoration:
                                        isApplied && afterOfferPrice != ""
                                            ? TextDecoration.lineThrough
                                            : TextDecoration.none),
                          ),
                          Visibility(
                              visible: isApplied && afterOfferPrice != "",
                              child: Text(
                                "₹$price",
                                style: StyleResource.instance.styleSemiBold(
                                    color: isSelected
                                        ? ColorResource.primaryColor
                                        : ColorResource.white,
                                    fontSize:
                                        DimensionResource.fontSizeExtraLarge -
                                            2),
                              )),
                          // Visibility(
                          //     visible: showEffectivePrice,
                          //     child: Text(
                          //       "Effectively ₹400/month",
                          //       style: StyleResource.instance.styleRegular(
                          //           fontSize: DimensionResource.fontSizeSmall - 2,
                          //           color: isSelected
                          //               ? ColorResource.primaryColor
                          //               : ColorResource.white),
                          //     ))
                        ],
                      ),
                      const SizedBox(
                        width: 5,
                      ),
                      InkWell(
                        onTap: () {
                          ProgressDialog().showInforDialog(
                            description: data.description,
                            context: context,
                          );
                        },
                        child: const Icon(
                          Icons.info_outlined,
                          color: ColorResource.primaryColor,
                          size: 19,
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
          Visibility(
            visible: isStandard,
            child: Positioned(
                bottom: 0,
                right: 0,
                child: Stack(
                  children: [
                    Image.asset(
                      ImageResource.instance.bottomTriangle,
                      height: 28,
                      color: isSelected
                          ? ColorResource.primaryColor
                          : ColorResource.white,
                    ),
                    Positioned(
                        bottom: 5,
                        right: 4,
                        child: Image.asset(
                          ImageResource.instance.starIcon,
                          height: 8,
                        ))
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget subscriptionBox({
    required SubscriptionController controller,
    Duration animateDuration = const Duration(milliseconds: 300),
    String? afterOfferPrice,
    required bool isSelected,
    required bool isStandard,
    required bool isApplied,
    required plan.Datum data,
    required bool showEffectivePrice,
    required BuildContext context,
  }) {
    int price = (double.parse(data.price.toString()) -
            double.parse(
                afterOfferPrice == null ? "0" : afterOfferPrice.toString()))
        .toInt();
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(8),
          color: isSelected ? ColorResource.white : ColorResource.mateBlack,
          image: DecorationImage(
              image: AssetImage(isSelected
                  ? ImageResource.instance.unSelectedSubscriptionBoxBG
                  : ImageResource.instance.selectedSubscriptionBoxBG))),
      margin: const EdgeInsets.symmetric(
        horizontal: DimensionResource.marginSizeDefault,
      ),
      child: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(
                  DimensionResource.marginSizeSmall,
                  DimensionResource.marginSizeDefault,
                  DimensionResource.marginSizeSmall,
                  data.subBatch != null && isSelected
                      ? 0
                      : DimensionResource.marginSizeSmall,
                ), // DimensionResource.marginSizeDefault),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: Get.width * 0.5),
                      child: Text(
                        data.title ?? "",
                        style: StyleResource.instance.styleSemiBold(
                            color: isSelected
                                ? ColorResource.primaryColor
                                : ColorResource.white,
                            fontSize: DimensionResource.fontSizeDefault - 1),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "₹${data.price}",
                              style: TextStyle(
                                      color: isSelected
                                          ? ColorResource.primaryColor
                                          : ColorResource.white,
                                      fontWeight: FontWeight.w600,
                                      fontSize: isApplied &&
                                              afterOfferPrice != ""
                                          ? DimensionResource.fontSizeDefault -
                                              1
                                          : DimensionResource.fontSizeLarge - 1)
                                  .copyWith(
                                      decoration:
                                          isApplied && afterOfferPrice != ""
                                              ? TextDecoration.lineThrough
                                              : TextDecoration.none),
                            ),
                            Visibility(
                                visible: isApplied && afterOfferPrice != "",
                                child: Text(
                                  "₹$price",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: isSelected
                                          ? ColorResource.primaryColor
                                          : ColorResource.white,
                                      fontSize:
                                          DimensionResource.fontSizeLarge - 1),
                                )),
                          ],
                        ),
                        const SizedBox(width: 5),
                        InkWell(
                          onTap: () {
                            ProgressDialog().showInforDialog(
                                description: data.description,
                                context: context);
                          },
                          child: const Icon(
                            Icons.info_outlined,
                            color: ColorResource.primaryColor,
                            size: 19,
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
              AnimatedContainer(
                  margin: const EdgeInsets.only(
                      bottom: DimensionResource.paddingSizeExtraSmall),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(
                          DimensionResource.borderRadiusDefault)),
                  duration: animateDuration,
                  height: data.subBatch != null && isSelected ? 45 : 0,
                  alignment: Alignment.centerLeft,
                  child: AnimatedOpacity(
                    opacity: isSelected ? 1 : 0,
                    duration: Duration(
                        milliseconds:
                            (animateDuration.inMilliseconds * 0.5).toInt()),
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: List.generate(
                            data.subBatch?.length ?? 0,
                            (index) => RadioMenuButton(
                                style: ButtonStyle(
                                    shape: MaterialStatePropertyAll(
                                        RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                DimensionResource
                                                    .borderRadiusDefault)))),
                                value: data.subBatch?[index].id,
                                groupValue: controller.selectedSubBatch.value,
                                onChanged: (value) {
                                  controller.selectedSubBatch.value =
                                      value ?? 0;
                                  controller.batchDateId =
                                      data.subBatch?[index].id;
                                  debugPrint(
                                      'subscription: subBatch id ${controller.batchDateId}');
                                },
                                child: Text(
                                  AppConstants.formatSmallDate(DateTime.parse(
                                      data.subBatch?[index].startDate ?? '')),
                                  style: const TextStyle(
                                      color: ColorResource.primaryColor,
                                      fontWeight: FontWeight.w600,
                                      fontSize:
                                          DimensionResource.fontSizeDefault -
                                              1),
                                ))),
                      ),
                    ),
                  )),
            ],
          ),
          Visibility(
            visible: isStandard,
            child: Positioned(
                bottom: 0,
                right: 0,
                child: Stack(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(
                              DimensionResource.borderRadiusDefault)),
                      child: Image.asset(
                        ImageResource.instance.bottomTriangle,
                        height: 27,
                        color: isSelected
                            ? ColorResource.primaryColor
                            : ColorResource.white,
                      ),
                    ),
                    Positioned(
                        bottom: 5,
                        right: 4,
                        child: Image.asset(
                          ImageResource.instance.starIcon,
                          height: 8,
                        ))
                  ],
                )),
          )
        ],
      ),
    );
  }

  Widget roundedBox(Color color) {
    double size = 5;
    return Container(
      height: size,
      width: size,
      margin: const EdgeInsets.all(16),
      decoration:
          BoxDecoration(color: color, borderRadius: BorderRadius.circular(20)),
    );
  }
}

class SpecialOfferBox extends GetView<SubscriptionController> {
  const SpecialOfferBox({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: ColorResource.offerColor,
      ),
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeSmall,
          vertical: DimensionResource.marginSizeDefault),
      margin: const EdgeInsets.symmetric(
        horizontal: DimensionResource.marginSizeDefault,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Expanded(
                child: Text(
              StringResource.specialSale,
              style: StyleResource.instance.styleBold(
                  color: ColorResource.white,
                  fontSize: DimensionResource.fontSizeLarge + 0.4),
            )),
            const VerticalDivider(
              color: ColorResource.borderColor,
              thickness: 0.5,
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(() {
                    return TimerCountDown(
                      timeInSeconds: (controller
                                  .specialOfferData.value.data?.expiredAt
                                  ?.difference(DateTime.now())
                                  .inSeconds
                                  .isGreaterThan(0)) ??
                              false
                          ? controller.specialOfferData.value.data?.expiredAt
                                  ?.difference(DateTime.now())
                                  .inSeconds ??
                              5
                          : 0,
                      isHrs: true,
                      isHrShow: false,
                      fontStyle: StyleResource.instance.styleBold(
                          fontSize: DimensionResource.fontSizeDefault + 1,
                          color: ColorResource.white),
                      remainingSeconds: (second) {
                        // EasyDebounce.debounce(
                        //     controller.countValue.value.toString(), const Duration(milliseconds: 1000),
                        //         () async {
                        //
                        //
                        //     });
                        // logPrint(second);
                      },
                    );
                  }),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Text(
                        "hr",
                        style: StyleResource.instance.styleRegular(
                            color: ColorResource.white,
                            fontSize: DimensionResource.fontSizeSmall + 1),
                      ),
                      Text(
                        "min",
                        style: StyleResource.instance.styleRegular(
                            color: ColorResource.white,
                            fontSize: DimensionResource.fontSizeSmall + 1),
                      ),
                      Text(
                        "sec",
                        style: StyleResource.instance.styleRegular(
                            color: ColorResource.white,
                            fontSize: DimensionResource.fontSizeSmall + 1),
                      )
                    ],
                  )
                ],
              ),
            ),
            const VerticalDivider(
              color: ColorResource.borderColor,
              thickness: 0.5,
            ),
            Expanded(
                child: InkWell(
              onTap: () {
                controller.selectedOffer.value = offer.Datum.fromJson(
                    controller.specialOfferData.value.data?.toJson() ?? {});
                controller.offerController.value.text =
                    controller.specialOfferData.value.data?.code ?? "";
                controller.onApplyCoupon();
              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.specialOfferData.value.data?.discountType ==
                            "Amount"
                        ? "upTo\n₹${controller.specialOfferData.value.data?.discountValue} OFF"
                        : "FLAT ${controller.specialOfferData.value.data?.discountValue}% OFF",
                    style: StyleResource.instance.styleSemiBold(
                        color: ColorResource.white,
                        fontSize: DimensionResource.fontSizeDefault - 1),
                    textAlign: TextAlign.center,
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeExtraSmall,
                  ),
                  Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4),
                          color: ColorResource.primaryColor),
                      child: Container(
                          clipBehavior: Clip.antiAliasWithSaveLayer,
                          decoration: const BoxDecoration(
                              color: ColorResource.white,
                              borderRadius: BorderRadius.only(
                                topRight: Radius.circular(4),
                                bottomRight: Radius.circular(4),
                              )),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 4, vertical: 5),
                          margin: const EdgeInsets.only(left: 5),
                          child: Text(
                            controller.specialOfferData.value.data?.code
                                    ?.toUpperCase() ??
                                "",
                            style: StyleResource.instance.styleMedium(
                                fontSize: DimensionResource.fontSizeSmall - 3),
                          ))),
                ],
              ),
            ))
          ],
        ),
      ),
    );
  }
}

Widget couponCodeContainer(offer.Datum data,
    {bool isOfferView = false,
    required SubscriptionController controller,
    bool? isMentorship}) {
  print("sdlkfhkjsdhfkjhl : ${data}");
  print("sdlkfhkjsdhfkjhl : ${isMentorship}");
  return Padding(
    padding: const EdgeInsets.symmetric(
        horizontal: DimensionResource.marginSizeDefault),
    child: InkWell(
      onTap: () {
        // if (Get.find<AuthService>().isGuestUser.value) {
        //   ProgressDialog().showFlipDialog(isForPro: false);
        // }
        // else {
        if (controller.appliedOffer.value.data?.id != data.id) {
          controller.selectedOffer.value = data;
          controller.offerController.value.text = data.code ?? "";
          isMentorship == true
              ? controller.onApplyMentorShipCoupon()
              : controller.onApplyCoupon();
          if (isOfferView) {
            Get.back();
          }
        } else {
          toastShow(message: StringResource.alreadyApplied);
        }
        // }
      },
      child: IntrinsicHeight(
        child: Row(
          children: [
            SizedBox(
              height: 70,
              width: 55,
              child: Stack(
                children: [
                  Positioned(
                    left: 0,
                    right: 0,
                    top: 0,
                    bottom: 0,
                    child: Image.asset(
                      ImageResource.instance.offerBg,
                      color: ColorResource.white,
                      height: 70,
                      width: 55,
                      fit: BoxFit.fill,
                    ),
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Text(
                      data.discountType == "Amount"
                          ? "upTo\n₹${data.discountValue}\nOFF"
                          : "${data.discountValue}%\nOFF",
                      style: StyleResource.instance.styleSemiBold(
                          fontSize: DimensionResource.fontSizeSmall),
                      textAlign: TextAlign.center,
                      maxLines: 3,
                    ),
                  )
                ],
              ),
            ),
            Expanded(
                child: Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: DimensionResource.marginSizeSmall),
              color: ColorResource.mateBlack,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        data.code ?? "",
                        style: StyleResource.instance
                            .styleSemiBold(color: ColorResource.white),
                      ),
                      Text(
                        controller.appliedOffer.value.data?.id == data.id
                            ? StringResource.applied
                            : StringResource.select,
                        style: StyleResource.instance
                            .styleSemiBold(color: ColorResource.mateGreenColor),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeExtraSmall - 1,
                  ),
                  Text(
                    "${data.description}",
                    // "Use code ${data.code ?? ""} & get ${data.discountType == "Amount" ? "upTo ₹${data.discountValue} OFF" : "${data.discountValue} % off"} on this subscription",
                    style: StyleResource.instance.styleRegular(
                        color: ColorResource.subTextColorLight,
                        fontSize: DimensionResource.fontSizeSmall - 1),
                  ),
                ],
              ),
            ))
          ],
        ),
      ),
    ),
  );
}

ButtonStyle _radioBtnStyle() => const ButtonStyle(
    foregroundColor: MaterialStatePropertyAll(ColorResource.white),
    iconColor: MaterialStatePropertyAll(ColorResource.white),
    shape: MaterialStatePropertyAll(RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
            Radius.circular(DimensionResource.borderRadiusDefault)))));
