import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/dimensions_resource.dart';
import 'package:stockpathshala_beta/model/utils/style_resource.dart';

import '../../../model/utils/color_resource.dart';

class MyDialog extends StatelessWidget {
  final VoidCallback? onPress;
  final bool? isFailed;
  final double? rotateAngle;
  final String? title;
  final String? yesText;
  final String? noText;
  final String? description;
  final String? image;
  final String? color;
  final Widget? child;
  final Widget? icon;
    const MyDialog(
      {super.key,
      this.isFailed = false,
      this.rotateAngle = 0,
      this.child,
      required this.title,
      required this.description,
      required this.onPress,
      this.yesText,
      this.noText,
      this.color,
      this.icon,
      this.image});

  @override
  Widget build(BuildContext context) {
    var device = MediaQuery.of(context);
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      child: Container(
        color: Colors.white,
        padding: const EdgeInsets.all(20),
        width: device.orientation == Orientation.portrait
            ? device.size.width * .8
            : device.size.width * .4,
        child: child ??
            Stack(clipBehavior: Clip.none, children: [
              Positioned(
                left: 0,
                right: 0,
                top: -55,
                child: Container(
                  height: 55,
                  width: 55,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                      color: ColorResource.primaryColor,
                      shape: BoxShape.circle),
                  child: Transform.rotate(
                    angle: rotateAngle!,
                    child: icon ??
                        Image.asset(
                          image!,
                          height: 25,
                          color: Colors.white,
                        ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  Text(title!, style: StyleResource.instance.styleSemiBold()),
                  const SizedBox(height: 10),
                  Text(description!,
                      textAlign: TextAlign.center,
                      style: StyleResource.instance.styleMedium()),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: ColorResource.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                  color: ColorResource.primaryColor, width: 2)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: MaterialButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                onPressed: () {
                                  Get.back();
                                },
                                child: Text(noText ?? "No",
                                    style: StyleResource.instance.styleSemiBold(
                                    
                                        fontSize:

                                            DimensionResource.fontSizeSmall)),
                              )),
                        ),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                              color: ColorResource.primaryColor,
                              borderRadius: BorderRadius.circular(8)),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: MaterialButton(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 15),
                                onPressed: onPress!,
                                child: Text(yesText ?? "Yes",
                                    style: StyleResource.instance.styleSemiBold(
                                        color: ColorResource.white,
                                        fontSize:
                                            DimensionResource.fontSizeSmall)),
                              )),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ]),
      ),
    );
  }
}
