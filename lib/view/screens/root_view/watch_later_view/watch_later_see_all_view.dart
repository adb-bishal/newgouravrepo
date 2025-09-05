import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/search_widget/search_container.dart';

import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import '../../../../view_model/controllers/root_view_controller/watch_later_controller/watch_later_see_all_controller.dart';
import '../../../widgets/bottom_sheet.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../widgets/log_print/log_print_condition.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';
import '../live_classes_view/filter_view/filter_view.dart';

class WatchLaterSeeAllView extends StatelessWidget {
  const WatchLaterSeeAllView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => Obx(() {
        return TitleBarCentered(
          titleText: controller.categoryType.value,
        );
      }),
      onActionBuilder: (context, controller) => [
        InkWell(
            onTap: () {
              BottomSheetCommon(
                  isDismissible: true,
                  child: LiveFilterScreen(
                    listOfSelectedTeacher: const [],
                    listOFSelectedRating: controller.selectedRating,
                    listOFSelectedCat: const [],
                    listOFSelectedDuration: const [],
                    listOFSelectedLang: const [],
                    listOFSelectedLevel: const [],
                    isHideSubscription: false,
                    isPastFilter: false,
                    isHideCategory: true,
                    title: "Courses Level",
                    isHideLanguage: true,
                    isHideLevel: true,
                    isHideTime: true,
                    selectedSubscription:
                        controller.selectedSubScriptioin.value,
                    onClear: (val) {
                      logPrint("kjnj $val");
                      controller.isClearLoading.value = true;
                      Future.delayed(Duration.zero, () {
                        controller.isClearLoading.value = false;
                      });
                      controller.selectedRating.value = val['rating'];
                      controller.selectedSubScriptioin.value = val['is_free'];
                      controller.getWishlistsData(
                        1,
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
                      controller.selectedRating.value = val['rating'];
                      controller.selectedSubScriptioin.value = val['is_free'];
                      controller.getWishlistsData(
                        1,
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
                  )).present(context).then((value) {
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
      viewControl: WatchLaterSeeAllController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, WatchLaterSeeAllController controller) {
    return Obx(() {
      return ListView(
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
                controller.categoryType.value,
                style: StyleResource.instance.styleSemiBold(),
              );
            }),
          ),
          controller.isDataLoading.value
              ? ShimmerEffect.instance.commonPageGridShimmer()
              : (controller.wishListData.value.data?.data?.isEmpty ?? true)
                  ? SizedBox(
                      height: Get.height * 0.65, child: const NoDataFound())
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
      );
    });
  }
}
