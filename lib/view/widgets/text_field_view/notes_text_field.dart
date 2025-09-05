import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

import '../../../model/utils/color_resource.dart';

class NotesTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final bool isMarginEnable;
  final String hintText;
  final Color color;
  final Color? cursorColor;
  final TextStyle? hintStyle;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final TextStyle? style;
  final String? errorText;
  final BoxBorder? border;
  const NotesTextFormField({
    Key? key,
    required this.controller,
    this.isMarginEnable = true,
    this.errorText,
    this.inputFormatters,
    this.cursorColor,
    this.hintText = "Would you like to write anything about this service?",
    this.color = ColorResource.white,
    this.hintStyle,
    this.validator,
    this.border,
    this.style
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin:  EdgeInsets.symmetric(
              horizontal: isMarginEnable? DimensionResource.marginSizeDefault:0),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              border: border,
              color: color,
              ),
          child: TextFormField(
            controller: controller,
            maxLines: 7,
            maxLength: 400,
            inputFormatters: inputFormatters??[],
            validator: validator,
            style: style ??
                StyleResource.instance.styleLight(
                    fontSize: DimensionResource.fontSizeExtraSmall,
                    color: const Color(0xff8A8D9F)),
            cursorColor: cursorColor??ColorResource.white,
            decoration: InputDecoration(
              errorText: "",
                errorStyle: const TextStyle(
                  height: 0,
                ),
              counterText: "",
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: DimensionResource.marginSizeSmall,
                  vertical: DimensionResource.marginSizeExtraSmall,
                ),
                hintText:
                hintText,
                hintStyle: style?? StyleResource.instance.styleLight(
                    fontSize: DimensionResource.fontSizeExtraSmall,
                    color: const Color(0xff8A8D9F))),
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeExtraSmall,
        ),
        Row(
          children: [
            Text(
              (errorText??"").capitalize??"",
              style: StyleResource.instance.styleRegular(color: ColorResource.errorColor,fontSize: DimensionResource.fontSizeExtraSmall,),
              textAlign: TextAlign.start,
            ),
            const Spacer(),
            Align(
              alignment: Alignment.centerRight,
              child:  Text(
                "maximum 400 characters",
                style: StyleResource.instance.styleLight(
                    fontSize: DimensionResource.fontSizeExtraSmall,color: ColorResource.white.withOpacity(0.6)
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}