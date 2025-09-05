import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CountdownController extends GetxController {
  late DateTime targetTime;
  RxString countdownText = "".obs;
  RxString dayText = "".obs;
  RxString dayAfterText = "".obs;

  RxBool isTimerFinished = false.obs;

  Timer? timer;

  // Flag to ensure the countdown starts only once
  RxBool isCountdownStarted = false.obs;

  // Minute countdown variables
  RxString minuteCountdownText = "".obs;
  RxBool isMinuteTimerFinished = false.obs;
  Timer? minuteTimer;

  // Flag to track whether to show the minute countdown
  RxBool showMinuteCountdown = false.obs;

  void startCountdown(String timeString) {
    // Check if countdown has already started
    if (isCountdownStarted.value) {
      return; // Do not start the countdown again if it's already running
    }

    try {
      targetTime = DateTime.parse(timeString);

      // Set the flag to true to indicate the countdown has started
      isCountdownStarted.value = true;

      // Start the timer
      timer = Timer.periodic(Duration(seconds: 1), (timer) {
        final now = DateTime.now();
        final difference = targetTime.difference(now);

        if (difference.isNegative || difference.inSeconds == 0) {
          countdownText.value = "Time's up!";
          isTimerFinished.value = true;
          timer.cancel();
        } else {
          countdownText.value = formatDuration(difference);
        }
      });
    } catch (e) {
      countdownText.value = "Invalid time format!";
    }
  }

  String formatDuration(Duration duration) {
    DateTime now = DateTime.now();
    DateTime targetDate = now.add(duration);

    int daysDifference =
        targetDate.difference(DateTime(now.year, now.month, now.day)).inDays;

    if (daysDifference == 1) {
      return "$daysDifference day";
    } else if (daysDifference > 1 && daysDifference <= 2) {
      return "$daysDifference days";
    } else if (daysDifference > 2) {
      return "Registered";
    } else {
      final hours = duration.inHours.remainder(24);
      final minutes = duration.inMinutes.remainder(60);
      final seconds = duration.inSeconds.remainder(60);
      return "${hours.toString().padLeft(2, '0')}:${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}";
    }
  }

  String formatDate(DateTime startTime) {
    DateTime now = DateTime.now();
    DateTime tomorrow = now.add(Duration(days: 1));
    DateTime dayAfterTomorrow = now.add(Duration(days: 2));

    String formattedDate = DateFormat("dd MMM yyyy").format(startTime);

    if (startTime.year == now.year &&
        startTime.month == now.month &&
        startTime.day == now.day) {
      dayText.value = "Today";
      return "Today";
    } else if (startTime.year == tomorrow.year &&
        startTime.month == tomorrow.month &&
        startTime.day == tomorrow.day) {
      dayText.value = "Tomorrow";
      return "Tomorrow";
    } else if (startTime.year == dayAfterTomorrow.year &&
        startTime.month == dayAfterTomorrow.month &&
        startTime.day == dayAfterTomorrow.day) {
      dayText.value = formattedDate;
      dayAfterText.value = "DayAfterTomorrow";
      return "Day After Tomorrow";
    } else {
      dayText.value = formattedDate;
      return formattedDate;
    }
  }

  @override
  void onClose() {
    timer?.cancel();
    minuteTimer?.cancel();
    super.onClose();
  }

}



