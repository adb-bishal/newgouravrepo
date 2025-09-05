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
import '../../../../../view_model/routes/app_pages.dart';
import '../../../../widgets/view_helpers/small_button.dart';
import '../home_view_screen.dart';

class HomeContinueLearningWidget extends StatelessWidget {
  final HomeDataModelDatum homeDataModelDatum;
  const HomeContinueLearningWidget({Key? key, required this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(
            () {}, homeDataModelDatum.title ?? StringResource.continueLearning,
            showIcon: false,
            enableBottomPadding: false,
            enableTopPadding: false),
        Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(homeDataModelDatum.data!.length, (index) {
                DatumDatum data = homeDataModelDatum.data!.elementAt(index);
                return GestureDetector(
                    onTap: () {
                      switch (data.type) {
                        case "course_text":
                          Get.toNamed(
                              Routes.textCourseDetail(
                                  id: data.trackable?.id.toString()),
                              arguments: [
                                data.trackable?.courseTitle,
                                data.trackable?.id.toString()
                              ]);
                          break;
                        case "audio":
                          Get.toNamed(
                              Routes.audioCourseDetail(
                                  id: data.trackable?.id.toString()),
                              arguments: [
                                CourseDetailViewType.audio,
                                data.trackable?.id.toString(),
                                data.trackable?.categoryId.toString(),
                                data.trackable?.courseTitle
                              ]);
                          break;
                        case "course_audio":
                          Get.toNamed(
                              Routes.audioCourseDetail(
                                  id: data.trackable?.id.toString()),
                              arguments: [
                                CourseDetailViewType.audioCourse,
                                data.trackable?.id.toString(),
                                data.trackable?.categoryId.toString(),
                                data.trackable?.courseTitle
                              ]);
                          break;
                        case "video":
                          AppConstants.instance.singleCourseId.value =
                              (data.trackable!.id.toString());

                          Get.toNamed(
                              Routes.continueWatchScreen(
                                  id: data.trackable?.id.toString()),
                              arguments: [
                                data.trackable?.id.toString(),
                                data.trackable?.categoryId.toString(),
                              ]);
                          break;
                        case "course_video":
                          AppConstants.instance.videoCourseId.value =
                              (data.trackable!.id.toString());

                          Get.toNamed(
                              Routes.videoCourseDetail(
                                  id: data.trackable?.id.toString()),
                              arguments: [
                                data.trackable?.courseTitle ?? "",
                                data.trackable?.id.toString()
                              ]);
                          break;
                        default:
                          AppConstants.instance.videoCourseId.value =
                              (data.trackable!.id.toString());

                          Get.toNamed(
                              Routes.videoCourseDetail(
                                  id: data.trackable?.id.toString()),
                              arguments: [
                                data.trackable?.courseTitle ?? "",
                                data.trackable?.id.toString()
                              ]);
                          break;
                      }
                    },
                    child: Padding(
                      padding: EdgeInsets.only(
                          right: index ==
                                  (Get.find<HomeController>()
                                          .continueData
                                          .value
                                          .data
                                          ?.data
                                          ?.length ??
                                      0 - 1)
                              ? DimensionResource.marginSizeDefault
                              : 0),
                      child: learningContainer(index, data),
                    ));
              }),
            ),
          );
        }),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        )
      ],
    );
  }
}

Widget learningContainer(int index, DatumDatum data) {
  return Card(
    clipBehavior: Clip.antiAliasWithSaveLayer,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
    child: Stack(
      children: [
        Positioned(
          top: 0,
          bottom: 0,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 130,
            width: 136,
            child: cachedNetworkImage(
              data.trackable?.thumbnail ?? data.trackable?.image ?? "",
              fit: BoxFit.cover,
            ),
          ),
        ),
        Container(
          height: 130,
          width: 136,
          decoration: BoxDecoration(
              color: ColorResource.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.only(
              top: DimensionResource.marginSizeExtraSmall,
              right: DimensionResource.marginSizeExtraSmall,
              left: DimensionResource.marginSizeExtraSmall,
              bottom: DimensionResource.marginSizeSmall),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible: data.trackable?.avgRating != null &&
                    data.trackable?.avgRating != 0.0,
                child: Align(
                    alignment: Alignment.topRight,
                    child: StarContainer(
                      rating: data.trackable?.avgRating.toString() ?? "",
                    )),
              ),
              Text(
                data.trackable?.courseTitle ?? data.trackable?.aboutTitle ?? "",
                style: StyleResource.instance.styleMedium(
                    fontSize: DimensionResource.fontSizeSmall,
                    color: ColorResource.white),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              )
            ],
          ),
        )
      ],
    ),
  );
}
