import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/icon_button.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/text_field_view/regex/regex.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'dart:math' as math;
import '../../../../model/models/dashboard/dashboard_model.dart' as dash;
import '../../../../model/utils/color_resource.dart';
import '../../../../view_model/controllers/root_view_controller/course_detail_controller/course_detail_controller.dart';
import '../../../../view_model/controllers/root_view_controller/dashboard_controller/dashboard_controller.dart';
import '../../../../enum/routing/routes/app_pages.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';
import '../../base_view/base_view_screen.dart';
import '../home_view/home_view_screen.dart';

class DashBoardView extends GetView<DashboardController> {
  const DashBoardView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.secondaryColor,
      appBar: PreferredSize(
        preferredSize: const Size(double.infinity, 45),
        child: Container(
          margin: EdgeInsets.zero,
          color: ColorResource.secondaryColor,
          padding: const EdgeInsets.only(
              left: DimensionResource.marginSizeDefault,
              right: DimensionResource.marginSizeDefault,
              top: DimensionResource.marginSizeDefault + 3),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                  onTap: () {
                    Get.back();
                  },
                  child: const SizedBox(
                      height: 25,
                      width: 25,
                      child: Center(
                          child: Icon(
                        Icons.arrow_back_ios,
                        color: ColorResource.white,
                        size: 20,
                      )))),
              const Expanded(
                  child: TitleBarCentered(
                titleText: StringResource.dashboard,
              )),
              ActionCustomButton(
                onTap: () {
                  Get.toNamed(Routes.notificationView);
                },
                iconSize: 20,
                isLeft: false,
                icon: ImageResource.instance.notificationIcon,
              ),
            ],
          ),
        ),
      ),
      body: Obx(() {
        return controller.isDataLoading.value
            ? const SizedBox(
                height: 500,
                child: CommonCircularIndicator(),
              )
            : ListView(
                shrinkWrap: true,
                //crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    child: UserGreetingWidget(
                      title: "${StringResource.hello},",
                      titleFontSize: DimensionResource.fontSizeLarge - 2,
                      subTitleFontSize:
                          DimensionResource.fontSizeExtraLarge - 2,
                    ),
                  ),
                  Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    color: ColorResource.mateBlack,
                    margin: const EdgeInsets.only(
                      top: DimensionResource.marginSizeDefault,
                      left: DimensionResource.marginSizeDefault,
                      right: DimensionResource.marginSizeDefault,
                    ),
                    elevation: 5,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensionResource.marginSizeSmall,
                          vertical: DimensionResource.marginSizeSmall),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                StringResource.totalUp,
                                style: StyleResource.instance.styleSemiBold(
                                    fontSize:
                                        DimensionResource.fontSizeSmall - 2,
                                    color: ColorResource.primaryColor),
                              ),
                              InkWell(
                                onTap: controller.onRedeemNow,
                                splashColor: ColorResource.transparent,
                                child: Text(
                                  StringResource.redeemNow,
                                  style: StyleResource.instance.styleSemiBold(
                                      fontSize:
                                          DimensionResource.fontSizeSmall - 2,
                                      color: ColorResource.mateGreenColor),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(
                            height: DimensionResource.marginSizeExtraSmall,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                StringResource.credits,
                                style: StyleResource.instance.styleMedium(
                                    fontSize:
                                        DimensionResource.fontSizeExtraLarge -
                                            2,
                                    color: ColorResource.white),
                              ),
                              InkWell(
                                onTap: controller.onRedeemNow,
                                splashColor: ColorResource.transparent,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      ImageResource.instance.coinsIcon,
                                      height: 13,
                                    ),
                                    const SizedBox(
                                      width:
                                          DimensionResource.marginSizeSmall - 3,
                                    ),
                                    Obx(() {
                                      return Text(
                                        controller.dashboardData.value.data
                                                ?.totalPoints
                                                .toString() ??
                                            "0",
                                        style: StyleResource.instance
                                            .styleSemiBold(
                                                fontSize: DimensionResource
                                                        .fontSizeDoubleExtraLarge -
                                                    2,
                                                color:
                                                    ColorResource.yellowColor),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Obx(() {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensionResource.marginSizeDefault),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          statusCardWidget(
                              onTap: () {
                                Get.toNamed(Routes.homeSeeAllView, arguments: [
                                  StringResource.videoCourses,
                                  CourseDetailViewType.videoCourse
                                ]);
                              },
                              courseType: "Video Courses\nCompleted",
                              score: controller.dashboardData.value.data
                                      ?.totalVideoCourse
                                      .toString() ??
                                  "0"),
                          const SizedBox(
                            width: DimensionResource.marginSizeSmall - 1,
                          ),
                          statusCardWidget(
                              onTap: () {
                                Get.toNamed(Routes.homeSeeAllView, arguments: [
                                  StringResource.audioCourses,
                                  CourseDetailViewType.audioCourse
                                ]);
                              },
                              courseType: "Audio Courses\nCompleted",
                              score: controller.dashboardData.value.data
                                      ?.totalAudioCourse
                                      .toString() ??
                                  "0"),
                          const SizedBox(
                            width: DimensionResource.marginSizeSmall - 1,
                          ),
                          statusCardWidget(
                              onTap: () {
                                Get.toNamed(Routes.homeSeeAllView, arguments: [
                                  StringResource.textCourses,
                                  CourseDetailViewType.textCourse
                                ]);
                              },
                              enableRightPadding: false,
                              courseType: "Text Courses\nCompleted",
                              score: controller
                                      .dashboardData.value.data?.totalTextCourse
                                      .toString() ??
                                  "0"),
                        ],
                      ),
                    );
                  }),
                  const SizedBox(
                    height: DimensionResource.marginSizeDefault,
                  ),
                  dashBoardTitle(text: StringResource.achievment),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      //mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: List.generate(
                          controller.dashboardData.value.data?.badge?.length ??
                              0, (index) {
                        dash.Badge data = controller
                            .dashboardData.value.data!.badge!
                            .elementAt(index);
                        logPrint("jhbhjb ${data.icon}");
                        return Padding(
                            padding: EdgeInsets.only(
                                right: DimensionResource.marginSizeSmall - 1,
                                left: index == 0
                                    ? DimensionResource.marginSizeDefault
                                    : 0),
                            child: achievementCardWidget(data: data));
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeDefault,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    child: Row(
                      children: [
                        quizScoreWidget(
                            color: ColorResource.primaryColor,
                            child: InkWell(
                              onTap: () {
                                Get.toNamed(Routes.quizzesView);
                              },
                              splashColor: ColorResource.white,
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal:
                                            DimensionResource.marginSizeSmall),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Text(
                                          StringResource.attendedQuiz,
                                          style: StyleResource.instance
                                              .styleSemiBold(
                                                  fontSize: DimensionResource
                                                      .fontSizeSmall,
                                                  color: ColorResource.white),
                                        )),
                                        CircleAvatar(
                                          backgroundColor: ColorResource.white,
                                          child: Text(
                                              (controller
                                                          .dashboardData
                                                          .value
                                                          .data
                                                          ?.totalAttendedQuiz ??
                                                      0)
                                                  .toString(),
                                              style: StyleResource.instance
                                                  .styleSemiBold(
                                                      color: ColorResource
                                                          .primaryColor,
                                                      fontSize:
                                                          DimensionResource
                                                              .fontSizeLarge)),
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(
                                    height: DimensionResource.marginSizeSmall,
                                  ),
                                  SizedBox(
                                      width: double.infinity,
                                      height: 5,
                                      child: LinearPercentIndicator(
                                        animation: true,
                                        barRadius: const Radius.circular(10),
                                        animationDuration: 1000,
                                        lineHeight: 5.0,
                                        percent: (controller
                                                        .dashboardData
                                                        .value
                                                        .data
                                                        ?.totalAttendedQuiz ??
                                                    0) ==
                                                0
                                            ? 0
                                            : 0.6,
                                        linearStrokeCap: LinearStrokeCap.butt,
                                        progressColor: ColorResource.white,
                                        backgroundColor: ColorResource.white
                                            .withOpacity(0.2),
                                      ))
                                ],
                              ),
                            )),
                        const SizedBox(
                          width: DimensionResource.marginSizeSmall,
                        ),
                        quizScoreWidget(
                          color: ColorResource.mateGreenColor,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: DimensionResource.marginSizeSmall),
                            child: Row(
                              children: [
                                Expanded(
                                    child: Text(
                                  StringResource.avgQuiz,
                                  style: StyleResource.instance.styleSemiBold(
                                    color: ColorResource.white,
                                    fontSize: DimensionResource.fontSizeSmall,
                                  ),
                                )),
                                SizedBox(
                                  height: 55,
                                  child: CircularPercentIndicator(
                                    radius: 24.0,
                                    lineWidth: 8.0,
                                    animation: true,
                                    percent: ((controller.dashboardData.value
                                                .data?.totalQuizScore ??
                                            0) /
                                        100),
                                    center: Text(
                                      "${controller.dashboardData.value.data?.totalQuizScore ?? 0}%",
                                      style: StyleResource.instance.styleMedium(
                                          color: ColorResource.white,
                                          fontSize: DimensionResource
                                                  .fontSizeExtraSmall -
                                              2),
                                    ),
                                    circularStrokeCap: CircularStrokeCap.round,
                                    progressColor: ColorResource.white,
                                    backgroundColor:
                                        ColorResource.white.withOpacity(0.4),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeDefault,
                  ),
                  Visibility(
                      visible: controller.dateList.isNotEmpty,
                      child: dashBoardTitle(text: StringResource.streaks)),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children:
                          List.generate(controller.dateList.length, (index) {
                        DateTime date = controller.dateList.elementAt(index);
                        bool isPresent = controller
                                .userHistoryModel.value.data?.userAverageTime
                                ?.any((element) =>
                                    (element.date?.toIso8601String() ==
                                        date.toIso8601String()) &&
                                    element.avgTime != "0") ??
                            false;
                        return Padding(
                          padding: EdgeInsets.only(
                              left: index == 0
                                  ? DimensionResource.marginSizeDefault
                                  : 0.0,
                              right: index == (controller.dateList.length - 1)
                                  ? DimensionResource.marginSizeDefault
                                  : 0.0),
                          child: streakContainer(isPresent, date,
                              index == (controller.dateList.length - 1)),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeDefault,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: ColorResource.mateBlack,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    child: Obx(() {
                      return Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: DimensionResource.marginSizeSmall,
                                vertical:
                                    DimensionResource.marginSizeExtraSmall),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  StringResource.setGoal,
                                  style: StyleResource.instance.styleSemiBold(
                                      color:
                                          ColorResource.white.withOpacity(0.7)),
                                ),
                                // Visibility(
                                //   visible: controller.newGoalList.isNotEmpty,
                                //   child: InkWell(
                                //     onTap: () {
                                //       controller.isAddActive.value = !controller.isAddActive.value;
                                //     },
                                //     child: Container(
                                //       height: 35,
                                //       width: 35,
                                //       decoration: BoxDecoration(
                                //           color: ColorResource.primaryColor,
                                //           borderRadius: BorderRadius.circular(8)),
                                //       child: Center(
                                //           child: Image.asset(
                                //         controller.isAddActive.value
                                //             ? ImageResource.instance.closeIcon
                                //             : ImageResource.instance.addIcon,
                                //         height: 12,
                                //         color: ColorResource.white,
                                //       )),
                                //     ),
                                //   ),
                                // )
                              ],
                            ),
                          ),
                          controller.newGoalList.isNotEmpty &&
                                  !controller.isAddActive.value
                              ? Divider(
                                  color: ColorResource.white.withOpacity(0.65),
                                )
                              : const SizedBox(),
                          controller.newGoalList.isEmpty ||
                                  controller.isAddActive.value
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          DimensionResource.marginSizeSmall,
                                      vertical:
                                          DimensionResource.marginSizeSmall),
                                  child: Container(
                                    height: 45,
                                    clipBehavior: Clip.antiAliasWithSaveLayer,
                                    padding: EdgeInsets.zero,
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(12),
                                        border: Border.all(
                                          color: ColorResource.borderColor
                                              .withOpacity(0.3),
                                          width: 0.6,
                                        )),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            flex: 2,
                                            child: Container(
                                              decoration: const BoxDecoration(
                                                color:
                                                    ColorResource.primaryColor,
                                              ),
                                              child: Center(
                                                  child: Text(
                                                StringResource.minutes,
                                                style: StyleResource.instance
                                                    .styleSemiBold(
                                                        color:
                                                            ColorResource.white,
                                                        fontSize:
                                                            DimensionResource
                                                                .fontSizeSmall),
                                              )),
                                            )),
                                        Expanded(
                                            flex: 6,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: DimensionResource
                                                    .marginSizeSmall,
                                              ),
                                              child: Row(
                                                children: [
                                                  Expanded(
                                                    child: Form(
                                                      key: controller.formKey,
                                                      child: TextFormField(
                                                        maxLength: 5,
                                                        inputFormatters: [
                                                          FilteringTextInputFormatter
                                                              .allow(RegExp(
                                                                  "[0-9]")),
                                                        ],
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        textInputAction:
                                                            TextInputAction
                                                                .done,
                                                        validator: (val) {
                                                          if (val?.isEmpty ??
                                                              true) {
                                                            toastShow(
                                                                message:
                                                                    StringResource
                                                                        .pleaseEnterMinute);
                                                            return "";
                                                          } else if (!val
                                                              .toString()
                                                              .isNumeric()) {
                                                            toastShow(
                                                                message:
                                                                    StringResource
                                                                        .enterCorrectMinute);
                                                            return "";
                                                          } else if ((int.tryParse(
                                                                      val.toString()) ??
                                                                  0) <
                                                              0) {
                                                            toastShow(
                                                                message:
                                                                    StringResource
                                                                        .enterCorrectMinute);
                                                            return "";
                                                          } else {
                                                            return null;
                                                          }
                                                        },
                                                        cursorColor:
                                                            ColorResource
                                                                .borderColor
                                                                .withOpacity(
                                                                    0.3),
                                                        controller: controller
                                                            .goalController,
                                                        style: StyleResource
                                                            .instance
                                                            .styleRegular(
                                                                color:
                                                                    ColorResource
                                                                        .white,
                                                                fontSize:
                                                                    DimensionResource
                                                                        .fontSizeSmall),
                                                        decoration:
                                                            InputDecoration(
                                                                counterText: "",
                                                                errorText: null,
                                                                errorStyle:
                                                                    const TextStyle(
                                                                  height: 0,
                                                                ),
                                                                border:
                                                                    InputBorder
                                                                        .none,
                                                                hintText:
                                                                    StringResource
                                                                        .enterMin,
                                                                hintStyle: StyleResource.instance.styleRegular(
                                                                    color: ColorResource
                                                                        .borderColor
                                                                        .withOpacity(
                                                                            0.3),
                                                                    fontSize:
                                                                        DimensionResource
                                                                            .fontSizeSmall)),
                                                      ),
                                                    ),
                                                  ),
                                                  controller.isAddGoalLoading
                                                          .value
                                                      ? const SizedBox(
                                                          height: 17,
                                                          width: 17,
                                                          child:
                                                              CommonCircularIndicator(),
                                                        )
                                                      : InkWell(
                                                          onTap: controller
                                                              .onAddNewGoal,
                                                          child: Text(
                                                            StringResource.add,
                                                            style: StyleResource
                                                                .instance
                                                                .styleSemiBold(
                                                                    color: ColorResource
                                                                        .primaryColor,
                                                                    fontSize:
                                                                        DimensionResource.fontSizeSmall -
                                                                            1),
                                                          ))
                                                ],
                                              ),
                                            ))
                                      ],
                                    ),
                                  ),
                                )
                              : const SizedBox(),
                          controller.newGoalList.isNotEmpty &&
                                  !controller.isAddActive.value
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal:
                                          DimensionResource.marginSizeSmall,
                                      vertical: DimensionResource
                                          .marginSizeExtraSmall),
                                  child: Column(
                                    children: List.generate(
                                        controller.newGoalList.length, (index) {
                                      String data = controller.newGoalList
                                          .elementAt(index);
                                      return Padding(
                                        padding: const EdgeInsets.only(
                                            bottom: DimensionResource
                                                .marginSizeSmall),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              data,
                                              style: StyleResource.instance
                                                  .styleSemiBold(
                                                      color: ColorResource
                                                          .mateGreenColor),
                                            ),
                                            controller.isAddGoalLoading.value
                                                ? const SizedBox(
                                                    height: 17,
                                                    width: 17,
                                                    child:
                                                        CommonCircularIndicator(),
                                                  )
                                                : InkWell(
                                                    onTap: () {
                                                      ProgressDialog()
                                                          .showConfirmFlipDialog(
                                                              title:
                                                                  "Do you want to delete\nyour Goal?",
                                                              onConfirm: () {
                                                                Get.back();
                                                                controller
                                                                    .onDeleteGoal(
                                                                        index);
                                                              });
                                                    },
                                                    child: Text(
                                                      StringResource.delete,
                                                      style: StyleResource
                                                          .instance
                                                          .styleSemiBold(
                                                              color: ColorResource
                                                                  .mateRedColor,
                                                              fontSize:
                                                                  DimensionResource
                                                                      .fontSizeSmall),
                                                    ),
                                                  )
                                          ],
                                        ),
                                      );
                                    }),
                                  ),
                                )
                              : const SizedBox()
                        ],
                      );
                    }),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeDefault,
                  ),
                  dashBoardTitle(text: StringResource.userAvgTime),
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall,
                  ),
                  Container(
                    height: 300,
                    //width:300,
                    decoration: BoxDecoration(
                      color: ColorResource.mateBlack,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    margin: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeSmall,
                        vertical: DimensionResource.marginSizeSmall + 5),
                    child: BarChart(
                      BarChartData(
                        //maxY: 450,
                        barTouchData: BarTouchData(
                          touchTooltipData: BarTouchTooltipData(
                            tooltipBgColor: Colors.grey,
                            getTooltipItem: (a, b, c, d) => null,
                          ),
                          touchCallback: (FlTouchEvent event, response) {
                            if (response == null || response.spot == null) {
                              controller.touchedGroupIndex.value = -1;
                              controller.showingBarGroups =
                                  List.of(controller.rawBarGroups);
                              return;
                            }
                            controller.touchedGroupIndex.value =
                                response.spot!.touchedBarGroupIndex;
                            if (!event.isInterestedForInteractions) {
                              controller.touchedGroupIndex.value = -1;
                              controller.showingBarGroups =
                                  List.of(controller.rawBarGroups);
                              return;
                            }
                            controller.showingBarGroups =
                                List.of(controller.rawBarGroups);
                            if (controller.touchedGroupIndex.value != -1) {
                              var sum = 0.0;
                              for (final rod in controller
                                  .showingBarGroups[
                                      controller.touchedGroupIndex.value]
                                  .barRods) {
                                sum += rod.toY;
                              }
                              final avg = sum /
                                  controller
                                      .showingBarGroups[
                                          controller.touchedGroupIndex.value]
                                      .barRods
                                      .length;

                              controller.showingBarGroups[controller
                                  .touchedGroupIndex
                                  .value] = controller.showingBarGroups[
                                      controller.touchedGroupIndex.value]
                                  .copyWith(
                                barRods: controller
                                    .showingBarGroups[
                                        controller.touchedGroupIndex.value]
                                    .barRods
                                    .map((rod) {
                                  return rod.copyWith(
                                      toY: avg, color: Colors.red);
                                }).toList(),
                              );
                            }
                          },
                        ),
                        titlesData: FlTitlesData(
                          show: true,
                          rightTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          topTitles: AxisTitles(
                            sideTitles: SideTitles(showTitles: false),
                          ),
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: bottomTitles,
                              reservedSize: 42,
                            ),
                          ),
                          leftTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              reservedSize: 20,
                              interval: controller.graphInterval.value,
                              getTitlesWidget: leftTitles,
                            ),
                          ),
                        ),
                        borderData: FlBorderData(
                            show: true,
                            border: Border(
                                left: BorderSide(
                                    color: ColorResource.white.withOpacity(0.2),
                                    width: 2.4))),
                        barGroups: controller.showingBarGroups,
                        gridData: FlGridData(
                            show: true,
                            drawVerticalLine: false,
                            horizontalInterval: controller.graphInterval.value),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeLarge,
                  ),
                ],
              );
      }),
    );
  }

