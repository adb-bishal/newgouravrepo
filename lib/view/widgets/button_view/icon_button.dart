import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';

class ActionCustomButton extends StatelessWidget {
  final Function() onTap;
  final String icon;
  final Color? iconColor;
  final double iconSize;
  final double padding;
  final EdgeInsets morePadding;
  final bool isLeft;
  final int greenDotValue;
  final bool showGreenDot;
  const ActionCustomButton(
      {Key? key,
      required this.onTap,
      required this.icon,
      this.iconSize = 16,
      this.padding = 8,
      this.morePadding = EdgeInsets.zero,
      this.greenDotValue = 0,
      this.showGreenDot = false,
      this.iconColor,
      required this.isLeft})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
          padding: morePadding,
          height: double.infinity,
          child: Padding(
            padding: EdgeInsets.only(
                left: isLeft ? 0 : padding, right: isLeft ? padding : 0),
            child: Center(
                child: Stack(
              alignment: Alignment.topRight,
              children: [
                Padding(
                  padding: EdgeInsets.only(
                      right: showGreenDot ? 6 : 0, top: showGreenDot ? 4 : 0),
                  child: Image.asset(
                    icon,
                    color: iconColor,
                    height: iconSize,
                  ),
                ),
                Visibility(
                  visible: showGreenDot,
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: const BoxDecoration(
                        color: ColorResource.mateGreenColor,
                        shape: BoxShape.circle),
                    child: Text(
                      greenDotValue.toString(),
                      style: const TextStyle(fontSize: 11, color: Colors.white),
                    ),
                  ),
                )
              ],
            )),
          )),
    );
  }
}
