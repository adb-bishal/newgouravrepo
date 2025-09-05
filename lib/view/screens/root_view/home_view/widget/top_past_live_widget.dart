import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/services/auth_service.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/string_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../home_view_screen.dart';

class TopPastLiveWidget extends StatelessWidget {
  final HomeDataModelDatum homeDataModelDatum;
  final Function() onTap;
  const TopPastLiveWidget({
    super.key,
    required this.homeDataModelDatum,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final list = List<CommonDatum>.from(
        homeDataModelDatum.data!.map((x) => CommonDatum.fromJson(x.toJson())));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(() {
          Get.find<LiveClassesController>().isTabValueChange.value = true;

          Get.find<RootViewController>().selectedTab.value = 2;
          Get.find<LiveClassesController>().tabChange();
          Get.find<PastClassesController>().onRefresh();
        }, homeDataModelDatum.title ?? StringResource.topTen,
            showIcon: true,
            enableTopPadding: false,
            titleWidget: Container(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(Get.context!).size.width * 0.7),
              child: Row(
                children: [
                  Text(
                    homeDataModelDatum.title ?? StringResource.topTen,
                    style: StyleResource.instance.styleSemiBold().copyWith(
                        fontSize: MediaQuery.of(context).size.width < 500
                            ? DimensionResource.fontSizeDefault - 1
                            : DimensionResource.fontSizeExtraLarge,
                        color: ColorResource.secondaryColor,
                        letterSpacing: .3),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  const ProContainerButton(
                    isCircle: true,
                  ),
                ],
              ),
            )),
        SizedBox(
          height: 185,
          child: ListView.separated(
            separatorBuilder: (context, index) => const SizedBox.shrink(),
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            itemCount: list.length,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DatumDatum data = homeDataModelDatum.data!.elementAt(index);
              bool trialStatus = data.isTrial == 0 ? false : true;
              final video = list[index];
              return Padding(
                padding: EdgeInsets.only(
                    left: index != 0
                        ? DimensionResource.marginSizeExtraSmall + 1
                        : 0),
                child: Stack(
                  alignment: Alignment.topLeft,
                  children: [
                    InkWell(
                      splashColor: Colors.transparent,
                      onTap: () {
                        // if (data.batchId != null) {
                        //   AppConstants.instance.batchId.value = (data.id.toString());
                        //   Get.toNamed(
                        //       Routes.batchClassDetails(id: data.id.toString()),
                        //       arguments: [false, data.id.toString()]);
                        // } else {

                        logPrint("trailStatus is : ${trialStatus}");
                        AppConstants.instance.liveId.value =
                            (data.id.toString());
                        Get.toNamed(
                            Routes.liveClassDetail(id: data.id.toString()),
                            arguments: [true, data.id.toString(), trialStatus]);
                        // }
                      },
                      child: AbsorbPointer(
                        absorbing: !(Get.find<AuthService>().isPro.value &&
                            !Get.find<AuthService>().isGuestUser.value),
                        child: topPastClassesContainer(
                          0,
                          height: 185,
                          width: MediaQuery.of(context).size.width < 500
                              ? 157
                              : 190,
                          fontSize: 12,
                          isPast: true,
                          data: video,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -10,
                      child: Stack(
                        children: <Widget>[
                          Text(
                            '${index + 1}',
                            style: StyleResource.instance
                                .styleSemiBold(fontSize: 50)
                                .copyWith(
                                    foreground: Paint()
                                      ..style = PaintingStyle.stroke
                                      ..strokeWidth = 3.5
                                      ..color = ColorResource.primaryColor),
                          ),
                          // Solid text as fill.
                          Text(
                            '${index + 1}',
                            style: StyleResource.instance.styleSemiBold(
                                fontSize: 50, color: ColorResource.white),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        ),
      ],
    );
  }
}
