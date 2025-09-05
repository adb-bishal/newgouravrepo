
import 'package:get/get.dart';

import '../../../models/network_call_model/api_response.dart';
import '../../../services/auth_service.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class QuizRepo {

  final DioClient dioClient;
  QuizRepo({
    required this.dioClient,
  });

  Future<ApiResponse> getQuiz({required int pageNo,int? isScholarship,String? categoryId,String? languageId,String? searchKeyword,String? subscriptionLevel}) async {
    String url = "${AppConstants.instance.quiz}$pageNo&is_scholarship=${isScholarship??""}&category_id=${categoryId??""}&language_id=${languageId??""}&search=${searchKeyword??""}&is_free=${subscriptionLevel??""}";
    return dioClient.getResponse(url: url,dioClient: dioClient);
  }
  Future<ApiResponse> getQuizById({required String quizId}) async {
    String url = "${AppConstants.instance.quizById}/$quizId";
    return dioClient.getResponse(url: url,dioClient: dioClient);
  }
  Future<ApiResponse> getQuizResult({required Map<String,dynamic> mapData}) async {
    String url = "${AppConstants.instance.quizById}${Get.find<AuthService>().isGuestUser.value ? "-guest-user":""}";
    return dioClient.postResponse(url: url,dioClient: dioClient,data: mapData);
  }

}