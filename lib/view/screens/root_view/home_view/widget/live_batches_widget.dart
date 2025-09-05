import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/batch_models/all_batch_model.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/widgets/batch_widgets.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/home_view_screen.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/string_resource.dart';
import '../../../../../view_model/controllers/batch_controller/live_batch_controller.dart';
import '../../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../../view_model/routes/app_pages.dart';

class LiveBatchesWidget extends StatelessWidget {
  final HomeDataModelDatum homeDataModelDatum;

  const LiveBatchesWidget({Key? key, required this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    LiveBatchesController controller = Get.put(LiveBatchesController());
    double width = MediaQuery.of(context).size.width;

    return Obx(() {
      // Observe the controller data for changes
      final displayList = controller.batchData.value.data;

      if (displayList == null || displayList.isEmpty) {
        // Trigger a data fetch or show a loader
        controller.getBatchData(); // Ensure this fetches the data
        return const Center(
          child: CircularProgressIndicator(),
        );
      }
      final screenWidth = MediaQuery.of(context).size.width;

      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          rowTile(() {
            Get.find<RootViewController>().selectedTab.value = 3;
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
                          : screenWidth < 500
                              ? 2 / 3.5
                              : 2 / 4.5,
                  mainAxisSpacing: DimensionResource.marginSizeSmall,
                  crossAxisSpacing: DimensionResource.marginSizeSmall - 5),
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                // Safely access displayList and its elements
                if (index + 1 >= displayList.length) return const SizedBox();

                BatchData firstData = displayList[index + 1];
                DatumDatum data = homeDataModelDatum.data!.elementAt(index);

                return InkWell(
                  splashColor: ColorResource.white,
                  onTap: () {
                    // Handle tap
                  },
                  child: homeTiling(
                      index: index,
                      isPast: false,
                      data: homeDataModelDatum,
                      boxBgColor: ColorResource.white,
                      boxFgColor: ColorResource.secondaryColor,
                      bottomBgColor: ColorResource.secondaryColor,
                      isHome: true,
                      onExplore: () {
                        print('Exploring data...');

                        // Filter `firstData` list to find matching entries
                        final matchingData = displayList?.where((batchData) {
                          print(
                              'Exploring data...batchData.id : ${batchData.id}');
                          print('Exploring data...data.id : ${data.id}');
                          return batchData.id == data.id;
                        }).toList();

                        if (matchingData != null && matchingData.isNotEmpty) {
                          // Navigate with the first matching data
                          Get.toNamed(
                            Routes.batchDetails,
                            arguments: [matchingData.first, false],
                          );
                        } else {
                          // Handle no match case
                          print("No matching data found in firstData.");
                        }
                      }),
                );
              },
            ),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
        ],
      );
    });
  }
}
