import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:glowy_borders/glowy_borders.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stockpathshala_beta/mentroship/controller/mentorship_controller.dart';
import 'package:stockpathshala_beta/mentroship/view/mentorship_detail_screen.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/batches_filter_view/batches_filter_view.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../model/utils/color_resource.dart';
import '../../model/utils/dimensions_resource.dart';
import '../controller/mentorship_controller.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';

class MentorshipScreen extends StatefulWidget {
  const MentorshipScreen({super.key});

  @override
  State<MentorshipScreen> createState() => _MentorshipScreenState();
}

class _MentorshipScreenState extends State<MentorshipScreen> {
  final MentorshipController controller = Get.find<MentorshipController>();

  @override
  Widget build(BuildContext context) {
    var resHeight = MediaQuery.of(context).size.height;
    var resWidth = MediaQuery.of(context).size.width;
    var textScale = MediaQuery.of(context).textScaleFactor;

    double screenWidth = MediaQuery.of(context).size.width;
    print('listHeight ${controller.listHeight.value}');
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarIconBrightness: Brightness.light,
        statusBarColor: ColorResource.primaryColor,
      ),
      child: Scaffold(
        backgroundColor: hexToColor(
            controller.mentorshipData.value?.data?.screenBgColor ?? ""),
        body: Obx(() => controller.isLoading.value == true
            ? _buildShimmerEffect(context, resWidth, resHeight)
            : RefreshIndicator(
                onRefresh: () async {
                  // Logic to refresh data
                  controller.onRefresh();
                },
                child: SingleChildScrollView(
                  child: SafeArea(
                    child: Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: resWidth * 0.02),
                      child: Column(
                        children: [
                          SizedBox(height: resHeight * 0.015),
                          // centerTitle: true,
                          // title:
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Builder(
                                builder: (context) {
                                  // Get screen width using MediaQuery
                                  double screenWidth =
                                      MediaQuery.of(context).size.width;

                                  // Set font size based on screen width
                                  double fontSize = screenWidth < 500 ? 20 : 34;

                                  return Text(
                                    "${controller.mentorshipData.value?.data?.mentorListTitle}",
                                    style: TextStyle(
                                      fontSize: fontSize * textScale,
                                      fontWeight: FontWeight.w600, // bold text
                                      color: hexToColor(controller
                                              .mentorshipData
                                              .value
                                              ?.data
                                              ?.mentorListTitleColor ??
                                          ""),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),

                          SizedBox(height: resHeight * 0.015),
                          // Horizontal ListView
                          Column(
                            children: [
                              Container(
                                height: resHeight * 0.09,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: controller.mentorList.length,
                                  itemBuilder: (context, index) {
                                    final screenWidth =
                                        MediaQuery.of(context).size.width;

                                    // Define responsive width and height based on screen size
                                    final width = screenWidth < 500
                                        ? resWidth * 0.16
                                        : resWidth *
                                            0.16; // Increased width for screens > 500

                                    final height = screenWidth > 500
                                        ? resHeight * 0.16
                                        : resHeight * 0.25;
                                    return Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: resWidth * 0.05),
                                      child: Container(
                                        width: width,
                                        height: height,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          image: DecorationImage(
                                            image: NetworkImage(controller
                                                .mentorList[index].image),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: resHeight * 0.015),
                          controller.mentorshipData.value?.data
                                      ?.certification !=
                                  null
                              ? SizedBox(
                                  height: resHeight * 0.04,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: controller.mentorshipData.value
                                        ?.data?.certification.length,
                                    itemBuilder: (context, index) {
                                      final screenWidth =
                                          MediaQuery.of(context).size.width;

                                      // Define responsive padding and font size based on screen size
                                      final horizontalPadding =
                                          screenWidth < 500
                                              ? resWidth * 0.02
                                              : resWidth * 0.03;
                                      final fontSize =
                                          screenWidth < 500 ? 11.0 : 17.0;
                                      return Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: horizontalPadding),
                                        child: Row(
                                          children: [
                                            Image.asset(
                                                "assets/images/icons/check.png",
                                                width: resWidth * 0.04),
                                            SizedBox(width: resWidth * 0.01),
                                            Text(
                                              "${controller.mentorshipData.value?.data?.certification[index]}",
                                              style: TextStyle(
                                                fontSize: fontSize,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(),
                          SizedBox(height: resHeight * 0.003),

                          // running list
                          Container(
                            height: MediaQuery.of(context).size.width < 500
                                ? resHeight *
                                    0.003 // For smaller screens (<500), height is resHeight * 0.003
                                : resHeight * 0.002,
                            // For larger screens (>=500), height is resHeight * 0.002
                            width: MediaQuery.of(context).size.width < 500
                                ? resWidth *
                                    0.9 // For smaller screens (<500), width is resWidth * 0.9
                                : resWidth * 0.9,
                            color: hexToColor(controller.mentorshipData.value
                                    ?.data?.seperatorColor ??
                                ""),
                          ),

                          Row(
                            children: [
                              Expanded(
                                child: Container(
                                  margin: const EdgeInsets.only(
                                      left: 10, right: 10, top: 10, bottom: 10),
                                  child: ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(DimensionResource
                                            .borderRadiusExtraLarge)),
                                    child: ColoredBox(
                                      color: ColorResource.primaryColor
                                          .withOpacity(0.2),
                                      child: SizedBox(
                                        height: 30,
                                        child: TabBar(
                                          splashBorderRadius:
                                              const BorderRadius.all(Radius
                                                  .circular(DimensionResource
                                                      .borderRadiusExtraLarge)),
                                          dividerColor: Colors.transparent,
                                          indicator: const BoxDecoration(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(DimensionResource
                                                      .borderRadiusExtraLarge)),
                                              shape: BoxShape.rectangle,
                                              color:
                                                  ColorResource.primaryColor),
                                          labelColor: Colors.white,
                                          unselectedLabelColor: Colors.black54,
                                          indicatorSize:
                                              TabBarIndicatorSize.tab,
                                          labelStyle:
                                              const TextStyle(fontSize: 12),
                                          tabs: const [
                                            Tab(text: "Running"),
                                            Tab(text: "Upcoming"),
                                            Tab(text: "Past"),
                                          ],
                                          controller: controller.tabController,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              InkWell(
                                onTap: () {
                                  buildShowModalBottomSheet(context, Obx(() {
                                    return controller.isClearLoading.value
                                        ? const CircularProgressIndicator()
                                        : LiveFilterScreen(
                                            mentorship: true,
                                            type: controller
                                                        .tabController?.index ==
                                                    1
                                                ? 'upcoming'
                                                : 'past',
                                            indexOfTab:
                                                controller.tabController?.index,
                                            onClear: (val) {
                                              controller.listOFSelectedDuration
                                                  .clear();
                                              controller.listOFSelectedCat
                                                  .clear();
                                              controller.listOFMentorShip
                                                  .clear();
                                              controller.listOFSelectedDate
                                                  .clear();
                                              controller.listOFMentorShip
                                                  .clear();
                                              controller.isClearLoading.value =
                                                  true;
                                              controller.listofSelectedTeacher
                                                  .clear();
                                              Future.delayed(Duration.zero, () {
                                                controller.isClearLoading
                                                    .value = false;
                                              });
                                              controller.onClearFilter();
                                              Get.back();
                                            },
                                            isHideTeacher: true,
                                            isHideRating: true,
                                            isHideTime: true,
                                            isHideLevel: true,
                                            listOFSelectedLevel: const [],
                                            listOFSelectedCat:
                                                controller.listOFSelectedCat,
                                            listOFSelectedDays:
                                                controller.listOFSelectedDate,
                                            listOFMentorShip:
                                                controller.listOFMentorShip,
                                            listOFSelectedLang: const [],
                                            isPastFilter: true,
                                            onApply: (val) {
                                              controller.selectedSub.value =
                                                  val['is_free'];
                                              controller.listofSelectedTeacher
                                                  .value = val['teacher'];
                                              controller.listOFSelectedDate
                                                  .value = val['days'];
                                              controller.listOFSelectedCat
                                                  .value = val['category'];
                                              controller.listOFSelectedDuration
                                                  .value = val['duration'];
                                              controller.listOFMentorShip
                                                  .value = val['mentor'];
                                              controller.fetchData(
                                                  categoryId: controller
                                                      .listOFSelectedCat
                                                      .map((element) =>
                                                          element.id)
                                                      .toList()
                                                      .toString()
                                                      .replaceAll("[", "")
                                                      .replaceAll("]", "")
                                                      .removeAllWhitespace,
                                                  monthsFilter: controller
                                                      .listOFSelectedDate
                                                      .map((e) => e.displayName
                                                          ?.toLowerCase())
                                                      .join(','),
                                                  mentorType: controller
                                                      .listOFMentorShip
                                                      .map((e) => e.displayName)
                                                      .join(','),
                                                  type: controller.tabController
                                                              ?.index ==
                                                          0
                                                      ? 'running'
                                                      : controller.tabController
                                                                  ?.index ==
                                                              1
                                                          ? 'upcoming'
                                                          : 'past');
                                            },
                                            listOFSelectedRating: const [],
                                            listOfSelectedTeacher: const [],
                                            listOFSelectedDuration: const [],
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
                          SizedBox(
                            height: controller.listHeight.value,
                            child: TabBarView(
                                controller: controller.tabController,
                                children: [
                                  controller.isRunningLoading.value
                                      ? const Align(
                                          alignment: Alignment.topCenter,
                                          child: CircularProgressIndicator())
                                      : controller.runningList.isEmpty
                                          ? Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: const Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Text(
                                                    "New Mentorship Batches are being Set Up for You!",
                                                    textAlign: TextAlign.center,
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  )),
                                            )
                                          // running list
                                          : Obx(
                                              () {
                                                return NotificationListener<
                                                    ScrollNotification>(
                                                  onNotification:
                                                      (scrollNotification) {
                                                    if (scrollNotification
                                                            is ScrollEndNotification &&
                                                        scrollNotification
                                                                .metrics
                                                                .pixels ==
                                                            scrollNotification
                                                                .metrics
                                                                .maxScrollExtent) {
                                                      controller.loadMore(controller
                                                                  .tabController
                                                                  ?.index ==
                                                              0
                                                          ? 'running'
                                                          : controller.tabController
                                                                      ?.index ==
                                                                  1
                                                              ? 'upcoming'
                                                              : 'past');
                                                    }
                                                    return false;
                                                  },
                                                  child: resWidth < 600
                                                      ? ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          padding:
                                                              EdgeInsets.only(
                                                                  bottom:
                                                                      resHeight *
                                                                          0.1),
                                                          itemCount: controller
                                                              .runningList
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            print(
                                                                "length listed ${controller.runningList.length}");
                                                            return GestureDetector(
                                                              onTap: () async {
                                                                SharedPreferences
                                                                    mentorId =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                await mentorId.setString(
                                                                    'mId',
                                                                    controller
                                                                        .runningList[
                                                                            index]
                                                                        .id
                                                                        .toString());
                                                                Get.toNamed(
                                                                  Routes
                                                                      .mentorshipDetail(
                                                                    id: controller
                                                                        .runningList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                  ),
                                                                  arguments: {
                                                                    'id': controller
                                                                        .runningList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                  },
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            0.05),
                                                                child: Stack(
                                                                  children: [
                                                                    controller.runningList[index].isPlus == 1 ||
                                                                            controller.runningList[index].isPlus ==
                                                                                2
                                                                        ? Positioned(
                                                                            top: resWidth *
                                                                                0.11,
                                                                            right: resWidth *
                                                                                0.015,
                                                                            bottom:
                                                                                0,
                                                                            child:
                                                                                Container(
                                                                              height: resWidth < 360 ? resHeight * 0.566 : resHeight * 0.634,
                                                                              width: resWidth * 0.93,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: BorderRadius.circular(20),
                                                                                gradient: LinearGradient(
                                                                                  colors: [
                                                                                    hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                    hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ))
                                                                        : Container(),
                                                                    controller.runningList[index].isPlus ==
                                                                                1 ||
                                                                            controller.runningList[index].isPlus ==
                                                                                2
                                                                        ? Positioned(
                                                                            top:
                                                                                resHeight * -0,
                                                                            left:
                                                                                resWidth * 0.11,
                                                                            // Moves it outside but attached
                                                                            child:
                                                                                Stack(children: [
                                                                              Positioned(
                                                                                  top: resHeight * 0.006,
                                                                                  right: resWidth * 0.03,
                                                                                  child: Container(
                                                                                    height: resHeight * 0.74,
                                                                                    width: resWidth * 0.73,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                      gradient: LinearGradient(
                                                                                        colors: [
                                                                                          hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                          hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(6.0),
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(top: resWidth * 0.01, left: resWidth * 0.005, right: resWidth * 0.03, bottom: resWidth * 0.03),
                                                                                  width: resWidth * 0.7, // Slightly wider at the base for smooth blending
                                                                                  height: 40,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelBgColor),
                                                                                    // hexToColor(controller.upcomingList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1 : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 6.0),
                                                                                    child: Center(
                                                                                      child: (controller.runningList[index].isPlus == 1 || controller.runningList[index].isPlus == 2)
                                                                                          ? MentorshipGradientText(
                                                                                              controller.runningList[index].isPlus == 2 ? "Micro Mentorship" : (controller.mentorshipData.value?.data?.mentorshipPlusLabel ?? "Mentorship Plus"),
                                                                                              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                                                                              gradient: LinearGradient(
                                                                                                colors: controller.runningList[index].isPlus == 2
                                                                                                    ? [
                                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor1),
                                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipMicroLabelTextColor2),
                                                                                                      ]
                                                                                                    : [
                                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor1),
                                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor2),
                                                                                                      ],
                                                                                              ),
                                                                                            )
                                                                                          : const SizedBox.shrink(),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                          )
                                                                        : Container(),

                                                                    Container(
                                                                      margin: controller.runningList[index].isPlus == 1 ||
                                                                              controller.runningList[index].isPlus ==
                                                                                  2
                                                                          ? EdgeInsets.only(
                                                                              top: resWidth * 0.12,
                                                                              left: resWidth * 0.03,
                                                                              right: resWidth * 0.03,
                                                                              bottom: resWidth * 0.03)
                                                                          : EdgeInsets.all(resWidth * 0.02),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                        gradient:
                                                                            LinearGradient(
                                                                          // colors: [
                                                                          //   hexToColor(controller.runningList[index].isPlus == 1
                                                                          //       ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1
                                                                          //       : controller.runningList[index].isPlus == 2
                                                                          //           ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1
                                                                          //           : controller.mentorshipData.value?.data?.mentorshipNewCardBgColor1 ?? ""),
                                                                          //   hexToColor(controller.runningList[index].isPlus == 1
                                                                          //       ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor2
                                                                          //       : controller.runningList[index].isPlus == 2
                                                                          //           ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor2
                                                                          //           : controller.mentorshipData.value?.data?.mentorshipNewCardBgColor2 ?? ""),
                                                                          // ],

                                                                          // colors: [
                                                                          //   hexToColor(controller.runningList[index].isPlus == 1
                                                                          //       ? controller.mentorshipData.value?.data
                                                                          //       ?.mentorshipPlusCardBgColor1
                                                                          //       : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ??
                                                                          //       ""),
                                                                          //   hexToColor(controller.runningList[index].isPlus == 1
                                                                          //       ? controller.mentorshipData.value?.data
                                                                          //       ?.mentorshipPlusCardBgColor2
                                                                          //       : controller.mentorshipData.value?.data?.mentorshipCardBgColor2 ??
                                                                          //       "")
                                                                          // ],
                                                                              colors: [
                                                                                hexToColor(controller.runningList[index].isPlus == 1
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1
                                                                                    : controller.runningList[index].isPlus == 2
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipMicroCardBgColor1
                                                                                    : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                hexToColor(controller.runningList[index].isPlus == 1
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor2
                                                                                    : controller.runningList[index].isPlus == 2
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipMicroCardBgColor2
                                                                                    : controller.mentorshipData.value?.data?.mentorshipCardBgColor2 ?? "")
                                                                              ],
                                                                          begin:
                                                                              Alignment.topCenter,
                                                                          end: Alignment
                                                                              .bottomCenter,
                                                                        ),
                                                                        boxShadow: [
                                                                          controller.runningList[index].isPlus != 1
                                                                              ? BoxShadow(
                                                                                  color: Colors.black.withOpacity(0.2),
                                                                                  blurRadius: 10,
                                                                                  spreadRadius: 5,
                                                                                  offset: const Offset(0, 4),
                                                                                )
                                                                              : const BoxShadow()
                                                                        ],
                                                                      ),
                                                                      child: Stack(
                                                                          children: [
                                                                            Column(
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              children: [
                                                                                SizedBox(height: resHeight <= 700 ? resHeight * 0.258 : resHeight * 0.24),
                                                                                Text(
                                                                                  controller.runningList[index].title ?? "",
                                                                                  style: TextStyle(
                                                                                    height: 1,
                                                                                    fontSize: 34 * textScale,
                                                                                    fontWeight: FontWeight.w900,
                                                                                    color: hexToColor(controller.mentorshipData.value?.data?.mentorshipTitleColor ?? ""),
                                                                                  ),
                                                                                  textAlign: TextAlign.center,
                                                                                ),
                                                                                SizedBox(height: resHeight * 0.016),
                                                                                Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                  children: [
                                                                                    _buildProgramDetail(context, Icons.calendar_today, "${controller.runningList[index].info1 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle1 ?? "", controller),
                                                                                    Container(
                                                                                      width: 1,
                                                                                      height: resHeight * 0.08,
                                                                                      color: Colors.white70,
                                                                                    ),
                                                                                    (controller.runningList[index].isPlus == 1 || controller.runningList[index].isPlus == 2) ? Container() : _buildProgramDetail(context, Icons.group, "${controller.runningList[index].info2 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle2 ?? "", controller),
                                                                                    Container(
                                                                                      width: 1,
                                                                                      height: resHeight * 0.08,
                                                                                      color: Colors.white70,
                                                                                    ),
                                                                                    _buildProgramDetail(context, Icons.person, "${controller.runningList[index].info3 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle3 ?? "", controller),
                                                                                  ],
                                                                                ),
                                                                                SizedBox(height: resHeight * 0.016),
                                                                                Container(
                                                                                  width: resWidth * 0.75,
                                                                                  height: 3,
                                                                                  color: Colors.white70,
                                                                                ),
                                                                                SizedBox(height: resHeight * 0.012),
                                                                                Text(
                                                                                  "Starts: ${controller.runningList[index].mentorshipStartDateFormatted ?? ""}",
                                                                                  style: TextStyle(
                                                                                    fontSize: 14 * textScale,
                                                                                    color: Colors.white,
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                                SizedBox(height: resHeight * 0.01),
                                                                                ElevatedButton(
                                                                                  onPressed: () async {
                                                                                    SharedPreferences mentorId = await SharedPreferences.getInstance();
                                                                                    await mentorId.setString('mId', controller.runningList[index].id.toString());
                                                                                    print('sdfsdfs ${mentorId.getString('mId')}');
                                                                                    Get.toNamed(
                                                                                      Routes.mentorshipDetail(
                                                                                        id: controller.runningList[index].id.toString(),
                                                                                      ),
                                                                                      arguments: {
                                                                                        'id': controller.runningList[index].id.toString(),
                                                                                      },
                                                                                    );
                                                                                  },
                                                                                  style: ElevatedButton.styleFrom(
                                                                                    backgroundColor: hexToColor(controller.mentorshipData.value?.data?.detailButtonColor ?? ""),
                                                                                    shape: RoundedRectangleBorder(
                                                                                      borderRadius: BorderRadius.circular(24),
                                                                                    ),
                                                                                    minimumSize: Size(resWidth * 0.75, resHeight * 0.05),
                                                                                  ),
                                                                                  child: Text(
                                                                                    controller.mentorshipData.value?.data?.detailButtonText ?? '',
                                                                                    style: TextStyle(
                                                                                      fontSize: 17 * textScale,
                                                                                      fontWeight: FontWeight.w700,
                                                                                      color: hexToColor(controller.mentorshipData.value?.data?.detailButtonTextColor ?? ""),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                                const SizedBox(height: 0),
                                                                              ],
                                                                            ),
                                                                            Positioned(
                                                                              top: resHeight / 45,
                                                                              left: resWidth / -9,
                                                                              child: Transform.rotate(
                                                                                angle: -0.7,
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  // Centering the text inside the container
                                                                                  padding: EdgeInsets.symmetric(horizontal: resWidth * 0.13, vertical: resHeight * 0.005),
                                                                                  color: hexToColor(controller.mentorshipData.value?.data?.monthStripBgColor ?? ""),
                                                                                  child: Text(
                                                                                    controller.runningList[index].monthName ?? "",
                                                                                    style: TextStyle(
                                                                                      fontSize: 13 * textScale,
                                                                                      color: hexToColor(controller.mentorshipData.value?.data?.monthStripTextColor ?? ""),
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: resHeight * 0.02,
                                                                              right: resWidth * 0.0001,
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: resWidth * 0.03, vertical: resHeight * 0.007),
                                                                                decoration: BoxDecoration(
                                                                                  color: controller.runningList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripBgColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripBgColor ?? ""),
                                                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                                                ),
                                                                                child: Text(
                                                                                  controller.runningList[index].isPlus == 1
                                                                                      ? controller.mentorshipData.value?.data?.mentorshipPlusStripText ?? ""
                                                                                      : controller.runningList[index].isPlus == 2
                                                                                          ? controller.mentorshipData.value?.data?.mentorshipMicroStripText ?? ""
                                                                                          : controller.runningList[index].seatsLeftLable ?? "",
                                                                                  style: TextStyle(
                                                                                    fontSize: 11 * textScale,
                                                                                    color: controller.runningList[index].isPlus == 1
                                                                                        ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripTextColor ?? "")
                                                                                        : controller.runningList[index].isPlus == 2
                                                                                            ? hexToColor(controller.mentorshipData.value?.data?.mentorshipMicroStripTextColor ?? "")
                                                                                            : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripTextColor ?? ""),
                                                                                    fontWeight: FontWeight.w600,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                    controller.runningList[index].isPlus ==
                                                                                1 ||
                                                                            controller.runningList[index].isPlus ==
                                                                                2
                                                                        ? Positioned(
                                                                            top:
                                                                                resHeight * 0.06,
                                                                            left:
                                                                                resWidth * 0.19,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                              child: ClipPath(
                                                                                clipper: BottomCircularClipper(),
                                                                                child: Container(
                                                                                  width: resWidth * 0.5,
                                                                                  height: resWidth * 0.5,
                                                                                  // Ensure a consistent aspect ratio for the circle
                                                                                  decoration: BoxDecoration(
                                                                                    image: DecorationImage(
                                                                                      image: NetworkImage(controller.runningList[index].image ?? ''),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Align(
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                              child: ClipPath(
                                                                                clipper: BottomCircularClipper(),
                                                                                child: Container(
                                                                                  width: resWidth * 0.5,
                                                                                  height: resWidth * 0.5,
                                                                                  // Ensure a consistent aspect ratio for the circle
                                                                                  decoration: BoxDecoration(
                                                                                    image: DecorationImage(
                                                                                      image: NetworkImage(controller.runningList[index].image ?? ''),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                    // Bottle neck - Attached to the main body
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : SingleChildScrollView(
                                                          child: Container(
                                                            // Ensure GridView has a finite height
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: resHeight *
                                                                  2.1, // Adjust based on your design
                                                            ),
                                                            child: GridView
                                                                .builder(
                                                              gridDelegate:
                                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    2, // 2 items per row
                                                                childAspectRatio:
                                                                    2 / 3.3, // Aspect ratio for each item
                                                                crossAxisSpacing:
                                                                    0.0,
                                                                mainAxisSpacing:
                                                                    0.0,
                                                              ),
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              // Disable GridView's scroll
                                                              itemCount:
                                                                  controller
                                                                      .runningList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                print(
                                                                    "lengthlist${controller.runningList.length}");
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    Get.toNamed(
                                                                      Routes
                                                                          .mentorshipDetail(
                                                                        id: controller
                                                                            .runningList[index]
                                                                            .id
                                                                            .toString(),
                                                                      ),
                                                                      arguments: {
                                                                        'id': controller
                                                                            .upcomingList[index]
                                                                            .id
                                                                            .toString(),
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: resHeight *
                                                                            0.01),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        controller.runningList[index].isPlus ==
                                                                                1
                                                                            ? Positioned(
                                                                                top: resWidth * 0.11,
                                                                                right: resWidth * 0.015,
                                                                                child: Container(
                                                                                  height: resWidth < 360 ? resHeight * 0.566 : resHeight * 0.634,
                                                                                  width: resWidth * 0.93,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                    gradient: LinearGradient(
                                                                                      colors: [
                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                            : Container(),
                                                                        controller.runningList[index].isPlus ==
                                                                                1
                                                                            ? Positioned(
                                                                                top: resHeight * -0,
                                                                                left: resWidth * 0.11,
                                                                                // Moves it outside but attached
                                                                                child: Stack(children: [
                                                                                  Positioned(
                                                                                      top: resHeight * 0.006,
                                                                                      right: resWidth * 0.03,
                                                                                      child: Container(
                                                                                        height: resHeight * 0.74,
                                                                                        width: resWidth * 0.73,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                          gradient: LinearGradient(
                                                                                            colors: [
                                                                                              hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                              hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(6.0),
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.only(top: resWidth * 0.01, left: resWidth * 0.005, right: resWidth * 0.03, bottom: resWidth * 0.03),
                                                                                      width: resWidth * 0.7, // Slightly wider at the base for smooth blending
                                                                                      height: 40,
                                                                                      decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: Colors.white
                                                                                          // hexToColor(controller.upcomingList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1 : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                          ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(bottom: 6.0),
                                                                                        child: Center(
                                                                                          child: MentorshipGradientText(
                                                                                            controller.mentorshipData.value?.data?.mentorshipMicroLabel != null && controller.mentorshipData.value?.data?.mentorshipMicroLabel != "" ? "Micro Mentorship" : (controller.mentorshipData.value?.data?.mentorshipPlusLabel ?? "Mentorship Plus"),
                                                                                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                                                                            gradient: LinearGradient(
                                                                                              colors: controller.mentorshipData.value?.data?.mentorshipMicroLabel != null && controller.mentorshipData.value?.data?.mentorshipMicroLabel != ""
                                                                                                  ? [
                                                                                                      hexToColor(controller.mentorshipData.value?.data?.mentorshipMicroLabelTextColor1),
                                                                                                      hexToColor(controller.mentorshipData.value?.data?.mentorshipMicroLabelTextColor2),
                                                                                                    ]
                                                                                                  : [
                                                                                                      hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor1),
                                                                                                      hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor2),
                                                                                                    ],
                                                                                            ),
                                                                                          ),

                                                                                          // child: MentorshipGradientText(
                                                                                          //   controller.mentorshipData.value?.data?.mentorshipPlusLabel ?? "Mentorship Plus",
                                                                                          //   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                                                                          //   gradient: LinearGradient(
                                                                                          //     colors: [
                                                                                          //       hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor1),
                                                                                          //       hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor2),
                                                                                          //     ],
                                                                                          //   ),
                                                                                          // ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ]),
                                                                              )
                                                                            : Container(),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.all(resWidth * 0.01),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            gradient:
                                                                                LinearGradient(
                                                                              colors: [
                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipCardBgColor2 ?? "")
                                                                              ],
                                                                              begin: Alignment.topCenter,
                                                                              end: Alignment.bottomCenter,
                                                                            ),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                blurRadius: 10,
                                                                                spreadRadius: 5,
                                                                                offset: const Offset(0, 4),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Stack(children: [
                                                                            Container(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  SizedBox(height: resHeight <= 700 ? resHeight * 0.258 : resHeight * 0.20),
                                                                                  Text(
                                                                                    controller.runningList[index].title ?? "",
                                                                                    style: TextStyle(
                                                                                      height: 1,
                                                                                      fontSize: 34 * textScale,
                                                                                      fontWeight: FontWeight.w900,
                                                                                      color: hexToColor(controller.mentorshipData.value?.data?.mentorshipTitleColor ?? ""),
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 2,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.012),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      _buildProgramDetail(context, Icons.calendar_today, "${controller.runningList[index].info1 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle1 ?? "", controller),
                                                                                      Container(
                                                                                        width: 1,
                                                                                        height: resHeight * 0.08,
                                                                                        color: Colors.white70,
                                                                                      ),
                                                                                      _buildProgramDetail(context, Icons.group, "${controller.runningList[index].info2 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle2 ?? "", controller),
                                                                                      Container(
                                                                                        width: 1,
                                                                                        height: resHeight * 0.08,
                                                                                        color: Colors.white70,
                                                                                      ),
                                                                                      _buildProgramDetail(context, Icons.person, "${controller.runningList[index].info3 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle3 ?? "", controller),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.016),
                                                                                  Container(
                                                                                    width: resWidth * 0.35,
                                                                                    height: 3,
                                                                                    color: Colors.white70,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.012),
                                                                                  Text(
                                                                                    "Starts: ${controller.runningList[index].mentorshipStartDateFormatted ?? ""}",
                                                                                    style: TextStyle(
                                                                                      fontSize: 13 * textScale,
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.01),
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Get.toNamed(
                                                                                        Routes.mentorshipDetail(
                                                                                          id: controller.runningList[index].id.toString(),
                                                                                        ),
                                                                                        arguments: {
                                                                                          'id': controller.runningList[index].id.toString(),
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: hexToColor(controller.mentorshipData.value?.data?.detailButtonColor ?? ""),
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(30),
                                                                                      ),
                                                                                      minimumSize: Size(resWidth * 0.36, resHeight * 0.05),
                                                                                    ),
                                                                                    child: Text(
                                                                                      controller.mentorshipData.value?.data?.detailButtonText ?? '',
                                                                                      style: TextStyle(
                                                                                        fontSize: 17 * textScale,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: hexToColor(controller.mentorshipData.value?.data?.detailButtonTextColor ?? ""),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 0),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                                top: resHeight / 48,
                                                                                left: resWidth / -9,
                                                                                child: Transform.rotate(
                                                                                  angle: -0.6,
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: resWidth * 0.12, vertical: resHeight * 0.005),
                                                                                    color: hexToColor(controller.mentorshipData.value?.data?.monthStripBgColor ?? ""),
                                                                                    child: Text(
                                                                                      controller.runningList[index].monthName ?? "",
                                                                                      style: TextStyle(
                                                                                        fontSize: 13 * textScale,
                                                                                        color: hexToColor(controller.mentorshipData.value?.data?.monthStripTextColor ?? ""),
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                            Positioned(
                                                                              top: resHeight * 0.02,
                                                                              right: resWidth * 0.0001,
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: resWidth * 0.03, vertical: resHeight * 0.007),
                                                                                decoration: BoxDecoration(
                                                                                  color: controller.runningList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripBgColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripBgColor ?? ""),
                                                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                                                ),
                                                                                child: Text(
                                                                                  controller.runningList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusStripText ?? "" : controller.runningList[index].seatsLeftLable ?? "",
                                                                                  style: TextStyle(fontSize: 11 * textScale, color: controller.runningList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripTextColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripTextColor ?? ""), fontWeight: FontWeight.w600),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                        ),
                                                                        controller.runningList[index].isPlus ==
                                                                                1
                                                                            ? Positioned(
                                                                                top: resHeight * 0.06,
                                                                                left: resWidth * 0.19,
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                                  child: ClipPath(
                                                                                    clipper: BottomCircularClipper(),
                                                                                    child: Container(
                                                                                      width: resWidth * 0.5,
                                                                                      height: resWidth * 0.5,
                                                                                      // Ensure a consistent aspect ratio for the circle
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          image: NetworkImage(controller.runningList[index].image ?? ''),
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Align(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                                  child: ClipPath(
                                                                                    clipper: BottomCircularClipper(),
                                                                                    child: Container(
                                                                                      width: resWidth * 0.5,
                                                                                      height: resWidth * 0.5,
                                                                                      // Ensure a consistent aspect ratio for the circle
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          image: NetworkImage(controller.runningList[index].image ?? ''),
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                );
                                              },
                                            ),

                                  // Upcoming list
                                  controller.isUpcomingLoading.value
                                      ? const Align(
                                          alignment: Alignment.topCenter,
                                          child: CircularProgressIndicator())
                                      : controller.upcomingList.isEmpty
                                          ? const Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                    "New Mentorship Batches are being Set Up for You!",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ))
                                          : Obx(
                                              () {
                                                return NotificationListener<
                                                    ScrollNotification>(
                                                  onNotification:
                                                      (scrollNotification) {
                                                    if (scrollNotification
                                                            is ScrollEndNotification &&
                                                        scrollNotification
                                                                .metrics
                                                                .pixels ==
                                                            scrollNotification
                                                                .metrics
                                                                .maxScrollExtent) {
                                                      // Load next page when scrolled to the bottom
                                                      controller.loadMore(controller
                                                                  .tabController
                                                                  ?.index ==
                                                              0
                                                          ? 'running'
                                                          : controller.tabController
                                                                      ?.index ==
                                                                  1
                                                              ? 'upcoming'
                                                              : 'past');
                                                    }
                                                    return false;
                                                  },
                                                  // child:SizedBox(height: 50,),
                                                  // height: resHeight,
                                                  child: resWidth < 600
                                                      ? ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                          itemCount: controller
                                                              .upcomingList
                                                              .length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return GestureDetector(
                                                              onTap: () async {
                                                                SharedPreferences
                                                                    mentorId =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                await mentorId.setString(
                                                                    'mId',
                                                                    controller
                                                                        .upcomingList[
                                                                            index]
                                                                        .id
                                                                        .toString());
                                                                Get.toNamed(
                                                                  Routes
                                                                      .mentorshipDetail(
                                                                    id: controller
                                                                        .upcomingList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                  ),
                                                                  arguments: {
                                                                    'id': controller
                                                                        .upcomingList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                  },
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            0.1),
                                                                // controller
                                                                //     .upcomingList[
                                                                // index]
                                                                //     .isPlus ==
                                                                //     1
                                                                //     ? resHeight *
                                                                //     0.05
                                                                //     : resHeight *
                                                                //     0.02),
                                                                child: Stack(
                                                                  children: [
                                                                    controller.upcomingList[index].isPlus ==
                                                                            1
                                                                        ? Positioned(
                                                                            top: resWidth *
                                                                                0.11,
                                                                            right: resWidth *
                                                                                0.015,
                                                                            bottom:
                                                                                0,
                                                                            child:
                                                                                Container(
                                                                              height: resWidth < 360 ? resHeight * 0.566 : resHeight * 0.634,
                                                                              width: resWidth * 0.93,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                gradient: LinearGradient(
                                                                                  colors: [
                                                                                    hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                    hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ))
                                                                        : Container(),
                                                                    controller.upcomingList[index].isPlus ==
                                                                            1
                                                                        ? Positioned(
                                                                            top:
                                                                                resHeight * -0,
                                                                            left:
                                                                                resWidth * 0.11,
                                                                            // Moves it outside but attached
                                                                            child:
                                                                                Stack(children: [
                                                                              Positioned(
                                                                                  top: resHeight * 0.006,
                                                                                  right: resWidth * 0.03,
                                                                                  child: Container(
                                                                                    height: resHeight * 0.74,
                                                                                    width: resWidth * 0.73,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                      gradient: LinearGradient(
                                                                                        colors: [
                                                                                          hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                          hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(6.0),
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(top: resWidth * 0.01, left: resWidth * 0.005, right: resWidth * 0.03, bottom: resWidth * 0.03),
                                                                                  width: resWidth * 0.7, // Slightly wider at the base for smooth blending
                                                                                  height: 40,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelBgColor),
                                                                                    // hexToColor(controller.upcomingList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1 : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 6.0),
                                                                                    child: Center(
                                                                                      child: MentorshipGradientText(
                                                                                        controller.mentorshipData.value?.data?.mentorshipPlusLabel ?? "Mentorship Plus",
                                                                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                                                                        gradient: LinearGradient(
                                                                                          colors: [
                                                                                            hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor1),
                                                                                            hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor2),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                          )
                                                                        : Container(),

                                                                    Container(
                                                                      margin: controller.upcomingList[index].isPlus ==
                                                                              1
                                                                          ? EdgeInsets.only(
                                                                              top: resWidth * 0.12,
                                                                              left: resWidth * 0.03,
                                                                              right: resWidth * 0.03,
                                                                              bottom: resWidth * 0.03)
                                                                          : EdgeInsets.all(resWidth * 0.02),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                        gradient:
                                                                            LinearGradient(
                                                                          // colors: [
                                                                          //   hexToColor(controller.upcomingList[index].isPlus == 1
                                                                          //       ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1
                                                                          //       : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                          //   hexToColor(controller.upcomingList[index].isPlus == 1
                                                                          //       ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor2
                                                                          //       : controller.mentorshipData.value?.data?.mentorshipCardBgColor2 ?? "")
                                                                          // ],
                                                                              colors: [
                                                                                hexToColor(controller.upcomingList[index].isPlus == 1
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1
                                                                                    : controller.upcomingList[index].isPlus == 2
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipMicroCardBgColor1
                                                                                    : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                hexToColor(controller.upcomingList[index].isPlus == 1
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor2
                                                                                    : controller.upcomingList[index].isPlus == 2
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipMicroCardBgColor2
                                                                                    : controller.mentorshipData.value?.data?.mentorshipCardBgColor2 ?? "")
                                                                              ],
                                                                          begin:
                                                                              Alignment.topCenter,
                                                                          end: Alignment
                                                                              .bottomCenter,
                                                                        ),
                                                                        boxShadow: [
                                                                          controller.upcomingList[index].isPlus != 1
                                                                              ? BoxShadow(
                                                                                  color: Colors.black.withOpacity(0.2),
                                                                                  blurRadius: 10,
                                                                                  spreadRadius: 5,
                                                                                  offset: const Offset(0, 4),
                                                                                )
                                                                              : const BoxShadow()
                                                                        ],
                                                                      ),
                                                                      child: Stack(
                                                                          children: [
                                                                            Container(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  SizedBox(height: resHeight <= 700 ? resHeight * 0.258 : resHeight * 0.24),
                                                                                  Text(
                                                                                    controller.upcomingList[index].title ?? "",
                                                                                    style: TextStyle(
                                                                                      height: 1,
                                                                                      fontSize: 34 * textScale,
                                                                                      fontWeight: FontWeight.w900,
                                                                                      color: hexToColor(controller.mentorshipData.value?.data?.mentorshipTitleColor ?? ""),
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.016),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      _buildProgramDetail(context, Icons.calendar_today, "${controller.upcomingList[index].info1 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle1 ?? "", controller),
                                                                                      Container(
                                                                                        width: 1,
                                                                                        height: resHeight * 0.08,
                                                                                        color: Colors.white70,
                                                                                      ),
                                                                                      controller.upcomingList[index].isPlus == 1 ? Container() : _buildProgramDetail(context, Icons.group, "${controller.upcomingList[index].info2 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle2 ?? "", controller),
                                                                                      Container(
                                                                                        width: 1,
                                                                                        height: resHeight * 0.08,
                                                                                        color: Colors.white70,
                                                                                      ),
                                                                                      _buildProgramDetail(context, Icons.person, "${controller.upcomingList[index].info3 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle3 ?? "", controller),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.016),
                                                                                  Container(
                                                                                    width: resWidth * 0.75,
                                                                                    height: 3,
                                                                                    color: Colors.white70,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.012),
                                                                                  Text(
                                                                                    "Starts: ${controller.upcomingList[index].mentorshipStartDateFormatted ?? ""}",
                                                                                    style: TextStyle(
                                                                                      fontSize: 14 * textScale,
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.01),
                                                                                  ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      SharedPreferences mentorId = await SharedPreferences.getInstance();
                                                                                      await mentorId.setString('mId', controller.upcomingList[index].id.toString());
                                                                                      print('sdfsdfs ${mentorId.getString('mId')}');
                                                                                      Get.toNamed(
                                                                                        Routes.mentorshipDetail(
                                                                                          id: controller.upcomingList[index].id.toString(),
                                                                                        ),
                                                                                        arguments: {
                                                                                          'id': controller.upcomingList[index].id.toString(),
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: hexToColor(controller.mentorshipData.value?.data?.detailButtonColor ?? ""),
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(24),
                                                                                      ),
                                                                                      minimumSize: Size(resWidth * 0.75, resHeight * 0.05),
                                                                                    ),
                                                                                    child: Text(
                                                                                      controller.mentorshipData.value?.data?.detailButtonText ?? '',
                                                                                      style: TextStyle(
                                                                                        fontSize: 17 * textScale,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: hexToColor(controller.mentorshipData.value?.data?.detailButtonTextColor ?? ""),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 16),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: resHeight / 45,
                                                                              left: resWidth / -9,
                                                                              child: Transform.rotate(
                                                                                angle: -0.7,
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  // Centering the text inside the container
                                                                                  padding: EdgeInsets.symmetric(horizontal: resWidth * 0.13, vertical: resHeight * 0.005),
                                                                                  color: hexToColor(controller.mentorshipData.value?.data?.monthStripBgColor ?? ""),
                                                                                  child: Text(
                                                                                    controller.upcomingList[index].monthName ?? "",
                                                                                    style: TextStyle(
                                                                                      fontSize: 13 * textScale,
                                                                                      color: hexToColor(controller.mentorshipData.value?.data?.monthStripTextColor ?? ""),
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: resHeight * 0.02,
                                                                              right: resWidth * 0.0001,
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: resWidth * 0.03, vertical: resHeight * 0.007),
                                                                                decoration: BoxDecoration(
                                                                                  color: controller.upcomingList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripBgColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripBgColor ?? ""),
                                                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                                                ),
                                                                                child: Text(
                                                                                  controller.upcomingList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusStripText ?? "" : controller.upcomingList[index].seatsLeftLable ?? "",
                                                                                  style: TextStyle(fontSize: 11 * textScale, color: controller.upcomingList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripTextColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripTextColor ?? ""), fontWeight: FontWeight.w600),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                    controller.upcomingList[index].isPlus ==
                                                                            1
                                                                        ? Positioned(
                                                                            top:
                                                                                resHeight * 0.06,
                                                                            left:
                                                                                resWidth * 0.19,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                              child: ClipPath(
                                                                                clipper: BottomCircularClipper(),
                                                                                child: Container(
                                                                                  width: resWidth * 0.5,
                                                                                  height: resWidth * 0.5,
                                                                                  // Ensure a consistent aspect ratio for the circle
                                                                                  decoration: BoxDecoration(
                                                                                    image: DecorationImage(
                                                                                      image: NetworkImage(controller.upcomingList[index].image ?? ''),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Align(
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                              child: ClipPath(
                                                                                clipper: BottomCircularClipper(),
                                                                                child: Container(
                                                                                  width: resWidth * 0.5,
                                                                                  height: resWidth * 0.5,
                                                                                  // Ensure a consistent aspect ratio for the circle
                                                                                  decoration: BoxDecoration(
                                                                                    image: DecorationImage(
                                                                                      image: NetworkImage(controller.upcomingList[index].image ?? ''),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                    // Bottle neck - Attached to the main body
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : SingleChildScrollView(
                                                          child: Container(
                                                            // Ensure GridView has a finite height
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: resHeight *
                                                                  2.1, // Adjust based on your design
                                                            ),
                                                            child: GridView
                                                                .builder(
                                                              gridDelegate:
                                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    2, // 2 items per row
                                                                childAspectRatio:
                                                                    2 / 3.3, // Aspect ratio for each item
                                                                crossAxisSpacing:
                                                                    0.0,
                                                                mainAxisSpacing:
                                                                    0.0,
                                                              ),
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              // Disable GridView's scroll
                                                              itemCount: controller
                                                                  .upcomingList
                                                                  .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                print(
                                                                    "lengthlist${controller.upcomingList.length}");
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    Get.toNamed(
                                                                      Routes
                                                                          .mentorshipDetail(
                                                                        id: controller
                                                                            .upcomingList[index]
                                                                            .id
                                                                            .toString(),
                                                                      ),
                                                                      arguments: {
                                                                        'id': controller
                                                                            .upcomingList[index]
                                                                            .id
                                                                            .toString(),
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: resHeight *
                                                                            0.01),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        controller.upcomingList[index].isPlus ==
                                                                                1
                                                                            ? Positioned(
                                                                                top: resWidth * 0.11,
                                                                                right: resWidth * 0.015,
                                                                                child: Container(
                                                                                  height: resWidth < 360 ? resHeight * 0.566 : resHeight * 0.634,
                                                                                  width: resWidth * 0.93,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                    gradient: LinearGradient(
                                                                                      colors: [
                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                            : Container(),
                                                                        controller.upcomingList[index].isPlus ==
                                                                                1
                                                                            ? Positioned(
                                                                                top: resHeight * -0,
                                                                                left: resWidth * 0.11,
                                                                                // Moves it outside but attached
                                                                                child: Stack(children: [
                                                                                  Positioned(
                                                                                      top: resHeight * 0.006,
                                                                                      right: resWidth * 0.03,
                                                                                      child: Container(
                                                                                        height: resHeight * 0.74,
                                                                                        width: resWidth * 0.73,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                          gradient: LinearGradient(
                                                                                            colors: [
                                                                                              hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                              hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(6.0),
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.only(top: resWidth * 0.01, left: resWidth * 0.005, right: resWidth * 0.03, bottom: resWidth * 0.03),
                                                                                      width: resWidth * 0.7, // Slightly wider at the base for smooth blending
                                                                                      height: 40,
                                                                                      decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: Colors.white
                                                                                          // hexToColor(controller.upcomingList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1 : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                          ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(bottom: 6.0),
                                                                                        child: Center(
                                                                                          child: MentorshipGradientText(
                                                                                            controller.mentorshipData.value?.data?.mentorshipPlusLabel ?? "Mentorship Plus",
                                                                                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                                                                            gradient: LinearGradient(
                                                                                              colors: [
                                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor1),
                                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor2),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ]),
                                                                              )
                                                                            : Container(),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.all(resWidth * 0.01),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            gradient:
                                                                                LinearGradient(
                                                                              colors: [
                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipCardBgColor2 ?? "")
                                                                              ],
                                                                              begin: Alignment.topCenter,
                                                                              end: Alignment.bottomCenter,
                                                                            ),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                blurRadius: 10,
                                                                                spreadRadius: 5,
                                                                                offset: const Offset(0, 4),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Stack(children: [
                                                                            Container(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  SizedBox(height: resHeight <= 700 ? resHeight * 0.258 : resHeight * 0.20),
                                                                                  Text(
                                                                                    controller.upcomingList[index].title ?? "",
                                                                                    style: TextStyle(
                                                                                      height: 1,
                                                                                      fontSize: 34 * textScale,
                                                                                      fontWeight: FontWeight.w900,
                                                                                      color: hexToColor(controller.mentorshipData.value?.data?.mentorshipTitleColor ?? ""),
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 2,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.012),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      _buildProgramDetail(context, Icons.calendar_today, "${controller.upcomingList[index].info1 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle1 ?? "", controller),
                                                                                      Container(
                                                                                        width: 1,
                                                                                        height: resHeight * 0.08,
                                                                                        color: Colors.white70,
                                                                                      ),
                                                                                      _buildProgramDetail(context, Icons.group, "${controller.upcomingList[index].info2 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle2 ?? "", controller),
                                                                                      Container(
                                                                                        width: 1,
                                                                                        height: resHeight * 0.08,
                                                                                        color: Colors.white70,
                                                                                      ),
                                                                                      _buildProgramDetail(context, Icons.person, "${controller.upcomingList[index].info3 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle3 ?? "", controller),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.016),
                                                                                  Container(
                                                                                    width: resWidth * 0.35,
                                                                                    height: 3,
                                                                                    color: Colors.white70,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.012),
                                                                                  Text(
                                                                                    "Starts: ${controller.upcomingList[index].mentorshipStartDateFormatted ?? ""}",
                                                                                    style: TextStyle(
                                                                                      fontSize: 13 * textScale,
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.01),
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Get.toNamed(
                                                                                        Routes.mentorshipDetail(
                                                                                          id: controller.upcomingList[index].id.toString(),
                                                                                        ),
                                                                                        arguments: {
                                                                                          'id': controller.upcomingList[index].id.toString(),
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: hexToColor(controller.mentorshipData.value?.data?.detailButtonColor ?? ""),
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(30),
                                                                                      ),
                                                                                      minimumSize: Size(resWidth * 0.36, resHeight * 0.05),
                                                                                    ),
                                                                                    child: Text(
                                                                                      controller.mentorshipData.value?.data?.detailButtonText ?? '',
                                                                                      style: TextStyle(
                                                                                        fontSize: 17 * textScale,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: hexToColor(controller.mentorshipData.value?.data?.detailButtonTextColor ?? ""),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 20),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                                top: resHeight / 48,
                                                                                left: resWidth / -9,
                                                                                child: Transform.rotate(
                                                                                  angle: -0.6,
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: resWidth * 0.12, vertical: resHeight * 0.005),
                                                                                    color: hexToColor(controller.mentorshipData.value?.data?.monthStripBgColor ?? ""),
                                                                                    child: Text(
                                                                                      controller.upcomingList[index].monthName ?? "",
                                                                                      style: TextStyle(
                                                                                        fontSize: 13 * textScale,
                                                                                        color: hexToColor(controller.mentorshipData.value?.data?.monthStripTextColor ?? ""),
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                            Positioned(
                                                                              top: resHeight * 0.02,
                                                                              right: resWidth * 0.0001,
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: resWidth * 0.03, vertical: resHeight * 0.007),
                                                                                decoration: BoxDecoration(
                                                                                  color: controller.upcomingList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripBgColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripBgColor ?? ""),
                                                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                                                ),
                                                                                child: Text(
                                                                                  controller.upcomingList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusStripText ?? "" : controller.upcomingList[index].seatsLeftLable ?? "",
                                                                                  style: TextStyle(fontSize: 11 * textScale, color: controller.upcomingList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripTextColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripTextColor ?? ""), fontWeight: FontWeight.w600),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                        ),
                                                                        controller.upcomingList[index].isPlus ==
                                                                                1
                                                                            ? Positioned(
                                                                                top: resHeight * 0.06,
                                                                                left: resWidth * 0.19,
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                                  child: ClipPath(
                                                                                    clipper: BottomCircularClipper(),
                                                                                    child: Container(
                                                                                      width: resWidth * 0.5,
                                                                                      height: resWidth * 0.5,
                                                                                      // Ensure a consistent aspect ratio for the circle
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          image: NetworkImage(controller.upcomingList[index].image ?? ''),
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Align(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                                  child: ClipPath(
                                                                                    clipper: BottomCircularClipper(),
                                                                                    child: Container(
                                                                                      width: resWidth * 0.5,
                                                                                      height: resWidth * 0.5,
                                                                                      // Ensure a consistent aspect ratio for the circle
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          image: NetworkImage(controller.upcomingList[index].image ?? ''),
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                );
                                              },
                                            ),

                                  controller.isPastLoading.value
                                      ? const Align(
                                          alignment: Alignment.topCenter,
                                          child: CircularProgressIndicator())
                                      : controller.pastList.isEmpty
                                          ? const Align(
                                              alignment: Alignment.topCenter,
                                              child: Padding(
                                                padding: EdgeInsets.all(8.0),
                                                child: Text(
                                                    "No records match your selection",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                        fontSize: 12)),
                                              ))

                                          // Past list
                                          : Obx(
                                              () {
                                                return NotificationListener<
                                                    ScrollNotification>(
                                                  onNotification:
                                                      (scrollNotification) {
                                                    if (scrollNotification
                                                            is ScrollEndNotification &&
                                                        scrollNotification
                                                                .metrics
                                                                .pixels ==
                                                            scrollNotification
                                                                .metrics
                                                                .maxScrollExtent) {
                                                      // Load next page when scrolled to the bottom
                                                      controller.loadMore(controller
                                                                  .tabController
                                                                  ?.index ==
                                                              0
                                                          ? 'running'
                                                          : controller.tabController
                                                                      ?.index ==
                                                                  1
                                                              ? 'upcoming'
                                                              : 'past');
                                                    }
                                                    return false;
                                                  },
                                                  // height: resHeight,
                                                  child: resWidth < 600
                                                      ? ListView.builder(
                                                          physics:
                                                              const NeverScrollableScrollPhysics(),
                                                          shrinkWrap: true,
                                                    padding: EdgeInsets.only(
                                                      bottom: MediaQuery.of(context).padding.bottom + 20,
                                                    ),
                                                          itemCount: controller
                                                              .pastList.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return GestureDetector(
                                                              onTap: () async {
                                                                SharedPreferences
                                                                    mentorId =
                                                                    await SharedPreferences
                                                                        .getInstance();
                                                                await mentorId.setString(
                                                                    'mId',
                                                                    controller
                                                                        .pastList[
                                                                            index]
                                                                        .id
                                                                        .toString());
                                                                Get.toNamed(
                                                                  Routes
                                                                      .mentorshipDetail(
                                                                    id: controller
                                                                        .pastList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                  ),
                                                                  arguments: {
                                                                    'id': controller
                                                                        .pastList[
                                                                            index]
                                                                        .id
                                                                        .toString(),
                                                                  },
                                                                );
                                                              },
                                                              child: Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top:
                                                                            0.01),
                                                                // controller
                                                                //     .pastList[
                                                                // index]
                                                                //     .isPlus ==
                                                                //     1
                                                                //     ? resHeight *
                                                                //     0.05
                                                                //     : resHeight *
                                                                //     0.02),
                                                                child: Stack(
                                                                  children: [
                                                                    controller.pastList[index].isPlus ==
                                                                            1
                                                                        ? Positioned(
                                                                            top: resWidth *
                                                                                0.11,
                                                                            right: resWidth *
                                                                                0.015,
                                                                            bottom:
                                                                                0,
                                                                            child:
                                                                                Container(
                                                                              height: resWidth < 360 ? resHeight * 0.566 : resHeight * 0.634,
                                                                              width: resWidth * 0.93,
                                                                              decoration: BoxDecoration(
                                                                                borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                gradient: LinearGradient(
                                                                                  colors: [
                                                                                    hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                    hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ))
                                                                        : Container(),
                                                                    controller.pastList[index].isPlus ==
                                                                            1
                                                                        ? Positioned(
                                                                            top:
                                                                                resHeight * -0,
                                                                            left:
                                                                                resWidth * 0.11,
                                                                            // Moves it outside but attached
                                                                            child:
                                                                                Stack(children: [
                                                                              Positioned(
                                                                                  top: resHeight * 0.006,
                                                                                  right: resWidth * 0.03,
                                                                                  child: Container(
                                                                                    height: resHeight * 0.74,
                                                                                    width: resWidth * 0.73,
                                                                                    decoration: BoxDecoration(
                                                                                      borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                      gradient: LinearGradient(
                                                                                        colors: [
                                                                                          hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                          hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                        ],
                                                                                      ),
                                                                                    ),
                                                                                  )),
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(6.0),
                                                                                child: Container(
                                                                                  margin: EdgeInsets.only(top: resWidth * 0.01, left: resWidth * 0.005, right: resWidth * 0.03, bottom: resWidth * 0.03),
                                                                                  width: resWidth * 0.7, // Slightly wider at the base for smooth blending
                                                                                  height: 40,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelBgColor),
                                                                                    // hexToColor(controller.upcomingList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1 : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                  ),
                                                                                  child: Padding(
                                                                                    padding: const EdgeInsets.only(bottom: 6.0),
                                                                                    child: Center(
                                                                                      child: MentorshipGradientText(
                                                                                        controller.mentorshipData.value?.data?.mentorshipPlusLabel ?? "Mentorship Plus",
                                                                                        style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                                                                        gradient: LinearGradient(
                                                                                          colors: [
                                                                                            hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor1),
                                                                                            hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor2),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ]),
                                                                          )
                                                                        : Container(),

                                                                    Container(
                                                                      margin: controller.pastList[index].isPlus ==
                                                                              1
                                                                          ? EdgeInsets.only(
                                                                              top: resWidth * 0.12,
                                                                              left: resWidth * 0.03,
                                                                              right: resWidth * 0.03,
                                                                              bottom: resWidth * 0.03)
                                                                          : EdgeInsets.all(resWidth * 0.02),
                                                                      decoration:
                                                                          BoxDecoration(
                                                                        borderRadius:
                                                                            BorderRadius.circular(16),
                                                                        gradient:
                                                                            LinearGradient(
                                                                          colors: [
                                                                            hexToColor(controller.pastList[index].isPlus == 1
                                                                                ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1
                                                                                : controller.pastList[index].isPlus == 2
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipMicroCardBgColor1
                                                                                    : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                            hexToColor(controller.pastList[index].isPlus == 1
                                                                                ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor2
                                                                                : controller.pastList[index].isPlus == 2
                                                                                    ? controller.mentorshipData.value?.data?.mentorshipMicroCardBgColor2
                                                                                    : controller.mentorshipData.value?.data?.mentorshipCardBgColor2 ?? "")
                                                                          ],
                                                                          begin:
                                                                              Alignment.topCenter,
                                                                          end: Alignment
                                                                              .bottomCenter,
                                                                        ),
                                                                        boxShadow: [
                                                                          controller.pastList[index].isPlus != 1
                                                                              ? BoxShadow(
                                                                                  color: Colors.black.withOpacity(0.2),
                                                                                  blurRadius: 10,
                                                                                  spreadRadius: 5,
                                                                                  offset: const Offset(0, 4),
                                                                                )
                                                                              : const BoxShadow()
                                                                        ],
                                                                      ),
                                                                      child: Stack(
                                                                          children: [
                                                                            Container(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  SizedBox(height: resHeight <= 700 ? resHeight * 0.258 : resHeight * 0.24),
                                                                                  Text(
                                                                                    controller.pastList[index].title ?? "",
                                                                                    style: TextStyle(
                                                                                      height: 1,
                                                                                      fontSize: 34 * textScale,
                                                                                      fontWeight: FontWeight.w900,
                                                                                      color: hexToColor(controller.mentorshipData.value?.data?.mentorshipTitleColor ?? ""),
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.016),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      _buildProgramDetail(context, Icons.calendar_today, "${controller.pastList[index].info1 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle1 ?? "", controller),
                                                                                      // Container(
                                                                                      //   width: 1,
                                                                                      //   height: resHeight * 0.08,
                                                                                      //   color: Colors.white70,
                                                                                      // ),
                                                                                      // controller.pastList[index].isPlus == 1 ? Container() : _buildProgramDetail(context, Icons.group, "${controller.pastList[index].info2 ?? ""}", "${controller.mentorshipData.value?.data?.mentorshipInfoTitle2 ?? ""}", controller),
                                                                                      //
                                                                                      Container(
                                                                                        width: 1,
                                                                                        height: resHeight * 0.08,
                                                                                        color: Colors.white70,
                                                                                      ),
                                                                                      _buildProgramDetail(context, Icons.person, "${controller.pastList[index].info3 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle3 ?? "", controller),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.016),
                                                                                  Container(
                                                                                    width: resWidth * 0.75,
                                                                                    height: 3,
                                                                                    color: Colors.white70,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.012),
                                                                                  Text(
                                                                                    "Ended on : ${controller.pastList[index].mentorshipEndDateFormatted ?? ""}",
                                                                                    style: TextStyle(
                                                                                      fontSize: 14 * textScale,
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.01),
                                                                                  ElevatedButton(
                                                                                    onPressed: () async {
                                                                                      SharedPreferences mentorId = await SharedPreferences.getInstance();
                                                                                      await mentorId.setString('mId', controller.pastList[index].id.toString());
                                                                                      print('sdfsdfs ${mentorId.getString('mId')}');
                                                                                      Get.toNamed(
                                                                                        Routes.mentorshipDetail(
                                                                                          id: controller.pastList[index].id.toString(),
                                                                                        ),
                                                                                        arguments: {
                                                                                          'id': controller.pastList[index].id.toString(),
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: hexToColor(controller.mentorshipData.value?.data?.detailButtonColor ?? ""),
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(24),
                                                                                      ),
                                                                                      minimumSize: Size(resWidth * 0.75, resHeight * 0.05),
                                                                                    ),
                                                                                    child: Text(
                                                                                      controller.mentorshipData.value?.data?.detailButtonText ?? '',
                                                                                      style: TextStyle(
                                                                                        fontSize: 17 * textScale,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: hexToColor(controller.mentorshipData.value?.data?.detailButtonTextColor ?? ""),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 16),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: resHeight / 45,
                                                                              left: resWidth / -9,
                                                                              child: Transform.rotate(
                                                                                angle: -0.7,
                                                                                child: Container(
                                                                                  alignment: Alignment.center,
                                                                                  // Centering the text inside the container
                                                                                  padding: EdgeInsets.symmetric(horizontal: resWidth * 0.13, vertical: resHeight * 0.005),
                                                                                  color: hexToColor(controller.mentorshipData.value?.data?.monthStripBgColor ?? ""),
                                                                                  child: Text(
                                                                                    controller.pastList[index].monthName ?? "",
                                                                                    style: TextStyle(
                                                                                      fontSize: 13 * textScale,
                                                                                      color: hexToColor(controller.mentorshipData.value?.data?.monthStripTextColor ?? ""),
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                              top: resHeight * 0.02,
                                                                              right: resWidth * 0.0001,
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: resWidth * 0.03, vertical: resHeight * 0.007),
                                                                                decoration: BoxDecoration(
                                                                                  color: controller.pastList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripBgColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripBgColor ?? ""),
                                                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                                                ),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Image.asset(
                                                                                      ImageResource.instance.starIcon,
                                                                                      height: resWidth * 0.04,
                                                                                      color: ColorResource.orangeColor,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: resWidth * 0.02,
                                                                                    ),
                                                                                    Text(
                                                                                      controller.pastList[index].isPlus == 1 ? "${controller.pastList[index].totalRatings ?? ""}" : "${controller.pastList[index].totalRatings ?? ""}",
                                                                                      style: TextStyle(fontSize: 14 * textScale, color: controller.pastList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripTextColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripTextColor ?? ""), fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                    ),
                                                                    controller.pastList[index].isPlus ==
                                                                            1
                                                                        ? Positioned(
                                                                            top:
                                                                                resHeight * 0.06,
                                                                            left:
                                                                                resWidth * 0.19,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                              child: ClipPath(
                                                                                clipper: BottomCircularClipper(),
                                                                                child: Container(
                                                                                  width: resWidth * 0.5,
                                                                                  height: resWidth * 0.5,
                                                                                  // Ensure a consistent aspect ratio for the circle
                                                                                  decoration: BoxDecoration(
                                                                                    image: DecorationImage(
                                                                                      image: NetworkImage(controller.pastList[index].image ?? ''),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          )
                                                                        : Align(
                                                                            alignment:
                                                                                Alignment.bottomCenter,
                                                                            child:
                                                                                Padding(
                                                                              padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                              child: ClipPath(
                                                                                clipper: BottomCircularClipper(),
                                                                                child: Container(
                                                                                  width: resWidth * 0.5,
                                                                                  height: resWidth * 0.5,
                                                                                  // Ensure a consistent aspect ratio for the circle
                                                                                  decoration: BoxDecoration(
                                                                                    image: DecorationImage(
                                                                                      image: NetworkImage(controller.pastList[index].image ?? ''),
                                                                                      fit: BoxFit.cover,
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ),
                                                                    // Bottle neck - Attached to the main body
                                                                  ],
                                                                ),
                                                              ),
                                                            );
                                                          },
                                                        )
                                                      : SingleChildScrollView(
                                                          child: Container(
                                                            // Ensure GridView has a finite height
                                                            constraints:
                                                                BoxConstraints(
                                                              maxHeight: resHeight *
                                                                  2.1, // Adjust based on your design
                                                            ),
                                                            child: GridView
                                                                .builder(
                                                              gridDelegate:
                                                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                                                crossAxisCount:
                                                                    2, // 2 items per row
                                                                childAspectRatio:
                                                                    2 / 3.3, // Aspect ratio for each item
                                                                crossAxisSpacing:
                                                                    0.0,
                                                                mainAxisSpacing:
                                                                    0.0,
                                                              ),
                                                              physics:
                                                                  const NeverScrollableScrollPhysics(),
                                                              // Disable GridView's scroll
                                                              itemCount:
                                                                  controller
                                                                      .pastList
                                                                      .length,
                                                              itemBuilder:
                                                                  (context,
                                                                      index) {
                                                                print(
                                                                    "lengthlist${controller.pastList.length}");
                                                                return GestureDetector(
                                                                  onTap: () {
                                                                    Get.toNamed(
                                                                      Routes
                                                                          .mentorshipDetail(
                                                                        id: controller
                                                                            .pastList[index]
                                                                            .id
                                                                            .toString(),
                                                                      ),
                                                                      arguments: {
                                                                        'id': controller
                                                                            .pastList[index]
                                                                            .id
                                                                            .toString(),
                                                                      },
                                                                    );
                                                                  },
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        top: resHeight *
                                                                            0.01),
                                                                    child:
                                                                        Stack(
                                                                      children: [
                                                                        controller.pastList[index].isPlus ==
                                                                                1
                                                                            ? Positioned(
                                                                                top: resWidth * 0.11,
                                                                                right: resWidth * 0.015,
                                                                                child: Container(
                                                                                  height: resWidth < 360 ? resHeight * 0.566 : resHeight * 0.634,
                                                                                  width: resWidth * 0.93,
                                                                                  decoration: BoxDecoration(
                                                                                    borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                    gradient: LinearGradient(
                                                                                      colors: [
                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                        hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ))
                                                                            : Container(),
                                                                        controller.pastList[index].isPlus ==
                                                                                1
                                                                            ? Positioned(
                                                                                top: resHeight * -0,
                                                                                left: resWidth * 0.11,
                                                                                // Moves it outside but attached
                                                                                child: Stack(children: [
                                                                                  Positioned(
                                                                                      top: resHeight * 0.006,
                                                                                      right: resWidth * 0.03,
                                                                                      child: Container(
                                                                                        height: resHeight * 0.74,
                                                                                        width: resWidth * 0.73,
                                                                                        decoration: BoxDecoration(
                                                                                          borderRadius: const BorderRadius.all(Radius.circular(15)),
                                                                                          gradient: LinearGradient(
                                                                                            colors: [
                                                                                              hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor1),
                                                                                              hexToColor(controller.mentorshipData.value?.data?.mentorshipCardAnimationColor2),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      )),
                                                                                  Padding(
                                                                                    padding: const EdgeInsets.all(6.0),
                                                                                    child: Container(
                                                                                      margin: EdgeInsets.only(top: resWidth * 0.01, left: resWidth * 0.005, right: resWidth * 0.03, bottom: resWidth * 0.03),
                                                                                      width: resWidth * 0.7, // Slightly wider at the base for smooth blending
                                                                                      height: 40,
                                                                                      decoration: const BoxDecoration(borderRadius: BorderRadius.only(topLeft: Radius.circular(10), topRight: Radius.circular(10)), color: Colors.white
                                                                                          // hexToColor(controller.upcomingList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusCardBgColor1 : controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                          ),
                                                                                      child: Padding(
                                                                                        padding: const EdgeInsets.only(bottom: 6.0),
                                                                                        child: Center(
                                                                                          child: MentorshipGradientText(
                                                                                            controller.mentorshipData.value?.data?.mentorshipPlusLabel ?? "Mentorship Plus",
                                                                                            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                                                                                            gradient: LinearGradient(
                                                                                              colors: [
                                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor1),
                                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusLabelTextColor2),
                                                                                              ],
                                                                                            ),
                                                                                          ),
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ]),
                                                                              )
                                                                            : Container(),
                                                                        Container(
                                                                          margin:
                                                                              EdgeInsets.all(resWidth * 0.01),
                                                                          decoration:
                                                                              BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(16),
                                                                            gradient:
                                                                                LinearGradient(
                                                                              colors: [
                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipCardBgColor1 ?? ""),
                                                                                hexToColor(controller.mentorshipData.value?.data?.mentorshipCardBgColor2 ?? "")
                                                                              ],
                                                                              begin: Alignment.topCenter,
                                                                              end: Alignment.bottomCenter,
                                                                            ),
                                                                            boxShadow: [
                                                                              BoxShadow(
                                                                                color: Colors.black.withOpacity(0.2),
                                                                                blurRadius: 10,
                                                                                spreadRadius: 5,
                                                                                offset: const Offset(0, 4),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                          child:
                                                                              Stack(children: [
                                                                            Container(
                                                                              child: Column(
                                                                                mainAxisSize: MainAxisSize.min,
                                                                                children: [
                                                                                  SizedBox(height: resHeight <= 700 ? resHeight * 0.258 : resHeight * 0.20),
                                                                                  Text(
                                                                                    controller.pastList[index].title ?? "",
                                                                                    style: TextStyle(
                                                                                      height: 1,
                                                                                      fontSize: 34 * textScale,
                                                                                      fontWeight: FontWeight.w900,
                                                                                      color: hexToColor(controller.mentorshipData.value?.data?.mentorshipTitleColor ?? ""),
                                                                                    ),
                                                                                    textAlign: TextAlign.center,
                                                                                    maxLines: 2,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.012),
                                                                                  Row(
                                                                                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                                    children: [
                                                                                      _buildProgramDetail(context, Icons.calendar_today, "${controller.pastList[index].info1 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle1 ?? "", controller),
                                                                                      Container(
                                                                                        width: 1,
                                                                                        height: resHeight * 0.08,
                                                                                        color: Colors.white70,
                                                                                      ),
                                                                                      // _buildProgramDetail(context, Icons.group, "${controller.pastList[index].info2 ?? ""}", "${controller.mentorshipData.value?.data?.mentorshipInfoTitle2 ?? ""}", controller),
                                                                                      // Container(
                                                                                      //   width: 1,
                                                                                      //   height: resHeight * 0.08,
                                                                                      //   color: Colors.white70,
                                                                                      // ),
                                                                                      _buildProgramDetail(context, Icons.person, "${controller.pastList[index].info3 ?? ""}", controller.mentorshipData.value?.data?.mentorshipInfoTitle3 ?? "", controller),
                                                                                    ],
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.016),
                                                                                  Container(
                                                                                    width: resWidth * 0.35,
                                                                                    height: 3,
                                                                                    color: Colors.white70,
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.012),
                                                                                  Text(
                                                                                    "Ended on : ${controller.pastList[index].mentorshipEndDateFormatted ?? ""}",
                                                                                    style: TextStyle(
                                                                                      fontSize: 13 * textScale,
                                                                                      color: Colors.white,
                                                                                      fontWeight: FontWeight.w600,
                                                                                    ),
                                                                                  ),
                                                                                  SizedBox(height: resHeight * 0.01),
                                                                                  ElevatedButton(
                                                                                    onPressed: () {
                                                                                      Get.toNamed(
                                                                                        Routes.mentorshipDetail(
                                                                                          id: controller.pastList[index].id.toString(),
                                                                                        ),
                                                                                        arguments: {
                                                                                          'id': controller.pastList[index].id.toString(),
                                                                                        },
                                                                                      );
                                                                                    },
                                                                                    style: ElevatedButton.styleFrom(
                                                                                      backgroundColor: hexToColor(controller.mentorshipData.value?.data?.detailButtonColor ?? ""),
                                                                                      shape: RoundedRectangleBorder(
                                                                                        borderRadius: BorderRadius.circular(30),
                                                                                      ),
                                                                                      minimumSize: Size(resWidth * 0.36, resHeight * 0.05),
                                                                                    ),
                                                                                    child: Text(
                                                                                      controller.mentorshipData.value?.data?.detailButtonText ?? '',
                                                                                      style: TextStyle(
                                                                                        fontSize: 17 * textScale,
                                                                                        fontWeight: FontWeight.w700,
                                                                                        color: hexToColor(controller.mentorshipData.value?.data?.detailButtonTextColor ?? ""),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                  const SizedBox(height: 20),
                                                                                ],
                                                                              ),
                                                                            ),
                                                                            Positioned(
                                                                                top: resHeight / 48,
                                                                                left: resWidth / -9,
                                                                                child: Transform.rotate(
                                                                                  angle: -0.6,
                                                                                  child: Container(
                                                                                    padding: EdgeInsets.symmetric(horizontal: resWidth * 0.12, vertical: resHeight * 0.005),
                                                                                    color: hexToColor(controller.mentorshipData.value?.data?.monthStripBgColor ?? ""),
                                                                                    child: Text(
                                                                                      controller.pastList[index].monthName ?? "",
                                                                                      style: TextStyle(
                                                                                        fontSize: 13 * textScale,
                                                                                        color: hexToColor(controller.mentorshipData.value?.data?.monthStripTextColor ?? ""),
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                )),
                                                                            Positioned(
                                                                              top: resHeight * 0.02,
                                                                              right: resWidth * 0.0001,
                                                                              child: Container(
                                                                                padding: EdgeInsets.symmetric(horizontal: resWidth * 0.03, vertical: resHeight * 0.007),
                                                                                decoration: BoxDecoration(
                                                                                  color: controller.pastList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripBgColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripBgColor ?? ""),
                                                                                  borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                                                                                ),
                                                                                child: Row(
                                                                                  children: [
                                                                                    Image.asset(
                                                                                      ImageResource.instance.starIcon,
                                                                                      height: resWidth * 0.04,
                                                                                      color: ColorResource.orangeColor,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: resWidth * 0.02,
                                                                                    ),
                                                                                    Text(
                                                                                      controller.pastList[index].isPlus == 1 ? controller.mentorshipData.value?.data?.mentorshipPlusStripText ?? "" : controller.pastList[index].seatsLeftLable ?? "",
                                                                                      style: TextStyle(fontSize: 11 * textScale, color: controller.pastList[index].isPlus == 1 ? hexToColor(controller.mentorshipData.value?.data?.mentorshipPlusStripTextColor ?? "") : hexToColor(controller.mentorshipData.value?.data?.seatsLeftStripTextColor ?? ""), fontWeight: FontWeight.w600),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            ),
                                                                          ]),
                                                                        ),
                                                                        controller.pastList[index].isPlus ==
                                                                                1
                                                                            ? Positioned(
                                                                                top: resHeight * 0.06,
                                                                                left: resWidth * 0.19,
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                                  child: ClipPath(
                                                                                    clipper: BottomCircularClipper(),
                                                                                    child: Container(
                                                                                      width: resWidth * 0.5,
                                                                                      height: resWidth * 0.5,
                                                                                      // Ensure a consistent aspect ratio for the circle
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          image: NetworkImage(controller.pastList[index].image ?? ''),
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              )
                                                                            : Align(
                                                                                alignment: Alignment.bottomCenter,
                                                                                child: Padding(
                                                                                  padding: EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                                                                                  child: ClipPath(
                                                                                    clipper: BottomCircularClipper(),
                                                                                    child: Container(
                                                                                      width: resWidth * 0.5,
                                                                                      height: resWidth * 0.5,
                                                                                      // Ensure a consistent aspect ratio for the circle
                                                                                      decoration: BoxDecoration(
                                                                                        image: DecorationImage(
                                                                                          image: NetworkImage(controller.pastList[index].image ?? ''),
                                                                                          fit: BoxFit.cover,
                                                                                        ),
                                                                                      ),
                                                                                    ),
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                );
                                                              },
                                                            ),
                                                          ),
                                                        ),
                                                );
                                              },
                                            ),
                                ]),
                          ),
                          const SizedBox(
                            height: 18,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )),
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

  Widget _buildShimmerEffect(
      BuildContext context, double resWidth, double resHeight) {
    final screenWidth = MediaQuery.of(context).size.width;

    return RefreshIndicator(
      onRefresh: () async {
        // Simulate a network request or some data loading.
        await controller.onRefresh();
      },
      child: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: resWidth * 0.02),
            child: Column(
              children: [
                SizedBox(height: resHeight * 0.015),
                SizedBox(height: resHeight * 0.015),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: resHeight * 0.07,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: resWidth * 0.05),
                          child: Container(
                            width: resWidth * 0.16,
                            height: resWidth * 0.16,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.grey[300],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: resHeight * 0.015),
                Shimmer.fromColors(
                  baseColor: Colors.grey[300]!,
                  highlightColor: Colors.grey[100]!,
                  child: Container(
                    height: resHeight * 0.04,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: 5,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding:
                              EdgeInsets.symmetric(horizontal: resWidth * 0.02),
                          child: Container(
                            height: 20,
                            width: resWidth * 0.2,
                            color: Colors.grey[300],
                          ),
                        );
                      },
                    ),
                  ),
                ),
                SizedBox(height: resHeight * 0.02),
                screenWidth < 500
                    ? ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 3,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(resHeight * 0.015),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: resHeight * 0.55,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                          );
                        },
                      )
                    : GridView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: 6,
                        // Adjust item count for GridView
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2, // Number of columns in GridView
                          crossAxisSpacing:
                              resHeight * 0.02, // Spacing between columns
                          mainAxisSpacing:
                              resHeight * 0.02, // Spacing between rows
                        ),
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: EdgeInsets.all(resHeight * 0.015),
                            child: Shimmer.fromColors(
                              baseColor: Colors.grey[300]!,
                              highlightColor: Colors.grey[100]!,
                              child: Container(
                                height: resHeight *
                                    0.55, // Adjust height for GridView items
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(16),
                                  color: Colors.grey[300],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

Color hexToColor(String? hexColor) {
  if (hexColor == null || hexColor.isEmpty) {
    return Colors.white; // Default fallback color
  }
  hexColor = hexColor.replaceAll("#", "");
  if (hexColor.length == 6) {
    hexColor = "FF$hexColor"; // Add alpha value if not provided
  }
  try {
    return Color(int.parse("0x$hexColor"));
  } catch (e) {
    print("Invalid hex color: $hexColor");
    return Colors.transparent; // Default fallback color
  }
}

Widget _buildProgramDetail(BuildContext context, IconData icon, String count,
    String label, controller) {
  var resHeight = MediaQuery.of(context).size.height;
  var resWidth = MediaQuery.of(context).size.width;
  var textScale = MediaQuery.of(context).textScaleFactor;
  final data = controller.mentorshipData.value?.data;

  return Flexible(
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                color: hexToColor(controller
                        .mentorshipData.value?.data?.mentorshipInfoColor ??
                    ""),
                size: resWidth * 0.06),
            SizedBox(width: resWidth * 0.01),
            Text(
              int.parse(count) < 10 ? "0${count}" : count,
              style: TextStyle(
                fontSize: 15 * textScale,
                color: hexToColor(controller
                        .mentorshipData.value?.data?.mentorshipInfoColor ??
                    ""),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        SizedBox(height: resHeight * 0.01),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 12 * textScale,
            color: hexToColor(
                controller.mentorshipData.value?.data?.mentorshipInfoColor ??
                    ""),
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    ),
  );
}

class BottomCircularClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(0, size.height - 50);
    path.quadraticBezierTo(
        size.width / 2, size.height + 50, size.width, size.height - 50);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}

class MentorshipGradientText extends StatelessWidget {
  const MentorshipGradientText(
    this.text, {
    super.key,
    this.align,
    this.style,
    this.gradient, // Allows overriding the default gradient
  });

  final String text;
  final TextStyle? style;
  final TextAlign? align;
  final Gradient? gradient; // Made nullable to allow default

  static const Gradient defaultGradient = LinearGradient(
    colors: [
      Colors.red,
      Colors.deepPurple,
    ],
  );

  @override
  Widget build(BuildContext context) {
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: (bounds) => (gradient ?? defaultGradient).createShader(
        Rect.fromLTWH(0, 0, bounds.width, bounds.height),
      ),
      child: Text(
        text,
        style: style,
        textAlign: align,
      ),
    );
  }
}
