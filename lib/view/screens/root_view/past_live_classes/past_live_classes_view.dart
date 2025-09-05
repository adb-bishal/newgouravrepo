// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:stockpathshala_beta/model/utils/style_resource.dart';
// // import 'package:stockpathshala_beta/view/screens/base_view/base_view_screen.dart';
// // import 'package:stockpathshala_beta/view/widgets/button_view/animated_box.dart';
// // import '../../../../model/models/common_container_model/common_container_model.dart';
// // import '../../../../model/utils/app_constants.dart';
// // import '../../../../model/utils/color_resource.dart';
// // import '../../../../model/utils/dimensions_resource.dart';
// // import '../../../../model/utils/image_resource.dart';
// // import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
// // import '../../../../view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
// // import '../../../../view_model/routes/app_pages.dart';
// // import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
// // import '../../../widgets/image_provider/image_provider.dart';
// // import '../../../widgets/no_data_found/no_data_found.dart';
// // import '../../../widgets/search_widget/search_container.dart';
// // import '../../../widgets/shimmer_widget/shimmer_widget.dart';
// // import '../live_classes_view/filter_view/batches_filter_view.dart';
// //
// // class PastClassesView extends StatelessWidget {
// //   const PastClassesView({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BaseView(
// //       onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
// //         titleText: "Class Recordings",
// //       ),
// //       onActionBuilder: (context, controller) => [
// //         InkWell(
// //             onTap: () {
// //               buildShowModalBottomSheet(context, Obx(() {
// //                 return controller.isClearLoading.value
// //                     ? const CircularProgressIndicator()
// //                     : LiveFilterScreen(
// //                         onClear: (val) {
// //                           //controller.listOFSelectedLang.clear();
// //                           controller.selectedRating.value = val['rating'];
// //                           controller.listOFSelectedDuration.clear();
// //                           controller.listOFSelectedCat.clear();
// //                           // controller.selectedLevel.value = val['level'];
// //                           controller.isClearLoading.value = true;
// //                           Future.delayed(Duration.zero, () {
// //                             controller.isClearLoading.value = false;
// //                           });
// //                           controller.selectedSub.value = val['is_free'];
// //                           controller.listofSelectedTeacher.value =
// //                               val['teacher'];
// //                           controller.getLiveData(
// //                             pageNo: 1,
// //                             categoryId: controller.listOFSelectedCat
// //                                 .map((element) => element.id)
// //                                 .toList()
// //                                 .toString()
// //                                 .replaceAll("[", "")
// //                                 .replaceAll("]", "")
// //                                 .removeAllWhitespace,
// //                             duration: controller.listOFSelectedDuration
// //                                 .map((element) => element.optionName)
// //                                 .toList()
// //                                 .toString()
// //                                 .replaceAll("[", "")
// //                                 .replaceAll("]", "")
// //                                 .removeAllWhitespace,
// //                             teacherId: controller.listofSelectedTeacher
// //                                 .map((element) => element.id)
// //                                 .toList()
// //                                 .toString()
// //                                 .replaceAll("[", "")
// //                                 .replaceAll("]", "")
// //                                 .removeAllWhitespace,
// //                             //langId: controller.listOFSelectedLang.map((element) => element.id).toList().toString().replaceAll("[", "").replaceAll("]", "").removeAllWhitespace,
// //                             // rating: controller.selectedRating,
// //                             subscriptionLevel: val['is_free'].optionName,
// //                           );
// //                           Get.back();
// //                         },
// //                         listOfSelectedTeacher: controller.listofSelectedTeacher,
// //                         isHideTeacher: false,
// //                         isHideLevel: true,
// //                         selectedSubscription: controller.selectedSub.value,
// //                         listOFSelectedLevel: const [],
// //                         listOFSelectedCat: controller.listOFSelectedCat,
// //                         listOFSelectedDuration:
// //                             controller.listOFSelectedDuration,
// //                         listOFSelectedLang: const [],
// //                         listOFSelectedRating: controller.selectedRating,
// //                         isPastFilter: true,
// //                         onApply: (val) {
// //                           // controller.selectedLevel.value = val['level'];
// //                           controller.selectedSub.value = val['is_free'];
// //                           controller.listofSelectedTeacher.value =
// //                               val['teacher'];
// //                           controller.selectedRating.value = val['rating'];
// //                           controller.listOFSelectedCat.value = val['category'];
// //                           //controller.listOFSelectedLang.value = val['language'];
// //                           controller.listOFSelectedDuration.value =
// //                               val['duration'];
// //                           controller.getLiveData(
// //                             pageNo: 1,
// //                             categoryId: controller.listOFSelectedCat
// //                                 .map((element) => element.id)
// //                                 .toList()
// //                                 .toString()
// //                                 .replaceAll("[", "")
// //                                 .replaceAll("]", "")
// //                                 .removeAllWhitespace,
// //                             teacherId: controller.listofSelectedTeacher
// //                                 .map((element) => element.id)
// //                                 .toList()
// //                                 .toString()
// //                                 .replaceAll("[", "")
// //                                 .replaceAll("]", "")
// //                                 .removeAllWhitespace,
// //                             duration: controller.listOFSelectedDuration
// //                                 .map((element) => element.optionName)
// //                                 .toList()
// //                                 .toString()
// //                                 .replaceAll("[", "")
// //                                 .replaceAll("]", "")
// //                                 .removeAllWhitespace,
// //                             subscriptionLevel:
// //                                 controller.selectedSub.value.optionName,
// //                           );
// //                         },
// //                       );
// //               }), isDark: false, isDismissible: true)
// //                   .then((value) {
// //                 Get.delete<ClassesFilterController>();
// //               });
// //             },
// //             child: Padding(
// //               padding: const EdgeInsets.all(3.0),
// //               child: Image.asset(
// //                 ImageResource.instance.filterIcon,
// //                 height: 18,
// //               ),
// //             ))
// //       ],
// //       isBackShow: true,
// //       onBackClicked: (context, controller) {
// //         Get.back();
// //       },
// //       viewControl: PastClassesController(),
// //       onPageBuilder: (context, controller) =>
// //           _mainPageBuilder(context, controller),
// //     );
// //   }
// //
// //   Widget _mainPageBuilder(
// //       BuildContext context, PastClassesController controller) {
// //     return RefreshIndicator(
// //       color: ColorResource.primaryColor,
// //       onRefresh: controller.onRefresh,
// //       child: SingleChildScrollView(
// //         controller: controller.dataPagingController.value.scrollController,
// //         padding: const EdgeInsets.symmetric(
// //             horizontal: DimensionResource.marginSizeDefault),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const SizedBox(
// //               height: DimensionResource.marginSizeDefault,
// //             ),
// //             Obx(() {
// //               return SearchWidget(
// //                 enableMargin: false,
// //                 textEditingController: controller.searchController.value,
// //                 onChange: controller.onClassSearch,
// //                 onClear: () {
// //                   controller.onClassSearch("");
// //                 },
// //               );
// //             }),
// //             const SizedBox(
// //               height: DimensionResource.marginSizeSmall,
// //             ),
// //             Text(
// //               "View class recordings",
// //               style: StyleResource.instance.styleSemiBold(),
// //             ),
// //             const SizedBox(
// //               height: DimensionResource.marginSizeSmall,
// //             ),
// //             videoCourseWrapList(
// //                 pastClassesController: controller, context: context),
// //             const SizedBox(
// //               height: DimensionResource.marginSizeSmall,
// //             ),
// //             Visibility(
// //                 visible:
// //                     controller.dataPagingController.value.isDataLoading.value,
// //                 child: const Padding(
// //                   padding: EdgeInsets.only(bottom: 15.0),
// //                   child: CommonCircularIndicator(),
// //                 )),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget videoCourseWrapList(
// //       {required PastClassesController pastClassesController,
// //       required BuildContext context}) {
// //     return Obx(() => pastClassesController.isDataLoading.value
// //         ? ShimmerEffect.instance.liveClassLoader()
// //         : pastClassesController.dataPagingController.value.list.isEmpty
// //             ? const SizedBox(
// //                 height: 500,
// //                 child: NoDataFound(
// //                   showText: true,
// //                   text: "Be a Pro to Watch Class Recordings",
// //                 ))
// //             : Wrap(
// //                 spacing: DimensionResource.marginSizeSmall,
// //                 runSpacing: DimensionResource.marginSizeExtraSmall,
// //                 children: List.generate(
// //                     pastClassesController
// //                         .dataPagingController.value.list.length, (index) {
// //                   CommonDatum data = CommonDatum.fromJson(pastClassesController
// //                       .dataPagingController.value.list
// //                       .elementAt(index)
// //                       .toJson());
// //                   return Padding(
// //                     padding: EdgeInsets.only(
// //                         bottom: pastClassesController.dataPagingController.value
// //                                         .list.length -
// //                                     1 ==
// //                                 index
// //                             ? DimensionResource.marginSizeDefault
// //                             : 0),
// //                     child: _pastLiveClassesView(index,
// //                         height: 120,
// //                         fontSize: DimensionResource.marginSizeSmall + 3,
// //                         data: data,
// //                         isPast: true,
// //                         pastClassesController: pastClassesController,
// //                         onItemTap: (data) {},
// //                         size: MediaQuery.of(context).size),
// //                   );
// //                 }),
// //               ));
// //   }
// // }
// //
// // Widget _pastLiveClassesView(int index,
// //     {double height = 120,
// //     double fontSize = DimensionResource.fontSizeExtraSmall - 2,
// //     bool isPast = false,
// //     Function(CommonDatum data)? onItemTap,
// //     required CommonDatum data,
// //     required PastClassesController pastClassesController,
// //     required Size size}) {
// //   return GestureDetector(
// //     onTap: () {
// //       AppConstants.instance.liveId.value = (data.id.toString());
// //       Get.toNamed(Routes.liveClassDetail(id: data.id.toString()),
// //           arguments: [isPast, data.id.toString()]);
// //       if (onItemTap != null) {
// //         onItemTap(data);
// //       }
// //     },
// //     child: Container(
// //       height: height,
// //       margin: const EdgeInsets.only(bottom: 10),
// //       decoration: BoxDecoration(
// //           color: ColorResource.white,
// //           shape: BoxShape.rectangle,
// //           border: Border.all(color: ColorResource.black),
// //           borderRadius: BorderRadius.circular(
// //               DimensionResource.appDefaultContainerRadius)),
// //       child: Row(
// //         children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.horizontal(
// //               left:
// //                   Radius.circular(DimensionResource.appDefaultContainerRadius),
// //             ),
// //             child: SizedBox(
// //               height: height,
// //               width: 100,
// //               child: cachedNetworkImage(
// //                 data.preview ?? data.image ?? "",
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: Container(
// //               height: height,
// //               decoration: const BoxDecoration(
// //                   color: ColorResource.white,
// //                   borderRadius: BorderRadius.horizontal(
// //                       right: Radius.circular(
// //                           DimensionResource.appDefaultContainerRadius))),
// //               padding: const EdgeInsets.all(
// //                   DimensionResource.marginSizeExtraSmall + 2),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Container(
// //                     decoration: BoxDecoration(
// //                         borderRadius: BorderRadius.circular(5),
// //                         color: ColorResource.lightYellowColor),
// //                     padding:
// //                         const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
// //                     child: Text(
// //                       data.category?.title ?? '',
// //                       style: StyleResource.instance.styleMedium(fontSize: 8),
// //                     ),
// //                   ),
// //                   const SizedBox(
// //                     height: DimensionResource.marginSizeExtraSmall,
// //                   ),
// //                   Text(
// //                     "Streamed on ${AppConstants.formatDate(data.startTime)}",
// //                     style: StyleResource.instance.styleMedium(
// //                         fontSize: DimensionResource.fontSizeExtraSmall - 2,
// //                         color: ColorResource.greenDarkColor),
// //                     overflow: TextOverflow.ellipsis,
// //                     maxLines: 2,
// //                   ),
// //                   const SizedBox(
// //                     height: DimensionResource.marginSizeExtraSmall - 2,
// //                   ),
// //                   SizedBox(
// //                     height: 60,
// //                     child: Text(
// //                       data.title ?? '',
// //                       style: StyleResource.instance.styleMedium(
// //                           fontSize: fontSize, color: ColorResource.black),
// //                       overflow: TextOverflow.ellipsis,
// //                       maxLines: 3,
// //                     ),
// //                   ),
// //                   const SizedBox(
// //                     height: 5,
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           )
// //         ],
// //       ),
// //     ),
// //   );
// // }
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
//
// import 'package:stockpathshala_beta/model/utils/style_resource.dart';
// import 'package:stockpathshala_beta/view/screens/base_view/base_view_screen.dart';
// import 'package:stockpathshala_beta/view/widgets/button_view/animated_box.dart';
//
// import '../../../../model/models/common_container_model/common_container_model.dart';
// import '../../../../model/utils/app_constants.dart';
// import '../../../../model/utils/color_resource.dart';
// import '../../../../model/utils/dimensions_resource.dart';
// import '../../../../model/utils/image_resource.dart';
//
// import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
// import '../../../../view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
//
// import '../../../../view_model/routes/app_pages.dart';
//
// import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
// import '../../../widgets/image_provider/image_provider.dart';
// import '../../../widgets/no_data_found/no_data_found.dart';
// import '../../../widgets/search_widget/search_container.dart';
// import '../../../widgets/shimmer_widget/shimmer_widget.dart';
//
// import '../live_classes_view/filter_view/batches_filter_view.dart';
//
// // class PastClassesView extends StatelessWidget {
// //   const PastClassesView({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return BaseView<PastClassesController>(
// //       onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
// //         titleText: "Class Recordings",
// //       ),
// //       onActionBuilder: (context, controller) => [
// //         InkWell(
// //           onTap: () {
// //             buildShowModalBottomSheet(
// //               context,
// //               Obx(() {
// //                 if (controller.isClearLoading.value) {
// //                   return const Center(child: CircularProgressIndicator());
// //                 }
// //                 return LiveFilterScreen(
// //                   onClear: (val) {
// //                     controller.selectedRating.value = val['rating'];
// //                     controller.listOFSelectedDuration.clear();
// //                     controller.listOFSelectedCat.clear();
// //                    // controller.listOFSelectedDays.clear();
// //                     controller.isClearLoading.value = true;
// //                     Future.delayed(Duration.zero, () {
// //                       controller.isClearLoading.value = false;
// //                     });
// //                     controller.selectedSub.value = val['is_free'];
// //                     controller.listofSelectedTeacher.value = val['teacher'];
// //                     controller.listSelectedDate.clear();
// //
// //                     controller.getLiveData(
// //                       pageNo: 1,
// //
// //                       categoryId: controller.listOFSelectedCat
// //                           .map((e) => e.id)
// //                           .join(","),
// //                       endDate: controller.listSelectedDate.isNotEmpty
// //                           ? DateTime.tryParse(controller.listSelectedDate.first.id ?? '')
// //                           : null,
// //                       duration: controller.listOFSelectedDuration
// //                           .map((e) => e.optionName)
// //                           .join(","),
// //                       teacherId: controller.listofSelectedTeacher
// //                           .map((e) => e.id)
// //                           .join(","),
// //                       subscriptionLevel: val['is_free'].optionName,
// //                     );
// //                     Get.back();
// //                   },
// //                   listOfSelectedTeacher: controller.listofSelectedTeacher,
// //                   isHideTeacher: false,
// //                   isHideLevel: true,
// //                   selectedSubscription: controller.selectedSub.value,
// //                   listOFSelectedLevel: const [],
// //                   listOFSelectedCat: controller.listOFSelectedCat,
// //                   listOFSelectedDuration: controller.listOFSelectedDuration,
// //                   listOFSelectedLang: const [],
// //                   listOFSelectedRating: controller.selectedRating,
// //                   isPastFilter: true,
// //                   onApply: (val) {
// //                     controller.selectedSub.value = val['is_free'];
// //                     controller.listofSelectedTeacher.value = val['teacher'];
// //                     controller.selectedRating.value = val['rating'];
// //                     controller.listOFSelectedCat.value = val['category'];
// //                    // controller.listOFSelectedDays.value =val["end_datetime"];
// //                     controller.listOFSelectedDuration.value = val['duration'];
// //                     controller.listSelectedDate.value = val['days'];
// //
// //                     controller.getLiveData(
// //                       pageNo: 1,
// //                       endDate: controller.listSelectedDate.isNotEmpty
// //                           ? DateTime.tryParse(controller.listSelectedDate.first.optionName ?? '')
// //                           : null,
// //                       categoryId: controller.listOFSelectedCat
// //                           .map((e) => e.id)
// //                           .join(","),
// //                       teacherId: controller.listofSelectedTeacher
// //                           .map((e) => e.id)
// //                           .join(","),
// //                       duration:
// //                       controller.listOFSelectedDuration.map((e) => e.optionName).join(","),
// //                       subscriptionLevel: controller.selectedSub.value.optionName,
// //                     );
// //                     Get.back();
// //                   }, listSelectedDate: controller.listSelectedDate,
// //                 );
// //               }),
// //               isDark: false,
// //               isDismissible: true,
// //             ).then((value) {
// //               Get.delete<ClassesFilterController>();
// //             });
// //           },
// //           child: Padding(
// //             padding: const EdgeInsets.all(3.0),
// //             child: Image.asset(
// //               ImageResource.instance.filterIcon,
// //               height: 18,
// //             ),
// //           ),
// //         )
// //       ],
// //       isBackShow: true,
// //       onBackClicked: (context, controller) {
// //         Get.back();
// //       },
// //       viewControl: PastClassesController(),
// //       onPageBuilder: (context, controller) => _mainPageBuilder(context, controller),
// //     );
// //   }
// //
// //   Widget _mainPageBuilder(BuildContext context, PastClassesController controller) {
// //     return RefreshIndicator(
// //       color: ColorResource.primaryColor,
// //       onRefresh: controller.onRefresh,
// //       child: SingleChildScrollView(
// //         controller: controller.dataPagingController.value.scrollController,
// //         padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeDefault),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             const SizedBox(height: DimensionResource.marginSizeDefault),
// //             Obx(() {
// //               return SearchWidget(
// //                 enableMargin: false,
// //                 textEditingController: controller.searchController.value,
// //                 onChange: controller.onClassSearch,
// //                 onClear: () {
// //                   controller.onClassSearch("");
// //                 },
// //               );
// //             }),
// //             const SizedBox(height: DimensionResource.marginSizeSmall),
// //             Text(
// //               "View class recordings",
// //               style: StyleResource.instance.styleSemiBold(),
// //             ),
// //             const SizedBox(height: DimensionResource.marginSizeSmall),
// //             videoCourseWrapList(
// //               pastClassesController: controller,
// //               context: context,
// //             ),
// //             const SizedBox(height: DimensionResource.marginSizeSmall),
// //             Obx(() {
// //               return Visibility(
// //                 visible: controller.dataPagingController.value.isDataLoading.value,
// //                 child: const Padding(
// //                   padding: EdgeInsets.only(bottom: 15.0),
// //                   child: CommonCircularIndicator(),
// //                 ),
// //               );
// //             }),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget videoCourseWrapList({
// //     required PastClassesController pastClassesController,
// //     required BuildContext context,
// //   }) {
// //     return Obx(() {
// //       if (pastClassesController.isDataLoading.value) {
// //         return ShimmerEffect.instance.liveClassLoader();
// //       } else if (pastClassesController.dataPagingController.value.list.isEmpty) {
// //         return const SizedBox(
// //           height: 500,
// //           child: NoDataFound(
// //             showText: true,
// //             text: "Be a Pro to Watch Class Recordings",
// //           ),
// //         );
// //       } else {
// //         return Wrap(
// //           spacing: DimensionResource.marginSizeSmall,
// //           runSpacing: DimensionResource.marginSizeExtraSmall,
// //           children: List.generate(
// //             pastClassesController.dataPagingController.value.list.length,
// //                 (index) {
// //               final data = CommonDatum.fromJson(
// //                 pastClassesController.dataPagingController.value.list[index].toJson(),
// //               );
// //               return Padding(
// //                 padding: EdgeInsets.only(
// //                   bottom: index == pastClassesController.dataPagingController.value.list.length - 1
// //                       ? DimensionResource.marginSizeDefault
// //                       : 0,
// //                 ),
// //                 child: _pastLiveClassesView(
// //                   index,
// //                   height: 120,
// //                   fontSize: DimensionResource.marginSizeSmall + 3,
// //                   data: data,
// //                   isPast: true,
// //                   pastClassesController: pastClassesController,
// //                   onItemTap: (data) {},
// //                   size: MediaQuery.of(context).size,
// //                 ),
// //               );
// //             },
// //           ),
// //         );
// //       }
// //     });
// //   }
// // }
// //
// // Widget _pastLiveClassesView(
// //     int index, {
// //       double height = 120,
// //       double fontSize = DimensionResource.fontSizeExtraSmall - 2,
// //       bool isPast = false,
// //       Function(CommonDatum data)? onItemTap,
// //       required CommonDatum data,
// //       required PastClassesController pastClassesController,
// //       required Size size,
// //     }) {
// //   return GestureDetector(
// //     onTap: () {
// //       AppConstants.instance.liveId.value = data.id.toString();
// //       Get.toNamed(
// //         Routes.liveClassDetail(id: data.id.toString()),
// //         arguments: [isPast, data.id.toString()],
// //       );
// //       if (onItemTap != null) {
// //         onItemTap(data);
// //       }
// //     },
// //     child: Container(
// //       height: height,
// //       margin: const EdgeInsets.only(bottom: 10),
// //       decoration: BoxDecoration(
// //         color: ColorResource.white,
// //         shape: BoxShape.rectangle,
// //         border: Border.all(color: ColorResource.black),
// //         borderRadius: BorderRadius.circular(DimensionResource.appDefaultContainerRadius),
// //       ),
// //       child: Row(
// //         children: [
// //           ClipRRect(
// //             borderRadius: const BorderRadius.horizontal(
// //               left: Radius.circular(DimensionResource.appDefaultContainerRadius),
// //             ),
// //             child: SizedBox(
// //               height: height,
// //               width: 100,
// //               child: cachedNetworkImage(
// //                 data.preview ?? data.image ?? "",
// //                 fit: BoxFit.cover,
// //               ),
// //             ),
// //           ),
// //           Expanded(
// //             child: Container(
// //               height: height,
// //               decoration: const BoxDecoration(
// //                 color: ColorResource.white,
// //                 borderRadius: BorderRadius.horizontal(
// //                   right: Radius.circular(DimensionResource.appDefaultContainerRadius),
// //                 ),
// //               ),
// //               padding: const EdgeInsets.all(DimensionResource.marginSizeExtraSmall + 2),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.start,
// //                 mainAxisSize: MainAxisSize.min,
// //                 children: [
// //                   Container(
// //                     decoration: BoxDecoration(
// //                       borderRadius: BorderRadius.circular(5),
// //                       color: ColorResource.lightYellowColor,
// //                     ),
// //                     padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
// //                     child: Text(
// //                       data.category?.title ?? '',
// //                       style: StyleResource.instance.styleMedium(fontSize: 8),
// //                     ),
// //                   ),
// //                   const SizedBox(height: DimensionResource.marginSizeExtraSmall),
// //                   Text(
// //                     "Streamed on ${AppConstants.formatDate(data.startTime)}",
// //                     style: StyleResource.instance.styleMedium(
// //                       fontSize: DimensionResource.fontSizeExtraSmall - 2,
// //                       color: ColorResource.greenDarkColor,
// //                     ),
// //                     overflow: TextOverflow.ellipsis,
// //                     maxLines: 2,
// //                   ),
// //                   const SizedBox(height: DimensionResource.marginSizeExtraSmall - 2),
// //                   SizedBox(
// //                     height: 60,
// //                     child: Text(
// //                       data.title ?? '',
// //                       style: StyleResource.instance.styleMedium(
// //                         fontSize: fontSize,
// //                         color: ColorResource.black,
// //                       ),
// //                       overflow: TextOverflow.ellipsis,
// //                       maxLines: 3,
// //                     ),
// //                   ),
// //                   const SizedBox(height: 5),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ],
// //       ),
// //     ),
// //   );
// // }
//
// import 'package:stockpathshala_beta/service/utils/Session.dart';
//
// class PastClassesView extends StatelessWidget {
//   const PastClassesView({Key? key}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return BaseView(
//       onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
//         titleText: "Class Recordings",
//       ),
//       onActionBuilder: (context, controller) => [
//         InkWell(
//             onTap: () {
//               buildShowModalBottomSheet(context, Obx(() {
//                 return controller.isClearLoading.value
//                     ? const CircularProgressIndicator()
//                     : LiveFilterScreen(
//                   onClear: (val) {
//                     //controller.listOFSelectedLang.clear();
//                     controller.selectedRating.value = val['rating'];
//                     controller.listOFSelectedDuration.clear();
//                     controller.listOFSelectedCat.clear();
//                     controller.listOFSelectedDays.clear();
//                     // controller.selectedLevel.value = val['level'];
//                     controller.isClearLoading.value = true;
//                     Future.delayed(Duration.zero, () {
//                       controller.isClearLoading.value = false;
//                     });
//                     controller.selectedSub.value = val['is_free'];
//                     controller.listofSelectedTeacher.value =
//                     val['teacher'];
//                     controller.getLiveData(
//                       pageNo: 1,
//                       categoryId: controller.listOFSelectedCat
//                           .map((element) => element.id)
//                           .toList()
//                           .toString()
//                           .replaceAll("[", "")
//                           .replaceAll("]", "")
//                           .removeAllWhitespace,
//                       duration: controller.listOFSelectedDuration
//                           .map((element) => element.optionName)
//                           .toList()
//                           .toString()
//                           .replaceAll("[", "")
//                           .replaceAll("]", "")
//                           .removeAllWhitespace,
//                     dateFilter: Session.getSelectedDateFilter().toString(),
//                       teacherId: controller.listofSelectedTeacher
//                           .map((element) => element.id)
//                           .toList()
//                           .toString()
//                           .replaceAll("[", "")
//                           .replaceAll("]", "")
//                           .removeAllWhitespace,
//                       //langId: controller.listOFSelectedLang.map((element) => element.id).toList().toString().replaceAll("[", "").replaceAll("]", "").removeAllWhitespace,
//                       // rating: controller.selectedRating,
//                       subscriptionLevel: val['is_free'].optionName,
//                     );
//                     Get.back();
//                   },
//                   listOfSelectedTeacher: controller.listofSelectedTeacher,
//                   isHideTeacher: false,
//                   isHideLevel: true,
//                   selectedSubscription: controller.selectedSub.value,
//                   listOFSelectedLevel: const [],
//                   listOFSelectedCat: controller.listOFSelectedCat,
//                   listOFSelectedDays:controller.listOFSelectedDays,
//                   listOFSelectedDuration:
//                   controller.listOFSelectedDuration,
//                   listOFSelectedLang: const [],
//                   listOFSelectedRating: controller.selectedRating,
//                   isPastFilter: true,
//                   onApply: (val) {
//                     // controller.selectedLevel.value = val['level'];
//                     controller.selectedSub.value = val['is_free'];
//                     controller.listofSelectedTeacher.value =
//                     val['teacher'];
//                     controller.selectedRating.value = val['rating'];
//                     controller.listOFSelectedCat.value = val['category'];
//                    controller.listOFSelectedDays=val['dateFilter'];
//                     //controller.listOFSelectedLang.value = val['language'];
//                     controller.listOFSelectedDuration.value =
//                     val['duration'];
//                     controller.getLiveData(
//                       pageNo: 1,
//                       categoryId: controller.listOFSelectedCat
//                           .map((element) => element.id)
//                           .toList()
//                           .toString()
//                           .replaceAll("[", "")
//                           .replaceAll("]", "")
//                           .removeAllWhitespace,
//                      dateFilter: Session.getSelectedDateFilter()?.value,
//                       teacherId: controller.listofSelectedTeacher
//                           .map((element) => element.id)
//                           .toList()
//                           .toString()
//                           .replaceAll("[", "")
//                           .replaceAll("]", "")
//                           .removeAllWhitespace,
//                       duration: controller.listOFSelectedDuration
//                           .map((element) => element.optionName)
//                           .toList()
//                           .toString()
//                           .replaceAll("[", "")
//                           .replaceAll("]", "")
//                           .removeAllWhitespace,
//                       subscriptionLevel:
//                       controller.selectedSub.value.optionName,
//                     );
//                   },
//                 );
//               }), isDark: false, isDismissible: true)
//                   .then((value) {
//                 Get.delete<ClassesFilterController>();
//               });
//             },
//             child: Padding(
//               padding: const EdgeInsets.all(3.0),
//               child: Image.asset(
//                 ImageResource.instance.filterIcon,
//                 height: 18,
//               ),
//             ))
//       ],
//       isBackShow: true,
//       onBackClicked: (context, controller) {
//         Get.back();
//       },
//       viewControl: PastClassesController(),
//       onPageBuilder: (context, controller) =>
//           _mainPageBuilder(context, controller),
//     );
//   }
//
//   Widget _mainPageBuilder(
//       BuildContext context, PastClassesController controller) {
//     return RefreshIndicator(
//       color: ColorResource.primaryColor,
//       onRefresh: controller.onRefresh,
//       child: SingleChildScrollView(
//         controller: controller.dataPagingController.value.scrollController,
//         padding: const EdgeInsets.symmetric(
//             horizontal: DimensionResource.marginSizeDefault),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             const SizedBox(
//               height: DimensionResource.marginSizeDefault,
//             ),
//             Obx(() {
//               return SearchWidget(
//                 enableMargin: false,
//                 textEditingController: controller.searchController.value,
//                 onChange: controller.onClassSearch,
//                 onClear: () {
//                   controller.onClassSearch("");
//                 },
//               );
//             }),
//             const SizedBox(
//               height: DimensionResource.marginSizeSmall,
//             ),
//             Text(
//               "View class recordings",
//               style: StyleResource.instance.styleSemiBold(),
//             ),
//             const SizedBox(
//               height: DimensionResource.marginSizeSmall,
//             ),
//             videoCourseWrapList(
//                 pastClassesController: controller, context: context),
//             const SizedBox(
//               height: DimensionResource.marginSizeSmall,
//             ),
//             Visibility(
//                 visible:
//                 controller.dataPagingController.value.isDataLoading.value,
//                 child: const Padding(
//                   padding: EdgeInsets.only(bottom: 15.0),
//                   child: CommonCircularIndicator(),
//                 )),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget videoCourseWrapList(
//       {required PastClassesController pastClassesController,
//         required BuildContext context}) {
//     return Obx(() => pastClassesController.isDataLoading.value
//         ? ShimmerEffect.instance.liveClassLoader()
//         : pastClassesController.dataPagingController.value.list.isEmpty
//         ? const SizedBox(
//         height: 500,
//         child: NoDataFound(
//           showText: true,
//           text: "Be a Pro to Watch Class Recordings",
//         ))
//         : Wrap(
//       spacing: DimensionResource.marginSizeSmall,
//       runSpacing: DimensionResource.marginSizeExtraSmall,
//       children: List.generate(
//           pastClassesController
//               .dataPagingController.value.list.length, (index) {
//         CommonDatum data = CommonDatum.fromJson(pastClassesController
//             .dataPagingController.value.list
//             .elementAt(index)
//             .toJson());
//         return Padding(
//           padding: EdgeInsets.only(
//               bottom: pastClassesController.dataPagingController.value
//                   .list.length -
//                   1 ==
//                   index
//                   ? DimensionResource.marginSizeDefault
//                   : 0),
//           child: _pastLiveClassesView(index,
//               height: 120,
//               fontSize: DimensionResource.marginSizeSmall + 3,
//               data: data,
//               isPast: true,
//               pastClassesController: pastClassesController,
//               onItemTap: (data) {},
//               size: MediaQuery.of(context).size),
//         );
//       }),
//     ));
//   }
// }
//
// Widget _pastLiveClassesView(int index,
//     {double height = 120,
//       double fontSize = DimensionResource.fontSizeExtraSmall - 2,
//       bool isPast = false,
//       Function(CommonDatum data)? onItemTap,
//       required CommonDatum data,
//       required PastClassesController pastClassesController,
//       required Size size}) {
//   return GestureDetector(
//     onTap: () {
//       AppConstants.instance.liveId.value = (data.id.toString());
//       Get.toNamed(Routes.liveClassDetail(id: data.id.toString()),
//           arguments: [isPast, data.id.toString()]);
//       if (onItemTap != null) {
//         onItemTap(data);
//       }
//     },
//     child: Container(
//       height: height,
//       margin: const EdgeInsets.only(bottom: 10),
//       decoration: BoxDecoration(
//           color: ColorResource.white,
//           shape: BoxShape.rectangle,
//           border: Border.all(color: ColorResource.black),
//           borderRadius: BorderRadius.circular(
//               DimensionResource.appDefaultContainerRadius)),
//       child: Row(
//         children: [
//           ClipRRect(
//             borderRadius: const BorderRadius.horizontal(
//               left:
//               Radius.circular(DimensionResource.appDefaultContainerRadius),
//             ),
//             child: SizedBox(
//               height: height,
//               width: 100,
//               child: cachedNetworkImage(
//                 data.preview ?? data.image ?? "",
//                 fit: BoxFit.cover,
//               ),
//             ),
//           ),
//           Expanded(
//             child: Container(
//               height: height,
//               decoration: const BoxDecoration(
//                   color: ColorResource.white,
//                   borderRadius: BorderRadius.horizontal(
//                       right: Radius.circular(
//                           DimensionResource.appDefaultContainerRadius))),
//               padding: const EdgeInsets.all(
//                   DimensionResource.marginSizeExtraSmall + 2),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     decoration: BoxDecoration(
//                         borderRadius: BorderRadius.circular(5),
//                         color: ColorResource.lightYellowColor),
//                     padding:
//                     const EdgeInsets.symmetric(vertical: 2, horizontal: 4),
//                     child: Text(
//                       data.category?.title ?? '',
//                       style: StyleResource.instance.styleMedium(fontSize: 8),
//                     ),
//                   ),
//                   const SizedBox(
//                     height: DimensionResource.marginSizeExtraSmall,
//                   ),
//                   Text(
//                     "Streamed on ${AppConstants.formatDate(data.startTime)}",
//                     style: StyleResource.instance.styleMedium(
//                         fontSize: DimensionResource.fontSizeExtraSmall - 2,
//                         color: ColorResource.greenDarkColor),
//                     overflow: TextOverflow.ellipsis,
//                     maxLines: 2,
//                   ),
//                   const SizedBox(
//                     height: DimensionResource.marginSizeExtraSmall - 2,
//                   ),
//                   SizedBox(
//                     height: 60,
//                     child: Text(
//                       data.title ?? '',
//                       style: StyleResource.instance.styleMedium(
//                           fontSize: fontSize, color: ColorResource.black),
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 3,
//                     ),
//                   ),
//                   const SizedBox(
//                     height: 5,
//                   ),
//                 ],
//               ),
//             ),
//           )
//         ],
//       ),
//     ),
//   );
// }
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/service/utils/Session.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/animated_box.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import '../../../../mentroship/view/mentorship_detail_screen.dart';
import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/services/player/file_video_widget.dart';
import '../../../../model/utils/app_constants.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../service/utils/download_file_util.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/live_class_detail/live_class_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import '../../../../view_model/controllers/root_view_controller/past_live_classes_controller/past_live_controller.dart';
import '../../../../view_model/controllers/root_view_controller/root_view_controller.dart';
import '../../../../view_model/controllers/root_view_controller/video_course_detail_controller/video_course_detail_controller.dart';
import '../../../../view_model/routes/app_pages.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/search_widget/search_container.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';
import '../home_view/widget/top_ten_widget.dart';
import '../live_classes_view/filter_view/filter_view.dart';

