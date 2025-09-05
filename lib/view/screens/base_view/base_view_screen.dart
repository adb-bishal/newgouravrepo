import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';

class BaseView<T extends GetxController> extends GetView {
  final T viewControl;
  final Widget? appBarLeadingIcon;
  final PreferredSizeWidget? customAppBar;
  final bool isBackShow;
  final bool isAppBarShow;
  final bool isTag;
  final String? customTag;
  final Color? appBarBackgroundColor;
  final Color? appBarForegroundColor;
  //final BottomBarPerimeter ?bottomBarPerimeter;
  final Color? backGroundColor;
  final Color? bodyColor;
  final Widget Function(BuildContext context, T value) onPageBuilder;
  final List<Widget> Function(BuildContext context, T value) onActionBuilder;
  final Function(BuildContext context, T value) onBackClicked;
  final Widget Function(BuildContext context, T value) onAppBarTitleBuilder;

  const BaseView(
      {super.key,
      required this.viewControl,
      this.isTag = false,
      this.appBarLeadingIcon,
      this.isBackShow = true,
      this.isAppBarShow = true,
      this.customAppBar,
      this.customTag,
      this.appBarBackgroundColor,
      this.appBarForegroundColor,
      required this.onAppBarTitleBuilder,
      required this.onBackClicked,
      required this.onPageBuilder,
      required this.onActionBuilder,
      this.backGroundColor,
      this.bodyColor})
      : assert(
            (appBarBackgroundColor != null && appBarForegroundColor != null) ||
                ((appBarBackgroundColor == null &&
                    appBarForegroundColor == null)),
            'must provide a foreground color, in case of background color provided in appbar');
  @override
  Widget build(BuildContext context) {
    final T controller = Get.put(viewControl,
        tag: customTag ?? (isTag ? "${DateTime.now().microsecond}" : null));
    return Container(
      color: Platform.isIOS ? ColorResource.white : Colors.transparent,
      child: SafeArea(
        top: false,
        bottom: false,
        //bottom:Platform.isIOS ? true:false,
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          appBar: isAppBarShow
              ? customAppBar ??
                  appBar(
                      context: context,
                      controller: controller,
                      backgroundColor: appBarBackgroundColor,
                      foregroundColor: appBarForegroundColor,
                      appBarLeadingIcon: appBarLeadingIcon,
                      isBackShow: isBackShow)
              : _buildBlankAppBar(),
          backgroundColor: appBarBackgroundColor ??
              backGroundColor ??
              ColorResource.backGroundColor,
          body: SizedBox(
            height: double.infinity,
            width: double.infinity,
            child: Container(
                decoration: BoxDecoration(
                    color: bodyColor ?? Colors.white,
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(20),
                        topLeft: Radius.circular(20))),
                child: onPageBuilder(context, controller)),
          ),
          //bottomNavigationBar:bottomBarPerimeter!=null ? bottomBarWidget(bottomBarPerimeter!,controller) : const SizedBox(),
        ),
      ),
    );
  }

  PreferredSize appBar(
      {required BuildContext context,
      required T controller,
      Color? backgroundColor,
      Color? foregroundColor,
      Widget? appBarLeadingIcon,
      required bool isBackShow}) {
    List<Widget> wid = get(context, controller);
    return PreferredSize(
      preferredSize: const Size(double.infinity, 45.0),
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.only(
            left: DimensionResource.marginSizeDefault,
            right: DimensionResource.marginSizeDefault,
            top: MediaQuery.of(context).padding.top),
        width: double.infinity,
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          color: backgroundColor ?? ColorResource.primaryColor,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            if (isBackShow) ...[
              InkWell(
                onTap: () {
                  try {
                    onBackClicked(context, controller);
                  } catch (e) {
                    logPrint(e);
                  }
                },
                child: appBarLeadingIcon ??
                    SizedBox(
                      height: 32,
                      width: 32,
                      child: Center(
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: foregroundColor ?? ColorResource.white,
                          size: 20,
                        ),
                      ),
                    ),
              ),
            ] else ...[
              const SizedBox.shrink()
            ],
            Expanded(
                child: Padding(
              padding: isBackShow
                  ? EdgeInsets.zero
                  : const EdgeInsets.only(left: 30),
              child: onAppBarTitleBuilder(context, controller),
            )),
            wid.isEmpty
                ? const SizedBox(
                    height: 25,
                    width: 25,
                  )
                : Row(
                    children: wid,
                  )
          ],
        ),
      ),
    );
  }

  List<Widget> get(BuildContext context, T controller) {
    return onActionBuilder(context, controller);
  }

  PreferredSize blankAppBar() {
    return PreferredSize(
        preferredSize: const Size(0.0, 0.0), child: Container());
  }

  PreferredSize _buildBlankAppBar() {
    return const PreferredSize(
        preferredSize: Size(0.0, 0.0), child: SizedBox());
  }

  Widget bottomBarWidget(BottomBarPerimeter bottomBarPerimeter, T controller) {
    return Container(
      height: bottomBarPerimeter.bottomBarHeight,
      width: double.infinity,
      color: bottomBarPerimeter.bottomBarBackGroundColor,
      child: bottomBarPerimeter.widget(Get.context!, controller),
    );
  }
}

