import 'package:stockpathshala_beta/model/network_calls/api_helper/repository_helper/wishlist_repo.dart';

import '../../../models/network_call_model/api_response.dart';
import 'account_provider.dart';

class WishListProvider {
  final WishListRepo wishListRepo;
  WishListProvider({required this.wishListRepo});

  Future getWishlistsData({required Function(String? message,Map<String, dynamic>? errorMap) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess}) async {
    ApiResponse apiResponse = await wishListRepo.getWishlistsData();
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  Future getWishlistsTypeData({required Function(String? message,Map<String, dynamic>? errorMap) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required String type,required int pageNo,required String searchKeyWord,String? rating,String? subscriptionLevel = ""}) async {
    ApiResponse apiResponse = await wishListRepo.getWishlistsTypeData(type: type,pageNo: pageNo,searchKeyWord:searchKeyWord,rating:rating??"" , subscription:subscriptionLevel??"");
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  Future saveToWatchLater({required Function(String? message,Map<String, dynamic>? errorMap) onError, required Function(String? message, Map<String, dynamic>? map)onSuccess,required Map<String, dynamic> data}) async {
    ApiResponse apiResponse = await wishListRepo.saveToWatchLater(data:data);
    CheckApiResponse.instance.initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}