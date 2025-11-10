import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/quiz_provider.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quiz_list.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../../model/models/quizze_model/quiz_by_id_model.dart';
import '../../../../model/models/quizze_model/quizze_list_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';
import '../../../../model/utils/color_resource.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
import '../../../../view/widgets/log_print/log_print_condition.dart';
import '../../../../enum/routing/routes/app_pages.dart';

class QuizController extends GetxController {
  QuizProvider quizProvider = getIt();
  Rx<QuizListModel> quizListData = QuizListModel().obs;
  //Rx<QuizResultModel> quizResultData = QuizResultModel().obs;
  Rx<QuizByIdModel> quizDataById = QuizByIdModel().obs;
  Rx<QuizType> quizType = QuizType.free.obs;
  RxBool isDataLoading = false.obs;
  RxBool isQuizDataLoading = false.obs;
  RxBool isClearLoading = false.obs;
  RxBool isTimeUp = false.obs;
  RxBool isFromHome = false.obs;
  RxBool isQuizAnswerLoading = true.obs;
  RxList<QuizQuestion> correctQuestions = <QuizQuestion>[].obs;
  RxInt currentQuestion = 0.obs;
  Timer? timer;
  RxInt countValue = 0.obs;
  RxDouble certificateCriteria = 0.0.obs;
  RxInt start = 30.obs;
  RxString courseId = "".obs;
  Rx<DropDownData> selectedSub = DropDownData().obs;
  RxString time = "".obs;
  RxString quizId = "".obs;
  RxString searchKey = "".obs;
  RxList<Widget> questionSectionWidget = <Widget>[].obs;
  Rx<TextEditingController> quizController = TextEditingController().obs;
  late Rx<PagingScrollController<Datum>> dataPagingController;

  // RxList<DropDownData> listOFSelectedLang = <DropDownData>[].obs;
  RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;

  @override
  void onInit() {
    if (Get.arguments != null && Get.arguments.isNotEmpty) {
      logPrint("error ${Get.arguments}");
      Map<String, dynamic> map = Get.arguments;
      if (Get.arguments.length == 3) {
        quizId.value = map['id'];
        getQuizById(quizId.value.toString());
        courseId.value = quizId.value = map['course_id'];
        certificateCriteria.value = map['certificate_criteria'];
        quizType.value = QuizType.course;
        isTimeUp.value = false;
      } else if (Get.arguments.length == 1) {
        quizId.value = map['id'];
        getQuizById(quizId.value.toString());
      } else {
        quizId.value = map['id'];
        getQuizById(quizId.value.toString());
        quizType.value = map['quiz_type'];
        isTimeUp.value = map['is_timeup'];
        isFromHome.value = map['is_fromHome'];
        // if(Get.arguments.length >4){
        //   correctQuestions.value = Get.arguments[4];
        //   courseId.value = map['course_id'];
        //  // getQuizResult();
        // }
      }
    } else {
      dataPagingController = PagingScrollController<Datum>(
          onLoadMore: (int page, int totalItemsCount) async {
       await getQuiz(
          page,
        );
      }, getStartPage: () {
        return 1;
      }, getThreshold: () {
        return 0;
      }).obs;
      getQuiz(
        1,
      );
    }
    super.onInit();
  }

  onQuizSearch(String? val) async {
    EasyDebounce.debounce(
        countValue.value.toString(), const Duration(milliseconds: 1000),
        () async {
      getQuiz(1, searchKeyword: val ?? "");
      countValue.value++;
    });
  }

  void startTimer(int min) {
    start.value = min;
    const oneSec = Duration(seconds: 1);
    if (start.value == 0) {
      timer?.cancel();
      start.value = min;
    }
    timer = Timer.periodic(
      oneSec,
      (Timer timer) {
        if (start.value == 0) {
          timer.cancel();
        } else {
          start--;
          if (start.value < 10) {
            time.value = "0$start";
          } else {
            time.value = "$start";
          }
        }
      },
    );
  }

  // getQuizResult()async{
  //   isDataLoading(true);
  //   int points = 0;
  //   List<Map<String,dynamic>> quizQuestionn = [];
  //   for(QuizQuestion quizData in correctQuestions){
  //     quizQuestionn.add({
  //       "id": quizData.id,
  //       "ans": quizData.ans,
  //       "points": quizData.points
  //     });
  //     if(quizData.isCorrect??false){
  //       points += quizData.points??0;
  //     }
  //   }
  //   Map<String,dynamic> mapData = {
  //     "quiz_id": quizId.value,
  //     "quiz_questions": quizQuestionn,
  //     "points": points.toString()
  //   };
  //   if(courseId.value != ""){
  //     mapData.addAll({"course_id": courseId.value,});
  //   }
  //
  //   await quizProvider.getQuizResult(
  //     mapData: mapData,
  //       onError: (message) {
  //         toastShow(error: true,message: message);
  //         isDataLoading(false);
  //       }, onSuccess: (message, json) {
  //     quizResultData.value =  QuizResultModel.fromJson(json!);
  //     isDataLoading(false);
  //   },);
  // }