//   Widget chartToRun() {
//     LabelLayoutStrategy? xContainerLabelLayoutStrategy;
//     ChartData chartData;
//     List<double> rowData = controller.userHistoryModel.value.data?.userAverageTime?.map((e) => e.avgTime == null ?0.0: double.parse(e.avgTime??"0.0")).toList()??[];
//     final List<String> titles =  controller.dateList.map((element) => DateFormat("dd\nMMM").format(element)).toList();
// logPrint("rowData  $rowData  ${rowData.length}");
// logPrint("titles  $titles  ${titles.length}");
// titles.removeAt(0);
//     ChartOptions chartOptions = const ChartOptions(
//       iterativeLayoutOptions: IterativeLayoutOptions(
//         maxLabelReLayouts: 2
//       ),
//       legendOptions: LegendOptions(
//           isLegendContainerShown: false
//       ),
//       verticalBarChartOptions: VerticalBarChartOptions(
//
//       ),
//       labelCommonOptions: LabelCommonOptions(
//         labelTextScaleFactor: 0.55
//       ),
//       xContainerOptions: XContainerOptions(
//         xLabelsPadTB: 5,
//           xLabelsPadLR: 5
//       ),
//       yContainerOptions: YContainerOptions(
//         yLeftMinTicksWidth: 3,
//           isYGridlinesShown:false,
//         yLabelsPadTB: 10
//       ),
//       dataContainerOptions: DataContainerOptions(
//
//       ),
//       lineChartOptions: LineChartOptions(
//         hotspotInnerPaintColor: ColorResource.primaryColor,
//           hotspotOuterPaintColor: ColorResource.primaryColor
//       )
//     );
//     chartData = ChartData(
//       dataRows:  [
//         rowData
//       ],
//       xUserLabels: titles,
//       dataRowsLegends: const [
//         "ds"
//       ],
//       dataRowsColors: const [
//         ColorResource.primaryColor
//       ],
//       chartOptions: chartOptions,
//     );
//    // exampleSideEffects = _ExampleSideEffects()..leftSqueezeText=''.. rightSqueezeText='';
//     var verticalBarChartContainer = VerticalBarChartTopContainer(
//       chartData: chartData,
//       xContainerLabelLayoutStrategy: xContainerLabelLayoutStrategy,
//     );
//
//     var verticalBarChart = VerticalBarChart(
//       painter: VerticalBarChartPainter(
//         verticalBarChartContainer: verticalBarChartContainer,
//       ),
//     );
//     return verticalBarChart;
//   }

  Widget leftTitles(double value, TitleMeta meta) {
    TextStyle style = StyleResource.instance.styleRegular(
        fontSize: DimensionResource.fontSizeExtraSmall - 3,
        color: ColorResource.borderColor.withOpacity(0.4));

    String text =
        "${(meta.formattedValue).toString()}${meta.formattedValue == "0" ? "\nmin" : ""}";

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 0,
      child: Padding(
        padding: const EdgeInsets.only(right: 4.0),
        child: Text(text, style: style),
      ),
    );
  }

  Widget bottomTitles(double value, TitleMeta meta) {
    final List<String> titles = controller.dateList
        .map((element) => DateFormat("dd\nMMM").format(element))
        .toList();
    logPrint("user average time index $value");
    final Widget text = Text(
      titles[value.toInt()],
      style: StyleResource.instance.styleRegular(
          fontSize: DimensionResource.fontSizeExtraSmall - 2,
          color: ColorResource.borderColor.withOpacity(0.4)),
      textAlign: TextAlign.center,
    );
    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 16, //margin top
      child: text,
    );
  }

  Widget streakContainer(bool isPresent, DateTime date, bool isLast) {
    List<String> day = DateFormat("EEE,dd,MMM").format(date).split(",");
    return Card(
      elevation: isPresent ? 5 : 0,
      color: date.isAfter(DateTime.now())
          ? ColorResource.mateBlack
          : isPresent
              ? ColorResource.primaryColor
              : ColorResource.mateRedColor,
      margin: EdgeInsets.only(
          right: isLast ? 0 : DimensionResource.marginSizeSmall,
          top: DimensionResource.marginSizeSmall,
          bottom: DimensionResource.marginSizeSmall),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      child: Padding(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeSmall + 3,
            vertical: DimensionResource.marginSizeSmall + 3),
        child: Column(
          children: [
            Text(
              day[0],
              style: StyleResource.instance.styleSemiBold(
                  fontSize: DimensionResource.fontSizeSmall,
                  color: date.isAfter(DateTime.now())
                      ? ColorResource.white.withOpacity(0.2)
                      : ColorResource.white.withOpacity(0.4)),
            ),
            const SizedBox(
              height: DimensionResource.marginSizeExtraSmall,
            ),
            Text(
              day[1],
              style: StyleResource.instance.styleRegular(
                  fontSize: DimensionResource.fontSizeDefault,
                  color: date.isAfter(DateTime.now())
                      ? ColorResource.white.withOpacity(0.4)
                      : isPresent
                          ? ColorResource.white
                          : ColorResource.white.withOpacity(0.7)),
            ),
            const SizedBox(
              height: DimensionResource.marginSizeExtraSmall,
            ),
            Text(
              day[2],
              style: StyleResource.instance.styleSemiBold(
                  fontSize: DimensionResource.fontSizeSmall,
                  color: date.isAfter(DateTime.now())
                      ? ColorResource.white.withOpacity(0.2)
                      : ColorResource.white.withOpacity(0.4)),
            ),
          ],
        ),
      ),
    );
  }

  Widget dashBoardTitle({required String text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault),
      child: Text(
        text,
        style: StyleResource.instance.styleRegular(
            fontSize: DimensionResource.fontSizeLarge - 2,
            color: ColorResource.white),
      ),
    );
  }

  Widget statusCardWidget(
      {bool enableRightPadding = true,
      required String score,
      required Function() onTap,
      required String courseType}) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: ColorResource.mateBlack,
          margin: const EdgeInsets.only(
            top: DimensionResource.marginSizeDefault,
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeExtraSmall + 1,
                vertical: DimensionResource.marginSizeSmall - 3),
            child: Column(
              children: [
                Text(
                  score,
                  style: StyleResource.instance.styleSemiBold(
                      fontSize: DimensionResource.fontSizeOverLarge,
                      color: ColorResource.primaryColor),
                ),
                const SizedBox(
                  height: DimensionResource.marginSizeSmall,
                ),
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: ColorResource.primaryColor),
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.marginSizeExtraSmall,
                      vertical: DimensionResource.marginSizeSmall),
                  child: Text(
                    courseType,
                    style: StyleResource.instance.styleRegular(
                        fontSize: DimensionResource.fontSizeSmall - 1,
                        color: ColorResource.white),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget achievementCardWidget(
      {bool enableRightPadding = true, required dash.Badge data}) {
    logPrint("data.icon ${data.icon}");
    return SizedBox(
      height: 100,
      width: 107,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: data.color,
        margin: const EdgeInsets.only(
          top: DimensionResource.marginSizeSmall,
        ),
        elevation: 5,
        child: Stack(
          children: [
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: DimensionResource.marginSizeDefault + 2,
                    vertical: DimensionResource.marginSizeDefault - 8),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                        height: 40,
                        child: cachedNetworkImage(data.icon ?? "",
                            fit: BoxFit.cover)),
                    const SizedBox(
                      height: DimensionResource.marginSizeDefault - 4,
                    ),
                    Text(
                      data.title ?? "",
                      style: StyleResource.instance.styleMedium(
                          fontSize: DimensionResource.fontSizeDefault - 1,
                          color: ColorResource.white),
                      textAlign: TextAlign.center,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: int.parse(data.target.toString()) >
                  int.parse(controller
                          .dashboardData.value.data?.totalCourseComplete
                          .toString() ??
                      "0"),
              child: Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 100,
                  width: 107,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  decoration: BoxDecoration(
                    color: ColorResource.black.withOpacity(0.65),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: DimensionResource.marginSizeSmall,
                      ),
                      SizedBox(
                        height: 40,
                        child: CircularPercentIndicator(
                          radius: 20.0,
                          lineWidth: 4.0,
                          animation: true,
                          percent: (int.parse(controller.dashboardData.value
                                              .data?.totalCourseComplete
                                              .toString() ??
                                          "0") /
                                      int.parse(data.target.toString())) >=
                                  1
                              ? 1
                              : (int.parse(controller.dashboardData.value.data
                                          ?.totalCourseComplete
                                          .toString() ??
                                      "0") /
                                  int.parse(data.target.toString())),
                          center: Text(
                            ("${int.parse(controller.dashboardData.value.data?.totalCourseComplete.toString() ?? "0")}/${int.parse(data.target.toString())}"),
                            style: StyleResource.instance.styleMedium(
                                color: ColorResource.white,
                                fontSize: DimensionResource.fontSizeExtraSmall),
                          ),
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: ColorResource.accentYellowColor,
                          backgroundColor: ColorResource.whiteYellowColor,
                        ),
                      ),
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal:
                                  DimensionResource.marginSizeExtraSmall),
                          child: Text(
                            StringResource.courseComplete,
                            style: StyleResource.instance.styleSemiBold(
                                fontSize:
                                    DimensionResource.fontSizeExtraSmall - 2,
                                color: ColorResource.white),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: DimensionResource.marginSizeSmall - 4,
                      )
                    ],
                  ),
                ),
              ),
            ),
            Visibility(
              visible: int.parse(data.target.toString()) >
                  int.parse(controller
                          .dashboardData.value.data?.totalCourseComplete
                          .toString() ??
                      "0"),
              child: SizedBox(
                height: 55,
                child: Stack(
                  children: [
                    Transform.rotate(
                        angle: 15.7,
                        child: Image.asset(
                          ImageResource.instance.triangle,
                          color: data.color,
                          height: 55,
                        )),
                    Padding(
                      padding: const EdgeInsets.all(5.0),
                      child: SizedBox(
                          height: 15,
                          child: cachedNetworkImage(data.icon ?? "",
                              fit: BoxFit.cover)),
                    ),
                    SizedBox(
                      height: 50,
                      width: 50,
                      //color: Colors.red,
                      child: Transform.rotate(
                        angle: 319.65,
                        child: Container(
                          margin: const EdgeInsets.only(top: 16),
                          // color: Colors.red,
                          child: Text(
                            data.title ?? "",
                            style: StyleResource.instance.styleSemiBold(
                                fontSize:
                                    DimensionResource.fontSizeExtraSmall - 2,
                                color: ColorResource.white),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget quizScoreWidget({required Widget child, required Color color}) {
    return Expanded(
      child: SizedBox(
        height: 90,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: color,
          margin: const EdgeInsets.only(
            top: DimensionResource.marginSizeSmall,
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                vertical: DimensionResource.marginSizeSmall),
            child: child,
          ),
        ),
      ),
    );
  }
}

class CustomTriangleClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path()
      ..addRRect(RRect.fromLTRBAndCorners(0, 0, size.height, size.height,
          topRight: const Radius.circular(5)))
      ..lineTo(size.height, size.height)
      ..lineTo(0, size.height)
      ..close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) {
    return true;
  }
}

class BadgeDecoration extends Decoration {
  final Color? badgeColor;
  final double badgeSize;
  final TextSpan textSpan;

  const BadgeDecoration(
      {required this.badgeColor,
      required this.badgeSize,
      required this.textSpan});

  @override
  BoxPainter createBoxPainter([Function()? onChanged]) =>
      _BadgePainter(badgeColor, badgeSize, textSpan);
}

class _BadgePainter extends BoxPainter {
  static const double baseLineShift = 1;
  static const double cornerRadius = 12;
  final Color? badgeColor;
  final double badgeSize;
  final TextSpan textSpan;

  _BadgePainter(this.badgeColor, this.badgeSize, this.textSpan);

  @override
  void paint(Canvas canvas, Offset offset, ImageConfiguration configuration) {
    canvas.save();
    canvas.translate(
        offset.dx + (configuration.size?.width ?? 0) - badgeSize, offset.dy);
    canvas.drawPath(buildBadgePath(), getBadgePaint());
    // draw text
    final hyp = math.sqrt(badgeSize * badgeSize + badgeSize * badgeSize);
    final textPainter = TextPainter(
        text: textSpan,
        // textDirection: TextDirection.,
        textAlign: TextAlign.center);
    textPainter.layout(minWidth: hyp, maxWidth: hyp);
    final halfHeight = textPainter.size.height / 2;
    final v = math.sqrt(halfHeight * halfHeight + halfHeight * halfHeight) +
        baseLineShift;
    canvas.translate(v, -v);
    canvas.rotate(0.785398); // 45 degrees
    textPainter.paint(canvas, Offset.zero);
    canvas.restore();
  }

  Paint getBadgePaint() => Paint()
    ..isAntiAlias = true
    ..color = badgeColor ?? Colors.white;

  Path buildBadgePath() => Path.combine(
      PathOperation.difference,
      Path()
        ..addRRect(RRect.fromLTRBAndCorners(0, 0, badgeSize, badgeSize,
            topRight: const Radius.circular(cornerRadius))),
      Path()
        ..lineTo(badgeSize, badgeSize)
        ..lineTo(0, badgeSize)
        ..close());
}
