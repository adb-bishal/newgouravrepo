import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

class RadioButtonWidget extends StatelessWidget {
  final String text;
  final bool isActive;
  const RadioButtonWidget({Key? key,required this.text,required this.isActive}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 15,
          width: 15,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: isActive ? ColorResource.primaryColor:ColorResource.secondaryColor,width: 1.3),
            color: ColorResource.white
          ),
          child: Visibility(
              visible: isActive,
              child: const Icon(Icons.circle,size: 10,color: ColorResource.primaryColor,)),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeExtraSmall),
          child: Text(text,style: StyleResource.instance.styleRegular(fontSize: DimensionResource.fontSizeDefault-2),),
        )
      ],
    );
  }
}
