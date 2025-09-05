import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';

import '../../../../model/services/auth_service.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/helper_util.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../view_model/controllers/profile_controller/profile_controller.dart';
import '../../../../view_model/routes/app_pages.dart';
import '../../../widgets/view_helpers/progress_dialog.dart';
import '../../base_view/base_view_screen.dart';

class SettingView extends GetView<ProfileController> {
  const SettingView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: Get.back,
          child:  Icon(
            Icons.arrow_back_ios,
            color: ColorResource.white,
            size:screenWidth<500? 20:26,
          ),
        ),
        title: const TitleBarCentered(
          titleText: StringResource.setting,
        ),
        centerTitle: true,
        backgroundColor: ColorResource.primaryColor,
      ),
      body: Padding(
        padding:  EdgeInsets.all(screenWidth<500? 0.0:16.0),
        child: ListView(
          children: [
            ListTile(
              dense: true,
              onTap: () {
                Get.toNamed(Routes.faqScreen);
              },
              leading: Image.asset(
                ImageResource.instance.faqIcon,
                height: screenWidth<500?20:36,
              ),
              title: Text(
                StringResource.faq,
                style: StyleResource.instance.styleSemiBold().copyWith(
                      fontSize:screenWidth<500? DimensionResource.fontSizeDefault - 1:DimensionResource.fontSizeDoubleExtraLarge,
                    ),
              ),
            ),
            ListTile(
              dense: true,
              onTap: () {
                Get.toNamed(Routes.tncScreen);
              },
              leading: Image.asset(
                ImageResource.instance.tncIcon,
                height: screenWidth<500?20:36,
              ),
              title: Text(
                StringResource.terms,
                style: StyleResource.instance.styleSemiBold().copyWith(
                      fontSize:screenWidth<500? DimensionResource.fontSizeDefault - 1:DimensionResource.fontSizeDoubleExtraLarge,
                    ),
              ),
            ),
            ListTile(
              dense: true,
              onTap: () {
                if (!Get.find<AuthService>().isGuestUser.value) {
                  Get.toNamed(Routes.referAndEarn);
                } else {
                  ProgressDialog().showFlipDialog(isForPro: false);
                }
              },
              leading: Image.asset(
                ImageResource.instance.referNEarnIcon,
                height: screenWidth<500?20:36,
              ),
              title: Text(
                StringResource.referNEarn,
                style: StyleResource.instance.styleSemiBold().copyWith(
                      fontSize:screenWidth<500? DimensionResource.fontSizeDefault - 1:DimensionResource.fontSizeDoubleExtraLarge,
                    ),
              ),
            ),
            ListTile(
              dense: true,
              onTap: () async {
                await HelperUtil.instance.buildInviteLink().then((value) async {
                  await HelperUtil.share(
                      referCode:
                          Get.find<AuthService>().user.value.referralCode ?? "",
                      url: value.shortUrl.toString());
                });
              },
              leading: Image.asset(
                ImageResource.instance.shareAppIcon,
                height: screenWidth<500?20:36,
              ),
              title: Text(
                StringResource.shareApp,
                style: StyleResource.instance.styleSemiBold().copyWith(
                      fontSize: screenWidth<500? DimensionResource.fontSizeDefault - 1:DimensionResource.fontSizeDoubleExtraLarge,
                    ),
              ),
            ),
            ListTile(
              dense: true,
              onTap: () {
                Get.toNamed(Routes.feedbackScreen);
              },
              leading: Image.asset(
                ImageResource.instance.feedbackIcon,
                height: screenWidth<500?20:36,
              ),
              title: Text(
                StringResource.feedback,
                style: StyleResource.instance.styleSemiBold().copyWith(
                      fontSize: screenWidth<500? DimensionResource.fontSizeDefault - 1:DimensionResource.fontSizeDoubleExtraLarge,
                    ),
              ),
            ),
            ListTile(
              dense: true,
              onTap: () {
                controller.onLogOut(context);
              },
              leading: Padding(
                padding: const EdgeInsets.only(left: 3),
                child: Image.asset(
                  ImageResource.instance.logoutIcon,
                  height: screenWidth<500?20:36,
                ),
              ),
              title: Text(
                StringResource.logOut,
                style: StyleResource.instance.styleSemiBold().copyWith(
                      fontSize: screenWidth<500? DimensionResource.fontSizeDefault - 1:DimensionResource.fontSizeDoubleExtraLarge,
                    ),
              ),
            ),
            ListTile(
              dense: true,
              onTap: () {
                controller.onAccountDelete(context);
              },
              leading:  Icon(
                Icons.delete,
                color: ColorResource.redColor,
                size:  screenWidth<500?22:36,
              ),
              title: Text(
                StringResource.deleteAccount,
                style: StyleResource.instance.styleSemiBold().copyWith(
                      fontSize:screenWidth<500? DimensionResource.fontSizeDefault - 1:DimensionResource.fontSizeDoubleExtraLarge,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
