import 'package:flutter/material.dart';
import 'package:flutter_avif/flutter_avif.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/mentroship/controller/mentorship_detail_controller.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';

class UserNamePopUpWidget extends StatelessWidget {
  final String title;
  final String titleColor;
  final String description;
  final String descriptionColor;
  final String buttonTitle;
  final String buttonColor;
  final String buttonTextColor;
  final String imageUrl;
  final VoidCallback? onButtonPressed;

  UserNamePopUpWidget({
    required this.title,
    required this.titleColor,
    required this.description,
    required this.descriptionColor,
    required this.buttonTitle,
    required this.buttonColor,
    required this.buttonTextColor,
    required this.imageUrl,
    this.onButtonPressed,
  });
  @override
  Widget build(BuildContext context) {
    final TextEditingController nameController = TextEditingController();
    final MentorshipDetailController service =
    Get.put(MentorshipDetailController());
    final RootViewController rootViewController = Get.put(RootViewController());
    var mentorshipData = service.mentorshipDetailData.value;

    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    var bottomPadding = MediaQuery.of(context).viewPadding.bottom;

    return SafeArea(
      top: false, // Only protect bottom
      child: Padding(
        padding: EdgeInsets.only(bottom: bottomPadding),
        child: Container(
          decoration: BoxDecoration(
            color: hexToColor(mentorshipData?.mentorshipPopup.popUpBgColor ?? "#ffffff"),
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
              mainAxisSize: MainAxisSize.min,
              children: [
                if (imageUrl.isNotEmpty)
                  CircleAvatar(
                    backgroundColor: Colors.transparent,
                    radius: screenHeight * 0.08,
                    backgroundImage: NetworkImage(imageUrl),
                  ),
                SizedBox(height: 12),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 24 : 18,
                    fontWeight: FontWeight.bold,
                    color: hexToColor(titleColor),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: screenWidth > 600 ? 18 : 14,
                    color: hexToColor(descriptionColor),
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 10),
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
                GestureDetector(
                  onTap: () {
                    final userName = nameController.text.trim();
                    rootViewController.joinOnTap(userName);
                    Get.find<RootViewController>().getProfile();
                    service.onReload();
                  },
                  child: Container(
                    width: screenWidth * 0.92,
                    padding: EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    decoration: BoxDecoration(
                      color: hexToColor(buttonColor),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      buttonTitle,
                      style: TextStyle(
                        color: hexToColor(buttonTextColor),
                        fontSize: screenWidth > 600 ? 18 : 16,
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
