import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/batch_models/all_batch_model.dart';
import 'package:stockpathshala_beta/model/models/home_data_model/home_data_model.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/widgets/live_dot.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import '../../../../../model/utils/app_constants.dart';
import '../../../../../view_model/routes/app_pages.dart';

String searchAndRemovePro(String str) {
  if (str.contains("Pro")) {
    return str.replaceAll("Pro", "");
  } else if (str.contains("PRO")) {
    return str.replaceAll("Pro", "");
  } else if (str.contains("pro")) {
    return str.replaceAll("Pro", "");
  } else {
    return str;
  }
}

Widget liveBatchTile({
  required BatchData data,
  String? sideText,
  bool isHome = false,
  Color boxBgColor = ColorResource.secondaryBlue,
  Color boxFgColor = ColorResource.white,
  Color bottomBgColor = ColorResource.secondaryColor,
  Color bottomFgColor = ColorResource.white,
  Color btnColor = ColorResource.primaryColorDark,
  Color btnTextColor = ColorResource.white,
  Color borderColor = ColorResource.secondaryColor,
  int? studentsEnrolled,
  bool isPast = false,
  required VoidCallback onExplore,
  bool? showDivider,
  bool showBottonCard = false,
  String? bottomCardUsers,
  int? bottomCardSallerHike,
  int? bottomCardOutcome,
}) {
  double bigText = 18;
  double smallText = 10;
  double contaierHeight = 150;
  double borderWidth = 2;
  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime.now();
  if (!isPast &&
      data.live_start_datetime != null &&
      data.live_end_datetime != null) {
    date1 = DateTime.parse(data.live_start_datetime!);
    date2 = DateTime.parse(data.live_end_datetime!);
  }
  bool val = (date1.isBefore(DateTime.now()) &&
      date2.isAfter(DateTime.now()) &&
      !isPast);
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    // AnimatedGradientBorder(
    //   borderSize: 0.5,
    //   glowSize: 3,
    //   gradientColors: [
    //     Color(0xFFffffff),
    //     Color(0xFFebd197),
    //     Color(0xFFbb9b49),
    //     Color(0xFFb48811),
    //     Color(0xFFa2790d),
    //   ],
    //   borderRadius: BorderRadius.all(Radius.circular(10)),
    //   child:

    // ),
    Card(
      margin: EdgeInsets.zero,
      // elevation: 10,
      child: InkWell(
        onTap: onExplore,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              fit: StackFit.passthrough,
              children: [
                Container(
                  height: contaierHeight,
                  decoration: BoxDecoration(
                      color: boxBgColor,
                      border: isHome
                          ? Border.all(width: borderWidth, color: borderColor)
                          : Border(
                              top: BorderSide(
                                  color: borderColor, width: borderWidth),
                              left: BorderSide(
                                  color: borderColor, width: borderWidth),
                              right: BorderSide(
                                  color: borderColor, width: borderWidth)),
                      borderRadius: isHome
                          ? const BorderRadius.all(Radius.circular(
                              DimensionResource.appDefaultContainerRadius))
                          : const BorderRadius.vertical(
                              top: Radius.circular(
                                  DimensionResource.appDefaultContainerRadius),
                            )),
                  padding: const EdgeInsets.only(
                      left: DimensionResource.paddingSizeSmall),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: isHome ? 3 : 2,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: DimensionResource.marginSizeSmall),
                              padding: const EdgeInsets.only(
                                  bottom:
                                      DimensionResource.paddingExtraSizeLarge +
                                          2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (DateTime.tryParse(data.subBatch?.first
                                                        .startDate ??
                                                    '')
                                                ?.isBefore(DateTime.now()) ??
                                            false)
                                        ? isPast
                                            ? data.title ?? ''
                                            : data.title ?? ''
                                        : data.title ?? '',
                                    maxLines: 2,
                                    style: StyleResource.instance
                                        .styleBold()
                                        .copyWith(
                                            fontSize: isHome
                                                ? DimensionResource
                                                    .fontSizeDefault
                                                : DimensionResource
                                                    .fontSizeLarge,
                                            color: boxFgColor),
                                  ),
                                  const SizedBox(
                                      height: DimensionResource
                                          .marginSizeExtraSmall),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: DimensionResource
                                              .paddingSizeSmall),
                                      child: Text(
                                        data.shortDescription ?? '',
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: boxFgColor,
                                            fontSize:
                                                MediaQuery.of(Get.context!)
                                                            .size
                                                            .width <
                                                        500
                                                    ? isHome
                                                        ? 10
                                                        : 12
                                                    : 13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: isHome ? 2 : 1, child: const SizedBox())
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: SizedBox()),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: double.infinity,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: isHome
                      ? EdgeInsets.only(bottom: borderWidth, left: 5)
                      : EdgeInsets.only(left: borderWidth),
                  height: 22,
                  child: Row(
                    children: [
                      ColoredBox(
                        color: bottomBgColor,
                        child: Container(
                          width: 20,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: boxBgColor,
                              borderRadius: BorderRadius.only(
                                  bottomRight: const Radius.circular(
                                      DimensionResource.borderRadiusMedium),
                                  bottomLeft: isHome
                                      ? const Radius.circular(5)
                                      : Radius.zero)),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(
                                      DimensionResource.borderRadiusMedium)),
                              color: bottomBgColor),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: DimensionResource.paddingSizeSmall),
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.date_range,
                                //   color: bottomFgColor,
                                //   size: bigText - 2,
                                // ),
                                // const SizedBox(width: 4),
                                Text(
                                  data.discountTextTwo ?? "",
                                  // (DateTime.tryParse(data.subBatch?.first
                                  //                     .startDate ??
                                  //                 '')
                                  //             ?.isBefore(DateTime.now()) ??
                                  //         false)
                                  //     ? isPast
                                  //         ? 'Past Batch'
                                  //         : 'Running Now'
                                  //     : data.subBatch != null
                                  //         ? 'Starting from ${AppConstants.formatSmallDate(DateTime.parse(data.subBatch?.first.startDate ?? ''))}'
                                  //         : 'Starting Shortly',
                                  style: TextStyle(
                                      fontSize: smallText,
                                      color: boxBgColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )),
                      ColoredBox(
                        color: bottomBgColor,
                        child: Container(
                          width: 20,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: boxBgColor,
                              border: Border.all(color: boxBgColor, width: 0),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      DimensionResource.borderRadiusMedium))),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: contaierHeight,
                  margin: isHome ? EdgeInsets.only(bottom: borderWidth) : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 3, child: SizedBox()),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  DimensionResource.appDefaultRadius),
                              child: cachedNetworkImage(data.image ?? '',
                                  alignment: Alignment.bottomCenter,
                                  fit: BoxFit.fitHeight)),
                        ),
                      )
                    ],
                  ),
                ),
                // (DateTime.tryParse(data.subBatch?.first.startDate ?? '')
                //             ?.isBefore(DateTime.now()) ??
                //         false)
                //     ? isPast
                //         ? Container()
                //         : LiveDot(
                //             left: 10,
                //             top: 14,
                //           )
                //     : Container()
              ],
            ),
            Visibility(
              visible: !isHome,
              child: Container(
                decoration: BoxDecoration(
                    color: bottomBgColor,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(
                            DimensionResource.appDefaultContainerRadius)),
                    border: Border(
                      left: BorderSide(color: borderColor, width: borderWidth),
                      bottom:
                          BorderSide(color: borderColor, width: borderWidth),
                      right: BorderSide(color: borderColor, width: borderWidth),
                    )),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(children: [
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: val ? 0 : 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  val
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              LiveDot(
                                                left: 0,
                                                top: 4, height: 40, width: 40,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 6, right: 6),
                                                decoration: const BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    shape: BoxShape.rectangle),
                                                child: Text(
                                                  "LIVE NOW",
                                                  style: StyleResource.instance
                                                      .styleBold()
                                                      .copyWith(
                                                          color: btnTextColor,
                                                          fontSize:
                                                              bigText - 2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              // searchAndRemovePro(data.discountText!),
                                              data.discountText ?? "",
                                              style: StyleResource.instance
                                                  .styleBold()
                                                  .copyWith(
                                                      // Prev Code
                                                      // fontSize: DimensionResource.fontSizeLarge,
                                                      fontSize: DimensionResource
                                                          .fontSizeExtraSmall,
                                                      color: bottomFgColor),
                                            ),
                                            // data.discountText!.contains("Pro")
                                            //     ? Text(
                                            //         'Pro',
                                            //         style: StyleResource.instance
                                            //             .styleBold()
                                            //             .copyWith(
                                            //                 // Prev Code
                                            //                 // fontSize: DimensionResource.fontSizeLarge,
                                            //                 fontSize:
                                            //                     DimensionResource
                                            //                         .fontSizeSmall,
                                            //                 color: ColorResource
                                            //                     .goldenColor),
                                            //       )
                                            //     : const SizedBox()
                                          ],
                                        )
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       '₹${data.discountPrice ?? 0}',
                                  //       style: StyleResource.instance
                                  //           .styleMedium()
                                  //           .copyWith(
                                  //               color: bottomFgColor,
                                  //               fontSize: DimensionResource
                                  //                       .fontSizeDefault -
                                  //                   1),
                                  //     ),
                                  //     const SizedBox(width: 8),
                                  //     Text(
                                  //       '₹${data.actualPrice ?? 0}',
                                  //       style: StyleResource.instance
                                  //           .styleMedium()
                                  //           .copyWith(
                                  //               color:
                                  //                   bottomFgColor.withOpacity(.5),
                                  //               decorationThickness: 2,
                                  //               decorationColor:
                                  //                   bottomFgColor.withOpacity(.5),
                                  //               decoration:
                                  //                   TextDecoration.lineThrough,
                                  //               fontSize: DimensionResource
                                  //                   .fontSizeSmall),
                                  //     )
                                  //   ],
                                  // ),
                                ],
                              )),
                        ),
                        Expanded(
                          child: _roundedButton(
                              margin: data.discountText == null
                                  ? const EdgeInsets.only(top: 3)
                                  : null,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              border: Border.all(color: ColorResource.grey),
                              onPressed: onExplore,
                              backgroundcolor: btnColor,
                              child: Text(
                                'view batch'.toUpperCase(),
                                style: StyleResource.instance
                                    .styleBold()
                                    .copyWith(
                                        color: btnTextColor,
                                        fontSize: bigText - 2),
                              )),
                        ),
                      ]),
                    ),
                    if (sideText != null)
                      _roundedButton(
                          radius: 10,
                          onPressed: null,
                          backgroundcolor: ColorResource.greenDarkContainer,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.discount,
                                size: 14,
                                color: ColorResource.greenDarkColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  sideText,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: smallText,
                                      color: ColorResource.greenDarkColor),
                                ),
                              ),
                            ],
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    if (showBottonCard &&
        bottomCardUsers != null &&
        bottomCardSallerHike != null &&
        bottomCardOutcome != null) ...[
      _bottomCard(
          users: bottomCardUsers,
          hikePerc: bottomCardSallerHike,
          outcomePrec: bottomCardOutcome),
      const SizedBox(height: 8)
    ] else if (showDivider ?? false) ...[
      const SizedBox(height: 10),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(
          thickness: 2,
          color: ColorResource.grey_2,
        ),
      )
    ]
  ]);
}

