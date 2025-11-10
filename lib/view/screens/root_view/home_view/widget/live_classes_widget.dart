import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';

import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/string_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../../enum/routing/routes/app_pages.dart';
import '../../../../widgets/button_view/common_button.dart';
import '../../../../widgets/view_helpers/small_button.dart';
import '../home_view_screen.dart';

class LiveClassesWidget extends StatelessWidget {
  final HomeDataModelDatum homeDataModelDatum;
  const LiveClassesWidget({Key? key, required this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(() {
          Get.find<RootViewController>().selectedTab.value = 2;
        }, homeDataModelDatum.title ?? StringResource.liveWebinar,
            showIcon: true,
            enableTopPadding: false,
            enableBottomPadding: false),
        SizedBox(
          height: (homeDataModelDatum.data?.isNotEmpty ?? false) &&
                  homeDataModelDatum.data?.length == 1
              ? 160
              : 320,
          child: GridView.builder(
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
                        : MediaQuery.of(Get.context!).size.width < 500
                            ? 2 / 4.2
                            : 2 / 5.2,
                mainAxisSpacing: DimensionResource.marginSizeSmall,
                crossAxisSpacing: DimensionResource.marginSizeSmall - 5),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DatumDatum data = homeDataModelDatum.data!.elementAt(index);
              return InkWell(
                splashColor: ColorResource.white,
                onTap: () {
                  if (data.batchId != null) {
                    AppConstants.instance.batchId.value = (data.id.toString());
                    Get.toNamed(
                        Routes.batchClassDetails(id: data.id.toString()),
                        arguments: [false, data.id.toString()]);
                  } else {
                    AppConstants.instance.liveId.value = (data.id.toString());
                    Get.toNamed(Routes.liveClassDetail(id: data.id.toString()),
                        arguments: [false, data.id.toString()]);
                  }
                },
                child: SizedBox(
                  height: 158,
                  child: Card(
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    // margin: const EdgeInsets.only(bottom: DimensionResource.marginSizeDefault),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Stack(
                      children: [
                        Positioned(
                          top: 0,
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: cachedNetworkImage(data.image ?? "",
                                fit: BoxFit.cover),
                          ),
                        ),
                        Container(
                          decoration: BoxDecoration(
                              color: ColorResource.black.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(10)),
                          padding: const EdgeInsets.only(
                              top: DimensionResource.marginSizeExtraSmall,
                              right: DimensionResource.marginSizeExtraSmall,
                              left: DimensionResource.marginSizeSmall,
                              bottom: DimensionResource.marginSizeSmall),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Align(
                                  alignment: Alignment.topRight,
                                  child: LiveContainer()),
                              Align(
                                  alignment: Alignment.bottomLeft,
                                  child: Container(
                                      width: Get.width * 0.5,
                                      decoration: BoxDecoration(
                                          color: ColorResource.black
                                              .withOpacity(0.65),
                                          borderRadius:
                                              BorderRadius.circular(7)),
                                      padding: const EdgeInsets.all(8),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          ContainerButton(
                                            text: data.category?.title
                                                    ?.toUpperCase() ??
                                                "",
                                            onPressed: () {},
                                            color: ColorResource.yellowColor,
                                            textStyle: StyleResource.instance
                                                .styleMedium(
                                                    fontSize: MediaQuery.of(Get
                                                                    .context!)
                                                                .size
                                                                .width <
                                                            500
                                                        ? DimensionResource
                                                                .fontSizeExtraSmall -
                                                            3
                                                        : DimensionResource
                                                                .fontSizeSmall -
                                                            2)
                                                .copyWith(letterSpacing: .3),
                                            radius: 3,
                                            padding: const EdgeInsets.all(3),
                                          ),
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 5),
                                            child: Text(
                                              AppConstants.formatDateAndTime(
                                                  data.startDate),
                                              style: StyleResource.instance
                                                  .styleMedium(
                                                      fontSize: MediaQuery.of(Get
                                                                      .context!)
                                                                  .size
                                                                  .width <
                                                              500
                                                          ? DimensionResource
                                                                  .fontSizeExtraSmall -
                                                              1
                                                          : DimensionResource
                                                              .fontSizeSmall,
                                                      color: ColorResource
                                                          .greenColor),
                                            ),
                                          ),
                                          Text(
                                            data.title ?? "",
                                            style: StyleResource.instance
                                                .styleSemiBold(
                                                    fontSize: MediaQuery.of(Get
                                                                    .context!)
                                                                .size
                                                                .width <
                                                            500
                                                        ? DimensionResource
                                                            .fontSizeSmall
                                                        : DimensionResource
                                                            .fontSizeDefault,
                                                    color: ColorResource.white),
                                          ),
                                        ],
                                      )))
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        )
      ],
    );
  }
}
