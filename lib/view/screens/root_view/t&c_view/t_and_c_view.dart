import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';

import '../../../../view_model/controllers/root_view_controller/faq_controller/faq_controller.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';

class TermsAndCondition extends StatelessWidget {
  const TermsAndCondition({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => TitleBarCentered(
        titleText: StringResource.terms,
      ),
      onActionBuilder: (context, controller) => [],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: FaqController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(BuildContext context, FaqController controller) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding:  EdgeInsets.symmetric(
        vertical:screenWidth<500?0:8 ,
          horizontal: DimensionResource.marginSizeDefault),
      child: Obx(() => controller.isTncLoading.value
          ? ShimmerEffect.instance.tNcAllTextLoader()
          : controller.tncData.value.data == null ||
                  controller.tncData.value.data == ""
              ? const NoDataFound(
                  text: "Please Check stockpathshala.com for more information",
                  showText: true,
                )
              : SizedBox(
                  height: Get.height,
                  width: Get.width,
                  child: SingleChildScrollView(
                    child: Html(
                      data: controller.tncData.value.data ?? "",
                    ),
                  ),
                )),
    );
  }
}