Widget homeTiling({
  required HomeDataModelDatum data,
  int index = 0,
  String? sideText,
  bool isHome = false,
  Color boxBgColor = ColorResource.secondaryBlue,
  Color boxFgColor = ColorResource.white,
  Color bottomBgColor = ColorResource.secondaryColor,
  Color bottomFgColor = ColorResource.white,
  Color btnColor = ColorResource.primaryColorDark,
  Color btnTextColor = ColorResource.white,
  Color borderColor = ColorResource.secondaryColor,
  int? studentsEnrolled,
  bool isPast = false,
  required VoidCallback onExplore,
  bool? showDivider,
  bool showBottonCard = false,
  String? bottomCardUsers,
  int? bottomCardSallerHike,
  int? bottomCardOutcome,
}) {
  double bigText = 18;
  double smallText = 10;
  double contaierHeight = 150;
  double borderWidth = 2;
  DateTime date1 = DateTime.now();
  DateTime date2 = DateTime.now();
  if (!isPast &&
      data.data![index].startDate != null &&
      data.data![index].endDate != null) {
    date1 = DateTime.parse(data.data![index].startDate.toString());
    date2 = DateTime.parse(data.data![index].endDate.toString());
  }
  bool val = (date1.isBefore(DateTime.now()) &&
      date2.isAfter(DateTime.now()) &&
      !isPast);
  return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
    // AnimatedGradientBorder(
    //   borderSize: 0.5,
    //   glowSize: 3,
    //   gradientColors: [
    //     Color(0xFFffffff),
    //     Color(0xFFebd197),
    //     Color(0xFFbb9b49),
    //     Color(0xFFb48811),
    //     Color(0xFFa2790d),
    //   ],
    //   borderRadius: BorderRadius.all(Radius.circular(10)),
    //   child:

    // ),
    Card(
      margin: EdgeInsets.zero,
      // elevation: 10,
      child: InkWell(
        onTap: onExplore,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              fit: StackFit.passthrough,
              children: [
                Container(
                  height: contaierHeight,
                  decoration: BoxDecoration(
                      color: boxBgColor,
                      border: isHome
                          ? Border.all(width: borderWidth, color: borderColor)
                          : Border(
                              top: BorderSide(
                                  color: borderColor, width: borderWidth),
                              left: BorderSide(
                                  color: borderColor, width: borderWidth),
                              right: BorderSide(
                                  color: borderColor, width: borderWidth)),
                      borderRadius: isHome
                          ? const BorderRadius.all(Radius.circular(
                              DimensionResource.appDefaultContainerRadius))
                          : const BorderRadius.vertical(
                              top: Radius.circular(
                                  DimensionResource.appDefaultContainerRadius),
                            )),
                  padding: const EdgeInsets.only(
                      left: DimensionResource.paddingSizeSmall),
                  child: Stack(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: isHome ? 3 : 2,
                            child: Container(
                              margin: const EdgeInsets.only(
                                  top: DimensionResource.marginSizeSmall),
                              padding: const EdgeInsets.only(
                                  bottom:
                                      DimensionResource.paddingExtraSizeLarge +
                                          2),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    (DateTime.tryParse(data
                                                        .data![index]
                                                        .batchSubBatches
                                                        ?.first
                                                        .startDate ??
                                                    '')
                                                ?.isBefore(DateTime.now()) ??
                                            false)
                                        ? isPast
                                            ? data.data![index].title ?? ''
                                            : data.data![index].title ?? ''
                                        : data.data![index].title ?? '',
                                    maxLines: 2,
                                    style: StyleResource.instance
                                        .styleBold()
                                        .copyWith(
                                            fontSize: isHome
                                                ? DimensionResource
                                                    .fontSizeDefault
                                                : DimensionResource
                                                    .fontSizeLarge,
                                            color: boxFgColor),
                                  ),
                                  const SizedBox(
                                      height: DimensionResource
                                          .marginSizeExtraSmall),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: DimensionResource
                                              .paddingSizeSmall),
                                      child: Text(
                                        data.data![index].batchDetails ?? '',
                                        overflow: TextOverflow.fade,
                                        style: TextStyle(
                                            fontWeight: FontWeight.w500,
                                            color: boxFgColor,
                                            fontSize:
                                                MediaQuery.of(Get.context!)
                                                            .size
                                                            .width <
                                                        500
                                                    ? isHome
                                                        ? 10
                                                        : 12
                                                    : 13),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: isHome ? 2 : 1, child: const SizedBox())
                        ],
                      ),
                      const Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(flex: 3, child: SizedBox()),
                          Expanded(
                            flex: 2,
                            child: SizedBox(
                              height: double.infinity,
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: isHome
                      ? EdgeInsets.only(bottom: borderWidth, left: 5)
                      : EdgeInsets.only(left: borderWidth),
                  height: 22,
                  child: Row(
                    children: [
                      ColoredBox(
                        color: bottomBgColor,
                        child: Container(
                          width: 20,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: boxBgColor,
                              borderRadius: BorderRadius.only(
                                  bottomRight: const Radius.circular(
                                      DimensionResource.borderRadiusMedium),
                                  bottomLeft: isHome
                                      ? const Radius.circular(5)
                                      : Radius.zero)),
                        ),
                      ),
                      Container(
                          decoration: BoxDecoration(
                              borderRadius: const BorderRadius.vertical(
                                  top: Radius.circular(
                                      DimensionResource.borderRadiusMedium)),
                              color: bottomBgColor),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 4,
                                horizontal: DimensionResource.paddingSizeSmall),
                            child: Row(
                              children: [
                                // Icon(
                                //   Icons.date_range,
                                //   color: bottomFgColor,
                                //   size: bigText - 2,
                                // ),
                                // const SizedBox(width: 4),
                                Text(
                                  data.data![index].batchDiscountText ?? "",
                                  // (DateTime.tryParse(data.subBatch?.first
                                  //                     .startDate ??
                                  //                 '')
                                  //             ?.isBefore(DateTime.now()) ??
                                  //         false)
                                  //     ? isPast
                                  //         ? 'Past Batch'
                                  //         : 'Running Now'
                                  //     : data.subBatch != null
                                  //         ? 'Starting from ${AppConstants.formatSmallDate(DateTime.parse(data.subBatch?.first.startDate ?? ''))}'
                                  //         : 'Starting Shortly',
                                  style: TextStyle(
                                      fontSize: smallText,
                                      color: boxBgColor,
                                      fontWeight: FontWeight.w600),
                                ),
                              ],
                            ),
                          )),
                      ColoredBox(
                        color: bottomBgColor,
                        child: Container(
                          width: 20,
                          height: double.infinity,
                          decoration: BoxDecoration(
                              color: boxBgColor,
                              border: Border.all(color: boxBgColor, width: 0),
                              borderRadius: const BorderRadius.only(
                                  bottomLeft: Radius.circular(
                                      DimensionResource.borderRadiusMedium))),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: contaierHeight,
                  margin: isHome ? EdgeInsets.only(bottom: borderWidth) : null,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Expanded(flex: 3, child: SizedBox()),
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: double.infinity,
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(
                                  DimensionResource.appDefaultRadius),
                              child: cachedNetworkImage(
                                  data.data![index].image ?? '',
                                  alignment: Alignment.bottomCenter,
                                  fit: BoxFit.fitHeight)),
                        ),
                      )
                    ],
                  ),
                ),
                // (DateTime.tryParse(data.subBatch?.first.startDate ?? '')
                //             ?.isBefore(DateTime.now()) ??
                //         false)
                //     ? isPast
                //         ? Container()
                //         : LiveDot(
                //             left: 10,
                //             top: 14,
                //           )
                //     : Container()
              ],
            ),
            Visibility(
              visible: !isHome,
              child: Container(
                decoration: BoxDecoration(
                    color: bottomBgColor,
                    borderRadius: const BorderRadius.vertical(
                        bottom: Radius.circular(
                            DimensionResource.appDefaultContainerRadius)),
                    border: Border(
                      left: BorderSide(color: borderColor, width: borderWidth),
                      bottom:
                          BorderSide(color: borderColor, width: borderWidth),
                      right: BorderSide(color: borderColor, width: borderWidth),
                    )),
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: Row(children: [
                        Expanded(
                          child: Padding(
                              padding: EdgeInsets.only(left: val ? 0 : 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  val
                                      ? Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              LiveDot(
                                                left: 0,
                                                top: 4,height: 40, width: 40,
                                              ),
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    left: 6, right: 6),
                                                decoration: const BoxDecoration(
                                                    color: Colors.redAccent,
                                                    borderRadius:
                                                        BorderRadius.all(
                                                            Radius.circular(4)),
                                                    shape: BoxShape.rectangle),
                                                child: Text(
                                                  "LIVE NOW",
                                                  style: StyleResource.instance
                                                      .styleBold()
                                                      .copyWith(
                                                          color: btnTextColor,
                                                          fontSize:
                                                              bigText - 2),
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                      : Row(
                                          children: [
                                            Text(
                                              // searchAndRemovePro(data.discountText!),
                                              data.data![index].batchDiscount
                                                      .toString() ??
                                                  "",
                                              style: StyleResource.instance
                                                  .styleBold()
                                                  .copyWith(
                                                      // Prev Code
                                                      // fontSize: DimensionResource.fontSizeLarge,
                                                      fontSize: DimensionResource
                                                          .fontSizeExtraSmall,
                                                      color: bottomFgColor),
                                            ),
                                            // data.discountText!.contains("Pro")
                                            //     ? Text(
                                            //         'Pro',
                                            //         style: StyleResource.instance
                                            //             .styleBold()
                                            //             .copyWith(
                                            //                 // Prev Code
                                            //                 // fontSize: DimensionResource.fontSizeLarge,
                                            //                 fontSize:
                                            //                     DimensionResource
                                            //                         .fontSizeSmall,
                                            //                 color: ColorResource
                                            //                     .goldenColor),
                                            //       )
                                            //     : const SizedBox()
                                          ],
                                        )
                                  // Row(
                                  //   children: [
                                  //     Text(
                                  //       '₹${data.discountPrice ?? 0}',
                                  //       style: StyleResource.instance
                                  //           .styleMedium()
                                  //           .copyWith(
                                  //               color: bottomFgColor,
                                  //               fontSize: DimensionResource
                                  //                       .fontSizeDefault -
                                  //                   1),
                                  //     ),
                                  //     const SizedBox(width: 8),
                                  //     Text(
                                  //       '₹${data.actualPrice ?? 0}',
                                  //       style: StyleResource.instance
                                  //           .styleMedium()
                                  //           .copyWith(
                                  //               color:
                                  //                   bottomFgColor.withOpacity(.5),
                                  //               decorationThickness: 2,
                                  //               decorationColor:
                                  //                   bottomFgColor.withOpacity(.5),
                                  //               decoration:
                                  //                   TextDecoration.lineThrough,
                                  //               fontSize: DimensionResource
                                  //                   .fontSizeSmall),
                                  //     )
                                  //   ],
                                  // ),
                                ],
                              )),
                        ),
                        Expanded(
                          child: _roundedButton(
                              margin:
                                  data.data![index].batchDiscount.toString() ==
                                          null
                                      ? const EdgeInsets.only(top: 3)
                                      : null,
                              padding: const EdgeInsets.symmetric(vertical: 4),
                              border: Border.all(color: ColorResource.grey),
                              onPressed: onExplore,
                              backgroundcolor: btnColor,
                              child: Text(
                                'view batch'.toUpperCase(),
                                style: StyleResource.instance
                                    .styleBold()
                                    .copyWith(
                                        color: btnTextColor,
                                        fontSize: bigText - 2),
                              )),
                        ),
                      ]),
                    ),
                    if (sideText != null)
                      _roundedButton(
                          radius: 10,
                          onPressed: null,
                          backgroundcolor: ColorResource.greenDarkContainer,
                          child: Row(
                            children: [
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.discount,
                                size: 14,
                                color: ColorResource.greenDarkColor,
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  sideText,
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: smallText,
                                      color: ColorResource.greenDarkColor),
                                ),
                              ),
                            ],
                          )),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    if (showBottonCard &&
        bottomCardUsers != null &&
        bottomCardSallerHike != null &&
        bottomCardOutcome != null) ...[
      _bottomCard(
          users: bottomCardUsers,
          hikePerc: bottomCardSallerHike,
          outcomePrec: bottomCardOutcome),
      const SizedBox(height: 8)
    ] else if (showDivider ?? false) ...[
      const SizedBox(height: 10),
      const Padding(
        padding: EdgeInsets.symmetric(horizontal: 16),
        child: Divider(
          thickness: 2,
          color: ColorResource.grey_2,
        ),
      )
    ]
  ]);
}

