import 'package:flutter/cupertino.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';

class CustomSwitchButton extends StatelessWidget {
  final Function(bool)? onChanged;
  final bool ?value;
  final double ?height;
  final double ?width;
  const CustomSwitchButton({Key? key,this.value,this.onChanged,this.height,this.width}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 30, //set desired REAL HEIGHT
      width: 40, //
      child:  Transform.scale(
        transformHitTests: false,
        scale: .7,
        child: CupertinoSwitch(
          activeColor: ColorResource.primaryColor,
          thumbColor: ColorResource.white,
          trackColor: ColorResource.grey_1,
          value: value ?? false,
          onChanged: onChanged,
        ),
      ),
    );
  }
}
