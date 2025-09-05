
import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

// class LiveRepo {
//   final DioClient dioClient;
//   LiveRepo({
//     required this.dioClient,
//   });
//
//   Future<ApiResponse> getLiveData(
//       {required int pageNo,
//       required bool isPast,
//       bool isMyClass = false,
//       String? searchKeyWord,
//       String? categoryId,
//       String? currentId,
//         String? dateFilter,
//       String? teacherId,
//       String? langId,
//       String? levelId,
//       String? duration,
//       String? rating,
//       String? subscriptionLevel}) async {
//     String url;
//     if (isMyClass) {
//       url = "${AppConstants.instance.myClassLive}?limit=20&page=$pageNo&category_ids=${categoryId ?? ""}&level_ids=${levelId ?? ""}&language_ids=${langId ?? ""}&user_id=${teacherId ?? ""}&duration=${duration ?? ""}&rating=${rating ?? ""}&subscription_level=${subscriptionLevel ?? ""}&search=${searchKeyWord ?? ""}&current_id=${currentId ?? ""}";
//       print('urlss: $url');
//     } else {
//       url = "${isPast ? AppConstants.instance.pastLive : AppConstants.instance.live}?limit=20&page=$pageNo&category_ids=${categoryId ?? ""}&level_ids=${levelId ?? ""}&language_ids=${langId ?? ""}&user_id=${teacherId ?? ""}&duration=${duration ?? ""}&rating=${rating ?? ""}&subscription_level=${subscriptionLevel ?? ""}&search=${searchKeyWord ?? ""}&current_id=${currentId ?? ""}&date_filter=${isPast ? dateFilter : "tomorrow"}";
//
//       // url = "${isPast ? AppConstants.instance.pastLive : AppConstants.instance.live}?limit=20&page=$pageNo&category_ids=${categoryId ?? ""}&level_ids=${levelId ?? ""}&language_ids=${langId ?? ""}&user_id=${teacherId ?? ""}&duration=${duration ?? ""}&rating=${rating ?? ""}&subscription_level=${subscriptionLevel ?? ""}&search=${searchKeyWord ?? ""}&current_id=${currentId ?? ""}&date_filter=${dateFilter??""}";
//       //print('Final URL (isPast=$isPast): $url');
//     }
//     print('urls: $url');
//     return dioClient.getResponse(url: url, dioClient: dioClient);
//   }
//
//   Future<ApiResponse> getLiveDataDetail({
//     required String id,
//   }) async {
//     String url = "${AppConstants.instance.live}/$id";
//     return dioClient.getResponse(url: url, dioClient: dioClient);
//   }
//
//   Future<ApiResponse> postVideoJoinStatus(Map<String, dynamic> mapData) async {
//     String url = AppConstants.instance.live;
//     return dioClient.postResponse(
//         url: url, dioClient: dioClient, data: mapData);
//   }
//
//   Future<ApiResponse> postLiveCallStatus(Map<String, dynamic> mapData) async {
//     String url = AppConstants.instance.postLiveCallStatus;
//     return dioClient.postResponse(
//         url: url, dioClient: dioClient, data: mapData);
//   }
//
//   Future<ApiResponse> onBuyPackage(
//       {int? pageNo, required Map<String, dynamic> mapData}) async {
//     String url = AppConstants.instance.buyLivePackage;
//     return dioClient.postResponse(
//         url: url, dioClient: dioClient, data: mapData);
//   }
// }
class LiveRepo {
  final DioClient dioClient;

  LiveRepo({
    required this.dioClient,
  });

  Future<ApiResponse> getLiveData(
      {required int pageNo,
        required bool isPast,
        bool isMyClass = false,
        String? searchKeyWord,
        String? categoryId,
        String? currentId,
        String? dateFilter,
        String? teacherId,
        String? langId,
        String? levelId,
        String? duration,
        String? rating,
        bool isFilter = false,
        String? subscriptionLevel}) async {
    String url;
    if (isMyClass) {
      url =
      "${AppConstants.instance.myClassLive}?limit=20&page=$pageNo&category_ids=${categoryId ?? ""}&level_ids=${levelId ?? ""}&language_ids=${langId ?? ""}&user_id=${teacherId ?? ""}&duration=${duration ?? ""}&rating=${rating ?? ""}&subscription_level=${subscriptionLevel ?? ""}&search=${searchKeyWord ?? ""}&current_id=${currentId ?? ""}&date_filter=${isPast ? dateFilter : dateFilter}";
    } else {
      if(isFilter){
        url = "${isPast ? AppConstants.instance.pastLive : AppConstants.instance.live}?limit=20&page=$pageNo&category_ids=${categoryId ?? ""}&level_ids=${levelId ?? ""}&language_ids=${langId ?? ""}&user_id=${teacherId ?? ""}&duration=${duration ?? ""}&rating=${rating ?? ""}&subscription_level=${subscriptionLevel ?? ""}&search=${searchKeyWord ?? ""}&current_id=${currentId ?? ""}&date_filter=${dateFilter ?? ""}";
      }else{
        url = "${isPast ? AppConstants.instance.pastLive : AppConstants.instance.live}?limit=20&page=$pageNo&category_ids=${categoryId ?? ""}&level_ids=${levelId ?? ""}&language_ids=${langId ?? ""}&user_id=${teacherId ?? ""}&duration=${duration ?? ""}&rating=${rating ?? ""}&subscription_level=${subscriptionLevel ?? ""}&search=${searchKeyWord ?? ""}&current_id=${currentId ?? ""}";
      }
      //logPrint("getDateFilterDatas $dateFilter");
    }
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> getLiveDataDetail({
    required String id,
  }) async {
    String url = "${AppConstants.instance.live}/$id";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> postVideoJoinStatus(Map<String, dynamic> mapData) async {
    String url = AppConstants.instance.live;
    return dioClient.postResponse(
        url: url, dioClient: dioClient, data: mapData);
  }
   Future<ApiResponse> postLiveCallStatus(Map<String, dynamic> mapData) async {
    String url = AppConstants.instance.postLiveCallStatus;
    return dioClient.postResponse(
        url: url, dioClient: dioClient, data: mapData);
  }
  Future<ApiResponse> onBuyPackage(
      {int? pageNo, required Map<String, dynamic> mapData}) async {
    String url = AppConstants.instance.buyLivePackage;
    return dioClient.postResponse(
        url: url, dioClient: dioClient, data: mapData);
  }
}
