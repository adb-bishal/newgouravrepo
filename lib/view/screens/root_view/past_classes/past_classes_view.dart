import 'package:flutter/material.dart';

class PastClassesView extends StatefulWidget {
  const PastClassesView({super.key});

  @override
  State<PastClassesView> createState() => _PastClassesViewState();
}

class _PastClassesViewState extends State<PastClassesView> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(

        // body: ,
        // bottomNavigationBar: StreamBuilder<bool>(
        //           stream: ConnectivityUtils.instance.isPhoneConnectedStream,
        //           builder: (context, snapshot) {
        //             return Stack(
        //               alignment: Alignment.topCenter,
        //               children: [
        //                 SizedBox(
        //                   height: Platform.isIOS ? 110 : 90,
        //                   child: Stack(
        //                     children: <Widget>[
        //                       if (!(snapshot.data ?? true))
        //                         Align(
        //                           alignment: Alignment.topCenter,
        //                           child: Container(
        //                             height: 50,
        //                             width: double.infinity,
        //                             margin: const EdgeInsets.only(
        //                                 top: DimensionResource.marginSizeDefault),
        //                             decoration: const BoxDecoration(
        //                                 color: ColorResource.redColor,
        //                                 borderRadius: BorderRadius.only(
        //                                     topRight: Radius.circular(20),
        //                                     topLeft: Radius.circular(20))),
        //                             child: Row(
        //                               crossAxisAlignment:
        //                                   CrossAxisAlignment.start,
        //                               mainAxisAlignment: MainAxisAlignment.center,
        //                               children: [
        //                                 Text(
        //                                   "No Internet Connected",
        //                                   style: StyleResource.instance
        //                                       .styleMedium(
        //                                           color: ColorResource.white,
        //                                           fontSize: DimensionResource
        //                                                   .fontSizeExtraSmall -
        //                                               1),
        //                                 ),
        //                               ],
        //                             ),
        //                           ),
        //                         ),
        //                       if (!isShowFloatingButton)
        //                         Align(
        //                           alignment: Alignment.bottomCenter,
        //                           child: Container(
        //                             height: Platform.isIOS ? 82 : 62,
        //                             padding: const EdgeInsets.only(top: 4),
        //                             decoration: const BoxDecoration(
        //                                 color: ColorResource.primaryColor,
        //                                 borderRadius: BorderRadius.only(
        //                                     topRight: Radius.circular(16),
        //                                     topLeft: Radius.circular(16))),
        //                             child: Container(
        //                               padding: EdgeInsets.only(
        //                                   bottom: Platform.isIOS ? 20 : 0),
        //                               decoration: const BoxDecoration(
        //                                   color: ColorResource.secondaryColor,
        //                                   borderRadius: BorderRadius.only(
        //                                       topRight: Radius.circular(16),
        //                                       topLeft: Radius.circular(16))),
        //                               child: Obx(() {
        //                                 return Row(
        //                                   children: List.generate(
        //                                       controller.bottomIcon.length,
        //                                       (index) => Expanded(
        //                                             child: InkWell(
        //                                               onTap: () {
        //                                                 if (index == 4) {
        //                                                   Get.toNamed(Routes
        //                                                       .subscriptionView);
        //                                                 } else {
        //                                                   controller.selectedTab
        //                                                       .value = index;
        //                                                 }
        //                                               },
        //                                               child: index != 4
        //                                                   ? Container(
        //                                                       margin:
        //                                                           const EdgeInsets
        //                                                               .all(1),
        //                                                       padding:
        //                                                           const EdgeInsets
        //                                                               .symmetric(
        //                                                               vertical:
        //                                                                   8),
        //                                                       child: Column(
        //                                                         mainAxisAlignment:
        //                                                             MainAxisAlignment
        //                                                                 .center,
        //                                                         children: [
        //                                                           if (index != 2)
        //                                                             Container(
        //                                                               padding:
        //                                                                   const EdgeInsets
        //                                                                       .all(
        //                                                                       4),
        //                                                               decoration:
        //                                                                   BoxDecoration(
        //                                                                 shape: BoxShape
        //                                                                     .circle,
        //                                                                 boxShadow: controller.bottomIcon[index].title ==
        //                                                                         StringResource.batchSub
        //                                                                     ? [
        //                                                                         BoxShadow(color: ColorResource.starColor.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)
        //                                                                       ]
        //                                                                     : [],
        //                                                                 color: controller.bottomIcon[index].title ==
        //                                                                         StringResource
        //                                                                             .batchSub
        //                                                                     ? ColorResource
        //                                                                         .starColor
        //                                                                     : ColorResource
        //                                                                         .secondaryColor,
        //                                                               ),
        //                                                               child: Image
        //                                                                   .asset(
        //                                                                 controller
        //                                                                     .bottomIcon[
        //                                                                         index]
        //                                                                     .icon!,
        //                                                                 height:
        //                                                                     14,
        //                                                                 color: controller.selectedTab.value ==
        //                                                                         index
        //                                                                     ? ColorResource
        //                                                                         .primaryColor
        //                                                                     : ColorResource
        //                                                                         .white,
        //                                                               ),
        //                                                             ),
        //                                                           const Spacer(),
        //                                                           Text(
        //                                                             controller
        //                                                                 .bottomIcon[
        //                                                                     index]
        //                                                                 .title!,
        //                                                             style: StyleResource
        //                                                                 .instance
        //                                                                 .styleMedium()
        //                                                                 .copyWith(
        //                                                                   color: controller.selectedTab.value ==
        //                                                                           index
        //                                                                       ? ColorResource.primaryColor
        //                                                                       : ColorResource.white,
        //                                                                   fontSize:
        //                                                                       DimensionResource.fontSizeExtraSmall -
        //                                                                           1,
        //                                                                 ),
        //                                                           )
        //                                                         ],
        //                                                       ),
        //                                                     )
        //                                                   : OverlayTooltipItem(
        //                                                       displayIndex: 1,
        //                                                       tooltipVerticalPosition:
        //                                                           TooltipVerticalPosition
        //                                                               .TOP,
        //                                                       tooltip: (p0) {
        //                                                         return Padding(
        //                                                           padding:
        //                                                               const EdgeInsets
        //                                                                   .only(
        //                                                             right: 10,
        //                                                           ),
        //                                                           child:
        //                                                               Container(
        //                                                             width:
        //                                                                 size.width *
        //                                                                     0.8,
        //                                                             padding:
        //                                                                 const EdgeInsets
        //                                                                     .all(
        //                                                               10,
        //                                                             ),
        //                                                             decoration: BoxDecoration(
        //                                                                 color: ColorResource
        //                                                                     .white,
        //                                                                 borderRadius:
        //                                                                     BorderRadius.circular(
        //                                                                         10)),
        //                                                             child: Column(
        //                                                               mainAxisSize:
        //                                                                   MainAxisSize
        //                                                                       .min,
        //                                                               children: [
        //                                                                 Text(
        //                                                                   'Make a payment and get access to Premium Live Classes & Courses.',
        //                                                                   textAlign:
        //                                                                       TextAlign.center,
        //                                                                   style: StyleResource
        //                                                                       .instance
        //                                                                       .styleMedium(
        //                                                                     color:
        //                                                                         ColorResource.black,
        //                                                                   ),
        //                                                                 ),
        //                                                                 const SizedBox(
        //                                                                   height:
        //                                                                       20,
        //                                                                 ),
        //                                                                 Row(
        //                                                                   mainAxisAlignment:
        //                                                                       MainAxisAlignment.spaceEvenly,
        //                                                                   children: [
        //                                                                     InkWell(
        //                                                                       onTap:
        //                                                                           () async {
        //                                                                         await Get.find<AuthService>().saveTrainingTooltips('buyNow');
        //                                                                         controller.toolTipcontroller.dismiss();
        //                                                                       },
        //                                                                       child:
        //                                                                           Container(
        //                                                                         alignment: Alignment.center,
        //                                                                         padding: const EdgeInsets.only(
        //                                                                           left: 20,
        //                                                                           right: 20,
        //                                                                           top: 5,
        //                                                                           bottom: 5,
        //                                                                         ),
        //                                                                         decoration: BoxDecoration(
        //                                                                           borderRadius: BorderRadius.circular(20),
        //                                                                           border: Border.all(
        //                                                                             color: ColorResource.primaryColor,
        //                                                                           ),
        //                                                                         ),
        //                                                                         child: Text(
        //                                                                           'Skip',
        //                                                                           style: StyleResource.instance.styleMedium(
        //                                                                             color: ColorResource.black,
        //                                                                           ),
        //                                                                           textAlign: TextAlign.center,
        //                                                                         ),
        //                                                                       ),
        //                                                                     ),
        //                                                                     InkWell(
        //                                                                       onTap:
        //                                                                           () async {
        //                                                                         await Get.find<AuthService>().saveTrainingTooltips('buyNow');
        //                                                                         controller.toolTipcontroller.dismiss();
        //                                                                       },
        //                                                                       child:
        //                                                                           Container(
        //                                                                         alignment: Alignment.center,
        //                                                                         padding: const EdgeInsets.only(
        //                                                                           left: 20,
        //                                                                           right: 20,
        //                                                                           top: 5,
        //                                                                           bottom: 5,
        //                                                                         ),
        //                                                                         decoration: BoxDecoration(
        //                                                                           borderRadius: BorderRadius.circular(20),
        //                                                                           border: Border.all(
        //                                                                             color: ColorResource.primaryColor,
        //                                                                           ),
        //                                                                         ),
        //                                                                         child: Text(
        //                                                                           'Got it',
        //                                                                           style: StyleResource.instance.styleMedium(
        //                                                                             color: ColorResource.black,
        //                                                                           ),
        //                                                                           textAlign: TextAlign.center,
        //                                                                         ),
        //                                                                       ),
        //                                                                     ),
        //                                                                   ],
        //                                                                 )
        //                                                               ],
        //                                                             ),
        //                                                           ),
        //                                                         );
        //                                                       },
        //                                                       child: Container(
        //                                                         margin:
        //                                                             const EdgeInsets
        //                                                                 .all(1),
        //                                                         padding:
        //                                                             const EdgeInsets
        //                                                                 .symmetric(
        //                                                                 vertical:
        //                                                                     8),
        //                                                         child: Column(
        //                                                           mainAxisAlignment:
        //                                                               MainAxisAlignment
        //                                                                   .center,
        //                                                           children: [
        //                                                             if (index !=
        //                                                                 2)
        //                                                               Container(
        //                                                                 padding:
        //                                                                     const EdgeInsets
        //                                                                         .all(
        //                                                                         4),
        //                                                                 decoration:
        //                                                                     BoxDecoration(
        //                                                                   shape: BoxShape
        //                                                                       .circle,
        //                                                                   boxShadow: controller.bottomIcon[index].title == StringResource.batchSub &&
        //                                                                           !Get.find<AuthService>().isPro.value
        //                                                                       ? [
        //                                                                           BoxShadow(color: ColorResource.goldenColor.withOpacity(0.3), blurRadius: 10, spreadRadius: 2)
        //                                                                         ]
        //                                                                       : [],
        //                                                                   color: controller.bottomIcon[index].title == StringResource.batchSub ||
        //                                                                           controller.bottomIcon[index].title == StringResource.batchSub2
        //                                                                       ? Get.find<AuthService>().isPro.value
        //                                                                           ? ColorResource.greenColor
        //                                                                           : ColorResource.starColor
        //                                                                       : ColorResource.secondaryColor,
        //                                                                 ),
        //                                                                 child: Image
        //                                                                     .asset(
        //                                                                   controller.bottomIcon[index].title == StringResource.batchSub ||
        //                                                                           controller.bottomIcon[index].title == StringResource.batchSub2
        //                                                                       ? Get.find<AuthService>().isPro.value
        //                                                                           ? ImageResource.instance.proTick
        //                                                                           : ImageResource.instance.proIcon
        //                                                                       : controller.bottomIcon[index].icon!,
        //                                                                   height:
        //                                                                       14,
        //                                                                   color: controller.selectedTab.value ==
        //                                                                           index
        //                                                                       ? ColorResource.primaryColor
        //                                                                       : ColorResource.white,
        //                                                                 ),
        //                                                               ),
        //                                                             const Spacer(),
        //                                                             Text(
        //                                                               controller.bottomIcon[index].title == StringResource.batchSub ||
        //                                                                       controller.bottomIcon[index].title ==
        //                                                                           StringResource
        //                                                                               .batchSub2
        //                                                                   ? Get.find<AuthService>()
        //                                                                           .isPro
        //                                                                           .value
        //                                                                       ? StringResource
        //                                                                           .batchSub2
        //                                                                       : StringResource
        //                                                                           .batchSub
        //                                                                   : controller
        //                                                                       .bottomIcon[index]
        //                                                                       .title!,
        //                                                               style: StyleResource
        //                                                                   .instance
        //                                                                   .styleMedium()
        //                                                                   .copyWith(
        //                                                                     color: controller.selectedTab.value == index
        //                                                                         ? ColorResource.primaryColor
        //                                                                         : ColorResource.white,
        //                                                                     fontSize:
        //                                                                         DimensionResource.fontSizeExtraSmall - 1,
        //                                                                   ),
        //                                                             )
        //                                                           ],
        //                                                         ),
        //                                                       ),
        //                                                     ),
        //                                             ),
        //                                           )),
        //                                 );
        //                               }),
        //                             ),
        //                           ),
        //                         ),
        //                     ],
        //                   ),
        //                 ),
        //                 if (!isShowFloatingButton)
        //                   InkWell(
        //                     onTap: () {
        //                       controller.selectedTab.value = 2;
        //                     },
        //                     child: Stack(
        //                       alignment: Alignment.center,
        //                       clipBehavior: Clip.antiAlias,
        //                       children: [
        //                         Transform.rotate(
        //                           angle: -math.pi / 4,
        //                           child: Container(
        //                             padding: const EdgeInsets.all(10),
        //                             decoration: BoxDecoration(
        //                               color: ColorResource.white,
        //                               borderRadius: BorderRadius.circular(7),
        //                               border: Border.all(
        //                                 width: 3,
        //                                 color: ColorResource.primaryColor,
        //                               ),
        //                             ),
        //                             height: 55,
        //                             width: 55,
        //                           ),
        //                         ),
        //                         ClipRRect(
        //                           borderRadius: BorderRadius.circular(50),
        //                           child: Image.asset(
        //                             ImageResource.instance.liveIconRed,
        //                             height: 47,
        //                             width: 47,
        //                           ),
        //                         )
        //                       ],
        //                     ),
        //                   )
        //               ],
        //             );
        //           }),
        );
  }
}
