import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:math' as math;

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';

Future<void> showAnimatedDialog(BuildContext context, Widget dialog,
    {bool isFlip = false, bool dismissible = true}) {
  return showGeneralDialog(
    context: context,
    barrierDismissible: dismissible,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    pageBuilder: (context, animation1, animation2) => dialog,
    transitionDuration: const Duration(milliseconds: 500),
    transitionBuilder: (context, a1, a2, widget) {
      if (isFlip) {
        return Rotation3DTransition(
          alignment: Alignment.center,
          animation: Tween<double>(begin: math.pi, end: 2.0 * math.pi).animate(
              CurvedAnimation(
                  parent: a1,
                  curve: const Interval(0.0, 1.0, curve: Curves.linear))),
          child: FadeTransition(
            opacity: Tween<double>(begin: 0.0, end: 1.0).animate(
                CurvedAnimation(
                    parent: a1,
                    curve: const Interval(0.5, 1.0, curve: Curves.elasticOut))),
            child: widget,
          ),
        );
      } else {
        return Transform.scale(
          scale: a1.value,
          child: Opacity(
            opacity: a1.value,
            child: widget,
          ),
        );
      }
    },
  );
}

class Rotation3DTransition extends AnimatedWidget {
  final Alignment? alignment;
  final Widget? child;
  const Rotation3DTransition({
    Key? key,
    required Animation<double> animation,
    this.alignment = Alignment.center,
    this.child,
  }) : super(key: key, listenable: animation);
  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    final double turnsValue = animation.value;
    final Matrix4 transform = Matrix4.identity()
      ..setEntry(3, 2, 0.0006)
      ..rotateY(turnsValue);
    return Transform(
      transform: transform,
      alignment: const FractionalOffset(0.5, 0.5),
      child: child,
    );
  }
}

showCommonDialog(Widget child) {
  return Center(
    child: SafeArea(
      

      child: Scaffold(
        backgroundColor: Colors.black.withOpacity(0.1),
        body: Center(
          child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                color: ColorResource.white,
                borderRadius: BorderRadius.circular(18)),
            padding: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault,
                vertical: DimensionResource.marginSizeDefault),
            margin: const EdgeInsets.symmetric(
                horizontal: DimensionResource.marginSizeDefault),
            child: child,
          ),
        ),
      ),
    ),
  );
}
//
Future<dynamic> buildShowModalBottomSheet(BuildContext context, Widget child,
    {Color? bgColor,
    double radius = 20,
    bool isDark = true,
    bool isDismissible = false}) {
  return showModalBottomSheet(
      isScrollControlled: true,
      barrierColor: Colors.black.withOpacity(0.4),
      backgroundColor: Colors.transparent,
      isDismissible: isDismissible,
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: ClipRRect(
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(radius),
              topLeft: Radius.circular(radius),
            ),
            child: Container(
              constraints: BoxConstraints(maxHeight: Get.height * 0.75),
              // height: MediaQuery.of(context).size.height * 0.44+height,
              decoration: BoxDecoration(
                  color: !isDark
                      ? bgColor ?? ColorResource.white
                      : bgColor ?? ColorResource.secondaryColor,
                  boxShadow: const [
                    BoxShadow(
                        color: ColorResource.secondaryColor,
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: Offset(0, -2))
                  ],
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(radius),
                    topLeft: Radius.circular(radius),
                  )),
              child: SingleChildScrollView(
                //padding: const EdgeInsets.only(bottom: DimensionResource.marginSizeSmall),
                physics: const ClampingScrollPhysics(),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(
                          top: DimensionResource.marginSizeExtraSmall + 3),
                      height: 6,
                      width: 45,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: isDark
                              ? ColorResource.borderColor
                              : ColorResource.borderColor),
                    ),
                    child
                  ],
                ),
              ),
            ),
          ),
        );
      });
}


