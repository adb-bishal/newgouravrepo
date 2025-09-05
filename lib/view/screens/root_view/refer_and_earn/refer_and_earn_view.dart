import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/helper_util.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';

import '../../../../model/utils/dimensions_resource.dart';
import '../../../../view_model/controllers/root_view_controller/refer_and_earn_controller/refer_and_earn_controller.dart';
import '../../base_view/base_view_screen.dart';

class ReferAndEarn extends StatelessWidget {
  const ReferAndEarn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: StringResource.referNEarn,
      ),
      onActionBuilder: (context, controller) => [],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: ReferAndEarnController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, ReferAndEarnController controller) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
         SizedBox(
          height:screenWidth<500? DimensionResource.marginSizeExtraLarge: DimensionResource.marginSizeExtraLarge+20,
        ),
        Padding(
          padding: const EdgeInsets.symmetric(
              horizontal: DimensionResource.marginSizeDefault),
          child: Image.asset(
            ImageResource.instance.referNEarnBG,
            height:screenWidth<500? 200:300,
          ),
        ),
         SizedBox(
          height: screenWidth<500?DimensionResource.marginSizeExtraLarge:DimensionResource.marginSizeExtraLarge+10,
        ),
        Text(
          "Get 200 Credit Points",
          style: StyleResource.instance.styleSemiBold(
              color: ColorResource.primaryColor,
              fontSize:screenWidth<500? DimensionResource.fontSizeDoubleExtraLarge - 2:DimensionResource.fontSizeOverLarge-2),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall - 3,
        ),
        Text(
          "For every new user you refer",
          style: StyleResource.instance.styleLight(
              color: ColorResource.secondaryColor,
              fontSize:screenWidth<500? DimensionResource.fontSizeLarge - 2:DimensionResource.fontSizeLarge),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeExtraSmall - 2,
        ),
        Text(
          "Refer this application to your Friends &\nEarn credit points",
          style: StyleResource.instance.styleLight(
              color: ColorResource.textColor_6,
              fontSize: screenWidth<500? DimensionResource.fontSizeSmall:DimensionResource.fontSizeSmall+1),
          textAlign: TextAlign.center,
        ),
        const SizedBox(
          height: DimensionResource.marginSizeExtraLarge + 15,
        ),
        Visibility(
          visible: Get.find<AuthService>().user.value.referralCode != null,
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            child: DottedBorder(
              borderType: BorderType.RRect,
              dashPattern: const [5, 3],
              strokeWidth: 0.6,
              radius: const Radius.circular(25),
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(24)),
                child: SizedBox(
                  height: screenWidth<500?40:60,
                  child: Row(
                    children: [
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.only(
                            left: DimensionResource.marginSizeDefault),
                        child: Text(
                          Get.find<AuthService>().user.value.referralCode ?? "",
                          style:screenWidth<500? StyleResource.instance.styleRegular():StyleResource.instance.styleRegularReferTablet(),
                        ),
                      )),
                      Padding(
                        padding:  EdgeInsets.all( screenWidth <500?3.0:6),
                        child: ContainerButton(
                          text: "Copy",
                          onPressed: () {
                            HelperUtil.copyToClipBoard(
                                textToBeCopied: Get.find<AuthService>()
                                        .user
                                        .value
                                        .referralCode ??
                                    '');
                          },
                          padding: const EdgeInsets.symmetric(
                              horizontal: 13, vertical: 3),
                          color: ColorResource.primaryColor,
                          fontColor: ColorResource.white,
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        const Spacer(),
        CommonButton(
          text: "",
          loading: false,
          onPressed: controller.onShareApp,
          radius: 0,
          color: ColorResource.secondaryColor,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                ImageResource.instance.shareIcon,
                height: 14,
                color: ColorResource.white,
              ),
              const SizedBox(
                width: DimensionResource.marginSizeExtraSmall,
              ),
              Text("Share",
                  style: StyleResource.instance.styleMedium(
                      fontSize: DimensionResource.fontSizeLarge - 1,
                      color: ColorResource.white))
            ],
          ),
        )
      ],
    );
  }
}
