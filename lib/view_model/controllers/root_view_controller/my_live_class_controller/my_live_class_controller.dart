import 'package:get/get.dart';

import '../../../../model/models/common_container_model/common_container_model.dart';
import '../../../../model/models/live_class_model/live_class_model.dart';
import '../../../../model/network_calls/api_helper/provider_helper/live_provider.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';

class MyLiveClassController extends GetxController {
  LiveProvider liveProvider = getIt();
  Rx<LiveClassModel> liveData = LiveClassModel().obs;
  late Rx<PagingScrollController<CommonDatum>> dataPagingController;
  RxBool isDataLoading = false.obs;

  @override
  void onInit() {
    dataPagingController = PagingScrollController<CommonDatum>(
        onLoadMore: (int page, int totalItemsCount) async {
     await getLiveData(pageNo: page);
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    getLiveData(pageNo: 1);
    super.onInit();
  }

  getLiveData({required int pageNo}) async {
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      dataPagingController.value.reset();
      isDataLoading.value = true;
    }
    await liveProvider.getLiveData(
      isPast: false,
      isMyClass: true,
      onError: (message, errorMap) {
        toastShow(message: message);
        isDataLoading.value = false;
      },
      onSuccess: (message, json) {
        liveData.value = LiveClassModel.fromJson(json!);
        if (liveData.value.data?.data?.isNotEmpty ?? false) {
          dataPagingController.value.list.addAll(List<CommonDatum>.from(liveData
              .value.data!.data!
              .map((x) => CommonDatum.fromJson(x.toJson()))));
        } else {
          dataPagingController.value.isDataLoading.value = false;
        }
        isDataLoading.value = false;
      },
      pageNo: pageNo,
      //dateFilter: dateFilter,
    );
    if (pageNo != 1) {
      // dataPagingController.value.isDataLoading.value = false;
    }
  }
}
