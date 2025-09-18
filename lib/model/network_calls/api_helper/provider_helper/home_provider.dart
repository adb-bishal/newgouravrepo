import '../../../models/network_call_model/api_response.dart';
import '../repository_helper/home_repo.dart';
import 'account_provider.dart';

class HomeProvider {
  final HomeRepo homeRepo;
  HomeProvider({required this.homeRepo});

  Future getHomeData(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      String? levelId}) async {
    ApiResponse apiResponse = await homeRepo.getHomeData(levelId: levelId);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getCounselling(int? categoryId, String isAvailable,
      {required Function(String? message, Map<String, dynamic>? errorMap)
      onError,
        required Function(String? message, Map<String, dynamic>? map) onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getCounselling(categoryId,isAvailable);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }


  Future getQuestionsForFeedback(
      {required Function(String? message, Map<String, dynamic>? errorMap)
      onError,
        required Function(String? message, Map<String, dynamic>? map) onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getQuestions();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getContinueLearning(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getContinueLearning();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getSubscriptionPlan(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getSubscriptionPlan();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getSubscribedPlan(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getSubscribedPlan();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getSubscriptionDescription(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getSubscriptionDescription();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getSpecialSubscriptionOffer(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getSpecialSubscriptionOffer();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getOfferBanner(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map)
          onSuccess}) async {
    ApiResponse apiResponse = await homeRepo.getOfferBanner();
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future getOfferData(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required int pageNo}) async {
    ApiResponse apiResponse = await homeRepo.getOfferData(pageNo: pageNo);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onApplyCoupon(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required Map<String, dynamic> mapData}) async {
    ApiResponse apiResponse = await homeRepo.onApplyCoupon(mapData: mapData);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onPaymentConfirmation(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required Map<String, dynamic> mapData}) async {
    ApiResponse apiResponse =
        await homeRepo.onPaymentConfirmation(mapData: mapData);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onBuyPackage(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required Map<String, dynamic> mapData}) async {
    ApiResponse apiResponse = await homeRepo.onBuyPackage(mapData: mapData);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
  Future createCounsellingOrders(
      {required Function(String? message, Map<String, dynamic>? errorMap)
      onError,
        required Function(String? message, Map<String, dynamic>? map) onSuccess,
        required Map<String, dynamic> mapData}) async {
    ApiResponse apiResponse = await homeRepo.createCounsellingOrder(mapData: mapData);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }

  Future onBuyMentorship(
      {required Function(String? message, Map<String, dynamic>? errorMap)
          onError,
      required Function(String? message, Map<String, dynamic>? map) onSuccess,
      required Map<String, dynamic> mapData}) async {
    ApiResponse apiResponse = await homeRepo.onBuyMentorship(mapData: mapData);
    CheckApiResponse.instance
        .initResponse(apiResponse, onSuccess: onSuccess, onError: onError);
  }
}