  getQuiz(
    int pageNo, {
    String? subscriptionLevel,
    String? categoryId,
    String? langId,
    String? searchKeyword,
  }) async {
    searchKey.value = searchKeyword ?? searchKey.value;
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      dataPagingController.value.reset();
      isDataLoading.value = true;
    }
    await quizProvider.getQuiz(
      categoryId: listOFSelectedCat
          .map((element) => element.id)
          .toList()
          .toString()
          .replaceAll("[", "")
          .replaceAll("]", "")
          .removeAllWhitespace,
      //languageId: listOFSelectedLang.map((element) => element.id).toList().toString().replaceAll("[", "").replaceAll("]", "").removeAllWhitespace,
      subscriptionLevel: selectedSub.value.optionName?.toLowerCase(),
      searchKeyword: searchKey.value,
      onError: (message, errorMap) {
        toastShow(error: true, message: message);
        isDataLoading(false);
      },
      onSuccess: (message, json) {
        quizListData.value = QuizListModel.fromJson(json!);
        if (quizListData.value.data?.data?.isNotEmpty ?? false) {
          dataPagingController.value.list
              .addAll(quizListData.value.data?.data ?? []);
        }
        isDataLoading(false);
      },
      pageNo: pageNo,
    );
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = false;
    }
  }

  getQuizById(String quizId) async {
    isQuizDataLoading(true);
    questionSectionWidget.clear();
    currentQuestion.value = 0;
    correctQuestions.clear();
    await quizProvider.getQuizById(
        onError: (message, errorMap) {
          toastShow(error: true, message: message);
          isQuizDataLoading(false);
        },
        onSuccess: (message, json) {
          quizDataById.value = QuizByIdModel.fromJson(json!);
          if (quizDataById.value.data?.quizQuestions?.isNotEmpty ?? false) {
            for (QuizQuestion quizQuestion
                in quizDataById.value.data?.quizQuestions ?? []) {
              questionSectionWidget.add(questionWidget(quizQuestion));
            }
          }
          isQuizDataLoading(false);
        },
        quizId: quizId);
  }

  questionWidget(QuizQuestion quizQuestion) {
    RxList<String> options = [
      quizQuestion.option1 ?? "",
      quizQuestion.option2 ?? "",
      quizQuestion.option3 ?? "",
      quizQuestion.option4 ?? ""
    ].obs;
    RxString? selectedValue = "".obs; // Default selected value
    Rx<Color> isCorrectAnswer = ColorResource.white.obs;
    RxBool isBttnClicked = true.obs;

    Map<String, String> optionMap = {
      "option_1": quizQuestion.option1 ?? "",
      "option_2": quizQuestion.option2 ?? "",
      "option_3": quizQuestion.option3 ?? "",
      "option_4": quizQuestion.option4 ?? "",
    };
    return Obx(() {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorResource.white,
                borderRadius: BorderRadius.circular(7)),
            padding: const EdgeInsets.all(10),
            child: Text(
              quizQuestion.question ?? "",
              style: StyleResource.instance.styleRegular(
                  fontSize: DimensionResource.fontSizeLarge - 1,
                  color: ColorResource.secondaryColor),
            ),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeLarge + 5,
          ),
          ...List.generate(options.length, (index) {
            MapEntry mapEntry = optionMap.entries.elementAt(index);
            return Padding(
              padding: const EdgeInsets.only(
                  bottom: DimensionResource.marginSizeDefault - 3),
              child: Theme(
                data: ThemeData(
                  splashColor: Colors.transparent,
                  highlightColor: Colors.transparent,
                ),
                child: Card(
                  elevation: 0,
                  margin: EdgeInsets.zero,
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                      side: const BorderSide(color: Colors.black, width: 0.25)),
                  child: Center(
                      child: RadioListTile(
                    title: Padding(
                      padding: const EdgeInsets.only(left: 50),
                      child: Text(
                        options[index],
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18,
                            color: selectedValue.value == options[index]
                                ? Colors.white
                                : Colors.black),
                      ),
                    ),
                    value: options[index],
                    groupValue: selectedValue.value,
                    onChanged: isBttnClicked.value
                        ? (value) {
                            selectedValue.value = options[index];
                            isBttnClicked.value = false;
                            isQuizAnswerLoading.value = false;

                            if (quizQuestion.correctAns == mapEntry.key) {
                              isCorrectAnswer.value =
                                  ColorResource.mateGreenColor;
                              quizQuestion.isCorrect = true;
                              quizQuestion.ans = mapEntry.key;
                            } else {
                              isCorrectAnswer.value =
                                  ColorResource.mateRedColor;
                              quizQuestion.isCorrect = false;
                              quizQuestion.ans = mapEntry.key;
                            }
                            correctQuestions.add(quizQuestion);
                            Future.delayed(const Duration(milliseconds: 500),
                                () {
                              if (currentQuestion.value <
                                  (quizDataById.value.data?.quizQuestions
                                              ?.length ??
                                          0) -
                                      1) {
                                isCorrectAnswer.value = ColorResource.white;
                                currentQuestion.value++;
                                isQuizAnswerLoading.value = true;
                              } else {
                                isQuizAnswerLoading.value = true;
                                Get.offNamed(Routes.quizResultView, arguments: [
                                  quizDataById.value.data?.id.toString(),
                                  courseId.value,
                                  quizType.value,
                                  isTimeUp.value,
                                  correctQuestions,
                                  isFromHome.value,
                                  certificateCriteria.value
                                ]);
                              }
                            });
                          }
                        : null,
                    overlayColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    selected: selectedValue.value == options[index],
                    fillColor:
                        MaterialStateProperty.all<Color>(Colors.transparent),
                    selectedTileColor: isCorrectAnswer.value,
                    controlAffinity: ListTileControlAffinity.trailing,
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 20.0),
                    dense: true,
                  )),
                ),
              ),

              //  Obx(() {
              //   return CommonButtonQuiz(
              //     radius: 5,
              //     text: option,
              //     height: 40,
              //     onPressed:
              //      isQuizAnswerLoading.value
              //         ?
              //         ()
              //         {

              //             isQuizAnswerLoading.value = false;
              //             if (quizQuestion.correctAns == mapEntry.key) {
              //               isCorrectAnswer.value = ColorResource.mateGreenColor;
              //               quizQuestion.isCorrect = true;
              //               quizQuestion.ans = mapEntry.key;
              //             } else {
              //               isCorrectAnswer.value = ColorResource.mateRedColor;
              //               quizQuestion.isCorrect = false;
              //               quizQuestion.ans = mapEntry.key;
              //             }
              //             correctQuestions.add(quizQuestion);
              //             Future.delayed(const Duration(milliseconds: 500), () {
              //               if (currentQuestion.value < (quizDataById.value.data?.quizQuestions?.length ??0) -1)
              //               {
              //                 isCorrectAnswer.value = ColorResource.white;
              //                 currentQuestion.value++;
              //                 isQuizAnswerLoading.value = true;

              //               }
              //               else {
              //                 isQuizAnswerLoading.value = true;
              //                 Get.offNamed(Routes.quizResultView, arguments: [
              //                   quizDataById.value.data?.id.toString(),
              //                   courseId.value,
              //                   quizType.value,
              //                   isTimeUp.value,
              //                   correctQuestions,
              //                   isFromHome.value,
              //                   certificateCriteria.value
              //                 ]);

              //               }
              //             });
              //           }
              //         : null,
              //     color: isCorrectAnswer.value,
              //     loading: false,
              //     style: StyleResource.instance
              //         .styleMedium(color: ColorResource.secondaryColor),
              //   );
              // }),
            );
          }),
        ],
      );
    });
  }
}

