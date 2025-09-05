import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';

import 'font_resource.dart';

FontWeight semiBold = FontWeight.w600;
FontWeight regular = FontWeight.w400;
FontWeight light = FontWeight.w300;
FontWeight medium = FontWeight.w500;
FontWeight bold = FontWeight.w700;
FontWeight extraBold = FontWeight.w900;

class StyleResource {
  static StyleResource? _instance;
  static StyleResource get instance => _instance ??= StyleResource._init();
  StyleResource._init();

  TextStyle styleExtraBold({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeDefault,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: extraBold);
  }

  TextStyle styleBold({
    double? fontSize,
    Color? color,
    FontWeight? fontWeight,  // Added fontWeight parameter
  }) {
    return TextStyle(
      fontSize: fontSize ?? DimensionResource.fontSizeDefault,
      color: color ?? ColorResource.secondaryColor,
      fontFamily: FontResource.instance.mainFont,
      fontWeight: fontWeight ?? FontWeight.bold, // Default to FontWeight.bold
    );
  }

  TextStyle styleSemiBold({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeDefault,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: semiBold);
  }
  TextStyle styleSemiBoldFeedbackTab({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeExtraLarge,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: semiBold);
  }
  TextStyle styleSemiBoldTablet({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeDefault+10,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: semiBold);
  }
  TextStyle styleSemiBoldQuizTablet({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeDefault+18,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: semiBold);
  }

  TextStyle styleRegular({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeDefault,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: regular);
  }
  TextStyle styleRegularReferTablet({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeLarge,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: regular);
  }

  TextStyle styleMedium({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeDefault,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: medium);
  }
  TextStyle styleMediumTablet({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeDoubleExtraLarge,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: medium);
  }
  TextStyle styleLight({double? fontSize, Color? color}) {
    return TextStyle(
        fontSize: fontSize??DimensionResource.fontSizeDefault,
        color: color??ColorResource.secondaryColor,
        fontFamily: FontResource.instance.mainFont,
        fontWeight: light);
  }
}