class AppbarPerimeter {
  Color appBarBackGroundColor;
  Color backButtonColor;
  bool backButtonShow;
  String title;
  String subTitle;
  VoidCallback? onTapBackButton;
  List<Widget> actionButton;
  Widget Function(BuildContext context, dynamic value)? appBarWidget;
  AppbarPerimeter(
      {this.backButtonShow = true,
      this.title = "",
      this.subTitle = "",
      this.actionButton = const [],
      this.appBarBackGroundColor = ColorResource.primaryColor,
      this.backButtonColor = ColorResource.white,
      this.onTapBackButton,
      this.appBarWidget});
}

class BottomBarPerimeter {
  Color bottomBarBackGroundColor;
  double bottomBarHeight;
  Widget Function(BuildContext context, dynamic value) widget;
  BottomBarPerimeter(
      {this.bottomBarHeight = 60,
      required this.widget,
      this.bottomBarBackGroundColor = Colors.transparent});
}

class AuthView<T extends GetxController> extends GetView {
  final T viewControl;
  final Color? backGroundColor;
  final Color imageBackGroundColor;
  final String? backgroundImage;
  final double imageHeight;
  final BoxFit imageFit;
  final Widget Function(BuildContext context, T value)? imageProvider;
  final Widget Function(BuildContext context, T value)? leadingIcon;
  final Widget Function(BuildContext context, T value) onPageBuilder;
  const AuthView(
      {Key? key,
      required this.viewControl,
      required this.onPageBuilder,
      this.imageProvider,
      this.imageHeight = 150,
      this.imageFit = BoxFit.fitWidth,
      this.backgroundImage,
      this.backGroundColor,
      this.leadingIcon,
      this.imageBackGroundColor = ColorResource.primaryColor})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    final T controller = Get.put(viewControl);
    return SafeArea(
      top: false,
      bottom: false,
      child: Scaffold(
        backgroundColor: ColorResource.white,
        body: Stack(
          children: [
            Positioned(
              left: 0,
              right: 0,
              top: 0,
              bottom: 0,
              child: Container(
                width: double.infinity,
                //height: imageHeight,
                alignment: Alignment.topCenter,
                color: imageBackGroundColor,
                padding:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                child: imageProvider != null
                    ? imageProvider!(context, controller)
                    : Image.asset(
                        backgroundImage ?? "",
                        fit: imageFit,
                        height: imageHeight,
                        width: double.infinity,
                      ),
              ),
            ),
            leadingIcon == null
                ? const SizedBox()
                : Padding(
                    padding: EdgeInsets.only(
                        top: MediaQuery.of(context).padding.top),
                    child: leadingIcon!(context, controller),
                  ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                margin:
                    EdgeInsets.only(top: MediaQuery.of(context).padding.top),
                height: MediaQuery.of(context).size.height -
                    MediaQuery.of(context).padding.top -
                    imageHeight +
                    0,
                width: Get.width,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(25),
                        topLeft: Radius.circular(25)),
                    color: backGroundColor ?? ColorResource.white),
                child: onPageBuilder(context, controller),
              ),
            )
          ],
        ),
      ),
    );
  }
}
class TitleBarCentered extends StatelessWidget {
  final String titleText;
  final bool isBatch;
  final Color? titleColor;
  final bool isCapital;

  const TitleBarCentered({
    Key? key,
    required this.titleText,
    this.isBatch = false,
    this.isCapital=false,
    this.titleColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.6,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            titleText,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),

        ],
      ),
    );
  }
}
// class TitleBarCentered extends StatelessWidget {
//   final String? titleText;
//   final bool isCapital;
//   final Color? titleColor;
//   final bool isBatch;
//
//   const TitleBarCentered({
//     Key? key,
//     this.titleText,
//     this.titleColor,
//     this.isCapital = false,
//     this.isBatch = false ,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return Text(
//       // Prev code
//       // titleText ?? '',
//       isCapital ? titleText?.toUpperCase() ?? '' : titleText ?? '', maxLines: 1,
//
//       style: StyleResource.instance.styleSemiBold().copyWith(
//             fontSize: isBatch
//                 ? DimensionResource.fontSizeDefault
//                 : DimensionResource.fontSizeExtraLarge+8 ,
//             color: titleColor ?? ColorResource.white,
//           ),
//       overflow: TextOverflow.visible,
//       textAlign: isBatch ? TextAlign.left : TextAlign.center,
//     );
//   }
// }