// Future<dynamic> buildShowModalBottomSheet(BuildContext context, Widget child,
//     {Color? bgColor,
//       double radius = 20,
//       bool isDark = true,
//       bool isDismissible = false}) {
//   return showModalBottomSheet(
//     isScrollControlled: true,
//     barrierColor: Colors.black.withOpacity(0.4),
//     backgroundColor: Colors.transparent,
//     isDismissible: isDismissible,
//     context: context,
//     builder: (context) {
//       return Padding(
//         padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
//         child: ClipRRect(
//           borderRadius: BorderRadius.only(
//             topRight: Radius.circular(radius),
//             topLeft: Radius.circular(radius),
//           ),
//           child: Container(
//             constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.75),
//             decoration: BoxDecoration(
//               color: !isDark ? bgColor ?? Colors.white : bgColor ?? Colors.grey[900],
//               boxShadow: const [
//                 BoxShadow(
//                   color: Colors.black12,
//                   spreadRadius: 20,
//                   blurRadius: 1,
//                   offset: Offset(0, -2),
//                 )
//               ],
//               borderRadius: BorderRadius.only(
//                 topRight: Radius.circular(radius),
//                 topLeft: Radius.circular(radius),
//               ),
//             ),
//             child: SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               child: Column(
//                 mainAxisSize: MainAxisSize.min,
//                 children: [
//                   Container(
//                     margin: const EdgeInsets.only(top: 10),
//                     height: 6,
//                     width: 45,
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(20),
//                       color: isDark ? Colors.white38 : Colors.black26,
//                     ),
//                   ),
//                   child,
//                 ],
//               ),
//             ),
//           ),
//         ),
//       );
//     },
//   );
// }
//
// class WebinarFilterWidget extends StatefulWidget {
//   const WebinarFilterWidget({super.key});
//
//   @override
//   State<WebinarFilterWidget> createState() => _WebinarFilterWidgetState();
// }
//
// class _WebinarFilterWidgetState extends State<WebinarFilterWidget> {
//   final List<String> dayOptions = ['Today', 'Tomorrow', 'This Week', 'This Month'];
//   final List<String> categoryOptions = [
//     'Trading Psychology',
//     'Smart Money Concept',
//     'Positional Trading',
//     'Technical Analysis',
//     'Stock Market Basics',
//     'Advanced Trade Strategies',
//     'Fundamental Analysis',
//     'Intraday Trading',
//     'Options Trading',
//   ];
//
//   final Set<String> selectedDays = {};
//   final Set<String> selectedCategories = {};
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           /// Header
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               /// Days Column
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'By Days',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     const SizedBox(height: 12),
//                     ...dayOptions.map((item) => CheckboxListTile(
//                       value: selectedDays.contains(item),
//                       dense: true,
//                       contentPadding: EdgeInsets.zero,
//                       onChanged: (val) {
//                         setState(() {
//                           val! ? selectedDays.add(item) : selectedDays.remove(item);
//                         });
//                       },
//                       title: Text(item, style: const TextStyle(fontSize: 14)),
//                       controlAffinity: ListTileControlAffinity.leading,
//                       visualDensity: VisualDensity.compact,
//                     )),
//                   ],
//                 ),
//               ),
//
//               const SizedBox(width: 20),
//
//               /// Category Column
//               Expanded(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     const Text(
//                       'By Category',
//                       style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
//                     ),
//                     const SizedBox(height: 12),
//                     ...categoryOptions.map((item) => CheckboxListTile(
//                       value: selectedCategories.contains(item),
//                       dense: true,
//                       contentPadding: EdgeInsets.zero,
//                       onChanged: (val) {
//                         setState(() {
//                           val! ? selectedCategories.add(item) : selectedCategories.remove(item);
//                         });
//                       },
//                       title: Text(item, style: const TextStyle(fontSize: 14)),
//                       controlAffinity: ListTileControlAffinity.leading,
//                       visualDensity: VisualDensity.compact,
//                     )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//
//           const SizedBox(height: 24),
//
//           /// Footer
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               TextButton(
//                 onPressed: () {
//                   setState(() {
//                     selectedDays.clear();
//                     selectedCategories.clear();
//                   });
//                 },
//                 child: const Text("Clear all"),
//               ),
//               ElevatedButton(
//                 onPressed: () {
//                   // handle apply filter
//                   Navigator.pop(context);
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepPurple,
//                   padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 10),
//                 ),
//                 child: const Text("Apply"),
//               ),
//             ],
//           ),
//         ],
//       ),
//     );
//   }
// }
