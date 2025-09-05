import '../../../models/network_call_model/api_response.dart';
import '../../../utils/app_constants.dart';
import '../../dio_client/dio_client.dart';

class RootRepo {
  final DioClient dioClient;
  RootRepo({
    required this.dioClient,
  });

  Future<ApiResponse> openTradingAccount(Map<String, dynamic> data) async {
    String url = AppConstants.openTradingAccount;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: data);
  }

  Future<ApiResponse> postFeedback(Map<String, dynamic> data) async {
    String url = AppConstants.instance.feedback;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: data);
  }

  Future<ApiResponse> setGoal(Map<String, dynamic> data) async {
    String url = AppConstants.instance.setGoal;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: data);
  }

  Future<ApiResponse> onScalpHistory({String? id}) async {
    String url = "${AppConstants.instance.shortHistory}/${id ?? ""}";
    return dioClient.getResponse(url: url, dioClient: dioClient);
  }

  Future<ApiResponse> deleteGoal() async {
    String url = "${AppConstants.instance.setGoal}/delete";
    return dioClient.deleteResponse(url: url, dioClient: dioClient, data: {});
  }

  Future<ApiResponse> postUserActivity(dynamic data) async {
    String url = AppConstants.instance.userAvgTime;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: data);
  }

  Future<ApiResponse> getUserActivity() async {
    String url = AppConstants.instance.userAvgTime;
    return dioClient.getResponse(
      url: url,
      dioClient: dioClient,
    );
  }

  Future<ApiResponse> onRedeem() async {
    String url = AppConstants.instance.onRedeem;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: {});
  }

  Future<ApiResponse> getUpdateVersionCode(var data) async {
    String url = AppConstants.instance.versionHistories;
    return dioClient.postResponse(url: url, dioClient: dioClient, data: data);
  }

  Future<ApiResponse> getFaqData() async {
    String url = AppConstants.instance.faq;
    return dioClient.getResponse(
      url: url,
      dioClient: dioClient,
    );
  }

  Future<ApiResponse> getTnc() async {
    String url = AppConstants.instance.termsAndCondition;
    return dioClient.getResponse(
      url: url,
      dioClient: dioClient,
    );
  }

  Future<ApiResponse> getDashBoardData() async {
    String url = AppConstants.instance.dashboard;
    return dioClient.getResponse(
      url: url,
      dioClient: dioClient,
    );
  }

  Future<ApiResponse> getPopUpData() async {
    String url = AppConstants.instance.popUp;
    return dioClient.getResponse(
      url: url,
      dioClient: dioClient,
    );
  }

  Future<ApiResponse> getPromoCode({required int pageNo}) async {
    String url = AppConstants.instance.promocode + pageNo.toString();
    return dioClient.getResponse(
      url: url,
      dioClient: dioClient,
    );
  }

  Future<ApiResponse> getNotification({required int pageNo}) async {
    String url = AppConstants.instance.notification + pageNo.toString();
    return dioClient.getResponse(
      url: url,
      dioClient: dioClient,
    );
  }

  Future<ApiResponse> getScalpData({required int pageNo}) async {
    String url = AppConstants.instance.scalps + pageNo.toString();
    return dioClient.getResponse(
      url: url,
      dioClient: dioClient,
    );
  }

  Future<ApiResponse> onLike({required int id}) async {
    String url = AppConstants.instance.onLike;
    return dioClient
        .postResponse(url: url, dioClient: dioClient, data: {"short_id": id});
  }

  Future<ApiResponse> onShare({required int id}) async {
    String url = AppConstants.instance.onShare;
    return dioClient
        .postResponse(url: url, dioClient: dioClient, data: {"short_id": id});
  }
}
