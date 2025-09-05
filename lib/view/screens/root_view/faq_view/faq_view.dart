import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';
import 'package:stockpathshala_beta/model/models/promocode_model/faq_model.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import '../../../../model/services/pagination.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view_model/controllers/root_view_controller/faq_controller/faq_controller.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';

class FaqView extends StatelessWidget {
  const FaqView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BaseView(
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: "FAQs",
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
      padding:  EdgeInsets.symmetric( horizontal:screenWidth<500?0: 4 , vertical: screenWidth<500?0:22),
      child: faqList(controller: controller  , context:context),
    );
  }

  Widget faqList({required FaqController controller, required BuildContext context}) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Obx(() => controller.isLoading.value
        ? ShimmerEffect.instance.faqLoader()
        : controller.pagingController.value.list.isNotEmpty
            ? PaginationView<Datum>(
                onRefresh: () async {},
                itemBuilder: (context, index, data) {
                  //Datum data = controller.pagingController.value.list.elementAt(index);
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: index ==
                                controller.pagingController.value.list.length -
                                    1
                            ? controller
                                    .pagingController.value.isDataLoading.value
                                ? 10
                                : DimensionResource.marginSizeDefault
                            : 0),
                    child: ExpansionTile(
                      textColor: ColorResource.secondaryColor,
                      collapsedTextColor: ColorResource.secondaryColor,
                      iconColor: ColorResource.primaryColor,
                      collapsedIconColor: ColorResource.secondaryColor,
                      childrenPadding: const EdgeInsets.symmetric(
                          horizontal: DimensionResource.marginSizeDefault),
                      title: Text(
                        data.question?.capitalize ?? "",
                        style: StyleResource.instance.styleRegular(
                            fontSize:screenWidth<500? DimensionResource.fontSizeSmall + 1:DimensionResource.fontSizeLarge),
                      ),
                      children: [
                        Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                              color:
                                  ColorResource.primaryColor.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: DimensionResource.marginSizeSmall,
                              vertical: DimensionResource.marginSizeSmall),
                          child: Text(
                            data.answer ?? "",
                            style: StyleResource.instance
                                .styleLight(
                                    fontSize:screenWidth<500? DimensionResource.fontSizeSmall:DimensionResource.fontSizeLarge)
                                .copyWith(letterSpacing: 0.4),
                          ),
                        ),
                        const SizedBox(
                          height: DimensionResource.marginSizeSmall,
                        )
                      ],
                    ),
                  );
                },
                errorBuilder: (context) => Container(),
                bottomLoaderBuilder: (context) => const Padding(
                      padding: EdgeInsets.only(bottom: 100.0),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: ColorResource.secondaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                pagingScrollController: controller.pagingController.value)
            : const NoDataFound(
                showText: true,
                text: "FAQ Will Be Added Soon.",
              ));
  }
}
