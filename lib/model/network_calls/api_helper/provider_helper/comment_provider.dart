import '../../../models/network_call_model/api_response.dart';
import '../repository_helper/comment_repo.dart';
import 'account_provider.dart';

class CommentProvider {
  final CommentRepo commentRepo;
  CommentProvider({required this.commentRepo});

  Future getComment({required Function(String? message,Map<String, dynamic>? errorMap) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required int pageNo, required String id}) async {
    ApiResponse apiResponse = await commentRepo.getComment(pageNo: pageNo,id: id);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future postComment({required Function(String? message,Map<String, dynamic>? errorMap) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required Map<String, dynamic> data}) async {
    ApiResponse apiResponse = await commentRepo.postComment(data);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}
