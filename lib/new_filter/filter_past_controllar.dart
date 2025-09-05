// import 'package:get/get.dart';
// import '../../../../../model/models/explore_all_category/all_category_model.dart'
// as category;
// import '../../../../../model/network_calls/api_helper/provider_helper/courses_provider.dart';
// import '../../../../../model/network_calls/dio_client/get_it_instance.dart';
// import '../../../../../model/services/auth_service.dart';
// import '../../../../../view/widgets/toast_view/showtoast.dart';
// import '../../../../../view/widgets/log_print/log_print_condition.dart';
// import '../../../../../view/screens/root_view/live_classes_view/live_classes_view.dart';
//
//
// class PastClassesCategoryOnlyController extends GetxController {
//   PastClassesCategoryOnlyController({required List<DropDownData> initialCategories}) {
//     listOFSelectedCats.assignAll(initialCategories);
//     selectedSub.value = DropDownData(
//       id: "0",
//       optionName: subscriptionData[0].toLowerCase(),
//     );
//     logPrint("Initialized PastClassesCategoryOnlyController");
//   }
//
//   // Selected category list
//   RxList<DropDownData> listOFSelectedCats = <DropDownData>[].obs;
//
//   // All fetched categories
//   RxList<DropDownData> categoryLists = <DropDownData>[].obs;
//
//   // For loading state
//   RxBool isCategoryLoadings = false.obs;
//
//   // Subscription-related logic
//   Rx<DropDownData> selectedSub = DropDownData(id: "0", optionName: "all").obs;
//   RxList<String> subscriptionData = <String>["All", "Free", "Pro"].obs;
//
//   // Provider instance
//   final CourseProvider courseProvider = getIt();
//
//   @override
//   void onInit() {
//     super.onInit();
//     getAllCategories();
//   }
//
//   /// Fetch all available categories
//   void getAllCategories({String sort = "ASC"}) async {
//     isCategoryLoadings.value = true;
//     await courseProvider.getAllCategories(
//       languageId: Get.find<AuthService>().user.value.languageId?.toString() ?? "",
//       searchKeyWord: "",
//       sort: sort,
//       onError: (message, errorMap) {
//         isCategoryLoadings.value = false;
//         toastShow(message: message);
//       },
//       onSuccess: (message, json) {
//         final category.AllCategoryModel data = category.AllCategoryModel.fromJson(json!);
//         categoryLists.value = data.data
//             ?.map((e) => DropDownData(id: e?.id.toString(), optionName: e?.title))
//             .toList() ??
//             [];
//         isCategoryLoadings.value = false;
//       },
//     );
//   }
//
//   /// Clear all selected categories
//   void clearAllCategories() {
//     listOFSelectedCats.clear();
//   }
//
//   /// Toggle category selection
//   void toggleCategory(DropDownData categoryItem) {
//     if (listOFSelectedCats.any((cat) => cat.id == categoryItem.id)) {
//       listOFSelectedCats.removeWhere((cat) => cat.id == categoryItem.id);
//     } else {
//       listOFSelectedCats.add(categoryItem);
//     }
//   }
//
//   Map<String, dynamic> getSelectedFilters() {
//     return {
//       "category": listOFSelectedCats,
//
//     };
//   }
// }

