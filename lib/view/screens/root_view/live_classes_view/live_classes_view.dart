import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:overlay_tooltip/overlay_tooltip.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/service/utils/object_extension.dart';
import 'package:stockpathshala_beta/view/screens/base_view/base_view_screen.dart';
import 'package:stockpathshala_beta/view/screens/root_view/batches/widgets/live_dot.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/filter_view/filter_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/past_classes/past_live_classes_view.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quiz_list.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/no_data_found/no_data_found.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/small_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import '../../../../mentroship/view/mentorship_detail_screen.dart';
import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/live_classes_controller.dart';
import '../../../widgets/button_view/common_button.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../widgets/custom_drop_down_widget/custom_drop_down_widget.dart';
import '../../../widgets/custom_list_tile/custom_list_tile.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/search_widget/search_container.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../home_view/widget/top_ten_widget.dart';
import 'package:stockpathshala_beta/loader.dart';

class LiveClassesView extends StatefulWidget {
  const LiveClassesView({super.key});

  @override
  State<LiveClassesView> createState() => _LiveClassesViewState();
}

class _LiveClassesViewState extends State<LiveClassesView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    // Get.put(LiveClassesController());
    Get.find<LiveClassesController>().tabController = TabController(
        length: Get.find<LiveClassesController>().tabs.length, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => Container(
        margin: const EdgeInsets.only(
            top: DimensionResource.marginSizeExtraSmall + 5,
            bottom: DimensionResource.marginSizeExtraSmall),
        child: ClipRRect(
          borderRadius: const BorderRadius.all(
              Radius.circular(DimensionResource.borderRadiusExtraLarge)),
          child: ColoredBox(
            color: Colors.black38,
            child: TabBar(
              splashBorderRadius: const BorderRadius.all(
                  Radius.circular(DimensionResource.borderRadiusExtraLarge)),
              dividerColor: ColorResource.primaryColor,
              indicator: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(
                      DimensionResource.borderRadiusExtraLarge)),
                  shape: BoxShape.rectangle,
                  color: ColorResource.white),
              labelColor: ColorResource.primaryColor,
              unselectedLabelColor: Colors.white,
              indicatorSize: TabBarIndicatorSize.tab,
              tabs: controller.tabs,
              controller: controller.tabController,
            ),
          ),
        ),
      ),
      onActionBuilder: (context, controller) => [],
      isBackShow: false,
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: LiveClassesController(),
      onPageBuilder: (context, controller) {
        return TabBarView(controller: controller.tabController, children: [
          _mainPageBuilder(context, controller),
          const PastClassesView()
        ]);
      },
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, LiveClassesController controller) {
    final size = MediaQuery.of(context).size;
    double width = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      color: ColorResource.primaryColor,
      onRefresh: controller.onRefresh,
      child: ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        controller: controller.dataPagingController.value.scrollController,
        padding: const EdgeInsets.only(
            left: DimensionResource.marginSizeDefault,
            right: DimensionResource.marginSizeDefault),
        shrinkWrap: false,
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
                              type: 'live webinar',
                          
                              onClear: (val) {
                                controller.selectedRating.value = val['rating'];
                                controller.listOFSelectedDuration.clear();
                                controller.listOFSelectedCat.clear();
                                controller.listOFSelectedDate.clear();
                                controller.isClearLoading.value = true;
                                Future.delayed(Duration.zero, () {
                                  controller.isClearLoading.value = false;
                                });
                                controller.selectedSub.value = val['is_free'];
                                controller.listofSelectedTeacher.value =
                                    val['teacher'];
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
                                // controller.selectedLevel.value = val['level'];
                                controller.selectedSub.value = val['is_free'];
                                controller.listofSelectedTeacher.value =
                                    val['teacher'];
                                controller.listOFSelectedDate.value =
                                    val['days'];
                                controller.selectedRating.value = val['rating'];
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
                                  // teacherId: controller.listofSelectedTeacher
                                  //     .map((element) => element.id)
                                  //     .toList()
                                  //     .toString()
                                  //     .replaceAll("[", "")
                                  //     .replaceAll("]", "")
                                  //     .removeAllWhitespace,
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
                  ))
            ],
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
//         Text(
//   "View upcoming live webinars.",
//   style: TextStyle(
//     color: Colors.amber,
//     fontFamily: 'DMSans',
//     fontSize: 22,
//     fontWeight: FontWeight.w800,
//   ),
// )
// ,


          Text(
            "Hello StockPathshala!",
            style: TextStyle(
                fontFamily: 'DMSans',
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),

          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          videoCourseWrapList(liveClassesController: controller, size: size),
          const SizedBox(
            height: 15,
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
    );
  }

  Future<dynamic> buildShowModalBottomSheet(BuildContext context, Widget child,
      {Color? bgColor,
      double radius = 20,
      bool isDark = true,
      bool isDismissible = false}) {
    return showModalBottomSheet(
        isScrollControlled: true,
        barrierColor: Colors.black.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        context: context,
        builder: (context) {
          return Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: ClipRRect(
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(radius),
                topLeft: Radius.circular(radius),
              ),
              child: Container(
                constraints: BoxConstraints(maxHeight: Get.height * 0.75),
                // height: MediaQuery.of(context).size.height * 0.44+height,
                decoration: BoxDecoration(
                    color: !isDark
                        ? bgColor ?? ColorResource.white
                        : bgColor ?? ColorResource.secondaryColor,
                    boxShadow: const [
                      BoxShadow(
                          color: ColorResource.secondaryColor,
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, -2))
                    ],
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(radius),
                      topLeft: Radius.circular(radius),
                    )),
                child: SingleChildScrollView(
                  //padding: const EdgeInsets.only(bottom: DimensionResource.marginSizeSmall),
                  physics: const ClampingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(
                            top: DimensionResource.marginSizeExtraSmall + 3),
                        height: 6,
                        width: 45,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: isDark
                                ? ColorResource.borderColor
                                : ColorResource.borderColor),
                      ),
                      child
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }

  Widget videoCourseWrapList({
    required LiveClassesController liveClassesController,
    required Size size,
  }) {
    // return Obx(() {
    //   final isLoading = liveClassesController.isDataLoading.value;
    //   final isSearching =
    //       liveClassesController.searchController.value.text.isNotEmpty;
    //   final classList = liveClassesController.dataPagingController.value.list;
    //   print("classList ${classList.length}");
    //   if (isLoading && !isSearching) {
    //     return MediaQuery.of(context).size.width < 600
    //         ? ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForMobile()
    //         : ShimmerEffect.instance.upcomingLiveWebinarClassLoaderForTab();
    //   }
    //   if (classList.isEmpty) {
    //     return const SizedBox(
    //       height: 400,
    //       child: NoDataFound(
    //         showText: true,
    //         text: "LIVE Classes being Set Up for You!",
    //       ),
    //     );
    //   }
    return Obx(() {
      final classList = liveClassesController.dataPagingController.value.list;
      final isInitialLoading = liveClassesController.isDataLoading.value &&
          liveClassesController.searchController.value.text.isEmpty &&
          liveClassesController.dataPagingController.value.list.isEmpty;

      final hasNoData =
          liveClassesController.dataPagingController.value.list.isEmpty &&
              !liveClassesController.isDataLoading.value &&
              liveClassesController.hasMore.value == false;

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
            text: "Be a Pro to Watch Class Recordings",
          ),
        );
      }

      return ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: classList.length,
        itemBuilder: (context, index) {
          // if(index < classList.length){
          final data = classList[index];
          final item = data;

          double screenWidth = MediaQuery.of(context).size.width;
          double tileWidth =
              screenWidth < 500 ? screenWidth - 20 : screenWidth / 2 - 20;

          bool showDivider = classList.length > 1 &&
              index > 0 &&
              item.isRegister == 0 &&
              classList[index - 1].isRegister == 1;

          return Column(
            children: [
              if (classList.length > 1 &&
                  index > 0 &&
                  item.isRegister == 0 &&
                  classList[index - 1].isRegister == 1)
                const ProfessionalDivider(
                  // color: ColorResource.primaryColor,
                  thickness: 5,
                  margin: 20,
                  text: "Unregistered Webinar",
                  textColor: Colors.black,
                  // isDotted: true,
                  useGradient: true,
                ),
              SizedBox(
                width: tileWidth,
                child: Padding(
                    padding: EdgeInsets.only(
                      bottom: classList.length > 1 &&
                              liveClassesController.dataPagingController.value
                                          .list.length -
                                      1 ==
                                  index
                          ? DimensionResource.marginSizeDefault
                          : 0,
                    ),
                    child: liveClassesView(
                      index,
                      height: 150,
                      width: 300,
                      fontSize: DimensionResource.marginSizeSmall + 3,
                      data: data,
                      liveClassesController: liveClassesController,
                      onItemTap: (data) {},
                      size: size,
                    )),
              ),
            ],
          );

          // }else {
          //   if(liveClassesController.hasMore.value == true) {
          //     return const Center(child: Loader());
          //   }
          // }
        },
      );
    });
  }
}

