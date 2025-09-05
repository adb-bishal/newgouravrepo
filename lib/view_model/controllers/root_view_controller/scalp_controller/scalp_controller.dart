import 'package:card_swiper/card_swiper.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/network_calls/api_helper/provider_helper/root_provider.dart';
import 'package:stockpathshala_beta/model/network_calls/dio_client/get_it_instance.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../../model/models/scalp_model/scalp_data_model.dart';
import '../../../../model/services/auth_service.dart';
import '../../../../model/services/pagination.dart';
import '../../../../view/widgets/toast_view/showtoast.dart';

class ScalpController extends GetxController {
  RootProvider rootProvider = getIt();
  Rx<ScalpDataModel> scalpData = ScalpDataModel().obs;
  late Rx<PagingScrollController<Datum>> dataPagingController;
  Rx<SwiperController> swipeController = SwiperController().obs;
  PageController newsPageController = PageController(
    keepPage: true,
  );
  RxBool isAdded = false.obs;
  RxBool isDataLoading = false.obs;
  RxBool fromScalp = false.obs;
  RxInt count = 1.obs;
  RxInt currentPage = 1.obs;
  Rx<Datum> dataDatum = Datum().obs;

  // enableWakeLock() async {
  //   if (!await Wakelock.enabled) {
  //     await Wakelock.enable();
  //   }
  // }

  @override
  void onInit() {
    // enableWakeLock();
    dataPagingController = PagingScrollController<Datum>(
        onLoadMore: (int page, int totalItemsCount) async {
     await getScalpData(pageNo: page);
    }, getStartPage: () {
      return 1;
    }, getThreshold: () {
      return 0;
    }).obs;
    getScalpData(pageNo: currentPage.value);

    super.onInit();
  }

  onIndexChange(int index) {
    logPrint("dfsdfsdf df sdv");
    if (index == dataPagingController.value.list.length - 3) {
      currentPage.value++;
      getScalpData(pageNo: currentPage.value);
    }
  }

  onSingleRedirect(Datum data) async {
    dataDatum.value = data;
    int currentIndex = dataPagingController.value.list.indexWhere((element) {
      logPrint("element id ${element.id} data id ${data.id}");
      return element.id.toString() == data.id.toString();
    });
    logPrint("currentIndex $currentIndex");
    if (currentIndex.isNegative) {
      dataPagingController.value.list.add(data);
      currentIndex = dataPagingController.value.list.indexWhere((element) {
        logPrint(
            "Negative element id ${element.id} Negative data id ${data.id}");
        return element.id.toString() == data.id.toString();
      });
      logPrint("currentIndex in negative $currentIndex");
      try {
        swipeController.value.index = currentIndex;
      } catch (e) {
        logPrint("error $e");
      }
    } else {
      try {
        swipeController.value.index = currentIndex;
      } catch (e) {
        logPrint("error $e");
      }
      logPrint("currentIndex in $currentIndex");
    }
    fromScalp.value = false;

    logPrint(
        "scalp index ${swipeController.value.index}  and json ${data.toJson()}");
  }

  onSingleRedirectByID(String id) {
    onSingleScalp(id);
    fromScalp.value = false;
  }

  onRedirectView(List<Datum> data) {
    if (!isAdded.value) {
      isAdded.value = true;
      scalpData.value.data?.data?.addAll(data);
    }
  }

  getScalpData({required int pageNo}) async {
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = true;
    } else {
      dataPagingController.value.reset();
      isDataLoading.value = true;
    }
    await rootProvider.getScalpData(
        pageNo: pageNo,
        onError: (message, errorMap) {
          toastShow(message: message);
          isDataLoading.value = false;
        },
        onSuccess: (message, map) async {
          if (map != null && map["data"].isNotEmpty) {
            scalpData.value = ScalpDataModel.fromJson(map);
            if (scalpData.value.data?.data?.isNotEmpty ?? false) {
              dataPagingController.value.list
                  .addAll(scalpData.value.data?.data ?? []);
              if (fromScalp.value) {
                swipeController.value.index = scalpData.value.data?.data
                        ?.indexWhere(
                            (element) => element.id == dataDatum.value.id) ??
                    0;
              }
            }
            // pagingController.value.list.addAll(notificationData.value.data?.data??[]);
          }
          isDataLoading.value = false;
        });
    if (pageNo != 1) {
      dataPagingController.value.isDataLoading.value = false;
    }
  }

  onLike(int id, {required Function(Map<String, dynamic>) onSuccess}) async {
    await rootProvider.onLike(
        id: id,
        onError: (message, errorMap) {
          toastShow(message: message);
        },
        onSuccess: (message, json) {
          onSuccess(json ?? {});
        });
  }

  onShare(int id, {Function()? onSuccess}) async {
    // await HelperUtil.instance.buildInviteLink().then((value) async {
    //   await HelperUtil.share(referCode: Get.find<AuthService>().user.value.referralCode, url: value.shortUrl.toString());
    // });
    if (!Get.find<AuthService>().isGuestUser.value) {
      await rootProvider.onShare(
          id: id,
          onError: (message, errorMap) {
            toastShow(message: message);
          },
          onSuccess: (message, json) {
            logPrint("onShare : $json");
            if (onSuccess != null) {
              onSuccess();
            }
          });
    }
  }

  onSingleScalp(String id) async {
    isDataLoading.value = true;
    await rootProvider.onScalpHistory(
        id: id,
        onError: (message, errorMap) {
          isDataLoading.value = false;
        },
        onSuccess: (message, json) {
          logPrint("json $json");
          try {
            dataPagingController.value.list
                .insert(0, Datum.fromJson(json?['data'] ?? {}));
            swipeController.value.index = dataPagingController.value.list
                .indexWhere((element) => element.id.toString() == id);
          } catch (e, stack) {
            logPrint("message sd $e $stack");
          }
          isDataLoading.value = false;
        });
  }

  onScalpHistory(String id) async {
    // await HelperUtil.instance.buildInviteLink().then((value) async {
    //   await HelperUtil.share(referCode: Get.find<AuthService>().user.value.referralCode, url: value.shortUrl.toString());
    // });
    if (!Get.find<AuthService>().isGuestUser.value) {
      EasyDebounce.debounce(
          count.value.toString(), const Duration(milliseconds: 200), () async {
        logPrint("debounce");
        await rootProvider.onScalpHistory(
            id: id,
            onError: (message, errorMap) {},
            onSuccess: (message, json) {});
        count.value++;
      });
    }
  }
}
