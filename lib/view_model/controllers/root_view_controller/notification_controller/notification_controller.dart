import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/root_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/models/promocode_model/notification_model.dart';
import '../../../../model/services/pagination.dart';

class NotificationController extends GetxController {
  RootProvider rootProvider = getIt();
  RxBool isDataLoading = false.obs;
  late Rx<PagingScrollController<Datum>> pagingController;
  Rx<NotificationModel> notificationData = NotificationModel().obs;

  @override
  void onInit() {
    pagingController = PagingScrollController<Datum>(
        onLoadMore: (int page, int totalItemsCount) async {
      // getFaqData(page);
     await getNotificationData(page);
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    super.onInit();
    getNotificationData(1);
  }

  Future getNotificationData(int pageNo) async {
    if (pageNo != 1) {
      pagingController.value.isDataLoading.value = true;
    } else {
      isDataLoading.value = true;
      pagingController.value.reset();
    }
    await rootProvider.getNotification(
        pageNo: pageNo,
        onError: (message, errorMap) {
          // toastShow(message :message,error: false);
          isDataLoading.value = false;
        },
        onSuccess: (message, map) async {
          if (map != null && map["data"].isNotEmpty) {
            notificationData.value = NotificationModel.fromJson(map);
            pagingController.value.list
                .addAll(notificationData.value.data?.data ?? []);
          }
          isDataLoading.value = false;
        });
    if (pageNo != 1) {
      pagingController.value.isDataLoading.value = false;
    }
  }
}
