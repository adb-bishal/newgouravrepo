import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get_storage/get_storage.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:pulsator/pulsator.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stockpathshala_beta/mentroship/controller/mentorship_detail_controller.dart';
import 'package:stockpathshala_beta/mentroship/widget/showUserNamePopUp.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/hex_color.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/view/screens/subscription_view/new_subscription_view.dart';
import 'package:stockpathshala_beta/view/screens/subscription_view/subscription_view.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../model/services/auth_service.dart';
import '../../model/services/player/file_video_widget.dart';
import '../../model/utils/dimensions_resource.dart';
import '../../model/utils/style_resource.dart';
import '../../view/screens/root_view/batches/widgets/live_dot.dart';
import '../../view/screens/root_view/live_classes_view/live_class_detail/live_class_webview.dart';
import '../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../view/screens/root_view/quiz_view/quiz_list.dart';
import '../../view/widgets/alert_dialog_popup.dart';
import '../../view_model/controllers/root_view_controller/root_view_controller.dart';

class MentorshipDetailScreen extends StatefulWidget {

  @override
  State<MentorshipDetailScreen> createState() => _MentorshipDetailScreenState();
}

class _MentorshipDetailScreenState extends State<MentorshipDetailScreen> {
  // Create an instance of the service class
  final MentorshipDetailController service =
      Get.find<MentorshipDetailController>();

