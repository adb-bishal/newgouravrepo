import 'package:flutter/material.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';

class TitleBarLeft extends StatelessWidget {
   final String? titleText;
   final Color? titleColor;
   final double? textSize;

   const TitleBarLeft({Key? key,this.titleText,this.titleColor,this.textSize}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      titleText??'',
      style: StyleResource.instance.styleMedium(
          fontSize:textSize??DimensionResource.fontSizeExtraLarge,color:titleColor?? ColorResource.white),
      overflow: TextOverflow.ellipsis,
      textAlign: TextAlign.left,
    );
  }
}
