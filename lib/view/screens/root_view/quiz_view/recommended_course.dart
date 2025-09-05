import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';

import '../../../../model/utils/app_constants.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/quiz_controller/recommended_controller.dart';
import '../../../widgets/button_view/common_button.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';
import '../courses_detail_view/course_detail_view.dart';

class RecommendedView extends StatelessWidget {
  const RecommendedView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      isBackShow: false,
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: "Recommended Courses",
      ),
      onActionBuilder: (context, controller) => [],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: RecommendedController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, RecommendedController controller) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            child: Text(
              "Based on your quiz performance recommended courses are:",
              style: StyleResource.instance.styleMedium(),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Obx(
            () => controller.isDataLoading.value
                ? ShimmerEffect.instance.commonPageGridShimmer()
                : controller.dataPagingController.isEmpty
                    ? const NoDataFound()
                    : controller.courseType.value ==
                            CourseDetailViewType.videoCourse
                        ? videoCourseWrapList(
                            categoryType: "Option Trading",
                            data: controller.dataPagingController)
                        : textCourseWrapList(
                            categoryType: "Option Trading",
                            data: controller.dataPagingController),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeLarge,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ContainerButton(
                //padding: EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeSmall,vertical: DimensionResource.marginSizeDefault-5),
                isIconShow: true,
                onPressed: () {
                  AppConstants.instance.valueListenerVar.value = "run";
                  Get.back(
                    result: true,
                  );
                },
                text: "Skip",
                radius: 8,
                fontColor: ColorResource.white,
              ),
              const SizedBox(
                width: DimensionResource.marginSizeDefault,
              )
            ],
          ),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
        ],
      ),
    );
  }
}
