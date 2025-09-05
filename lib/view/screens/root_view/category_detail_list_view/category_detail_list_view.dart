import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/base_view/base_view_screen.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view_model/controllers/root_view_controller/category_detail_controller/category_detail_controller.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';

class CategoryDetailView extends StatelessWidget {
  const CategoryDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => Obx(() {
        return TitleBarCentered(
          titleText: controller.categoryType.value,
        );
      }),
      onActionBuilder: (context, controller) => [],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: CategoryDetailController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, CategoryDetailController controller) {
    return Obx(() {
      return RefreshIndicator(
        color: ColorResource.primaryColor,
        onRefresh: controller.onRefresh,
        child: ListView(
          children: [
            const SizedBox(
              height: DimensionResource.marginSizeSmall,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault,
              ),
              child: Text(
                '${StringResource.contentRelate} "${controller.categoryType.value}"'
                        .capitalize ??
                    "",
                style: StyleResource.instance.styleSemiBold(),
              ),
            ),
            const SizedBox(
              height: DimensionResource.marginSizeSmall,
            ),
            ...List.generate(
                controller.items.isEmpty ? 1 : controller.items.length,
                (index) {
              if (controller.isDataLoading.value) {
                return ShimmerEffect.instance.allCatogaryViewLoader();
              } else {
                if (controller.items.isEmpty) {
                  return SizedBox(
                      height: Get.height * 0.65, child: const NoDataFound());
                } else {
                  Widget currentWidget = controller.items.elementAt(index);
                  return currentWidget;
                }
              }
            }),
            const SizedBox(
              height: DimensionResource.marginSizeExtraLarge,
            )
          ],
        ),
      );
    });
  }

  Widget slideIt(BuildContext context, int index, animation,
      CategoryDetailController controller) {
    Widget currentWidget = controller.items.elementAt(index);
    return SlideTransition(
      position: Tween<Offset>(
        begin: const Offset(-1, 0),
        end: const Offset(0, 0),
      ).animate(animation),
      child: currentWidget,
    );
  }
}
