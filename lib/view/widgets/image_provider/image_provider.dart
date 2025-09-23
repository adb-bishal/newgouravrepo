import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';
import '../../../model/utils/image_resource.dart';
import '../shimmer_widget/shimmer_widget.dart';

Widget cachedNetworkImage(String url,
    {BoxFit fit = BoxFit.fill,
      Color? color,
      bool imageLoader = false,
      Alignment? alignment}) {
  return SizedBox(
    child: CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      alignment: alignment ?? Alignment.center,
      placeholder: (context, url) => imageLoader
          ? const CommonCircularIndicator()
          : ShimmerEffect.instance.imageLoader(color: color),
      errorWidget: (context, url, error) {
        if (kDebugMode) {
          logPrint('network image error: $error');
        }
        return imageLoader
            ? const CommonCircularIndicator()
            : Container(
          color: color ?? ColorResource.imageBackground,
          padding: const EdgeInsets.all(22.0),
          child: Image.asset(
            ImageResource.instance.errorImage,
            fit: BoxFit.contain,
          ),
        );
      },
    ),
  );
}
