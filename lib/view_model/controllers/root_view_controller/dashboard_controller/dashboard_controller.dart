import 'dart:io';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/dashboard/dashboard_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/root_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:stockpathshala_beta/view/widgets/view_helpers/progress_dialog.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';

import '../../../../model/models/dashboard/user_history_model.dart';
import '../../../../view/widgets/alert_dialog_popup.dart';

class DashboardController extends GetxController {
  RxList<int> selectedStreak = <int>[].obs;
  RootProvider rootProvider = getIt();
  RxBool isAddActive = false.obs;
  RxBool isAddGoalLoading = false.obs;
  RxBool isDataLoading = false.obs;
  RxBool isRedeemLoading = false.obs;
  RxList<String> newGoalList = <String>[].obs;
  TextEditingController goalController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final double width = 5;
  RxDouble graphInterval = 1.0.obs;
  Rx<DashboardModel> dashboardData = DashboardModel().obs;
  Rx<UserHistoryModel> userHistoryModel = UserHistoryModel().obs;
  RxList<DateTime> dateList = <DateTime>[].obs;
  late List<BarChartGroupData> rawBarGroups = <BarChartGroupData>[];
  late List<BarChartGroupData> showingBarGroups = <BarChartGroupData>[];

  RxInt touchedGroupIndex = (-1).obs;

  @override
  void onInit() {
    getDashBoardData();
    getUserHistory();
    super.onInit();
  }

  getDashBoardData({bool isFirst = true}) async {
    if (isFirst) {
      isDataLoading(true);
    }
    await rootProvider.getDashBoardData(onError: (message, errorMap) {
      toastShow(message: message);
    }, onSuccess: (message, json) {
      dashboardData.value = DashboardModel.fromJson(json!);
      if (dashboardData.value.data?.goal?.id != null) {
        newGoalList.add(
            "${dashboardData.value.data?.goal?.time.toString() ?? ""} minutes");
        isAddActive.value = false;
      }
      isDataLoading(false);
    });
  }

  onRedeemNow() async {
    if ((dashboardData.value.data?.totalPoints ?? 0) >= 200) {
      ProgressDialog().showRedeemDialog(
          onDone: _onRedeem,
          coins: dashboardData.value.data?.totalPoints.toString() ?? "",
          buttonText: "Continue",
          title:
              "Avail ${dashboardData.value.data?.totalPoints.toString() ?? ""} Points Discount on the Pro Plan Now. Continue?");
    } else {
      toastShow(message: "Minimum 200 Points Required to Redeem");
    }
  }

  _onRedeem() async {
    isRedeemLoading(true);
    await rootProvider.onRedeem(onError: (message, errorMap) {
      toastShow(message: message);
      isRedeemLoading(false);
      //isDataLoading(false);
    }, onSuccess: (message, json) {
      getDashBoardData(isFirst: false);
      Get.back();
      isRedeemLoading(false);
      ShowToastFlash(
              title:
                  "Your redeem points converted into promo code. Code is ${json?['data']['code']}\nLater you can check your promocode list.",
              message: "",
              positiveButton: "",
              negativeButton: "")
          .present(Get.context!, duration: const Duration(seconds: 4),
              onPositiveAction: () {
        Get.toNamed(Routes.promoCode);
      });
      if (Platform.isAndroid) {
        Get.toNamed(Routes.subscriptionView, arguments: {
          "code": json?['data']['code'],
          "id": json?['data']['id']
        });
      }
    });
  }

  getUserHistory() async {
    await rootProvider.getUserActivity(onError: (message, errorMap) {
      toastShow(message: message);
      isDataLoading(false);
      //isDataLoading(false);
    }, onSuccess: (message, json) {
      userHistoryModel.value = UserHistoryModel.fromJson(json!);
      if (userHistoryModel.value.data != null) {
        generateDateList();
      }
      isDataLoading(false);
    });
  }

  generateDateList() {
    DateTime startDate =
        (userHistoryModel.value.data?.startDate ?? DateTime(1));
    DateTime endDate =
        (userHistoryModel.value.data?.endDate ?? DateTime(1)).toLocal();
    int difference = endDate.difference(startDate).inDays;
    dateList.value = List<DateTime>.generate(
        difference + 1,
        (i) => DateTime(
              startDate.year,
              startDate.month,
              startDate.day,
            ).add(Duration(days: i)));
    List<BarChartGroupData> items = [];
    int i = 0;
    for (UserAverageTime userAverageTime
        in userHistoryModel.value.data?.userAverageTime ?? []) {
      items.add(makeGroupData(i, double.parse(userAverageTime.avgTime ?? "0")));
      i++;
    }
    if (userHistoryModel.value.data?.maxTime != null &&
        (userHistoryModel.value.data?.maxTime ?? 0) > 0) {
      graphInterval.value = ((userHistoryModel.value.data?.maxTime ?? 1) / 10);
    }
    rawBarGroups.addAll(items);

    showingBarGroups.addAll(rawBarGroups);
  }

  BarChartGroupData makeGroupData(int x, double y) {
    return BarChartGroupData(
      barsSpace: 2,
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          fromY: 0,
          color: ColorResource.primaryColor,
          width: width,
        ),
      ],
    );
  }

  onAddNewGoal() async {
    if (formKey.currentState?.validate() ?? false) {
      isAddGoalLoading(true);
      await rootProvider.setGoal(
          onError: (message, errorMap) {
            logPrint(message);
            isAddGoalLoading(false);
          },
          onSuccess: (message, json) {
            newGoalList.add("${goalController.text} minutes");
            isAddActive.value = false;
            goalController.clear();
            isAddGoalLoading(false);
          },
          data: {"time": goalController.text});
    }
  }

  onDeleteGoal(int index) async {
    isAddGoalLoading(true);
    await rootProvider.deleteGoal(
      onError: (message, errorMap) {
        isAddGoalLoading(false);
      },
      onSuccess: (message, json) {
        newGoalList.removeAt(index);
        isAddGoalLoading(false);
      },
    );
  }
}
