import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/common_container_model/common_container_model.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/video_course_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../../model/utils/dimensions_resource.dart';
import '../../../../../view_model/routes/app_pages.dart';
import '../../courses_detail_view/course_detail_view.dart';
import '../../home_view/home_view_screen.dart';
import '../../home_view/widget/blogs_widget.dart';
import '../../live_classes_view/live_classes_view.dart';

class MoreLikeWidget extends StatelessWidget {
  final String? title;
  final Function() onTap;
  final Function(CommonDatum data) onItemTap;
  final List<CommonDatum> dataList;
  final bool isVideo;
  final bool? isPast;
  final bool isLiveVideo;
  final bool isBlog;
  final bool isSeeAllEnable;
  final bool enableTopPadding;
  const MoreLikeWidget(
      {Key? key,
      this.title,
      required this.onTap,
      required this.onItemTap,
      this.isVideo = false,
      this.isPast,
      required this.dataList,
      this.isLiveVideo = false,
      this.isBlog = false,
      this.isSeeAllEnable = true,
      this.enableTopPadding = true})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        rowTile(
          onTap,
          title ?? "More like this",
          showIcon: isSeeAllEnable,
          enableTopPadding: enableTopPadding,
        ),
        SingleChildScrollView(
          padding: const EdgeInsets.symmetric(
              horizontal: DimensionResource.marginSizeDefault),
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(dataList.length, (index) {
              logPrint(dataList.first.toJson());
              CommonDatum data = dataList.elementAt(index);
              return Padding(
                padding: EdgeInsets.only(
                    left: index != 0 ? DimensionResource.marginSizeSmall : 0),
                child: isBlog
                    ? blogsContainer(data, width: 130, onItemTap: onItemTap)
                    : isLiveVideo
                        ? liveClassesContainer(index,
                            height: 140,
                            width: 130,
                            onItemTap: onItemTap,
                            data: data,
                            isPast: isPast ?? false)
                        : isVideo
                            ? videoCourseContainer(
                                index,
                                data,
                                categoryType: "",
                                onItemTap: onItemTap,
                              )
                            : InkWell(
                                onTap: () {
                                  Get.toNamed(
                                      Routes.textCourseDetail(
                                          id: data.id.toString()),
                                      arguments: [
                                        "categoryType",
                                        data.id.toString()
                                      ]);
                                  onItemTap(data);
                                },
                                child: textCourseContainer(
                                  index,
                                  height: 120,
                                  width: 120,
                                  data: data,
                                )),
              );
            }),
          ),
        )
      ],
    );
  }
}
