import 'package:card_swiper/card_swiper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/scalp_model/scalp_data_model.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../view_model/controllers/root_view_controller/scalp_controller/scalp_controller.dart';
import '../../../widgets/log_print/log_print_condition.dart';
import 'content_screen.dart';

class ScalpView extends GetView<ScalpController> {
  const ScalpView({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.put(ScalpController());
    return Scaffold(
      backgroundColor: ColorResource.black,
      body: Obx(() {
        return Container(
          color: ColorResource.black,
          child: controller.isDataLoading.value
              ? const CommonCircularIndicator()
              : (controller.dataPagingController.value.list.isEmpty)
                  ? const NoDataFound(
                      isDark: true,
                      text: 'New Scalps Will Be Added Soon',
                      showText: true,
                    )
                  : Stack(
                      children: [
                        Positioned(
                          top: -10,
                          bottom: -35,
                          left: 0,
                          right: 0,
                          child: Swiper(
                            loop: true,
                            onIndexChanged: controller.onIndexChange,
                            controller: controller.swipeController.value,
                            itemBuilder: (BuildContext context, int index) {
                              Datum data = controller
                                  .dataPagingController.value.list
                                  .elementAt(index);
                              logPrint("dataass ${data.toJson()}");
                              return ContentScreen(
                                data: data,
                              );
                            },
                            viewportFraction: 1,
                            itemCount: controller
                                .dataPagingController.value.list.length,
                            scrollDirection: Axis.vertical,
                          ),
                        ),
                      ],
                    ),
          // PageView.builder(
          //   controller: controller.newsPageController,
          //   //loop: true,
          //   //onIndexChanged: controller.onIndexChange,
          //   //controller: controller.swipeController.value,
          //   onPageChanged: controller.onIndexChange,
          //   itemBuilder: (BuildContext context, int index) {
          //     Datum data = controller.dataPagingController.value.list
          //         .elementAt(index);
          //     return StackPageView(
          //       backgroundColor: ColorResource.black,
          //       controller: controller.newsPageController,
          //       index: index,
          //       child: Container(
          //         color: ColorResource.black,
          //         child: ContentScreen(
          //           data: data,
          //         ),
          //       ),
          //     );
          //   },
          //   //viewportFraction: 1,
          //   itemCount: controller.dataPagingController.value.list.length ?? 0,
          //   scrollDirection: Axis.vertical,
          // ),
        );
      }),
    );
  }
}
