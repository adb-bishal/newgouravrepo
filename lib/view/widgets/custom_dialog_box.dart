import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/hex_color.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/hex_color.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/auth_controllers/login_controller.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

class CustomDialog extends StatefulWidget {
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

  const CustomDialog({
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
  }) : super(key: key);

  @override
  CustomDialogState createState() => CustomDialogState();
}

class CustomDialogState extends State<CustomDialog> {
  late LoginController controller;

  @override
  void initState() {
    super.initState();
    controller = Get.put(LoginController());
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: widget.bgType == 'color'
            ? Color(int.parse(widget.bgColor.replaceFirst('#', '0xff')))
            : Colors.transparent, // Transparent if bgType is 'image'
        image: widget.bgType == 'image'
            ? DecorationImage(
                image: NetworkImage(widget.bgImage),
                fit: BoxFit.cover,
              )
            : null,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(25.0),
          topRight: Radius.circular(25.0),
        ),
      ),
      constraints: BoxConstraints(
        // maxWidth: Get.width * 1, // Limit the width of the dialog
        maxHeight: Get.height * 0.8, // Limit the height of the dialog
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(),
                  SizedBox(
                    height: 10,
                  ),
                  Text(
                    widget.heading.replaceAll(r'\n', '\n'),
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 18.0,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  // IconButton(
                  //   onPressed: widget.onClose,
                  //   icon: const Icon(Icons.close),
                  // ),
                ],
              ),
              SizedBox(height: Get.height / 80),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  widget.description
                      .replaceAll(r'\n', '\n')
                      .replaceAll(RegExp(r'<[^>]*>'), ''),
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 14.0,
                  ),
                ),
              ),
              SizedBox(height: Get.height / 80),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: listItem(
                      widget.image1,
                      widget.title1.replaceAll(r'\n', '\n'),
                      widget.titleColorAll,
                      widget.subTitle1.replaceAll(r'\n', '\n'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: listItem(
                      widget.image2,
                      widget.title2.replaceAll(r'\n', '\n'),
                      widget.titleColorAll,
                      widget.subTitle2.replaceAll(r'\n', '\n'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: listItem(
                      widget.image3,
                      widget.title3.replaceAll(r'\n', '\n'),
                      widget.titleColorAll,
                      widget.subTitle3.replaceAll(r'\n', '\n'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: listItem(
                      widget.image4,
                      widget.title4.replaceAll(r'\n', '\n'),
                      widget.titleColorAll,
                      widget.subTitle4.replaceAll(r'\n', '\n'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () => CommonButton(
                    text: 'Continue',
                    loading: controller.isLoading.value,
                    onPressed: () {
                      controller.emailController.text = "Enter phone number";
                      Get.find<AuthService>().isGuestUser.value
                          ? Get.offAllNamed(Routes.loginScreen)
                          : controller.trailOnTap(false, true);
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget listItem(
    String image1, String title1, String titleColorAll, String subTitle1) {
  return Row(
    children: [
      const SizedBox(width: 8),
      CircleAvatar(
        backgroundImage: NetworkImage(image1),
        radius: 26,
      ),
      const SizedBox(width: 12),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title1,
              style: TextStyle(
                fontSize: 12.0,
                color: HexColor(titleColorAll),
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              subTitle1,
              style: TextStyle(
                fontSize: 10.0,
                color: HexColor(titleColorAll),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

String removeAllHtmlTags(String htmlText) {
  RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);
  return htmlText.replaceAll(exp, '');
}

// class CustomDialog extends StatefulWidget {
//   final String heading;
//   // final BuildContext context;
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

//   const CustomDialog({
//     Key? key,
//     required this.heading,
//     // required this.context,
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
//   }) : super(key: key);

//   @override
//   CustomDialogState createState() => CustomDialogState();
// }

// class CustomDialogState extends State<CustomDialog> {
//   late LoginController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = Get.put(LoginController());
//     // controller.emailController.text = "Your your name";
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       decoration: BoxDecoration(
//         color: widget.bgType == 'color'
//             ? Color(int.parse(widget.bgColor.replaceFirst('#', '0xff')))
//             : Colors.transparent, // Transparent if bgType is 'bgImage'
//         image: widget.bgType == 'image'
//             ? DecorationImage(
//                 image: NetworkImage(widget.bgImage),
//                 fit: BoxFit.cover,
//               )
//             : null, // No image if bgType is 'color'

//         borderRadius: BorderRadius.only(
//           topLeft: Radius.circular(25.0), // Curved upper-left corner
//           topRight: Radius.circular(25.0), // Curved upper-right corner
//         ),
//       ),
//       child: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.only(left: 8, right: 8, bottom: 16),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   const SizedBox(),
//                   IconButton(
//                       onPressed: widget.onClose, icon: const Icon(Icons.close))
//                 ],
//               ),
//               Text(
//                 widget.heading.replaceAll(r'\n', '\n'),
//                 textAlign: TextAlign.center,
//                 style: const TextStyle(
//                   fontSize: 18.0,
//                   fontWeight: FontWeight.w600,
//                 ),
//               ),
//               SizedBox(
//                 height: Get.height / 80,
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 5),
//                 child: Text(
//                   widget.description.replaceAll(r'\n', '\n').replaceAll(
//                       RegExp(r'<[^>]*>'),
//                       ''), // Remove HTML tags and escape sequences
//                   textAlign: TextAlign.center,
//                   style: const TextStyle(
//                     fontSize: 14.0,
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: Get.height / 80,
//               ),
//               Row(

//                 children: [
//                   listItem(
//                       widget.image1,
//                       widget.title1.replaceAll(r'\n', '\n'),
//                       widget.titleColorAll,
//                       widget.subTitle1.replaceAll(r'\n', '\n')),
//                   listItem(
//                       widget.image2,
//                       widget.title2.replaceAll(r'\n', '\n'),
//                       widget.titleColorAll,
//                       widget.subTitle2.replaceAll(r'\n', '\n')),
//                 ],
//               ),
//               const SizedBox(
//                 height: 24,
//               ),
//               Row(
//                 children: [
//                   listItem(
//                       widget.image3,
//                       widget.title3.replaceAll(r'\n', '\n'),
//                       widget.titleColorAll,
//                       widget.subTitle3.replaceAll(r'\n', '\n')),
//                   listItem(
//                       widget.image4,
//                       widget.title4.replaceAll(r'\n', '\n'),
//                       widget.titleColorAll,
//                       widget.subTitle4.replaceAll(r'\n', '\n')),
//                 ],
//               ),
//               const SizedBox(height: 16.0),
//               Padding(
//                 padding: const EdgeInsets.all(8.0),
//                 child: Obx(() => CommonButton(
//                     text: 'Continue',
//                     loading: controller.isLoading.value,
//                     onPressed: () {
//                       controller.emailController.text = "Enter phone number";
//                       Get.find<AuthService>().isGuestUser.value
//                           ? Get.offAllNamed(Routes.loginScreen)
//                           : controller.trailOnTap(
//                               false, true,
//                               // widget.days
//                             );
//                     })),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// Widget listItem(image1, title1, titleColorAll, subTitle1) {
//   return Row(
//     children: [
//       const SizedBox(
//         width: 8,
//       ),
//       CircleAvatar(
//         backgroundImage: NetworkImage(image1),
//         radius: 26,
//       ),
//       const SizedBox(
//         width: 12,
//       ),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           SizedBox(
//             width: Get.width / 2.25,
//             child: Text(
//               title1,
//               style: TextStyle(
//                 fontSize: 12.0,
//                 color: HexColor(titleColorAll),
//                 fontWeight: FontWeight.w600,
//               ),
//             ),
//           ),
//           SizedBox(
//             width: Get.width / 2.5,
//             child: Text(
//               subTitle1,
//               style: TextStyle(
//                 fontSize: 10.0,
//                 color: HexColor(titleColorAll),
//                 fontWeight: FontWeight.w500,
//               ),
//             ),
//           ),
//         ],
//       ),
//     ],
//   );
// }

// String removeAllHtmlTags(String htmlText) {
//   RegExp exp = RegExp(r"<[^>]*>", multiLine: true, caseSensitive: true);

//   return htmlText.replaceAll(exp, '');
// }
