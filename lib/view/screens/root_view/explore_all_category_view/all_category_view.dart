import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/explore_all_category/all_category_model.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/base_view/base_view_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/home_view_screen.dart';
import 'package:stockpathshala_beta/view/widgets/bottom_sheet.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/radio_button_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import '../../../widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/all_category_controller/all_category_controller.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../widgets/search_widget/search_container.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';

class AllCategoryView extends StatelessWidget {
  const AllCategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: "Explore All Categories",
      ),
      onActionBuilder: (context, controller) => [
        InkWell(
            onTap: () {
              BottomSheetCommon(
                      child: CategoryFilterWidget(
                        controller: controller,
                      ),
                      isDismissible: true)
                  .present(context);
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.asset(
                ImageResource.instance.filterIcon,
                height: 18,
              ),
            ))
      ],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: AllCategoryController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, AllCategoryController controller) {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: DimensionResource.marginSizeDefault,
            ),
            SearchWidget(
              textEditingController: controller.categorySearchController.value,
              onChange: controller.onCategorySearch,
              onClear: () {
                controller.onCategorySearch("");
              },
            ),
            rowTile(() {}, StringResource.exploreAllCategories,
                showIcon: false,
                labelStyle: StyleResource.instance.styleSemiBold().copyWith(
                    fontSize: DimensionResource.fontSizeSmall + 1,
                    letterSpacing: .3)),
            const SizedBox(
              height: DimensionResource.marginSizeExtraSmall,
            ),
            Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DimensionResource.marginSizeDefault),
                child: controller.isCategoryLoading.value
                    ? ShimmerEffect.instance
                        .commonPageGridShimmer(length: 6, itemHeight: 120)
                    : (controller.allCategoryData.value.data?.isEmpty ?? true)
                        ? const SizedBox(height: 400, child: NoDataFound())
                        : GridView.builder(
                            shrinkWrap: true,
                            physics: const ClampingScrollPhysics(),
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing:
                                  DimensionResource.marginSizeSmall + 2,
                              mainAxisSpacing:
                                  DimensionResource.marginSizeSmall,
                              childAspectRatio: 1.25,
                            ),
                            itemCount:
                                controller.allCategoryData.value.data?.length ??
                                    0,
                            itemBuilder: (context, index) {
                              Datum data = controller
                                  .allCategoryData.value.data!
                                  .elementAt(index);
                              return _categoryCard(data);
                            }))
          ],
        ),
      );
    });
  }

  Widget _categoryCard(Datum data) {
    return Card(
      elevation: 3,
      shadowColor: ColorResource.white,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: SizedBox(
        height: 155,
        width: 160,
        child: GestureDetector(
          onTap: () {
            try {
              Get.toNamed(Routes.categoryDetail,
                  arguments: [data.title.toString().capitalize ?? "", data.id]);
            } catch (e) {
              logPrint("ee $e");
            }
          },
          child: Stack(
            children: [
              SizedBox(
                  height: 155,
                  width: 160,
                  child:
                      cachedNetworkImage(data.image ?? "", fit: BoxFit.cover)),
              Container(
                color: ColorResource.black.withOpacity(0.1),
                child: Center(
                  child: Text(
                    data.title.toString().capitalize ?? "",
                    style: StyleResource.instance
                        .styleMedium(color: ColorResource.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

class CategoryFilterWidget extends StatelessWidget {
  AllCategoryController controller;
  CategoryFilterWidget({super.key, required this.controller});

  RxInt selectIndex = 0.obs;

  @override
  Widget build(BuildContext context) {
    selectIndex.value = controller.selectedFilter.value;
    return TopPinContainer(
      child: Obx(() => Column(children: [
            ...List.generate(
                controller.filterList.length,
                (index) => Padding(
                      padding: const EdgeInsets.only(
                          left: DimensionResource.marginSizeDefault,
                          bottom: DimensionResource.marginSizeExtraSmall),
                      child: InkWell(
                        onTap: () {
                          selectIndex.value = index;
                        },
                        child: RadioButtonWidget(
                          text: controller.filterList[index],
                          isActive: selectIndex.value == index,
                        ),
                      ),
                    )),
            const SizedBox(
              height: DimensionResource.marginSizeDefault,
            ),
            CommonButton(
              text: "APPLY",
              loading: false,
              onPressed: () {
                controller.selectedFilter.value = selectIndex.value;
                controller.getAllCategory(
                    sort: controller.selectedFilter.value == 0 ? "ASC" : "DESC",
                    searchKeyWord: controller.searchKey.value);
                Get.back();
              },
              radius: 0,
              color: ColorResource.primaryColor,
            )
          ])),
    );
  }
}