class PastClassesView extends StatefulWidget {
  const PastClassesView({Key? key}) : super(key: key);

  @override
  State<PastClassesView> createState() => _PastClassesViewState();
}

class _PastClassesViewState extends State<PastClassesView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    Get.put(PastClassesController());
    Get.find<PastClassesController>().tabController = TabController(
        length: Get.find<PastClassesController>().tabs.length, vsync: this);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // return BaseView(
    //   onAppBarTitleBuilder: (context, controller) => Container(
    //     margin: const EdgeInsets.only(
    //         bottom: DimensionResource.marginSizeExtraSmall),
    //     child: ClipRRect(
    //       borderRadius: const BorderRadius.all(
    //           Radius.circular(DimensionResource.borderRadiusExtraLarge)),
    //       child: ColoredBox(
    //         color: Colors.black38,
    //         child: TabBar(
    //           splashBorderRadius: const BorderRadius.all(
    //               Radius.circular(DimensionResource.borderRadiusExtraLarge)),
    //           dividerColor: ColorResource.primaryColor,
    //           indicator: const BoxDecoration(
    //               borderRadius: BorderRadius.all(Radius.circular(
    //                   DimensionResource.borderRadiusExtraLarge)),
    //               shape: BoxShape.rectangle,
    //               color: ColorResource.white),
    //           labelColor: ColorResource.primaryColor,
    //           unselectedLabelColor: Colors.white,
    //           indicatorSize: TabBarIndicatorSize.tab,
    //           tabs: controller.tabs,
    //           controller: controller.tabController,
    //         ),
    //       ),
    //     ),
    //   ),
    //   appBarLeadingIcon: Container(
    //     margin:
    //         const EdgeInsets.only(bottom: DimensionResource.marginSizeSmall),
    //     child: const SizedBox(
    //       height: 32,
    //       width: 32,
    //       child: Center(
    //         child: Icon(
    //           Icons.arrow_back_ios,
    //           color: ColorResource.white,
    //           size: 20,
    //         ),
    //       ),
    //     ),
    //   ),
    //   onActionBuilder: (context, controller) => [],
    //   isBackShow: true,
    //   onBackClicked: (context, controller) {
    //     Get.back();
    //   },
    //   viewControl: PastClassesController(),
    //   onPageBuilder: (context, controller) => TabBarView(
    //     controller: controller.tabController,
    //     children: [
    //       const PastBatchClasses(),
    return _mainPageBuilder(context, Get.find<PastClassesController>());
    //     ],
    //   ),
    // );
  }

  Widget _mainPageBuilder(
      BuildContext context, PastClassesController controller) {
    return RefreshIndicator(
      color: ColorResource.primaryColor,
      onRefresh: controller.onRefresh,
      child: SingleChildScrollView(
        controller: controller.dataPagingController.value.scrollController,
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeDefault),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: DimensionResource.marginSizeDefault,
            ),
            Row(
              children: [
                Expanded(
                  child: Obx(() {
                    return SearchWidget(
                      enableMargin: false,
                      textEditingController: controller.searchController.value,
                      onChange: controller.onClassSearch,
                      onClear: () {
                        controller.onClassSearch("");
                      },
                    );
                  }),
                ),
                const SizedBox(
                  width: DimensionResource.marginSizeDefault,
                ),
                InkWell(
                    onTap: () {
                      buildShowModalBottomSheet(context, Obx(() {
                        return controller.isClearLoading.value
                            ? const CircularProgressIndicator()
                            : LiveFilterScreen(
                          onClear: (val) {
                            //controller.listOFSelectedLang.clear();
                            controller.selectedRating.value =
                            val['rating'];
                            controller.listOFSelectedDuration.clear();
                            controller.listOFSelectedCat.clear();
                            controller.listOFSelectedDate.clear();
                            // controller.selectedLevel.value = val['level'];
                            controller.isClearLoading.value = true;
                            Future.delayed(Duration.zero, () {
                              controller.isClearLoading.value = false;
                            });
                            controller.selectedSub.value = val['is_free'];
                            controller.listofSelectedTeacher.value =
                            val['teacher'];
                            controller.getLiveData(
                              pageNo: 1,
                              categoryId: controller.listOFSelectedCat
                                  .map((element) => element.id)
                                  .toList()
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "")
                                  .removeAllWhitespace,
                              duration: controller.listOFSelectedDuration
                                  .map((element) => element.optionName)
                                  .toList()
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "")
                                  .removeAllWhitespace,
                              teacherId: controller.listofSelectedTeacher
                                  .map((element) => element.id)
                                  .toList()
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "")
                                  .removeAllWhitespace,
                              dateFilter: Session.getSelectedDateFilter().toString(),
                              //langId: controller.listOFSelectedLang.map((element) => element.id).toList().toString().replaceAll("[", "").replaceAll("]", "").removeAllWhitespace,
                              // rating: controller.selectedRating,
                              subscriptionLevel:
                              val['is_free'].optionName,
                            );
                            Get.back();
                          },
                          listOfSelectedTeacher:
                          controller.listofSelectedTeacher,
                          isHideTeacher: true,
                          isHideRating: true,
                          isHideTime: true,
                          isHideLevel: true,
                          selectedSubscription:
                          controller.selectedSub.value,
                          listOFSelectedLevel: const [],
                          listOFSelectedCat: controller.listOFSelectedCat,
                          listOFSelectedDays:controller.listOFSelectedDate,
                          listOFSelectedDuration:
                          controller.listOFSelectedDuration,
                          listOFSelectedLang: const [],
                          listOFSelectedRating: controller.selectedRating,
                          isPastFilter: true,
                          onApply: (val) {
                            // controller.selectedLevel.value = val['level'];
                            controller.selectedSub.value = val['is_free'];
                            controller.listofSelectedTeacher.value =
                            val['teacher'];
                            controller.selectedRating.value =
                            val['rating'];
                            controller.listOFSelectedCat.value =
                            val['category'];
                            //controller.listOFSelectedLang.value = val['language'];
                            controller.listOFSelectedDuration.value =
                            val['duration'];
                            controller.getLiveData(
                              pageNo: 1,
                              categoryId: controller.listOFSelectedCat
                                  .map((element) => element.id)
                                  .toList()
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "")
                                  .removeAllWhitespace,
                              teacherId: controller.listofSelectedTeacher
                                  .map((element) => element.id)
                                  .toList()
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "")
                                  .removeAllWhitespace,
                              dateFilter: Session.getSelectedDateFilter().toString(),
                              duration: controller.listOFSelectedDuration
                                  .map((element) => element.optionName)
                                  .toList()
                                  .toString()
                                  .replaceAll("[", "")
                                  .replaceAll("]", "")
                                  .removeAllWhitespace,
                              subscriptionLevel:
                              controller.selectedSub.value.optionName,
                            );
                          },
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
                        color: ColorResource.primaryColor,
                        height: 18,
                      ),
                    ))
              ],
            ),
            const SizedBox(
              height: DimensionResource.marginSizeSmall,
            ),
            Text(
              "Past Webinar Recordings",
              style: StyleResource.instance.styleSemiBold(),
            ),
            const SizedBox(
              height: DimensionResource.marginSizeSmall,
            ),
            videoCourseWrapList(
                pastClassesController: controller, context: context),
            const SizedBox(
              height: DimensionResource.marginSizeSmall,
            ),
            Visibility(
                visible:
                controller.dataPagingController.value.isDataLoading.value &&
                    controller.searchController.value.text.isEmpty,
                child: const Padding(
                  padding: EdgeInsets.only(bottom: 15.0),
                  child: CommonCircularIndicator(),
                )),
          ],
        ),
      ),
    );
  }

  Widget videoCourseWrapList(
      {required PastClassesController pastClassesController,
        required BuildContext context}) {
    return Obx(() => pastClassesController.isDataLoading.value &&
        pastClassesController.searchController.value.text
            .isEmpty // No shimmer during search
        ? (MediaQuery.of(context).size.width < 600
        ? ShimmerEffect.instance
        .upcomingLiveRecordingClassLoaderForMobile()
        : ShimmerEffect.instance
        .upcomingLiveRecordingClassLoaderForTab())
        : pastClassesController.dataPagingController.value.list.isEmpty
        ? const SizedBox(
        height: 500,
        child: NoDataFound(
          showText: true,
          text: "Be a Pro to Watch Class Recordings",
        ))
        : SingleChildScrollView(
      child: GridView.builder(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount:
          MediaQuery.of(context).size.width < 500 ? 1 : 2,
          crossAxisSpacing: DimensionResource.marginSizeSmall + 6,
          mainAxisSpacing: DimensionResource.marginSizeExtraSmall,
          childAspectRatio: 1.5, // Adjust ratio if needed
        ),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: pastClassesController
            .dataPagingController.value.list.length,
        itemBuilder: (context, index) {
          CommonDatum data = CommonDatum.fromJson(
            pastClassesController.dataPagingController.value.list
                .elementAt(index)
                .toJson(),
          );

          return Padding(
            padding: EdgeInsets.only(
              bottom: pastClassesController.dataPagingController
                  .value.list.length -
                  1 ==
                  index
                  ? DimensionResource.marginSizeDefault
                  : 0,
            ),
            child: _pastLiveClassesView(
              context,
              index,
              fontSize: DimensionResource.marginSizeSmall + 3,
              data: data,
              isPast: true,
              pastClassesController: pastClassesController,
              onItemTap: (data) {},
              isTrial: pastClassesController.isTrialList[
              index], // Passing specific isTrial value for each item
            ),
          );
        },
      ),
    )

      /*Wrap(
                spacing: DimensionResource.marginSizeSmall,
                runSpacing: DimensionResource.marginSizeExtraSmall,
                children: List.generate(
                    pastClassesController
                        .dataPagingController.value.list.length, (index) {
                  CommonDatum data = CommonDatum.fromJson(pastClassesController
                      .dataPagingController.value.list
                      .elementAt(index)
                      .toJson());
                  return Padding(
                    padding: EdgeInsets.only(
                        bottom: pastClassesController.dataPagingController.value
                                        .list.length -
                                    1 ==
                                index
                            ? DimensionResource.marginSizeDefault
                            : 0),
                       child: _pastLiveClassesView(index,
                        height: 120,
                        fontSize: DimensionResource.marginSizeSmall + 3,
                        data: data,
                        isPast: true,
                        pastClassesController: pastClassesController,
                        onItemTap: (data) {},
                        size: MediaQuery.of(context).size),
                  );
                }),
              )*/
    );
  }
}

