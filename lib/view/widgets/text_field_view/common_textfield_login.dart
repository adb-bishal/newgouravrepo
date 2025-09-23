import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

class CommonTextFieldLogin extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final TextCapitalization? textCapitalization;
  final Function(String)? onFieldSubmitted;
  final String? initialVal;
  final String? label;
  final String? hintText;
  final String? errorText;
  final String? iconData;
  final bool? obscureText;
  final Widget? prefixIcon;
  final bool readOnly;
  final bool isLabel;
  final bool showEdit;
  final bool isLogin;
  final bool isSpace;
  final bool isTrailPopUp;
  final bool? isHint;
  final FocusNode? focus;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;
  final Color? containerColor;
  final Color? cursorColor;
  final Color? outLineColor;
  final Color? hintColor;
  final Color? errorColor;
  final int? maxLength;
  final Widget? suffix;
  final bool? passwordView;
  final EdgeInsetsGeometry? padding;
  final Function(String)? onValueChanged;
  final Function()? onTap;
  final TextStyle? style;
  final TextStyle? hintStyle;

  CommonTextFieldLogin(
      {Key? key,
        this.validator,
        this.isLabel = true,
        this.keyboardType,
        this.textInputAction,
        this.textCapitalization,
        this.onFieldSubmitted,
        this.label,
        this.isHint,
        this.isTrailPopUp = false,
        this.initialVal,
        this.hintText,
        this.isLogin = false,
        this.isSpace = false,
        this.errorText,
        this.iconData,
        this.padding,
        this.obscureText,
        this.prefixIcon,
        this.inputFormatters,
        this.controller,
        this.focus,
        this.containerColor,
        this.cursorColor,
        this.outLineColor,
        this.hintColor,
        this.errorColor,
        this.maxLength,
        this.passwordView,
        this.onValueChanged,
        this.style,
        this.onTap,
        this.hintStyle,
        this.suffix,
        this.showEdit = true,
        this.readOnly = false})
      : super(key: key);
  RxBool passwordVisible = true.obs;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 40,
          decoration: BoxDecoration(
              boxShadow: const [
                BoxShadow(
                  color: ColorResource.grey_4,
                ),
                BoxShadow(
                  color: ColorResource.white,
                ),
                BoxShadow(
                  color: ColorResource.white,
                )
              ],
              color: containerColor ?? ColorResource.white,
              borderRadius:
              BorderRadius.circular(DimensionResource.appDefaultRadius),
              border: Border.all(
                  color: const Color.fromARGB(255, 0, 0, 0), width: 0.6)),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // +91 prefix section with proper alignment
                if (isLogin)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Center(
                      child: Text(
                        "+91",
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: DimensionResource.fontSizeSmall,
                            color: Color.fromARGB(255, 35, 35, 35)),
                      ),
                    ),
                  ),

                // Text field section with proper alignment
                Expanded(
                  child: TextFormField(
                    focusNode: focus,
                    obscureText:
                    passwordView == true ? passwordVisible.value : false,
                    controller: controller,
                    readOnly: readOnly,
                    inputFormatters: inputFormatters,
                    textInputAction: textInputAction ?? TextInputAction.done,
                    keyboardType: keyboardType,
                    maxLength: maxLength ?? 40,
                    onChanged: onValueChanged,
                    obscuringCharacter: '●',
                    onTap: onTap,
                    cursorColor: const Color.fromARGB(255, 14, 17, 21),
                    cursorHeight: 20,
                    textAlignVertical: TextAlignVertical.center,
                    style: isHint ?? true
                        ? StyleResource.instance.styleSemiBold(
                        fontSize: DimensionResource.fontSizeSmall,
                        color: const Color.fromARGB(255, 156, 156, 156))
                        : const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: DimensionResource.fontSizeSmall,
                        color: Color.fromARGB(255, 35, 35, 35)),
                    onFieldSubmitted: onFieldSubmitted,
                    decoration: InputDecoration(
                      prefixIcon: prefixIcon,
                      labelText: isLabel ? hintText : null,
                      counterText: "",
                      hintText: isLabel ? null : hintText,
                      hintStyle: StyleResource.instance.styleLight(
                          fontSize: DimensionResource.fontSizeSmall,
                          color: const Color.fromARGB(255, 0, 0, 0)),
                      labelStyle: isLabel
                          ? StyleResource.instance.styleLight(
                          fontSize: DimensionResource.fontSizeSmall,
                          color: ColorResource.textColor_6)
                          : null,
                      border: InputBorder.none,
                      suffixIcon: passwordView ?? false
                          ? InkWell(
                        onTap: () => passwordVisible.value =
                        !passwordVisible.value,
                        child: Container(
                          height: double.infinity,
                          width: 55,
                          alignment: Alignment.center,
                          child: Icon(
                            passwordVisible.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: ColorResource.primaryColor,
                            size: 25,
                          ),
                        ),
                      )
                          : suffix ??
                          ((!readOnly && showEdit)
                              ? Container(
                            alignment: Alignment.center,
                            padding: const EdgeInsets.only(right: 10),
                            child: Image.asset(
                              ImageResource.instance.editIcon,
                              color: ColorResource.primaryColor,
                              height: 16,
                              width: 16,
                            ),
                          )
                              : null),
                      contentPadding: padding ??
                          EdgeInsets.only(
                            left: isLogin ? 0 : 16,
                            right: 8,
                            top: 16,
                            bottom: 16,
                          ),
                      isDense: false,
                      alignLabelWithHint: true,
                      counterStyle: const TextStyle(height: 0),
                      errorStyle: const TextStyle(height: 0),
                    ),
                    validator: validator,
                  ),
                ),
              ],
            ),
          ),
        ),
        errorText == null || errorText == ""
            ? SizedBox(
          height: isSpace ? 0 : DimensionResource.marginSizeLarge,
        )
            : Padding(
          padding: const EdgeInsets.only(top: 4, bottom: 4),
          child: Text(
            errorText?.capitalize ?? "",
            style: StyleResource.instance.styleRegular(
                color: ColorResource.errorColor,
                fontSize: DimensionResource.fontSizeExtraSmall),
            textAlign: TextAlign.start,
          ),
        ),
      ],
    );
  }
}

class NormalTextField extends StatelessWidget {
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  final String? errorText;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController? controller;

  const NormalTextField({
    Key? key,
    this.validator,
    this.keyboardType,
    this.hintText,
    this.errorText,
    this.inputFormatters,
    this.controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 38,
          alignment: Alignment.centerLeft,
          child: TextFormField(
            controller: controller,
            inputFormatters: inputFormatters,
            keyboardType: keyboardType,
            cursorColor: ColorResource.primaryColor,
            textAlignVertical: TextAlignVertical.center,
            style: StyleResource.instance.styleRegular(),
            decoration: InputDecoration(
              hintText: hintText,
              counterText: "",
              hintStyle: StyleResource.instance.styleRegular(),
              border: InputBorder.none,
              contentPadding: const EdgeInsets.symmetric(
                  horizontal: 15,
                  vertical: 8
              ),
              isDense: true,
              errorText: "",
              errorStyle: const TextStyle(height: 0),
            ),
            validator: validator,
          ),
        ),
        if (errorText != null && errorText!.isNotEmpty)
          Padding(
            padding: const EdgeInsets.only(top: 4),
            child: Text(
              errorText!,
              style: StyleResource.instance.styleRegular(
                color: ColorResource.errorColor,
                fontSize: DimensionResource.fontSizeExtraSmall,
              ),
              textAlign: TextAlign.start,
            ),
          ),
      ],
    );
  }
}