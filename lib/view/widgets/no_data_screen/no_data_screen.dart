import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../button_view/common_button.dart';

class NoDataFoundScreen extends StatelessWidget {
  final String? message;
  final double? height;
  final double? width;
  final VoidCallback? onRefresh;
  final bool showRefreshButton;
  const NoDataFoundScreen(
      {Key? key,
      this.message,
      this.height,
      this.width,
      this.onRefresh,
      this.showRefreshButton = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorResource.white,
      body: SizedBox(
        height: height ?? double.infinity,
        width: width ?? double.infinity,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Image.asset(
                ImageResource.instance.noDataFoundIcon,
              )),
              const SizedBox(
                height: 20,
              ),
              Text(
                message ?? "No data available!".tr,
                style: StyleResource.instance.styleMedium(),
                textAlign: TextAlign.center,
              ),
              const SizedBox(
                height: 20,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Visibility(
                    visible: showRefreshButton,
                    child: CommonButton(
                      onPressed: onRefresh ?? () {},
                      text: "Refresh",
                      color: ColorResource.secondaryColor,
                      loading: false,
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}
