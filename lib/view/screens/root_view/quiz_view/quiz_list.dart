import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';

import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../view_model/controllers/root_view_controller/quiz_controller/quiz_controller.dart';
import '../../../widgets/button_view/icon_button.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';

enum QuizType { scholarship, free, course }

class QuizMainScreen extends GetView<QuizController> {
  const QuizMainScreen({Key? key}) : super(key: key);

  Future<bool> promptExit() async {
    late bool returnVal;
    ProgressDialog().showConfirmFlipDialog(
        confirmText: "Yes",
        declineText: "No",
        title: "Your Quiz will restart if you leave now.\nContinue with Quiz?",
        onConfirm: () {
          Get.back();
          returnVal = false;
        },
        declineColor: ColorResource.white,
        confirmColor: ColorResource.secondaryColor,
        onDecline: () {
          Get.back();
          Get.back();
          returnVal = true;
        });
    return Future.value(returnVal);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return WillPopScope(
      onWillPop: promptExit,
      child: Scaffold(
        backgroundColor: ColorResource.secondaryColor,
        body: Theme(
          data: ThemeData(
            splashColor: ColorResource.secondaryColor,
            //accentColor: ColorResource.secondaryColor,
          ),
          child: NestedScrollView(headerSliverBuilder:
              (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 200,
                collapsedHeight: 0,
                toolbarHeight: 0,
                floating: false,
                pinned: true,
                backgroundColor: ColorResource.secondaryColor,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  collapseMode: CollapseMode.parallax,
                  background: Obx(() {
                    return Stack(
                      children: [
                        Positioned(
                          top: 0,
                          left: 0,
                          right: 0,
                          child: SizedBox(
                            height: 220,
                            width: double.infinity,
                            child: cachedNetworkImage(
                                controller.quizDataById.value.data
                                            ?.quizQuestions?.isEmpty ??
                                        true
                                    ? controller
                                            .quizDataById.value.data?.banner ??
                                        ""
                                    : controller
                                            .quizDataById
                                            .value
                                            .data
                                            ?.quizQuestions?[controller
                                                .currentQuestion.value]
                                            .image ??
                                        "",
                                imageLoader: true,
                                fit: screenWidth<500? BoxFit.cover:BoxFit.fill),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                              top: MediaQuery.of(context).padding.top),
                          child: SizedBox(
                              width: screenWidth<500? 40:60,
                              height: screenWidth<500? 40:60,
                              child: ActionCustomButton(
                                padding: DimensionResource.marginSizeDefault,
                                icon: ImageResource.instance.closeIcon,
                                isLeft: false,
                                iconColor: ColorResource.borderColor,
                                onTap: promptExit,
                              )),
                        ),
                      ],
                    );
                  }),

                ),

                bottom: PreferredSize(
                  preferredSize: const Size(double.infinity,15),
                  child: Container(
                    width: double.infinity,
                    decoration: const BoxDecoration(
                        color: ColorResource.secondaryColor,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20),
                        )),
                    child:  Column(
                      children: [
                        SizedBox(
                          height:screenWidth<500?  DimensionResource.marginSizeLarge:
                          DimensionResource.marginSizeExtraLarge,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SliverPersistentHeader(
                delegate: _SliverAppBarDelegate(),
                pinned: true,
              ),
            ];
          }, body: Obx(() {
            if (controller.isQuizDataLoading.value) {
              return SizedBox(
                  height: Get.height * 0.65,
                  child: const CommonCircularIndicator()
              );
            } else {
              if (controller.questionSectionWidget.isEmpty) {
                return SizedBox(
                    height: Get.height * 0.65, child: const NoDataFound());
              } else {
                return SingleChildScrollView(
                  physics: const ClampingScrollPhysics(),
                  padding:  EdgeInsets.symmetric(
                      horizontal: screenWidth<500? DimensionResource.marginSizeDefault
                          :DimensionResource.marginSizeExtraLarge),
                  child: Column(
                    children: [
                      SizedBox(
                        height: screenWidth<500? 55:85,
                        child: Card(
                          margin: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8)),
                          child: Row(
                            children: [
                              Expanded(
                                  flex: 2,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: ColorResource.primaryColor,
                                        borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          bottomLeft: Radius.circular(8),
                                        )),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: screenWidth<500? 28:38,
                                          width:screenWidth<500? 28:38,
                                          decoration: BoxDecoration(
                                              color:
                                                  ColorResource.secondaryColor,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              border: Border.all(
                                                  color: ColorResource.white)),
                                          child: Center(
                                            child: Text(
                                              "1",
                                              style: StyleResource.instance
                                                  .styleRegular(
                                                      color:
                                                          ColorResource.white,
                                                      fontSize: screenWidth<500? DimensionResource
                                                              .fontSizeLarge -3 : DimensionResource.fontSizeExtraLarge
                                                         ),
                                            ),
                                          ),
                                        ),
                                        Text(
                                          "Quiz",
                                          style: StyleResource.instance
                                              .styleRegular(
                                                  color: ColorResource.white,
                                                  fontSize: screenWidth<500? DimensionResource.fontSizeLarge -3:
                                                  DimensionResource.fontSizeExtraLarge),
                                        )
                                      ],
                                    ),
                                  )),
                              Expanded(
                                  flex: 9,
                                  child: Container(
                                    decoration: const BoxDecoration(
                                        color: ColorResource.white,
                                        borderRadius: BorderRadius.only(
                                          topRight: Radius.circular(7),
                                          bottomRight: Radius.circular(7),
                                        )),
                                    padding: const EdgeInsets.all(8),
                                    child: Text(
                                      controller
                                              .quizDataById.value.data?.title ??
                                          "",
                                      style: StyleResource.instance
                                          .styleRegular(
                                              color:
                                                  ColorResource.secondaryColor,
                                              fontSize: screenWidth<500? DimensionResource.fontSizeLarge -3:
                                              DimensionResource.fontSizeExtraLarge),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 2,
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                       SizedBox(
                        height:screenWidth<500? DimensionResource.marginSizeDefault + 3 :DimensionResource.marginSizeExtraLarge,
                      ),
                      Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    StringResource.questionL,
                                    style: StyleResource.instance.styleRegular(
                                        color: ColorResource.white,
                                        fontSize:screenWidth<500? DimensionResource.fontSizeLarge:
                                        DimensionResource.fontSizeDoubleExtraLarge+2),
                                  ),
                                  const SizedBox(
                                    width:
                                        DimensionResource.marginSizeSmall - 2,
                                  ),
                                  Obx(() {
                                    return RichText(
                                        text: TextSpan(
                                            style: StyleResource.instance
                                                .styleRegular(
                                                    color: ColorResource.white),
                                            children: [
                                          TextSpan(
                                            text:
                                                "${controller.currentQuestion.value + 1}",
                                            style: StyleResource.instance
                                                .styleRegular(
                                                    color: ColorResource.white,
                                                    fontSize: screenWidth<500? 18:20),
                                          ),
                                          TextSpan(
                                            text:
                                                "/${controller.quizDataById.value.data?.quizQuestions?.length ?? 0}",
                                            style: StyleResource.instance
                                                .styleRegular(
                                                    color: ColorResource.white,
                                                    fontSize: screenWidth<500? 12:16),
                                          ),
                                        ]));
                                  }),
                                ],
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(4),
                                    color: ColorResource.white),
                                padding:  EdgeInsets.symmetric(
                                    horizontal:screenWidth<500? DimensionResource.marginSizeSmall:DimensionResource.marginSizeDefault,
                                    vertical:screenWidth<500? DimensionResource.marginSizeExtraSmall - 1 :DimensionResource.marginSizeExtraSmall+1),
                                child: Row(
                                  children: [
                                    Image.asset(
                                      ImageResource.instance.timerClockIcon,
                                      height: screenWidth<500?14:20,
                                    ),
                                    const SizedBox(
                                      width:
                                          DimensionResource.marginSizeSmall - 5,
                                    ),
                                    Obx(() {
                                      return Visibility(
                                        visible:
                                            !controller.isQuizDataLoading.value,
                                        child: TimerCountDown(
                                          isHrShow: false,
                                          timeInSeconds: Duration(
                                                  minutes: controller
                                                          .quizDataById
                                                          .value
                                                          .data
                                                          ?.quizTimer ??
                                                      0)
                                              .inSeconds,
                                          remainingSeconds: (second) {
                                            EasyDebounce.debounce(
                                                controller.countValue.value
                                                    .toString(),
                                                const Duration(
                                                    milliseconds: 1000),
                                                () async {
                                              if (second == 0 &&
                                                  !controller.isTimeUp.value) {
                                                controller.isTimeUp.value =
                                                    true;
                                                Get.offNamed(
                                                    Routes.quizResultView,
                                                    arguments: [
                                                      controller.quizDataById
                                                          .value.data?.id
                                                          .toString(),
                                                      controller.courseId.value,
                                                      controller.quizType.value,
                                                      controller.isTimeUp.value,
                                                      controller
                                                          .correctQuestions,
                                                      controller
                                                          .isFromHome.value,
                                                      controller
                                                          .certificateCriteria
                                                          .value
                                                    ]);
                                              }
                                              controller.countValue.value++;
                                            });

                                            // logPrint(second);
                                          },
                                        ),
                                      );
                                    }),
                                  ],
                                ),
                              ),
                            ],
                          ),
                           SizedBox(
                            height: screenWidth<500?DimensionResource.marginSizeSmall - 2:DimensionResource.marginSizeLarge+4,
                          ),
                          LinearPercentIndicator(
                            padding: EdgeInsets.zero,
                            animation: false,
                            barRadius: const Radius.circular(10),
                            animationDuration: 100,
                            lineHeight: screenWidth<500?5.0:10.0,
                            percent: ((controller.currentQuestion.value + 1) /
                                (controller.quizDataById.value.data
                                        ?.quizQuestions?.length ??
                                    0)),
                            linearStrokeCap: LinearStrokeCap.butt,
                            progressColor: ColorResource.primaryColor,
                            backgroundColor: ColorResource.white,
                          )
                        ],
                      ),
                       SizedBox(
                        height: screenWidth<500? DimensionResource.marginSizeDefault + 5:DimensionResource.marginSizeExtraLarge+15,
                      ),
                      Obx(() {
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeIn,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                              horizontal: screenWidth < 500 ? 0.0 : 8.0,  // Horizontal padding
                              vertical: screenWidth < 500 ? 0.0 : 12.0,  // Vertical padding
                            ),
                            child: controller.questionSectionWidget[controller.currentQuestion.value],
                          ),
                        );
                      })

                    ],
                  ),
                );
              }
            }
          })),
        ),
      ),
    );
  }
  // @override
  // Widget build(BuildContext context) {
  //   return WillPopScope(
  //     onWillPop: promptExit,
  //     child: AuthView(
  //       imageBackGroundColor: ColorResource.secondaryColor,
  //       leadingIcon: (BuildContext context, QuizController controller) {
  //         return SizedBox(
  //             width: 40,
  //             height: 40,
  //             child: ActionCustomButton(
  //               padding: DimensionResource.marginSizeDefault,
  //               icon: ImageResource.instance.closeIcon,
  //               isLeft: false,
  //               iconColor: ColorResource.white,
  //               onTap: promptExit,
  //             ));
  //       },
  //       imageHeight: MediaQuery.of(context).size.height * .28,
  //       imageFit: BoxFit.contain,
  //       backGroundColor: ColorResource.secondaryColor,
  //       viewControl: QuizController(),
  //       onPageBuilder: (BuildContext context, QuizController controller) =>
  //           _buildMainView(context, controller),
  //       backgroundImage: ImageResource.instance.quizBg,
  //       imageProvider: (BuildContext context, QuizController controller) => Obx(
  //           () => cachedNetworkImage(
  //               controller.quizDataById.value.data?.quizQuestions?.isEmpty ??
  //                       true
  //                   ? controller.quizDataById.value.data?.banner ?? ""
  //                   : controller
  //                           .quizDataById
  //                           .value
  //                           .data
  //                           ?.quizQuestions?[controller.currentQuestion.value]
  //                           .image ??
  //                       "",
  //               imageLoader: true,
  //               fit: BoxFit.cover)),
  //     ),
  //   );
  // }
  //
  // _buildMainView(BuildContext context, QuizController controller) {
  //   return SizedBox(
  //     height: MediaQuery.of(context).size.height -
  //         (MediaQuery.of(context).size.height * .25),
  //     child: SingleChildScrollView(
  //       padding: const EdgeInsets.symmetric(
  //         horizontal: DimensionResource.marginSizeDefault,
  //       ),
  //       child: Obx(() {
  //         if (controller.isQuizDataLoading.value) {
  //           return SizedBox(
  //               height: Get.height * 0.65,
  //               child: const CommonCircularIndicator());
  //         } else {
  //           if (controller.questionSectionWidget.isEmpty) {
  //             return SizedBox(
  //                 height: Get.height * 0.65, child: const NoDataFound());
  //           } else {
  //             return Column(
  //               children: [
  //                 const SizedBox(
  //                   height: DimensionResource.marginSizeDefault,
  //                 ),
  //                 SizedBox(
  //                   height: 55,
  //                   child: Card(
  //                     margin: EdgeInsets.zero,
  //                     shape: RoundedRectangleBorder(
  //                         borderRadius: BorderRadius.circular(8)),
  //                     child: Row(
  //                       children: [
  //                         Expanded(
  //                             flex: 2,
  //                             child: Container(
  //                               decoration: const BoxDecoration(
  //                                   color: ColorResource.primaryColor,
  //                                   borderRadius: BorderRadius.only(
  //                                     topLeft: Radius.circular(8),
  //                                     bottomLeft: Radius.circular(8),
  //                                   )),
  //                               child: Column(
  //                                 mainAxisAlignment: MainAxisAlignment.center,
  //                                 children: [
  //                                   Container(
  //                                     height: 28,
  //                                     width: 28,
  //                                     decoration: BoxDecoration(
  //                                         color: ColorResource.secondaryColor,
  //                                         borderRadius:
  //                                             BorderRadius.circular(30),
  //                                         border: Border.all(
  //                                             color: ColorResource.white)),
  //                                     child: Center(
  //                                       child: Text(
  //                                         "1",
  //                                         style: StyleResource.instance
  //                                             .styleRegular(
  //                                                 color: ColorResource.white,
  //                                                 fontSize: DimensionResource
  //                                                         .fontSizeLarge -
  //                                                     3),
  //                                       ),
  //                                     ),
  //                                   ),
  //                                   Text(
  //                                     "Quiz",
  //                                     style: StyleResource.instance
  //                                         .styleRegular(
  //                                             color: ColorResource.white,
  //                                             fontSize: DimensionResource
  //                                                     .fontSizeLarge -
  //                                                 3),
  //                                   )
  //                                 ],
  //                               ),
  //                             )),
  //                         Expanded(
  //                             flex: 9,
  //                             child: Container(
  //                               decoration: const BoxDecoration(
  //                                   color: ColorResource.white,
  //                                   borderRadius: BorderRadius.only(
  //                                     topRight: Radius.circular(7),
  //                                     bottomRight: Radius.circular(7),
  //                                   )),
  //                               padding: const EdgeInsets.all(8),
  //                               child: Text(
  //                                 controller.quizDataById.value.data?.title ??
  //                                     "",
  //                                 style: StyleResource.instance.styleRegular(
  //                                     color: ColorResource.secondaryColor,
  //                                     fontSize:
  //                                         DimensionResource.fontSizeLarge - 3),
  //                                 overflow: TextOverflow.ellipsis,
  //                                 maxLines: 2,
  //                               ),
  //                             )),
  //                       ],
  //                     ),
  //                   ),
  //                 ),
  //                 const SizedBox(
  //                   height: DimensionResource.marginSizeDefault + 3,
  //                 ),
  //                 Column(
  //                   children: [
  //                     Row(
  //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                       children: [
  //                         Row(
  //                           children: [
  //                             Text(
  //                               StringResource.questionL,
  //                               style: StyleResource.instance.styleRegular(
  //                                   color: ColorResource.white,
  //                                   fontSize: DimensionResource.fontSizeLarge),
  //                             ),
  //                             const SizedBox(
  //                               width: DimensionResource.marginSizeSmall - 2,
  //                             ),
  //                             Obx(() {
  //                               return RichText(
  //                                   text: TextSpan(
  //                                       style: StyleResource.instance
  //                                           .styleRegular(
  //                                               color: ColorResource.white),
  //                                       children: [
  //                                     TextSpan(
  //                                       text:
  //                                           "${controller.currentQuestion.value + 1}",
  //                                       style: StyleResource.instance
  //                                           .styleRegular(
  //                                               color: ColorResource.white,
  //                                               fontSize: 18),
  //                                     ),
  //                                     TextSpan(
  //                                       text:
  //                                           "/${controller.quizDataById.value.data?.quizQuestions?.length ?? 0}",
  //                                       style: StyleResource.instance
  //                                           .styleRegular(
  //                                               color: ColorResource.white,
  //                                               fontSize: 12),
  //                                     ),
  //                                   ]));
  //                             }),
  //                           ],
  //                         ),
  //                         Container(
  //                           decoration: BoxDecoration(
  //                               borderRadius: BorderRadius.circular(4),
  //                               color: ColorResource.white),
  //                           padding: const EdgeInsets.symmetric(
  //                               horizontal: DimensionResource.marginSizeSmall,
  //                               vertical:
  //                                   DimensionResource.marginSizeExtraSmall - 1),
  //                           child: Row(
  //                             children: [
  //                               Image.asset(
  //                                 ImageResource.instance.timerClockIcon,
  //                                 height: 14,
  //                               ),
  //                               const SizedBox(
  //                                 width: DimensionResource.marginSizeSmall - 5,
  //                               ),
  //                               Obx(() {
  //                                 return Visibility(
  //                                   visible:
  //                                       !controller.isQuizDataLoading.value,
  //                                   child: TImerCountDown(
  //                                     timeInSeconds: Duration(
  //                                             minutes: controller.quizDataById
  //                                                     .value.data?.quizTimer ??
  //                                                 0)
  //                                         .inSeconds,
  //                                     remainingSeconds: (second) {
  //                                       EasyDebounce.debounce(
  //                                           controller.countValue.value
  //                                               .toString(),
  //                                           const Duration(milliseconds: 1000),
  //                                           () async {
  //                                         if (second == 0 &&
  //                                             !controller.isTimeUp.value) {
  //                                           controller.isTimeUp.value = true;
  //                                           Get.offNamed(Routes.quizResultView,
  //                                               arguments: [
  //                                                 controller.quizDataById.value
  //                                                     .data?.id
  //                                                     .toString(),
  //                                                 controller.courseId.value,
  //                                                 controller.quizType.value,
  //                                                 controller.isTimeUp.value,
  //                                                 controller.correctQuestions,
  //                                                 controller.isFromHome.value,
  //                                                 controller
  //                                                     .certificateCriteria.value
  //                                               ]);
  //                                         }
  //                                         controller.countValue.value++;
  //                                       });
  //
  //                                       // logPrint(second);
  //                                     },
  //                                   ),
  //                                 );
  //                               }),
  //                             ],
  //                           ),
  //                         ),
  //                       ],
  //                     ),
  //                     const SizedBox(
  //                       height: DimensionResource.marginSizeSmall - 2,
  //                     ),
  //                     LinearPercentIndicator(
  //                       padding: EdgeInsets.zero,
  //                       animation: false,
  //                       barRadius: const Radius.circular(10),
  //                       animationDuration: 100,
  //                       lineHeight: 5.0,
  //                       percent: ((controller.currentQuestion.value + 1) /
  //                           (controller.quizDataById.value.data?.quizQuestions
  //                                   ?.length ??
  //                               0)),
  //                       linearStrokeCap: LinearStrokeCap.butt,
  //                       progressColor: ColorResource.primaryColor,
  //                       backgroundColor: ColorResource.white,
  //                     )
  //                   ],
  //                 ),
  //                 // Row(
  //                 //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //                 //   children: [
  //                 //     const SizedBox(
  //                 //       width: 70,
  //                 //     ),
  //                 //     Text(
  //                 //       StringResource.question,
  //                 //       style: StyleResource.instance
  //                 //           .styleRegular(color: ColorResource.white,fontSize: DimensionResource.fontSizeDefault-1),
  //                 //     ),
  //                 //     Container(
  //                 //       decoration: BoxDecoration(
  //                 //           borderRadius: BorderRadius.circular(4),
  //                 //           color: ColorResource.white),
  //                 //       padding: const EdgeInsets.symmetric(
  //                 //           horizontal: DimensionResource.marginSizeSmall,
  //                 //           vertical: DimensionResource.marginSizeExtraSmall-1),
  //                 //       child: Row(
  //                 //         children: [
  //                 //           Image.asset(
  //                 //             ImageResource.instance.timerClockIcon,
  //                 //             height: 14,
  //                 //           ),
  //                 //           const SizedBox(
  //                 //             width: DimensionResource.marginSizeSmall - 5,
  //                 //           ),
  //                 //           Obx(
  //                 //                   () {
  //                 //                 return Visibility(
  //                 //                   visible: !controller.isQuizDataLoading.value,
  //                 //                   child: TImerCountDown(timeInSeconds: Duration(minutes: controller.quizDataById.value.data?.quizTimer??0).inSeconds,remainingSeconds: (second){
  //                 //                     EasyDebounce.debounce(
  //                 //                         controller.countValue.value.toString(), const Duration(milliseconds: 1000),
  //                 //                             () async {
  //                 //                               // if(second == 0 && !controller.isTimeUp.value){
  //                 //                               //   controller.isTimeUp.value = true;
  //                 //                               //   Get.offNamed(Routes.quizResultView,arguments: [controller.quizDataById.value.data?.id.toString(),controller.courseId.value,controller.quizType.value,controller.isTimeUp.value,controller.correctQuestions,controller.isFromHome.value,controller.certificateCriteria.value]);
  //                 //                               // }
  //                 //                               // controller.countValue.value++;
  //                 //                         });
  //                 //
  //                 //                     // logPrint(second);
  //                 //                   },),
  //                 //                 );
  //                 //               }
  //                 //           ),
  //                 //         ],
  //                 //       ),
  //                 //     ),
  //                 //   ],
  //                 // ),
  //                 // Obx(
  //                 //   () {
  //                 //     return RichText(
  //                 //         text: TextSpan(
  //                 //             style: StyleResource.instance
  //                 //                 .styleRegular(color: ColorResource.white),
  //                 //             children: [
  //                 //               TextSpan(
  //                 //                 text: "${controller.currentQuestion.value+1}",
  //                 //                 style: StyleResource.instance
  //                 //                     .styleRegular(color: ColorResource.white, fontSize: 34),
  //                 //               ),
  //                 //               TextSpan(
  //                 //                 text: "/${controller.quizDataById.value.data?.quizQuestions?.length??0}",
  //                 //                 style: StyleResource.instance
  //                 //                     .styleRegular(color: ColorResource.white, fontSize: 22),
  //                 //               ),
  //                 //             ]));
  //                 //   }
  //                 // ),
  //                 const SizedBox(
  //                   height: DimensionResource.marginSizeDefault + 5,
  //                 ),
  //                 Obx(() {
  //                   return AnimatedContainer(
  //                     duration: const Duration(milliseconds: 500),
  //                     curve: Curves.easeIn,
  //                     child: controller.questionSectionWidget[
  //                         controller.currentQuestion.value],
  //                   );
  //                 })
  //               ],
  //             );
  //           }
  //         }
  //       }),
  //     ),
  //   );
  // }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate();

  @override
  double get minExtent => 1;
  @override
  double get maxExtent => 1;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Container(
      height: 1,
      decoration: const BoxDecoration(
        color: ColorResource.secondaryColor,
      ),
    );
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class SliverWidget extends SingleChildRenderObjectWidget {
  const SliverWidget({Widget? child, Key? key}) : super(child: child, key: key);
  @override
  RenderObject createRenderObject(BuildContext context) {
    return RenderSliverWidget();
  }
}