class CommonButtonQuiz extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final TextStyle? style;
  final Widget? child;
  final bool loading;
  final bool showBorder;
  final Color color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final double elevation;
  final double radius;

  const CommonButtonQuiz(
      {Key? key,
      required this.text,
      this.child,
      required this.loading,
      required this.onPressed,
      this.elevation = 0,
      this.radius = DimensionResource.appDefaultRadius,
      this.color = ColorResource.secondaryColor,
      this.textColor,
      this.width,
      this.showBorder = false,
      this.height,
      this.fontSize,
      this.style})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: showBorder
              ? const BorderSide(color: ColorResource.borderColor, width: 1.5)
              : BorderSide(color: color, width: 1.5)),
      color: color,
      child: SizedBox(
          //height:height?? 45,
          width: MediaQuery.of(context).size.width,
          child: MaterialButton(
              onPressed: loading ? () {} : onPressed,
              padding: const EdgeInsets.symmetric(
                  vertical: DimensionResource.marginSizeExtraSmall + 10,
                  horizontal: DimensionResource.marginSizeSmall),
              child: Center(
                child: loading
                    ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                        ))
                    : child ??
                        Text(
                          text,
                          style: style ??
                              StyleResource.instance.styleMedium(
                                  fontSize: fontSize ??
                                      DimensionResource.fontSizeLarge - 1,
                                  color: textColor ?? ColorResource.white),
                          textAlign: TextAlign.center,
                        ),
              ))),
    );
  }
}
