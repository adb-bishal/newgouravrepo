import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

class LabelContainer extends StatelessWidget {

  final Widget child;
  final String label;
  final String? errorText;
  final Widget? trailWidget;
  final bool isRequired;
  final bool ?boldLabel;
  const LabelContainer({Key? key, required this.child, required this.label, this.errorText, required this.isRequired, this.trailWidget,this.boldLabel}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isRequired?"$label *" :label,
              style:boldLabel==true? StyleResource.instance.styleMedium():StyleResource.instance.styleRegular(),
              textAlign: TextAlign.start,
            ),
            trailWidget ?? const SizedBox()
          ],
        ),
        SizedBox(
          height: boldLabel==true?10:0,
        ),
        child,
        errorText == null || errorText == ""
            ? const SizedBox(
                height: 10,
              )
            : Padding(
                padding: const EdgeInsets.only(left: 0, right: 0, top: 5, bottom: 5),
                child: Text(
                  (errorText ?? "").capitalize??"",
                  style: StyleResource.instance.styleRegular(),
                  textAlign: TextAlign.start,
                ),
              ),
      ]),
    );
  }
}
