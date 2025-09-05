import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';

import '../../../model/utils/style_resource.dart';

class AboutUsTextField extends StatelessWidget {
  final TextEditingController? controller;
  final String? hintText;
  final FormFieldValidator<String>? validator;
  final String? errorText;
  const AboutUsTextField({Key? key, this.controller, this.hintText, this.validator, this.errorText}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          height: 120,
          padding: const EdgeInsets.only(top: 5, bottom: 5),
          decoration: BoxDecoration(
              color: ColorResource.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: ColorResource.borderColor,width: 1.5)),
          child: TextFormField(
            inputFormatters: [
              LengthLimitingTextInputFormatter(1024),
            ],
            controller: controller,
            minLines: 6,
            maxLines: null,
            keyboardType: TextInputType.multiline,
            textInputAction: TextInputAction.done,
            cursorColor: ColorResource.primaryColor,
            style: StyleResource.instance.styleRegular(),
            decoration: InputDecoration(
                hintText: hintText ?? "Please enter your message",
                hintStyle: StyleResource.instance.styleRegular(),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 15,vertical: 5),
                errorText: "",
                errorStyle: const TextStyle(
                  height: 0,
                )),
            validator: validator,
          ),
        ),
        errorText == null || errorText == ""
            ? const SizedBox()
            : Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 0),
                child: Text(
                  errorText?.capitalize??"",
                  style: StyleResource.instance.styleRegular(),
                  textAlign: TextAlign.start,
                ),
              ),
      ],
    );
  }
}