/*Widget itemCard(data) {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
              width: 400,
              child: liveBatchTile(
                  data: data,
                  boxBgColor: ColorResource.white,
                  boxFgColor: ColorResource.secondaryColor,
                  bottomBgColor: ColorResource.secondaryColor,
                  sideText: data.courseOfferTitle,
                  onExplore: () {
                    Get.toNamed(Routes.batchDetails, arguments: [data, false]);
                  },
                  studentsEnrolled:
                  int.tryParse(data.totalStudentsEnrolled ?? ''),
                  // showDivider: index !=
                  //     controller.batchData.value.data!.length - 1,
                  bottomCardUsers: '1.5 Lakh',
                  bottomCardSallerHike: 40,
                  bottomCardOutcome: 100)),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 350,
              child: liveBatchTile(
                  data: data,
                  boxBgColor: ColorResource.white,
                  boxFgColor: ColorResource.secondaryColor,
                  bottomBgColor: ColorResource.secondaryColor,
                  sideText: data.courseOfferTitle,
                  onExplore: () {
                   Get.toNamed(Routes.batchDetails, arguments: [data, false]);
                  },
                  studentsEnrolled:
                  int.tryParse(data.totalStudentsEnrolled ?? ''),
                  // showDivider: index !=
                  //     controller.batchData.value.data!.length - 1,
                  bottomCardUsers: '1.5 Lakh',
                  bottomCardSallerHike: 40,
                  bottomCardOutcome: 100)
          ),
        ],
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: 500,
        child: _bottomCard(users: '1.5 Lakh', hikePerc: 40, outcomePrec: 100),
      ),
    ],
  );
}*/