class RenderSliverWidget extends RenderSliverToBoxAdapter {
  RenderSliverWidget({
    RenderBox? child,
  }) : super(child: child);

  @override
  void performResize() {}

  @override
  void performLayout() {
    if (child == null) {
      geometry = SliverGeometry.zero;
      return;
    }
    final SliverConstraints constraints = this.constraints;
    child?.layout(
        constraints.asBoxConstraints(/* crossAxisExtent: double.infinity */),
        parentUsesSize: true);
    double childExtent;
    switch (constraints.axis) {
      case Axis.horizontal:
        childExtent = child?.size.width ?? 0.0;
        break;
      case Axis.vertical:
        childExtent = child?.size.height ?? 0.0;
        break;
    }
    assert(childExtent != null);
    final double paintedChildSize =
        calculatePaintOffset(constraints, from: 0.0, to: childExtent);
    final double cacheExtent =
        calculateCacheOffset(constraints, from: 0.0, to: childExtent);

    assert(paintedChildSize.isFinite);
    assert(paintedChildSize >= 0.0);
    geometry = SliverGeometry(
      scrollExtent: childExtent,
      paintExtent: 100,
      paintOrigin: constraints.scrollOffset,
      cacheExtent: cacheExtent,
      maxPaintExtent: childExtent,
      hitTestExtent: paintedChildSize,
    );
    setChildParentData(child!, constraints, geometry!);
  }
}

