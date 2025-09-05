import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:stockpathshala_beta/view/screens/root_view/quiz_view/quiz_list.dart';

import '../../../../model/models/quizze_model/quiz_by_id_model.dart';
import '../../../../model/models/quizze_model/quiz_result_model.dart';
import '../../../../model/network_calls/api_helper/provider_helper/quiz_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../view/widgets/log_print/log_print_condition.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';

class QuizResultController extends GetxController {
  QuizProvider quizProvider = getIt();
  final player = AudioPlayer();
  RxBool isDataLoading = false.obs;
  RxBool isFromHome = false.obs;
  RxDouble certificateCriteria = 0.0.obs;
  Rx<QuizResultModel> quizResultData = QuizResultModel().obs;
  RxList<QuizQuestion> correctQuestions = <QuizQuestion>[].obs;
  RxBool isTimeUp = false.obs;
  RxBool downloadingLoader = false.obs;
  RxBool isPassCourseQuiz = false.obs;
  RxString quizId = "".obs;
  RxString courseId = "".obs;
  Rx<QuizType> quizType = QuizType.free.obs;

  onPlayAudio(String url) async {
    await player.setUrl(url);
    await player.play();
  }

  getQuizResult() async {
    isDataLoading(true);
    int points = 0;
    List<Map<String, dynamic>> quizQuestionn = [];
    for (QuizQuestion quizData in correctQuestions) {
      quizQuestionn.add(
          {"id": quizData.id, "ans": quizData.ans, "points": quizData.points});
      if (quizData.isCorrect ?? false) {
        points += quizData.points ?? 0;
      }
    }
    Map<String, dynamic> mapData = {
      "quiz_id": quizId.value,
      "quiz_questions": quizQuestionn,
      "points": points.toString()
    };
    if (courseId.value != "") {
      mapData.addAll({
        "course_id": courseId.value,
      });
    }

    await quizProvider.getQuizResult(
      mapData: mapData,
      onError: (message, errorMap) {
        toastShow(error: true, message: message);
        Get.back();
        isDataLoading(false);
      },
      onSuccess: (message, json) {
        quizResultData.value = QuizResultModel.fromJson(json!);
        logPrint("data as ${quizResultData.value.data?.data?.toJson()}");
        if (quizResultData.value.data?.data?.typeId == null &&
            quizResultData.value.data?.result != "pass") {
          isPassCourseQuiz.value = false;
        } else {
          isPassCourseQuiz.value = true;
          onPlayAudio(
              quizResultData.value.data?.scholarshipSlab?.audioFile ?? "");
        }
        isDataLoading(false);
      },
    );
  }

  @override
  void onInit() {
    if (Get.arguments.isNotEmpty) {
      quizId.value = Get.arguments[0].toString();
      courseId.value = Get.arguments[1].toString();
      quizType.value = Get.arguments[2];
      isTimeUp.value = Get.arguments[3];
      correctQuestions.value = Get.arguments[4];
      isFromHome.value = Get.arguments[5] ?? false;
      certificateCriteria.value = Get.arguments[6] ?? 0.0;
      if (!isTimeUp.value) {
        getQuizResult();
      }
    }
    super.onInit();
  }

  @override
  Future<void> onClose() async {
    await player.stop();
    super.onClose();
  }

  // getQuizById(String quizId) async {
  //   isQuizDataLoading(true);
  //   questionSectionWidget.clear();
  //   currentQuestion.value = 0;
  //   correctQuestions.clear();
  //   await quizProvider.getQuizById(
  //       onError: (message) {
  //         toastShow(error: true,message: message);
  //         isQuizDataLoading(false);
  //       }, onSuccess: (message, json) {
  //     quizDataById.value =  QuizByIdModel.fromJson(json!);
  //     if(quizDataById.value.data?.quizQuestions?.isNotEmpty??false){
  //       for(QuizQuestion quizQuestion in quizDataById.value.data?.quizQuestions??[]){
  //         questionSectionWidget.add(questionWidget(quizQuestion));
  //       }
  //     }
  //     isQuizDataLoading(false);
  //   }, quizId: quizId);
  // }
}
