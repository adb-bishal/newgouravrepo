import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/mentroship/view/mentorship_detail_screen.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/font_resource.dart';
import 'package:stockpathshala_beta/view/screens/home/home_new_controller.dart';
import 'package:stockpathshala_beta/view/screens/root_view/home_view/category_model.dart';

class SessionRequestCard extends StatelessWidget {
  final String userName;
  final HomeNewController controller;

  const SessionRequestCard(
      {Key? key, required this.userName, required this.controller})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      clipBehavior: Clip.antiAlias,
      child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          hexToColor(controller.categoriesData.value.ui
              .counsellingBookingSessionRequestCardBgColor1),
          hexToColor(controller.categoriesData.value.ui
              .counsellingBookingSessionRequestCardBgColor2),
        ], begin: Alignment.bottomCenter, end: Alignment.topCenter)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              color: hexToColor(controller.categoriesData.value.ui
                  .counsellingBookingSessionRequestCardBgColor),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(10),
                  topLeft: Radius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // const Text(
                      //   "⏳",
                      //   style: TextStyle(fontSize: 22),
                      // ),
                      controller.categoriesData.value.ui
                                  .counsellingBookingSessionRequestIconUrl !=
                              null
                          ? Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 6.0),
                              child: Image.network(
                                controller.categoriesData.value.ui
                                        .counsellingBookingSessionRequestIconUrl ??
                                    "",
                                width: 30,
                                height: 30,
                              ),
                            )
                          : const SizedBox.shrink(),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              controller.categoriesData.value.ui
                                      .counsellingBookingSessionRequestHeroTitle ??
                                  "Session Request Received",
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: hexToColor(controller
                                        .categoriesData
                                        .value
                                        .ui
                                        .counsellingBookingSessionRequestHeroTitleColor) ??
                                    ColorResource.black,
                              ),
                            ),
                            Text(
                              controller.categoriesData.value.ui
                                  .counsellingBookingSessionRequestHeroSubTitle ??"",
                              style: TextStyle(
                                fontSize: 12,
                                color: hexToColor(controller
                                        .categoriesData
                                        .value
                                        .ui
                                        .counsellingBookingSessionRequestHeroSubTitleColor) ??
                                    ColorResource.black,
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
            // const SizedBox(height: 8),
            // Padding(
            //   padding: const EdgeInsets.all(16.0),
            //   child: Column(
            //     crossAxisAlignment: CrossAxisAlignment.start,
            //     children: [
            //       // Greeting text with bold username
            //       // RichText(
            //       //   text: TextSpan(
            //       //     style:
            //       //         const TextStyle(fontSize: 13, color: Colors.black87),
            //       //     children: [
            //       //       TextSpan(
            //       //           text: controller.sessionRequestBody['text']?[0] ??
            //       //               "Hi",
            //       //           style: TextStyle(
            //       //             color: hexToColor(controller
            //       //                 .categoriesData
            //       //                 .value
            //       //                 .ui
            //       //                 .counsellingBookingSessionRequestTitleColor),
            //       //             fontFamily: FontResource.instance.mainFont,
            //       //           )),
            //       //       TextSpan(
            //       //         text:
            //       //             '${controller.sessionRequestBody['placeholders']?[0].replaceAll('username', userName).replaceAll('<br>', '\n')},' ??
            //       //                 "User",
            //       //         style: TextStyle(
            //       //           color: hexToColor(controller.categoriesData.value.ui
            //       //               .counsellingBookingSessionRequestTitleColor),
            //       //           fontWeight: FontWeight.bold,
            //       //           fontFamily: FontResource.instance.mainFont,
            //       //         ),
            //       //       ),
            //       //       TextSpan(
            //       //           text: controller.sessionRequestBody['text']?[1]
            //       //                   .replaceAll('<br>', '\n') ??
            //       //               "Thank you for booking your counselling session.",
            //       //           style: TextStyle(
            //       //             color: hexToColor(controller
            //       //                 .categoriesData
            //       //                 .value
            //       //                 .ui
            //       //                 .counsellingBookingSessionRequestTitleColor),
            //       //             fontSize: 13,
            //       //             fontFamily: FontResource.instance.mainFont,
            //       //           )),
            //       //     ],
            //       //   ),
            //       // ),
            //       // const SizedBox(height: 8),
            //       Column(
            //         children: [
            //           Card(
            //             color: Colors.grey.withOpacity(0.04),
            //             elevation: 0,
            //             child: Padding(
            //               padding: EdgeInsets.all(16.0),
            //               child: Row(
            //                 crossAxisAlignment: CrossAxisAlignment.start,
            //                 children: [
            //                   Icon(
            //                     Icons.person_2_outlined,
            //                     color: hexToColor(controller
            //                         .categoriesData
            //                         .value
            //                         .ui
            //                         .counsellingBookingSessionRequestAssignedTitleColor),
            //                   ),
            //                   SizedBox(width: 10),
            //                   Expanded(
            //                     child: Text(
            //                       controller.categoriesData.value.ui
            //                               .counsellingBookingSessionRequestAssignedTitle ??
            //                           "A mentor will be assigned shortly based on your selected category.",
            //                       style: TextStyle(
            //                           fontSize: 13,
            //                           color: hexToColor(controller
            //                               .categoriesData
            //                               .value
            //                               .ui
            //                               .counsellingBookingSessionRequestAssignedTitleColor)),
            //                     ),
            //                   ),
            //                 ],
            //               ),
            //             ),
            //           ),
            //
            //           const SizedBox(height: 8),
            //           Padding(
            //             padding: EdgeInsets.symmetric(horizontal: 16.0),
            //             child: Row(
            //               crossAxisAlignment: CrossAxisAlignment.start,
            //               children: [
            //                 Expanded(
            //                   child: RichText(
            //                     text: TextSpan(
            //                       style:
            //                       const TextStyle(fontSize: 13, color: Colors.black87),
            //                       children: [
            //                         TextSpan(
            //                             text: controller.sessionRequestBody['text']?[0] ??
            //                                 "Hi",
            //                             style: TextStyle(
            //                               color: hexToColor(controller
            //                                   .categoriesData
            //                                   .value
            //                                   .ui
            //                                   .counsellingBookingSessionRequestTitleColor),
            //                               fontFamily: FontResource.instance.mainFont,
            //                             )),
            //                         TextSpan(
            //                           text:
            //                           '${controller.sessionRequestBody['placeholders']?[0].replaceAll('username', userName).replaceAll('<br>', '\n')},' ??
            //                               "User",
            //                           style: TextStyle(
            //                             color: hexToColor(controller.categoriesData.value.ui
            //                                 .counsellingBookingSessionRequestTitleColor),
            //                             fontWeight: FontWeight.bold,
            //                             fontFamily: FontResource.instance.mainFont,
            //                           ),
            //                         ),
            //                         TextSpan(
            //                             text: controller.sessionRequestBody['text']?[1]
            //                                 .replaceAll('<br>', '\n') ??
            //                                 "Thank you for booking your counselling session.",
            //                             style: TextStyle(
            //                               color: hexToColor(controller
            //                                   .categoriesData
            //                                   .value
            //                                   .ui
            //                                   .counsellingBookingSessionRequestTitleColor),
            //                               fontSize: 13,
            //                               fontFamily: FontResource.instance.mainFont,
            //                             )),
            //                       ],
            //                     ),
            //                   ),
            //                 ),
            //                 const SizedBox(height: 8),
            //                 // Icon(
            //                 //   Icons.notifications_none_outlined,
            //                 //   color: hexToColor(controller
            //                 //       .categoriesData
            //                 //       .value
            //                 //       .ui
            //                 //       .counsellingBookingSessionRequestNotifyTitleColor),
            //                 // ),
            //                 // SizedBox(width: 10),
            //                 // Expanded(
            //                 //   child: Text(
            //                 //     controller.categoriesData.value.ui
            //                 //             .counsellingBookingSessionRequestNotifyTitle ??
            //                 //         "You'll be notified once it's scheduled.",
            //                 //     style: TextStyle(
            //                 //       fontSize: 13,
            //                 //       color: hexToColor(controller
            //                 //           .categoriesData
            //                 //           .value
            //                 //           .ui
            //                 //           .counsellingBookingSessionRequestNotifyTitleColor),
            //                 //     ),
            //                 //   ),
            //                 // ),
            //               ],
            //             ),
            //           ),
            //           // const SizedBox(height: 8),
            //           // const Row(
            //           //   crossAxisAlignment: CrossAxisAlignment.start,
            //           //   children: [
            //           //     Expanded(
            //           //       child: Text(
            //           //         "You’ll be notified once the session is scheduled",
            //           //         style: TextStyle(
            //           //             fontSize: 13, color: ColorResource.grey_1),
            //           //       ),
            //           //     ),
            //           //   ],
            //           // ),
            //         ],
            //       ),
            //       const SizedBox(height: 8),
            //     ],
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}
