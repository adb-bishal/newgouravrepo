import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:stockpathshala_beta/model/models/batch_models/batch_details_model.dart';
import 'package:stockpathshala_beta/model/models/common_container_model/common_container_model.dart';
import 'package:stockpathshala_beta/model/services/pagination.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';
import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/batch_controller/batch_details/detail_tabs/batch_class_view_controller.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';

import '../../../../../mentroship/model/mentorshipCardList_model.dart' hide Pagination;

class BatchDetailsFromNotification extends StatefulWidget {
  const BatchDetailsFromNotification({super.key});

  @override
  State<BatchDetailsFromNotification> createState() =>
      _BatchDetailsFromNotificationState();
}

class _BatchDetailsFromNotificationState
    extends State<BatchDetailsFromNotification> {
  late BatchClassViewController controller;
  int? batchDateId;
  @override
  void initState() {
    if (Get.arguments != null) {
      batchDateId = int.parse(Get.arguments[0]);
    }
    Get.put(BatchClassViewController(), tag: 'subBatch$batchDateId');
    controller = Get.find(tag: 'subBatch$batchDateId');

    controller.dataPagingController = PagingScrollController<CommonDatum>(
        onLoadMore: (int page, int totalItemsCount) async {
      await controller.getBatchDetails(pageNo: page);
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    controller.batchDateId = batchDateId;

    controller.getBatchDetails();

    super.initState();
  }

  @override
  void dispose() {
    Get.find<BatchClassViewController>(tag: 'subBatch$batchDateId').dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Obx(
      () => Container(
        color: Platform.isIOS ? ColorResource.white : Colors.transparent,
        child: SafeArea(
          top: false,
          bottom: false,
          //bottom:Platform.isIOS ? true:false,
          child: Scaffold(
            resizeToAvoidBottomInset: false,
            appBar: AppBar(
              centerTitle: true,
              title: Text(
                // Prev code
                // titleText ?? '',
                controller.batchDetailData.value.data?.data?[0].batchTitle ??
                    "Loading...".toUpperCase(),

                style: StyleResource.instance.styleSemiBold().copyWith(
                      fontSize: DimensionResource.fontSizeExtraLarge,
                      color: ColorResource.white,
                    ),
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
              ),
              backgroundColor: ColorResource.backGroundColor,
              leading: InkWell(
                onTap: () => Get.back(),
                child: const SizedBox(
                  height: 32,
                  width: 32,
                  child: Center(
                    child: Icon(
                      Icons.arrow_back_ios,
                      color: ColorResource.white,
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),

            backgroundColor: ColorResource.backGroundColor,
            body: SizedBox(
              height: double.infinity,
              width: double.infinity,
              child: Container(
                  margin: const EdgeInsets.only(top: 4),
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: RefreshIndicator(
                    color: ColorResource.primaryColor,
                    onRefresh: controller.onRefresh,
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      controller: controller
                          .dataPagingController.value.scrollController,
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensionResource.marginSizeSmall),
                      children: [
                        Container(
                          padding: const EdgeInsets.all(4),
                          margin: EdgeInsets.only(
                            left: size.width / 3,
                            right: size.width / 3,
                          ),
                          decoration: BoxDecoration(
                            color: ColorResource.primaryColor,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'Starting from',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 10, color: ColorResource.white),
                              ),
                              Text(
                                AppConstants.formatSmallDate(DateTime.parse(
                                    controller.batchDetailData.value.data
                                            ?.data?[0].startDatetime ??
                                        '1999-01-01')),
                                style:
                                    const TextStyle(color: ColorResource.white),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: DimensionResource.marginSizeSmall,
                        ),
                        _videoCourseWrapList(
                            batchDetailsViewController: controller, size: size),
                        const SizedBox(
                          height: 15,
                        ),
                        Obx(
                          () => Visibility(
                              visible: controller.isDataLoading.value,
                              child: const Padding(
                                padding: EdgeInsets.only(bottom: 15.0),
                                child: CommonCircularIndicator(),
                              )),
                        ),
                      ],
                    ),
                  )),
            ),
            //bottomNavigationBar:bottomBarPerimeter!=null ? bottomBarWidget(bottomBarPerimeter!,controller) : const SizedBox(),
          ),
        ),
      ),
    );
  }
}

Widget _videoCourseWrapList(
    {required BatchClassViewController batchDetailsViewController,
    required Size size}) {
  return Obx(
    () {
      /// user subscription
      // UserSubscription? userSub =
      //     Get.find<AuthService>().user.value.userSubscription;

      return batchDetailsViewController.isDataLoading.value
          ? ShimmerEffect.instance.liveClassLoader()
          : batchDetailsViewController.dataPagingController.value.list.isEmpty
              ? const SizedBox(
                  height: 400,
                  child: NoDataFound(
                    showText: true,
                    text: "Batches are being Set Up for You!",
                  ))
              : Wrap(
                  children: List.generate(
                    batchDetailsViewController
                        .dataPagingController.value.list.length,
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
                            isPast: false,
                            showPro:
                                // !((userSub?.batchId ==
                                //             controller.batchData?.id &&
                                //         userSub?.batchStartDate ==
                                //             widget.batchDateId) ||
                                //     (userSub?.pastSubscription == 1 ||
                                //         userSub?.superSub == 1))
                                false,
                            batchDetailsViewController:
                                batchDetailsViewController,
                            size: size),
                      );
                    },
                  ),
                );
    },
  );
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
  return InkWell(
    // onTap: ()
    // {
    //   AppConstants.instance.liveId.value = (data.id.toString());
    //   Get.toNamed(
    //     Routes.batchClassDetails(id: data.id.toString()),
    //     arguments: [isPast, data.id.toString()],
    //   );
    // },
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                          visible: showPro,
                          child: const ProContainerButton(
                            isShow: true,
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
                            onTap: () {
                              AppConstants.instance.liveId.value =
                                  (data.id.toString());
                              Get.toNamed(
                                Routes.batchClassDetails(
                                    id: data.id.toString()),
                                arguments: [isPast, data.id.toString()],
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
    ),
  );
}
