import 'package:get/get.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/chat_controller/chat_controller.dart';

class ChatBinding extends Bindings{
  @override
  void dependencies() {
   Get.lazyPut<ChatController>(() => ChatController());
  }

}