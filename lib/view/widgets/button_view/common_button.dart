import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/string_resource.dart';
import '../../../model/utils/style_resource.dart';
import '../toast_view/showtoast.dart';

class CommonButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? style;
  final Widget? child;
  final bool loading;
  final bool showBorder;
  final Color color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final double elevation;
  final double radius;
  final icon;
  final bool? iconShow;

  const CommonButton(
      {Key? key,
        required this.text,
        this.child,
        required this.loading,
        required this.onPressed,
        this.elevation = 0,
        this.radius = DimensionResource.appDefaultRadius,
        this.color = ColorResource.secondaryColor,
        this.textColor,
        this.width,
        this.showBorder = false,
        this.height,
        this.fontSize,
        this.style,
        this.icon,
        this.iconShow})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(radius),
          side: showBorder
              ? const BorderSide(color: ColorResource.borderColor, width: 1.5)
              : BorderSide(color: color, width: 1.5)),
      color: color,
      child: SizedBox(
          height: height ?? 45,
          width: width ?? double.infinity,
          child: MaterialButton(
              onPressed: loading ? () {} : onPressed,
              child: Center(
                child: loading
                    ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ))
                    : child ??
                    FittedBox(
                      child: Row(
                        children: [
                          if (iconShow == true)
                            Row(
                              children: [
                                Icon(
                                  icon,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                              ],
                            ),
                          Text(text,
                              style: style ??
                                  StyleResource.instance.styleMedium(
                                      fontSize: fontSize ??
                                          DimensionResource.fontSizeLarge -
                                              1,
                                      color: textColor ??
                                          ColorResource.white)),
                        ],
                      ),
                    ),
              ))),
    );
  }
}

class BuyButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final TextStyle? style;
  final Widget? child;
  final bool loading;
  final bool showBorder;
  final Color color;
  final Color? textColor;
  final double? width;
  final double? height;
  final double? fontSize;
  final double elevation;
  final double radius;

  const BuyButton(
      {Key? key,
        required this.text,
        this.child,
        required this.loading,
        required this.onPressed,
        this.elevation = 0,
        this.radius = DimensionResource.appDefaultRadius,
        this.color = ColorResource.secondaryColor,
        this.textColor,
        this.width,
        this.showBorder = false,
        this.height,
        this.fontSize,
        this.style})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(
                0.5), // Adjust the shadow color and opacity as needed
            spreadRadius: 5, // Adjust the spread radius
            blurRadius: 7, // Adjust the blur radius
            offset: const Offset(0, 3), // Adjust the position of the shadow
          ),
        ],
        borderRadius: BorderRadius.circular(radius),
        color: color,
        // image: DecorationImage(
        //   image: AssetImage(
        //     'assets/images/buy_bttn.png',
        //   ), // Replace 'assets/background_image.jpg' with your image path
        //   fit: BoxFit.fitHeight, // Adjust the fit as needed
        // ),
      ),
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      child: SizedBox(
          height: height ?? 45,
          width: width ?? double.infinity,
          child: MaterialButton(
              onPressed: loading ? () {} : onPressed,
              child: Center(
                child: loading
                    ? const SizedBox(
                    height: 30,
                    width: 30,
                    child: CircularProgressIndicator(
                      strokeWidth: 3,
                      valueColor:
                      AlwaysStoppedAnimation<Color>(Colors.white),
                    ))
                    : child ??
                    FittedBox(
                      child: Text(text,
                          style: style ??
                              StyleResource.instance.styleMedium(
                                  fontSize: fontSize ??
                                      DimensionResource.fontSizeLarge - 1,
                                  color: textColor ?? ColorResource.black)),
                    ),
              ))),
    );
  }
}

class CommonContainer extends StatelessWidget {
  final VoidCallback? onPressed;
  final bool loading;
  final bool showBorder;
  final bool isDisable;
  final Widget child;
  final Color color;
  final double? width;
  final double? radius;
  final double? height;
  final double elevation;
  final EdgeInsetsGeometry? padding;
  const CommonContainer({
    Key? key,
    required this.isDisable,
    required this.loading,
    required this.child,
    this.padding,
    this.radius,
    required this.onPressed,
    this.elevation = 0,
    this.color = ColorResource.secondaryColor,
    this.width,
    this.showBorder = false,
    this.height,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      margin: EdgeInsets.zero,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
              radius ?? DimensionResource.appDefaultContainerRadius),
          side: showBorder && !isDisable
              ? const BorderSide(color: ColorResource.borderColor, width: 1.5)
              : BorderSide(color: color, width: isDisable ? 0 : 1.5)),
      color: color,
      child: SizedBox(
          height: height ?? 50,
          width: width ?? double.infinity,
          child: Stack(
            children: [
              MaterialButton(
                  padding: padding ??
                      const EdgeInsetsDirectional.only(start: 12.0, end: 16.0),
                  onPressed: loading ? () {} : onPressed,
                  child: Center(
                    child: loading
                        ? const SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(
                          strokeWidth: 3,
                          valueColor:
                          AlwaysStoppedAnimation<Color>(Colors.white),
                        ))
                        : child,
                  )),
              Visibility(
                visible: isDisable,
                child: GestureDetector(
                  onTap: () {
                    toastShow(message: StringResource.onDownloadButton);
                  },
                  child: Container(
                    color: Colors.white.withOpacity(0.35),
                  ),
                ),
              )
            ],
          )),
    );
  }
}

