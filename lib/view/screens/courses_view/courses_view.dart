import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/common_container_model/common_container_model.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/widget/video_course_widget.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';

import '../../../model/models/course_models/courses_model.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../view_model/controllers/root_view_controller/courses_view_controller/courses_view_controller.dart';
import '../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import '../../../enum/routing/routes/app_pages.dart';
import '../../widgets/button_view/animated_box.dart';
import '../../widgets/search_widget/search_container.dart';
import '../../widgets/shimmer_widget/shimmer_widget.dart';
import '../base_view/base_view_screen.dart';
import '../root_view/home_view/widget/videos_widget.dart';
import '../root_view/live_classes_view/filter_view/filter_view.dart';

class CoursesView extends StatelessWidget {
  const CoursesView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      isTag: true,
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: StringResource.coursesHeading,
      ),
      onActionBuilder: (context, controller) => [
        InkWell(
            onTap: () {
              buildShowModalBottomSheet(context, Obx(() {
                return controller.isDataLoading.value
                    ? const CircularProgressIndicator()
                    : LiveFilterScreen(
                        listOfSelectedTeacher: const [],
                        isHideTime: true,
                        listOFSelectedRating: controller.selectedRating,
                        listOFSelectedLevel: controller.selectedLevel,
                        isHideRating: true,
                        isHideLevel: true,
                        isHideSubscription: false,
                        isForCoursesTab: true,
                        selectedSubscription: controller.selectedSub.value,
                        title: StringResource.courseFilter,
                        onClear: (val) {
                          controller.selectedRating.value = val['rating'];
                          controller.selectedSub.value = val['is_free'];
                          controller.listOFSelectedCat.clear();
                          controller.selectedRating.clear();
                          controller.isDataLoading.value = true;
                          Future.delayed(Duration.zero, () {
                            controller.isDataLoading.value = false;
                          });
                          controller.getCourseData(
                            pageNo: 1,
                            rating: controller.selectedRating
                                .map((element) => element.ratingValue)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            categoryId: controller.listOFSelectedCat
                                .map((element) => element.id)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            subscriptionLevel: val['is_free'].optionName,
                          );
                          Get.back();
                        },
                        listOFSelectedCat: controller.listOFSelectedCat,
                        listOFSelectedLang: const [],
                        listOFSelectedDuration: const [],
                        isPastFilter: true,
                        onApply: (val) {
                          controller.selectedLevel.value = val['level'];
                          controller.selectedSub.value = val['is_free'];
                          controller.listOFSelectedCat.value = val['category'];
                          controller.selectedRating.value = val['rating'];
                          controller.getCourseData(
                            pageNo: 1,
                            rating: controller.selectedRating
                                .map((element) => element.ratingValue)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            categoryId: controller.listOFSelectedCat
                                .map((element) => element.id)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            level: controller.selectedLevel
                                .map((element) => element.id)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            subscriptionLevel: val['is_free'].optionName,
                          );
                        },
                  listOFSelectedDays: [],
                      );
              }), isDark: false, isDismissible: true)
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
      isBackShow: false,
      viewControl: CoursesViewController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, CoursesViewController controller) {
    return RefreshIndicator(
      color: ColorResource.primaryColor,
      onRefresh: controller.onRefresh,
      child: ListView(
        shrinkWrap: false,

        controller: controller.dataPagingController.value.scrollController,
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault),
        //crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Obx(() {
            return SearchWidget(
              enableMargin: false,
              textEditingController: controller.searchController.value,
              onChange: controller.onCourseSearch,
              onClear: () {
                controller.onCourseSearch("");
              },
            );
          }),
          Padding(
            padding: const EdgeInsets.symmetric(
                vertical: DimensionResource.marginSizeSmall),
            child: Text(
              StringResource.allCourses,
              style: StyleResource.instance.styleSemiBold(),
            ),
          ),
          Obx(() {
            return controller.isDataLoading.value
                ? ShimmerEffect.instance.coursesLoader()
                : (controller.dataPagingController.value.list.isNotEmpty)
                    ? Wrap(
                        runSpacing: DimensionResource.marginSizeSmall + 7,
                        spacing: DimensionResource.marginSizeDefault + 0,
                        children: List.generate(
                          (controller
                                  .dataPagingController.value.list.isNotEmpty)
                              ? (controller.dataPagingController.value.list
                                              .length >
                                          controller.showIndex.value &&
                                      controller.selectedSub.value.optionName
                                              ?.toLowerCase() !=
                                          "pro")
                                  ? controller.dataPagingController.value.list
                                          .length +
                                      1
                                  : controller
                                      .dataPagingController.value.list.length
                              : 0,
                          (index) {
                            int currentIndex = index;
                            if (index == controller.showIndex.value &&
                                controller.selectedSub.value.optionName
                                        ?.toLowerCase() !=
                                    "pro") {
                              return SizedBox(
                                width: Get.width,
                              );
                              //  Column(
                              //   crossAxisAlignment: CrossAxisAlignment.start,
                              //   children: [
                              //     CommonContainer(
                              //         height: 40,
                              //         isDisable: false,
                              //         loading: false,
                              //         color: ColorResource.primaryColor,
                              //         child: Text(
                              //           Get.find<AuthService>()
                              //                   .serviceData
                              //                   .value
                              //                   .data
                              //                   ?.titleOne ??
                              //               StringResource.freeOptionTrading,
                              //           style: StyleResource.instance
                              //               .styleMedium(
                              //                   color: ColorResource.white),
                              //         ),
                              //         onPressed: () {
                              //           switch (Get.find<AuthService>()
                              //               .serviceData
                              //               .value
                              //               .data
                              //               ?.typeOne) {
                              //             case AppConstants.video:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType.video,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;
                              //             case AppConstants.audio:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType.audio,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;
                              //             case AppConstants.videoCourse:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType
                              //                         .videoCourse,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;
                              //             case AppConstants.audioCourse:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType
                              //                         .audioCourse,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;

                              //             case AppConstants.textCourse:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType
                              //                         .textCourse,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;
                              //           }
                              //         }),
                              //     const SizedBox(
                              //       height: DimensionResource.marginSizeDefault,
                              //     ),
                              //     CommonContainer(
                              //         height: 40,
                              //         isDisable: false,
                              //         loading: false,
                              //         color: ColorResource.secondaryColor,
                              //         child: Text(
                              //           Get.find<AuthService>()
                              //                   .serviceData
                              //                   .value
                              //                   .data
                              //                   ?.titleTwo ??
                              //               StringResource.freeOptionTrading,
                              //           style: StyleResource.instance
                              //               .styleMedium(
                              //                   color: ColorResource.white),
                              //         ),
                              //         onPressed: () {
                              //           logPrint(
                              //               "type Data ${Get.find<AuthService>().serviceData.value.data?.typeTwo}");
                              //           switch (Get.find<AuthService>()
                              //               .serviceData
                              //               .value
                              //               .data
                              //               ?.typeTwo) {
                              //             case AppConstants.video:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType.video,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;
                              //             case AppConstants.audio:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType.audio,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;
                              //             case AppConstants.videoCourse:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType
                              //                         .videoCourse,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;
                              //             case AppConstants.audioCourse:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType
                              //                         .audioCourse,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;

                              //             case AppConstants.textCourse:
                              //               Get.toNamed(Routes.courseDetail,
                              //                   arguments: [
                              //                     "",
                              //                     CourseDetailViewType
                              //                         .textCourse,
                              //                     "",
                              //                     "",
                              //                     "free"
                              //                   ]);
                              //               break;
                              //           }
                              //         }),
                              //   ],
                              // );
                            } else {
                              Datum data = Datum();
                              if (index >= controller.showIndex.value &&
                                  controller.selectedSub.value.optionName
                                          ?.toLowerCase() !=
                                      "pro") {
                                currentIndex -= 1;
                                data = controller
                                    .dataPagingController.value.list
                                    .elementAt(currentIndex);
                              } else {
                                data = controller
                                    .dataPagingController.value.list
                                    .elementAt(currentIndex);
                              }
                              return Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  data.typeId == 1

                                      //For Text Courses
                                      ? InkWell(
                                          onTap: () {
                                            Get.toNamed(
                                                Routes.textCourseDetail(
                                                    id: data.id.toString()),
                                                arguments: [
                                                  data.courseCategory?.title,
                                                  data.id.toString()
                                                ]);
                                            //onItemTap(data);
                                          },

                                          child: videoCourseContainer(
                                              currentIndex,
                                              CommonDatum.fromJson(
                                                  data.toJson()),
                                              categoryType:
                                                  data.courseCategory?.title ??
                                                      "",
                                              width: 157,
                                              height: 145,
                                              isTapEnable: false),
                                          //child: textCourseContainer(currentIndex,height: 145,width: 157,data: CommonDatum.fromJson(data.toJson()),)
                                        )
                                      : data.typeId == 2
                                          ? GestureDetector(
                                              onTap: () {
                                                Get.toNamed(
                                                    Routes.audioCourseDetail(
                                                        id: data.id.toString()),
                                                    arguments: [
                                                      CourseDetailViewType
                                                          .audioCourse,
                                                      data.id.toString(),
                                                      data.categoryId
                                                          .toString(),
                                                      data.courseTitle
                                                    ]);
                                                //Get.toNamed(Routes.audioCourseDetail(id: dataa.id.toString()));
                                              },
                                              child: videoContainer(
                                                  currentIndex,
                                                  CommonDatum.fromJson(
                                                      data.toJson()),
                                                  height: 145,
                                                  width: 152,
                                                  isAudio: true,
                                                  showWishlist: false))
                                          : videoCourseContainer(
                                              currentIndex,
                                              CommonDatum.fromJson(
                                                  data.toJson()),
                                              categoryType:
                                                  data.courseCategory?.title ??
                                                      "",
                                              width: 157,
                                              height: 145),
                                  Positioned(
                                      top: -10,
                                      child: Image.asset(
                                        data.typeId == 1
                                            ? ImageResource
                                                .instance.textCourseIcon
                                            : data.typeId == 2
                                                ? ImageResource
                                                    .instance.audioCourseIcon
                                                : ImageResource
                                                    .instance.videoCourseIcon,
                                        height: 34,
                                      ))
                                ],
                              );
                            }
                          },
                        ),
                      )
                    : const SizedBox(height: 400, child: NoDataFound());
          }),
          const SizedBox(
            height: 15,
          )
        ],
      ),
    );
    // return Obx(
    //         () {
    //       return AnimatedList(
    //         shrinkWrap: true,
    //         key: controller.listKey.value,
    //         initialItemCount: controller.items.length > 1 ?controller.items.length+1:1,
    //         itemBuilder: (context, index, animation) {
    //           if(index == 0){
    //             return Padding(
    //               padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault,vertical: DimensionResource.marginSizeExtraSmall),
    //               child: Text('Content related to "${controller.categoryType.value}"',style: StyleResource.instance.styleSemiBold(),),
    //             );
    //           }
    //           else{
    //             if(controller.items.length == 1 ){
    //               return const CommonPageIndicator();
    //             }else{
    //               return slideIt(context, index, animation,controller);
    //             }
    //           } // Refer step 3
    //         },
    //       );
    //     }
    // );
  }
}
