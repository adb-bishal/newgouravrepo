import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:get_storage/get_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:stockpathshala_beta/main.dart';
import 'package:stockpathshala_beta/mentroship/model/mentorship_details_model.dart';
import 'package:stockpathshala_beta/mentroship/view/mentorship_detail_screen.dart';
import 'package:stockpathshala_beta/view_model/routes/app_pages.dart';
import '../../model/services/auth_service.dart';
import '../../model/utils/app_constants.dart';
import '../../model/utils/string_resource.dart';
import 'package:get/get.dart';

import '../../service/floor/clientService.dart';
import '../../view_model/controllers/root_view_controller/root_view_controller.dart';

class MentorshipDetailController extends GetxController {
  var mentorshipDataUi = Rxn<MentorshipDetailUI>();
  var mentorshipDetailData = Rxn<MentorshipDetailData>();
  var isLoading = true.obs;
  var errorMessage = ''.obs;
  var isShow = false.obs;
  RxString serverTime = ''.obs;
  // late String mentorshipId;
  RxBool isStarted = false.obs;
  RxInt start = 0.obs;
  RxList<String> time = <String>[].obs;
  RxString participant = "".obs;

  RxList<Map<String, DateTime>> mentorshipClassTimes =
      <Map<String, DateTime>>[].obs;

  // Timer-related variables
  RxList<Timer?> timers = <Timer?>[].obs; // List of timers
  var isTimerActive = false.obs;

  RxInt countValue = 0.obs;

  RxInt timeInSeconds = 0.obs;
  RxBool showJoinButton = false.obs;
  RxBool timerTrue = false.obs;
  RxBool onRegister = false.obs;
  RxBool threebutton = false.obs;

  var isCountdownFinished = false.obs;

  DateTime currentDate = DateTime.now();

  RxList<int> isRegisterList = <int>[].obs;
  RxList<String> isClassStatusList = <String>[].obs;
  RxList<int> mentorshipClassTimeDifferences = <int>[].obs; // in seconds
  RxList<int> mentorshipClassDaysLeft = <int>[].obs;
  RxBool isAnyClassLessThanOneDay = false.obs;

  String token = Get.find<AuthService>().getUserToken();

  Dio _dio = Dio();
  var mentorshipId = Get.arguments?['id'] ?? '';

  String baseUrl = '${AppConstants.instance.baseUrl}mentorship/';

  // RxBool isReloading = false.obs;
  @override
  void onInit() {
    super.onInit();
    // Retrieve the passed 'id' argument
    // mentorshipId = Get.arguments['id'];

    var mentorshipId = Get.arguments?['id'] ?? '';
    print("mentorShip $mentorshipId");
    // SystemChrome.setEnabledSystemUIMode(SystemUiMode.leanBack);

    fetchMentorshipData(mentorshipId);
    // fetchMentorshipDataUI();
  }

  @override
  void onReady() {
    super.onReady();
    print("Controller is ready");
  }

  @override
  void onClose() {
    for (var t in timers) {
      t?.cancel();
    }
    timers.clear();
    super.onClose();
    print("Controller Closed");
  }

  // @override
  // void onClose() {
  //   timer?.cancel();
  //   timer = null;
  //   super.onClose();
  //   // Unregister the observer when the controller is closed
  //   print("Controller Closed");
  // }

  @override
  Future<void> onReload() async {
    print('drfgdfv');
    SharedPreferences mentorId = await SharedPreferences.getInstance();
    String mentorIdValue = mentorId.getString('mId') ?? '';
    // print("Get.arguments: ${Get.arguments}"); // Debugging
    // print("Type of Get.arguments: ${Get.arguments.runtimeType}"); // Debugging

    // var mentorshipId = '';

    // if (Get.arguments is Map<String, dynamic>) {
    //   mentorshipId = Get.arguments['id'] ?? '';
    // } else {
    //   print("Unexpected type for Get.arguments: ${Get.arguments.runtimeType}");
    // }

    if (mentorIdValue.isNotEmpty) {
      print('thrgfdbvrdfg');
      // fetchMentorshipDataUI();
      fetchMentorshipData(mentorIdValue);
      threebutton.value = true;
    }
    print("Reload triggered.");
  }


