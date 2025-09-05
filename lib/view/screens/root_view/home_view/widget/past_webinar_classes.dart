import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';

import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/string_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../../view_model/routes/app_pages.dart';
import '../../../../widgets/button_view/common_button.dart';
import '../../../../widgets/view_helpers/small_button.dart';
import '../home_view_screen.dart';

class PastWebinarClassesWidget extends StatelessWidget {
  final HomeDataModelDatum homeDataModelDatum;
  const PastWebinarClassesWidget({Key? key, required this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    PastClassesController pastClassesController =
        Get.put(PastClassesController());
    final authService = Get.find<AuthService>();
    final userRole = authService.userRole.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(() {
          Get.find<LiveClassesController>().isTabValueChange.value = true;

          Get.find<RootViewController>().selectedTab.value = 2;
          Get.find<LiveClassesController>().tabChange();
          Get.find<PastClassesController>().onRefresh();
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
                        : 2 / 4.2,
                mainAxisSpacing: DimensionResource.marginSizeSmall,
                crossAxisSpacing: DimensionResource.marginSizeSmall - 5),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DatumDatum data = homeDataModelDatum.data!.elementAt(index);
              bool trialStatus = data.isTrial == 0 ? false : true;
              return InkWell(
                splashColor: ColorResource.white,
                onTap: () {
                  // if (data.batchId != null) {
                  //   AppConstants.instance.batchId.value = (data.id.toString());
                  //   Get.toNamed(
                  //       Routes.batchClassDetails(id: data.id.toString()),
                  //       arguments: [false, data.id.toString()]);
                  // } else {

                  logPrint("trailStatus is : ${trialStatus}");
                  AppConstants.instance.liveId.value = (data.id.toString());
                  Get.toNamed(Routes.liveClassDetail(id: data.id.toString()),
                      arguments: [true, data.id.toString(), trialStatus]);
                  // }
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
                              Align(
                                alignment: Alignment.topRight,
                                child: userRole == "trial_user"
                                    // ||
                                    //     userRole == "trial_expired_user"
                                    ? trialStatus
                                        ? Container()
                                        // FreeContainerButton(
                                        //     isCircle: true,
                                        //     isShow:
                                        //         isTrial) // Show FreeContainerButton if isTrial is true
                                        : const ProContainerButton(
                                            isCircle: true,
                                            isShow: true,
                                          ) // Show ProContainerButton if isTrial is false

                                    : userRole != "pro_user"
                                        ? const ProContainerButton(
                                            isCircle: true,
                                            isShow: true,
                                          )
                                        : Container(),
                              ),
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
                                                    fontSize: DimensionResource
                                                            .fontSizeExtraSmall -
                                                        3)
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
                                                      fontSize: DimensionResource
                                                              .fontSizeExtraSmall -
                                                          1,
                                                      color: ColorResource
                                                          .greenColor),
                                            ),
                                          ),
                                          Text(
                                            data.title ?? "",
                                            style: StyleResource.instance
                                                .styleSemiBold(
                                                    fontSize: DimensionResource
                                                        .fontSizeSmall,
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