Widget itemCard(BatchData firstData, BatchData? secondData) {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
            width: 400,
            child: liveBatchTile(
              data: firstData,
              boxBgColor: ColorResource.white,
              boxFgColor: ColorResource.secondaryColor,
              bottomBgColor: ColorResource.secondaryColor,
              sideText: firstData.courseOfferTitle,
              onExplore: () {
                Get.toNamed(Routes.batchDetails, arguments: [firstData, false]);
              },
              studentsEnrolled:
                  int.tryParse(firstData.totalStudentsEnrolled ?? ''),
              bottomCardUsers: '1.5 Lakh',
              bottomCardSallerHike: 40,
              bottomCardOutcome: 100,
            ),
          ),
          const SizedBox(width: 20),
          if (secondData != null)
            SizedBox(
              width: 350,
              child: liveBatchTile(
                data: secondData,
                boxBgColor: ColorResource.white,
                boxFgColor: ColorResource.secondaryColor,
                bottomBgColor: ColorResource.secondaryColor,
                sideText: secondData.courseOfferTitle,
                onExplore: () {
                  print('sdefsdf');
                  Get.toNamed(Routes.batchDetails,
                      arguments: [secondData, false]);
                },
                studentsEnrolled:
                    int.tryParse(secondData.totalStudentsEnrolled ?? ''),
                bottomCardUsers: '1.5 Lakh',
                bottomCardSallerHike: 40,
                bottomCardOutcome: 100,
              ),
            ),
        ],
      ),
      const SizedBox(height: 20),
      SizedBox(
        width: 500,
        child: _bottomCard(users: '1.5 Lakh', hikePerc: 40, outcomePrec: 100),
      ),
    ],
  );
}

