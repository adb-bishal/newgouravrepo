import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/auth_models/sign_in.dart';
import 'package:stockpathshala_beta/model/models/batch_models/batch_details_model.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/batch_controller/batch_details/batch_class_view_controller2.dart';
import '../../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../../model/services/pagination.dart';
import '../../../../../../model/utils/app_constants.dart';
import '../../../../../../model/utils/color_resource.dart';
import '../../../../../../model/utils/dimensions_resource.dart';
import '../../../../../../model/utils/style_resource.dart';

import '../../../../../../view_model/routes/app_pages.dart';
import '../../../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../../../widgets/no_data_found/no_data_found.dart';
import '../../../../../widgets/search_widget/search_container.dart';
import '../../../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../../../../widgets/view_helpers/small_button.dart';
import '../../../home_view/widget/top_ten_widget.dart';

class BatchClassView2 extends StatefulWidget {
  const BatchClassView2(
      {Key? key,
      required this.batchDateId,
      this.isFromNotification = false,
      this.isPast = false})
      : super(key: key);
  final int batchDateId;
  final bool isPast;
  final bool isFromNotification;

  @override
  State<BatchClassView2> createState() => _BatchClassViewState();
}

class _BatchClassViewState extends State<BatchClassView2> {
  late BatchClassViewController2 controller;

  @override
  void initState() {
    Get.put(BatchClassViewController2(), tag: 'subBatch${widget.batchDateId}');
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
    logPrint("hghgvh${controller.batchData?.hasRecording}");
    super.initState();
  }

  @override
  void dispose() {
    Get.find<BatchClassViewController2>(tag: 'subBatch${widget.batchDateId}')
        .dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return RefreshIndicator(
        color: ColorResource.primaryColor,
        onRefresh: controller.onRefresh,
        child: Scaffold(
          body: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            controller: controller.dataPagingController.value.scrollController,
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeSmall),
            children: [
              const SizedBox(
                height: DimensionResource.marginSizeSmall,
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
                    : SizedBox.shrink(); // Use SizedBox.shrink() to hide the widget when not needed
              }),

              _videoCourseWrapList(
                  batchDetailsViewController: controller, size: size),
              const SizedBox(
                height: 15,
              ),
              // Obx(
              //   () => Visibility(
              //       visible: controller.dataPagingController.value.isDataLoading.value &&
              //           controller.searchController.value.text.isEmpty,
              //       // visible: controller.isDataLoading.value &&
              //       // controller.searchController.value.text.isEmpty,
              //       child: const Padding(
              //         padding: EdgeInsets.only(bottom: 15.0),
              //         child: CommonCircularIndicator(),
              //       )),
              // ),
            ],
          ),
        )

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
      {required BatchClassViewController2 batchDetailsViewController,
      required Size size}) {
    return Obx(() {
      // Get the user's subscription
      final isLoading = batchDetailsViewController.isDataLoading.value;
      final isSearchEmpty = batchDetailsViewController.searchController.value.text.isEmpty;
      final isListEmpty = batchDetailsViewController.dataPagingController.value.list.isEmpty;


      UserSubscription? userSub =
          Get.find<AuthService>().user.value.userSubscription;

      if (isLoading && isSearchEmpty) {

        return MediaQuery.of(context).size.width < 500
            ? ShimmerEffect.instance.pastRecordingOneTileLoader()
            : ShimmerEffect.instance.pastRecordingLoader();
      } else if (isListEmpty && !isLoading) {

        return const SizedBox(
          height: 400,
          child: NoDataFound(
            showText: true,
            text: "Batches are being Set Up for You!",
          ),
        );
      }else {
        return
          LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              int tilesPerRow = width < 500 ? 1 : 2;

              return Column(
                children: [
                  // Add the SearchWidget before the grid


                  // Optional spacing between the search bar and grid view
                  const SizedBox(height: 16.0), // Adjust height as needed

                  // The Wrap widget containing the grid view list
                  Wrap(
                    spacing: 24.0, // Space between tiles horizontally
                    runSpacing: 12.0, // Space between tiles vertically
                    children: List.generate(
                      batchDetailsViewController.dataPagingController.value.list
                          .length,
                          (index) {
                        CommonDatum data = batchDetailsViewController
                            .dataPagingController.value.list[index];

                        return Container(
                          width: (width / tilesPerRow) - 16,
                          child: Padding(
                            padding: EdgeInsets.only(
                              bottom: batchDetailsViewController
                                  .dataPagingController.value.list.length - 1 ==
                                  index
                                  ? DimensionResource.marginSizeDefault
                                  : 0,
                            ),
                            child: _liveClassesView(
                              index,
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
                              batchDetailsViewController: batchDetailsViewController,
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
      }
    });
  }
}

Widget _liveClassesView(int index,
    {double height = 120,
    double width = 120,
    required bool showPro,
    double fontSize = DimensionResource.fontSizeExtraSmall - 2,
    bool isPast = false,
    required CommonDatum data,
    required BatchClassViewController2 batchDetailsViewController,
    required Size size}) {
  return InkWell(
    onTap: () {
      AppConstants.instance.liveId.value = (data.id.toString());
      Get.toNamed(
        Routes.liveClassDetail(id: data.id.toString()),
        arguments: [isPast, data.id.toString()],
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.horizontal(
              left:
                  Radius.circular(DimensionResource.appDefaultContainerRadius),
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
                  if (!isPast)
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
                          const Align(
                            alignment: Alignment.topRight,
                            child: BatchTypeContainer(
                              bgColor: Colors.red,
                              fontColor: Colors.white,
                              text: 'Live',
                              size: 9,
                              horizontalPadding: 5,
                              verticalPadding: 3,
                            ),
                          ),
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
                  Text(
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
                  const SizedBox(
                    height: DimensionResource.marginSizeExtraSmall - 2,
                  ),
                  SizedBox(
                    height: 60,
                    child: Text(
                      data.title ?? '',
                      style: StyleResource.instance.styleMedium(
                          fontSize: fontSize, color: ColorResource.black),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 4,
                    ),
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: InkWell(
                            // onTap: () {
                            //   AppConstants.instance.liveId.value =
                            //   (data.id.toString());
                            //   Get.toNamed(
                            //     Routes.batchClassDetails(
                            //         id: data.id.toString()),
                            //     arguments: [isPast, data.id.toString()],
                            //   );
                            // },
                            onTap: () {
                              AppConstants.instance.liveId.value =
                                  (data.id.toString());
                              Get.toNamed(
                                Routes.liveClassDetail(id: data.id.toString()),
                                arguments: [isPast, data.id.toString()],
                              );
                              // if (onItemTap != null) {
                              //   onItemTap(data);
                              // }
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
    ),
  );
}