class TimerCountDown extends StatefulWidget {
  final int timeInSeconds;
  final bool isHrShow;
  final Function(int) remainingSeconds;
  final bool isHrs;
  final TextStyle? fontStyle;
  const TimerCountDown(
      {Key? key,
      required this.timeInSeconds,
      required this.remainingSeconds,
      required this.isHrShow,
      this.isHrs = false,
      this.fontStyle})
      : super(key: key);

  @override
  State<TimerCountDown> createState() => _TimerCountDownState();
}

class _TimerCountDownState extends State<TimerCountDown>
    with TickerProviderStateMixin {
  late AnimationController controller;
  int levelClock = 180;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    levelClock = widget.timeInSeconds;
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: levelClock));

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Countdown(
      isHrs: widget.isHrs,
      isHrShow: widget.isHrShow,
      fontStyle: widget.fontStyle,
      remainingSeconds: widget.remainingSeconds,
      animation: StepTween(
        begin: levelClock, // THIS IS A USER ENTERED NUMBER
        end: 0,
      ).animate(controller),
    );
  }
}

class Countdown extends AnimatedWidget {
  final bool isHrs;
  final TextStyle? fontStyle;
  final Function(int) remainingSeconds;
  final bool isHrShow;

  const Countdown({
    Key? key,
    required this.animation,
    this.fontStyle,
    required this.isHrShow,
    required this.remainingSeconds,
    required this.isHrs,
  }) : super(key: key, listenable: animation);

