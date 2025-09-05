
import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/chat_repo.dart';

import '../../../models/network_call_model/api_response.dart';
import 'account_provider.dart';

class ChatProvider {
  final ChatRepo chatRepo;
  ChatProvider({required this.chatRepo});

  Future chatBotQuestion({required Function(String? message,Map<String, dynamic>? errorMap) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await chatRepo.chatBotQuestion();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}
