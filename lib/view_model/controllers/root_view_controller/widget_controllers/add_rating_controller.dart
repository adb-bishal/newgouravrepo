import 'package:get/get.dart';

class AddRatingController extends GetxController{
  RxDouble rating = 0.0.obs;

  onRatingChange(val){
    rating.value = val;
  }

}