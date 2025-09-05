import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/home_data_model/continue_learning_model.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../../../../model/utils/app_constants.dart';
import '../../../../../model/utils/color_resource.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../model/utils/style_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../home_view_screen.dart';

class CountinueLearningContainerWidget extends StatelessWidget {
  // final Data homeDataModelDatum;
  const CountinueLearningContainerWidget({
    Key? key,
    //  required this.homeDataModelDatum
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return
      Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(
            () {},
            Get.find<HomeController>().continueData.value.data?.title ??
                StringResource.continueLearning,
            showIcon: false,
            enableBottomPadding: false,
            enableTopPadding: false),
        Obx(() {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                  Get.find<HomeController>().continueDataList.length, (index) {
                Datum data = Get.find<HomeController>()
                    .continueDataList
                    .elementAt(index);
                return GestureDetector(
                    onTap: () {
                      switch (data.type) {
                        case "course_text":
                          Get.toNamed(
                              Routes.textCourseDetail(
                                  id: data.trackableId.toString()),
                              arguments: [
                                data.trackable?.category?.title,
                                data.trackableId.toString()
                              ]);
                          break;
                        case "audio":
                          Get.toNamed(
                              Routes.audioCourseDetail(
                                  id: data.trackableId.toString()),
                              arguments: [
                                CourseDetailViewType.audio,
                                data.trackableId.toString(),
                                data.trackable?.category?.id.toString(),
                                data.trackable?.courseTitle
                              ]);
                          break;
                        case "course_audio":
                          Get.toNamed(
                              Routes.audioCourseDetail(
                                  id: data.trackableId.toString()),
                              arguments: [
                                CourseDetailViewType.audioCourse,
                                data.trackableId.toString(),
                                data.trackable?.category?.id.toString(),
                                data.trackable?.courseTitle
                              ]);
                          break;
                        case "video":
                          AppConstants.instance.singleCourseId.value =
                              (data.trackableId.toString());

                          Get.toNamed(
                              Routes.continueWatchScreen(
                                  id: data.trackableId.toString()),
                              arguments: [
                                data.trackableId.toString(),
                                data.trackable?.category?.id.toString()
                              ]);
                          break;
                        case "course_video":
                          AppConstants.instance.videoCourseId.value =
                              (data.trackableId.toString());

                          Get.toNamed(
                              Routes.videoCourseDetail(
                                  id: data.trackableId.toString()),
                              arguments: [
                                data.trackable?.category?.title ?? "",
                                data.trackableId.toString()
                              ]);
                          break;
                        default:
                          AppConstants.instance.videoCourseId.value =
                              (data.trackableId.toString());

                          Get.toNamed(
                              Routes.videoCourseDetail(
                                  id: data.trackableId.toString()),
                              arguments: [
                                data.trackable?.category?.title ?? "",
                                data.trackableId.toString()
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

Widget learningContainer(int index, Datum data) {
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
                data.trackable?.courseTitle ?? data.trackable?.title ?? "",
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
