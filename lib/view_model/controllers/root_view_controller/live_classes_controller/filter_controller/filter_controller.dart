import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/root_view_controller.dart';

import '../../../../../model/models/explore_all_category/all_category_model.dart'
    as category;
import '../../../../../model/network_calls/api_helper/provider_helper/courses_provider.dart';
import '../../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../../model/services/auth_service.dart';
import '../../../../../view/widgets/log_print/log_print_condition.dart';
import '../../../../../view/widgets/toast_view/showtoast.dart';

class ClassesFilterController extends GetxController {
  ClassesFilterController({
    DropDownData? selectedSubscription,
    required List<DropDownData> listOSelectedCat,
  }) {
    Future.delayed(Duration.zero, () {
      listOFSelectedCat.value = [];
      listOFSelectedCat.addAll(listOSelectedCat);
    });
    selectedSub =
        DropDownData(id: "0", optionName: subscriptionData[0].toLowerCase())
            .obs;
    selectedSub.value = DropDownData(
        id: selectedSubscription?.id ?? "0",
        optionName: selectedSubscription?.optionName ??
            subscriptionData[0].toLowerCase());

    if (selectedSubscription?.optionName == "free") {
      selectedSubscriptionFilter.value = 1;
    } else if (selectedSubscription?.optionName == "pro") {
      selectedSubscriptionFilter.value = 2;
    } else {
      selectedSubscriptionFilter.value = 0;
    }

    logPrint("selected sub in constructor ${selectedSub.value.optionName}");
  }

  RxList<DropDownData> levelData = Get.find<AuthService>().levelData;
  RxList<DropDownData> selectedLevel = <DropDownData>[].obs;
  RxList<DropDownData> categoryList = <DropDownData>[].obs;
  RxList<DropDownData> durationList = <DropDownData>[
    DropDownData(id: "1", optionName: "15", displayName: "15 Minutes"),
    DropDownData(id: "2", optionName: "30", displayName: "30 Minutes"),
    DropDownData(id: "3", optionName: "45", displayName: "45 Minutes"),
    DropDownData(id: "4", optionName: "60", displayName: "60 Minutes"),
    DropDownData(id: "5", optionName: "90", displayName: "90 Minutes"),
  ].obs;

  RxList<DropDownData> langList = Get.find<RootViewController>().languageData;
  RxList<String> subscriptionData = <String>["All", "Free", "Pro"].obs;
  RxInt selectedSubscriptionFilter = 0.obs;
  RxList<DropDownData> teacherList = <DropDownData>[].obs;
  RxList<DropDownData> listOfSelectedTeacher = <DropDownData>[].obs;
  RxList<DropDownData> listOFSelectedDuration = <DropDownData>[].obs;
  RxList<DropDownData> listOFSelectedLang = <DropDownData>[].obs;
  RxList<DropDownData> listOFSelectedCat = <DropDownData>[].obs;
  RxList<DropDownData> listOFSelectedDays = <DropDownData>[].obs;
  RxList<DropDownData> listOFMentorShip = <DropDownData>[].obs;

  // ✅ New Days Filter
  RxBool isDaysLoading = false.obs;
  RxBool isMentorShipTypeLoading = false.obs;
  RxList<DropDownData> daysList = <DropDownData>[
    DropDownData(id: "1", optionName: "Today", displayName: 'today'),
    DropDownData(id: "2", optionName: "Yesterday", displayName: 'yesterday'),
    DropDownData(id: "3", optionName: "Last Week", displayName: 'last_week'),
    DropDownData(id: "4", optionName: "This Month", displayName: 'this_month'),
  ].obs;
  RxList<DropDownData> liveDaysList = <DropDownData>[
    DropDownData(id: "1", optionName: "Today", displayName: 'today'),
    DropDownData(id: "2", optionName: "Tomorrow", displayName: 'tomorrow'),
    DropDownData(id: "3", optionName: "This Week", displayName: 'this_week'),
    DropDownData(id: "4", optionName: "This Month", displayName: 'this_month'),
  ].obs;


  RxList<DropDownData> mentorShipList = <DropDownData>[
    DropDownData(id: "2", optionName: "Mentorship", displayName: '1'),
    DropDownData(id: "1", optionName: "Group Mentorship", displayName: '0,3'),
    DropDownData(id: "3", optionName: "Mini Mentorship", displayName: '2'),
  ].obs;


  RxList<DropDownData> batchesDaysList = <DropDownData>[
    DropDownData(
      id: "1",
      optionName: "This Month",
      displayName: 'this_month',
    ),
    DropDownData(
      id: "2",
      optionName: "Previous Month",
      displayName: 'previous_month',
    ),
    DropDownData(
      id: "3",
      optionName: "Previous 3 Months",
      displayName: 'previous_3_months',
    ),
    DropDownData(
      id: "4",
      optionName: "Previous 6 Months",
      displayName: 'previous_6_months',
    ),
    DropDownData(
      id: "5",
      optionName: "This Year",
      displayName: '${DateTime.now().year}',
    ),
  ].obs;
  RxList<DropDownData> upcomingBatchesDaysList = <DropDownData>[
    DropDownData(
      id: "1",
      optionName: "This Month",
      displayName: 'this_month',
    ),
    DropDownData(
      id: "2",
      optionName: "Next Month",
      displayName: 'next_month',
    ),
    DropDownData(
      id: "3",
      optionName: "Next 3 Months",
      displayName: 'next_3_months',
    ),
    DropDownData(
      id: "4",
      optionName: "Next 6 Months",
      displayName: 'next_6_months',
    ),
    DropDownData(
      id: "5",
      optionName: "This Year",
      displayName: '${DateTime.now().year}',
    ),
  ].obs;
  RxList<RatingDataVal> selectedRating = <RatingDataVal>[
    RatingDataVal(
      ratingName: "All",
      ratingValue: "all",
    ),
  ].obs;

