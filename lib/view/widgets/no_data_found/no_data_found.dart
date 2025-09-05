import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

class NoDataFound extends StatelessWidget {
  final bool isSomething;
  final bool showText;
  final bool isDark;
  final String? text;
  const NoDataFound({
    Key? key,
    this.isSomething = false,
    this.showText = false,
    this.isDark = false,
    this.text
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // const SizedBox(
          //   height: DimensionResource.marginSizeExtraLarge +0
          //       //DimensionResource.marginSizeExtraLarge,
          // ),
          showText ?
          Center(
            child: Text(text??"",style: StyleResource.instance.styleSemiBold(color: isDark ?ColorResource.white :ColorResource.secondaryColor),textAlign: TextAlign.center,),
          ):
          Image.asset(
            ImageResource.instance.dataNotImage,
            fit: BoxFit.contain,
            height: 220,
          ),
        ],
      ),
    );
  }
}