class ProfessionalDivider extends StatelessWidget {
  final double thickness;
  final Color color;
  final double margin;
  final bool isDotted;
  final bool useGradient;
  final String? text;
  final IconData? icon;
  final Color? textColor;

  const ProfessionalDivider({
    Key? key,
    this.thickness = 1.5,
    this.color = Colors.grey,
    this.margin = 10.0,
    this.isDotted = false,
    this.useGradient = false,
    this.text,
    this.icon,
    this.textColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: margin),
      child: Row(
        children: [
          Expanded(
            child: isDotted ? _buildDottedLine() : _buildSolidLine(),
          ),
          if (text != null || icon != null) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Row(
                children: [
                  if (icon != null) Icon(icon, color: color, size: 18),
                  if (icon != null && text != null) const SizedBox(width: 5),
                  if (text != null)
                    Text(
                      text!,
                      style: TextStyle(
                        color: textColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                ],
              ),
            ),
            Expanded(
              child: isDotted ? _buildDottedLine() : _buildSolidLine(),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSolidLine() {
    return Container(
      height: thickness,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        gradient: useGradient
            ? LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.3),
                  color,
                  ColorResource.primaryColor.withOpacity(0.3)
                ],
              )
            : null,
        color: useGradient ? null : color,
      ),
    );
  }

  Widget _buildDottedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(
            (constraints.maxWidth / 6).floor(),
            (index) => Container(
              width: 4,
              height: thickness,
              decoration: BoxDecoration(
                color: color,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
        );
      },
    );
  }
}

