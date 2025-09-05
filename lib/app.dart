import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_framework/responsive_framework.dart';

import 'model/language/language_manager.dart';
import 'model/utils/color_resource.dart';
import 'model/utils/font_resource.dart';
import 'model/utils/string_resource.dart';
import 'view/widgets/error_show/error_show.dart';
import 'view_model/routes/app_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyAppSP extends StatelessWidget {
  const MyAppSP({Key? key}) : super(key: key);
  static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  static FirebaseAnalyticsObserver observer =
      FirebaseAnalyticsObserver(analytics: analytics);
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: StringResource.instance.appName,
      builder: kDebugMode
          ? (BuildContext context, Widget? widget) {
              return responsiveScreen(context, widget);
            }
          : (BuildContext context, Widget? widget) {
              ErrorWidget.builder = (FlutterErrorDetails errorDetails) {
                return ErrorMessage(errorDetails: errorDetails);
              };
              return responsiveScreen(context, widget);
            },
      theme: ThemeData(
        primaryColor: ColorResource.primaryColor,
        visualDensity: VisualDensity.adaptivePlatformDensity,
        splashColor: ColorResource.primaryColor,
        highlightColor: Colors.transparent,
        fontFamily: FontResource.instance.mainFont,
        datePickerTheme: DatePickerThemeData(
          headerBackgroundColor: ColorResource.primaryColor,
          todayBackgroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return ColorResource.primaryColor.withOpacity(0.6);
            }
            return ColorResource.primaryColor;
          }),
          todayForegroundColor: MaterialStateProperty.resolveWith((states) {
            if (states.contains(MaterialState.pressed)) {
              return ColorResource.primaryColor.withOpacity(0.6);
            }
            return ColorResource.primaryColor;
          }),
          // dayBackgroundColor: MaterialStateProperty.resolveWith((states) {
          //   if (states.contains(MaterialState.pressed)) {
          //     return ColorResource.primaryColor.withOpacity(0.6);
          //   }
          //   return ColorResource.primaryColor;
          // }),
          // dayForegroundColor: MaterialStateProperty.resolveWith((states) {
          //   if (states.contains(MaterialState.pressed)) {
          //     return ColorResource.primaryColor.withOpacity(0.6);
          //   }
          //   return ColorResource.primaryColor;
          // }),
        ),
      ),
      navigatorObservers: <NavigatorObserver>[observer],
      translations: LanguageManager.instance.translationLocalStrings,
      locale: LanguageManager.instance.enLocale,
      supportedLocales: LanguageManager.instance.supportedLocales,
      getPages: AppPages.routes,
      initialRoute: AppPages.initial,
      defaultTransition: Transition.circularReveal,
    );
  }
}

Widget responsiveScreen(context, widget) {
  return ResponsiveWrapper.builder(
      BouncingScrollWrapper.builder(context, widget!),
      maxWidth: 2400,
      minWidth: 360,
      defaultScale: true,
      breakpoints: [
        // const ResponsiveBreakpoint.resize(450, name: MOBILE),
        const ResponsiveBreakpoint.resize(600, name: MOBILE),
        const ResponsiveBreakpoint.autoScale(800, name: TABLET),
        const ResponsiveBreakpoint.resize(1200, name: DESKTOP),
        const ResponsiveBreakpoint.autoScale(2460, name: "4K"),
      ],
      background: Container(color: const Color(0xFFF5F5F5)));
}
