import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class CommentRepo {

  final DioClient dioClient;
  CommentRepo({
    required this.dioClient,
  });

  Future<ApiResponse> getComment({required int pageNo,required String id}) async {
    String url = "${AppConstants.instance.getComment}$id?limit=10&page=$pageNo";
    return dioClient.getResponse(url: url,dioClient: dioClient);
  }

  Future<ApiResponse> postComment(Map<String,dynamic> data) async {
    String url = AppConstants.instance.postComment;
    return dioClient.postResponse(url: url,dioClient: dioClient,data: data);
  }

}