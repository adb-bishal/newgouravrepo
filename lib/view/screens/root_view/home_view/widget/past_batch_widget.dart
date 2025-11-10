import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/batch_models/all_batch_model.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/widgets/batch_widgets.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/string_resource.dart';
import '../../../../../view_model/controllers/batch_controller/live_batch_controller.dart';
import '../../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../../enum/routing/routes/app_pages.dart';

class PastBatchesWidget extends StatelessWidget {
  final HomeDataModelDatum homeDataModelDatum;

  const PastBatchesWidget({Key? key, required this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PastClassesController controller = Get.put(PastClassesController());
    // double width = MediaQuery.of(context).size.width;
    // final displayList = controller.batchData.value.data;

    return Obx(() {
      final displayList = controller.batchData.value.data;

      if (displayList == null || displayList.isEmpty) {
        // Trigger a data fetch or show a loader
        controller.getBatches(); // Ensure this fetches the data
        return const Center(
          child: CircularProgressIndicator(),
        );
      }

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowTile(() {
            // print('sefswdefvzdfvc');
            // Get.toNamed(
            //   Routes.batchDetails,
            // );
            Get.find<LiveBatchesController>().isTabValueChange.value = true;

            Get.find<RootViewController>().selectedTab.value = 3;
            Get.find<LiveBatchesController>().tabChange();
          }, homeDataModelDatum.title ?? StringResource.batchesHeading,
              showIcon: true,
              enableTopPadding: false,
              enableBottomPadding: true),
          SizedBox(
            height: (homeDataModelDatum.data?.isNotEmpty ?? false) &&
                    homeDataModelDatum.data?.length == 1
                ? 165
                : 335,
            child: GridView.builder(
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(
                  horizontal: DimensionResource.marginSizeDefault),
              itemCount: homeDataModelDatum.data?.length ?? 0,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      (homeDataModelDatum.data?.isNotEmpty ?? false) &&
                              homeDataModelDatum.data?.length == 1
                          ? 1
                          : 2,
                  childAspectRatio:
                      (homeDataModelDatum.data?.isNotEmpty ?? false) &&
                              homeDataModelDatum.data?.length == 1
                          ? .484
                          : 2 / 3.5,
                  mainAxisSpacing: DimensionResource.marginSizeSmall,
                  crossAxisSpacing: DimensionResource.marginSizeSmall - 5),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                BatchData firstData = displayList![index + 1];

                // BatchData firstData = displayList![index];
                DatumDatum data = homeDataModelDatum.data!.elementAt(index);
                return InkWell(
                    splashColor: ColorResource.white,
                    onTap: () {},
                    child: homeTiling(
                      index: index,
                      isPast: true,
                      data: homeDataModelDatum,
                      boxBgColor: ColorResource.white,
                      boxFgColor: ColorResource.secondaryColor,
                      bottomBgColor: ColorResource.secondaryColor,
                      isHome: true,
                      onExplore: () {
                        print('Exploring data...');

                        // Filter `firstData` list to find matching entries
                        final matchingData = displayList?.where((batchData) {
                          return batchData.id == data.id;
                        }).toList();

                        if (matchingData != null && matchingData.isNotEmpty) {
                          // Navigate with the first matching data
                          Get.toNamed(
                            Routes.batchDetails,
                            arguments: [
                              matchingData
                                  .first, // Pass the first matching item
                              true, // isPast
                            ],
                          );
                        } else {
                          // Handle no match case
                          print("No matching data found in firstData.");
                        }
                      },
                    ));
              },
            ),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          )
        ],
      );
    });
  }
}
