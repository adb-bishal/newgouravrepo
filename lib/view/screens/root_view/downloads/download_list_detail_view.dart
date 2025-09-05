import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/videoplayer.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/filter_view/filter_view.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../view_model/controllers/download_controller/download_list_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import '../../../widgets/bottom_sheet.dart';
import '../../../widgets/search_widget/search_container.dart';
import '../../base_view/base_view_screen.dart';
import '../courses_detail_view/course_detail_view.dart';
import 'downloaded_list_view.dart';

class DownloadDetailView extends StatelessWidget {
  const DownloadDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return BaseView(
      onAppBarTitleBuilder: (context, controller) => Obx(() => TitleBarCentered(
            titleText: "Downloaded ${controller.categoryType.value} Courses",
          )),
      onActionBuilder: (context, controller) => [
        InkWell(
            onTap: () {
              BottomSheetCommon(
                  child: LiveFilterScreen(
                listOfSelectedTeacher: const [],
                listOFSelectedCat: controller.listOFSelectedCat,
                listOFSelectedDuration: const [],
                listOFSelectedLang: const [],
                listOFSelectedRating: const [],
                listOFSelectedLevel: const [],
                isPastFilter: false,
                title: "Courses Level",
                isHideLanguage: true,
                isHideLevel: true,
                isHideTime: true,
                isHideRating: true,
                isHideSubscription: true,
                onClear: (val) {
                  controller.listOFSelectedCat.clear();
                  controller.getAllContent();
                  Get.back();
                },
                onApply: (val) {
                  controller.listOFSelectedCat = val['category'];
                  logPrint("selected category ${controller.listOFSelectedCat}");
                  if (controller.listOFSelectedCat.isNotEmpty) {
                    controller.getFilterData(controller.listOFSelectedCat
                        .map((element) => element.id)
                        .toList());
                  } else {
                    controller.getAllContent();
                  }
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
      viewControl: DownloadDetailController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, DownloadDetailController controller) {
    final LiveClassDetailController liveClassDetailController =
    Get.put(LiveClassDetailController());
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          SearchWidget(
            textEditingController: controller.searchController.value,
            onChange: controller.onClassSearch,
            onClear: () {
              controller.onClassSearch("");
            },
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            child: Text(
              "List of Downloaded ${controller.categoryType.value}",
              style: StyleResource.instance.styleMedium(),
            ),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Obx(() {

            bool showNoData = false;

            if (controller.viewType.value == CourseDetailViewType.video) {
              showNoData = controller.video.isEmpty;
            } else if (controller.viewType.value ==
                CourseDetailViewType.audio) {
              showNoData = controller.audio.isEmpty;
            } else if (controller.viewType.value ==
                CourseDetailViewType.videoCourse) {
              showNoData = controller.videoCourses.isEmpty;
            }  else {
              showNoData = controller.audioCourses.isEmpty;
            }
            return controller.categoryType.value != "Webinars"?
            showNoData
                ? Center(
                    child: SizedBox(
                      height: 400,
                      child: Center(
                        child: Text(
                          "No Downloaded Content.\nGo ahead and Download now!",
                          style: StyleResource.instance.styleMedium(),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )
                :
            commonGridViewList(child: (index, d) {
                      if (controller.viewType.value ==
                          CourseDetailViewType.video) {
                        return videoDownloadContainer(
                            index,
                            controller.searchVideo.isEmpty
                                ? controller.video[index]
                                : controller.searchVideo[index],
                            height: 145,
                            width: 157,
                            isAudio: false);
                      } else if (controller.viewType.value ==
                          CourseDetailViewType.videoCourse) {
                        return videoCourseDownloadContainer(
                            index,
                            controller.searchVideoCourses.isEmpty
                                ? controller.videoCourses[index]
                                : controller.searchVideoCourses[index],
                            height: 145,
                            width: 157,
                            categoryType: "",
                            fontSize: DimensionResource.fontSizeExtraSmall);
                      }
                      else if (controller.viewType.value ==
                          CourseDetailViewType.audio) {
                        return audioDownloadContainer(
                            index,
                            controller.searchAudio.isEmpty
                                ? controller.audio[index]
                                : controller.searchAudio[index],
                            height: 145,
                            width: 157,
                            isAudio: true,
                            fontSize: DimensionResource.fontSizeExtraSmall);
                      } else {
                        return audioCourseDownloadContainer(
                            index,
                            controller.searchAudioCourses.isEmpty
                                ? controller.audioCourses[index]
                                : controller.searchAudioCourses[index],
                            height: 145,
                            width: 157,
                            fontSize: DimensionResource.fontSizeExtraSmall);
                      }
                    },
                    itemCount: controller.viewType.value == CourseDetailViewType.video
                            ? controller.searchVideo.isEmpty
                                ? controller.video.length
                                : controller.searchVideo.length


                            : controller.viewType.value ==
                                    CourseDetailViewType.videoCourse
                                ? controller.searchVideoCourses.isEmpty
                                    ? controller.videoCourses.length
                                    : controller.searchVideoCourses.length

                            : controller.viewType.value ==
                                        CourseDetailViewType.audio
                                    ? controller.searchAudio.isEmpty
                                        ? controller.audio.length
                                        : controller.searchAudio.length
                                    : controller.searchAudioCourses.isEmpty
                                        ? controller.audioCourses.length
                                        : controller.searchAudioCourses.length,
                    isRectangle: false,
                  ):
            commonGridViewList(child: (index, d) {
              return webinarVideoContainer(index, liveClassDetailController.downloadedVideos[index], width: 145, height: 157);
            }, itemCount: liveClassDetailController.downloadedVideos.length, isRectangle: false);

          }),
          const SizedBox(
            height: DimensionResource.marginSizeLarge,
          )
        ],
      ),
    );
  }
}
