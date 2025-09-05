import '../../../models/network_call_model/api_response.dart';
import '../repository_helper/quiz_repo.dart';
import 'account_provider.dart';

class QuizProvider {
  final QuizRepo quizRepo;
  QuizProvider({required this.quizRepo});

  Future getQuiz({required Function(String? message,Map<String, dynamic>? errorMap) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required int pageNo, int? isScholarship,String? categoryId,String? languageId,String? searchKeyword,String? subscriptionLevel}) async {
    ApiResponse apiResponse = await quizRepo.getQuiz(pageNo: pageNo,isScholarship: isScholarship,categoryId: categoryId,languageId: languageId,searchKeyword:searchKeyword,subscriptionLevel: subscriptionLevel);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getQuizResult({required Function(String? message,Map<String, dynamic>? errorMap) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required Map<String, dynamic> mapData}) async {
    ApiResponse apiResponse = await quizRepo.getQuizResult(mapData: mapData);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getQuizById({required Function(String? message,Map<String, dynamic>? errorMap) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required String quizId,}) async {
    ApiResponse apiResponse = await quizRepo.getQuizById(quizId: quizId);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

}