Widget _pastLiveClassesView(BuildContext context, int index,
    {double fontSize = DimensionResource.fontSizeExtraSmall - 2,
      bool isPast = false,
      Function(CommonDatum data)? onItemTap,
      required CommonDatum data,
      required PastClassesController pastClassesController,
      required RxBool isTrial}) {
  final authService = Get.find<AuthService>();
  final userRole = authService.userRole.value;
  String formattedDate = DateFormat("dd MMM yyyy")
      .format(DateTime.parse(data.startTime.toString()));

  String formattedTime =
  DateFormat.jm().format(DateTime.parse(data.startTime.toString()));
  final LiveClassesController liveClassesController =
  Get.put(LiveClassesController());
  final LiveClassDetailController liveClassDetailController =
  Get.put(LiveClassDetailController());
  final PastClassesController pastClassesController =
  Get.put(PastClassesController());
  var expiredPopup =
      liveClassesController.liveData.value.data!.expiredUserPopup;

  final ui = liveClassesController.liveData.value!.cardUi!;
  final teacher =
  data.teacher!.certificationText.toString().split(' ').join('\n');

  logPrint("is trial past ${data.isTrial}");
  logPrint("is trial title ${data.title}");
  logPrint("is trial contro ${pastClassesController.liveData.toString()}");

  return InkWell(
    onTap: () {
      bool trialStatus = pastClassesController.isTrialList[index].value;
      logPrint("trailStatus is : ${trialStatus}");
      AppConstants.instance.liveId.value = (data.id.toString());
      Get.toNamed(Routes.liveClassDetail(id: data.id.toString()),
          arguments: [isPast, data.id.toString(), trialStatus]);
      if (onItemTap != null) {
        onItemTap(data);
      }
    },
    child: Container(
      margin: EdgeInsets.only(top: 5),
      decoration: BoxDecoration(
        color: hexToColor(ui.cardBgColor),
        shape: BoxShape.rectangle,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3), // Subtle shadow color
            blurRadius: 8, // Slight blur for the shadow
            offset: Offset(2, 2), // Slight offset to make the shadow visible
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            padding: EdgeInsets.symmetric(vertical: 6, horizontal: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              // Align text left and button right
              children: [
                Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: hexToColor(ui.dateTimeChipBgColor),
                        shape: BoxShape.rectangle,
                        borderRadius:
                        BorderRadius.circular(25), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.calendar_month_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            formattedDate,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: hexToColor(ui.dateTimeChipTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 5,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        color: hexToColor(ui.dateTimeChipBgColor),
                        shape: BoxShape.rectangle,
                        borderRadius:
                        BorderRadius.circular(25), // Rounded corners
                      ),
                      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.access_time_rounded,
                            color: Colors.white,
                            size: 12,
                          ),
                          SizedBox(
                            width: 3,
                          ),
                          Text(
                            "${data.duration.toString() + " mins"}",
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: hexToColor(ui.dateTimeChipTextColor),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    !isTrial.value && Get.find<AuthService>().isTrial.value
                        ? Container(
                      width: 100,
                      child: InkWell(
                        onTap: () {
                          Get.find<RootViewController>().getPopUpData2();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                color: hexToColor(ui.unlockButtonColor),
                                border: Border.all(
                                    color: Colors.white, width: 1),
                                borderRadius: BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/Lock.svg",
                                  width: 13,
                                  height: 13,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  ui.unlockButtonText.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    )
                        : Container(
                      width: 100,
                      child: (Get.find<AuthService>().isFreshUser.value ||
                          Get.find<AuthService>().isGuestUser.value ||
                          Get.find<AuthService>()
                              .isTrialExpired
                              .value ||
                          Get.find<AuthService>().isProExpired.value)
                          ? InkWell(
                        onTap: () {
                          Get.find<RootViewController>()
                              .getPopUpData2(
                              title: expiredPopup?.title,
                              subtitle: expiredPopup?.subtitle,
                              imageUrl: expiredPopup?.imageUrl,
                              buttonTitle:
                              expiredPopup?.buttonTitle);
                        },
                        child: Container(
                            padding:
                            EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                color: hexToColor(
                                    ui.unlockButtonColor),
                                border: Border.all(
                                    color: Colors.white, width: 1),
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/Lock.svg",
                                  width: 13,
                                  height: 13,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  ui.unlockButtonText.toString(),
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )),
                      )
                          : InkWell(
                        onTap: () {
                          print(
                              'sdffsdfc ${data.fileUrl.toString()}');
                          Get.to(FileVideoWidget(
                            url: data.fileUrl.toString(),
                            isOrientation: false,
                            orientation: false,
                            eventCallBack:
                                (progress, totalDuration) {},
                          ));
                        },
                        child: Container(
                            padding:
                            EdgeInsets.symmetric(vertical: 6),
                            decoration: BoxDecoration(
                                color:
                                hexToColor(ui.playButtonColor),
                                borderRadius:
                                BorderRadius.circular(10)),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.center,
                              crossAxisAlignment:
                              CrossAxisAlignment.center,
                              children: [
                                SvgPicture.asset(
                                  "assets/svg/LiveVideo.svg",
                                  width: 12,
                                  height: 12,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '${ui.playButtonText}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w500,
                                    color: hexToColor(
                                        ui.playButtonTextColor),
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            )),
                      ),
                    ),
                    // SizedBox(width: 8,),
                    //
                    // Container(
                    //   height: 30,width: 30,
                    //   child: data.fileUrl.toString() != null &&
                    //       data.fileUrl.toString() != ""
                    //       ? Flexible(
                    //     flex: 2,
                    //     child: Container(
                    //       // padding: const EdgeInsets.symmetric(
                    //       //     horizontal: DimensionResource.marginSizeDefault,
                    //       //     vertical: DimensionResource.marginSizeSmall),
                    //       child: Obx(() {
                    //
                    //         String videoUrl = data.fileUrl.toString();
                    //         // String videoUrl = controller.liveClassDetail.value.data!.title.toString();
                    //
                    //         bool isDownloaded = liveClassDetailController.downloadedVideos
                    //             .any((video) => video.title == data.title);
                    //
                    //         // Check if the current video is being downloaded or is already downloaded
                    //         bool isDownloading = liveClassDetailController
                    //             .isDownloadingMap[videoUrl] ??
                    //             false;
                    //         // bool isDownloaded = liveClassDetailController.isDownloadedMap[videoUrl] ?? false;
                    //         double progress = liveClassDetailController
                    //             .downloadProgressMap[videoUrl] ??
                    //             0.0;
                    //         String status = liveClassDetailController
                    //             .downloadStatusMap[videoUrl] ??
                    //             "";
                    //
                    //         return isDownloading
                    //             ? Stack(
                    //               alignment: Alignment.center,
                    //               children: [
                    //                 // CircularProgressIndicator
                    //                 CircularProgressIndicator(
                    //                   value: progress,
                    //                   strokeWidth: 3,
                    //                   color: ColorResource.primaryColor,
                    //                   backgroundColor:
                    //                   Colors.grey.shade300,
                    //                 ),
                    //                 // Percentage text in the center of the progress indicator
                    //                 Text(
                    //                   "${(progress * 100).toStringAsFixed(0)}%",
                    //                   style: TextStyle(
                    //                     color:
                    //                     ColorResource.primaryColor,
                    //                     fontSize: MediaQuery.of(context)
                    //                         .size
                    //                         .width *
                    //                         0.020,
                    //                     fontWeight: FontWeight.w600,
                    //                   ),
                    //                 ),
                    //               ],
                    //             )
                    //             : isDownloaded
                    //             ? Container(
                    //           // padding: EdgeInsets.all(10),
                    //           decoration: BoxDecoration(
                    //               shape: BoxShape.circle,
                    //               color:
                    //               ColorResource.primaryColor),
                    //           child: Icon(Icons.check_rounded,color: Colors.white,size: 18,)
                    //         )
                    //             : GestureDetector(
                    //           onTap: () {
                    //             final isTrialCourse = liveClassDetailController
                    //                 .liveClassDetail
                    //                 .value
                    //                 .data
                    //                 ?.isTrial ??
                    //                 0;
                    //             final isProUser =
                    //                 Get.find<AuthService>()
                    //                     .isPro
                    //                     .value;
                    //
                    //             if (isTrialCourse == 1 ||
                    //                 isProUser) {
                    //               liveClassDetailController
                    //                   .downloadVideo(
                    //                 data.fileUrl.toString(),
                    //                 data.title
                    //                     .toString(),
                    //                 data.preview
                    //                     .toString(),
                    //               );
                    //             } else {
                    //               ProgressDialog().showFlipDialog(
                    //                 title:
                    //                 "Download All Premium Stock Market Content as a Pro User. Continue?",
                    //                 isForPro:
                    //                 !Get.find<AuthService>()
                    //                     .isGuestUser
                    //                     .value,
                    //               );
                    //             }
                    //           },
                    //           child: Container(
                    //             // padding: EdgeInsets.all(10),
                    //             decoration: BoxDecoration(
                    //                 shape: BoxShape.circle,
                    //                 color:
                    //                 ColorResource.primaryColor),
                    //             child: Icon(Icons.download_rounded,color: Colors.white,size: 20,)
                    //           ),
                    //         );
                    //       }),
                    //     ),
                    //   )
                    //       : Container(),
                    // ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            margin: const EdgeInsets.only(bottom: 50),
            decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    hexToColor(ui.cardColor1),
                    hexToColor(ui.cardColor2),
                    // hexToColor(ui.cardBgColor2)
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                // color: hexToColor(ui.cardBgColor2),
                shape: BoxShape.rectangle,
                borderRadius: BorderRadius.circular(15)),
            child: Column(
              children: [
                SizedBox(
                  height: 15,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 5,
                        child: Text(
                          data.title ?? '',
                          style: TextStyle(
                            decorationColor: Colors.white,
                            decorationThickness: 1,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: hexToColor(ui.titleColor),
                          ),
                          overflow: TextOverflow.ellipsis,
                          // Prevents overflow
                          maxLines: 3,
                        ),
                      ),
                      Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.bottomRight,
                            child: Stack(
                              children: [
                                Container(
                                  height: 115.0,
                                  width: 115.0,
                                  decoration: BoxDecoration(
                                    border: Border.all(color: Colors.white),
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        data.preview ?? data.image ?? "",
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                    shape: BoxShape.circle,
                                    gradient: LinearGradient(
                                        begin: Alignment.topCenter,
                                        end: Alignment.bottomCenter,
                                        colors: [
                                          hexToColor("FF01053A"),
                                          hexToColor("FF01053A"),
                                          hexToColor(ui.certificationBgColor),
                                          hexToColor(ui.certificationBgColor),
                                        ],
                                        stops: [
                                          0.0,
                                          0.6,
                                          0.3,
                                          1.0
                                        ]),
                                  ),
                                ),
                                if (teacher != 'null')
                                  Container(
                                    height: 115.0,
                                    width: 115.0,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.white),
                                      // image: DecorationImage(
                                      //   image: NetworkImage(
                                      //     '',
                                      //   ),
                                      //   fit: BoxFit.contain,
                                      // ),
                                      shape: BoxShape.circle,
                                      gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.transparent,
                                            Colors.transparent,
                                            hexToColor(ui.certificationBgColor),
                                            hexToColor(ui.certificationBgColor),
                                          ],
                                          stops: [
                                            0.0,
                                            0.7,
                                            0.3,
                                            1.0
                                          ]),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 10, vertical: 5),
                                      alignment: Alignment.bottomCenter,
                                      child: Text(teacher,
                                          textAlign: TextAlign.center,
                                          maxLines: 2,
                                          style: TextStyle(
                                            fontSize: 9,
                                            fontWeight: FontWeight.bold,
                                            color: hexToColor(
                                                ui.certificationTextColor),
                                          )),
                                    ),
                                  ),
                              ],
                            ),
                          ))
                    ],
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Positioned(
            top: 2, // Moves the date container out of the border
            left: 6,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 8, vertical: 5),
              margin: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              decoration: BoxDecoration(
                color: hexToColor(ui.bottomChipBgColor),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                data.category!.title.toString(),
                style: TextStyle(
                    fontSize: 9,
                    color: hexToColor(ui.bottomChipTextColor),
                    fontWeight: FontWeight.w500),
              ),
            ),
          ),
          Align(
            alignment: Alignment.topRight,
            child: Container(
              alignment: Alignment.topRight,
              margin: EdgeInsets.all(6),
              child: userRole == "trial_user"
              // ||
              //     userRole == "trial_expired_user"
                  ? Obx(
                    () => isTrial.value
                    ? Container()
                // FreeContainerButton(
                //     isCircle: true,
                //     isShow:
                //         isTrial) // Show FreeContainerButton if isTrial is true
                    : const ProContainerButton(
                  isCircle: true,
                  isShow: true,
                ), // Show ProContainerButton if isTrial is false
              )
                  : userRole != "pro_user"
                  ? const ProContainerButton(
                isCircle: true,
                isShow: true,
              )
                  : Container(),
            ),
          ),
        ],
      ),
    ),
  );
}
