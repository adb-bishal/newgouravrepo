import '../../../models/network_call_model/api_response.dart';
import '../repository_helper/live_repo.dart';
import 'account_provider.dart';
class LiveProvider {
  final LiveRepo liveRepo;

  LiveProvider({required this.liveRepo});

  Future getLiveData(
      {required Function(String? message, Map<String, dynamic>? errorMap)
      onError,
        required Function(String? message, Map<String, dynamic>? map) onSuccess,
        required int pageNo,
        bool isPast = false,
        bool isMyClass = false,
        String? searchKeyWord,
        String? categoryId,
        String? dateFilter,
        String? langId,
        String? levelId,
        String? teacherId,
        String? currentId,
        String? duration,
        String? rating,
        String? subscriptionLevel}) async {
   print('getDateFilterDatas provider $dateFilter');
    bool isFilter = dateFilter != null && dateFilter.isNotEmpty;
    ApiResponse apiResponse = await liveRepo.getLiveData(
        pageNo: pageNo,
        isPast: isPast,
        categoryId: categoryId,
        langId: langId,
        levelId: levelId,
        dateFilter: dateFilter,
        duration: duration,
        teacherId: teacherId,
        rating: rating,
        subscriptionLevel: subscriptionLevel,
        searchKeyWord: searchKeyWord,
        currentId: currentId,
        isFilter: isFilter,
        isMyClass: isMyClass);
    CheckApiResponse.instance.initResponse(
      apiResponse,
      onSuccess: onSuccess,
      onError: onError,
    );
  }

  Future getLiveDataDetail({
    required Function(String? message, Map<String, dynamic>? errorMap) onError,
    required Function(String? message, Map<String, dynamic>? map) onSuccess,
    required String id,
  }) async {
    ApiResponse apiResponse = await liveRepo.getLiveDataDetail(id: id);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future postVideoJoinStatus(
      {required Function(
          String? message,
          Map<String, dynamic>? errorMap,
          ) onError,
        required Function(String? message, Map<String, dynamic>? map) onSuccess,
        required Function() onComplete,
        required Map<String, dynamic> mapData}) async {
    ApiResponse apiResponse = await liveRepo.postVideoJoinStatus(mapData);
    CheckApiResponse.instance.initResponse(
      apiResponse,
      onSuccess: (message, data) {
        onSuccess(message, data);
        onComplete(); // Call onComplete after success
      },
      onError: (message, errorMap) {
        onError(message, errorMap);
        onComplete(); // Call onComplete after error
      },
    );
  }

  Future postLiveCallStatus(
      {required Function(String? message, Map<String, dynamic>? errorMap)
      onError,
        required Function(String? message, Map<String, dynamic>? map) onSuccess,
        required Map<String, dynamic> mapData}) async {
    ApiResponse apiResponse = await liveRepo.postLiveCallStatus(mapData);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onBuyPackage(
      {required Function(String? message, Map<String, dynamic>? errorMap)
      onError,
        required Function(String? message, Map<String, dynamic>? map) onSuccess,
        required Map<String, dynamic> mapData}) async {
    ApiResponse apiResponse = await liveRepo.onBuyPackage(mapData: mapData);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}


