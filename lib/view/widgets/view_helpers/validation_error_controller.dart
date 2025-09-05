
import 'package:get/get.dart';

class ErrorController {
  RxString errorText =''.obs;
  RxBool isShow = false.obs;

  showError({required String message}){
    errorText.value = message;
    isShow.value  = true;
  }

  hideError(){
    errorText.value = '';
    isShow.value  = false;
  }
}
