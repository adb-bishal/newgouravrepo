import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view/widgets/image_provider/image_provider.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';

import '../../../../model/models/quizze_model/quizze_list_model.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../view_model/controllers/root_view_controller/live_classes_controller/filter_controller/filter_controller.dart';
import '../../../../view_model/controllers/root_view_controller/quiz_controller/quiz_controller.dart';
import '../../../widgets/bottom_sheet.dart';
import '../../../widgets/log_print/log_print_condition.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/search_widget/search_container.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';
import '../live_classes_view/filter_view/filter_view.dart';

class QuizzesView extends StatelessWidget {
  const QuizzesView({Key? key, this.isBackButtonShow}) : super(key: key);

  final bool? isBackButtonShow;



  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: StringResource.quizzes,


      ),
      onActionBuilder: (context, controller) => [
        InkWell(
            onTap: () {
              BottomSheetCommon(
                      child: LiveFilterScreen(
                        listOfSelectedTeacher: const [],
                        isHideTime: true,
                        isHideLevel: true,
                        isHideRating: true,
                        isHideLanguage: true,
                        selectedSubscription: controller.selectedSub.value,
                        title: StringResource.quizFilter,
                        onClear: (val) {
                          controller.listOFSelectedCat.clear();
                          controller.isDataLoading.value = true;
                          controller.selectedSub.value = val['is_free'];
                          Future.delayed(Duration.zero, () {
                            controller.isDataLoading.value = false;
                          });
                          controller.getQuiz(
                            1,
                            categoryId: controller.listOFSelectedCat
                                .map((element) => element.id)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            subscriptionLevel: val['is_free'].optionName,
                          );
                          Get.back();
                        },
                        listOFSelectedCat: controller.listOFSelectedCat,
                        listOFSelectedLang: const [],
                        listOFSelectedLevel: const [],
                        listOFSelectedDuration: const [],
                        isPastFilter: true,
                        listOFSelectedRating: const [],
                        onApply: (val) {
                          logPrint('dataa ${val['is_free'].optionName}');
                          controller.listOFSelectedCat.value = val['category'];
                          controller.selectedSub.value = val['is_free'];
                          controller.getQuiz(
                            1,
                            categoryId: controller.listOFSelectedCat
                                .map((element) => element.id)
                                .toList()
                                .toString()
                                .replaceAll("[", "")
                                .replaceAll("]", "")
                                .removeAllWhitespace,
                            subscriptionLevel: val['is_free'].optionName,
                          );
                        }, listOFSelectedDays: [],
                      ),
                      isDismissible: true)
                  .present(context)
                  .then((value) {
                Get.delete<ClassesFilterController>();
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(3.0),
              child: Image.asset(
                ImageResource.instance.filterIcon,
                height: screenWidth<500? 18:22,
              ),
            ))
      ],
      onBackClicked: (context, controller) {
        Get.back();
      },
      isBackShow: isBackButtonShow == null ? true : false,
      viewControl: QuizController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(BuildContext context, QuizController controller) {
    final screenWidth = MediaQuery.of(context).size.width;
    return RefreshIndicator(
      color: ColorResource.primaryColor,
      onRefresh: () async {
        controller.getQuiz(
          1,
        );
      },
      child: ListView(
        controller: controller.dataPagingController.value.scrollController,
        // crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           SizedBox(
            height: screenWidth<500? DimensionResource.marginSizeDefault
                :DimensionResource.marginSizeExtraLarge,
          ),
          SearchWidget(
            textEditingController: controller.quizController.value,
            onChange: controller.onQuizSearch,
            onClear: () {
              controller.onQuizSearch("");
            },
          ),
          // const SizedBox(
          //   height: DimensionResource.marginSizeSmall,
          // ),
          Padding(
            padding:  EdgeInsets.symmetric(
              horizontal: screenWidth<500? DimensionResource.marginSizeDefault:DimensionResource.marginSizeLarge,
              vertical: screenWidth<500 ? DimensionResource.marginSizeSmall : DimensionResource.marginSizeLarge,
            ),
            child: Text(
              StringResource.allQuizzes,
              style: screenWidth<500? StyleResource.instance.styleSemiBold():StyleResource.instance.styleSemiBoldQuizTablet(),
            ),
          ),
          Obx(
            () => controller.isDataLoading.value
                // ? ShimmerEffect.instance.commonPageGridShimmer(itemHeight: 180)
                 ? ShimmerEffect.instance.quizClassLoader()
                : (controller.dataPagingController.value.list.isEmpty)
                    ? SizedBox(
                        height: Get.height * 0.65,
                        child: const NoDataFound(
                          text: "Quizzes Being Added for You",
                          showText: true,
                        ))
                    : quizzesWrapList(quizController: controller),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeLarge,
          )
        ],
      ),
    );
  }

  Widget quizList(Datum data, QuizController quizController , BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: () {
        Get.find<RootViewController>().getPopUpData5(data, quizController);
      },
      child: Padding(
        padding: screenWidth < 500
            ? EdgeInsets.zero
            :  EdgeInsets.only(left: 8, right: 8 , top: 4),
        child: Card(
          color: ColorResource.secondaryColor,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:  EdgeInsets.only(left: screenWidth<500? 7.0:18, right:screenWidth<500? 7.0:18, top:screenWidth<500? 8:16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ContainerButton(
                      text: data.category?.title ?? "",
                      onPressed: () {},
                      padding:
                           EdgeInsets.symmetric(horizontal:screenWidth<500? 5:10, vertical:screenWidth<500? 3:8),
                      textStyle: StyleResource.instance.styleSemiBold(
                          fontSize: screenWidth<500? DimensionResource.fontSizeExtraSmall - 3.5:DimensionResource.fontSizeSmall,
                          color: ColorResource.primaryColor),
                      color: ColorResource.white,
                    ),
                    Padding(
                      padding:  EdgeInsets.symmetric(
                          vertical: DimensionResource.marginSizeExtraSmall - 2),
                      child: Text(
                        data.title.toString().capitalize ?? "",
                        style: StyleResource.instance.styleMedium(
                          color: ColorResource.white,
                          fontSize: screenWidth <500? DimensionResource.fontSizeSmall - 2:DimensionResource.fontSizeDoubleExtraLarge,
                        ),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2,
                      ),
                    ),
                    SizedBox(
                      height: screenWidth<500? 110:320,
                      width: double.infinity,
                      child: Card(
                        margin: EdgeInsets.zero,
                        clipBehavior: Clip.antiAliasWithSaveLayer,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                        child: Stack(
                          children: [
                            Positioned(
                                top: 0,
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: cachedNetworkImage(data.banner ?? "",
                                    fit: BoxFit.cover)),
                            Visibility(
                                visible: data.isScholarship == 1,
                                child: Image.asset(
                                  ImageResource.instance.schTriangle,
                                  height: 43,
                                )),
                            Visibility(
                              visible: data.isScholarship == 1,
                              child: Align(
                                  alignment: Alignment.bottomRight,
                                  child: Stack(
                                    children: [
                                      Image.asset(
                                        ImageResource.instance.triangle,
                                        height: 43,
                                      ),
                                      Positioned(
                                        bottom: 8,
                                        right: 2,
                                        child: RotationTransition(
                                            turns: const AlwaysStoppedAnimation(
                                                315 / 360),
                                            child: Text(
                                              "50% off",
                                              style: StyleResource
                                                  .instance
                                                  .styleBold(
                                                      fontSize: DimensionResource
                                                              .fontSizeExtraSmall -
                                                          3,
                                                      color: ColorResource
                                                          .mateRedColor),
                                            )),
                                      )
                                    ],
                                  )),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Container(
                decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                    ),
                    color: ColorResource.mateGreenColor),
                margin: const EdgeInsets.only(
                    top: DimensionResource.marginSizeExtraSmall - 3),
                padding:  EdgeInsets.symmetric( horizontal:screenWidth<500? 7:12, vertical: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      StringResource.start.toUpperCase(),
                      style: StyleResource.instance.styleMedium(
                          fontSize: screenWidth<500? DimensionResource.fontSizeSmall - 1:DimensionResource.fontSizeLarge,
                          color: ColorResource.white),
                    ),
                     Icon(
                      Icons.arrow_forward_outlined,
                      color: ColorResource.white,
                      size: screenWidth<500? 14:24,
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget quizzesWrapList({required QuizController quizController}) {
    return GridView.builder(
        padding: const EdgeInsets.symmetric(
            horizontal: DimensionResource.marginSizeSmall),
        shrinkWrap: true,
        physics: const ClampingScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: DimensionResource.marginSizeExtraSmall,
            childAspectRatio: 0.81),
        itemCount: quizController.dataPagingController.value.list.length,
        itemBuilder: (context, index) {
          Datum data =
              quizController.dataPagingController.value.list.elementAt(index);
          return quizList(data, quizController ,context);
        });
  }
}

class DrawTriangle extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var path = Path();
    path.moveTo(size.width / 2, 0);
    path.lineTo(0, size.height);
    path.lineTo(size.height, size.width);
    path.close();
    canvas.drawPath(path, Paint()..color = Colors.green);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return false;
  }
}
