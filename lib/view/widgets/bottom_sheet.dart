import 'package:flutter/material.dart';

import '../../model/utils/color_resource.dart';
import '../../model/utils/dimensions_resource.dart';

@immutable
class BottomSheetModel {
  final bool isDismissible;
  final bool isScrollable;
  final bool isScrollControlled;
  final BorderRadius? borderRadius;
  final EdgeInsets? padding;
  final Widget child;
  final Color color;

  const BottomSheetModel(
      {required this.isDismissible,
      required this.isScrollable,
      required this.isScrollControlled,
      this.borderRadius,
      this.padding,
      required this.color,
      required this.child});
}

@immutable
class BottomSheetCommon extends BottomSheetModel {
  const BottomSheetCommon(
      {bool? isDismissible,
      bool? isScrollable,
      bool? isScrollControlled,
      BorderRadius? borderRadius,
      EdgeInsets? padding,
      Color? color,
      required Widget child})
      : super(
            isDismissible: isDismissible ?? false,
            isScrollable: isScrollable ?? true,
            isScrollControlled: isScrollControlled ?? true,
            borderRadius: borderRadius ??
                const BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
            color: color ?? ColorResource.white,
            padding: padding ?? padding,
            child: child);
}

@immutable
class TopPinContainer extends StatelessWidget {
  Widget child;

  TopPinContainer({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const SizedBox(
          height: DimensionResource.marginSizeSmall,
        ),
        Container(
          width: 35,
          height: 4,
          decoration: const BoxDecoration(
              color: ColorResource.grey,
              borderRadius: BorderRadius.all(Radius.circular(50))),
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

@immutable
class ScrollableBottomSheetContainer extends StatelessWidget {
  final Widget child;
  double? extraPadding;

  ScrollableBottomSheetContainer(
      {Key? key, required this.child, this.extraPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
          maxHeight:
              MediaQuery.of(context).size.height * 0.9 * (extraPadding ?? 1) -
                  MediaQuery.of(context).viewInsets.bottom),
      child: SingleChildScrollView(
        child: child,
      ),
    );
  }
}

extension Present on BottomSheetCommon {
  Future<dynamic> present(BuildContext context) {
    return showModalBottomSheet(
        enableDrag: isScrollable,
        isScrollControlled: isScrollControlled,
        barrierColor: Colors.black.withOpacity(0.4),
        backgroundColor: Colors.transparent,
        isDismissible: isDismissible,
        context: context,
        builder: (context) {
          return Container(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Padding(
              padding: padding ?? EdgeInsets.zero,
              child: ClipRRect(
                borderRadius: borderRadius ?? BorderRadius.zero,
                child: Container(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 0.64,
                  ),
                  decoration: BoxDecoration(
                      color: color,
                      boxShadow: const [
                        BoxShadow(
                            color: ColorResource.grey,
                            spreadRadius: 2,
                            blurRadius: 1,
                            offset: Offset(0, -2))
                      ],
                      borderRadius: borderRadius ?? BorderRadius.zero),
                  child: child,
                ),
              ),
            ),
          );
        });
  }
}
