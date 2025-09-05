import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/root_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

class FeedbackController extends GetxController{
  RootProvider rootProvider = getIt();
  final GlobalKey<FormState> feedbackFormKey = GlobalKey<FormState>();
  Rx<TextEditingController> emailController  = TextEditingController().obs;
  Rx<TextEditingController> nameController  = TextEditingController().obs;
  Rx<TextEditingController> feedBackController  = TextEditingController().obs;
  RxString emailError = "".obs;
  RxString feedBackError = "".obs;
  RxString nameError = "".obs;
  RxBool isPostLoading = false.obs;

  postFeedback()async{
    if(feedbackFormKey.currentState?.validate()??false){
      isPostLoading.value = true;
      await rootProvider.postFeedback(onError: (message,errorMap){
        isPostLoading.value = false;
        toastShow(message: message);
      }, onSuccess: (message,json){
        isPostLoading.value = false;
        toastShow(message: message,error: false);
        Get.back();
      }, data: {
        "name":nameController.value.text,
        "email":emailController.value.text,
        "message":feedBackController.value.text,
      });
    }
  }

  @override
  void onInit() {
   emailController.value.text = Get.find<AuthService>().user.value.email??"";
   nameController.value.text = Get.find<AuthService>().user.value.name??"";
    super.onInit();
  }
}