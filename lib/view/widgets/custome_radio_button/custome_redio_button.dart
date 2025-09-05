import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';


class CustomRadioButton extends StatelessWidget {
  final VoidCallback ?onTap;
  final bool ?value;
  final double ?height;
  final double ?width;
  const CustomRadioButton({Key? key,this.value,this.onTap,this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          height: height ?? 18,
          width: width??18,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color:value!? ColorResource.grey:ColorResource.grey_3,width:value!? 6:1)
          ),
      ),
    );
  }
}
