
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/utils/style_resource.dart';
import 'validation_error_controller.dart';

class ErrorContainer extends StatelessWidget {
  final ErrorController controller;
  final EdgeInsets? padding;
  final Widget? child;

  const ErrorContainer({Key? key, required this.controller, this.child, this.padding}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(()=> Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [Align(alignment: Alignment.center,child: child,),
        controller.isShow.value ? Padding(padding: padding??const EdgeInsets.all(4.0),
          child: Text(controller.errorText.value,style: StyleResource.instance.styleRegular(),textAlign: TextAlign.start,),
        ):Container()],),
    );
  }
}