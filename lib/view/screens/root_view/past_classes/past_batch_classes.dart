import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/batch_models/all_batch_model.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/widgets/batch_widgets.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/shimmer_widget/shimmer_widget.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import '../../../../view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
import '../../../../view_model/routes/app_pages.dart';
import '../../../widgets/button_view/animated_box.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/search_widget/search_container.dart';
import '../live_classes_view/batches_filter_view/batches_filter_view.dart';

class PastBatchClasses extends StatefulWidget {
  const PastBatchClasses({super.key});

  @override
  State<PastBatchClasses> createState() => _PastBatchClassesState();
}

class _PastBatchClassesState extends State<PastBatchClasses> {
  PastClassesController controller = Get.put(PastClassesController());
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    print('sdfsdc ${controller.batchList.length}');

    return RefreshIndicator(
      color: ColorResource.primaryColor,
      onRefresh: controller.onRefresh,
      child: ListView(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.paddingSizeDefault),
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
                        type: 'past',
                        onClear: (val) {
                          controller.selectedRating.value = val['rating'];
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
                          controller.getBatches(

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
                        listOFSelectedRating: controller.selectedRating,
                        isPastFilter: true,
                        onApply: (val) {
                          logPrint("selectedValue $val");
                          // controller.selectedLevel.value = val['level'];
                          controller.selectedSub.value = val['is_free'];
                          controller.listofSelectedTeacher.value =
                          val['teacher'];
                          controller.listOFSelectedDate.value =
                          val['days'];
                          controller.selectedRating.value = val['rating'];
                          controller.listOFSelectedCat.value =
                          val['category'];
                          //controller.listOFSelectedLang.value = val['language'];
                          controller.listOFSelectedDuration.value =
                          val['duration'];
                          controller.getBatches(
                            pageNo: 1,
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
                        },
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

          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Text(
            "View Live Batch Class Recordings",
            style: StyleResource.instance.styleSemiBold(),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          Obx(() {
            final displayList = controller.filteredBatchList.isEmpty
                ? controller.batchList // Show full list if no search query
                : controller
                    .filteredBatchList; // Show filtered list when there's a query

            return controller.isBatchesLoading.value
                ? (width < 500
                    ? ShimmerEffect.instance.allBatchesLoader()
                    : ShimmerEffect.instance
                        .allBatchesLoaderPastForTabletView())
                : displayList.isEmpty
                    ? SizedBox(
                        height: 400,
                        child: NoDataFound(
                          showText: true,
                          text: "Buy Batches to see their class recordings!"
                              .capitalize,
                        ),
                      )
                    : Wrap(
                        runSpacing: DimensionResource.marginSizeSmall,
                        children: List.generate(
                          (displayList.length / (width < 500 ? 1 : 2)).ceil(),
                          (index) {
                            int firstIndex = index * (width < 500 ? 1 : 2);
                            BatchData firstData =
                                displayList.elementAt(firstIndex);

                            if (width < 500) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 8.0,right: 8,bottom: 40,top: 0),
                                child: liveBatchTile(
                                  isPast: true,
                                  data: firstData,
                                  boxBgColor: ColorResource.white,
                                  boxFgColor: ColorResource.secondaryColor,
                                  bottomBgColor: ColorResource.secondaryColor,
                                  sideText: firstData.courseOfferTitle,
                                  onExplore: () {
                                    print('tyhytngn');
                                    Get.toNamed(
                                      Routes.batchDetails,
                                      arguments: [
                                        firstData,
                                        true,
                                        controller.filterSubBatches(
                                            batchId: firstData.id ?? 0),
                                      ],
                                    );
                                  },
                                  showDivider:
                                      firstIndex != displayList.length - 1,
                                ),
                              );
                            } else {
                              BatchData? secondData;
                              if (firstIndex + 1 < displayList.length) {
                                secondData =
                                    displayList.elementAt(firstIndex + 1);
                              }
                              return Row(
                                children: [
                                  Expanded(
                                    child: liveBatchTile(
                                      isPast: true,
                                      data: firstData,
                                      boxBgColor: ColorResource.white,
                                      boxFgColor: ColorResource.secondaryColor,
                                      bottomBgColor:
                                          ColorResource.secondaryColor,
                                      sideText: firstData.courseOfferTitle,
                                      onExplore: () {
                                        print('dfdfdfgdeds');
                                        Get.toNamed(
                                          Routes.batchDetails,
                                          arguments: [
                                            firstData,
                                            true,
                                            controller.filterSubBatches(
                                                batchId: firstData.id ?? 0),
                                          ],
                                        );
                                      },
                                      showDivider:
                                          firstIndex != displayList.length - 1,
                                    ),
                                  ),
                                  const SizedBox(width: 20),
                                  if (secondData != null)
                                    Expanded(
                                      child: liveBatchTile(
                                        isPast: true,
                                        data: secondData,
                                        boxBgColor: ColorResource.white,
                                        boxFgColor:
                                            ColorResource.secondaryColor,
                                        bottomBgColor:
                                            ColorResource.secondaryColor,
                                        sideText: secondData.courseOfferTitle,
                                        onExplore: () {
                                          print('sdefsdf');
                                          Get.toNamed(
                                            Routes.batchDetails,
                                            arguments: [
                                              secondData,
                                              true,
                                              controller.filterSubBatches(
                                                  batchId: secondData?.id ?? 0),
                                            ],
                                          );
                                        },
                                        showDivider: firstIndex + 1 !=
                                            displayList.length - 1,
                                      ),
                                    ),
                                ],
                              );
                            }
                          },
                        ),
                      );
          })

          // Obx(() {
          //   return controller.isBatchesLoading.value
          //       ? (width < 500
          //       ? ShimmerEffect.instance.allBatchesLoader() // For small screens (1 row per tile)
          //       : ShimmerEffect.instance.allBatchesLoaderPastForTabletView()) // For tablet view (2 rows per tile)
          //       : controller.batchList.isEmpty
          //       ? SizedBox(
          //     height: 400,
          //     child: NoDataFound(
          //       showText: true,
          //       text: "Buy Batches to see their class recordings!".capitalize,
          //     ),
          //   )
          //       : Wrap(
          //     runSpacing: DimensionResource.marginSizeSmall,
          //     children: List.generate(
          //       (controller.batchList.length / (width < 500 ? 1 : 2)).ceil(),
          //           (index) {
          //         int firstIndex = index * (width < 500 ? 1 : 2);
          //         BatchData firstData = controller.batchList.elementAt(firstIndex);
          //
          //
          //         if (width < 500) {
          //           // Display single tile per row for small screens
          //           return Padding(
          //             padding: const EdgeInsets.all(8.0),
          //             child: liveBatchTile(
          //               isPast: true,
          //               data: firstData,
          //               boxBgColor: ColorResource.white,
          //               boxFgColor: ColorResource.secondaryColor,
          //               bottomBgColor: ColorResource.secondaryColor,
          //               sideText: firstData.courseOfferTitle,
          //               onExplore: () {
          //                 Get.toNamed(
          //                   Routes.batchDetails,
          //                   arguments: [
          //                     firstData,
          //                     true,
          //                     controller.filterSubBatches(batchId: firstData.id ?? 0),
          //                   ],
          //                 );
          //               },
          //               showDivider: firstIndex != controller.batchList.length - 1,
          //             ),
          //           );
          //         } else {
          //           // Display two tiles per row for larger screens
          //           BatchData? secondData;
          //           if (firstIndex + 1 < controller.batchList.length) {
          //             secondData = controller.batchList.elementAt(firstIndex + 1);
          //           }
          //           return Row(
          //             children: [
          //               Expanded(
          //                 child: liveBatchTile(
          //                   isPast: true,
          //                   data: firstData,
          //                   boxBgColor: ColorResource.white,
          //                   boxFgColor: ColorResource.secondaryColor,
          //                   bottomBgColor: ColorResource.secondaryColor,
          //                   sideText: firstData.courseOfferTitle,
          //                   onExplore: () {
          //                     Get.toNamed(
          //                       Routes.batchDetails,
          //                       arguments: [
          //                         firstData,
          //                         true,
          //                         controller.filterSubBatches(batchId: firstData.id ?? 0),
          //                       ],
          //                     );
          //                   },
          //                   showDivider: firstIndex != controller.batchList.length - 1,
          //                 ),
          //               ),
          //               const SizedBox(width: 20),
          //               if (secondData != null)
          //                 Expanded(
          //                   child: liveBatchTile(
          //                     isPast: true,
          //                     data: secondData,
          //                     boxBgColor: ColorResource.white,
          //                     boxFgColor: ColorResource.secondaryColor,
          //                     bottomBgColor: ColorResource.secondaryColor,
          //                     sideText: secondData.courseOfferTitle,
          //                     onExplore: () {
          //                       Get.toNamed(
          //                         Routes.batchDetails,
          //                         arguments: [
          //                           secondData,
          //                           true,
          //                           controller.filterSubBatches(batchId: secondData?.id ?? 0),
          //                         ],
          //                       );
          //                     },
          //                     showDivider: firstIndex + 1 != controller.batchList.length - 1,
          //                   ),
          //                 ),
          //             ],
          //           );
          //         }
          //       },
          //     ),
          //   );
          // })
        ],
      ),
    );
  }
}


/*           Wrap(
                        runSpacing: DimensionResource.marginSizeSmall,
                        children: List.generate(controller.batchList.length, (index) {
                          BatchData data = controller.batchList.elementAt(index);
                           return (width < 500)
                      ? Padding(
                      padding: const EdgeInsets.all(8.0),
                     child: liveBatchTile(
                    isPast: true,
                    data: data,
                    boxBgColor: ColorResource.white,
                    boxFgColor: ColorResource.secondaryColor,
                    bottomBgColor: ColorResource.secondaryColor,
                    sideText: data.courseOfferTitle,
                    onExplore: () {
                      Get.toNamed(Routes.batchDetails, arguments: [
                        data,
                        true,
                        controller.filterSubBatches(
                            batchId: data.id ?? 0),
                        // [
                        //   SubBatch.fromJson(
                        //       {"id": 51, "start_date": "2024-07-02"}),
                        //   SubBatch.fromJson(
                        //       {"id": 51, "start_date": "Past Classes"}),
                        // ]
                      ]);
                    },
                    showDivider: index !=
                        controller.batchData.value.data!.length - 1,
                  ),
                ):itemCardPastRecording(data) ;
              }),


            );*/