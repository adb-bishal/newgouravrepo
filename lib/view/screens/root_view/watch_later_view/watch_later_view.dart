import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view_model/controllers/root_view_controller/watch_later_controller/watch_later_controller.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';
import '../home_view/widget/scalps_widget.dart';

class WatchLaterView extends StatelessWidget {
  const WatchLaterView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: "Watch Later",
      ),
      onActionBuilder: (context, controller) => [
        // InkWell(
        //     onTap: (){
        //       BottomSheetCommon(
        //           child: LiveFilterScreen(
        //             isPastFilter: false,
        //             isHideCategory: true,
        //             title: "Courses Level",
        //             isHideLanguage: true,
        //             isHideLevel: true,
        //             isHideTime: true,
        //             onCategorySelect: (val) {},
        //             onRatingSelect: (val) {},
        //             onSubscriptionSelect: (val) {},
        //           )).present(context);
        //     },
        //     child: Image.asset(ImageResource.instance.filterIcon,height: 18,))
      ],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: WatchLaterController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, WatchLaterController controller) {
    return SingleChildScrollView(
      child: Obx(() {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: DimensionResource.marginSizeSmall,
            ),
            ...List.generate(
                controller.items.isEmpty ? 1 : controller.items.length,
                (index) {
              if (controller.isDataLoading.value) {
                return ShimmerEffect.instance.watchLaterLoader();
              } else {
                if (controller.items.isEmpty) {
                  return SizedBox(
                      height: Get.height * 0.65,
                      width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Center(
                            child: IconButtonLayout(
                              onTap: () async {
                                Get.back();
                                Get.back();
                                Get.find<RootViewController>()
                                    .selectedTab
                                    .value = 1;
                              },
                              secondImage: null,
                              image: ImageResource.instance.likeIcon,
                              iconSize: 11,
                              bgColor: ColorResource.mateRedColor,
                              iconColor: ColorResource.white,
                            ),
                          ),
                          const SizedBox(
                            height: DimensionResource.marginSizeDefault,
                          ),
                          Center(
                            child: Text(
                              StringResource.addDataToWatchLater,
                              style: StyleResource.instance.styleSemiBold(),
                              textAlign: TextAlign.center,
                            ),
                          )
                        ],
                      ));
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
        );
      }),
    );
  }
}
