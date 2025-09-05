import 'package:stockpathshala_beta/view/screens/root_view/live_classes_view/live_classes_view.dart';
import 'package:get_storage/get_storage.dart';

// class Session {
//   static String _item = "";
//
//   static void setItem(String value) => _item = value;
//   static String get item => _item;
//
//   static getSelectedDateFilter() {
//     switch (_item) {
//       case 'Today':
//         return "today";
//       case 'Tomorrow':
//         return "tomorrow";
//       case 'Yesterday':
//         return "yesterday";
//       case 'Last Week':
//         return "last_week";
//       case 'This Week':
//         return "this_week";
//       case 'This Month':
//         return "this_month";
//       default:
//         return null;
//     }
//   }
//
// }
class Session {
  static String _item = "";
  static final box = GetStorage();

  static void setItem(String value) {
    _item = value;
    box.write('selected_date_filter', value);
  }

  static String get item {
    _item = box.read('selected_date_filter') ?? "";
    return _item;
  }

  static getSelectedDateFilter() {
    if (_item.isEmpty) {
      _item = box.read('selected_date_filter') ?? "";
    }
    switch (_item) {
      case 'Today':
        return "today";
      case 'Tomorrow':
        return "tomorrow";
      case 'Yesterday':
        return "yesterday";
      case 'Last Week':
        return "last_week";
      case 'This Week':
        return "this_week";
      case 'This Month':
        return "this_month";
      default:
        return null;
    }
  }
}