import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';

// toastShow({String? message, bool? error}) {
//   return Fluttertoast.showToast(
//       msg: (message ?? "Something wrong here.").capitalize ?? "",
//       gravity: ToastGravity.BOTTOM,
//       toastLength: Toast.LENGTH_SHORT,
//       timeInSecForIosWeb: 1,
//       backgroundColor: (error ?? false)
//           ? ColorResource.mateRedColor
//           : ColorResource.secondaryColor,
//       textColor: ColorResource.white,
//       fontSize: 12.0);
// }


toastShow({String? message, bool? error}) {
  return Fluttertoast.showToast(
    msg: message ?? "Something went wrong.",
    gravity: ToastGravity.BOTTOM,
    toastLength: Toast.LENGTH_LONG, // Ensure it shows long enough
    timeInSecForIosWeb: 3,
    backgroundColor: (error ?? false)
              ? ColorResource.mateRedColor
          : ColorResource.secondaryColor,
      textColor: ColorResource.white,
    fontSize: 14.0,
  );
}
