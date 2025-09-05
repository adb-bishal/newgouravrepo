import 'package:flutter/material.dart';

class ContainerIconButton extends StatelessWidget {
  final Icon? icon;
  final Image? imageIcon;
  final Icon? rightIcon;
  final Image? rightImageIcon;
  final bool? isExpanded;
  final String text;
  final Function() onPressed;
  final TextStyle textStyle;
  final EdgeInsets padding;
  final double radius;
  final double borderWidth;
  final Color color;
  final Color borderColor;
  const ContainerIconButton({Key? key,
    this.icon,
    this.imageIcon,
    this.rightIcon,
    this.rightImageIcon,
    this.isExpanded,
    required this.text,
    required this.onPressed,
    required this.textStyle,
    required this. padding,
    required this.radius,
    required this.color,
    required this.borderColor,
    required this.borderWidth }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: Container(
        decoration: BoxDecoration(color:color,
            borderRadius: BorderRadius.circular(radius),
            border: Border.all(color: borderColor,width: borderWidth,) ),
        padding: padding,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize:  (isExpanded == null || isExpanded!) ?MainAxisSize.min:MainAxisSize.max,
          children: [
            icon??imageIcon??Container(),
            if(icon !=null || imageIcon !=null)
              const SizedBox(width: 10,),
            Text(
              text,
              textAlign: TextAlign.center,
              style: textStyle,
            ),

            if(rightIcon !=null || rightImageIcon !=null)
              const SizedBox(width: 10,),
            rightIcon??rightImageIcon??Container(),



          ],
        ),
      ),
    );

  }
}