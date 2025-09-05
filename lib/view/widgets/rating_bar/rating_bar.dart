import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/image_resource.dart';

typedef void RatingChangeCallback(double rating);

class StarRating extends StatelessWidget {
  final int starCount;
  final double size;
  final double rating;
  final RatingChangeCallback? onRatingChanged;
  final Color? color;

  const StarRating({super.key, this.starCount = 5, this.rating = .0, this.onRatingChanged, this.color,this.size = 16});

  Widget buildStar(BuildContext context, int index) {
    Widget icon;
    if (index >= rating) {
      icon =  Image.asset(
        ImageResource.instance.starOutLineIcon,
        height: size,
        color: color ?? ColorResource.white,
      );
    }
    else {
      icon =  Image.asset(
        ImageResource.instance.starIcon,
        height: size,
        color: color ?? ColorResource.starColor,
      );
    }
    return  Padding(
      padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeSmall),
      child: InkResponse(
        splashColor: Colors.white,
        onTap: onRatingChanged == null ? null : () => onRatingChanged!(index + 1.0),
        child: icon,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return  Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:  List.generate(starCount, (index) => buildStar(context, index)));
  }
}