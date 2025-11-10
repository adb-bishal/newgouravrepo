import 'dart:io';

import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/promocode_model/promocode_model.dart';
import 'package:stockpathshala_beta/model/utils/app_constants.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/string_resource.dart';
import 'package:stockpathshala_beta/view/widgets/button_view/common_button.dart';
import 'package:stockpathshala_beta/view_model/controllers/root_view_controller/promo_code_controller/promo_code_controller.dart';
import 'package:stockpathshala_beta/enum/routing/routes/app_pages.dart';

import '../../../../model/services/pagination.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/helper_util.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../widgets/no_data_found/no_data_found.dart';
import '../../../widgets/shimmer_widget/shimmer_widget.dart';
import '../../base_view/base_view_screen.dart';

class PromoCodeView extends StatelessWidget {
  const PromoCodeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => const TitleBarCentered(
        titleText: "Promocodes",
      ),
      onActionBuilder: (context, controller) => [],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: PromoCodeController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(
      BuildContext context, PromoCodeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.marginSizeDefault),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: DimensionResource.marginSizeDefault,
          ),
          Text(
            StringResource.userPromoCode,
            style: StyleResource.instance.styleSemiBold(),
          ),
          const SizedBox(
            height: DimensionResource.marginSizeSmall,
          ),
          Expanded(child: promoCodeList(controller: controller)),

          //...promoCodeList(promoCodeController: controller)
        ],
      ),
    );
  }

  promoCodeList({required PromoCodeController controller}) {
    return Obx(() => controller.isDataLoading.value
        ? ShimmerEffect.instance.promocodeLoader()
        : controller.pagingController.value.list.isNotEmpty
            ? PaginationView<Datum>(
                onRefresh: () async {},
                itemBuilder: (context, index, data) {
                  //Datum data = controller.pagingController.value.list.elementAt(index);
                  return Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: DimensionResource.marginSizeDefault),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom: BorderSide(
                                color:
                                    ColorResource.borderColor.withOpacity(0.4),
                                width: 1.1))),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            DottedBorder(
                              color: ColorResource.primaryColor,
                              borderType: BorderType.RRect,
                              dashPattern: const [3, 3],
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                color:
                                    ColorResource.primaryColor.withOpacity(0.2),
                                child: Center(
                                  child: Text(
                                    data.code?.toUpperCase() ?? "",
                                    style: StyleResource.instance.styleSemiBold(
                                        fontSize: DimensionResource
                                            .fontSizeExtraSmall,
                                        color: ColorResource.primaryColor),
                                  ),
                                ),
                              ),
                            ),
                            ContainerButton(
                              radius: 4,
                              text: StringResource.availNow,
                              color: (data.expireAt?.year == 1999 ||
                                      (data.expireAt?.isAfter(DateTime.now()) ??
                                          true))
                                  ? ColorResource.secondaryColor
                                  : ColorResource.secondaryColor
                                      .withOpacity(0.4),
                              padding: const EdgeInsets.symmetric(
                                  vertical:
                                      DimensionResource.marginSizeExtraSmall,
                                  horizontal:
                                      DimensionResource.marginSizeSmall),
                              onPressed: (data.expireAt?.year == 1999 ||
                                      (data.expireAt?.isAfter(DateTime.now()) ??
                                          true))
                                  ? () {
                                      if (Platform.isAndroid) {
                                        Get.toNamed(Routes.subscriptionView,
                                            arguments: data.toJson());
                                      }

                                      HelperUtil.copyToClipBoard(
                                          textToBeCopied:
                                              data.code?.toUpperCase() ?? "");
                                    }
                                  : () {},
                              textStyle: StyleResource.instance.styleSemiBold(
                                  fontSize:
                                      DimensionResource.fontSizeExtraSmall,
                                  color: ColorResource.white),
                            )
                          ],
                        ),
                        SizedBox(
                          height: data.expireAt?.year == 1999
                              ? 0
                              : DimensionResource.marginSizeSmall,
                        ),
                        Visibility(
                            visible: data.expireAt?.year != 1999,
                            child: Text(
                              "${StringResource.expireOn} ${AppConstants.formatDate(data.expireAt)}",
                              style: StyleResource.instance.styleMedium(
                                  fontSize: DimensionResource.fontSizeSmall),
                            ))
                      ],
                    ),
                  );
                },
                errorBuilder: (context) => Container(),
                bottomLoaderBuilder: (context) => const Padding(
                      padding: EdgeInsets.only(bottom: 100.0),
                      child: Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: ColorResource.secondaryColor,
                            strokeWidth: 2,
                          ),
                        ),
                      ),
                    ),
                pagingScrollController: controller.pagingController.value)
            : NoDataFound(
                showText: true,
                text: StringResource.noUserPromoData,
              ));
  }
}
