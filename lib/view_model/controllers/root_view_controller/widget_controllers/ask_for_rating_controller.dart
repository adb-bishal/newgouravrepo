import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/rating_model/askForRating_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/ask_rating%20_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/model/services/pagination.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/alert_dialog_popup.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/rating_model/askForRating_model.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

class AskForRatingController extends GetxController {
  Rx<GlobalKey<FormState>> formKey = GlobalKey<FormState>().obs;

  // Observables for state management
  RxBool isLoading = false.obs; // Added for fetch state
  RxString feedbackError = "".obs;
  RxBool isPostLoading = false.obs;
  RxBool isShow = false.obs;
  RxDouble rating = 4.0.obs;
  AskRatingProvider askratingProvider = getIt();
  Rx<AskForRatingModel> askForRatingData = AskForRatingModel().obs;
  TextEditingController feedbackController = TextEditingController();

  late AppConstants appConstants;

  onRatingChange(val) {
    rating.value = val;
  }

  @override
  void onInit() {
    super.onInit();
    fetchAskForReview();
  }

  Dio dio = getIt<Dio>(); // Initialize Dio

  /// Fetch AskForReview data from the API
  Future<void> fetchAskForReview() async {
    String url = '${AppConstants.instance.baseUrl}ask-for-review';
    print("bdnjsbfdbsb ${url}");
    isLoading.value = true;
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        final data = response.data['data'];
        print('ewrfewrcd $data');
        // print('sdfrgwedsc ${data == null}');
        // print('sdfrgwedsc ${data == ''}');

        isShow.value = data != null ? true : false;
        print('ewrfewrcd ${isShow.value}');
        // Update askForRatingData with new data and trigger the UI update
        if (data != null) {
          askForRatingData.value = AskForRatingModel.fromJson(data);
          logPrint("Fetch successful: ${askForRatingData.value.toString()}");
          logPrint("Fetch successful: ${askForRatingData.value.title}");

          askForRatingData
              .refresh(); // Refresh the data to notify GetX of changes
        }
      } else {
        logPrint("Failed to fetch data: ${response.statusMessage}");
        // toastShow(message: "Failed to fetch data");
      }
    } catch (e) {
      logPrint("Error while fetching AskForReview: $e");
      // toastShow(message: "Failed to fetch data");
    } finally {
      isLoading.value = false;
    }
  }

  /// Post feedback and rating to the API
  Future<void> postRating({required String type, required String id}) async {
    isPostLoading.value = true;
    await askratingProvider.postRating(
      onError: (message, errorMap) {
        isPostLoading.value = false;
        toastShow(message: message);
      },
      onSuccess: (message, map) {
        isPostLoading.value = false;
        Get.back();
        fetchAskForReview(); // Refresh data after posting the rating
        feedbackController.clear();
        rating.value = 4.0;
        toastShow(message: "Review added successfully");
      },
      data: <String, dynamic>{
        "type": type,
        "reviewable_id": id,
        "comment": feedbackController.text,
        "rating": rating.value,
      },
    );
  }
}
