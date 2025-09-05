import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/helper_util.dart';

import '../../../../model/services/auth_service.dart';

class ReferAndEarnController extends GetxController {
  @override
  void onInit() {
    // if(Get.find<AuthService>().user.value.referredBy == null) {
    //    Future.delayed(const Duration(seconds: 2),showReferByDialog);
    //  }
    super.onInit();
  }

  onShareApp() async {
    await HelperUtil.instance.buildInviteLink().then((value) async {
      await HelperUtil.share(
          referCode: Get.find<AuthService>().user.value.referralCode ?? "",
          url: value.shortUrl.toString());
    });
  }
}