  Future<void> fetchMentorshipData(String mentorshipId) async {
    // isLoading(true);
    errorMessage('');
    print('sdvsdc $token');

    // // Base URLs
    // String betaBaseUrl =
    //     'https://sp-backend-beta.stockpathshala.com/api/v1/mentorship/';
    // String internalBaseUrl =
    //     'https://internal.stockpathshala.in/api/v1/mentorship/';

// URLs for Internal
//     String url = '${internalBaseUrl}${mentorshipId}?device=${Platform.isIOS ? "ios" : "android"}';

// URLs for Beta
    String url =
        '$baseUrl$mentorshipId?device=${Platform.isIOS ? "ios" : "android"}';

// For reference
// Beta base URL: 'https://sp-backend-beta.stockpathshala.com'; // beta link

    // String url =
    //     '${AppConstants.instance.baseUrl}mentorship/${mentorshipId}?device=${Platform.isIOS ? "ios" : "android"}';

    try {
      final response = await _dio.get(
        "$url",
        options: Options(
          headers: token.isNotEmpty ? {'Authorization': 'Bearer $token'} : {},
        ),
      );
      if (response.statusCode == 200) {
        print('dvscsdc ${response.data}');
        isRegisterList.clear();
        isClassStatusList.clear();
        time.clear();
        mentorshipDetailData.value =
            MentorshipDetailData.fromJson(response.data['data']);

        serverTime.value = response.data['server_time'];

        print("serverTime is : ${serverTime.value}");

        // Convert serverTime to DateTime
        DateTime serverDateTime = DateTime.parse(serverTime.value);

        // Extract mentorship_classes list
        List<dynamic> classes = response.data['data']['mentorship_classes'];

        // Iterate over the classes and extract start and end times
        for (int i = 0; i < classes.length; i++) {
          String startTimeString = classes[i]['start_datetime'];
          String endTimeString = classes[i]['end_datetime'];

          try {
            DateTime startTime = DateTime.parse(startTimeString);
            DateTime endTime = DateTime.parse(endTimeString);

            // Calculate the difference between the current time and start time
            Duration timeDifference = startTime.difference(serverDateTime);
            mentorshipClassTimeDifferences
                .add(timeDifference.inSeconds); // store difference in seconds

            // Add the start and end times as a map to the mentorshipClassTimes list
            mentorshipClassTimes.add({
              'startTime': startTime,
              'endTime': endTime,
            });

            // Check if the time difference is less than 3600 seconds and start countdown if true
            if (timeDifference.inSeconds < 86400) {
              startCountdownForClass(i); // Start countdown for this class
            }
          } catch (e) {
            print("Error parsing date strings: $e");
          }
        }

// Print the mentorshipClassTimes list for verification
        print('Mentorship Class Times:');
        mentorshipClassTimes.forEach((classTime) {
          print(
              'Start Time: ${classTime['startTime']}, End Time: ${classTime['endTime']}');
        });

// Print the mentorshipClassTimeDifferences list for verification
        print('Mentorship Class Time Differences (in seconds):');
        mentorshipClassTimeDifferences.forEach((timeDiff) {
          print('Time Difference: $timeDiff seconds');
        });

        // Clear existing data in the list
        // isRegisterList.clear();

        // Iterate over the classes and extract is_register values
        for (var mentorshipClass in classes) {
          try {
            int isRegisterValue = mentorshipClass['is_register'] ?? 0;
            isRegisterList.add(isRegisterValue);

            String isClassStatusValue = mentorshipClass['class_status'] ?? 0;
            isClassStatusList.add(isClassStatusValue);
          } catch (e) {
            print("Error extracting is_register: $e");
          }
        }

        // for (var mentorshipClass in classes) {
        //   try {
        //     int isClassStatusValue = mentorshipClass['class_status'] ?? 0;
        //     isClassStatusList.add(isClassStatusValue);
        //   } catch (e) {
        //     print("Error extracting is_register: $e");
        //   }
        // }

        // Print the isRegisterList for verification
        print('isClasssList: $isClassStatusList');
      } else {
        errorMessage('Failed to load data');
      }
    } catch (e) {
      errorMessage('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  void startCountdownForClass(int classIndex) {
    int timeDifference = mentorshipClassTimeDifferences[classIndex];

    if (timeDifference < 86400) {
      // Ensure the time and timers lists have enough items
      while (time.length <= classIndex) {
        time.add("0");
      }
      while (timers.length <= classIndex) {
        timers.add(null);
      }

      time[classIndex] = timeDifference.toString();

      timers[classIndex]?.cancel(); // Cancel previous timer if any

      timers[classIndex] = Timer.periodic(Duration(seconds: 1), (Timer t) {
        int remainingTime = int.tryParse(time[classIndex]) ?? 0;

        if (remainingTime <= 0) {
          t.cancel();
          time[classIndex] = "0";
          isStarted.value = true;
          timerTrue.value = true;
        } else {
          time[classIndex] = (remainingTime - 1).toString();
          isStarted.value = false;
          timerTrue.value = false;
        }
      });
    }
  }


  Future<void> joinForLiveClass(int id, String type) async {
    String baseUrl =
        '${AppConstants.instance.baseUrl}live_classes'; // Your actual base URL

    try {
      // Prepare the body and headers
      var body = {
        'live_class_id': id,
        'type': type,
      };

      // Send the POST request
      final response = await _dio.post(
        baseUrl,
        data: jsonEncode(body), // Use jsonEncode to send the body as JSON
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add the token here
            'Content-Type':
                'application/json', // Ensure the Content-Type is application/json
          },
        ),
      );

      // Handle the response
      if (response.statusCode == 200) {
        print('Response received successfully.');
        // Assuming participant is a reactive variable
        participant.value = response.data['data']['participant_link'];
        print('Participant Link: ${participant.value}');
        // You can use the participant link here or navigate to a different screen
      } else {
        print('Error: ${response.data['message']}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> onRegisterForLiveClass(int id, String type) async {
    String baseUrl =
        '${AppConstants.instance.baseUrl}live_classes'; // Your actual base URL

    try {
      // Prepare the body and headers
      var body = {
        'live_class_id': id,
        'type': type,
      };

      // Send the POST request
      final response = await _dio.post(
        baseUrl,
        data: jsonEncode(body), // Use jsonEncode to send the body as JSON
        options: Options(
          headers: {
            'Authorization': 'Bearer $token', // Add the token here
            'Content-Type':
                'application/json', // Ensure the Content-Type is application/json
          },
        ),
      );

      // Handle the response
      if (response.statusCode == 200) {
        onRegister.value = true;
        print('Response received successfully.');
        // Assuming participant is a reactive variable
        participant.value = response.data['data']['participant_link'];

        print('Participant Link: ${participant.value}');

        SharedPreferences mentorId = await SharedPreferences.getInstance();
        String mentorIdValue = mentorId.getString('mId') ?? '';
        // Get.back();
        // Get.toNamed(
        //   Routes.mentorshipDetail(
        //     id: mentorIdValue,
        //   ),
        //   arguments: {
        //     'id': mentorIdValue,
        //   },
        // );

        // onReload();

        // print("paymenteddas");
        // fetchMentorshipData(mentorIdValue);
        update();
        // You can use the participant link here or navigate to a different screen
      } else {
        print('Error: ${response.data['message']}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   timer?.cancel();
  //   timer = null;

  //   print('Aman');
  //   // // Dispose of the controller resources
  //   // mentorshipDataUi.close();
  //   // mentorshipDetailData.close();
  //   // isLoading.close();
  //   // errorMessage.close();
  //   // // isStarted.close();
  //   // start.close();
  //   // time.close();
  //   // participant.close();
  //   // mentorshipClassTimes.close();
  //   // // isTimerActive.close();
  //   // countValue.close();
  //   // timeInSeconds.close();
  //   // showJoinButton.close();
  //   // timerTrue.close();
  //   // isCountdownFinished.close();
  //   // mentorshipClassTimeDifferences.close();

  //   super.dispose();
  // }
}
