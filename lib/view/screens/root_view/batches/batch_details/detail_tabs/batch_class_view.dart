import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:stockpathshala_beta/model/models/auth_models/sign_in.dart';
import 'package:stockpathshala_beta/model/models/batch_models/batch_details_model.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/widgets/live_dot.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/batch_controller/batch_details/detail_tabs/batch_class_view_controller.dart';
import '../../../../../../mentroship/model/mentorshipCardList_model.dart' hide Pagination;
import '../../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../../model/services/pagination.dart';
import '../../../../../../model/utils/app_constants.dart';
import '../../../../../../model/utils/color_resource.dart';
import '../../../../../../model/utils/dimensions_resource.dart';
import '../../../../../../model/utils/style_resource.dart';

import '../../../../../../enum/routing/routes/app_pages.dart';
import '../../../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../../../widgets/no_data_found/no_data_found.dart';
import '../../../../../widgets/search_widget/search_container.dart';
import '../../../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../../../../widgets/view_helpers/small_button.dart';
import '../../../home_view/widget/top_ten_widget.dart';

class BatchClassView extends StatefulWidget {
  const BatchClassView(
      {Key? key,
      required this.batchDateId,
      this.isFromNotification = false,
      this.isPast = false})
      : super(key: key);
  final int batchDateId;
  final bool isPast;
  final bool isFromNotification;

  @override
  State<BatchClassView> createState() => _BatchClassViewState();
}

class _BatchClassViewState extends State<BatchClassView> {
  BatchClassViewController controller = Get.put(BatchClassViewController());

  @override
  void initState() {
    Get.put(BatchClassViewController(), tag: 'subBatch${widget.batchDateId}');
    controller = Get.find(tag: 'subBatch${widget.batchDateId}');
    controller.isPast.value = widget.isPast;
    controller.batchDateId = widget.batchDateId;
    controller.dataPagingController = PagingScrollController<CommonDatum>(
        onLoadMore: (int page, int totalItemsCount) async {
      await controller.getBatchDetails(pageNo: page);
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    controller.dataPagingController.value.list.clear();
    controller.getBatchDetails();
    logPrint(controller.batchData?.startDate);
    super.initState();
  }

  // @override
  // void dispose() {
  //   Get.find<BatchClassViewController>(tag: 'subBatch${widget.batchDateId}')
  //       .dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;
    final padding = EdgeInsets.only(
      left: MediaQuery.of(context).size.width * 0.02, // 2% of screen width
    );
    return RefreshIndicator(
      color: ColorResource.primaryColor,
      onRefresh: controller.onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.dataPagingController.value.scrollController,
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeSmall),
        children: [
          const SizedBox(
            height: DimensionResource.marginSizeLarge,
          ),
          Obx(() {
            return controller.isSearchEnabled.value
                ? SearchWidget(
                    enableMargin: false,
                    textEditingController: controller.searchController.value,
                    onChange: controller.onClassSearch,
                    onClear: () {
                      controller.onClassSearch("");
                    },
                  )
                : SizedBox
                    .shrink(); // Use SizedBox.shrink() to hide the widget when not needed
          }),
          _videoCourseWrapList(
              batchDetailsViewController: controller, size: size),
          const SizedBox(
            height: 15,
          ),
          Obx(
            () => Visibility(

                //controller.isDataLoading.value ,
                visible: controller.isDataLoading.value,
                // controller.dataPagingController.value.isDataLoading.value,
                // ||
                //     controller.searchController.value.text.isEmpty,
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: CommonCircularIndicator(),
                )),
          ),
        ],
      ),

      // Scaffold(
      //     body:
      //     // bottomNavigationBar:

      //     //  Obx(() {
      //     //   UserSubscription? userSub =
      //     //       Get.find<AuthService>().user.value.userSubscription;