  @override
  Widget build(BuildContext context) {

    final size = MediaQuery.of(context).size;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isLargeScreen = size.width > 600;
    // String mentorshipId = Get.arguments['id'] ??"";
    //
    // // Fetch data when the screen is initialized
    // service.fetchMentorshipDataUI();
    // service.fetchMentorshipData(mentorshipId);

    return SafeArea(
      child: Scaffold(
        // appBar: AppBar(title: Text(service.mentorshipData.value?.mentorshipDetailFirst ?? "")),
        body: Obx(() {
          if (service.isLoading.value) {
            return _buildShimmerEffect(context);
          }

          if (service.errorMessage.isNotEmpty) {
            return Center(child: Text(service.errorMessage.value));
          }

          var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
          var mentorshipData = service.mentorshipDetailData.value;

          if (mentorship == null) {
            return Center(child: Text('No data found'));
          }

          String formatDate(DateTime date) {
            return DateFormat('dd MMM yyyy').format(date);
          }

          // Example usage
          final mentorshipStartDate = mentorshipData?.mentorshipStartDate;
          final mentorshipEndDate = mentorshipData?.mentorshipEndDate;
          DateTime serverDateTime = DateTime.parse(service.serverTime.value);
          final formattedStartDate = mentorshipStartDate != null
              ? formatDate(DateTime.parse(mentorshipStartDate))
              : formatDate(serverDateTime);
          // Format the end date. If it's null, use the current date.
          final formattedEndDate = mentorshipEndDate != null
              ? formatDate(DateTime.parse(mentorshipEndDate))
              : formatDate(serverDateTime);
          final mentorshipDuration = '$formattedStartDate - $formattedEndDate';
          // Example of using the fetched data
          return SafeArea(
            child: Stack(
              children: [
                RefreshIndicator(
                  onRefresh: () async {
                    // Logic to refresh data
                    service.onReload();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                hexToColor(mentorshipData?.isPlus == 1
                                    ? mentorship.mentorshipPlusCardBgColor1
                                    : mentorship.mentorshipCardBgColor1),
                                hexToColor(mentorshipData?.isPlus == 1
                                    ? mentorship.mentorshipPlusCardBgColor2
                                    : mentorship.mentorshipCardBgColor2),
                              ],
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                            ),
                            // borderRadius: BorderRadius.circular(12),
                          ),
                          child: LayoutBuilder(
                            builder: (context, constraints) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Stack(
                                    children: [
                                      Positioned(
                                        top: screenWidth < 500 ? 0 : 10,
                                        bottom: -10,
                                        left: 0,
                                        right: -20,
                                        child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: mentorshipData?.cardImage != null
                                              ? Image.network(
                                              mentorshipData!.cardImage)
                                              : Container(),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(16.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            GestureDetector(
                                                onTap: () {
                                                  Get.back();
                                                },
                                                child: Icon(
                                                  Icons.arrow_back_rounded,
                                                  color: Colors.white,
                                                  size:
                                                      screenWidth < 500 ? 22 : 28,
                                                )),
                                            const SizedBox(height: 10),
                                            Container(
                                               constraints: BoxConstraints(
                                                 maxWidth: MediaQuery.of(context).size.width*0.6
                                               ),
                                              child: Text(
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                                mentorshipData?.mentorshipTitle ??
                                                    '',
                                                style: TextStyle(

                                                  decoration:
                                                      TextDecoration.underline,
                                                  decorationColor: Colors.white,
                                                  // Optional: Change the color of the underline
                                                  decorationThickness: 1,
                                                  fontSize:
                                                      screenWidth < 500 ? 16 : 34,
                                                  fontWeight: FontWeight.bold,
                                                  color: hexToColor(mentorship
                                                      .mentorshipTitleColor),
                                                ),
                                              ),
                                            ),
                                            SizedBox(
                                                height:
                                                    screenWidth < 500 ? 8 : 20),
                                            ListView.builder(
                                              shrinkWrap: true,
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              itemCount:
                                                  mentorship?.property.length ??
                                                      0,
                                              itemBuilder: (context, index) {
                                                return Padding(
                                                    padding: EdgeInsets.symmetric(
                                                      vertical: 2,
                                                    ),
                                                    // Add some spacing if needed
                                                    child: _buildChip(
                                                        Icons.check_circle,
                                                        mentorship!
                                                            .property[index],
                                                        context));
                                              },
                                            ),
                                            SizedBox(
                                                height:
                                                    screenWidth < 500 ? 25 : 55),
                                            Row(
                                              children: [
                                                Icon(
                                                  Icons.calendar_today,
                                                  color: Colors.yellow,
                                                  size:
                                                      screenWidth < 500 ? 16 : 26,
                                                ),
                                                SizedBox(width: 5),
                                                Text(
                                                  mentorshipDuration,
                                                  style: TextStyle(
                                                      color: Colors.yellow,
                                                      fontSize: screenWidth < 500
                                                          ? 10
                                                          : 18,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.topRight,
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 6),
                                          margin:
                                              EdgeInsets.symmetric(vertical: 14),
                                          decoration: BoxDecoration(
                                            color: Color(0xFFFCF6CA),
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(12),
                                                bottomLeft: Radius.circular(12)),
                                          ),
                                          child: Wrap(
                                            crossAxisAlignment:
                                                WrapCrossAlignment.center,
                                            spacing: screenWidth * 0.014,
                                            children: [
                                              if (mentorshipData
                                                      ?.mentorshipStatus ==
                                                  "past")
                                                Image.asset(
                                                  ImageResource.instance.starIcon,
                                                  height: screenHeight * 0.02,
                                                  color:
                                                      ColorResource.orangeColor,
                                                ),
                                              Text(
                                                mentorshipData?.isPlus == 1
                                                    ? mentorship
                                                            .mentorshipPlusLabel
                                                            ?.toString() ??
                                                        ""
                                                    : mentorshipData
                                                                ?.mentorshipStatus ==
                                                            "past"
                                                        ? "${mentorshipData?.totalRatings?.toString() ?? ""}"
                                                        : "${mentorshipData?.seatsLeft?.toString() ?? ""} Seats Left",
                                                style: TextStyle(
                                                  fontSize:
                                                      isLargeScreen ? 12 : 10,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        bottom: screenWidth < 500 ? 5 : 20,
                                        left: 0,
                                        right: screenWidth < 500 ? 5 : 20,
                                        child: Align(
                                            alignment: Alignment.bottomRight,
                                            child: CachedNetworkImage(
                                              imageUrl: mentorship.stampIconUrl
                                                      ?.toString() ??
                                                  '',
                                              placeholder: (context, url) =>
                                                  Container(),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      Icon(Icons.error),
                                              height: isLargeScreen ? 70 : 50,
                                              width: isLargeScreen ? 70 : 50,
                                            )),
                                      ),
                                    ],
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: screenWidth < 500 ? 20 : 30),
                              Divider(
                                color: hexToColor(mentorship.quoteLineColor),
                                thickness: 2,
                                endIndent: screenWidth < 500 ? 15 : 10,
                                indent: screenWidth < 500 ? 15 : 10,
                              ),
                              Center(
                                child: Text(
                                  '“${mentorshipData?.quote ?? "Stock Pathshala"}”',
                                  style: TextStyle(
                                    fontFamily: 'Poly',
                                    fontStyle: FontStyle.italic,
                                    fontSize: screenWidth < 500 ? 18 : 42,
                                    fontWeight: FontWeight.bold,
                                    color: hexToColor(mentorship.quoteTextColor),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Divider(
                                color: hexToColor(mentorship.quoteLineColor),
                                thickness: 2,
                                endIndent: screenWidth < 500 ? 10 : 10,
                                indent: screenWidth < 500 ? 15 : 10,
                              ),
                              SizedBox(height: screenWidth < 500 ? 20 : 35),
                              _buildCurriculumSection(isLargeScreen, context),
                              SizedBox(height: 30),
                              _buildMentorInfo(context),
                              SizedBox(height: 30),
                              Divider(
                                color: Colors.grey,
                                thickness: screenWidth < 500 ? 1 : 3,
                              ),
                              Padding(
                                padding: EdgeInsets.only(
                                    left: 8.0, top: screenWidth < 500 ? 15 : 35),
                                child: Text(
                                  'FAQs',
                                  style: TextStyle(
                                    fontSize: screenWidth < 500 ? 18 : 32,
                                    fontWeight: FontWeight.w600,
                                    // color: hexToColor(mentorship.faqTitleColor),
                                  ),
                                ),
                              ),
                              _buildFAQSection(context),
                              SizedBox(height: 30),
                              _buildGuidanceSection(isLargeScreen, context),
                              SizedBox(height: 30),
                            ],
                          ),
                        ),
                        mentorshipData?.isPurchased != 0
                            ? Container()
                            : SizedBox(
                                height: isLargeScreen ? 120 : 100,
                              ),
                      ],
                    ),
                  ),
                ),
                mentorshipData?.isPurchased == 0
                    ? Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: _buildFooterSection(context),
                      )
                    : Container(),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _buildShimmerEffect(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final isLargeScreen = size.width > 600;

    return SingleChildScrollView(
      physics: ClampingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Container(
            height: size.height * 0.35,
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.grey[400]!, Colors.grey[300]!],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Shimmer.fromColors(
                  //   baseColor: Colors.grey[400]!,
                  //   highlightColor: Colors.grey[200]!,
                  //   period: Duration(milliseconds: 1000),
                  //   child: Container(
                  //     width: 40,
                  //     height: 40,
                  //     decoration: BoxDecoration(
                  //       color: Colors.grey,
                  //       borderRadius: BorderRadius.circular(8),
                  //     ),
                  //   ),
                  // ),
                  SizedBox(height: 16),

                  Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[200]!,
                    period: Duration(milliseconds: 1000),
                    child: Container(
                      height: 20,
                      width: size.width * 0.6,
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[200]!,
                    period: Duration(milliseconds: 1000),
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: 3,
                      itemBuilder: (context, index) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4.0),
                          child: Row(
                            children: [
                              Icon(Icons.circle, color: Colors.grey, size: 18),
                              SizedBox(width: 8),
                              Container(
                                height: 15,
                                width: size.width * 0.5,
                                decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(height: 16),
                  Shimmer.fromColors(
                    baseColor: Colors.grey[400]!,
                    highlightColor: Colors.grey[200]!,
                    period: Duration(milliseconds: 1000),
                    child: Row(
                      children: [
                        Icon(Icons.calendar_today,
                            color: Colors.grey, size: 16),
                        SizedBox(width: 8),
                        Container(
                          height: 15,
                          width: size.width * 0.3,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Quote Section
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
            child: Column(
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[200]!,
                  period: Duration(milliseconds: 1000),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                ),
                SizedBox(height: 16),
                Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[200]!,
                  period: Duration(milliseconds: 1000),
                  child: Container(
                    height: isLargeScreen ? 24 : 20,
                    width: size.width * 0.8,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[200]!,
                  period: Duration(milliseconds: 1000),
                  child: Divider(
                    color: Colors.grey,
                    thickness: 2,
                    indent: 15,
                    endIndent: 15,
                  ),
                ),
              ],
            ),
          ),

          // Curriculum Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[200]!,
                  period: Duration(milliseconds: 1000),
                  child: Container(
                    height: 20,
                    width: size.width * 0.4,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 3,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[400]!,
                        highlightColor: Colors.grey[200]!,
                        period: Duration(milliseconds: 1000),
                        child: Container(
                          height: size.height * 0.1,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // FAQ Section
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Shimmer.fromColors(
                  baseColor: Colors.grey[400]!,
                  highlightColor: Colors.grey[200]!,
                  period: Duration(milliseconds: 1000),
                  child: Container(
                    height: 20,
                    width: size.width * 0.3,
                    decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: 2,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Shimmer.fromColors(
                        baseColor: Colors.grey[400]!,
                        highlightColor: Colors.grey[200]!,
                        period: Duration(milliseconds: 1000),
                        child: Container(
                          height: size.height * 0.08,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitleSection(bool isLargeScreen) {
    var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
    var mentorshipData = service.mentorshipDetailData.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "What Will You Get?",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: hexToColor(mentorship?.classTitleColor)),
        ),
        SizedBox(height: 2),
        GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isLargeScreen ? 4 : 2,
              // Adjust columns for screen size
              // mainAxisSpacing: 2,
              crossAxisSpacing: 8,
              childAspectRatio: 6, // Adjust aspect ratio for layout
            ),
            itemCount: mentorship?.property.length,
            itemBuilder: (context, index) {
              return _buildChip(
                  Icons.check_circle, mentorship!.property[index], context);
            }),
      ],
    );
  }

  Widget _buildChip(IconData icon, String text, BuildContext context) {
    var mentorship = service.mentorshipDetailData.value;
    var resWidth = MediaQuery.of(context).size.width;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: resWidth < 500 ? 15 : 24,
        ),
        SizedBox(
          width: 5,
        ),
        Expanded(
          child: Builder(
            builder: (context) {
              // Get screen width using MediaQuery
              final screenWidth = MediaQuery.of(context).size.width;

              return Text(
                text,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.white,
                  fontSize: screenWidth < 500 ? 12.0 : 26.0,
                ),
              );
            },
          ),
        ),
      ],
    );

    //   Chip(
    //   avatar: Icon(icon, color: Colors.green),
    //   label: Text(text),
    //   backgroundColor: Colors.grey[200],
    // );
  }

  Widget _buildCurriculumSection(bool isLargeScreen, BuildContext context) {
    var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
    var mentorshipData = service.mentorshipDetailData.value;

    final curriculumItems = mentorshipData?.mentorshipClasses;
    final MentorshipDetailController controller =
        Get.find<MentorshipDetailController>();
    final screenWidth = MediaQuery.of(context).size.width;

    int lastTemporaryIndex = mentorshipData?.mentorshipClasses
            ?.lastIndexWhere((item) => item.temporaryClass == 1) ??
        -1;

   return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Text(
          "Mentorship Curriculum",
          style: TextStyle(
            fontSize: screenWidth < 500 ? 20.0 : 38.0,
            fontWeight: FontWeight.bold,
            color: hexToColor(mentorship?.classTitleColor),
          ),
        ),
        SizedBox(height: screenWidth < 500 ? 15 : 30),

        ...(() {
          int firstRecordedIndex = -1;
          for (int i = 0; i < curriculumItems!.length; i++) {
            if (curriculumItems![i].recordingUrl.isNotEmpty) {
              firstRecordedIndex = i;
              break;
            }
          }

          return List.generate(curriculumItems!.length, (index) {
            final item = curriculumItems![index];

            final screenWidth = MediaQuery.of(context).size.width;
            final serverDateTime = DateTime.parse(service.serverTime.value);

            final startDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(item.startDatetime);
            final endDate = DateFormat("yyyy-MM-dd HH:mm:ss").parse(item.endDatetime);

            final formattedDate = DateFormat('d MMM').format(startDate);
            final formattedStartTime = DateFormat('h:mm a').format(startDate);
            final formattedEndTime = DateFormat('h:mm a').format(endDate);

            final daysLeft = startDate.difference(serverDateTime).inDays;

            bool join = controller.currentDate.isAfter(startDate) &&
                controller.currentDate.isBefore(endDate);
            controller.showJoinButton.value = !join;

            bool showHours = DateTime.parse(item.startDatetime).difference(serverDateTime).inHours >= 24 ||
                DateTime.parse(item.startDatetime).difference(serverDateTime).inSeconds < 0;

            return Column(
              children: [
                if (index == firstRecordedIndex) ...[
                  SizedBox(height: 24),
                  ProfessionalDivider(
                    text: "Past Sessions",
                    textColor: Colors.black87,
                    color: Colors.grey.shade300,
                    thickness: 1,
                  ),
                  SizedBox(height: 16),
                ],

                _buildCurriculumItem(
                  onTapCallback: () {
                    if (mentorshipData?.isPurchased == 0) {
                      if (mentorshipData?.allowPurchase != 0) {
                        showBuyMentorshipPopup(
                          context: Get.context!,
                          title: controller.mentorshipDetailData.value?.mentorshipPopup.popUptitle ?? "",
                          subtitle: controller.mentorshipDetailData.value?.mentorshipPopup.popUpsubtitle ?? "",
                          buttonTitle: controller.mentorshipDetailData.value?.mentorshipPopup.popUpbuttonTitle ?? "",
                          imageUrl: controller.mentorshipDetailData.value?.mentorshipPopup.popUpImageUrl ?? "",
                        );
                      } else if (mentorshipData?.recommendedMentorship != null) {
                        showRecommendedMentorshipPopup(
                          context: Get.context!,
                          title: service.mentorshipDetailData.value?.recommendedMentorshipPopup.subtitle ?? "",
                          subtitle: service.mentorshipDetailData.value?.recommendedMentorship.title ?? "",
                          buttonTitle: service.mentorshipDetailData.value?.recommendedMentorshipPopup.buttonTitle ?? "",
                          imageUrl: service.mentorshipDetailData.value?.recommendedMentorshipPopup.imageUrl ?? "",
                        );
                      }
                    } else if (join || item.classStatus == "running") {
                      if (Get.find<AuthService>().user.value.name == null &&
                          controller.mentorshipDetailData.value?.userNamePrompt != null) {
                        showModalBottomSheet(
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.transparent,
                            builder: (BuildContext context) {
                              return SafeArea(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                    bottom: MediaQuery.of(context).viewInsets.bottom,
                                  ),
                                  child: UserNamePopUpWidget(
                                    title: controller.mentorshipDetailData.value?.userNamePrompt.prompttitle ?? "",
                                    description: controller.mentorshipDetailData.value?.userNamePrompt.promptdescription ?? "",
                                    buttonTitle: controller.mentorshipDetailData.value?.userNamePrompt.promptconfirmButton ?? "",
                                    imageUrl: controller.mentorshipDetailData.value?.userNamePrompt.promptimageUrl ?? "",
                                    titleColor: controller.mentorshipDetailData.value?.userNamePrompt.prompttitleColor ?? "",
                                    descriptionColor: controller.mentorshipDetailData.value?.userNamePrompt.promptdescriptionColor ?? "",
                                    buttonColor: controller.mentorshipDetailData.value?.userNamePrompt.promptconfirmButtonColor ?? "",
                                    buttonTextColor: controller.mentorshipDetailData.value?.userNamePrompt.promptconfirmBtnTextColor ?? "",
                                  ),
                                ),
                              );
                            }

                        );
                      } else {
                        toastShow(message: 'Joining...');
                        controller.joinForLiveClass(item.id, "join");
                        Future.delayed(Duration(seconds: 2), () async {
                          String link = Get.find<MentorshipDetailController>().participant.value.toString();
                          Navigator.push(
                            Get.context!,
                            MaterialPageRoute(
                              builder: (context) => LiveClassLaunch(
                                title: item.title ?? '',
                                url: link,
                              ),
                            ),
                          );
                          service.onReload();
                          toastShow(message: 'Class Joined');
                        });
                      }
                    } else if (item.recordingUrl.isNotEmpty) {
                      Get.to(FileVideoWidget(
                        url: item.recordingUrl,
                        isOrientation: false,
                        orientation: false,
                        eventCallBack: (progress, totalDuration) {},
                      ));
                    } else {
                      toastShow(message: 'Starting on $formattedDate. Be ready!');
                    }
                  },
                  date: formattedDate,
                  title: item.title.toString(),
                  duration: mentorshipData?.isPurchased != 0 && item.recordingUrl.isNotEmpty
                      ? "${item.duration.toString()} minutes"
                      : item.recordingUrl.isNotEmpty
                      ? mentorshipData?.mentorshipClasses[index].temporaryClass == 1
                      ? "upcoming"
                      : "${item.duration.toString()} minutes"
                      : '$formattedStartTime to $formattedEndTime',
                  status: mentorshipData?.isPurchased == 0
                      ? mentorship!.unlockButtonText.toString()
                      : join || item.classStatus == "running"
                      ? mentorship!.joinButtonText.toString()
                      : item.recordingUrl.isNotEmpty
                      ? mentorship!.recordingText.toString()
                      : "abc",
                  icon: Icons.check_box,
                  iconColor: mentorshipData?.isPurchased == 0
                      ? hexToColor(mentorship?.unlockButtonColor)
                      : join || item.classStatus == "running"
                      ? hexToColor(mentorship?.joinButtonColor)
                      : item.recordingUrl.isNotEmpty
                      ? Colors.transparent
                      : ColorResource.primaryColor,
                  isLargeScreen: isLargeScreen,
                  startDate: item.startDatetime,
                  endDate: item.endDatetime,
                  showHrs: showHours,
                  recording: item.recordingUrl,
                  join: join,
                  id: item.id,
                  index: index,
                  context: context,
                  daysLeft: daysLeft,
                  classStatus: item.classStatus.toString(),
                  isRegister: item.isRegister,
                  controller: controller,
                ),

                if (index != curriculumItems!.length - 1 && index + 1 != firstRecordedIndex)
                  Divider(
                    color: Colors.grey.shade300,
                    indent: 80,
                    endIndent: 20,
                  ),
              ],
            );
          });
        })(),
      ],
    );
  }

  Widget _buildCurriculumItem(
      {required String date,
      required String startDate,
      required String endDate,
      required Function()? onTapCallback, // Specify the function signature
      required String title,

        required int id,
      required int daysLeft,
      required int index,
      required BuildContext context,
      required String duration,
      required String status,
      required String recording,
      required IconData icon,
      required Color iconColor,
      required bool showHrs,
      required bool join,
      required String classStatus,
      required bool isLargeScreen,
      required int isRegister,
      controller}) {
    var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
    var mentorshipData = service.mentorshipDetailData.value;

    final MentorshipDetailController controller =
        Get.find<MentorshipDetailController>();
    var dateWord = date.split(' ');

    DateTime serverDateTime = DateTime.parse(service.serverTime.value);

    final now = DateTime.now();
    final startDateTime = DateTime.parse(startDate);
    final isClassStarted = startDateTime.isBefore(serverDateTime);
    print('startDate sdg: $startDate');
    print('startDate sdg: $isClassStarted');
    bool isDurationInMinutes = RegExp(r'^\d+\sminutes$').hasMatch(duration);
    return SafeArea(
      child: GestureDetector(
        onTap: onTapCallback,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [


          Container(
          width: isLargeScreen ? 70 : 50,
          height: isLargeScreen ? 70 : 50,
          decoration: isDurationInMinutes
              ? null
              : BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: isDurationInMinutes
                ? Container(
              width: 20,
              height: 20,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.green[500], // bg-green-500
                shape: BoxShape.circle,   // rounded-full
              ),
              child: Center(
                child: Icon(
                  Icons.check,
                  size: 12,
                  color: Colors.grey.shade50, // text-slate-50
                ),
              ),
            )
                : Text(
              mentorshipData?.mentorshipStatus == "past"
                  ? (index + 1).toString()
                  : '${dateWord[0]}\n${dateWord[1]}',
              maxLines: 2,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: isLargeScreen ? 19 : 15,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),




        // if (classStatus == "running")
              // Check if classStatus is running

              SizedBox(
                width: 8,
              ),
              Expanded(
                flex: 5,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              classStatus == "running"
                                  ? Expanded(
                                      child: Row(
                                        children: [
                                          Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              // crossAxisAlignment:
                                              //     CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: RichText(
                                                    maxLines: 3,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    text: TextSpan(
                                                      style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.w800,
                                                          color: hexToColor(
                                                              mentorship
                                                                  ?.classTitleColor),
                                                          fontSize: isLargeScreen
                                                              ? 23.4
                                                              : 14.4,
                                                          height: 1.3,
                                                          wordSpacing: 1,
                                                          letterSpacing: 0.3
                                                          // Increase line height
                                                          ),
                                                      children: [
                                                        WidgetSpan(
                                                          child: LiveDot(
                                                            left: 0,
                                                            top: 4,
                                                            height: 18,
                                                            width: 15,
                                                          ),
                                                        ),
                                                        TextSpan(
                                                          text: ' $title',
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : Expanded(
                                      child: Text(
                                        title,
                                        maxLines: 3,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: hexToColor(
                                              mentorship?.classTitleColor),
                                          fontSize: isLargeScreen ? 22 : 13,
                                        ),
                                      ),
                                    ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Icon(
                          Icons.access_time,
                          size: isLargeScreen ? 19 : 12,
                        ),
                        SizedBox(width: 5),
                        Text(
                          duration,
                          style: TextStyle(fontSize: isLargeScreen ? 18 : 11),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Empty container when the live class is not running

              mentorshipData?.isPurchased == 0 ||
                      join == true ||
                      recording.isNotEmpty
                  ? Expanded(
                      flex: 2,
                      child: GestureDetector(
                        onTap: onTapCallback,
                        child: Container(
                          padding: EdgeInsets.only(
                              left: 5, right: 5, top: 6, bottom: 6),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              color: iconColor,
                              borderRadius: BorderRadius.circular(16)),
                          child: Column(
                            children: [
                              mentorshipData?.isPurchased != 0 &&
                                      recording.isNotEmpty
                                  ? Icon(
                                      CupertinoIcons.play,
                                      size: 30,
                                    )
                                  : Container(),
                              Text(
                                status,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: mentorshipData?.isPurchased != 0 &&
                                          recording.isNotEmpty
                                      ? Colors.black
                                      : Colors.white,
                                  fontSize: isLargeScreen ? 14 : 12,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  : showHrs
                      ? controller.isRegisterList[index] == 1
                          ? classStatus != "running"
                              ? Container(
                                  padding: EdgeInsets.only(
                                      left: 10, right: 5, top: 6, bottom: 6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: hexToColor(
                                          mentorship?.timerButtonColor),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Row(
                                    children: [
                                      Text(
                                        "$daysLeft",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isLargeScreen ? 12 : 10,
                                        ),
                                      ),
                                      SizedBox(
                                        width: isLargeScreen ? 6 : 4,
                                      ),
                                      Text(
                                        "days left",
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: isLargeScreen ? 12 : 10,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              : Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      String? name =
                                          Get.find<AuthService>().user.value.name;

                                      print('sdfvswcdwes ${name}');
                                      if (Get.find<AuthService>()
                                                  .user
                                                  .value
                                                  .name ==
                                              null &&
                                          controller.mentorshipDetailData.value!
                                                  .userNamePrompt !=
                                              null) {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          // To control height based on content
                                          backgroundColor: Colors.transparent,
                                          // Make background transparent for custom design
                                          builder: (BuildContext context) {
                                            print("fdgfgeergv");
                                            return UserNamePopUpWidget(
                                              title: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .prompttitle ??
                                                  "hiii",
                                              description: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptdescription ??
                                                  "",
                                              buttonTitle: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptconfirmButton ??
                                                  "",
                                              imageUrl: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptimageUrl ??
                                                  "",
                                              titleColor: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .prompttitleColor ??
                                                  "",
                                              descriptionColor: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptdescriptionColor ??
                                                  "",
                                              buttonColor: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptconfirmButtonColor ??
                                                  "",
                                              buttonTextColor: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptconfirmBtnTextColor ??
                                                  "",
                                            );
                                          },
                                        );
                                      } else {
                                        toastShow(
                                            message: 'Joining... Please wait');
                                        controller.joinForLiveClass(id, "join");
                                        // Wait for 3 seconds before navigating to the next screen
                                        Future.delayed(Duration(seconds: 2),
                                            () async {
                                          String link = Get.find<
                                                  MentorshipDetailController>()
                                              .participant
                                              .value
                                              .toString();

                                          Navigator.push(
                                            Get.context!,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LiveClassLaunch(
                                                title: title ?? '',
                                                url: link,
                                              ),
                                            ),
                                          );

                                          service.onReload();

                                          // SharedPreferences mentorId =
                                          //     await SharedPreferences.getInstance();
                                          // String mentorIdValue =
                                          //     mentorId.getString('mId') ?? '';
                                          // service.fetchMentorshipDataUI();
                                          // service.fetchMentorshipData(mentorIdValue);

                                          toastShow(message: 'Class Joined');
                                          service.onReload();
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 6, bottom: 6),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: hexToColor(mentorship!
                                              .joinButtonColor
                                              .toString()),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Text(
                                        mentorship!.joinButtonText.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color:
                                              mentorshipData?.isPurchased != 0 &&
                                                      recording.isNotEmpty
                                                  ? Colors.black
                                                  : Colors.white,
                                          fontSize: isLargeScreen ? 14 : 12,
                                        ),
                                      ),
                                    ),
                                  ))
                          : Expanded(
                              flex: 2,
                              child: GestureDetector(
                                onTap: () async {
                                  String? name =
                                      Get.find<AuthService>().user.value.name;

                                  print('sdfvswcdwes ${name}');
                                  if (Get.find<AuthService>().user.value.name ==
                                          null &&
                                      controller.mentorshipDetailData.value!
                                              .userNamePrompt !=
                                          null) {
                                    showModalBottomSheet(
                                      context: context,
                                      isScrollControlled: true,
                                      // To control height based on content
                                      backgroundColor: Colors.transparent,
                                      // Make background transparent for custom design
                                      builder: (BuildContext context) {
                                        print("snhfkjhsdjkf");
                                        return UserNamePopUpWidget(
                                          title: controller
                                                  .mentorshipDetailData
                                                  .value!
                                                  .userNamePrompt
                                                  .prompttitle ??
                                              "hiii",
                                          description: controller
                                                  .mentorshipDetailData
                                                  .value!
                                                  .userNamePrompt
                                                  .promptdescription ??
                                              "",
                                          buttonTitle: controller
                                                  .mentorshipDetailData
                                                  .value!
                                                  .userNamePrompt
                                                  .promptconfirmButton ??
                                              "",
                                          imageUrl: controller
                                                  .mentorshipDetailData
                                                  .value!
                                                  .userNamePrompt
                                                  .promptimageUrl ??
                                              "",
                                          titleColor: controller
                                                  .mentorshipDetailData
                                                  .value!
                                                  .userNamePrompt
                                                  .prompttitleColor ??
                                              "",
                                          descriptionColor: controller
                                                  .mentorshipDetailData
                                                  .value!
                                                  .userNamePrompt
                                                  .promptdescriptionColor ??
                                              "",
                                          buttonColor: controller
                                                  .mentorshipDetailData
                                                  .value!
                                                  .userNamePrompt
                                                  .promptconfirmButtonColor ??
                                              "",
                                          buttonTextColor: controller
                                                  .mentorshipDetailData
                                                  .value!
                                                  .userNamePrompt
                                                  .promptconfirmBtnTextColor ??
                                              "",
                                        );
                                      },
                                    );
                                  } else {
                                    // controller.isRegisterList.clear();
                                    toastShow(message: 'registered... ');
                                    controller.onRegisterForLiveClass(
                                        id, "register");

                                    Timer(Duration(seconds: 1), () async {
                                      SharedPreferences mentorId =
                                          await SharedPreferences.getInstance();
                                      String mentorIdValue =
                                          mentorId.getString('mId') ?? '';
                                      controller
                                          .fetchMentorshipData(mentorIdValue);
                                    });

                                    SharedPreferences mentorId =
                                        await SharedPreferences.getInstance();
                                    String mentorIdValue =
                                        mentorId.getString('mId') ?? '';
                                    controller.fetchMentorshipData(mentorIdValue);
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 6, bottom: 6),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      color: ColorResource.primaryColor,
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Text(
                                    "Register",
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: isLargeScreen ? 14 : 12,
                                    ),
                                  ),
                                ),
                              ))

                      //  Obx(
                      //     () => !controller
                      //             .isAnyClassLessThanOneDay.value
                      //         ?

                      // : Container(
                      //     padding: EdgeInsets.only(
                      //         left: 5, right: 5, top: 6, bottom: 6),
                      //     decoration: BoxDecoration(
                      //         color: hexToColor(
                      //             mentorship?.timerButtonColor),
                      //         borderRadius:
                      //             BorderRadius.circular(16)),
                      //     child: Center(
                      //       child: TimerCountDown(
                      //         isHrShow: false,
                      //         timeInSeconds: int.parse(controller
                      //             .time.value
                      //             .replaceAll('s', '')),
                      //         isHrs: true,
                      //         fontStyle: StyleResource.instance
                      //             .styleBold(
                      //                 fontSize:
                      //                     isLargeScreen ? 12 : 10,
                      //                 fontWeight: FontWeight.normal,
                      //                 color: ColorResource.white),
                      //         remainingSeconds: (second) {
                      //           if (second <= 120) {
                      //             EasyDebounce.debounce(
                      //                 controller.countValue.value
                      //                     .toString(),
                      //                 const Duration(
                      //                     milliseconds: 1000),
                      //                 () async {
                      //               controller.isStarted.value = true;
                      //             });
                      //           }
                      //         },
                      //       ),
                      //     ),
                      //   ),
                      // )

                      : Container(),

              !showHrs && mentorshipData?.isPurchased != 0
                  ? Obx(() => controller.isRegisterList[index] == 0
                      ? Expanded(
                          flex: 2,
                          child: GestureDetector(
                            onTap: () async {
                              String? name =
                                  Get.find<AuthService>().user.value.name;

                              print('sdfvswcdwes ${name}');
                              if (Get.find<AuthService>().user.value.name ==
                                      null &&
                                  controller.mentorshipDetailData.value!
                                          .userNamePrompt !=
                                      null) {
                                showModalBottomSheet(
                                  context: context,
                                  isScrollControlled: true,
                                  // To control height based on content
                                  backgroundColor: Colors.transparent,
                                  // Make background transparent for custom design
                                  builder: (BuildContext context) {
                                    print("snhfkjhsdjkffgdfg");
                                    return UserNamePopUpWidget(
                                      title: controller
                                              .mentorshipDetailData
                                              .value!
                                              .userNamePrompt
                                              .prompttitle ??
                                          "hiii",
                                      description: controller
                                              .mentorshipDetailData
                                              .value!
                                              .userNamePrompt
                                              .promptdescription ??
                                          "",
                                      buttonTitle: controller
                                              .mentorshipDetailData
                                              .value!
                                              .userNamePrompt
                                              .promptconfirmButton ??
                                          "",
                                      imageUrl: controller
                                              .mentorshipDetailData
                                              .value!
                                              .userNamePrompt
                                              .promptimageUrl ??
                                          "",
                                      titleColor: controller
                                              .mentorshipDetailData
                                              .value!
                                              .userNamePrompt
                                              .prompttitleColor ??
                                          "",
                                      descriptionColor: controller
                                              .mentorshipDetailData
                                              .value!
                                              .userNamePrompt
                                              .promptdescriptionColor ??
                                          "",
                                      buttonColor: controller
                                              .mentorshipDetailData
                                              .value!
                                              .userNamePrompt
                                              .promptconfirmButtonColor ??
                                          "",
                                      buttonTextColor: controller
                                              .mentorshipDetailData
                                              .value!
                                              .userNamePrompt
                                              .promptconfirmBtnTextColor ??
                                          "",
                                    );
                                  },
                                );
                              } else {
                                // controller.isRegisterList.clear();
                                toastShow(message: 'registered down... ');
                                controller.onRegisterForLiveClass(id, "register");

                                Timer(Duration(seconds: 1), () async {
                                  SharedPreferences mentorId =
                                      await SharedPreferences.getInstance();
                                  String mentorIdValue =
                                      mentorId.getString('mId') ?? '';
                                  controller.fetchMentorshipData(mentorIdValue);
                                });

                                SharedPreferences mentorId =
                                    await SharedPreferences.getInstance();
                                String mentorIdValue =
                                    mentorId.getString('mId') ?? '';
                                controller.fetchMentorshipData(mentorIdValue);
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 5, right: 5, top: 6, bottom: 6),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  color: ColorResource.primaryColor,
                                  borderRadius: BorderRadius.circular(16)),
                              child: Text(
                                "Register",
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: isLargeScreen ? 14 : 12,
                                ),
                              ),
                            ),
                          ))
                      : Obx(() {
                          int timeInSeconds =
                              int.tryParse(controller.time[index].trim()) ?? 0;
                          return timeInSeconds > 0
                              ? Container(
                                  padding: EdgeInsets.only(
                                      left: 5, right: 5, top: 6, bottom: 6),
                                  decoration: BoxDecoration(
                                      color: hexToColor(
                                          mentorship?.timerButtonColor),
                                      borderRadius: BorderRadius.circular(16)),
                                  child: Center(
                                    child: TimerCountDown(
                                      isHrShow: false,
                                      timeInSeconds: int.parse(
                                          controller.time[index].trim()),
                                      isHrs: true,
                                      fontStyle: StyleResource.instance.styleBold(
                                          fontSize: isLargeScreen ? 14 : 12,
                                          fontWeight: FontWeight.normal,
                                          color: ColorResource.white),
                                      remainingSeconds: (second) {
                                        if (second <= 120) {
                                          EasyDebounce.debounce(
                                              controller.countValue.value
                                                  .toString(),
                                              const Duration(milliseconds: 1000),
                                              () async {
                                            controller.isStarted.value = true;
                                          });
                                        }
                                      },
                                    ),
                                  ),
                                )
                              : Expanded(
                                  flex: 2,
                                  child: GestureDetector(
                                    onTap: () {
                                      String? name =
                                          Get.find<AuthService>().user.value.name;

                                      print('sdfvswcdwes ${name}');
                                      if (Get.find<AuthService>()
                                                  .user
                                                  .value
                                                  .name ==
                                              null &&
                                          controller.mentorshipDetailData.value!
                                                  .userNamePrompt !=
                                              null) {
                                        showModalBottomSheet(
                                          context: context,
                                          isScrollControlled: true,
                                          // To control height based on content
                                          backgroundColor: Colors.transparent,
                                          // Make background transparent for custom design
                                          builder: (BuildContext context) {
                                            print("hjklioeretert");
                                            return UserNamePopUpWidget(
                                              title: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .prompttitle ??
                                                  "hiii",
                                              description: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptdescription ??
                                                  "",
                                              buttonTitle: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptconfirmButton ??
                                                  "",
                                              imageUrl: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptimageUrl ??
                                                  "",
                                              titleColor: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .prompttitleColor ??
                                                  "",
                                              descriptionColor: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptdescriptionColor ??
                                                  "",
                                              buttonColor: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptconfirmButtonColor ??
                                                  "",
                                              buttonTextColor: controller
                                                      .mentorshipDetailData
                                                      .value!
                                                      .userNamePrompt
                                                      .promptconfirmBtnTextColor ??
                                                  "",
                                            );
                                          },
                                        );
                                      } else {
                                        toastShow(
                                            message: 'Joining... Please wait');
                                        controller.joinForLiveClass(id, "join");
                                        // Wait for 3 seconds before navigating to the next screen
                                        Future.delayed(Duration(seconds: 2),
                                            () async {
                                          String link = Get.find<
                                                  MentorshipDetailController>()
                                              .participant
                                              .value
                                              .toString();

                                          Navigator.push(
                                            Get.context!,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  LiveClassLaunch(
                                                title: title ?? '',
                                                url: link,
                                              ),
                                            ),
                                          );

                                          service.onReload();

                                          // SharedPreferences mentorId =
                                          //     await SharedPreferences.getInstance();
                                          // String mentorIdValue =
                                          //     mentorId.getString('mId') ?? '';
                                          // service.fetchMentorshipDataUI();
                                          // service.fetchMentorshipData(mentorIdValue);

                                          toastShow(message: 'Class Joined');
                                          service.onReload();
                                        });
                                      }
                                    },
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          left: 5, right: 5, top: 6, bottom: 6),
                                      alignment: Alignment.center,
                                      decoration: BoxDecoration(
                                          color: hexToColor(mentorship!
                                              .joinButtonColor
                                              .toString()),
                                          borderRadius:
                                              BorderRadius.circular(16)),
                                      child: Text(
                                        mentorship!.joinButtonText.toString(),
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          color:
                                              mentorshipData?.isPurchased != 0 &&
                                                      recording.isNotEmpty
                                                  ? Colors.black
                                                  : Colors.white,
                                          fontSize: isLargeScreen ? 12 : 10,
                                        ),
                                      ),
                                    ),
                                  ));
                        }))
                  : Container(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMentorInfo(BuildContext context) {
    var mentorshipData = service.mentorshipDetailData.value;
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    bool isLargeScreen =
        screenWidth > 600; // Treat screens wider than 600px as large

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          service.mentorshipDetailData.value?.mentorshipDetailUI
                  ?.tutorInfoTitle ??
              "Know About Your Mentor.!",
          style: TextStyle(
            fontSize: isLargeScreen ? 22 : 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        SizedBox(height: screenHeight * 0.02), // Dynamic spacing

        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Profile Image (Responsive)
            Container(
              width: isLargeScreen ? 120 : 80,
              height: isLargeScreen ? 120 : 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                image: DecorationImage(
                  image: NetworkImage(service
                      .mentorshipDetailData.value!.teacher.profile_image),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: screenWidth * 0.03),

            // Mentor Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Mentor Name
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.005),
                    child: Text(
                      mentorshipData!.teacher.name,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        fontSize: isLargeScreen ? 22 : 18,
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.01),

                  // Experience Row
                  _buildInfoRow(
                    icon: Icons.check_circle_outlined,
                    text:
                        "${mentorshipData.teacher.totalExperience}+ Years Trading Experience",
                  ),

                  // Live Classes Row (Only if available)
                  if (mentorshipData.teacher.totalLiveClasses != null &&
                      mentorshipData.teacher.totalLiveClasses > 0)
                    _buildInfoRow(
                      icon: Icons.check_circle_outlined,
                      text:
                          "${mentorshipData.teacher.totalLiveClasses}+ LIVE Classes",
                    ),

                  // Hours of Teaching (Only if available)
                  if (mentorshipData.teacher.hoursOfTeaching != null &&
                      mentorshipData.teacher.hoursOfTeaching > 0)
                    _buildInfoRow(
                      icon: Icons.check_circle_outlined,
                      text:
                          "${mentorshipData.teacher.hoursOfTeaching}+ Hours of Teaching",
                    ),

                  // Certification (Only if available)
                  if (mentorshipData.teacher.certificationText != null &&
                      mentorshipData.teacher.certificationText.isNotEmpty)
                    _buildInfoRow(
                      icon: Icons.check_circle_outlined,
                      text: mentorshipData.teacher.certificationText,
                    ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

// Helper function to build rows dynamically
  Widget _buildInfoRow({required IconData icon, required String text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 3.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.green, size: 18),
          SizedBox(width: 8),
          Flexible(
            child: Text(
              text,
              style: TextStyle(fontWeight: FontWeight.w400),
              overflow: TextOverflow.ellipsis, // Handle long text gracefully
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFAQSection(BuildContext context) {
    var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
    var mentorshipData = service.mentorshipDetailData.value;
    final screenWidth = MediaQuery.of(context).size.width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Adding FAQs from the mentorship data
        if (mentorshipData?.faqs != null && mentorshipData!.faqs.isNotEmpty)
          ...?mentorshipData?.faqs.map(
            (faq) {
              return Padding(
                padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                child: Container(
                  child: Theme(
                    data: ThemeData(
                      splashColor: Colors.transparent,
                      highlightColor: Colors.transparent,
                    ),
                    child: ExpansionTile(
                      tilePadding: EdgeInsets.zero,
                      title: Text(
                        faq.question ?? "No question provided",
                        // Fallback text if no question
                        style: TextStyle(
                          fontSize: screenWidth < 500 ? 14 : 18,
                          fontWeight: FontWeight.w700,
                          color: hexToColor(mentorship
                              ?.faqQuestionColor), // Custom color for question
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Text(
                            faq.answer ?? "No answer provided",
                            // Fallback text if no answer
                            style: TextStyle(
                              fontSize: screenWidth < 500 ? 12 : 18,
                              color: hexToColor(mentorship
                                  ?.faqAnswerColor), // Custom color for answer
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ).toList(),
      ],
    );
  }

  Widget _buildGuidanceSection(bool isLargeScreen, BuildContext context) {
    var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CircleAvatar(
            radius: screenWidth < 500
                ? isLargeScreen
                    ? 40
                    : 30
                : isLargeScreen
                    ? 50
                    : 30,
            backgroundImage: NetworkImage(mentorship?.callbackImageUrl ??
                ''), // Replace with actual image URL
          ),
          const SizedBox(height: 16),
          Text(
            mentorship?.callbackTitle ?? "Need Olympiads guidance?",
            style: TextStyle(
                fontSize: screenWidth < 500
                    ? isLargeScreen
                        ? 22
                        : 20
                    : isLargeScreen
                        ? 30
                        : 20,
                fontWeight: FontWeight.bold,
                color: hexToColor(mentorship?.callbackTitleColor)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 5),
          Text(
            mentorship?.callbackSubtitle ??
                "Our counsellors can help you guide for your Olympiads preparation.",
            style: TextStyle(
                fontSize: screenWidth < 500 ? 14 : 20,
                color: hexToColor(mentorship?.callbackSubtitleColor)),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenWidth < 500 ? 10 : 18),
          InkWell(
            onTap: () {
              if (Get.find<AuthService>().isGuestUser.value) {
                Get.find<RootViewController>().showOpenAccountDialog();
              } else {
                PermissionAlertDialog(
                        title: null,
                        message: null,
                        positiveButton: "Yes",
                        negativeButton: "no")
                    .present(context, onPositiveAction: () {
                  Get.find<RootViewController>().userNameController.value.text =
                      Get.find<AuthService>().user.value.name ?? "";
                  Get.find<RootViewController>().numberController.value.text =
                      Get.find<AuthService>().user.value.mobileNo ?? "";
                  Get.find<RootViewController>().onOpenTradingAccount(context);
                  Get.back();
                });
              }
            },
            splashColor: Colors.deepPurpleAccent.withOpacity(0.3),
            // Splash color
            highlightColor: Colors.transparent,
            borderRadius: BorderRadius.circular(12),

            child: screenWidth < 500
                ? Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    // margin: EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.black)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.black),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          mentorship?.callbackButtonText ??
                              "Arrange A Callback",
                          style: TextStyle(
                              fontSize: screenWidth < 500
                                  ? isLargeScreen
                                      ? 18
                                      : 16
                                  : isLargeScreen
                                      ? 20
                                      : 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.only(left: 38.0, right: 38.0),
                    child: Column(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(18),
                            border: Border.all(color: Colors.black),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Icon(Icons.phone, color: Colors.black),
                              SizedBox(
                                width: 10,
                              ),
                              Text(
                                mentorship?.callbackButtonText ??
                                    "Arrange A Callback",
                                style: TextStyle(
                                  fontSize: screenWidth < 500
                                      ? isLargeScreen
                                          ? 18
                                          : 16
                                      : isLargeScreen
                                          ? 20
                                          : 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(
                          height: 20, // Adjust the height as needed
                        ),
                      ],
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildFooterSection(BuildContext context) {
    var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
    var mentorshipData = service.mentorshipDetailData.value;
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      color: hexToColor(mentorship?.footerBgColor),
      padding: EdgeInsets.only(top: 18, bottom: 20, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            mentorship?.footerTitle ??
                "✔ Complimentary Yearly Plan Worth ₹4999/-",
            style: TextStyle(
              fontSize: screenWidth < 500 ? 12 : 22,
              color: hexToColor(mentorship?.footerTitleColor),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: screenWidth < 500 ? 16 : 36),
          ElevatedButton(
            onPressed: () {
              if (mentorshipData?.allowPurchase != 0) {
                Get.toNamed(Routes.subscriptionView, arguments: {
                  'isMentorShow': true,
                  'title': mentorshipData?.mentorshipDetailFirst.toString(),
                  'price': mentorshipData?.price.toString(),
                  'daysleft': mentorshipData?.daysLeft == null
                      ? "0"
                      : mentorshipData?.daysLeft.toString(),
                });
              } else if (mentorshipData?.recommendedMentorship != null) {
                showRecommendedMentorshipPopup(
                    context: Get.context!,
                    title: service.mentorshipDetailData.value!
                            .recommendedMentorshipPopup.subtitle ??
                        "",
                    subtitle: service.mentorshipDetailData.value!
                            .recommendedMentorship.title ??
                        "",
                    buttonTitle: service.mentorshipDetailData.value!
                            .recommendedMentorshipPopup.buttonTitle ??
                        "",
                    imageUrl: service.mentorshipDetailData.value!
                            .recommendedMentorshipPopup.imageUrl ??
                        "");
              }
              ;
            },
            child: Text(
              mentorship?.footerButtonText ?? "Join this Batch",
              style: TextStyle(
                fontSize: screenWidth < 500 ? 16 : 24,
                fontWeight: FontWeight.bold,
                color: hexToColor(mentorship?.footerButtonTextColor),
              ),
            ),
            style: screenWidth < 500
                ? ElevatedButton.styleFrom(
                    backgroundColor:
                        hexToColor(mentorship?.footerButtonBgColor),
                    padding: EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    minimumSize: Size(double.infinity, 50), // Full-width button
                  )
                : ElevatedButton.styleFrom(
                    backgroundColor:
                        hexToColor(mentorship?.footerButtonBgColor),
                    padding: EdgeInsets.symmetric(
                      vertical: 16, // Keep the vertical padding constant
                      horizontal: MediaQuery.of(context).size.width > 500
                          ? 200
                          : 0, // Add horizontal padding if screen size > 500
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize:
                        Size(double.minPositive, 50), // Full-width button
                  ),
          ),
          SizedBox(
            height: 8,
          )
        ],
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

void showBuyMentorshipPopup({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String buttonTitle,
  required String imageUrl,
  VoidCallback? onButtonPressed,
}) {
  final MentorshipDetailController service =
      Get.find<MentorshipDetailController>();
  var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
  var mentorshipData = service.mentorshipDetailData.value;
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // To control height based on content
    backgroundColor:
        Colors.transparent, // Make background transparent for custom design
    builder: (BuildContext context) {
      // Get the screen size
      var screenWidth = MediaQuery.of(context).size.width;
      var screenHeight = MediaQuery.of(context).size.height;

      return Container(
        decoration: BoxDecoration(
          color: hexToColor(
              mentorshipData!.mentorshipPopup.popUpBgColor ?? "#ffffff"),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust dialog size to content
            children: [
              // Circle Avatar Section (Image)
              CircleAvatar(
                radius:
                    screenHeight * 0.09, // Adjust size based on screen height
                backgroundImage: NetworkAvifImage(imageUrl),
                // backgroundColor: Colors.transparent,
              ),
              SizedBox(height: 16),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth > 600
                      ? 24
                      : 18, // Adjust title size for larger screens
                  fontWeight: FontWeight.bold,
                  color: hexToColor(
                      mentorshipData!.mentorshipPopup.popUpTitleColor ??
                          "#ffffff"),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              // Subtitle
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: screenWidth > 600
                      ? 18
                      : 14, // Adjust subtitle size for larger screens
                  color: hexToColor(
                      mentorshipData!.mentorshipPopup.popUpSubtitleColor ??
                          "#ffffff"),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              // Action Button
              GestureDetector(
                onTap: () {
                  Get.toNamed(Routes.subscriptionView, arguments: {
                    'isMentorShow': true,
                    'title': mentorshipData?.mentorshipDetailFirst.toString(),
                    'price': mentorshipData?.price.toString(),
                    'daysleft': mentorshipData?.daysLeft == null
                        ? "0"
                        : mentorshipData?.daysLeft.toString(),
                  });

                  ;
                },
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  decoration: BoxDecoration(
                    color: hexToColor(
                        mentorshipData!.mentorshipPopup.popUpButtonBgColor ??
                            "#ffffff"), // Custom color for the button
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    buttonTitle,
                    style: TextStyle(
                      color: hexToColor(mentorshipData!
                              .mentorshipPopup.popUpButtonTextColor ??
                          "#000000"),
                      fontSize: screenWidth > 600
                          ? 18
                          : 16, // Adjust font size based on screen width
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

void showRecommendedMentorshipPopup({
  required BuildContext context,
  required String title,
  required String subtitle,
  required String buttonTitle,
  required String imageUrl,
  VoidCallback? onButtonPressed,
}) {
  final MentorshipDetailController service =
      Get.find<MentorshipDetailController>();
  var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
  var mentorshipData = service.mentorshipDetailData.value;

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // To control height based on content
    backgroundColor:
        Colors.transparent, // Make background transparent for custom design
    builder: (BuildContext context) {
      // Get the screen size
      var screenWidth = MediaQuery.of(context).size.width;
      var screenHeight = MediaQuery.of(context).size.height;

      return SizedBox(
        width: screenWidth,
        // Set the height to two-thirds of the screen height
        child: Container(
          decoration: BoxDecoration(
            color: hexToColor(
                mentorshipData!.recommendedMentorshipPopup.popupBgColor ??
                    "#ffffff"),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Adjust dialog size to content
              children: [
                // Circle Avatar Section (Image)
                CircleAvatar(
                  radius:
                      screenHeight * 0.09, // Adjust size based on screen height
                  backgroundImage: NetworkImage(imageUrl),
                ),
                SizedBox(height: 16),
                // Title
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth > 600
                        ? 24
                        : 18, // Adjust title size for larger screens
                    fontWeight: FontWeight.bold,
                    color: hexToColor(
                        mentorshipData!.recommendedMentorshipPopup.titleColor ??
                            "#ffffff"),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                // Subtitle
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: screenWidth > 600
                        ? 18
                        : 14, // Adjust subtitle size for larger screens
                    color: hexToColor(mentorshipData!
                            .recommendedMentorshipPopup.subtitleColor ??
                        "#ffffff"),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 16),
                // Action Button
                GestureDetector(
                  onTap: () {
                    Get.back();
                    Get.offNamed(
                      Routes.mentorshipDetail(
                        id: service.mentorshipDetailData.value!
                            .recommendedMentorship.id
                            .toString(),
                      ),
                      arguments: {
                        'id': service.mentorshipDetailData.value!
                            .recommendedMentorship.id
                            .toString(),
                      },
                    );
                  },
                  child: Container(
                    width: screenWidth *
                        0.8, // Keep the button width 80% of the screen width
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    decoration: BoxDecoration(
                      color: hexToColor(mentorshipData!
                              .recommendedMentorshipPopup.buttonBgColor ??
                          "#ffffff"), // Custom color for the button
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      buttonTitle,
                      style: TextStyle(
                        color: hexToColor(mentorshipData!
                                .recommendedMentorshipPopup.buttonTextColor ??
                            "#000000"),
                        fontSize: screenWidth > 600
                            ? 18
                            : 16, // Adjust font size based on screen width
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}

void showUserNamePopUp({
  required BuildContext context,
  required String title,
  required String titleColor,
  required String description,
  required String descriptionColor,
  required String buttonTitle,
  required String buttonColor,
  required String buttonTextColor,
  required String imageUrl,
  VoidCallback? onButtonPressed,
}) {
  final MentorshipDetailController service =
      Get.find<MentorshipDetailController>();
  var mentorship = service.mentorshipDetailData.value?.mentorshipDetailUI;
  var mentorshipData = service.mentorshipDetailData.value;

  // Controller to handle text input
  final TextEditingController nameController = TextEditingController();

  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // To control height based on content
    backgroundColor:
        Colors.transparent, // Make background transparent for custom design
    builder: (BuildContext context) {
      // Get the screen size
      var screenWidth = MediaQuery.of(context).size.width;
      var screenHeight = MediaQuery.of(context).size.height;

      return Container(
        decoration: BoxDecoration(
          color: hexToColor(
              mentorshipData!.mentorshipPopup.popUpBgColor ?? "#ffffff"),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
        ),
        child: Padding(
          padding: EdgeInsets.only(
            left: 16.0,
            right: 16.0,
            top: 16.0,
            bottom: MediaQuery.of(context).viewInsets.bottom + 16.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjust dialog size to content
            children: [
              // Circle Avatar Section (Image)
              CircleAvatar(
                radius:
                    screenHeight * 0.09, // Adjust size based on screen height
                backgroundImage: NetworkAvifImage(imageUrl),
              ),
              SizedBox(height: 16),
              // Title
              Text(
                title,
                style: TextStyle(
                  fontSize: screenWidth > 600
                      ? 24
                      : 18, // Adjust title size for larger screens
                  fontWeight: FontWeight.bold,
                  color: hexToColor(titleColor ?? "#ffffff"),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 8),
              // Subtitle
              Text(
                description,
                style: TextStyle(
                  fontSize: screenWidth > 600
                      ? 18
                      : 14, // Adjust subtitle size for larger screens
                  color: hexToColor(descriptionColor ?? "#ffffff"),
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 16),
              // TextField for Name Input
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  hintText: "Enter your name",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              // Action Button
              GestureDetector(
                onTap: () {
                  final userName = nameController.text.trim();
                  if (userName.isEmpty) {
                    // Show an error message if the name is not entered
                    Get.snackbar(
                      "Error",
                      "Please enter your name",
                      backgroundColor: ColorResource.mateRedColor,
                      colorText: Colors.white,
                    );
                    return;
                  }
                  // Handle button action here
                  Get.toNamed(Routes.subscriptionView, arguments: {
                    'isMentorShow': true,
                    'title': mentorshipData?.mentorshipDetailFirst.toString(),
                    'price': mentorshipData?.price.toString(),
                    'daysleft': mentorshipData?.daysLeft == null
                        ? "0"
                        : mentorshipData?.daysLeft.toString(),
                    'userName': userName, // Pass the user's name
                  });
                },
                child: Container(
                  width: screenWidth * 0.8,
                  padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                  decoration: BoxDecoration(
                    color: hexToColor(
                        mentorshipData.mentorshipPopup.popUpButtonBgColor ??
                            "#ffffff"), // Custom color for the button
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    buttonTitle,
                    style: TextStyle(
                      color: hexToColor(buttonTextColor ?? "#000000"),
                      fontSize: screenWidth > 600
                          ? 18
                          : 16, // Adjust font size based on screen width
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );
}

class BlinkerWidget extends StatelessWidget {
  const BlinkerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 20,
      height: 20,
      child: Pulsator(
        style: const PulseStyle(color: Colors.red),
        count: 3,
        duration: const Duration(seconds: 4),
        repeat: 0,
        startFromScratch: false,
        autoStart: true,
        fit: PulseFit.contain,
        child: CircleAvatar(
          backgroundColor: ColorResource.redColor,
          radius: 2,
          child: CircleAvatar(
            backgroundColor: ColorResource.white,
            radius: 7,
            child: CircleAvatar(
              backgroundColor: ColorResource.redColor,
              radius: 5,
              child: CircleAvatar(
                backgroundColor: ColorResource.white,
                radius: 4.75,
                child: Visibility(
                  child: const CircleAvatar(
                    backgroundColor: ColorResource.redColor,
                    radius: 3,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
