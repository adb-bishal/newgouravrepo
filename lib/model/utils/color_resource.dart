import 'package:flutter/material.dart';

class ColorResource {
  static ColorResource? _instance;

  static ColorResource get instance => _instance ??= ColorResource._init();

  ColorResource._init();

  static Color parseHex(String value) {
    try {
      return Color(int.parse(value.substring(1, 7), radix: 16) + 0xFF000000);
    } catch (e) {
      return Colors.transparent;
    }
  }

  static const Color imageBackground = Color(0xFF5A62AE);
  static Color subTextColorLight = Colors.white.withOpacity(0.6);
  static const Color primaryDark = Color(0xff5E50D4); // darker shade

  static const Color transparent = Color(0x00ffffff);
  static const Color primaryColor = Color(0xff8276F4);
  static const Color primaryColorLight = Color(0xFFADD8E6); // Light Blue

  static const Color primaryColorDark = Color.fromARGB(255, 114, 101, 228);
  static const Color primaryContainer = Color.fromARGB(255, 158, 151, 221);
  static const Color lightPrimaryColor = Color(0xff8276F4);
  static const Color secondaryColor = Color(0xFF1A2330);
  static const Color lightSecondaryColor = Color(0xff5F5F5F);
  static const Color lightDarkColor = Color(0xff6B7580);
  static const Color backGroundColor = Color(0xff8276F4);
  static const Color secondaryBlue = Color(0xFF01053A);
  static const Color textLightGrey = Color(0xFF909090);

  static const Color textColor = Color(0xff344054);
  static const Color textColor_2 = Color(0xff667085);
  static const Color textColor_3 = Color(0xff707070);
  static const Color textColor_4 = Color(0xff647580);
  static const Color textColor_5 = Color(0xff666666);
  static const Color textColor_6 = Color(0xff5F5F5F);
  static const Color textColor_7 = Color(0xff5D5D5D);
  static const Color textColor_8 = Color(0xffDAD9D9);
  static const Color textHintColor = Color(0xff707070);
  static const Color text3Color = Color(0xff848484);

  static const Color drawerIconColor = Color(0xff667085);

  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff000000);
  static const Color buttonTextColor = Color(0xff7747DC);

  static const Color lightBlack = Color(0xff181E2A);
  static const Color lightContrastBlack = Color(0xff2B3D56);
  static const Color mateBlack = Color(0xff202B3B);

  static const Color borderColor = Color(0xffBEBEBE);
  static const Color lightTextColor = Color(0xff7A7A7A);
  static const Color statusBoxBackGroundColor = Color(0xffF2F4F7);
  static const Color chatBoxBackGroundColor = Color(0xffFAF9F9);
  static const Color boxBackGroundColor = Color(0xffFFFAEB);
  static const Color radioBoxBackGroundColor = Color(0xffF4F5F7);
  static const Color lightBorderColor = Color(0xffDADEE3);
  static const Color borderTextField2 = Color(0xffCECECE);
  static const Color dividerColor = Color(0xffE4E7EC);

  static const Color grey = Color(0xff707070);
  static const Color grey_1 = Color(0xff808080);
  static const Color grey_2 = Color(0xffE7E7E7);
  static const Color grey_3 = Color(0xffD2D2D2);
  static const Color grey_4 = Color(0xffc0c0c0);
  static const Color lineGreyColor = Color(0xffF5F5F5);
  static const Color lineGrey2Color = Color(0xffE7E7E7);

  static const Color boxColor = Color(0xffFCFCFC);
  static const Color extraDoubleLightGrey = Color(0xffFCFCFC);
  static const Color lightGrey = Color(0xffF9F9F9);

  static const Color greenColor = Color(0xFF1FD14A);
  static const Color greenButtonColor = Color(0xFFDBF300);
  static const Color greenDarkColor = Color(0xFF2E7D32);
  static Color greenDarkContainer = const Color(0xFFB2FF59).withOpacity(0.3);

  static const Color mateGreenColor = Color(0xFF4CD137);
  static const Color boxShadow = Color(0xffE4E4E4);

  static const Color orangeColor = Color(0xffFFA500);

  static const Color errorColor = Color(0xffEC3C3C);
  static const Color redColor = Color(0xffF04438);
  static const Color offerColor = Color(0xffa8232d);
  static const Color mateRedColor = Color(0xffF64E4E);

  static const Color goldenColor = Color(0xfff4d5a6);
  static const Color starColor = Color(0xffFEBF1C);
  static const Color yellowColor = Color(0xffE4EF4E);
  static const Color lightYellowColor = Color(0xffEFDF4E);
  static const Color accentYellowColor = Color(0xffF69C14);
  static const Color whiteYellowColor = Color(0xffFFE3BA);
  static const Color brownColor = Color(0xffD19166);
}
