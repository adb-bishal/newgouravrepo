import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/screens/base_view/base_view_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/batches_filter_view/batches_filter_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/past_classes/past_batch_classes.dart';
import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
import 'package:stockpathshala_beta/view_model/controllers/batch_controller/live_batch_controller.dart';
import '../../../../model/models/batch_models/all_batch_model.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../enum/routing/routes/app_pages.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/search_widget/search_container.dart';
import 'widgets/batch_widgets.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
class LiveBatches extends StatefulWidget {
  const LiveBatches({super.key});

  @override
  State<LiveBatches> createState() => _LiveBatchesState();
}

class _LiveBatchesState extends State<LiveBatches>
    with TickerProviderStateMixin {
  @override
  void initState() {
    Get.put(LiveBatchesController());
    Get.find<LiveBatchesController>().tabController = TabController(
        length: Get.find<LiveBatchesController>().tabs.length, vsync: this);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) =>
          Container(
        margin: const EdgeInsets.only(
            top: DimensionResource.marginSizeExtraSmall + 5,
            bottom: DimensionResource.marginSizeExtraSmall),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
              Radius.circular(DimensionResource.borderRadiusExtraLarge)),
          child: ColoredBox(
            color: Colors.black38,
            child: TabBar(
              splashBorderRadius: const BorderRadius.all(
                  Radius.circular(DimensionResource.borderRadiusExtraLarge)),
              dividerColor: ColorResource.primaryColor,
              indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                      DimensionResource.borderRadiusExtraLarge)),
                  shape: BoxShape.rectangle,
                  color: ColorResource.white),
              labelColor: ColorResource.primaryColor,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: controller.tabs,
              controller: controller.tabController,
            ),
          ),
        ),
      ),
      onActionBuilder: (context, controller) => [],
      isBackShow: false,
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: LiveBatchesController(),
      onPageBuilder: (context, controller) {
        return TabBarView(controller: controller.tabController, children: [
          _mainPageBuilder(context, controller),
          const PastBatchClasses()
        ]);
      },
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, LiveBatchesController controller) {
    double width = MediaQuery.of(context).size.width;
    return RefreshIndicator(
        color: ColorResource.primaryColor,
        onRefresh: controller.onRefresh,
        child: ListView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.only(
                left: DimensionResource.marginSizeSmall,
                right: DimensionResource.marginSizeSmall),
            children: [
              const SizedBox(
                height: DimensionResource.marginSizeDefault,
              ),
              Row(
                children: [
                  Expanded(
                    child: Obx(() {
                      return SearchWidget(
                        enableMargin: false,
                        textEditingController: controller.searchController.value,
                        onChange: controller.onClassSearch,
                        onClear: () {
                          controller.onClassSearch("");
                        },
                      );
                    }),
                  ),
                  const SizedBox(
                    width: DimensionResource.marginSizeDefault,
                  ),
                  InkWell(
                      onTap: () {
                        buildShowModalBottomSheet(context, Obx(() {
                          return controller.isClearLoading.value
                              ? const CircularProgressIndicator()
                              : LiveFilterScreen(
                            type:'live',
                            onClear: (val) {
                              controller.listOFSelectedDuration.clear();
                              controller.listOFSelectedCat.clear();
                              controller.listOFSelectedDate.clear();
                              controller.isClearLoading.value = true;
                              Future.delayed(Duration.zero, () {
                                controller.isClearLoading.value = false;
                              });
                              controller.selectedSub.value = val['is_free'];
                              controller.listofSelectedTeacher.value =
                              val['teacher'];
                              controller.getBatchData(
                                pageNo: 1
                              );
                              Get.back();
                            },
                            listOfSelectedTeacher:
                            controller.listofSelectedTeacher,
                            isHideTeacher: true,
                            isHideRating: true,
                            isHideTime: true,
                            isHideLevel: true,
                            selectedSubscription:
                            controller.selectedSub.value,
                            listOFSelectedLevel: const [],
                            listOFSelectedCat: controller.listOFSelectedCat,
                            listOFSelectedDays: controller.listOFSelectedDate,
                            listOFSelectedDuration:
                            controller.listOFSelectedDuration,
                            listOFSelectedLang: const [],
                            isPastFilter: true,
                            onApply: (val) {
                              // controller.selectedLevel.value = val['level'];
                              controller.selectedSub.value = val['is_free'];
                              controller.listofSelectedTeacher.value =
                              val['teacher'];
                              controller.listOFSelectedDate.value =
                              val['days'];
                              controller.listOFSelectedCat.value =
                              val['category'];
                              //controller.listOFSelectedLang.value = val['language'];
                              controller.listOFSelectedDuration.value =
                              val['duration'];
                              controller.getBatchData(
                                categoryId: controller.listOFSelectedCat
                                    .map((element) => element.id)
                                    .toList()
                                    .toString()
                                    .replaceAll("[", "")
                                    .replaceAll("]", "")
                                    .removeAllWhitespace,
                                // // teacherId: controller.listofSelectedTeacher
                                // //     .map((element) => element.id)
                                // //     .toList()
                                // //     .toString()
                                // //     .replaceAll("[", "")
                                // //     .replaceAll("]", "")
                                // //     .removeAllWhitespace,

                                dateFilter: controller.listOFSelectedDate
                                    .map((e) => e.displayName?.toLowerCase())
                                    .join(','),

                                // duration: controller.listOFSelectedDuration
                                //     .map((element) => element.optionName)
                                //     .toList()
                                //     .toString()
                                //     .replaceAll("[", "")
                                //     .replaceAll("]", "")
                                //     .removeAllWhitespace,
                                // subscriptionLevel:
                                // controller.selectedSub.value.optionName,
                              );
                            }, listOFSelectedRating: const [],
                          );
                        }), isDark: false, isDismissible: true)
                            .then((value) {
                          Get.delete<ClassesFilterController>();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Image.asset(
                          ImageResource.instance.filterIcon,
                          color: ColorResource.primaryColor,
                          height: 18,
                        ),
                      ))
                ],
              ),

              Obx(
                () => controller.isDataLoading.value
                    ? const SizedBox()
                    : Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.wifi_tethering_rounded,
                              color: ColorResource.redColor,
                            ),
                            const SizedBox(width: 4),
                            if (controller.batchData.value.totalSubBatches ==
                                    null ||
                                controller.batchData.value.totalSubBatches ==
                                    0) ...[
                              Text(
                                "No Batches running currently".capitalize ?? "",
                                style: StyleResource.instance.styleMedium(),
                              ),
                            ] else ...[
                              Text(
                                "${controller.batchData.value.totalSubBatches} live batches running..."
                                        .capitalize ??
                                    "",
                                style: StyleResource.instance.styleMedium(),
                              ),
                            ]
                          ],
                        ),
                      ),
              ),
              SizedBox(height: 16),
              Obx(() {
                // Choose display list: either full data or filtered data if a search query is applied
                final displayList = controller.filteredBatchData.isEmpty
                    ? controller.batchData.value.data ??
                        [] // Show full list if no search query
                    : controller.filteredBatchData;

                return controller.isDataLoading.value
                    ? (width < 500
                        ? ShimmerEffect.instance
                            .allBatchesLoader() // Shimmer for smaller screens
                        : ShimmerEffect.instance
                            .allBatchesLoaderForTabletView()) // Shimmer for larger screens
                    : (displayList.isEmpty // Check if display list has data
                        ? const SizedBox(
                            height: 400,
                            child: NoDataFound(
                              showText: true,
                              text: "Batches are being set up for you!",
                            ),
                          )
                        : Wrap(
                            //runSpacing: DimensionResource.marginSizeSmall + 20,
                            children: List.generate(
                              (displayList.length / (width < 500 ? 1 : 2))
                                  .ceil(), // Adjust based on screen size
                              (index) {
                                int firstIndex = index * (width < 500 ? 1 : 2);
                                BatchData firstData = displayList[firstIndex];
                                //CommonDatum data = batchClassViewController
                                //  .dataPagingController.value.list[index];

                                if (width < 500) {
                                  // For smaller screens, display one tile per row
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: liveBatchTile(
                                      data: firstData,
                                      boxBgColor: ColorResource.white,
                                      boxFgColor: ColorResource.secondaryColor,
                                      bottomBgColor:
                                          ColorResource.secondaryColor,
                                      sideText: firstData.courseOfferTitle,
                                      onExplore: () {
                                        Get.toNamed(
                                          Routes.batchDetails,
                                          arguments: [firstData, false],
                                        );
                                      },
                                      studentsEnrolled: int.tryParse(
                                          firstData.totalStudentsEnrolled ??
                                              '0'),
                                      showBottonCard: firstIndex % 3 == 0,
                                      showDivider:
                                          firstIndex != displayList.length - 1,
                                      bottomCardUsers: '1.5 Lakh',
                                      bottomCardSallerHike: 40,
                                      bottomCardOutcome: 100,
                                    ),
                                  );
                                } else {
                                  // For larger screens, display two tiles per row
                                  BatchData? secondData;
                                  if (firstIndex + 1 < displayList.length) {
                                    secondData = displayList[firstIndex + 1];
                                  }
                                  return itemCard(firstData, secondData);
                                }
                              },
                            ),
                          ));
              }),
              SizedBox(height: 16)
            ]));

    /*  Wrap(
                    runSpacing: DimensionResource.marginSizeSmall +20,
                    children: List.generate(
                        controller.batchData.value.data!.length, (index) {
                      BatchData data =
                          controller.batchData.value.data?[index] ??
                              BatchData();
                            return (width < 500)
                          ? Padding(
                           padding: const EdgeInsets.all(8.0),
                           child: liveBatchTile(
                            data: data,
                            boxBgColor: ColorResource.white,
                            boxFgColor: ColorResource.secondaryColor,
                            bottomBgColor: ColorResource.secondaryColor,
                            sideText: data.courseOfferTitle,
                            onExplore: () {
                              Get.toNamed(Routes.batchDetails,
                                  arguments: [data, false]);
                            },
                            studentsEnrolled: int.tryParse(
                                data.totalStudentsEnrolled ?? ''),
                            showBottonCard: index % 3 == 0,
                            showDivider: index !=
                                controller
                                    .batchData.value.data!.length -
                                    1,
                            bottomCardUsers: '1.5 Lakh',
                            bottomCardSallerHike: 40,
                            bottomCardOutcome: 100),
                      )
                          : itemCard(data);
                    }
                    ),
                  )*/
  }
  Future<dynamic> buildShowModalBottomSheet(BuildContext context, Widget child,
      {Color? bgColor,
        double radius = 20,
        bool isDark = true,
        bool isDismissible = false}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(radius),
                topLeft: Radius.circular(radius),
              ),
              child: Container(
                constraints: BoxConstraints(maxHeight: Get.height * 0.75),
                // height: MediaQuery.of(context).size.height * 0.44+height,
                decoration: BoxDecoration(
                    color: !isDark
                        ? bgColor ?? ColorResource.white
                        : bgColor ?? ColorResource.secondaryColor,
                    boxShadow: const [
                      BoxShadow(
                          color: ColorResource.secondaryColor,
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, -2))
                    ],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(radius),
                      topLeft: Radius.circular(radius),
                    )),
                child: SingleChildScrollView(
                  //padding: const EdgeInsets.only(bottom: DimensionResource.marginSizeSmall),
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: DimensionResource.marginSizeExtraSmall + 3),
                        height: 6,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isDark
                                ? ColorResource.borderColor
                                : ColorResource.borderColor),
                      ),
                      child
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

}
