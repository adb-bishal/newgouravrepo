import '../../../models/network_call_model/api_response.dart';
import '../repository_helper/rating_repo.dart';
import 'account_provider.dart';

class AskRatingProvider {
  final RatingRepo ratingRepo;
  AskRatingProvider({required this.ratingRepo});

  Future getRating(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required int pageNo,
      required String type,
      required String id}) async {
    ApiResponse apiResponse =
        await ratingRepo.getRating(pageNo: pageNo, type: type, id: id);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  // Future getAskRating(
  //     {required Function(String? message, Map<String, dynamic>? errorMap)
  //         onError,
  //     required Function(String? message, Map<String, dynamic>? map)
  //         onSuccess}) async {
  //   ApiResponse apiResponse = await ratingRepo.getAskRatingg();
  //   print('rwefewdrfvc $apiResponse');
  //   CheckApiResponse.instance
  //       .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  // }

  Future postRating(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required Map<String, dynamic> data}) async {
    ApiResponse apiResponse = await ratingRepo.postRating(data);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}
