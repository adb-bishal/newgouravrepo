import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

import '../../../model/utils/image_resource.dart';

class StarContainer extends StatelessWidget {
  final String rating;
  final Color bgColor;
  final Color fontColor;
  final double vertical;
  final double horizontal;
  final bool isDark;
  const StarContainer(
      {Key? key,
      this.rating = "",
      this.bgColor = ColorResource.secondaryColor,
      this.fontColor = ColorResource.white,
      this.vertical = 2,
      this.horizontal = 4,
      this.isDark = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: rating != "" && rating != "0.0",
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: isDark ? ColorResource.white : bgColor),
        padding:
            EdgeInsets.symmetric(vertical: vertical, horizontal: horizontal),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              ImageResource.instance.starIcon,
              height: 8,
            ),
            const SizedBox(
              width: 3,
            ),
            Text(
              rating,
              style: StyleResource.instance.styleMedium(
                  fontSize: 9,
                  color: isDark ? ColorResource.secondaryColor : fontColor),
            )
          ],
        ),
      ),
    );
  }
}

class LiveContainer extends StatelessWidget {
  final Color bgColor;
  final Color fontColor;
  final double verticalPadding;
  final double horizontalPadding;
  final double size;
  const LiveContainer(
      {Key? key,
      this.bgColor = ColorResource.redColor,
      this.fontColor = ColorResource.white,
      this.verticalPadding = 2,
      this.horizontalPadding = 4,
      this.size = 8})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: bgColor),
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImageResource.instance.liveIcon,
            height: size,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            "LIVE",
            style: StyleResource.instance
                .styleMedium(fontSize: size, color: fontColor),
          )
        ],
      ),
    );
  }
}

class BatchTypeContainer extends StatelessWidget {
  const BatchTypeContainer(
      {super.key,
      required this.bgColor,
      required this.fontColor,
      required this.verticalPadding,
      required this.horizontalPadding,
      required this.size,
      required this.text});
  final Color bgColor;
  final Color fontColor;
  final double verticalPadding;
  final double horizontalPadding;

  final double size;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10), color: bgColor),
      padding: EdgeInsets.symmetric(
          vertical: verticalPadding, horizontal: horizontalPadding),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            ImageResource.instance.liveIcon,
            height: size,
            fit: BoxFit.contain,
          ),
          const SizedBox(
            width: 3,
          ),
          Text(
            text,
            style: StyleResource.instance
                .styleMedium(fontSize: size, color: fontColor),
          )
        ],
      ),
    );
  }
}
