import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../view/widgets/log_print/log_print_condition.dart';

class ForgotPasswordController extends GetxController{
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  TextEditingController emailController  = TextEditingController();
  TextEditingController passwordController  = TextEditingController();
  var emailError = "".obs;
  var passwordError = "".obs;
  RxBool isPolicyChek = false.obs;
  RxBool isLoading = false.obs;

  VoidCallback get forgotPasswordTap =>(){
    if (formKey.currentState!.validate() &&  isLoading.value == false) {
      isLoading.value = true;
      try {
        // Get.toNamed(Routes.verifyOtpScreen,arguments: loginData);
        isLoading.value = false;
      } catch (e) {
        logPrint("this is login try error ${e.toString()}");
        isLoading.value = false;
      }
    }
  };
}