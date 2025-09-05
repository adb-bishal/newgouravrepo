import 'package:flutter/material.dart';

import 'color_resource.dart';
import 'dimensions_resource.dart';

class DecorationResource {
  static DecorationResource? _instance;
  static DecorationResource get instance =>
      _instance ??= DecorationResource._init();
  DecorationResource._init();

  BoxDecoration decorationFilterSpinnerNoRadius() {
    return BoxDecoration(
      border: Border.all(color: const Color(0xffFFDDDD), width: 1),
    );
  }

  BoxDecoration decorationRedRoundedCorner() {
    return BoxDecoration(
        color: ColorResource.primaryColor,
        border: Border.all(color: ColorResource.primaryColor, width: 1),
        borderRadius: BorderRadius.circular(4));
  }

  BoxDecoration decorationTextFieldRadius() {
    return BoxDecoration(
        color: ColorResource.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ColorResource.borderTextField2, width: 0.5));
  }

  BoxDecoration decorationTextFieldRoundedCorner() {
    return BoxDecoration(
        color: ColorResource.white,
        border: Border.all(color: ColorResource.borderColor, width: 1.5),
        borderRadius:
            BorderRadius.circular(DimensionResource.borderRadiusDefault));
  }

  OutlineInputBorder outLineBorder() {
    return OutlineInputBorder(
        borderRadius:
            BorderRadius.circular(DimensionResource.borderRadiusDefault),
        borderSide:
            const BorderSide(color: ColorResource.borderColor, width: 1));
  }

  BoxDecoration decorationImage({required String image}) {
    return BoxDecoration(
        image: DecorationImage(image: AssetImage(image), fit: BoxFit.fill));
  }

  BoxDecoration decorationTopLineGrey(Color color) {
    return BoxDecoration(
        color: ColorResource.white,
        border: Border(
          top: BorderSide(
            color: color,
            width: 1.0,
          ),
        ));
  }

  BoxDecoration decorationBorderBottom({Color? color}) {
    return BoxDecoration(
        color: ColorResource.white,
        border: Border(
          bottom: BorderSide(
            color: color ?? ColorResource.lightBorderColor,
            width: 1.5,
          ),
        ));
  }

  List<BoxShadow> containerBoxShadow() {
    return const [
      BoxShadow(
        color: ColorResource.boxShadow,
        blurRadius: 10.0,
      ),
    ];
  }
}
