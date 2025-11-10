import 'package:flutter/foundation.dart';
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
import '../../../../model/services/player/file_video_widget_past.dart';
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
import '../../../../enum/routing/routes/app_pages.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/search_widget/search_container.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';
import '../home_view/widget/top_ten_widget.dart';
import '../live_classes_view/filter_view/filter_view.dart';
import 'package:stockpathshala_beta/loader.dart';

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
    return _mainPageBuilder(context, Get.find<PastClassesController>());
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
                                controller.listOFSelectedDuration.clear();
                                controller.listOFSelectedCat.clear();
                                controller.listOFSelectedDate.clear();
                                controller.isClearLoading.value = true;
                                controller.listofSelectedTeacher.clear();
                                Future.delayed(Duration.zero, () {
                                  controller.isClearLoading.value = false;
                                });
                                controller.getLiveData(
                                  pageNo: 1,
                                  searchKeyWord: "",
                                  categoryId: "",
                                  langId: "",
                                  teacherId: "",
                                  dateFilter: "",
                                  levelId: "",
                                  duration: "",
                                  rating: "",
                                  subscriptionLevel: "",
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
                              listOFSelectedDays: controller.listOFSelectedDate,
                              listOFSelectedDuration:
                                  controller.listOFSelectedDuration,
                              listOFSelectedLang: const [],
                              listOFSelectedRating: controller.selectedRating,
                              isPastFilter: true,
                              onApply: (val) {
                                logPrint("selectedValue $val");
                                controller.selectedSub.value = val['is_free'];
                                controller.listofSelectedTeacher.value =
                                    val['teacher'];
                                controller.listOFSelectedDate.value =
                                    val['days'];
                                controller.selectedRating.value = val['rating'];
                                controller.listOFSelectedCat.value =
                                    val['category'];
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
                                  dateFilter: controller.listOFSelectedDate
                                      .map((e) => e.displayName?.toLowerCase())
                                      .join(','),
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
                  ),
                )
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

            //list
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

  Widget videoCourseWrapList({
    required PastClassesController pastClassesController,
    required BuildContext context,
  }) {
    return Obx(() {
      final isInitialLoading = pastClassesController.isDataLoading.value &&
          pastClassesController.searchController.value.text.isEmpty &&
          pastClassesController.dataPagingController.value.list.isEmpty;

      final hasNoData =
          pastClassesController.dataPagingController.value.list.isEmpty &&
              !pastClassesController.isDataLoading.value &&
              pastClassesController.hasMore.value == false;

      if (isInitialLoading) {
        return MediaQuery.of(context).size.width < 600
            ? ShimmerEffect.instance.upcomingLiveRecordingClassLoaderForMobile()
            : ShimmerEffect.instance.upcomingLiveRecordingClassLoaderForTab();
      }

      if (hasNoData) {
        return const SizedBox(
          height: 500,
          child: NoDataFound(
            showText: true,
            text: "Be a Pro to Watch Class Recordinngs",
          ),
        );
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            if (pastClassesController.hasMore.value &&
                !pastClassesController.isDataLoading.value &&
                !pastClassesController
                    .dataPagingController.value.isDataLoading.value) {
              pastClassesController.loadMoreData();
            }
          }
          return false;
        },
        child: Column(
          children: [
            GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: MediaQuery.of(context).size.width < 500 ? 1 : 2,
                crossAxisSpacing: DimensionResource.marginSizeSmall + 6,
                mainAxisSpacing: DimensionResource.marginSizeExtraSmall,
                childAspectRatio: 1.5,
              ),
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount:
                  pastClassesController.dataPagingController.value.list.length,
              itemBuilder: (context, index) {
                if (index >=
                    pastClassesController
                        .dataPagingController.value.list.length) {
                  return const SizedBox.shrink();
                }

                if (index >= pastClassesController.isTrialList.length) {
                  pastClassesController.isTrialList.add(RxBool(false));
                }

                CommonDatum data = pastClassesController
                    .dataPagingController.value.list
                    .elementAt(index);

                return Padding(
                  padding: EdgeInsets.only(
                    bottom: index ==
                            pastClassesController
                                    .dataPagingController.value.list.length -
                                1
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
                    isTrial: pastClassesController.isTrialList[index],
                  ),
                );
              },
            ),
            Obx(() {
              final isPaginating = pastClassesController
                      .dataPagingController.value.isDataLoading.value ||
                  (pastClassesController.isDataLoading.value &&
                      pastClassesController
                          .dataPagingController.value.list.isNotEmpty);

              final hasNoMore = !pastClassesController.hasMore.value &&
                  pastClassesController
                      .dataPagingController.value.list.isNotEmpty;

              if (isPaginating) {
                return Container(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  child: const Column(
                    children: [
                      Loader(),
                      SizedBox(
                        height: 8,
                      ),
                      Text(
                        'Loading more recordings...',
                        style: TextStyle(
                            fontSize: 12, color: ColorResource.textLightGrey),
                      ),
                      SizedBox(height: 100),
                    ],
                  ),
                );
              }

              if (hasNoMore) {
                return Container(
                  padding: const EdgeInsets.all(16),
                  child: const Center(
                    child: Text(
                      "No more courses to load",
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                  ),
                );
              }

              return const SizedBox.shrink();
            }),
          ],
        ),
      );
    });
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
                arguments: [isPast, data.id.toString(), trialStatus])
            ?.then(((onValue) {
          print("Returned from liveClassDetail, API called.");
          pastClassesController.getLiveData(pageNo: 1);
        }));
        if (onItemTap != null) {
          onItemTap(data);
        }
      },
      child: Container(
        margin: const EdgeInsets.only(top: 5),
        decoration: BoxDecoration(
          color: hexToColor(ui.cardBgColor),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3), // Subtle shadow color
              blurRadius: 8, // Slight blur for the shadow
              offset: const Offset(
                  2, 2), // Slight offset to make the shadow visible
            ),
          ],
        ),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
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
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.calendar_month_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(
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
                      const SizedBox(
                        width: 5,
                      ),
                      Container(
                        decoration: BoxDecoration(
                          color: hexToColor(ui.dateTimeChipBgColor),
                          shape: BoxShape.rectangle,
                          borderRadius:
                              BorderRadius.circular(25), // Rounded corners
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.access_time_rounded,
                              color: Colors.white,
                              size: 12,
                            ),
                            const SizedBox(
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
                          ? SizedBox(
                              width: 100,
                              child: InkWell(
                                onTap: () {
                                  Get.find<RootViewController>()
                                      .getPopUpData2();
                                },
                                child: Container(
                                    padding:
                                        const EdgeInsets.symmetric(vertical: 6),
                                    decoration: BoxDecoration(
                                        color: hexToColor(ui.unlockButtonColor),
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
                                        const SizedBox(
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
                          : SizedBox(
                              width: 100,
                              child: (Get.find<
                                              AuthService>()
                                          .isFreshUser
                                          .value ||
                                      Get.find<AuthService>()
                                          .isGuestUser
                                          .value ||
                                      Get.find<AuthService>()
                                          .isTrialExpired
                                          .value ||
                                      Get.find<AuthService>()
                                          .isProExpired
                                          .value)
                                  ? InkWell(
                                      onTap: () {
                                        Get.find<RootViewController>()
                                            .getPopUpData2(
                                                title: expiredPopup?.title,
                                                subtitle:
                                                    expiredPopup?.subtitle,
                                                imageUrl:
                                                    expiredPopup?.imageUrl,
                                                buttonTitle:
                                                    expiredPopup?.buttonTitle);
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          decoration: BoxDecoration(
                                              color: hexToColor(
                                                  ui.unlockButtonColor),
                                              border: Border.all(
                                                  color: Colors.white,
                                                  width: 1),
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
                                              const SizedBox(
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
                                        if (kDebugMode) {
                                          print(
                                              'fileUrl ${data.fileUrl.toString()}');
                                        }
                                        Get.to(FileVideoWidgetPast(
                                          url: data.fileUrl.toString(),
                                          isOrientation: false,
                                          orientation: false,
                                          watchedTime: data.lastWatchedSecond,
                                          eventCallBack:
                                              (progress, totalDuration) {
                                            print(
                                                "progress: $progress / totalDuration: $totalDuration");

                                            final lastWatched =
                                                data.lastWatchedSecond ?? 0;
                                            final combinedProgress =
                                                progress + lastWatched;

                                            if ((progress != 0 &&
                                                    progress < totalDuration &&
                                                    progress % 10 == 0) ||
                                                progress == totalDuration) {
                                              Future.sync(() {
                                                pastClassesController
                                                    .sendVideoTime(progress,
                                                        totalDuration, data.id);
                                              });
                                            }
                                          },
                                          isExit: (bool p1) {
                                            Get.find<PastClassesController>()
                                                .getLiveData(pageNo: 1);
                                          },
                                        ));
                                      },
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          decoration: BoxDecoration(
                                              color: hexToColor(
                                                  ui.playButtonColor),
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
                                              const SizedBox(
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
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              child: Container(
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
                    const SizedBox(
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
                                              hexToColor(
                                                  ui.certificationBgColor),
                                              hexToColor(
                                                  ui.certificationBgColor),
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
                                          border:
                                              Border.all(color: Colors.white),
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
                                                hexToColor(
                                                    ui.certificationBgColor),
                                                hexToColor(
                                                    ui.certificationBgColor),
                                              ],
                                              stops: [
                                                0.0,
                                                0.7,
                                                0.3,
                                                1.0
                                              ]),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
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
                  ],
                ),
              ),
            ),
            Positioned(
              top: 2, // Moves the date container out of the border
              left: 6,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
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
                margin: const EdgeInsets.all(6),
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
      ));
}