class ContainerButton extends StatelessWidget {
  const ContainerButton(
      {Key? key,
        required this.text,
        this.child,
        this.color,
        this.isLoading = false,
        this.fontColor,
        required this.onPressed,
        this.padding = const EdgeInsets.symmetric(
            horizontal: DimensionResource.paddingSizeSmall,
            vertical: DimensionResource.paddingSizeSmall),
        this.radius = 40,
        this.isIconShow = false,
        this.fontSize,
        this.borderColor = Colors.transparent,
        this.borderWidth = 0,
        this.textStyle,
        this.icon})
      : super(key: key);

  final String? text;
  final TextStyle? textStyle;
  final Color? color;
  final Color? fontColor;
  final Color? borderColor;
  final VoidCallback? onPressed;
  final double? radius;
  final double? fontSize;
  final double? borderWidth;
  final bool? isIconShow;
  final bool? isLoading;
  final Widget? icon;
  final Widget? child;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        InkWell(
          //splashColor: ColorResource.primaryColor,
          onTap: isLoading ?? false ? null : onPressed,
          child: Container(
            decoration: BoxDecoration(
                color: color ?? ColorResource.secondaryColor,
                borderRadius: BorderRadius.circular(radius!),
                border: Border.all(color: borderColor!, width: borderWidth!)),
            padding: padding,
            child: Center(
              child: isLoading ?? false
                  ? const SizedBox(
                height: 15,
                width: 15,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 1,
                ),
              )
                  : child ??
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        text ?? "",
                        style: textStyle ??
                            StyleResource.instance.styleRegular().copyWith(
                                fontSize: fontSize ??
                                    DimensionResource.fontSizeDefault,
                                color: fontColor ??
                                    ColorResource.primaryColor),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      Visibility(
                          visible: isIconShow!,
                          child: icon ??
                              Padding(
                                padding: const EdgeInsets.only(left: 8.0),
                                child: Image.asset(
                                  ImageResource.instance.arrowCircleIcon,
                                  height: 17,
                                ),
                              ))
                    ],
                  ),
            ),
          ),
        ),
      ],
    );
  }
}

class ContainerSelectionButton extends StatelessWidget {
  final Function() onTap;
  final bool isSelected;
  final bool showCheckIcon;
  final String text;
  final double? width;
  final double selectedFontSize;
  final double unSelectedFontSize;
  final EdgeInsetsGeometry padding;
  const ContainerSelectionButton({
    required this.onTap,
    required this.isSelected,
    required this.showCheckIcon,
    required this.text,
    this.selectedFontSize = DimensionResource.fontSizeSmall,
    this.unSelectedFontSize = DimensionResource.fontSizeSmall,
    this.width,
    this.padding = const EdgeInsets.symmetric(
        horizontal: DimensionResource.marginSizeLarge,
        vertical: DimensionResource.marginSizeDefault),
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      padding: EdgeInsets.zero,
      onPressed: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(6),
      ),
      child: SizedBox(
        width: width,
        child: Card(
          elevation: 0,
          margin: EdgeInsets.zero,
          color: isSelected ? ColorResource.primaryColor : Colors.transparent,
          //  margin: EdgeInsets.only(right: index.isEven?DimensionResource.marginSizeDefault:0,left: index.isOdd?DimensionResource.marginSizeDefault:0,bottom: DimensionResource.marginSizeLarge),
          clipBehavior: Clip.antiAliasWithSaveLayer,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
              side: BorderSide(
                  color: isSelected
                      ? ColorResource.primaryColor
                      : ColorResource.borderColor,
                  width: .6)),
          child: Padding(
            padding: padding,
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Visibility(
                      visible: isSelected && showCheckIcon,
                      child: Image.asset(
                        ImageResource.instance.checkIcon,
                        height: 14,
                        color: ColorResource.white,
                      )),
                  Visibility(
                    visible: isSelected && showCheckIcon,
                    child: const SizedBox(
                      width: DimensionResource.marginSizeSmall,
                    ),
                  ),
                  Expanded(
                      child: Text(
                        text,
                        style: isSelected
                            ? StyleResource.instance.styleBold(
                            fontSize: selectedFontSize,
                            color: ColorResource.white)
                            : StyleResource.instance.styleRegular(
                          fontSize: unSelectedFontSize,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      )),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
