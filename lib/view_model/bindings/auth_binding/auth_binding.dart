import 'package:get/get.dart';

import '../../controllers/auth_controllers/login_controller.dart';
import '../../controllers/auth_controllers/sign_up_controller.dart';

class AuthBinding extends Bindings{

  @override
  void dependencies() {
    Get.lazyPut<LoginController>(() => LoginController());
    Get.lazyPut<SignUpController>(() => SignUpController());
  }

}