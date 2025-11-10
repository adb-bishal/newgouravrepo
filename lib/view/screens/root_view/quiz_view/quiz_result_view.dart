import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:stockpathshala_beta/model/services/download_service/download_file.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quiz_list.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/quiz_controller/quiz_result_controller.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';

import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/helper_util.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../widgets/button_view/common_button.dart';
import '../../../widgets/button_view/icon_button.dart';
import '../../../widgets/circular_indicator/circular_indicator_widget.dart';

class QuizResultScreen extends GetView<QuizResultController> {
  const QuizResultScreen({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      bottom: Platform.isIOS ? true : false,
      child: Scaffold(
        backgroundColor: ColorResource.primaryColor,
        body: Stack(
          children: [
            Positioned(
                top: 0,
                bottom: 0,
                left: 0,
                right: 0,
                child: Image.asset(
                  ImageResource.instance.quizResultBg,
                  fit: BoxFit.cover,
                )),
            SizedBox(
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top + 5,
                        left: DimensionResource.marginSizeDefault,
                        right: DimensionResource.marginSizeDefault),
                    child: SizedBox(
                        width: 40,
                        height: 40,
                        child: ActionCustomButton(
                          icon: ImageResource.instance.closeIcon,
                          isLeft: true,
                          iconColor: ColorResource.white,
                          onTap: () {
                            Get.back();
                          },
                        )),
                  ),
                  Center(
                      child: Text(
                    StringResource.score,
                    style: StyleResource.instance.styleMedium(
                        color: ColorResource.white,
                        fontSize: DimensionResource.fontSizeExtraLarge),
                  )),
                  const SizedBox(
                    height: DimensionResource.marginSizeExtraSmall,
                  ),
                  Center(
                    child: SizedBox(
                      height: 150,
                      child: Obx(() {
                        return controller.isDataLoading.value
                            ? const CommonCircularIndicator()
                            : CircularPercentIndicator(
                                radius: 63.0,
                                lineWidth: 13.0,
                                animation: true,
                                percent: (controller.correctQuestions
                                        .where((p0) => p0.isCorrect == true)
                                        .toList()
                                        .length /
                                    (controller.quizResultData.value.data
                                            ?.totalQuestion ??
                                        0)),
                                center: Text(
                                  "${controller.correctQuestions.where((p0) => p0.isCorrect == true).toList().length}/${controller.quizResultData.value.data?.totalQuestion ?? 0}",
                                  style: StyleResource.instance.styleMedium(
                                      color: ColorResource.white,
                                      fontSize: DimensionResource
                                          .fontSizeOverExtraLarge),
                                ),
                                circularStrokeCap: CircularStrokeCap.round,
                                progressColor: ColorResource.accentYellowColor,
                                backgroundColor: ColorResource.whiteYellowColor,
                              );
                      }),
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeSmall - 5,
                  ),
                  Expanded(
                      child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              horizontal: DimensionResource.marginSizeDefault),
                          decoration: const BoxDecoration(
                              borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                  topLeft: Radius.circular(25)),
                              color: ColorResource.white),
                          child: Obx(
                            () => controller.isDataLoading.value
                                ? const SizedBox()
                                :
                                // isPass? buildWinnerView: buildQuizFailView
                                controller.isTimeUp.value
                                    ? buildQuizFailView(
                                        isOnTime: !controller.isTimeUp.value,
                                        onRetake: () {
                                          controller.isTimeUp.value = false;
                                          Get.back();
                                        },
                                        onContinue: () {
                                          controller.isTimeUp.value = false;
                                          Get.back();
                                        })
                                    : controller.isPassCourseQuiz.value
                                        ? buildWinnerView(
                                            context: context,
                                            onContinue: () {
                                              controller.isTimeUp.value = false;
                                              Get.back();
                                            })
                                        : buildQuizFailView(
                                            isOnTime:
                                                !controller.isTimeUp.value,
                                            onRetake: () {
                                              controller.isTimeUp.value = false;
                                              Get.back();
                                            },
                                            onContinue: () {
                                              controller.isTimeUp.value = false;
                                              Get.back();
                                            }),
                          )))
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Column buildQuizFailView(
      {required bool isOnTime,
      required Function() onRetake,
      required Function() onContinue}) {
    return Column(
      children: [
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        ),
        Text(
          isOnTime ? StringResource.quizComplete : StringResource.oops,
          style: StyleResource.instance.styleSemiBold(
              fontSize: DimensionResource.fontSizeExtraLarge,
              color: ColorResource.primaryColor),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        ),
        Image.asset(
          isOnTime
              ? ImageResource.instance.quizResultImage2
              : ImageResource.instance.quizResultImage1,
          height: controller.quizType.value == QuizType.free ? 175 : 125,
        ),
        const SizedBox(
          height: DimensionResource.marginSizeDefault,
        ),
        Text(
          isOnTime
              ? controller.quizType.value == QuizType.free
                  ? StringResource.freeNotEligableQuiz
                  : StringResource.notEligableQuiz
              : StringResource.timeUp,
          style: StyleResource.instance
              .styleRegular(fontSize: DimensionResource.fontSizeLarge - 1),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: DimensionResource.marginSizeDefault,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ContainerButton(
              padding: const EdgeInsets.symmetric(
                  horizontal: DimensionResource.marginSizeSmall + 2,
                  vertical: DimensionResource.marginSizeExtraSmall + 1),
              color: ColorResource.borderColor.withOpacity(0.1),
              radius: 7,
              text: "",
              onPressed: onRetake,
              isIconShow: true,
              icon: Image.asset(
                ImageResource.instance.retakeIcon,
                height: 14,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4.0),
                    child: Image.asset(
                      ImageResource.instance.retakeIcon,
                      height: 12,
                    ),
                  ),
                  const SizedBox(
                    width: 3,
                  ),
                  Text(
                    StringResource.retake,
                    style: StyleResource.instance.styleSemiBold().copyWith(
                        fontSize: DimensionResource.fontSizeDefault - 1,
                        color: ColorResource.primaryColor),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
        const Spacer(),
        CommonButton(
            text: StringResource.continueText,
            loading: false,
            onPressed: () {
              if (controller.quizType.value == QuizType.course) {
                Get.find<RootViewController>().myInAppReview();
                Get.offAndToNamed(Routes.recommendedCourse, arguments: [
                  controller.quizResultData.value.data?.data?.categoryId ?? "",
                  controller.quizResultData.value.data?.data?.languageId ?? "",
                  controller.quizResultData.value.data?.data?.levelId ?? "",
                  controller.quizResultData.value.data?.data?.typeId ?? "",
                  controller.quizResultData.value.data?.courseId ?? "",
                  controller.quizResultData.value.data?.percent ?? 0.0,
                  controller.certificateCriteria.value
                ]);
              } else {
                onContinue();
              }
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  controller.quizType.value == QuizType.course
                      ? StringResource.viewOtherCourses
                      : StringResource.continueText,
                  style: StyleResource.instance.styleMedium(
                      fontSize: DimensionResource.fontSizeLarge,
                      color: ColorResource.white),
                ),
                const SizedBox(
                  width: DimensionResource.marginSizeSmall,
                ),
                Image.asset(
                  ImageResource.instance.arrowCircleIcon,
                  height: 15,
                ),
              ],
            )),
        const SizedBox(
          height: DimensionResource.marginSizeLarge,
        ),
      ],
    );
  }

  Widget buildWinnerView(
      {required Function() onContinue, required BuildContext context}) {
    return MediaQuery.removePadding(
      removeTop: true,
      context: context,
      child: ListView(
        shrinkWrap: true,
        children: [
          const SizedBox(
            height: DimensionResource.marginSizeExtraSmall,
          ),
          Center(
            child: Text(
              StringResource.quizComplete,
              style: StyleResource.instance.styleSemiBold(
                  fontSize: DimensionResource.fontSizeExtraLarge,
                  color: ColorResource.primaryColor),
            ),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall - 3,
          ),
          Image.asset(
            ImageResource.instance.quizResultImage3,
            height: 125,
          ),
          const SizedBox(
            height: DimensionResource.marginSizeDefault - 3,
          ),
          Text(
            //StringResource.congratulations,
            controller.quizResultData.value.data?.scholarshipSlab?.word ??
                StringResource.congratulations,
            style: StyleResource.instance.styleSemiBold(
                fontSize: DimensionResource.fontSizeExtraLarge,
                color: ColorResource.greenColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          Text(
            controller.quizType.value == QuizType.free
                ? ""
                : controller.quizType.value == QuizType.course
                    ? StringResource.eligableQuiz
                    : controller.quizResultData.value.data?.data?.description ??
                        "",
            style: StyleResource.instance.styleRegular(
                fontSize: DimensionResource.fontSizeSmall,
                color: ColorResource.secondaryColor),
            textAlign: TextAlign.center,
          ),
          const SizedBox(
            height: DimensionResource.marginSizeExtraSmall,
          ),
          Visibility(
            visible: !(controller.quizType.value == QuizType.free),
            child: const Divider(
              color: ColorResource.borderColor,
              indent: DimensionResource.marginSizeOverExtraLarge + 30,
              endIndent: DimensionResource.marginSizeOverExtraLarge + 30,
            ),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeExtraSmall,
          ),
          Visibility(
            visible: controller.quizType.value == QuizType.course,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: () async {
                    await HelperUtil.instance.openUrlFunction(
                        onListen: (status) {
                          if (status == DownloadStatus.complete) {
                            controller.downloadingLoader.value = false;
                          } else if (status == DownloadStatus.start) {
                            controller.downloadingLoader.value = true;
                          } else {
                            controller.downloadingLoader.value = false;
                          }
                        },
                        courseName: "Certificate",
                        courseId: controller.quizResultData.value.data?.courseId
                            .toString());
                  },
                  child: Container(
                    height: 35,
                    constraints: BoxConstraints(maxWidth: Get.width * 0.65),
                    //width: Get.width*0.3,
                    decoration: BoxDecoration(
                      color: ColorResource.secondaryColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeSmall,
                        vertical: DimensionResource.marginSizeExtraSmall),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Image.asset(ImageResource.instance.batchIcon,
                            height: 16),
                        const SizedBox(
                          width: DimensionResource.marginSizeExtraSmall + 4,
                        ),
                        Text(
                          StringResource.downloadCertificate,
                          style: StyleResource.instance.styleSemiBold(
                              fontSize: DimensionResource.fontSizeSmall,
                              color: ColorResource.white),
                        ),
                        const Spacer(),
                        controller.downloadingLoader.value
                            ? const SizedBox(
                                height: 16,
                                width: 16,
                                child: CircularProgressIndicator(
                                  strokeWidth: 1.5,
                                  color: ColorResource.mateGreenColor,
                                ),
                              )
                            : Image.asset(
                                ImageResource.instance.arrowDownIcon,
                                height: 14,
                              ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          Visibility(
            visible: (controller.quizType.value == QuizType.scholarship),
            child: Padding(
              padding: const EdgeInsets.only(top: 5.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: ColorResource.primaryColor.withOpacity(0.25)),
                    padding: const EdgeInsets.all(6),
                    child: Image.asset(
                      ImageResource.instance.coinsIcon,
                      color: ColorResource.primaryColor,
                      height: 11,
                    ),
                  ),
                  const SizedBox(
                    width: DimensionResource.marginSizeSmall - 4,
                  ),
                  Visibility(
                    visible: controller.quizType.value != QuizType.free,
                    child: RichText(
                        text: TextSpan(
                            style: StyleResource.instance.styleRegular(),
                            children: [
                          const TextSpan(text: "${StringResource.credits}: "),
                          TextSpan(
                            text:
                                "${controller.quizResultData.value.data?.points ?? ""} points",
                            style: StyleResource.instance.styleSemiBold(),
                          )
                        ])),
                  )
                ],
              ),
            ),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Visibility(
            visible: !(controller.quizType.value == QuizType.course) &&
                controller.quizType.value != QuizType.free,
            child: DottedBorder(
                borderType: BorderType.RRect,
                dashPattern: const [6, 4],
                radius: const Radius.circular(10),
                color: ColorResource.borderColor.withOpacity(0.6),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: DimensionResource.marginSizeSmall,
                      vertical: DimensionResource.marginSizeExtraSmall),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      RichText(
                          text: TextSpan(
                              style: StyleResource.instance.styleRegular(),
                              children: [
                            const TextSpan(text: "${StringResource.code}: "),
                            TextSpan(
                              text: controller
                                      .quizResultData.value.data?.data?.code
                                      ?.toUpperCase() ??
                                  "",
                              style: StyleResource.instance.styleSemiBold(),
                            )
                          ])),
                      ContainerButton(
                        radius: 7,
                        color: ColorResource.primaryColor,
                        text: StringResource.availNowSmall,
                        textStyle: StyleResource.instance.styleRegular(
                            color: ColorResource.white,
                            fontSize: DimensionResource.fontSizeSmall),
                        onPressed: () async {
                          await HelperUtil.copyToClipBoard(
                              textToBeCopied: controller
                                      .quizResultData.value.data?.data?.code
                                      ?.toUpperCase() ??
                                  "");
                          if (Platform.isAndroid) {
                            Get.offNamed(Routes.subscriptionView, arguments: {
                              "code": controller
                                  .quizResultData.value.data?.data?.code
                            });
                          }
                        },
                        isIconShow: true,
                        icon: Image.asset(
                          ImageResource.instance.copyIcon,
                          height: 14,
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: DimensionResource.marginSizeSmall,
                            vertical:
                                DimensionResource.marginSizeExtraSmall + 3),
                      )
                    ],
                  ),
                )),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          Visibility(
              visible: !(controller.quizType.value == QuizType.course) &&
                  controller.quizType.value != QuizType.free,
              child: Center(
                  child: Text(
                "${StringResource.expireOn} 31 Dec, 2022",
                style: StyleResource.instance
                    .styleRegular(fontSize: DimensionResource.fontSizeSmall),
              ))),
          SizedBox(
            height: DimensionResource.marginSizeExtraLarge +
                (controller.quizType.value == QuizType.free ? 50 : 0),
          ),
          CommonButton(
              text: StringResource.continueText,
              loading: false,
              onPressed: () {
                Get.find<RootViewController>().myInAppReview();
                if (controller.quizType.value == QuizType.course) {
                  Get.offAndToNamed(Routes.recommendedCourse, arguments: [
                    controller.quizResultData.value.data?.data?.categoryId ??
                        "",
                    controller.quizResultData.value.data?.data?.languageId ??
                        "",
                    controller.quizResultData.value.data?.data?.levelId ?? "",
                    controller.quizResultData.value.data?.data?.typeId ?? "",
                    controller.quizResultData.value.data?.courseId ?? "",
                    controller.quizResultData.value.data?.percent ?? 0.0,
                    controller.certificateCriteria.value
                  ]);
                } else {
                  if (controller.isFromHome.value) {
                    Get.offNamed(Routes.quizzesView);
                  } else {
                    Get.back();
                  }
                }
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    controller.quizType.value == QuizType.course
                        ? StringResource.viewOtherCourses
                        : StringResource.continueText,
                    style: StyleResource.instance.styleMedium(
                        fontSize: DimensionResource.fontSizeLarge,
                        color: ColorResource.white),
                  ),
                  const SizedBox(
                    width: DimensionResource.marginSizeSmall,
                  ),
                  Image.asset(
                    ImageResource.instance.arrowCircleIcon,
                    height: 15,
                  ),
                ],
              )),
          const SizedBox(
            height: DimensionResource.marginSizeLarge,
          ),
        ],
      ),
    );
  }
}
