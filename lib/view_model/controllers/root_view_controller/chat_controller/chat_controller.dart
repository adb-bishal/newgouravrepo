import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/chat_provider.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../../model/models/chat_model/chat_bot_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';

class ChatController extends GetxController {
  ChatProvider chatProvider = getIt();
  Rx<ChatBotData> chatBotData = ChatBotData().obs;
  RxInt currentChatBotQuestionNumber = 0.obs;

  @override
  void onInit() {
    getChatBotData();
    super.onInit();
  }

  getChatBotData() async {
    await chatProvider.chatBotQuestion(onError: (message, errorMap) {
      toastShow(message: message);
    }, onSuccess: (message, json) {
      chatBotData.value = ChatBotData.fromJson(json ?? {});
    });
  }
}
