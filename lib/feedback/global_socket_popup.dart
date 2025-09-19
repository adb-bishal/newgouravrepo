import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/feedback/QuestionModel.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/home_provider.dart';

import '../model/network_calls/api_helper/provider_helper/account_provider.dart';
import '../model/network_calls/dio_client/get_it_instance.dart';
import 'live_class_rating_model.dart';

class GlobalSocketPopup extends StatelessWidget {
  final List<QuestionData>? questionList;
  final Map<String, dynamic>? userData;
  final dynamic? classDetails;
  final List<Map<String, dynamic>> selectedRatings = [];

  GlobalSocketPopup(
      {super.key, this.questionList, this.userData, this.classDetails});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Align(
              alignment: Alignment.topRight,
              child: GestureDetector(
                onTap: () async {
                  try {
                    Navigator.pop(context);
                    await feedbackCloseApi(
                      userId: userData?['id'],
                    );
                  } catch (e) {
                    Get.snackbar("Error", " $e",
                        dismissDirection: DismissDirection.down,
                        colorText: Colors.black,
                        backgroundColor: Colors.white,
                        snackPosition: SnackPosition.BOTTOM);
                  }
                },
                child: const Icon(Icons.close, color: Colors.black),
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Thank you for attending",
              style: TextStyle(fontSize: 14),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              classDetails?['title'] ?? "NA",
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              "Please share your valuable feedback!",
              style: TextStyle(fontSize: 14, color: Colors.black54),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            ...?questionList?.map((item) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: buildRatingRow(item),
              );
            }),
            const SizedBox(
              height: 8,
            )
          ],
        ),
      ),
    );
  }

  Widget buildRatingRow(QuestionData questionData) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
              child: Text(
            questionData.title.toString(),
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
          )),
          Expanded(
            child: RatingBar(
              itemSize: 30,
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              ratingWidget: RatingWidget(
                full: const Icon(Icons.star_rounded, color: Colors.amber),
                half: const Icon(Icons.star_half_rounded, color: Colors.amber),
                empty:
                    const Icon(Icons.star_border_rounded, color: Colors.grey),
              ),
              onRatingUpdate: (rating) async {
                if (kDebugMode) {
                  print('${questionData.title} rating: $rating');
                }
                final existingRating = selectedRatings.indexWhere(
                    (item) => item['question_list_id'] == questionData.id);

                if (existingRating != -1) {
                  selectedRatings[existingRating]['rating'] = rating.toInt();
                } else {
                  selectedRatings.add({
                    'question_list_id': questionData.id,
                    'rating': rating.toInt(),
                  });
                }
                try {
                  await submitLiveClassRating(
                    liveClassId: classDetails?['id'],
                    userId: userData?['id'],
                    ratings: selectedRatings,
                  );
                } catch (e) {
                  Get.snackbar("Error", " $e",
                      dismissDirection: DismissDirection.down,
                      colorText: Colors.black,
                      backgroundColor: Colors.white,
                      snackPosition: SnackPosition.BOTTOM);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> feedbackCloseApi({
    required int userId,
  }) async {
    HomeProvider homeProvider = getIt();

    await homeProvider.feedbackCloseApi(userId,
        onError: (String? message, Map<String, dynamic>? errorMap) {
      print("feedbackSkipApi OnError $errorMap");
      Get.snackbar('', errorMap?['message']);
    }, onSuccess: (String? message, Map<String, dynamic>? map) {
      print("feedbackSkipApi OnSuccess $map");

      // if (map != null && map['status'] == true) {
      //   // final data = LiveClassRatingModel.fromJson(map);
      //   Get.snackbar('Success', map['message'] ?? '',
      //       snackPosition: SnackPosition.BOTTOM,
      //       backgroundColor: Colors.black,
      //       colorText: Colors.white,
      //       animationDuration: Duration(milliseconds: 200));
      // }
    });
  }

  Future<void> submitLiveClassRating({
    required int liveClassId,
    required int userId,
    required List<Map<String, dynamic>> ratings,
  }) async {
    AccountProvider accountProvider = getIt();

    final payload = {
      "live_class_id": liveClassId,
      "user_id": userId,
      "ratings": ratings,
    };

    if (kDebugMode) {
      print('payload $payload');
    }

    await accountProvider.getLiveClassRating(payload,
        onError: (String? message, Map<String, dynamic>? errorMap) {
      print("OnError $errorMap");
      Get.snackbar('', errorMap?['message']);
    }, onSuccess: (String? message, Map<String, dynamic>? map) {
      print("OnSuccess $map");

      if (map != null && map['status'] == true) {
        // final data = LiveClassRatingModel.fromJson(map);
        Get.snackbar('Success', map['message'] ?? '',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.black,
            colorText: Colors.white,
            animationDuration: Duration(milliseconds: 200));
      }
    });
  }
}