Widget liveClassesView(
  int index, {
  double height = 120,
  double width = 120,
  double fontSize = DimensionResource.fontSizeExtraSmall - 2,
  bool isPast = false,
  Function(CommonDatum data)? onItemTap,
  required CommonDatum data,
  required LiveClassesController liveClassesController,
  required Size size,
}) {
  DateTime serverDateTime = DateTime.parse(
      liveClassesController.liveData.value.serverTime.toString());

  final ui = liveClassesController.liveData.value.cardUi!;
  final teacher = data.teacher!.certificationText
      .toString()
      .split(' ')
      .join('\n'); // Determine if the class has started
  final isClassStarted = !((data.startTime ?? serverDateTime) > serverDateTime);

  DateTime startTime = DateTime.parse(data.startTime.toString());
  DateTime now = DateTime.now();
  DateTime tomorrow = now.add(const Duration(days: 1));

  String formattedDate;

  if (DateFormat("dd MMM yyyy").format(startTime) ==
      DateFormat("dd MMM yyyy").format(now)) {
    formattedDate = "Today";
  } else if (DateFormat("dd MMM yyyy").format(startTime) ==
      DateFormat("dd MMM yyyy").format(tomorrow)) {
    formattedDate = "Tomorrow";
  } else {
    formattedDate = DateFormat("dd MMM yyyy").format(startTime);
  }

  String formattedTime =
      DateFormat.jm().format(DateTime.parse(data.startTime.toString()));

  List<String> timeList = [formattedTime];

  // // final CountdownController countdownController = CountdownController();
  // CountdownController countdownController = Get.put(CountdownController());
  // countdownController.startCountdown(data.startTime.toString());
  // countdownController.formatDate(DateTime.parse(data.startTime.toString()));

  var expiredPopup =
      liveClassesController.liveData.value.data!.expiredUserPopup;

  int timeDifference = liveClassesController.LiveClassTimeDifferences[index];

  String responseString = data.classPoints.toString();
  List<String> points =
      responseString.split(RegExp(r'[\r\n]+')); // Handles \r, \n, or \r\n

  // print('Time list: ${ui.cardBgColor}');

  return InkWell(
    onTap: () {
      AppConstants.instance.liveId.value = (data.id.toString());
      Get.toNamed(
        Routes.liveClassDetail(id: data.id.toString()),
        arguments: [isPast, data.id.toString()],
      )?.then((onValue) {
        print("Returned from liveClassDetail, API called.");
      });
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
            offset:
                const Offset(2, 2), // Slight offset to make the shadow visible
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.bottomLeft,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
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
                            // countdownController.dayText.value,
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
                            formattedTime,
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
                Obx(
                  () => (liveClassesController.isStartedClass[index] == true
                              // countdownController.isTimerFinished.value
                              &&
                              liveClassesController
                                      .LiveClassTimeDifferences.value[index] <=
                                  0 &&
                              data.isRegister == 1) &&
                          (Get.find<AuthService>().isPro.value ||
                              Get.find<AuthService>().isTrial.value)
                      ? Container(
                          width: 100,
                          child: InkWell(
                            onTap: () {
                              // if (liveClassesController.isStartedClass[index] == true) {
                              liveClassesController.onJoinLiveClass(
                                '${data.id ?? 0}',
                                index,
                                liveClassTitle: data.title,
                              );
                              // }
                            },
                            child: Container(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6),
                                decoration: BoxDecoration(
                                    color: hexToColor(ui.joinButtonColor),
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.play_circle_outline_rounded,
                                      color: Colors.white,
                                      size:
                                          12, // Adjusted size for better visibility
                                    ),
                                    const SizedBox(
                                      width: 5,
                                    ),
                                    Text(
                                      ui.joinButtonText.toString(),
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: ColorResource.white,
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
                                    print("getPopUpData2");
                                    Get.find<RootViewController>()
                                        .getPopUpData2(
                                            title: expiredPopup?.title,
                                            subtitle: expiredPopup?.subtitle,
                                            imageUrl: expiredPopup?.imageUrl,
                                            buttonTitle:
                                                expiredPopup?.buttonTitle);
                                  },
                                  child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: 6),
                                      decoration: BoxDecoration(
                                          color:
                                              hexToColor(ui.unlockButtonColor),
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
                                            width: 12,
                                            height: 12,
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
                              : (data.isRegister == 0)
                                  ? InkWell(
                                      onTap: liveClassesController
                                              .isOnTapAllowd.value
                                          ? () async {
                                              print("getPopUpData");
                                              await Get.find<
                                                      RootViewController>()
                                                  .getPopUpData(data, index);
                                            }
                                          : () {},
                                      child: Container(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 6),
                                          decoration: BoxDecoration(
                                              color: hexToColor(
                                                  ui.registerButtonColor),
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                          child: liveClassesController
                                                      .dataPagingController
                                                      .value
                                                      .list[index]
                                                      .isLoading ??
                                                  false
                                              ? const CupertinoActivityIndicator(
                                                  radius: 9.0,
                                                  color: ColorResource.white,
                                                )
                                              : Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.center,
                                                  children: [
                                                    SvgPicture.asset(
                                                      "assets/svg/OneFingerTap.svg",
                                                      width: 12,
                                                      height: 12,
                                                    ),
                                                    const SizedBox(
                                                      width: 5,
                                                    ),
                                                    Text(
                                                      ui.registerButtonText
                                                          .toString(),
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color:
                                                            ColorResource.white,
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                )),
                                    )
                                  : liveClassesController
                                                  .isStartedClass[index] !=
                                              true &&
                                          (data.isRegister == 1 &&
                                              // !isClassStarted) &&
                                              liveClassesController
                                                      .LiveClassTimeDifferences
                                                      .value[index] >
                                                  0)
                                      ? Container(
                                          padding: const EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              top: 6,
                                              bottom: 6),
                                          decoration: BoxDecoration(
                                              color: hexToColor(
                                                  ui.timerButtonColor),
                                              borderRadius:
                                                  BorderRadius.circular(16)),
                                          child: Center(
                                              child: timeDifference < 86400
                                                  ? TimerCountDown(
                                                      isHrShow: false,
                                                      timeInSeconds:
                                                          timeDifference, // Use the seconds directly
                                                      isHrs: true,
                                                      fontStyle: StyleResource
                                                          .instance
                                                          .styleBold(
                                                              fontSize: 12,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .normal,
                                                              color:
                                                                  ColorResource
                                                                      .white),
                                                      remainingSeconds:
                                                          (second) {
                                                        if (second <= 120) {
                                                          EasyDebounce.debounce(
                                                              liveClassesController
                                                                  .start.value
                                                                  .toString(),
                                                              const Duration(
                                                                  milliseconds:
                                                                      1000),
                                                              () async {
                                                            liveClassesController
                                                                    .isStartedClass[
                                                                index] = true;
                                                            // liveClassesController.onRefresh();
                                                          });
                                                        }
                                                      },
                                                    )
                                                  : timeDifference > 86400 * 2.5
                                                      ? Text(
                                                          "Registered",
                                                          style: StyleResource
                                                              .instance
                                                              .styleBold(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color:
                                                                      ColorResource
                                                                          .white),
                                                        )
                                                      : Text(
                                                          "${(timeDifference / 86400).floor()} ${(timeDifference / 86400).floor() == 1 ? 'day' : 'days'}",
                                                          style: StyleResource
                                                              .instance
                                                              .styleBold(
                                                                  fontSize: 12,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .normal,
                                                                  color:
                                                                      ColorResource
                                                                          .white),
                                                        )),
                                        )
                                      : InkWell(
                                          onTap: () {
                                            // if (liveClassesController.isStartedClass[index] == true) {
                                            liveClassesController
                                                .onJoinLiveClass(
                                              '${data.id ?? 0}',
                                              index,
                                              liveClassTitle: data.title,
                                            );
                                            // }
                                          },
                                          child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 6),
                                              decoration: BoxDecoration(
                                                  color: hexToColor(
                                                      ui.joinButtonColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10)),
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
                                                    ui.joinButtonText
                                                        .toString(),
                                                    style: const TextStyle(
                                                      fontWeight:
                                                          FontWeight.w500,
                                                      color:
                                                          ColorResource.white,
                                                      fontSize: 12,
                                                    ),
                                                  ),
                                                ],
                                              )),
                                        )),
                )
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
                                          hexToColor("FF01053A"),
                                          // hexToColor(ui.certificationBgColor),
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
                                teacher != 'null'
                                    ? Container(
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
                                      )
                                    : Container(
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
                                          child: Text('PnL \nVerified',
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
                const SizedBox(
                  height: 15,
                ),
              ],
            ),
          ),
          Positioned(
            top: 2, // Moves the date container out of the border
            left: 6,
            child: Row(
              children: [
                Obx(() =>
                    ((liveClassesController.isStartedClass[index] == true ||
                                isClassStarted) &&
                            (Get.find<AuthService>().isPro.value ||
                                Get.find<AuthService>().isTrial.value))
                        ? LiveDot(
                            left: 0,
                            top: 4,
                            height: 18,
                            width: 15,
                          )
                        : Container()),
                const SizedBox(
                  width: 5,
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 2, vertical: 4),
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
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

class ShowToolTipViw extends StatelessWidget {
  const ShowToolTipViw({
    super.key,
    required this.liveClassesController,
    required this.widget,
    required this.size,
    required this.isClaasJoin,
  });

  final Widget widget;
  final LiveClassesController liveClassesController;
  final Size size;
  final bool isClaasJoin;

  @override
  Widget build(BuildContext context) {
    return OverlayTooltipItem(
      tooltipVerticalPosition: TooltipVerticalPosition.BOTTOM,
      tooltipHorizontalPosition: TooltipHorizontalPosition.CENTER,
      tooltip: (p0) {
        return Container(
          margin: const EdgeInsets.only(top: 10),
          width: size.width * 0.8,
          padding: const EdgeInsets.all(
            10,
          ),
          decoration: BoxDecoration(
              color: ColorResource.white,
              borderRadius: BorderRadius.circular(10)),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                isClaasJoin
                    ? 'Class is LIVE, click here to JOIN.'
                    : 'Click here to register for this class.',
                textAlign: TextAlign.center,
                style: StyleResource.instance.styleMedium(
                  color: ColorResource.black,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  InkWell(
                    onTap: () async {
                      if (isClaasJoin) {
                        await Get.find<AuthService>()
                            .saveTrainingTooltips('joinLiveClass');
                      } else {
                        await Get.find<AuthService>()
                            .saveTrainingTooltips('registerClass');
                      }
                      liveClassesController.rootViewController.toolTipcontroller
                          .dismiss();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 5,
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorResource.primaryColor,
                        ),
                      ),
                      child: Text(
                        'Skip',
                        style: StyleResource.instance.styleMedium(
                          color: ColorResource.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () async {
                      if (isClaasJoin) {
                        await Get.find<
                                AuthService>() // get instance of authservices(which manages user authentication and actions.)
                            .saveTrainingTooltips('joinLiveClass');
                      } else {
                        await Get.find<AuthService>()
                            .saveTrainingTooltips('registerClass');
                      }
                      liveClassesController.rootViewController.toolTipcontroller
                          .dismiss();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      padding: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        top: 5,
                        bottom: 5,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: ColorResource.primaryColor,
                        ),
                      ),
                      child: Text(
                        'Got it',
                        style: StyleResource.instance.styleMedium(
                          color: ColorResource.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
      displayIndex: 3,
      child: widget,
    );
  }
}

class RegisterButton extends StatelessWidget {
  const RegisterButton({
    super.key,
    required this.title,
    required this.onTap,
    this.color,
    this.height = 30,
    this.width = 100,
    this.isLoading = false,
  });

  final String title;
  final Color? color;
  final bool isLoading;
  final double height;
  final double width;

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        height: height,
        width: width,
        decoration: BoxDecoration(
          color: color ?? ColorResource.lightPrimaryColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: isLoading
            ? const SizedBox(
                height: 10,
                width: 10,
                child: CupertinoActivityIndicator(
                  color: ColorResource.white,
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.thumb_up_alt_rounded,
                    color: Colors.white,
                    size: 12, // Adjusted size for better visibility
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    title,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      color: ColorResource.white,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

Widget topPastClassesContainer(
  int index, {
  double height = 120,
  double width = 120,
  double fontSize = DimensionResource.fontSizeExtraSmall - 2,
  bool isPast = false,
  Function(CommonDatum data)? onItemTap,
  required CommonDatum data,
}) {
  return GestureDetector(
    onTap: () {
      AppConstants.instance.liveId.value = (data.id.toString());
      Get.toNamed(Routes.liveClassDetail(id: data.id.toString()),
          arguments: [isPast, data.id.toString()]);
      if (onItemTap != null) {
        onItemTap(data);
      }
    },
    child: SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: const EdgeInsets.only(
          left: DimensionResource.marginSizeSmall,
          bottom: 4,
        ),
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            SizedBox(
              height: height,
              width: width,
              child: cachedNetworkImage(
                data.preview ?? data.image ?? "",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8)
                    ]),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.only(
                  top: DimensionResource.marginSizeExtraSmall + 2,
                  right: DimensionResource.marginSizeExtraSmall + 2,
                  left: DimensionResource.marginSizeExtraSmall + 2,
                  bottom: DimensionResource.marginSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: !isPast,
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: LiveContainer(
                            size: 9,
                            horizontalPadding: 5,
                            verticalPadding: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text(
                    data.title ?? "",
                    style: StyleResource.instance.styleMedium(
                        fontSize: fontSize, color: ColorResource.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

Widget liveClassesContainer(
  int index, {
  double height = 120,
  double width = 120,
  double fontSize = DimensionResource.fontSizeExtraSmall - 2,
  bool isPast = false,
  Function(CommonDatum data)? onItemTap,
  required CommonDatum data,
}) {
  return GestureDetector(
    onTap: () {
      AppConstants.instance.liveId.value = (data.id.toString());
      Get.toNamed(Routes.liveClassDetail(id: data.id.toString()),
          arguments: [isPast, data.id.toString()]);
      if (onItemTap != null) {
        onItemTap(data);
      }
    },
    child: SizedBox(
      height: height,
      width: width,
      child: Card(
        margin: EdgeInsets.zero,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Stack(
          children: [
            SizedBox(
              height: height,
              width: width,
              child: cachedNetworkImage(
                data.preview ?? data.image ?? "",
                fit: BoxFit.cover,
              ),
            ),
            Container(
              height: height,
              width: width,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.black.withOpacity(0.8)
                    ]),
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.only(
                  top: DimensionResource.marginSizeExtraSmall + 2,
                  right: DimensionResource.marginSizeExtraSmall + 2,
                  left: DimensionResource.marginSizeExtraSmall + 2,
                  bottom: DimensionResource.marginSizeSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Visibility(
                        visible: (data.isFree == 0 ? true : false),
                        child: const ProContainerButton(
                          isCircle: true,
                        ),
                      ),
                      Visibility(
                        visible: !isPast,
                        child: const Align(
                          alignment: Alignment.topRight,
                          child: LiveContainer(
                            size: 9,
                            horizontalPadding: 5,
                            verticalPadding: 3,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  ContainerButton(
                    text: data.category?.title?.toUpperCase() ?? "",
                    onPressed: () {},
                    color: ColorResource.yellowColor,
                    textStyle: StyleResource.instance
                        .styleMedium(
                            fontSize: DimensionResource.fontSizeExtraSmall -
                                (width > 130 ? 2 : 4))
                        .copyWith(letterSpacing: .3),
                    radius: 3,
                    padding: const EdgeInsets.all(3),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeExtraSmall,
                  ),
                  Text(
                    isPast
                        ? "Streamed on ${AppConstants.formatDate(data.startTime)}"
                        : AppConstants.formatDateAndTime(data.startTime),
                    style: StyleResource.instance.styleMedium(
                        fontSize: DimensionResource.fontSizeExtraSmall -
                            (width > 130 ? 0 : 2),
                        color: ColorResource.greenDarkColor),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeExtraSmall - 2,
                  ),
                  Text(
                    data.title ?? "",
                    style: StyleResource.instance.styleMedium(
                        fontSize: fontSize, color: ColorResource.white),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                  Visibility(
                    visible: isPast,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: DimensionResource.marginSizeExtraSmall),
                      child: ContainerButton(
                        text: "${data.duration} Minutes",
                        onPressed: () {},
                        color: ColorResource.white,
                        textStyle: StyleResource.instance
                            .styleMedium(
                                fontSize:
                                    DimensionResource.fontSizeExtraSmall - 2,
                                color: ColorResource.primaryColor)
                            .copyWith(letterSpacing: .3),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 3),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    ),
  );
}

class CustomRadioDropdown extends StatefulWidget {
  final String title;
  final bool isLoading;
  final List<DropDownData> listOfData;
  final List<DropDownData> listOfSelectedData;
  final Function(DropDownData) selectedList;

  const CustomRadioDropdown({
    Key? key,
    required this.title,
    required this.isLoading,
    required this.listOfData,
    required this.listOfSelectedData,
    required this.selectedList,
  }) : super(key: key);

  @override
  State<CustomRadioDropdown> createState() => _CustomRadioDropdown();
}

class _CustomRadioDropdown extends State<CustomRadioDropdown> {
  List<DropDownData> listOfData = [];
  DropDownData? selectedData;

  @override
  void initState() {
    listOfData = widget.listOfData;
    if (widget.listOfSelectedData.isNotEmpty) {
      selectedData = widget.listOfSelectedData.first;
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: StyleResource.instance
              .styleMedium(fontSize: DimensionResource.fontSizeDefault - 0.5),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSelectedWrap(selectedData, onClear: (index) {
              widget.selectedList(selectedData ?? DropDownData());
              setState(() {
                // listOfSelectedData.removeAt(index);
              });
            }),
            Container(
              // height: 45,
              padding: const EdgeInsets.only(top: 0),
              decoration: decoration(
                  containerColor: Colors.transparent,
                  borderColor: ColorResource.borderColor,
                  radius: 11,
                  width: 0.5),
              child: CustomExpansionTile(
                iconColor: ColorResource.lightDarkColor,
                title: Text(
                  selectedData == null
                      ? widget.isLoading
                          ? "Loading..."
                          : "Select"
                      : selectedData?.optionName ?? "",
                  style: StyleResource.instance
                      .styleRegular(fontSize: DimensionResource.fontSizeSmall)
                      .copyWith(color: ColorResource.lightDarkColor),
                ),
                children: <Widget>[
                  ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: listOfData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(bottom: 6.0),
                        child: ViewItem(
                            item: listOfData[index],
                            selected: (val) {
                              //selectedText = val;
                              if (selectedData?.id == null
                                  ? false
                                  : selectedData!.id == val.id) {
                                selectedData = null;
                              } else {
                                selectedData = val;
                              }
                              widget.selectedList(val);
                              setState(() {});
                            },



                            //aa//
                            itemSelected: selectedData?.id == null
                                ? false
                                : selectedData!.id ==
                                    widget.listOfData[index].id),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(
          height: DimensionResource.marginSizeExtraSmall - 2,
        ),
      ],
    );
  }

  buildSelectedWrap(DropDownData? selectedService,
      {required Function(int) onClear}) {
    return Padding(
      padding: EdgeInsets.only(
          bottom:
              selectedService == null ? 0 : DimensionResource.marginSizeSmall),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 8.0,
        runSpacing: 4.0,
        children: List.generate(selectedService == null ? 0 : 1, (int index) {
          return IntrinsicWidth(
            child: GestureDetector(
              onTap: () {
                onClear(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorResource.secondaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Text(
                    selectedService?.displayName ??
                        selectedService?.optionName ??
                        "",
                    style: StyleResource.instance.styleRegular().copyWith(
                        fontSize: DimensionResource.fontSizeExtraSmall,
                        color: ColorResource.white),
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class CustomLabeledDropDown extends StatefulWidget {
  final String title;
  final bool isLoading;
  final List<DropDownData> listOfData;
  final List<DropDownData> listOfSelectedData;
  final Function(DropDownData) selectedList;

  const CustomLabeledDropDown({
    Key? key,
    required this.title,
    required this.isLoading,
    required this.listOfData,
    required this.listOfSelectedData,
    required this.selectedList,
  }) : super(key: key);

  @override
  State<CustomLabeledDropDown> createState() => _CustomLabeledDropDownState();
}

class _CustomLabeledDropDownState extends State<CustomLabeledDropDown> {
  List<DropDownData> listOfData = [];
  List<DropDownData> listOfSelectedData = [];

  @override
  void initState() {
    listOfData = widget.listOfData;
    if (widget.listOfSelectedData.isNotEmpty) {
      listOfSelectedData.addAll(widget.listOfSelectedData);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.title,
          style: StyleResource.instance
              .styleMedium(fontSize: DimensionResource.fontSizeDefault - 0.5),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            buildSelectedWrap(listOfSelectedData, onClear: (index) {
              widget.selectedList(listOfSelectedData.elementAt(index));
              setState(() {
                listOfSelectedData.removeAt(index);
              });
            }),
            Container(
              margin: const EdgeInsets.only(bottom: 8),
              // height: 45,
              decoration: decoration(
                  containerColor: Colors.transparent,
                  borderColor: ColorResource.borderColor,
                  radius: 11,
                  width: 0.5),
              child: CustomExpansionTile(
                iconColor: ColorResource.lightDarkColor,
                title: Text(
                  listOfSelectedData.isEmpty
                      ? widget.isLoading
                          ? "Loading..."
                          : "Select"
                      : listOfSelectedData.map((e) => e.optionName).join(',') ??
                          "",
                  style: StyleResource.instance
                      .styleRegular(fontSize: DimensionResource.fontSizeSmall)
                      .copyWith(color: ColorResource.lightDarkColor),
                ),
                children: <Widget>[
                  ListView.builder(
                    physics: const ClampingScrollPhysics(),
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: listOfData.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin: const EdgeInsets.only(top: 6.0),
                        child: ViewItem(
                            item: listOfData[index],
                            selected: (val) {
                              //selectedText = val;
                              if (listOfSelectedData
                                  .any((element) => element.id == val.id)) {
                                listOfSelectedData.removeWhere(
                                    (element) => element.id == val.id);
                              } else {
                                listOfSelectedData.add(val);
                              }
                              widget.selectedList(val);
                              setState(() {});
                            },
                            itemSelected: listOfSelectedData.any((element) =>
                                element.id == widget.listOfData[index].id)),
                      );
                    },
                  ),
                  const SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
            // widget.errorText == ""
            //     ? const SizedBox(
            //   height: 10,
            // )
            //     : Padding(
            //   padding: const EdgeInsets.only(
            //       left: 0, right: 15, top: 0, bottom: 8),
            //   child: Text(
            //     widget.errorText,
            //     style: StyleResource.instance.styleRegular().copyWith(
            //       fontSize: DimensionResource.fontSizeExtraSmall,
            //       color: ColorResource.redColor,
            //     ),
            //     textAlign: TextAlign.start,
            //   ),
            // ),
          ],
        ),
        // CustomMultiselectDropDown(selectedList: selectedList, listOFStrings: listOFStrings, listOFSStrings: listOFSStrings, errorText: "",isLoading: isLoading,),
        // const SizedBox(
        //   height: DimensionResource.marginSizeExtraSmall - 2,
        // ),
      ],
    );
  }

  buildSelectedWrap(List<DropDownData> selectedService,
      {required Function(int) onClear}) {
    return Padding(
      padding: EdgeInsets.only(
          bottom:
              selectedService.isEmpty ? 0 : DimensionResource.marginSizeSmall),
      child: Wrap(
        direction: Axis.horizontal,
        alignment: WrapAlignment.start,
        crossAxisAlignment: WrapCrossAlignment.start,
        spacing: 8.0,
        runSpacing: 4.0,
        children: List.generate(selectedService.length, (int index) {
          return IntrinsicWidth(
            child: GestureDetector(
              onTap: () {
                onClear(index);
              },
              child: Container(
                decoration: BoxDecoration(
                  color: ColorResource.secondaryColor,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Row(
                    children: [
                      Text(
                        selectedService[index].optionName ??
                            selectedService[index].displayName ??
                            "",
                        style: StyleResource.instance.styleRegular().copyWith(
                            fontSize: DimensionResource.fontSizeExtraSmall,
                            color: ColorResource.white),
                      ),
                      const SizedBox(
                        width: 2,
                      ),
                      Container(
                        decoration: const BoxDecoration(
                            color: ColorResource.secondaryColor,
                            shape: BoxShape.circle),
                        padding: const EdgeInsets.all(0),
                        child: const Icon(
                          Icons.clear,
                          color: ColorResource.white,
                          size: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}

class DropDownData {
  final String? optionName;
  final String? id;
  final String? displayName;

  DropDownData({this.optionName, this.id, this.displayName});
}
