import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class RatingRepo {

  final DioClient dioClient;
  RatingRepo({
    required this.dioClient,
  });

  Future<ApiResponse> getRating({required int pageNo,required String type,required String id}) async {
    String url = "${AppConstants.instance.reviews}?limit=10&page=$pageNo&type=$type&reviewable_id=$id";
    return dioClient.getResponse(url: url,dioClient: dioClient);
  }

  Future<ApiResponse> postRating(Map<String,dynamic> data) async {
    String url = AppConstants.instance.reviews;
    return dioClient.postResponse(url: url,dioClient: dioClient,data: data);
  }

}