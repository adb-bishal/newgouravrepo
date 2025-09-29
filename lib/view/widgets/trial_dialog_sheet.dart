// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stockpathshala_beta/model/services/auth_service.dart';
// import 'package:stockpathshala_beta/model/utils/color_resource.dart';
// import 'package:stockpathshala_beta/model/utils/hex_color.dart';
// import 'package:stockpathshala_beta/model/utils/string_resource.dart';
// import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
// import 'package:stockpathshala_beta/view/widgets/custom_dialog_box.dart';
// import 'package:stockpathshala_beta/view/widgets/diagonal_strike_widget';
// import 'package:stockpathshala_beta/view/widgets/text_field_view/common_textfield.dart';
// import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
// import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
// import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
//
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:stockpathshala_beta/model/services/auth_service.dart';
// import 'package:stockpathshala_beta/model/utils/color_resource.dart';
// import 'package:stockpathshala_beta/model/utils/hex_color.dart';
// import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
// import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
// import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
// import 'package:flutter/services.dart'; //
//
// class TrialDialogSheet extends StatefulWidget {
//   final String heading;
//   final String title1;
//   final int days;
//   final String subTitle1;
//   final String title2;
//   final String subTitle2;
//   final String title3;
//   final String subTitle3;
//   final String title4;
//   final String subTitle4;
//   final String description;
//   final VoidCallback onClose;
//   final VoidCallback onContinue;
//   final String image2;
//   final String image1;
//   final String image3;
//   final String image4;
//   final String descriptionColor;
//   final String titleColorAll;
//   final String titleColorText;
//   final String headingColor;
//   final String bgType;
//   final String bgColor;
//   final String bgImage;
//   final TextEditingController emailController;
//
//   const TrialDialogSheet({
//     Key? key,
//     required this.heading,
//     required this.title1,
//     required this.days,
//     required this.subTitle1,
//     required this.title2,
//     required this.subTitle2,
//     required this.title3,
//     required this.subTitle3,
//     required this.title4,
//     required this.subTitle4,
//     required this.description,
//     required this.onClose,
//     required this.onContinue,
//     required this.image2,
//     required this.image1,
//     required this.image3,
//     required this.image4,
//     required this.descriptionColor,
//     required this.titleColorAll,
//     required this.titleColorText,
//     required this.headingColor,
//     required this.bgType,
//     required this.bgColor,
//     required this.bgImage,
//     required this.emailController,
//   }) : super(key: key);
//
//   @override
//   CustomDialogState createState() => CustomDialogState();
// }
//
// class CustomDialogState extends State<TrialDialogSheet>
//     with SingleTickerProviderStateMixin {
//   /// Initialize the controller here
//   final LoginController controller = Get.put(LoginController());
//   double progress = 0.25;
//   late AnimationController _controller;
//
//   @override
//   void initState() {
//     super.initState();
//     _controller =
//         AnimationController(vsync: this, duration: const Duration(seconds: 4));
//
//     /// Start progress animation
//   //   startProgress();
//   //     SystemChrome.setEnabledSystemUIMode(
//   //   SystemUiMode.manual,
//   //   overlays: [
//   //     SystemUiOverlay.top,    // Status bar
//   //     SystemUiOverlay.bottom, // Navigation bar
//   //   ],
//   // );
//     // SystemChrome.setSystemUIOverlayStyle(
//     //   const SystemUiOverlayStyle(
//     //     systemNavigationBarColor: Colors.transparent,
//     //     systemNavigationBarIconBrightness: Brightness.dark,
//     //     statusBarColor: Colors.transparent,
//     //     statusBarIconBrightness: Brightness.dark,
//     //   ),
//     // );
//   }
//
//   void startProgress() {
//     Future.delayed(const Duration(milliseconds: 600), () {
//       if (progress < 1.0) {
//         setState(() {
//           progress += 0.25;
//         });
//         startProgress();
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _controller.dispose();
//
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: Container(
//         decoration: BoxDecoration(
//           color: widget.bgType == 'color'
//               ? Color(int.parse(widget.bgColor.replaceFirst('#', '0xff')))
//               : Colors.transparent,
//           image: widget.bgType == 'image'
//               ? DecorationImage(
//                   image: NetworkImage(widget.bgImage),
//                   fit: BoxFit.cover,
//                 )
//               : null,
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(25.0),
//             topRight: Radius.circular(25.0),
//           ),
//         ),
//         // height: MediaQuery.of(context).size.height, // Set the full screen height
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 // Image.network(
//                 //   widget.image1,
//                 //   width: Get.width * 0.5,
//                 // ),
//                 SizedBox(
//                   height: 10,
//                 ),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     const SizedBox(),
//                     SizedBox(
//                       height: 10,
//                     ),
//                     // Text(
//                     //   widget.heading.replaceAll(r'\n', '\n'),
//                     //   textAlign: TextAlign.center,
//                     //   style: const TextStyle(
//                     //     fontSize: 23.0,
//                     //     fontWeight: FontWeight.w600,
//                     //   ),
//                     // ),
//                     Text.rich(
//                       TextSpan(
//                         children: _buildUnderlinedText(
//                             widget.heading.replaceAll(r'\n', '\n'),
//                             widget.headingColor,
//                             23.0,
//                             FontWeight.w600),
//                       ),
//                     ),
//                   ],
//                 ),
//
//                 SizedBox(height: 2),
//
//                 Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5),
//                   child:
//                       // Text(
//                       //   widget.description
//                       //       .replaceAll(r'\n', '\n')
//                       //       .replaceAll(RegExp(r'<[^>]*>'), ''),
//                       //   textAlign: TextAlign.center,
//                       //   style: const TextStyle(fontSize: 16.0, color: Colors.black54),
//                       // ),
//                       Text.rich(
//                     TextSpan(
//                       children: _buildUnderlinedText(
//                           widget.description
//                               .replaceAll(r'\n', '\n')
//                               .replaceAll(RegExp(r'<[^>]*>'), ''),
//                           widget.titleColorText,
//                           16.0,
//                           FontWeight.w600),
//                     ),
//                   ),
//                 ),
//                 SizedBox(height: 2),
//                 const Padding(
//                   padding: const EdgeInsets.symmetric(horizontal: 5),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       const Text("₹ 999",
//                           // widget.description
//                           // .replaceAll(r'\n', '\n')
//                           // .replaceAll(RegExp(r'<[^>]*>'), ''),
//                           textAlign: TextAlign.center,
//                           style: TextStyle(
//                             fontSize: 16.0,
//                             decoration: TextDecoration.lineThrough,
//                             decorationColor: Colors.red,
//                             decorationThickness:
//                                 2.5, // Change this color for the line
//                             color: Colors.black54,
//                           ) // Text color
//                           ),
//                       SizedBox(
//                         width: 10,
//                       ),
//                       // DiagonalStrikeText(
//                       //   text: 'Rs 999',
//                       //   fontSize: 18.0,
//                       //   strikeColor: Colors.red, // Height of the strike
//                       // ),
//                       // SizedBox(
//                       //   width: 10,
//                       // ),
//                       Text(
//                         "₹0",
//                         // widget.description
//                         // .replaceAll(r'\n', '\n')
//                         // .replaceAll(RegExp(r'<[^>]*>'), ''),
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontSize: 22.0,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//
//                 const SizedBox(height: 20),
//
//                 /// **List Items with Smooth Fade-In**
//                 AnimatedOpacity(
//                   duration: const Duration(milliseconds: 500),
//                   opacity: progress >= 0.25 ? 1 : 0,
//                   child: listPointItem(1, widget.image1, widget.title1,
//                       widget.titleColorAll, widget.subTitle1),
//                 ),
//                 const SizedBox(height: 10),
//                 AnimatedOpacity(
//                   duration: const Duration(milliseconds: 500),
//                   opacity: progress >= 0.50 ? 1 : 0,
//                   child: listPointItem(2, widget.image2, widget.title2,
//                       widget.titleColorAll, widget.subTitle2),
//                 ),
//                 const SizedBox(height: 10),
//                 AnimatedOpacity(
//                   duration: const Duration(milliseconds: 500),
//                   opacity: progress >= 0.75 ? 1 : 0,
//                   child: listPointItem(3, widget.image3, widget.title3,
//                       widget.titleColorAll, widget.subTitle3),
//                 ),
//                 const SizedBox(height: 10),
//                 AnimatedOpacity(
//                   duration: const Duration(milliseconds: 500),
//                   opacity: progress == 1.0 ? 1 : 0,
//                   child: listPointItem(4, widget.image4, widget.title4,
//                       widget.titleColorAll, widget.subTitle4),
//                 ),
//
//                 const SizedBox(height: 10),
//
//                 /// **Circular Progress Indicator at the Bottom**
//                 // TweenAnimationBuilder(
//                 //   duration: const Duration(milliseconds: 600),
//                 //   tween: Tween<double>(begin: 0.0, end: progress),
//                 //   builder: (context, double value, child) {
//                 //     return SizedBox(
//                 //       width: 70,
//                 //       height: 70,
//                 //       child: Stack(
//                 //         fit: StackFit.expand,
//                 //         children: [
//                 //           CircularProgressIndicator(
//                 //             value: value,
//                 //             strokeWidth: 8,
//                 //             backgroundColor: Colors.grey.shade300,
//                 //             valueColor: AlwaysStoppedAnimation<Color>(
//                 //                 ColorResource.primaryColor.withOpacity(0.8)),
//                 //             strokeCap: StrokeCap.round,
//                 //           ),
//                 //           Center(
//                 //             child: Text(
//                 //               '${(value * 100).toInt()}%',
//                 //               style: TextStyle(
//                 //                   fontSize: 16,
//                 //                   fontWeight: FontWeight.bold,
//                 //                   color: Colors.black54),
//                 //             ),
//                 //           ),
//                 //         ],
//                 //       ),
//                 //     );
//                 //   },
//                 // ),
//
//                 const SizedBox(height: 20.0),
//
//                 AnimatedOpacity(
//                   duration: const Duration(milliseconds: 500),
//                   opacity: progress == 1.0 ? 1 : 0,
//                   child: Column(
//                     children: [
//                       !Get.find<AuthService>().isGuestUser.value
//                           ? Padding(
//                               padding: const EdgeInsets.all(3.0),
//                               child: Obx(
//                                 () => Form(
//                                   key: Get.find<RootViewController>()
//                                       .signInFormKey,
//                                   child: Container(
//                                     margin: EdgeInsets.symmetric(horizontal: 20),
//                                     child: CommonTextField(
//                                       showEdit: false,
//                                       isSpace: true,
//                                       isTrailPopUp: true,
//                                       readOnly: Get.find<RootViewController>()
//                                           .isLoading
//                                           .value,
//                                       onTap: () {
//                                         widget.emailController.text = "";
//                                       },
//                                       isLogin: false,
//                                       isHint: false,
//                                       isLabel: true,
//                                       hintText: "My name is ...",
//                                       controller: widget.emailController,
//                                       // keyboardType: TextInputType.text,
//                                       validator: (value) {
//                                         if (value == "My name is ...") {
//                                           Get.find<RootViewController>()
//                                                   .emailError
//                                                   .value =
//                                               StringResource.nameInvalidError;
//                                           return "";
//                                         } else if (value!.trim().length <= 3) {
//                                           Get.find<RootViewController>()
//                                                   .emailError
//                                                   .value =
//                                               StringResource.nameInvalidError;
//                                           return "";
//                                         } else {
//                                           Get.find<RootViewController>()
//                                               .emailError
//                                               .value = "";
//                                           return null;
//                                         }
//                                       },
//                                       errorText: Get.find<RootViewController>()
//                                           .emailError
//                                           .value,
//                                     ),
//                                   ),
//                                 ),
//                               ),
//                             )
//                           : Container(),
//                       const SizedBox(
//                         height: 12,
//                       ),
//                       Padding(
//                         padding: const EdgeInsets.all(3.0),
//                         child: Obx(
//                           () => CommonButton(
//                             color: Colors.black,
//                               text:
//                                   // controller.isLoading.value
//                                   //     ? 'Activating ....'
//                                   //     :
//                                   'Activate Trial Plan ',
//                               loading: controller.isLoading.value,
//                               onPressed: () {
//                                 if (Get.find<AuthService>().isGuestUser.value) {
//                                   Get.offAllNamed(Routes.loginScreen);
//                                 } else if (Get.find<RootViewController>()
//                                         .signInFormKey
//                                         .currentState!
//                                         .validate() &&
//                                     Get.find<RootViewController>()
//                                             .isLoading
//                                             .value ==
//                                         false) {
//                                   print(
//                                       "hjkjiioiouiio emailtext is : ${widget.emailController.text}");
//                                   // Get.find<LoginController>()
//                                   //     .emailController
//                                   //     .text = widget.emailController.text;
//                                   Get.find<AuthService>().user.value.name =
//                                       widget.emailController.text;
//
//                                   controller.trailOnTap(true, false, true);
//
//                                   // if (Get.find<AuthService>().isLoader.value ==
//                                   //     false) {
//                                   //   Get.dialog(
//                                   //     Center(
//                                   //       child: CupertinoActivityIndicator(
//                                   //           radius: 20),
//                                   //     ),
//                                   //     barrierDismissible: false,
//                                   //   );
//                                   // } else {
//                                   //   Get.back();
//                                   // }
//                                   // Get.find<RootViewController>().getProfile();
//
//                                   print(
//                                       "hjkjiioiouiio emailtext is :rt ${Get.find<RootViewController>().emailController.text}");
//                                 } else {}
//                               }),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
// /// **List Item Widget with Fade-In Animation**
// Widget listPointItem(int index, String image, String title,
//     String titleColorAll, String subTitle) {
//   return Padding(
//     padding: const EdgeInsets.only(top: 4.0, left: 20),
//     child: Row(
//       crossAxisAlignment: CrossAxisAlignment.center,
//       mainAxisAlignment: MainAxisAlignment.start,
//       children: [
//         /// **Number Indicator**
//         CircleAvatar(
//           radius: 15,
//           backgroundColor: Colors.black54,
//           child: Text(
//             '$index',
//             style: const TextStyle(
//                 color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
//           ),
//         ),
//         const SizedBox(width: 20),
//
//         /// **Image**
//         ClipRRect(
//           borderRadius: BorderRadius.circular(8),
//           child: Image.network(image, width: 50, height: 50, fit: BoxFit.cover),
//         ),
//         const SizedBox(width: 15),
//
//         /// **Text Content**
//         Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text.rich(
//               TextSpan(
//                 children: _buildUnderlinedText(
//                     title, titleColorAll, 13, FontWeight.w600),
//               ),
//             ),
//             // Text(
//             //   title,
//             //   style: TextStyle(
//             //     fontSize: 13.0,
//             //     color:
//             //         Color(int.parse(titleColorAll.replaceFirst('#', '0xff'))),
//             //     fontWeight: FontWeight.w600,
//             //   ),
//             // ),
//             Text(
//               subTitle,
//               style: TextStyle(
//                 fontSize: 10.0,
//                 color:
//                     Color(int.parse(titleColorAll.replaceFirst('#', '0xff'))),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ],
//         ),
//       ],
//     ),
//   );
// }
//
// Widget buildUnderlinedTitle(String title, String titleColorAll, double fontSize,
//     FontWeight fontWeight) {
//   return RichText(
//     text: TextSpan(
//       children:
//           _buildUnderlinedText(title, titleColorAll, fontSize, fontWeight),
//     ),
//   );
// }
//
// List<InlineSpan> _buildUnderlinedText(String title, String titleColorAll,
//     double fontSize, FontWeight fontWeight) {
//   RegExp regex = RegExp(r'\{(.*?)\}');
//   List<InlineSpan> textSpans = [];
//   int lastIndex = 0;
//
//   for (RegExpMatch match in regex.allMatches(title)) {
//     // Normal text before the match
//     if (match.start > lastIndex) {
//       textSpans.add(
//         TextSpan(
//           text: title.substring(lastIndex, match.start),
//           style: TextStyle(
//             fontSize: fontSize,
//             color: Color(int.parse(titleColorAll.replaceFirst('#', '0xff'))),
//             fontWeight: fontWeight,
//           ),
//         ),
//       );
//     }
//
//     // Underlined text with space between text and line
//     textSpans.add(
//       WidgetSpan(
//         child: Stack(
//           clipBehavior: Clip.none,
//           children: [
//             Padding(
//               padding: const EdgeInsets.only(bottom: 0), // Creates space
//               child: Text(
//                 match.group(1)!, // Extract text inside {}
//                 style: TextStyle(
//                   fontSize: fontSize,
//                   color: Color(int.parse(titleColorAll.replaceFirst(
//                       '#', '0xff'))), // Blue text color
//                   fontWeight: fontWeight,
//                 ),
//               ),
//             ),
//             Positioned(
//               bottom: -2, // Adjust this for more space
//               left: 0,
//               right: 0,
//               child: Container(
//                 height: 2, // Line thickness
//                 color: ColorResource.primaryColor, // Line color
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//
//     lastIndex = match.end;
//   }
//
//   // Remaining normal text
//   if (lastIndex < title.length) {
//     textSpans.add(
//       TextSpan(
//         text: title.substring(lastIndex),
//         style: TextStyle(
//           fontSize: fontSize,
//           color: Color(int.parse(titleColorAll.replaceFirst('#', '0xff'))),
//           fontWeight: fontWeight,
//         ),
//       ),
//     );
//   }
//
//   return textSpans;
// }
//
// String removeAllHtmlTags(String htmlText) {
//   RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
//   return htmlText.replaceAll(exp, '');
// }


import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/hex_color.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/custom_dialog_box.dart';
import 'package:stockpathshala_beta/view/widgets/text_field_view/common_textfield.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import 'package:flutter/services.dart';

class TrialDialogSheet extends StatefulWidget {
  final String heading;
  final String title1;
  final int days;
  final String subTitle1;
  final String title2;
  final String subTitle2;
  final String title3;
  final String subTitle3;
  final String title4;
  final String subTitle4;
  final String description;
  final VoidCallback onClose;
  final VoidCallback onContinue;
  final String image2;
  final String image1;
  final String image3;
  final String image4;
  final String descriptionColor;
  final String titleColorAll;
  final String titleColorText;
  final String headingColor;
  final String bgType;
  final String bgColor;
  final String bgImage;
  final TextEditingController emailController;

  const TrialDialogSheet({
    Key? key,
    required this.heading,
    required this.title1,
    required this.days,
    required this.subTitle1,
    required this.title2,
    required this.subTitle2,
    required this.title3,
    required this.subTitle3,
    required this.title4,
    required this.subTitle4,
    required this.description,
    required this.onClose,
    required this.onContinue,
    required this.image2,
    required this.image1,
    required this.image3,
    required this.image4,
    required this.descriptionColor,
    required this.titleColorAll,
    required this.titleColorText,
    required this.headingColor,
    required this.bgType,
    required this.bgColor,
    required this.bgImage,
    required this.emailController,
  }) : super(key: key);

  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<TrialDialogSheet>
    with SingleTickerProviderStateMixin {
  /// Initialize the controller here
  final LoginController controller = Get.put(LoginController());
  final RootViewController rootController = Get.put(RootViewController());
  double progress = 0.25;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: const Duration(seconds: 4)
    );

    /// Start progress animation
    startProgress();
  }

  void startProgress() {
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted && progress < 1.0) {
        setState(() {
          progress += 0.25;
        });
        startProgress();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
          color: widget.bgType == 'color'
              ? Color(int.parse(widget.bgColor.replaceFirst('#', '0xff')))
              : Colors.transparent,
          image: widget.bgType == 'image'
              ? DecorationImage(
            image: NetworkImage(widget.bgImage),
            fit: BoxFit.cover,
          )
              : null,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text.rich(
                        TextSpan(
                          children: _buildUnderlinedText(
                            widget.heading.replaceAll(r'\n', '\n'),
                            widget.headingColor,
                            23.0,
                            FontWeight.w600,
                          ),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: Text.rich(
                    TextSpan(
                      children: _buildUnderlinedText(
                        widget.description
                            .replaceAll(r'\n', '\n')
                            .replaceAll(RegExp(r'<[^>]*>'), ''),
                        widget.titleColorText,
                        16.0,
                        FontWeight.w600,
                      ),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 5),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "₹ 999",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16.0,
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Colors.red,
                          decorationThickness: 2.5,
                          color: Colors.black54,
                        ),
                      ),
                      SizedBox(width: 10),
                      Text(
                        "₹0",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 22.0,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                /// List Items with Smooth Fade-In
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: progress >= 0.25 ? 1 : 0,
                  child: _listPointItem(
                      1,
                      widget.image1,
                      widget.title1,
                      widget.titleColorAll,
                      widget.subTitle1
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: progress >= 0.50 ? 1 : 0,
                  child: _listPointItem(
                      2,
                      widget.image2,
                      widget.title2,
                      widget.titleColorAll,
                      widget.subTitle2
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: progress >= 0.75 ? 1 : 0,
                  child: _listPointItem(
                      3,
                      widget.image3,
                      widget.title3,
                      widget.titleColorAll,
                      widget.subTitle3
                  ),
                ),
                const SizedBox(height: 10),
                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: progress == 1.0 ? 1 : 0,
                  child: _listPointItem(
                      4,
                      widget.image4,
                      widget.title4,
                      widget.titleColorAll,
                      widget.subTitle4
                  ),
                ),
                const SizedBox(height: 20),

                AnimatedOpacity(
                  duration: const Duration(milliseconds: 500),
                  opacity: progress == 1.0 ? 1 : 0,
                  child: Column(
                    children: [
                      if (!Get.find<AuthService>().isGuestUser.value)
                        Padding(
                          padding: const EdgeInsets.all(3.0),
                          child: Obx(
                                () => Form(
                              key: Get.find<RootViewController>().signInFormKey,
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 20),
                                child: CommonTextField(
                                  showEdit: false,
                                  isSpace: true,
                                  isTrailPopUp: true,
                                  readOnly: Get.find<RootViewController>()
                                      .isLoading
                                      .value,
                                  onTap: () {
                                    widget.emailController.text = "";
                                  },
                                  isLogin: false,
                                  isHint: false,
                                  isLabel: true,
                                  hintText: "My name is ...",
                                  controller: widget.emailController,
                                  validator: (value) {
                                    if (value == "My name is ...") {
                                      Get.find<RootViewController>()
                                          .emailError
                                          .value = StringResource.nameInvalidError;
                                      return "";
                                    } else if (value!.trim().length <= 3) {
                                      Get.find<RootViewController>()
                                          .emailError
                                          .value = StringResource.nameInvalidError;
                                      return "";
                                    } else {
                                      Get.find<RootViewController>()
                                          .emailError
                                          .value = "";
                                      return null;
                                    }
                                  },
                                  errorText: Get.find<RootViewController>()
                                      .emailError
                                      .value,
                                ),
                              ),
                            ),
                          ),
                        ),
                      const SizedBox(height: 12),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Obx(
                              () => CommonButton(
                            color: Colors.black,
                            text: 'Activate Trial Plan',
                            loading: controller.isLoading.value,
                            onPressed: () {
                              if (Get.find<AuthService>().isGuestUser.value) {
                                Get.offAllNamed(Routes.loginScreen);
                              } else if (Get.find<RootViewController>()
                                  .signInFormKey
                                  .currentState!
                                  .validate() &&
                                  !Get.find<RootViewController>()
                                      .isLoading
                                      .value) {
                                print(
                                    "Email text is: ${widget.emailController.text}");

                                Get.find<AuthService>().user.value.name =
                                    widget.emailController.text;

                                controller.trailOnTap(true, false, true);
                                print(
                                    "Email text is: ${Get.find<RootViewController>().emailController.text}");
                              }
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// List Item Widget with Fade-In Animation
  Widget _listPointItem(
      int index,
      String image,
      String title,
      String titleColorAll,
      String subTitle
      ) {
    return Padding(
      padding: const EdgeInsets.only(top: 4.0, left: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          /// Number Indicator
          CircleAvatar(
            radius: 15,
            backgroundColor: Colors.black54,
            child: Text(
              '$index',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold
              ),
            ),
          ),
          const SizedBox(width: 20),

          /// Image
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              image,
              width: 50,
              height: 50,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.image_not_supported),
                );
              },
            ),
          ),
          const SizedBox(width: 15),

          /// Text Content
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text.rich(
                  TextSpan(
                    children: _buildUnderlinedText(
                        title,
                        titleColorAll,
                        13,
                        FontWeight.w600
                    ),
                  ),
                ),
                Text(
                  subTitle,
                  style: TextStyle(
                    fontSize: 10.0,
                    color: Color(int.parse(titleColorAll.replaceFirst('#', '0xff'))),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Helper function for building underlined text
List<InlineSpan> _buildUnderlinedText(
    String title,
    String titleColorAll,
    double fontSize,
    FontWeight fontWeight
    ) {
  RegExp regex = RegExp(r'\{(.*?)\}');
  List<InlineSpan> textSpans = [];
  int lastIndex = 0;

  for (RegExpMatch match in regex.allMatches(title)) {
    // Normal text before the match
    if (match.start > lastIndex) {
      textSpans.add(
        TextSpan(
          text: title.substring(lastIndex, match.start),
          style: TextStyle(
            fontSize: fontSize,
            color: Color(int.parse(titleColorAll.replaceFirst('#', '0xff'))),
            fontWeight: fontWeight,
          ),
        ),
      );
    }

    // Underlined text with space between text and line
    textSpans.add(
      WidgetSpan(
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 0),
              child: Text(
                match.group(1)!, // Extract text inside {}
                style: TextStyle(
                  fontSize: fontSize,
                  color: Color(int.parse(titleColorAll.replaceFirst('#', '0xff'))),
                  fontWeight: fontWeight,
                ),
              ),
            ),
            Positioned(
              bottom: -2,
              left: 0,
              right: 0,
              child: Container(
                height: 2,
                color: ColorResource.primaryColor,
              ),
            ),
          ],
        ),
      ),
    );

    lastIndex = match.end;
  }

  // Remaining normal text
  if (lastIndex < title.length) {
    textSpans.add(
      TextSpan(
        text: title.substring(lastIndex),
        style: TextStyle(
          fontSize: fontSize,
          color: Color(int.parse(titleColorAll.replaceFirst('#', '0xff'))),
          fontWeight: fontWeight,
        ),
      ),
    );
  }

  return textSpans;
}

/// Helper function to remove HTML tags
String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(exp, '');
}