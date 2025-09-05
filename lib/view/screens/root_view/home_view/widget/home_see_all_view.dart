import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/home_controller/home_see_all_controller.dart';

import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/image_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import '../../../../widgets/bottom_sheet.dart';
import '../../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../../widgets/log_print/log_print_condition.dart';
import '../../../../widgets/no_data_found/no_data_found.dart';
import '../../../../widgets/search_widget/search_container.dart';
import '../../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../../base_view/base_view_screen.dart';
import '../../live_classes_view/filter_view/filter_view.dart';

class HomeSeeAllView extends StatelessWidget {
  const HomeSeeAllView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => Obx(() {
        return TitleBarCentered(
          titleText: controller.categoryHeadingType.value,
        );
      }),
      onActionBuilder: (context, controller) => [
        InkWell(
            onTap: () {
              BottomSheetCommon(
                      child: LiveFilterScreen(
                        listOfSelectedTeacher: const [],
                        listOFSelectedCat: controller.listOFSelectedCat,
                        listOFSelectedDuration: const [],
                        listOFSelectedLang: const [],
                        isPastFilter: false,
                        isHideCategory: false,
                        listOFSelectedLevel: const [],
                        isHideRating: true,
                        listOFSelectedRating: controller.selectedRating,
                        selectedSubscription:
                            controller.selectedSubScriptioin.value,
                        title: controller.categoryType.value ==
                                StringResource.singleAudio
                            ? "Filter Podcasts"
                            : "${controller.titleCategoryType.value.capitalize ?? ""} Filter",
                        isHideLanguage: true,
                        isHideLevel: true,
                        isHideTime: true,
                        isHideSubscription: false,
                        onClear: (val) {
                          logPrint("kjnj $val");
                          controller.isClearLoading.value = true;
                          Future.delayed(Duration.zero, () {
                            controller.isClearLoading.value = false;
                          });
                          controller.listOFSelectedCat.clear();
                          controller.selectedRating.value = val['rating'];
                          controller.selectedSubScriptioin.value =
                              val['is_free'];
                          controller.getCourseData(
                            pageNo: 1,
                            categoryId: controller.listOFSelectedCat
                                .map((element) => element.id)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            searchKeyWord: "",
                            rating: controller.selectedRating
                                .map((element) => element.ratingValue)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            subscriptionLevel: val['is_free'].optionName,
                          );
                          Get.back();
                        },
                        onApply: (val) {
                          controller.listOFSelectedCat.value = val['category'];
                          controller.selectedRating.value = val['rating'];
                          controller.selectedSubScriptioin.value =
                              val['is_free'];
                          controller.getCourseData(
                            pageNo: 1,
                            categoryId: controller.listOFSelectedCat
                                .map((element) => element.id)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            searchKeyWord: "",
                            rating: controller.selectedRating
                                .map((element) => element.ratingValue)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            subscriptionLevel: val['is_free'].optionName,
                          );
                        }, listOFSelectedDays: [],
                      ),
                      isDismissible: true)
                  .present(context)
                  .then((value) {
                Get.delete<ClassesFilterController>();
              });
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
      viewControl: HomeSeeAllController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, HomeSeeAllController controller) {
    return Obx(() {
      return RefreshIndicator(
        color: ColorResource.primaryColor,
        onRefresh: controller.onRefresh,
        child: ListView(
          shrinkWrap: true,
          controller: controller.dataPagingController.value.scrollController,
          children: [
            const SizedBox(
              height: DimensionResource.marginSizeSmall,
            ),
            SearchWidget(
                onChange: controller.onSearchChange,
                onClear: () {
                  controller.onSearchChange("");
                },
                textEditingController: controller.searchController.value),
            Padding(
              padding: const EdgeInsets.symmetric(
                  vertical: DimensionResource.marginSizeSmall,
                  horizontal: DimensionResource.marginSizeDefault),
              child: Obx(() {
                return Text(
                  controller.titleCategoryType.value.capitalize ?? "",
                  style: StyleResource.instance.styleSemiBold(),
                );
              }),
            ),
            controller.isDataLoading.value
                ? ShimmerEffect.instance.commonPageGridShimmer()
                : (controller.dataPagingController.value.list.isEmpty)
                    ? SizedBox(
                        height: Get.height * 0.65,
                        child: NoDataFound(
                          showText: true,
                          text:
                              "${StringResource.seeAllText}${controller.noDataType.value}",
                        ))
                    : MediaQuery.removePadding(
                        context: context,
                        removeTop: true,
                        child: controller.getWidget),
            const SizedBox(
              height: DimensionResource.marginSizeExtraLarge,
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
    });
  }
}