      //     //   return Visibility(
      //     //     visible: !((userSub?.batchId == controller.batchData?.id &&
      //     //             userSub?.batchStartDate == widget.batchDateId) ||
      //     //         (userSub?.pastSubscription == 1 || userSub?.superSub == 1)),
      //     //     child: Card(
      //     //         margin: const EdgeInsets.all(8),
      //     //         shape: RoundedRectangleBorder(
      //     //             borderRadius: BorderRadius.circular(8),
      //     //             side: const BorderSide(color: ColorResource.grey_3)),
      //     //         color: ColorResource.white,
      //     //         child: InkWell(
      //     //           onTap: Get.find<AuthService>().isGuestUser.value
      //     //               ? () {
      //     //                   Get.offAllNamed(Routes.loginScreen);
      //     //                 }
      //     //               : () {
      //     //                   Get.toNamed(Routes.subscriptionView,

      //     //                       /// to goto batchSubscription
      //     //                       arguments: [
      //     //                         controller.batchData?.id,
      //     //                         controller.batchDateId
      //     //                       ]);
      //     //                 },
      //     //           child: Row(
      //     //             children: [
      //     //               Expanded(
      //     //                   child: Column(
      //     //                 mainAxisSize: MainAxisSize.min,
      //     //                 children: [
      //     //                   Text(
      //     //                     'Buy batch'.toUpperCase(),
      //     //                     style: StyleResource.instance
      //     //                         .styleBold()
      //     //                         .copyWith(
      //     //                             color: ColorResource.primaryColor,
      //     //                             fontSize:
      //     //                                 DimensionResource.fontSizeExtraLarge),
      //     //                   ),
      //     //                   Text(
      //     //                     'Start building your future',
      //     //                     style: StyleResource.instance
      //     //                         .styleSemiBold()
      //     //                         .copyWith(
      //     //                             fontSize: 10,
      //     //                             color: ColorResource.greenDarkColor),
      //     //                   )
      //     //                 ],
      //     //               )),
      //     //               ElevatedButton(
      //     //                   onPressed: Get.find<AuthService>().isGuestUser.value
      //     //                       ? () => Get.offAllNamed(Routes.loginScreen)
      //     //                       : () {
      //     //                           Get.toNamed(Routes.subscriptionView,

