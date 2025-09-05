import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

class SimpleTextField extends StatefulWidget {
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String? hintText;
  final bool? autoFocus;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final TextEditingController controller;
  final Function(String)? onValueChanged;
  final Function()? onClear;
  final TextStyle? style;
  final TextStyle? hintStyle;
  final bool? enabled;

  const SimpleTextField({
    Key? key,
    this.onClear,
    this.contentPadding,
    this.validator,
    this.keyboardType,
    this.autoFocus,
    this.hintText,
    this.inputFormatters,
    required this.controller,
    this.onValueChanged,
    this.style,
    this.hintStyle,
    this.enabled,
  }) : super(key: key);

  @override
  State<SimpleTextField> createState() => _SimpleTextFieldState();
}

class _SimpleTextFieldState extends State<SimpleTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autofocus: widget.autoFocus ?? false,
      enabled: widget.enabled,
      controller: widget.controller,
      inputFormatters: widget.inputFormatters,
      keyboardType: widget.keyboardType,
      cursorColor: ColorResource.primaryColor,
      style: widget.style ?? StyleResource.instance.styleRegular(),
      onChanged: widget.onValueChanged,
      decoration: InputDecoration(
          hintText: widget.hintText,
          counterText: "",
          hintStyle: widget.style ?? StyleResource.instance.styleRegular(),
          border: InputBorder.none,

          contentPadding: widget.contentPadding ??
              const EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0),
          // EdgeInsets.fromLTRB(12.0, 8.0, 12.0, 8.0)
          suffixIcon: (widget.controller.text != "")
              ? GestureDetector(
                  onTap: () {
                    widget.controller.text = "";
                    widget.controller.clear();
                    if (widget.onClear != null) {
                      widget.onClear!();
                    }
                    setState(() {});
                  },
                  child: Container(
                    margin: const EdgeInsets.all(13),
                    height: 16,
                    width: 16,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: ColorResource.textColor_6)),
                    child: const Icon(
                      Icons.clear,
                      color: ColorResource.textColor_6,
                      size: 12,
                    ),
                  ),
                )
              : const SizedBox(
                  height: 0,
                  width: 0,
                ),
          // errorText: "",
          // errorStyle: const TextStyle(
          //   height: 0,
          // )
      ),
      validator: widget.validator,
    );
  }
}
