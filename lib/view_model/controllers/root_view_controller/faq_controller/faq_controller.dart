import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/promocode_model/faq_model.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/root_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../../model/models/t&c_model/t_and_c_model.dart';
import '../../../../model/services/pagination.dart';

class FaqController extends GetxController {
  RootProvider rootProvider = getIt();
  late Rx<PagingScrollController<Datum>> pagingController;
  RxBool isLoading = false.obs;
  RxBool isTncLoading = false.obs;
  Rx<FaqModel> faqData = FaqModel().obs;
  Rx<TermsAndConditionModel> tncData = TermsAndConditionModel().obs;

  @override
  void onInit() {
    pagingController = PagingScrollController<Datum>(
        onLoadMore: (int page, int totalItemsCount) async {
      //  getFaqData(page);
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    super.onInit();
    getFaqData(1);
    getTnc();
  }

  Future getFaqData(int pageNo) async {
    logPrint("opkfsdof");
    if (pageNo != 1) {
      pagingController.value.isDataLoading.value = true;
    } else {
      pagingController.value.reset();
      pagingController.value.list.clear();
      isLoading.value = true;
    }

    await rootProvider.getFaqData(onError: (message, errorMap) {
      toastShow(message: message, error: true);
      isLoading.value = false;
    }, onSuccess: (message, map) async {
      if (map != null && map["data"].isNotEmpty) {
        faqData.value = FaqModel.fromJson(map);
        pagingController.value.list.addAll(faqData.value.data ?? []);
        // pagingController.value.list.addAll(faqData.value.data!.data!);
      }
      isLoading.value = false;
    });
    if (pageNo != 1) {
      pagingController.value.isDataLoading.value = false;
    } else {
      isLoading.value = false;
    }
  }

  getTnc() async {
    isTncLoading(true);
    await rootProvider.getTnc(onError: (message, errorMap) {
      toastShow(message: message);
      isTncLoading(false);
    }, onSuccess: (message, json) async {
      tncData.value = TermsAndConditionModel.fromJson(json!);
      isTncLoading(false);
    });
  }
}

class FaqData {
  final String? title;
  final String? subTitle;

  FaqData({this.title, this.subTitle});
}