Widget itemCardPastRecording(data) {
  return Column(
    children: [
      Row(
        children: [
          SizedBox(
              width: 400,
              child: liveBatchTile(
                  data: data,
                  boxBgColor: ColorResource.white,
                  boxFgColor: ColorResource.secondaryColor,
                  bottomBgColor: ColorResource.secondaryColor,
                  sideText: data.courseOfferTitle,
                  onExplore: () {
                    print('sdefsdf');
                    Get.toNamed(Routes.batchDetails, arguments: [data, false]);
                  },
                  studentsEnrolled:
                      int.tryParse(data.totalStudentsEnrolled ?? ''),
                  // showDivider: index !=
                  //     controller.batchData.value.data!.length - 1,
                  bottomCardUsers: '1.5 Lakh',
                  bottomCardSallerHike: 40,
                  bottomCardOutcome: 100)),
          const SizedBox(
            width: 20,
          ),
          SizedBox(
              width: 350,
              child: liveBatchTile(
                  data: data,
                  boxBgColor: ColorResource.white,
                  boxFgColor: ColorResource.secondaryColor,
                  bottomBgColor: ColorResource.secondaryColor,
                  sideText: data.courseOfferTitle,
                  onExplore: () {
                    print('sdefsdf');
                    Get.toNamed(Routes.batchDetails, arguments: [data, false]);
                  },
                  studentsEnrolled:
                      int.tryParse(data.totalStudentsEnrolled ?? ''),
                  // showDivider: index !=
                  //     controller.batchData.value.data!.length - 1,
                  bottomCardUsers: '1.5 Lakh',
                  bottomCardSallerHike: 40,
                  bottomCardOutcome: 100)),
        ],
      ),
      const SizedBox(height: 20),
    ],
  );
}

