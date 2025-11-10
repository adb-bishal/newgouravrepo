import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';

class CommonCircularIndicator extends StatelessWidget {
  final Color? color;
  const CommonCircularIndicator({Key? key, this.color}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: color ?? ColorResource.primaryColor,
        strokeWidth: 2,
        
        backgroundColor: Colors.white,
      ),
    );
  }
}
