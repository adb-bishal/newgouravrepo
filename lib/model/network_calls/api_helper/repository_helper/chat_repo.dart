import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class ChatRepo {
  final DioClient dioClient;
  ChatRepo({
    required this.dioClient,
  });

  Future<ApiResponse> chatBotQuestion() async {
    String url = AppConstants.instance.chatBotQuestion;
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }
}