Widget _bottomCard({
  required String users,
  required int hikePerc,
  required outcomePrec,
}) {
  TextStyle smallFont = const TextStyle(
    fontSize: DimensionResource.fontSizeSmall,
  );
  TextStyle bigFont = StyleResource.instance.styleBold().copyWith(
        fontSize: DimensionResource.fontSizeLarge,
      );
  Gradient gradient = const LinearGradient(colors: [
    Colors.red,
    Colors.deepPurple,
  ]);
  return Card(
    color: ColorResource.white,
    margin: const EdgeInsets.only(top: 16),
    shape: RoundedRectangleBorder(
        side: const BorderSide(color: ColorResource.grey_3),
        borderRadius: BorderRadius.circular(8)),
    child: Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: Column(
              children: [
                GradientText(
                  '$users+',
                  gradient: gradient,
                  align: TextAlign.center,
                  style: bigFont,
                ),
                const SizedBox(height: 8),
                Text(
                  'Budding Traders'.capitalize!,
                  textAlign: TextAlign.center,
                  style: smallFont,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
            child: VerticalDivider(),
          ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                GradientText(
                  '$hikePerc+',
                  gradient: gradient,
                  align: TextAlign.center,
                  style: bigFont,
                ),
                const SizedBox(height: 8),
                Text(
                  'Verified tutors'.capitalize!,
                  textAlign: TextAlign.center,
                  style: smallFont,
                )
              ],
            ),
          ),
          const SizedBox(
            height: 50,
            child: VerticalDivider(),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                GradientText(
                  '$outcomePrec+',
                  gradient: gradient,
                  align: TextAlign.center,
                  style: bigFont,
                ),
                const SizedBox(height: 8),
                Text(
                  'Batches'.capitalize!,
                  textAlign: TextAlign.center,
                  style: smallFont,
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _roundedButton(
    {double radius = 6,
    Color? backgroundcolor,
    BoxBorder? border,
    required VoidCallback? onPressed,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    required Widget child}) {
  return Container(
    margin: margin,
    padding: const EdgeInsets.all(4),
    child: InkWell(
      onTap: onPressed,
      splashColor: Colors.grey,
      child: Container(
        alignment: Alignment.center,
        padding: padding ?? const EdgeInsets.all(6),
        decoration: BoxDecoration(
            color: backgroundcolor,
            border: border,
            borderRadius: BorderRadius.circular(radius)),
        child: child,
      ),
    ),
  );
}

Widget listOfModules() {
  return _moduleTile(
      batchData: AllBatchesModal(data: [
    BatchData(
        id: 1,
        title: 'title 1',
        deletedAt: '1 hr 30 min',
        createdAt: '14 march',
        batchVideo: 'vid title',
        batchStartDate: '2.30',
        updatedAt: '3.20'),
  ]));
}

Widget _moduleTile({required AllBatchesModal batchData}) {
  return Wrap(
    children: List.generate(batchData.data!.length, (index) {
      BatchData data = batchData.data![index];
      return Container(
        height: 70,
        margin: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          children: [
            Text(
              (data.id ?? '').toString(),
              style: StyleResource.instance.styleBold().copyWith(
                  color: ColorResource.grey,
                  fontSize: DimensionResource.fontSizeExtraLarge),
            ),
            const VerticalDivider(
              color: ColorResource.primaryColor,
              thickness: 2,
            ),
            const SizedBox(
              width: 35,
              child: Center(
                child: Divider(
                  color: ColorResource.primaryColor,
                  thickness: 2,
                ),
              ),
            ),
            DecoratedBox(
                decoration: BoxDecoration(
                    border: Border.all(color: ColorResource.grey_2),
                    borderRadius: BorderRadius.circular(
                        DimensionResource.appDefaultContainerRadius)))
          ],
        ),
      );
    }),
  );
}

class GradientText extends StatelessWidget {
  const GradientText(
    this.text, {
    super.key,
    this.align,
    required this.gradient,
    this.style,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final Gradient gradient;

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => gradient.createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
        textAlign: align,
      ),
    );
  }
}
