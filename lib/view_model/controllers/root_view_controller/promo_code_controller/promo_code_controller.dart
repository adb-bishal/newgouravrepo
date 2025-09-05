import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/root_provider.dart';
import 'package:stockpathshala_beta/view/widgets/toast_view/showtoast.dart';

import '../../../../model/models/promocode_model/promocode_model.dart';
import '../../../../model/network_calls/dio_client/get_it_instance.dart';
import '../../../../model/services/pagination.dart';

class PromoCodeController extends GetxController{
  RootProvider rootProvider = getIt();
  RxBool isDataLoading = false.obs;
  late Rx<PagingScrollController<Datum>> pagingController;
  Rx<PromoCodeModel> promoCodeData = PromoCodeModel().obs;
  @override
  void onInit() {
    pagingController = PagingScrollController<Datum>(
        onLoadMore: (int page, int totalItemsCount)async  {
         await getPromoCode(page);
        }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    super.onInit();
    getPromoCode(1);
  }

  getPromoCode(int pageNo)async{
    if(pageNo != 1){
      pagingController.value.isDataLoading.value = true;
    }else{
      pagingController.value.reset();
      isDataLoading.value = true;
    }
    await rootProvider.getPromoCode(onError:(message,errorMap){
      toastShow(message: message);
      isDataLoading.value  = false;
      pagingController.value.isDataLoading.value = false;
    },onSuccess:(message,json){
      if(json != null && json["data"].isNotEmpty){
        promoCodeData.value  = PromoCodeModel.fromJson(json);
        pagingController.value.list.addAll(promoCodeData.value.data!.data!);
      }else{
       pagingController.value.isDataLoading.value = false;
      }
      isDataLoading.value  = false;
    },pageNo: pageNo);
  }
}