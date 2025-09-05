import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class WishListRepo {
  final DioClient dioClient;
  WishListRepo({
    required this.dioClient,
  });

  Future<ApiResponse> getWishlistsData() async {
    String url = "${AppConstants.instance.wishlist}/all_types";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getWishlistsTypeData(
      {required String type,
      required int pageNo,
      String? searchKeyWord,
      String? rating,
      String? subscription}) async {
    String url =
        "${AppConstants.instance.wishlist}?limit=20&page=$pageNo&type=$type&search=${searchKeyWord ?? ""}&rating=${rating ?? ""}&is_free=${subscription ?? ""}";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> saveToWatchLater(
      {required Map<String, dynamic> data}) async {
    String url = AppConstants.instance.wishlist;
    return dioClient.postResponse(url: url, data: data, dioClient: dioClient);
  }
}
