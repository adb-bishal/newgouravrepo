import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';

import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/utils/app_constants.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/string_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../../enum/routing/routes/app_pages.dart';
import '../../../../widgets/view_helpers/small_button.dart';
import '../home_view_screen.dart';

class TrendingCoursesWidget extends StatelessWidget {
  final HomeDataModelDatum homeDataModelDatum;
  const TrendingCoursesWidget({Key? key, required this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(
            () {}, homeDataModelDatum.title ?? StringResource.tradingCourses,
            showIcon: false,
            enableTopPadding: false,
            enableBottomPadding: false),
        SizedBox(
          height: (homeDataModelDatum.data?.isNotEmpty ?? false) &&
                  homeDataModelDatum.data?.length == 1
              ? 150
              : 300,
          child: GridView.builder(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            itemCount: homeDataModelDatum.data?.length ?? 0,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount:
                    (homeDataModelDatum.data?.isNotEmpty ?? false) &&
                            homeDataModelDatum.data?.length == 1
                        ? 1
                        : 2,
                childAspectRatio:
                    (homeDataModelDatum.data?.isNotEmpty ?? false) &&
                            ((homeDataModelDatum.data?.length ?? 0) <= 2)
                        ? (2 / 4.4)
                        : (2 / 3.5),
                mainAxisSpacing: DimensionResource.marginSizeSmall - 3,
                crossAxisSpacing: DimensionResource.marginSizeSmall - 3),
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              DatumDatum data = homeDataModelDatum.data!.elementAt(index);
              return InkWell(
                splashColor: Colors.transparent,
                onTap: () {
                  switch (data.typeId) {
                    case 1:
                      Get.toNamed(
                              Routes.textCourseDetail(id: data.id.toString()),
                              arguments: [
                            data.category?.title,
                            data.id.toString()
                          ])!
                          .then((value) {
                        Get.find<HomeController>()
                            .getContinueLearning(isFirst: true);
                      });
                      break;
                    case 2:
                      Get.toNamed(
                              Routes.audioCourseDetail(id: data.id.toString()),
                              arguments: [
                            CourseDetailViewType.audioCourse,
                            data.id.toString(),
                            data.categoryId.toString(),
                            data.courseTitle
                          ])!
                          .then((value) {
                        Get.find<HomeController>()
                            .getContinueLearning(isFirst: true);
                      });
                      break;
                    default:
                      AppConstants.instance.videoCourseId.value =
                          (data.id ?? '').toString();

                      Get.toNamed(
                              Routes.videoCourseDetail(id: data.id.toString()),
                              arguments: [
                            data.category?.title,
                            data.id.toString()
                          ])!
                          .then((value) {
                        Get.find<HomeController>()
                            .getContinueLearning(isFirst: true);
                      });
                      break;
                  }
                },
                child: Card(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                  child: Stack(
                    children: [
                      Positioned(
                        top: 0,
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: cachedNetworkImage(data.image ?? ""),
                        ),
                      ),
                      Container(
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        decoration: BoxDecoration(
                            color: ColorResource.black.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.only(
                            top: DimensionResource.marginSizeExtraSmall,
                            right: DimensionResource.marginSizeExtraSmall,
                            left: DimensionResource.marginSizeSmall,
                            bottom: DimensionResource.marginSizeSmall),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Align(
                                alignment: Alignment.topRight,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Visibility(
                                      visible:
                                          (data.isFree == 0 ? true : false),
                                      child: const ProContainerButton(
                                        isCircle: true,
                                      ),
                                    ),
                                    StarContainer(
                                      rating: data.avgRating.toString(),
                                      fontColor: ColorResource.secondaryColor,
                                      bgColor: ColorResource.white,
                                    ),
                                  ],
                                )),
                            Align(
                                alignment: Alignment.bottomLeft,
                                child: Container(
                                    constraints: BoxConstraints(
                                        maxWidth: Get.width * 0.4),
                                    child: Text(
                                      data.courseTitle ?? "",
                                      style: StyleResource.instance
                                          .styleSemiBold(
                                              fontSize: DimensionResource
                                                      .fontSizeDefault -
                                                  1,
                                              color: ColorResource.white),
                                    )))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        )
      ],
    );
  }
}
