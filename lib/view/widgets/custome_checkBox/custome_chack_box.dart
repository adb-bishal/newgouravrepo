import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';

import '../../../model/utils/image_resource.dart';


class CustomCheckBox extends StatelessWidget {
  final VoidCallback ?onTap;
  final bool ?value;
  final double ?height;
  final double ?width;
  const CustomCheckBox({Key? key,this.value,this.onTap,this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
          height: height ?? 15,
          width: width??15,
          padding:const EdgeInsets.all(2),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(3),
              color:!value!? ColorResource.white:ColorResource.primaryColor,
              border: Border.all(color:!value!? ColorResource.borderColor:ColorResource.primaryColor,width: 1)
          ),
          child:Image.asset(ImageResource.instance.checkIcon,height: 20,color:ColorResource.white,)

      ),
    );
  }
}
