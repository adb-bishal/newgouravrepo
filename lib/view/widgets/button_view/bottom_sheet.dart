import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/style_resource.dart';

class BottomSheetModel {
  final bool isDismissible;
  final bool isScrollControlled;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Widget child;
  final String? title;
  final bool? titleStart;
  final Color color;
  final double ?height;

  BottomSheetModel(
      {required this.isDismissible,
        required this.isScrollControlled,
        this.borderRadius,
        this.padding,
        this.title,
        this.titleStart,
        this.height,
        required this.color,
        required this.child});
}

class DetailSuper extends StatelessWidget {
  final String title;
  final bool titleStart;
  final Widget child;
  const DetailSuper({Key? key, required this.child, required this.title, required this.titleStart}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: DimensionResource.marginSizeLarge, vertical: DimensionResource.marginSizeDefault),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Visibility(
                visible : titleStart == true ? true:false,
                child: const SizedBox(
                  width: 24,
                  height: 24,
                ),
              ),
              Expanded(child: Text(title,style: StyleResource.instance.styleRegular())),
              InkWell(
                onTap: () {
                  Get.back();
                },
                child: const Icon(
                  Icons.close,
                  size: 24,
                  color: ColorResource.black,
                ),
              )
            ],
          ),
        ),
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        ),
        child,
        /*const SizedBox(
          height: DimensionResource.marginSizeSmall,
        )*/
      ],
    );
  }
}

extension Present on BottomSheetModel {
  Future<dynamic> present(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: isScrollControlled,
        barrierColor: Colors.black.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        context: context,
        builder: (context) {
          return Padding(
            padding: padding ?? EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.44,
                ),
                decoration: BoxDecoration(
                    color: color,
                    boxShadow: const [
                      BoxShadow(
                          color: ColorResource.grey_2,
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, -2))
                    ],
                    borderRadius: borderRadius),
                child: child,
              ),
            ),
          );
        });
  }

  Future<dynamic> presentDetail(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: isScrollControlled,
        barrierColor: Colors.black.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        context: context,
        builder: (context) {
          return Padding(
            padding: padding ?? EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: Container(
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.44,
                ),
                decoration: BoxDecoration(
                    color: color,
                    boxShadow: const [
                      BoxShadow(
                          color: ColorResource.grey_2,
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, -2))
                    ],
                    borderRadius: borderRadius),
                child: DetailSuper(
                  title: title??"",
                  titleStart: titleStart??false,
                  child: child,
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> presentFull(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: isScrollControlled,
        barrierColor: Colors.black.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        context: context,
        builder: (context) {
          return Padding(
            padding: padding ?? EdgeInsets.zero,
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: Container(
                height: double.infinity,
                constraints: BoxConstraints(
                  minHeight: MediaQuery.of(context).size.height * 0.44,
                ),
                decoration: BoxDecoration(
                    color: color,
                    boxShadow: const [
                      BoxShadow(
                          color: ColorResource.grey_2,
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, -2))
                    ],
                    borderRadius: borderRadius),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: MediaQuery.of(context).padding.top + 30),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: DimensionResource.marginSizeLarge,
                          vertical: DimensionResource.marginSizeExtraSmall),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          InkWell(
                            onTap: () {
                              Get.back();
                            },
                            child: const Icon(
                              Icons.close,
                              size: 24,
                              color: ColorResource.black,
                            ),
                          )
                        ],
                      ),
                    ),
                    const SizedBox(
                      height: DimensionResource.marginSizeSmall,
                    ),
                    Expanded(child: child),
                    const SizedBox(
                      height: DimensionResource.marginSizeSmall,
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> presentHalf(BuildContext context) {
    return showModalBottomSheet(
        isScrollControlled: isScrollControlled,
        barrierColor: Colors.black.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        context: context,
        builder: (context) {
          return Padding(
            padding: padding ?? MediaQuery.of(context).viewInsets,
            child: ClipRRect(
              borderRadius: borderRadius ?? BorderRadius.zero,
              child: Container(
                height:height?? MediaQuery.of(context).size.height*.35,
                constraints: BoxConstraints(
                  minHeight:height?? MediaQuery.of(context).size.height * 0.35,
                ),
                decoration: BoxDecoration(
                    color: color,
                    boxShadow: const [
                      BoxShadow(
                          color: ColorResource.grey_2,
                          spreadRadius: 2,
                          blurRadius: 1,
                          offset: Offset(0, -2))
                    ],
                    borderRadius: borderRadius),
                child:child,
              ),
            ),
          );
        });
  }
}