  final Animation<int> animation;

  @override
  Widget build(BuildContext context) {
    // Calculate the clock timer
    Duration clockTimer = Duration(seconds: animation.value);
    remainingSeconds(animation.value);

    // Initialize timerText
    String timerText;

    if (isHrShow && clockTimer.inHours > 24) {
      timerText = clockTimer.inDays.toString();
    } else if (isHrs) {
      timerText =
      '${clockTimer.inHours.toString().padLeft(2, '0')} : ${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')} : ${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    } else {
      timerText =
      '${clockTimer.inMinutes.remainder(60).toString().padLeft(2, '0')}:${clockTimer.inSeconds.remainder(60).toString().padLeft(2, '0')}';
    }

    // Return the appropriate widget
    return isHrShow
        ? SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            timerText,
            style: fontStyle ??
                StyleResource.instance.styleRegular(
                  fontSize: DimensionResource.fontSizeDefault - 2,
                ),
          ),
          const SizedBox(width: 4),
          Text(
            clockTimer.inHours > 24
                ? clockTimer.inDays > 1
                ? 'Days'
                : 'Day'
                : 'Hrs',
            style: fontStyle,
            overflow: TextOverflow.fade,
          ),
        ],
      ),
    )
        : Text(
      timerText,
      style: fontStyle ??
          StyleResource.instance.styleRegular(
            fontSize: DimensionResource.fontSizeDefault - 2,
          ),
    );
  }
}
