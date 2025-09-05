import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/subscription_models/offer_code_model.dart';
import 'package:stockpathshala_beta/view/screens/subscription_view/subscription_view.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';
import 'package:stockpathshala_beta/view_model/controllers/subscription_controller/subscription_controller.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/string_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../base_view/base_view_screen.dart';

class OfferView extends StatelessWidget {
  const OfferView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Retrieve the argument passed from the previous screen
    final arguments = Get.arguments;
    final bool isMentorShow = arguments?['isMentorShow'] ?? false;

    print("sdhfnjklsdhbkjljk : ${isMentorShow}");
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => TitleBarCentered(
        titleText: StringResource.coupon,
      ),
      onActionBuilder: (context, controller) => [],
      onBackClicked: (context, controller) {
        Get.back();
      },
      bodyColor: ColorResource.black,
      viewControl: SubscriptionController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller, isMentorShow),
    );
  }

  Widget _mainPageBuilder(BuildContext context,
      SubscriptionController controller, bool isMentorShow) {
    return Obx(() {
      return controller.isOfferDataLoading.value
          ? const CommonCircularIndicator()
          : controller.dataPagingController.value.list.isEmpty
              ? const NoDataFound()
              : ListView(
                  controller:
                      controller.dataPagingController.value.scrollController,
                  children: [
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: DimensionResource.marginSizeDefault,
                    //       vertical: DimensionResource.marginSizeSmall),
                    //   child: Text(
                    //     "Apply Coupon",
                    //     style: StyleResource.instance
                    //         .styleSemiBold(color: ColorResource.white),
                    //   ),
                    // ),
                    // Container(
                    //   height: 40,
                    //   margin: const EdgeInsets.symmetric(
                    //       horizontal: DimensionResource.marginSizeDefault),
                    //   decoration: BoxDecoration(
                    //       color: ColorResource.white,
                    //       borderRadius: BorderRadius.circular(4)),
                    //   child: Row(
                    //     children: [
                    //       Expanded(
                    //           child: SimpleTextField(
                    //         controller: TextEditingController(),
                    //         hintText: StringResource.applyCoupon,
                    //         contentPadding: const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 6.0),
                    //         style: StyleResource.instance
                    //             .styleRegular(fontSize: DimensionResource.fontSizeSmall),
                    //       )),
                    //       Padding(
                    //         padding: const EdgeInsets.all(5.0),
                    //         child: ContainerButton(
                    //             radius: 5,
                    //             text: "APPLY",
                    //             fontSize: DimensionResource.fontSizeSmall,
                    //             color: ColorResource.primaryColor,
                    //             fontColor: ColorResource.white,
                    //             padding:
                    //                 const EdgeInsets.symmetric(horizontal: 12, vertical: 3),
                    //             onPressed: () {}),
                    //       )
                    //     ],
                    //   ),
                    // ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensionResource.marginSizeDefault,
                          vertical: DimensionResource.marginSizeSmall + 5),
                      child: Text(
                        "View More Offers",
                        style: StyleResource.instance
                            .styleSemiBold(color: ColorResource.white),
                      ),
                    ),
                    ...List.generate(
                        controller.dataPagingController.value.list.length,
                        (index) {
                      Datum data = controller.dataPagingController.value.list
                          .elementAt(index);
                      return Padding(
                          padding: const EdgeInsets.only(
                              bottom: DimensionResource.marginSizeSmall),
                          child: couponCodeContainer(data,
                              isOfferView: true,
                              controller: controller,
                              isMentorship: isMentorShow));
                    })
                  ],
                );
    });
  }
}
