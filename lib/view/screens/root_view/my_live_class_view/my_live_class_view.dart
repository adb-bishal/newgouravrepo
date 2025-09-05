import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/common_container_model/common_container_model.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view_model/controllers/root_view_controller/my_live_class_controller/my_live_class_controller.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';
import '../live_classes_view/live_classes_view.dart';

class MyLiveClassView extends StatelessWidget {
  const MyLiveClassView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: "My Live Classes",
      ),
      onActionBuilder: (context, controller) => [],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: MyLiveClassController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, MyLiveClassController controller) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Text(
            "List of My Live Classes",
            style: StyleResource.instance.styleSemiBold(),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          videoCourseWrapList(myLiveClassController: controller),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          Visibility(
              visible:
                  controller.dataPagingController.value.isDataLoading.value,
              child: const Padding(
                padding: EdgeInsets.only(bottom: 15.0),
                child: CommonCircularIndicator(),
              )),
        ],
      ),
    );
  }

  Widget videoCourseWrapList(
      {required MyLiveClassController myLiveClassController}) {
    return Obx(() => myLiveClassController.isDataLoading.value
        ? ShimmerEffect.instance.commonPageGridShimmer()
        : myLiveClassController.dataPagingController.value.list.isEmpty
            ? const SizedBox(
                height: 500,
                child: NoDataFound(
                  text: "Register for the Upcoming Live Class Now!",
                  showText: true,
                ))
            : Wrap(
                spacing: DimensionResource.marginSizeDefault,
                runSpacing: DimensionResource.marginSizeDefault,
                children: List.generate(
                    myLiveClassController
                        .dataPagingController.value.list.length, (index) {
                  CommonDatum data = CommonDatum.fromJson(myLiveClassController
                      .dataPagingController.value.list
                      .elementAt(index)
                      .toJson());
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: myLiveClassController.dataPagingController.value
                                        .list.length -
                                    1 ==
                                index
                            ? DimensionResource.marginSizeDefault
                            : 0),
                    child: liveClassesContainer(index,
                        height: 185,
                        width: 157,
                        fontSize: DimensionResource.marginSizeSmall + 1,
                        data: data),
                  );
                }),
              ));
  }
}