  late Rx<DropDownData> selectedSub;

  RxList<RatingDataVal> ratingData = <RatingDataVal>[
    RatingDataVal(
      ratingName: "All",
      ratingValue: "all",
    ),
    RatingDataVal(
      ratingName: "5 star",
      ratingValue: "5",
    ),
    RatingDataVal(
      ratingName: "4 star",
      ratingValue: "4",
    ),
    RatingDataVal(
      ratingName: "3 star",
      ratingValue: "3",
    ),
    RatingDataVal(
      ratingName: "2 star",
      ratingValue: "2",
    ),
    RatingDataVal(
      ratingName: "1 star",
      ratingValue: "1",
    ),
  ].obs;

  CourseProvider courseProvider = getIt();
  RxBool isCategoryLoading = false.obs;
  RxBool isDataLoading = false.obs;
  RxBool isTeacherLoading = false.obs;

  @override
  void onInit() async {
    getAllCategory();
    if (levelData.isNotEmpty) {
      if (!(levelData.any((element) => element.optionName == "All"))) {
        levelData.insert(0, DropDownData(optionName: "All", id: "0"));
      }
      final classLevel = await Get.find<AuthService>().getClassLevel();
      if (classLevel.isEmpty) {
        selectedLevel.add(
          DropDownData(
              id: Get.find<AuthService>().user.value.level?.id.toString(),
              displayName: null,
              optionName: Get.find<AuthService>()
                  .user
                  .value
                  .level
                  ?.level
                  .toString()
                  .toLowerCase()),
        );
      }

      selectedLevel.addAll(classLevel);
      List<DropDownData> updatedList = [];
      for (var x in selectedLevel) {
        if (!updatedList.any((e) => e.id == x.id)) {
          updatedList.add(x);
        }
      }
      selectedLevel.value = updatedList;
    }

    super.onInit();
  }

  Map<String, dynamic> onClearAll() {
    selectedSubscriptionFilter.value = 0;
    selectedLevel.clear();
    selectedRating.clear();
    listOFSelectedLang.clear();
    listOfSelectedTeacher.clear();
    listOFSelectedDuration.clear();
    listOFSelectedCat.clear();
    listOFSelectedDays.clear();
    listOFMentorShip.clear();
    listOFMentorShip.clear();

    selectedSub.value =
        DropDownData(id: "0", optionName: subscriptionData[0].toLowerCase());

    isCategoryLoading.value = true;
    isTeacherLoading.value = true;
    Future.delayed(const Duration(seconds: 1), () {
      isCategoryLoading.value = false;
      isTeacherLoading.value = false;
    });
    return {
      "category": listOFSelectedCat,
      "language": listOFSelectedLang,
      "level": selectedLevel,
      "duration": listOFSelectedDuration,
      "rating": selectedRating,
      "is_free": selectedSub.value,
      "teacher": listOfSelectedTeacher,
      "days": listOFSelectedDays,
      'mentor':listOFMentorShip
    };
  }

  getAllCategory({String sort = "ASC"}) async {
    isCategoryLoading.value = true;
    await courseProvider.getAllCategories(
        languageId: Get.find<AuthService>().user.value.languageId != null
            ? Get.find<AuthService>().user.value.languageId.toString()
            : "",
        searchKeyWord: "",
        onError: (message, errorMap) {
          isCategoryLoading.value = false;
          toastShow(message: message);
        },
        onSuccess: (message, json) async {
          category.AllCategoryModel data =
              category.AllCategoryModel.fromJson(json!);
          for (category.Datum? data in data.data ?? []) {
            categoryList.add(
                DropDownData(id: data?.id.toString(), optionName: data?.title));
          }
          isCategoryLoading.value = false;
        },
        sort: sort);
  }

  getAllTeachers() async {
    isTeacherLoading.value = true;
    await courseProvider.getTeacherData(onError: (message, map) {
      toastShow(message: message);
      isTeacherLoading.value = false;
    }, onSuccess: (message, json) {
      List list = json!['data'];
      teacherList.value = List.from(list.map((e) => TeacherModel.fromJson(e)));
      isTeacherLoading.value = false;
    });
  }

  Map<String, dynamic> onApply() {
    if (selectedLevel.any((element) => element.id == "0")) {
      selectedLevel.removeWhere((element) => element.id == "0");
    }

    if (selectedRating.any((element) => element.ratingValue == "all")) {
      selectedRating.removeWhere((element) => element.ratingValue == "all");
    }

    // final dateRange = getDateRangeForSelectedDay();
    return {
      "category": listOFSelectedCat,
      "level": selectedLevel,
      "duration": listOFSelectedDuration,
      "rating": selectedRating,
      "is_free": selectedSub.value,
      "teacher": listOfSelectedTeacher,
      "days": listOFSelectedDays,
      "mentor": listOFMentorShip,
      // "start_datetime": dateRange["start_datetime"],
      // "end_datetime": dateRange["end_datetime"],
    };
  }
}

class RatingDataVal {
  final String? ratingName;
  final String? ratingValue;

  RatingDataVal({this.ratingName, this.ratingValue});
}

extension TeacherModel on DropDownData {
  static fromJson(Map<String, dynamic> json) => DropDownData(
        id: json["id"].toString(),
        displayName: json['name'],
        optionName: json['name'],
      );

  Map<String, dynamic> toJson() => {
        "id": int.parse(id!),
        "name": optionName,
      };
}