      //     //                               /// to goto batchSubscription
      //     //                               arguments: [
      //     //                                 controller.batchData?.id,
      //     //                                 controller.batchDateId
      //     //                               ]);
      //     //                         },
      //     //                   style: ElevatedButton.styleFrom(
      //     //                       backgroundColor: ColorResource.primaryColor,
      //     //                       foregroundColor: ColorResource.white,
      //     //                       shape: RoundedRectangleBorder(
      //     //                           borderRadius: BorderRadius.circular(8))),
      //     //                   child: Column(
      //     //                     mainAxisSize: MainAxisSize.min,
      //     //                     children: [
      //     //                       Text(
      //     //                         '₹ ${controller.batchData?.discountPrice ?? ''}',
      //     //                         style: StyleResource.instance
      //     //                             .styleBold()
      //     //                             .copyWith(
      //     //                                 color: ColorResource.white,
      //     //                                 fontSize:
      //     //                                     DimensionResource.fontSizeLarge),
      //     //                       ),
      //     //                       Text(
      //     //                         '₹ ${controller.batchData?.actualPrice ?? ''}',
      //     //                         style: const TextStyle(
      //     //                             fontSize: DimensionResource.fontSizeSmall,
      //     //                             decorationColor: ColorResource.redColor,
      //     //                             decorationThickness: 2,
      //     //                             decoration: TextDecoration.lineThrough),
      //     //                       )
      //     //                     ],
      //     //                   )),
      //     //               const SizedBox(width: 4)
      //     //             ],
      //     //           ),
      //     //         )),
      //     //   );
      //     // })),
      //     )
    );
  }

  Widget _videoCourseWrapList(
      {required BatchClassViewController batchDetailsViewController,
      required Size size}) {
    return Obx(
      () {
        /// user subscription
        UserSubscription? userSub =
            Get.find<AuthService>().user.value.userSubscription;

        return batchDetailsViewController.isDataLoading.value &&
                batchDetailsViewController.searchController.value.text.isEmpty
            ? LayoutBuilder(
                builder: (context, constraints) {
                  // Check the screen width and display the appropriate shimmer effect
                  if (constraints.maxWidth < 600) {
                    // Mobile shimmer loader for smaller screens
                    return ShimmerEffect.instance
                        .upcomingLiveClassLoaderForMobile();
                  } else {
                    // Tablet shimmer loader for larger screens
                    return ShimmerEffect.instance
                        .upcomingLiveClassLoaderForTab();
                  }
                },
              )
            : batchDetailsViewController.dataPagingController.value.list.isEmpty
                ? const SizedBox(
                    height: 400,
                    child: NoDataFound(
                      showText: true,
                      text: "Batches are being Set Up for You!",
                    ))
                : LayoutBuilder(
                    builder: (context, constraints) {
                      // Check the width of the screen
                      double width = constraints.maxWidth;

                      // If the width is less than 500, show 1 tile per row
                      // If the width is greater than or equal to 500, show 2 tiles per row
                      int tilesPerRow = width < 500 ? 1 : 2;

                      return Column(
                        children: [
                          // Conditionally render the search bar widget based on `isSearchEnabled`

                          // Adding spacing between the search bar and grid view
                          SizedBox(height: 16.0), // Adjust height as needed

                          // Your grid view list
                          Wrap(
                            spacing: 24.0,
                            runSpacing: 12.0,
                            children: List.generate(
                              batchDetailsViewController
                                  .dataPagingController.value.list.length,
                              (index) {
                                CommonDatum data = batchDetailsViewController
                                    .dataPagingController.value.list[index];

                                return Container(
                                  width: (width / tilesPerRow) - 16,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: batchDetailsViewController
                                                      .dataPagingController
                                                      .value
                                                      .list
                                                      .length -
                                                  1 ==
                                              index
                                          ? DimensionResource.marginSizeDefault
                                          : 0,
                                    ),
                                    child: _liveClassesView(
                                      index,
                                      height: 160,
                                      fontSize:
                                          DimensionResource.marginSizeSmall + 3,
                                      data: data,
                                      isPast: widget.isPast,
                                      showPro: !((userSub?.batchId ==
                                                  controller.batchData?.id &&
                                              userSub?.batchStartDate ==
                                                  widget.batchDateId) ||
                                          (userSub?.pastSubscription == 1 ||
                                              userSub?.superSub == 1)),
                                      batchDetailsViewController:
                                          batchDetailsViewController,
                                      size: size,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      );
                    },
                  );
      },
    );
  }

  /*   Wrap(
                    children: List.generate(
                      batchDetailsViewController
                          .dataPagingController.value.list.length,  // gives the length of list
                      (index) {
                        CommonDatum data = batchDetailsViewController
                            .dataPagingController.value.list[index];

                        return Padding(
                          padding: EdgeInsets.only(
                              bottom: batchDetailsViewController
                                              .dataPagingController
                                              .value
                                              .list
                                              .length -
                                          1 ==
                                      index
                                  ? DimensionResource.marginSizeDefault
                                  : 0),
                          child: _liveClassesView(index,
                              height: 160,
                              fontSize: DimensionResource.marginSizeSmall + 3,
                              data: data,
                              isPast: widget.isPast,
                              showPro: !((userSub?.batchId ==
                                          controller.batchData?.id &&
                                      userSub?.batchStartDate ==
                                          widget.batchDateId) ||
                                  (userSub?.pastSubscription == 1 ||
                                      userSub?.superSub == 1)),
                              batchDetailsViewController:
                                  batchDetailsViewController,
                              size: size),
                        );
                      },
                    ),
                  );*/
}

Widget _liveClassesView(int index,
    {double height = 120,
    double width = 120,
    required bool showPro,
    double fontSize = DimensionResource.fontSizeExtraSmall - 2,
    bool isPast = false,
    required CommonDatum data,
    required BatchClassViewController batchDetailsViewController,
    required Size size}) {
  return GestureDetector(
    onTap: () {
      AppConstants.instance.batchId.value = (data.id.toString());
      Pagination pagination =
          batchDetailsViewController.batchDetailData.value.data?.pagination ??
              Pagination();
      int? currentpage =
          (pagination.currentPage ?? 0) <= (pagination.lastPage ?? 0)
              ? pagination.currentPage
              : pagination.lastPage;

      Get.toNamed(
        Routes.batchClassDetails(id: data.id.toString()),
        arguments: [
          isPast,
          data.id.toString(),
          batchDetailsViewController.batchData?.id,
          batchDetailsViewController.batchDateId,
          currentpage,
        ],
      );
    },
    child: Container(
      height: height,
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
          color: ColorResource.white,
          shape: BoxShape.rectangle,
          border: Border.all(color: ColorResource.black),
          borderRadius: BorderRadius.circular(
              DimensionResource.appDefaultContainerRadius)),
      child: Stack(
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.horizontal(
                  left: Radius.circular(
                      DimensionResource.appDefaultContainerRadius),
                ),
                child: SizedBox(
                  height: height,
                  width: 130,
                  child: cachedNetworkImage(
                    data.preview ?? data.image ?? "",
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  height: height,
                  decoration: const BoxDecoration(
                      color: ColorResource.white,
                      borderRadius: BorderRadius.horizontal(
                          right: Radius.circular(
                              DimensionResource.appDefaultContainerRadius))),
                  padding: const EdgeInsets.all(
                      DimensionResource.marginSizeExtraSmall + 2),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Visibility(
                              visible: showPro,
                              child: const ProContainerButton(
                                isShow: false,
                                isCircle: true,
                              )),
                          if (data.isDoubt == 1)
                            const Align(
                              alignment: Alignment.topRight,
                              child: BatchTypeContainer(
                                bgColor: Colors.indigo,
                                fontColor: Colors.white,
                                text: 'Doubt',
                                size: 9,
                                horizontalPadding: 5,
                                verticalPadding: 3,
                              ),
                            ),
                          if (data.isLive == 1)
                            !isPast
                                ? findDiff(data.startTime!)
                                    ? const Align(
                                        alignment: Alignment.topRight,
                                        child: BatchTypeContainer(
                                          bgColor: Colors.red,
                                          fontColor: Colors.white,
                                          text: 'Live',
                                          size: 9,
                                          horizontalPadding: 5,
                                          verticalPadding: 3,
                                        ),
                                      )
                                    : Container()
                                : Container(),
                          if (data.isWorkshop == 1)
                            const Align(
                              alignment: Alignment.topRight,
                              child: BatchTypeContainer(
                                bgColor: Colors.indigo,
                                fontColor: Colors.white,
                                text: 'Workshop',
                                size: 9,
                                horizontalPadding: 5,
                                verticalPadding: 3,
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(
                        height: DimensionResource.marginSizeExtraSmall,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          isPast
                              ? "Streamed on ${AppConstants.formatDate(data.startTime)}"
                              : AppConstants.formatDateAndTime(data.startTime),
                          style: StyleResource.instance.styleMedium(
                              fontSize: DimensionResource.fontSizeSmall -
                                  (width > 130 ? 0 : 2),
                              color: ColorResource.greenDarkColor),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ),
                      const SizedBox(
                        height: DimensionResource.marginSizeExtraSmall - 2,
                      ),
                      SizedBox(
                        height: 60,
                        child: Padding(
                          padding: const EdgeInsets.only(left: 12.0),
                          child: Text(
                            data.title ?? '',
                            style: StyleResource.instance.styleMedium(
                                fontSize: fontSize, color: ColorResource.black),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 4,
                          ),
                        ),
                      ),
                      const Spacer(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: InkWell(
                                onTap: () {
                                  AppConstants.instance.batchId.value =
                                      (data.id.toString());
                                  Pagination pagination =
                                      batchDetailsViewController.batchDetailData
                                              .value.data?.pagination ??
                                          Pagination();
                                  int? currentpage =
                                      (pagination.currentPage ?? 0) <=
                                              (pagination.lastPage ?? 0)
                                          ? pagination.currentPage
                                          : pagination.lastPage;

                                  Get.toNamed(
                                    Routes.batchClassDetails(
                                        id: data.id.toString()),
                                    arguments: [
                                      isPast,
                                      data.id.toString(),
                                      batchDetailsViewController.batchData?.id,
                                      batchDetailsViewController.batchDateId,
                                      currentpage,
                                    ],
                                  );
                                },
                                child: Container(
                                  alignment: Alignment.center,
                                  height: 30,
                                  width: 60,
                                  decoration: BoxDecoration(
                                      shape: BoxShape.rectangle,
                                      color: ColorResource.white,
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                        color: ColorResource.black,
                                      )),
                                  child: const Text(
                                    "VIEW",
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: ColorResource.black,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
          // !isPast
          //     ? findDiff(data.startTime!)
          //     ? LiveDot(left: 4, top: 4)
          //     : Container()
          //     : Container(),
        ],
      ),
    ),
  );
}

bool findDiff(DateTime givenDateTime) {
  // Example given datetime

  DateTime currentDateTime = DateTime.now(); // Current datetime

  Duration difference = currentDateTime.difference(givenDateTime);

  print('Difference: ${difference.inDays} days');
  print('Difference: ${difference.inHours} hours');
  print('Difference: ${difference.inMinutes} minutes');
  print('Difference: ${difference.inSeconds} seconds');

  if (currentDateTime.isAfter(givenDateTime)) {
    return true;
  } else if (currentDateTime.isBefore(givenDateTime)) {
    return false;
  } else {
    return true;
  }
}

// Scaffold(
//   body: ListView(
//     physics: const AlwaysScrollableScrollPhysics(),
//     padding: const EdgeInsets.only(
//         left: DimensionResource.marginSizeDefault,
//         right: DimensionResource.marginSizeDefault),
//     children: [
//       const SizedBox(
//         height: DimensionResource.marginSizeDefault,
//       ),
//       Align(
//         alignment: Alignment.topRight,
//         child: Text(
//           "Live batches by industry experts.".toUpperCase(),
//           style: StyleResource.instance
//               .styleRegular()
//               .copyWith(fontSize: DimensionResource.fontSizeExtraSmall),
//         ),
//       ),
//       const SizedBox(
//         height: DimensionResource.marginSizeSmall,
//       ),
//       listOfModules(),
//       ColoredBox(
//         color: ColorResource.grey_2,
//         child: Padding(
//           padding: const EdgeInsets.all(8),
//           child: Column(
//             children: [
//               Text('Need to know more',
//                   style: StyleResource.instance.styleBold().copyWith(
//                       color: ColorResource.grey,
//                       fontSize: DimensionResource.fontSizeExtraLarge)),
//               Row(
//                 children: [
//                   Expanded(
//                     child: Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: 16),
//                       child: ElevatedButton(
//                           style: ElevatedButton.styleFrom(
//                               shape: const RoundedRectangleBorder(),
//                               backgroundColor: ColorResource.grey,
//                               foregroundColor: ColorResource.white),
//                           onPressed: () {},
//                           child: Text(
//                             'Get call back',
//                             style: StyleResource.instance
//                                 .styleBold()
//                                 .copyWith(
//                                     color: ColorResource.white,
//                                     fontSize: DimensionResource
//                                         .fontSizeExtraLarge),
//                           )),
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//       ),
//       const SizedBox(height: 16),
//       Container(
//         decoration: BoxDecoration(
//             border: Border.all(color: ColorResource.grey_4),
//             borderRadius: BorderRadius.circular(24)),
//         height: 170,
//         child: ClipRRect(
//             borderRadius: BorderRadius.circular(24),
//             child: cachedNetworkImage('')),
//       )
//     ],
//   ),
//
// ),