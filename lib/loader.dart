
import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';


class Loader extends StatelessWidget {
  final double radius;
  final Color? color;

  const Loader({Key? key, this.radius = 15.0, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: radius,
      color: color ?? ColorResource.primaryColor,
    );
  }
}