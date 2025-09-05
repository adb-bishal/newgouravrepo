import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/videos_widget.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../../model/models/home_data_model/home_data_model.dart';
import '../../../../../model/utils/app_constants.dart';
import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../view_model/controllers/root_view_controller/home_controller/home_view_controller.dart';
import '../../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../home_view_screen.dart';

class AudiosWidget extends StatelessWidget {
  final Function() onTap;
  final HomeDataModelDatum? homeDataModelDatum;
  final List<CommonDatum>? data;
  final Function()? onWishlist;
  const AudiosWidget(
      {Key? key,
      required this.onTap,
      this.data,
      this.onWishlist,
      this.homeDataModelDatum})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(onTap, StringResource.audios,
            showIcon: true, enableTopPadding: false),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: DimensionResource.marginSizeDefault),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(
                homeDataModelDatum?.data?.length ?? data?.length ?? 0, (index) {
              CommonDatum dataa;
              if (homeDataModelDatum != null) {
                dataa = CommonDatum.fromJson(
                    homeDataModelDatum?.data?.elementAt(index).toJson() ?? {});
                for (var dataaa in homeDataModelDatum?.data ?? []) {
                  if (!Get.find<RootViewController>().audioData.any((element) =>
                      element.id?.value.toString() == dataaa.id.toString())) {
                    Get.find<RootViewController>().audioData.add(CourseWishlist(
                        id: RxInt(dataaa.id),
                        isWishList: dataaa.isWishlist ?? 0.obs));
                  }
                }
              } else {
                dataa = data!.elementAt(index);
              }
              return Padding(
                padding: EdgeInsets.only(
                    left: index != 0 ? DimensionResource.marginSizeSmall : 0),
                child: GestureDetector(
                    onTap: () {
                      Get.toNamed(
                              Routes.audioCourseDetail(
                                  id: dataa.model?.id != null
                                      ? dataa.model?.id.toString()
                                      : dataa.id.toString()),
                              arguments: [
                            CourseDetailViewType.audio,
                            dataa.model?.id != null
                                ? dataa.model?.id.toString()
                                : dataa.id.toString(),
                            dataa.model?.categoryId != null
                                ? dataa.model?.categoryId.toString()
                                : dataa.categoryId.toString(),
                            dataa.title ?? dataa.courseTitle ?? ""
                          ])!
                          .then((value) {
                        Get.find<HomeController>()
                            .getContinueLearning(isFirst: true);
                      });
                      //Get.toNamed(Routes.audioCourseDetail(id: dataa.id.toString()));
                    },
                    child: videoContainer(index, dataa,
                        width: AppConstants.instance.containerWidth,
                        height: 85,
                        isAudio: true,
                        fontSize: DimensionResource.fontSizeExtraSmall,
                        onWishlist: onWishlist)),
              );
            }),
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        )
      ],
    );
  }
}
