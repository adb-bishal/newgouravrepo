import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/course_models/course_by_id_model.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../model/network_calls/api_helper/provider_helper/courses_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/auth_service.dart';

class TextCourseController extends GetxController {
  CourseProvider courseProvider = getIt();
  late Rx<PageController> pageViewController;
  Rx<ScrollController> scrollController = ScrollController().obs;
  RxInt currentIndex = 0.obs;
  RxInt countVal = 0.obs;
  RxString categoryType = "".obs;
  RxString courseId = "".obs;
  Rx<CourseDetail> data = CourseDetail().obs;
  RxList<CourseDetail> courseData = <CourseDetail>[].obs;
  RxInt totalChapters = 1.obs;
  RxInt currentChapters = 0.obs;
  RxInt currentPage = 1.obs;
  RxBool isHistoryUploaded = true.obs;
  RxBool isContinueUploaded = true.obs;
  onPageUp() async {
    await pageViewController.value.previousPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  onPageDown() async {
    await pageViewController.value.nextPage(
        duration: const Duration(milliseconds: 500), curve: Curves.easeIn);
  }

  updateVideoStatus({String? status}) async {
    if (!Get.find<AuthService>().isGuestUser.value &&
        isContinueUploaded.value) {
      isContinueUploaded.value = false;
      EasyDebounce.debounce(
          countVal.value.toString(), const Duration(milliseconds: 1000),
          () async {
        await courseProvider.updateVideoStatus(
            mapData: {
              "type": "course_text",
              "trackable_id": courseId.value,
              "status": status
            },
            onError: (message, errorMap) {
              isContinueUploaded.value = true;
            },
            onSuccess: (message, json) async {
              isContinueUploaded.value = false;
            });
      });
    }
  }

  postCourseHistory() async {
    if (isHistoryUploaded.value) {
      // logPrint("course History uploaded");
      isHistoryUploaded.value = false;
      await courseProvider.postCourseHistory(
          mapData: {
            "course_id": courseId.value,
            "course_details_id": data.value.id
          },
          onError: (message, errorMap) {
            //toastShow(message: message,error: true);
            isHistoryUploaded.value = false;
          },
          onSuccess: (message, json) async {
            logPrint("success z $json");
            isHistoryUploaded.value = false;
          });
    }
  }

  onUpButton() {
    if ((currentChapters.value) != 0) {
      currentChapters.value--;
      if (currentPage.value != 1) {
        currentPage.value--;
      }
    }
    scrollPage();
  }

  void scrollTop() {
    scrollController.value.animateTo(
      scrollController.value.position.minScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.fastOutSlowIn,
    );
    currentPage.value = 1;
  }

  onDownButton() {
    if ((currentChapters.value + 1) != totalChapters.value) {
      currentChapters.value++;
      if (currentPage.value != totalChapters.value) {
        currentPage.value++;
      }
    }
    scrollPage();
  }

  onPageChange({bool isUp = false}) {
    logPrint(currentChapters.value);
    if ((currentChapters.value + 1) != 0 &&
        (currentChapters.value + 1) != totalChapters.value) {
      if (isUp) {
        currentChapters.value--;
      } else {
        currentChapters.value++;
      }
    }
  }

  scrollPage() {
    if (totalChapters.value - 2 == currentChapters.value) {
      /// course history
      EasyDebounce.debounce(DateTime.now().millisecond.toString(),
          const Duration(milliseconds: 500), () {
        postCourseHistory();
      });
    }
    scrollController.value.animateTo(
        currentChapters.value *
            (scrollController.value.position.viewportDimension - 20),
        curve: Curves.bounceInOut,
        duration: const Duration(milliseconds: 200));
  }

  RxDouble extendedViewPortValue = 0.0.obs;

  @override
  void onInit() {
    categoryType.value = Get.arguments[0];
    courseData.value = Get.arguments[1];
    currentIndex.value = Get.arguments[2];
    courseId.value = Get.arguments[3];
    data.value = courseData.elementAt(currentIndex.value);
    pageViewController = PageController(initialPage: currentIndex.value).obs;

    Future.delayed(const Duration(seconds: 1), () {
      double maxScrollExtent = scrollController.value.position.maxScrollExtent;
      double viewportDimension =
          scrollController.value.position.viewportDimension;
      double calculationValue = ((maxScrollExtent) / (viewportDimension));
      int chapterCount = (((maxScrollExtent) / (viewportDimension)).ceil());

      logPrint("chapterCount $chapterCount");
      logPrint("maxScrollExtent $maxScrollExtent");
      logPrint("viewportDimension $viewportDimension");

      if ((chapterCount - calculationValue) < 0.2) {
        totalChapters.value = chapterCount + 2;
      } else {
        totalChapters.value = chapterCount + 1;
      }

      if (totalChapters.value == 1 && isHistoryUploaded.value) {
        postCourseHistory();
        updateVideoStatus(status: "1");
      }
      var totalViewport = totalChapters.value * viewportDimension;
      extendedViewPortValue.value = ((totalViewport) - (maxScrollExtent));
      logPrint("totalChapters ${totalChapters.value}");
      logPrint("extendedViewPortValue ${extendedViewPortValue.value}");
    });
    if (totalChapters.value == 1) {
      updateVideoStatus(status: "0");
    }
    scrollController.value.addListener(() {
      int currentValue = (scrollController.value.offset /
              (scrollController.value.position.viewportDimension))
          .ceil();
      if (currentValue < totalChapters.value) {
        EasyDebounce.debounce(
            currentValue.toString(), const Duration(milliseconds: 50), () {
          currentChapters.value = currentValue;
        });
      }
      if (currentValue == totalChapters.value) {
        updateVideoStatus(status: "1");
      }
      if (totalChapters.value - 2 == currentChapters.value &&
          isHistoryUploaded.value) {
        postCourseHistory();
      }
    });
    super.onInit();
  }
}
