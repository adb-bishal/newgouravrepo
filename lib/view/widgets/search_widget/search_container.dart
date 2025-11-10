// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';

// import '../../../model/utils/color_resource.dart';
// import '../../../model/utils/dimensions_resource.dart';
// import '../../../model/utils/image_resource.dart';
// import '../text_field_view/simple_text_field.dart';

// class SearchWidget extends StatelessWidget {
//   const SearchWidget({
//     Key? key,
//     required this.onChange,
//     this.onClear,
//     this.enableMargin = true,
//     this.hintText = "Search",
    

//     required this.textEditingController,
//   }) : super(key: key);
//   final String hintText;
//   final bool enableMargin;
//   final TextEditingController textEditingController;
//   final Function(String?) onChange;
//   final Function()? onClear;

//   @override
//   Widget build(BuildContext context) {
//     return Card(
//       color: Colors.white,

//       elevation: 0,
//       shadowColor: ColorResource.white,
//       margin: EdgeInsets.symmetric(

//           horizontal: enableMargin ? DimensionResource.marginSizeDefault : 0),
//       shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(12),
//           side: const BorderSide(color: ColorResource.borderColor, width: 0.6)),
//       child: Container(
//         height: 42,
//         //color: Colors.red,
//         padding: const EdgeInsets.symmetric(
//             horizontal: DimensionResource.paddingSizeSmall,
//             vertical: DimensionResource.paddingSizeExtraSmall - 5),
//         child: Row(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Image.asset(
//               ImageResource.instance.searchIcon,
//               height: 20,
//               color: ColorResource.primaryColor,
//             ),
//             Expanded(
//                 child: SimpleTextField(
//               onClear: onClear,
//               controller: textEditingController,
//               /* inputFormatters: [
//                     FilteringTextInputFormatter.allow(RegExp("[a-zA-Z 0-9,-]"))
//                   ],*/
//               hintText: hintText,
//               onValueChanged: onChange,
//             )),
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../model/utils/color_resource.dart';
import '../../../model/utils/dimensions_resource.dart';
import '../../../model/utils/image_resource.dart';
import '../text_field_view/simple_text_field.dart';

class SearchWidget extends StatelessWidget {
  const SearchWidget({
    Key? key,
    required this.onChange,
    this.onClear,
    this.enableMargin = true,
    this.hintText = "Search",
    required this.textEditingController,
  }) : super(key: key);

  final String hintText;
  final bool enableMargin;
  final TextEditingController textEditingController;
  final Function(String?) onChange;
  final Function()? onClear;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      shadowColor: ColorResource.white,
      margin: EdgeInsets.symmetric(
        horizontal: enableMargin ? DimensionResource.marginSizeDefault : 0,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: ColorResource.borderColor, width: 0.6),
      ),
      child: Container(
        height: 42,
        padding: const EdgeInsets.symmetric(
          horizontal: DimensionResource.paddingSizeSmall,
          vertical: DimensionResource.paddingSizeExtraSmall - 5,
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              ImageResource.instance.searchIcon,
              height: 20,
              color: ColorResource.primaryColor,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: SimpleTextField(
                controller: textEditingController,
                hintText: hintText,
                onValueChanged: onChange,
                onClear: onClear,
                style: TextStyle(
                  fontSize: DimensionResource.fontSizeDefault, // your desired size
                  color: ColorResource.primaryColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
