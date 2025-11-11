// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:shimmer/shimmer.dart';
// import 'package:stockpathshala_beta/model/models/explore_all_category/all_category_model.dart' as category;
// import 'package:stockpathshala_beta/model/services/auth_service.dart';
// import 'package:stockpathshala_beta/model/utils/color_resource.dart';
// import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
// import 'package:stockpathshala_beta/view/widgets/text_field_view/regex/regex.dart';
// import 'package:stockpathshala_beta/view_model/controllers/profile_controller/profile_controller.dart';

// import '../../../../model/models/account_models/language_model.dart';
// import '../../../../model/utils/dimensions_resource.dart';
// import '../../../../model/utils/image_resource.dart';
// import '../../../../model/utils/string_resource.dart';
// import '../../../../model/utils/style_resource.dart';
// import '../../../../view_model/routes/app_pages.dart';
// import '../../../widgets/button_view/common_button.dart';
// import '../../../widgets/image_provider/image_provider.dart';
// import '../../../widgets/image_provider/image_selection_util.dart';
// import '../../../widgets/no_data_screen/no_data_screen.dart';
// import '../../../widgets/text_field_view/common_textfield.dart';
// import '../../auth_view/select_prefer.dart';
// import '../../base_view/base_view_screen.dart';

// class ProfileView extends StatelessWidget {
//   const ProfileView({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final screenWidth = MediaQuery.of(context).size.width;
//     return BaseView(
//       onAppBarTitleBuilder: (context, controller) => TitleBarCentered(
//         titleText: StringResource.profile,
//       ),
//       onActionBuilder: (context, controller) => [
//         InkWell(
//           onTap: () {
//             Get.toNamed(Routes.settingView);
//           },
//           child:  Icon(
//             Icons.settings_outlined,
//             color: ColorResource.white,
//             size:screenWidth<500? 24:34,
//           ),
//         )
//       ],
//       onBackClicked: (context, controller) {
//         Get.back();
//       },
//       viewControl: ProfileController(),
//       onPageBuilder: (context, controller) =>
//           _mainPageBuilder(context, controller),
//     );
//   }

//   Widget _mainPageBuilder(BuildContext context, ProfileController controller) {
//     final screenWidth  = MediaQuery.of(context).size.width;
//     return SafeArea(
//       child: Stack(
//         children: [
//           Scaffold(
//           backgroundColor: Colors.white,
//             resizeToAvoidBottomInset: true,
//             bottomNavigationBar: Obx(() {
//               return Container(
//                 color: ColorResource.secondaryColor,
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     CommonButton(
//                       height: screenWidth <500 ?45:70,
//                       text: StringResource.updateProfile,
//                       loading: controller.isPrefLoading.value,
//                       onPressed: controller.onUpdate,
//                       radius: 0,
//                     ),
//                     Container(
//                       height: Platform.isIOS ? 20 : 0,
//                       color: ColorResource.secondaryColor,
//                     )
//                   ],
//                 ),
//               );
//             }),
//             body: SingleChildScrollView(
//               physics: const ClampingScrollPhysics(),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Padding(
//                     padding: const EdgeInsets.symmetric(
//                         horizontal: DimensionResource.marginSizeDefault),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                          SizedBox(
//                           height:screenWidth<500? DimensionResource.marginSizeLarge:DimensionResource.marginSizeExtraLarge+12,
//                         ),
//                         Row(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const SizedBox(
//                               width: 30,
//                             ),
//                             SizedBox(
//                               height: screenWidth < 500 ? 93 : 160,
//                               width: screenWidth < 500 ? 93 : 166,
//                               child: Card(
//                                 margin: EdgeInsets.zero,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(12),
//                                   side: BorderSide(
//                                     color: ColorResource.primaryColor.withOpacity(0.4),
//                                     width: 1.3,
//                                   ),
//                                 ),
//                                 color: ColorResource.primaryColor.withOpacity(0.4),
//                                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                                 child: Obx(() => controller.selectedImage.value == ""
//                                     ? cachedNetworkImage(
//                                     Get.find<AuthService>().user.value.profileImage ?? "")
//                                     : imageContainer(
//                                   "",
//                                   imageProvider: Image.file(
//                                     File(controller.selectedImage.value),
//                                     fit: BoxFit.cover,
//                                   ),
//                                 )),
//                               ),
//                             ),
//                             InkWell(
//                               onTap: () => controller.pickImageAndUpload(),
//                               child: Card(
//                                 shadowColor: ColorResource.secondaryColor,
//                                 elevation: 4,
//                                 margin: EdgeInsets.zero,
//                                 shape: RoundedRectangleBorder(
//                                   borderRadius: BorderRadius.circular(3),
//                                 ),
//                                 color: ColorResource.white,
//                                 clipBehavior: Clip.antiAliasWithSaveLayer,
//                                 child: Padding(
//                                   padding: EdgeInsets.all(screenWidth < 500 ? 5.0 : 10),
//                                   child: Image.asset(
//                                     ImageResource.instance.editIcon,
//                                     color: ColorResource.primaryColor,
//                                     height: screenWidth < 500 ? 11 : 24,
//                                   ),
//                                 ),
//                               ),
//                             ),
      
//                             // SizedBox(
//                             //   height: screenWidth <500?93:160,
//                             //   width: screenWidth<500?93:166,
//                             //   child: Card(
//                             //     margin: EdgeInsets.zero,
//                             //     shape: RoundedRectangleBorder(
//                             //         borderRadius: BorderRadius.circular(12),
//                             //         side: BorderSide(
//                             //             color: ColorResource.primaryColor
//                             //                 .withOpacity(0.4),
//                             //             width: 1.3)),
//                             //     color:
//                             //         ColorResource.primaryColor.withOpacity(0.4),
//                             //     clipBehavior: Clip.antiAliasWithSaveLayer,
//                             //     child: Obx(() => controller.selectedImage.value ==
//                             //             ""
//                             //         ? cachedNetworkImage(Get.find<AuthService>()
//                             //                 .user
//                             //                 .value
//                             //                 .profileImage ??
//                             //             "")
//                             //         : imageContainer("",
//                             //             imageProvider: Image.file(
//                             //               File(controller.selectedImage.value),
//                             //               fit: BoxFit.cover,
//                             //             ))),
//                             //   ),
//                             // ),
//                             // InkWell(
//                             //   onTap: () {
//                             //     ImageSelectionUtil((file) async {
//                             //       await controller
//                             //           .sendFile(file, true)
//                             //           .then((value) {
//                             //         controller.selectedImage.value = file.path;
//                             //       });
//                             //     }).
//                             //     showImagePicker(context);
//                             //   },
//                             //   child: Card(
//                             //     shadowColor: ColorResource.secondaryColor,
//                             //     elevation: 4,
//                             //     margin: EdgeInsets.zero,
//                             //     shape: RoundedRectangleBorder(
//                             //       borderRadius: BorderRadius.circular(3),
//                             //     ),
//                             //     color: ColorResource.white,
//                             //     clipBehavior: Clip.antiAliasWithSaveLayer,
//                             //     child: Padding(
//                             //       padding:  EdgeInsets.all(screenWidth<500?5.0:10),
//                             //       child: Image.asset(
//                             //         ImageResource.instance.editIcon,
//                             //         color: ColorResource.primaryColor,
//                             //         height:screenWidth<500? 11:24,
//                             //       ),
//                             //     ),
//                             //   ),
//                             // )
//                           ],
//                         ),
//                          SizedBox(
//                           height: screenWidth<500? DimensionResource.marginSizeExtraLarge:DimensionResource.marginSizeExtraLarge+20,
//                         ),
//                         Form(
//                           autovalidateMode: AutovalidateMode.onUserInteraction,
//                           key: controller.profileFormKey,
//                           child: Obx(
//                             () => Column(
//                               crossAxisAlignment: CrossAxisAlignment.start,
//                               children: [
//                                 Text(
//                                   StringResource.yourInfo,
//                                   style: TextStyle(fontFamily: 'DMSans',fontSize: 14,fontWeight: FontWeight.w500,),
//                                 ),
//                                  SizedBox(
//                                   height:screenWidth<500? DimensionResource.marginSizeSmall: DimensionResource.marginSizeDefault,
//                                 ),
//                                 CommonTextField(
//                                   label: StringResource.name,
//                                   controller: controller.nameController.value,
//                                   hintText: StringResource.enterName,
//                                   keyboardType: TextInputType.name,
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       controller.nameError.value =
//                                           StringResource.emptyNameError;
//                                       return "";
//                                     }
//                                     // else if(!value.isValidEmail()){
//                                     //   controller.emailError.value ="Please enter valid email address";
//                                     //   return "";
//                                     // }
//                                     else {
//                                       controller.nameError.value = "";
//                                       return null;
//                                     }
//                                   },
//                                   errorText: controller.nameError.value,
//                                 ),
//                                 CommonTextField(
//                                   label: StringResource.email,
//                                   readOnly:
//                                       Get.find<AuthService>().user.value.email ==
//                                                   null ||
//                                               Get.find<AuthService>()
//                                                       .user
//                                                       .value
//                                                       .email ==
//                                                   ""
//                                           ? false
//                                           : true,
//                                   controller: controller.emailController.value,
//                                   hintText: StringResource.enterEmail,
//                                   keyboardType: TextInputType.emailAddress,
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       controller.emailError.value =
//                                           StringResource.emptyEmailError;
//                                       return "";
//                                     } else if (!value.isValidEmail()) {
//                                       controller.emailError.value =
//                                           StringResource.validEmailError;
//                                       return "";
//                                     } else {
//                                       controller.emailError.value = "";
//                                       return null;
//                                     }
//                                   },
//                                   errorText: controller.emailError.value,
//                                   suffix: Container(
//                                     margin: const EdgeInsets.only(left: 16.0), // Add margin as needed
//                                     child: Padding(
//                                       padding:  EdgeInsets.only(
//                                         left: 14.0,
//                                         top: screenWidth<500? 16.0:13,
//                                         bottom: 16.0,
//                                         right: 0.0,
//                                       ),
//                                       child: Image.asset(
//                                         ImageResource.instance.editIcon,
//                                         color: ColorResource.buttonTextColor, // Change this to your desired purple color
//                                         height:11,
//                                       ),
//                                     ),
//                                   ),
      
//                                 ),
//                                 CommonTextField(
//                                   label: "Mobile",
//                                   readOnly: controller
//                                           .mobileController.value.text.isEmpty
//                                       ? false
//                                       : true,
//                                   controller: controller.mobileController.value,
//                                   hintText: StringResource.enterMobile,
//                                   keyboardType: TextInputType.phone,
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.allow(
//                                         RegExp("[0-9]")),
//                                   ],
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       controller.mobileError.value =
//                                           StringResource.emptyPhoneError;
//                                       return "";
//                                     } else if (!value.isValidNumber()) {
//                                       controller.mobileError.value =
//                                           StringResource.correctPhoneError;
//                                       return "";
//                                     } else {
//                                       controller.mobileError.value = "";
//                                       return null;
//                                     }
//                                   },
//                                   errorText: controller.mobileError.value,
//                                 ),
//                                 CommonTextField(
//                                   label: "dob",
//                                   readOnly: true,
//                                   onTap: () async {
//                                     await showDatePicker(
//                                             context: context,
//                                             builder: (context, child) {
//                                               return Theme(

//                                                 data: Theme.of(context).copyWith(
//                                                   colorScheme:
//                                                       const ColorScheme.light(
//                                                     primary: ColorResource
//                                                         .primaryColor, // header background color
//                                                     onPrimary: Colors
//                                                         .white, // header text color
//                                                     onSurface: ColorResource
//                                                         .secondaryColor, // body text color
//                                                   ),
//                                                   textButtonTheme:
//                                                       TextButtonThemeData(
//                                                     style: TextButton.styleFrom(
//                                                       foregroundColor: ColorResource
//                                                           .primaryColor, // button text color
//                                                     ),
//                                                   ),
//                                                 ),
//                                                 child: child!,
//                                               );
//                                             },
//                                             initialDate: DateTime(
//                                                 DateTime.now().year - 8, 01, 01),
//                                             firstDate: DateTime(1960),
//                                             lastDate: DateTime(
//                                                 DateTime.now().year - 8, 12, 31))
//                                         .then((value) {
//                                       if (value != null) {
//                                         controller.dobController.value.text =
//                                             DateFormat(
//                                                     StringResource.dobDateFormat)
//                                                 .format(value);
//                                         controller.selectedDoB.value = value;
//                                       }
//                                     });
//                                   },
//                                   controller: controller.dobController.value,
//                                   hintText: StringResource.enterDob,
//                                   keyboardType: TextInputType.phone,
//                                   suffix: Container(
//                                     margin: const EdgeInsets.only(left: 16.0), // Add margin as needed
//                                     child: Padding(
//                                       padding: const EdgeInsets.only(
//                                         left: 14.0,
//                                         top: 14.0,
//                                         bottom: 14.0,
//                                         right: 0.0,
//                                       ),
//                                       child: Image.asset(
//                                         ImageResource.instance.dateIcon,
//                                         color: ColorResource.borderColor,
//                                         height: 11,
//                                       ),
//                                     ),
//                                   ),
      
//                                   inputFormatters: [
//                                     FilteringTextInputFormatter.allow(
//                                         RegExp("[0-9]")),
//                                   ],
//                                   validator: (value) {
//                                     if (value!.isEmpty) {
//                                       controller.dobError.value =
//                                           StringResource.emptyDobError;
//                                       return "";
//                                     } else {
//                                       controller.dobError.value = "";
//                                       return null;
//                                     }
//                                   },
//                                   errorText: controller.dobError.value,
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // Text(
//                         //   StringResource.choosePrefferLang,
//                         //   style: StyleResource.instance.styleMedium(
//                         //       fontSize:screenWidth<500? DimensionResource.fontSizeDefault
//                         //           :DimensionResource.fontSizeDoubleExtraLarge),
//                         // ),
//                         //  SizedBox(
//                         //   height: screenWidth<500?DimensionResource.marginSizeExtraSmall - 3:DimensionResource.marginSizeSmall-2,
//                         // ),
//                         // Text(
//                         //   StringResource.chooseOneLanguage,
//                         //   style: StyleResource.instance.styleLight(
//                         //       fontSize:screenWidth<500? DimensionResource.fontSizeSmall - 1:DimensionResource.fontSizeDefault),
//                         // ),
//                         //  SizedBox(
//                         //   height:screenWidth<500? DimensionResource.marginSizeSmall:DimensionResource.marginSizeDefault,
//                         // ),
//                         // Obx(() {
//                         //   return !controller.isLangLoading.value
//                         //       ? controller.languageData.value.data?.isEmpty ??
//                         //               true
//                         //           ? SizedBox(
//                         //               height: Get.height * 0.35,
//                         //               child: const NoDataFoundScreen(),
//                         //             )
//                         //           : Wrap(
//                         //               runSpacing:
//                         //                   DimensionResource.marginSizeDefault,
//                         //               spacing: DimensionResource.marginSizeSmall,
//                         //               children: List.generate(
//                         //                   controller.languageData.value.data
//                         //                           ?.length ??
//                         //                       0, (index) {
//                         //                 Datum data = controller
//                         //                         .languageData.value.data!
//                         //                         .elementAt(index) ??
//                         //                     Datum();
//                         //                 return ContainerSelectionButton(
//                         //                   onTap: () {
//                         //                     controller.onLanguageSelect(data);
//                         //                   },
//                         //                   showCheckIcon: true,
//                         //                   text: data.languageName ?? "",
//                         //                   width:screenWidth<500? 160:190,
//                         //                   isSelected: controller
//                         //                           .selectedLanguage.value.id ==
//                         //                       data.id,
//                         //                 );
//                         //               }),
//                         //             )
//                         //       : Wrap(
//                         //           runSpacing: DimensionResource.marginSizeLarge,
//                         //           spacing: DimensionResource.marginSizeSmall,
//                         //           children: List.generate(3, (index) {
//                         //             return Shimmer.fromColors(
//                         //               baseColor: Colors.grey[300]!,
//                         //               highlightColor: Colors.grey[100]!,
//                         //               enabled: true,
//                         //               child: Container(
//                         //                 height: 45,
//                         //                 width: 160,
//                         //                 decoration: BoxDecoration(
//                         //                     color: Colors.white,
//                         //                     borderRadius:
//                         //                         BorderRadius.circular(6),
//                         //                     border: Border.all(
//                         //                         color:
//                         //                             ColorResource.borderColor)),
//                         //               ),
//                         //             );
//                         //           }),
//                         //         );
//                         // }),
//                          SizedBox(
//                           height:screenWidth<500? DimensionResource.marginSizeDefault:DimensionResource.marginSizeLarge,
//                         ),
//                         Text(
//                           StringResource.choiceOfInterest,
//                           style: StyleResource.instance.styleMedium(
//                               fontSize:screenWidth<500? DimensionResource.fontSizeDefault:DimensionResource.fontSizeDoubleExtraLarge),
//                         ),
//                          SizedBox(
//                           height:screenWidth<500? DimensionResource.marginSizeExtraSmall - 3:DimensionResource.marginSizeSmall-2,
//                         ),
//                         Text(
//                           '(${StringResource.interestCanSelect})',
//                           style: StyleResource.instance.styleLight(
//                               fontSize:screenWidth<500? DimensionResource.fontSizeSmall - 1:DimensionResource.fontSizeLarge),
//                         ),
//                          SizedBox(
//                           height:screenWidth<500? DimensionResource.marginSizeSmall:DimensionResource.marginSizeDefault,
//                         ),
//                         Obx(() {
//                           return Wrap(
//                               runSpacing: DimensionResource.marginSizeSmall,
//                               spacing: DimensionResource.marginSizeSmall,
//                               children: !controller.isTagLoading.value
//                                   ? List.generate(
//                                       controller.tagsData.value.data?.length ?? 0,
//                                       (index) {
//                                       category.Datum data = controller
//                                           .tagsData.value.data!
//                                           .elementAt(index);
//                                       return Row(
//                                         mainAxisSize: MainAxisSize.min,
//                                         children: [
//                                           buildSelectedContainer(() {
//                                             if (controller.selectedTags.any(
//                                                 (element) =>
//                                                     element.id == data.id)) {
//                                               controller.selectedTags.removeWhere(
//                                                   (element) =>
//                                                       element.id == data.id);
//                                             } else {
//                                               controller.selectedTags.add(data);
//                                             }
//                                           },
//                                               controller.selectedTags.any(
//                                                   (element) =>
//                                                       element.id == data.id),
//                                               data.title ?? ""),
//                                         ],
//                                       );
//                                     })
//                                   : List.generate(3, (index) {
//                                       return Shimmer.fromColors(
//                                         baseColor: Colors.grey[300]!,
//                                         highlightColor: Colors.grey[100]!,
//                                         enabled: true,
//                                         child: Container(
//                                           height: 40,
//                                           width: 75,
//                                           margin: EdgeInsets.only(
//                                               right: index != 2
//                                                   ? DimensionResource
//                                                       .marginSizeSmall
//                                                   : 0),
//                                           decoration: BoxDecoration(
//                                               color: Colors.white,
//                                               borderRadius:
//                                                   BorderRadius.circular(6),
//                                               border: Border.all(
//                                                   color:
//                                                       ColorResource.borderColor)),
//                                         ),
//                                       );
//                                     }));
//                         }),
//                         const SizedBox(
//                           height: DimensionResource.marginSizeLarge,
//                         ),
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.center,
//                         //   children: [
//                         //     ContainerButton(
//                         //       padding: const EdgeInsets.symmetric(
//                         //           horizontal:
//                         //               DimensionResource.marginSizeSmall + 2,
//                         //           vertical:
//                         //               DimensionResource.marginSizeExtraSmall + 3),
//                         //       color: ColorResource.borderColor.withOpacity(0.1),
//                         //       radius: 5,
//                         //       text: "",
//                         //       onPressed: () {
//                         //         controller.onLogOut(context);
//                         //       },
//                         //       isIconShow: true,
//                         //       icon: Image.asset(
//                         //         ImageResource.instance.retakeIcon,
//                         //         height: 14,
//                         //       ),
//                         //       child: Row(
//                         //         mainAxisSize: MainAxisSize.min,
//                         //         children: [
//                         //           Padding(
//                         //             padding: const EdgeInsets.only(right: 4.0),
//                         //             child: Image.asset(
//                         //               ImageResource.instance.logoutIcon,
//                         //               height: 13,
//                         //             ),
//                         //           ),
//                         //           Text(
//                         //             StringResource.logOut,
//                         //             style: StyleResource.instance
//                         //                 .styleSemiBold()
//                         //                 .copyWith(
//                         //                     fontSize: DimensionResource
//                         //                             .fontSizeDefault -
//                         //                         1,
//                         //                     color: ColorResource.primaryColor),
//                         //             maxLines: 1,
//                         //             overflow: TextOverflow.ellipsis,
//                         //           ),
//                         //         ],
//                         //       ),
//                         //     ),
//                         //   ],
//                         // ),
//                         // const SizedBox(
//                         //   height: DimensionResource.marginSizeLarge,
//                         // ),
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.center,
//                         //   children: [
//                         //     ContainerButton(
//                         //       padding: const EdgeInsets.symmetric(
//                         //           horizontal:
//                         //               DimensionResource.marginSizeSmall + 2,
//                         //           vertical:
//                         //               DimensionResource.marginSizeExtraSmall + 3),
//                         //       color: ColorResource.borderColor.withOpacity(0.1),
//                         //       radius: 5,
//                         //       text: "",
//                         //       onPressed: () {
//                         //         controller.onAccountDelete(context);
//                         //       },
//                         //       isIconShow: true,
//                         //       icon: Image.asset(
//                         //         ImageResource.instance.retakeIcon,
//                         //         height: 14,
//                         //       ),
//                         //       child: Row(
//                         //         mainAxisSize: MainAxisSize.min,
//                         //         children: [
//                         //           const Padding(
//                         //             padding: EdgeInsets.only(right: 4.0),
//                         //             child: Icon(
//                         //               Icons.delete,
//                         //               color: ColorResource.redColor,
//                         //             ),
//                         //           ),
//                         //           Text(
//                         //             StringResource.deleteAccount,
//                         //             style: StyleResource.instance
//                         //                 .styleSemiBold()
//                         //                 .copyWith(
//                         //                     fontSize: DimensionResource
//                         //                             .fontSizeDefault -
//                         //                         1,
//                         //                     color: ColorResource.redColor),
//                         //             maxLines: 1,
//                         //             overflow: TextOverflow.ellipsis,
//                         //           ),
//                         //         ],
//                         //       ),
//                         //     ),
//                         //   ],
//                         // ),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(
//                     height: DimensionResource.marginSizeExtraLarge + 10,
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           Obx(() {
//             return Visibility(
//               visible: controller.isLogOutLoading.value,
//               child: Container(
//                   color: ColorResource.white.withOpacity(0.4),
//                   child: const CommonCircularIndicator()),
//             );
//           })
//         ],
//       ),
//     );
//   }
// }

// }
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shimmer/shimmer.dart';
import 'package:stockpathshala_beta/model/models/explore_all_category/all_category_model.dart' as category;
import 'package:stockpathshala_beta/model/services/auth_service.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';
import 'package:stockpathshala_beta/view/widgets/circular_indicator/circular_indicator_widget.dart';
import 'package:stockpathshala_beta/view/widgets/text_field_view/regex/regex.dart';
import 'package:stockpathshala_beta/view_model/controllers/profile_controller/profile_controller.dart';

import '../../../../model/models/account_models/language_model.dart';
import '../../../../model/utils/dimensions_resource.dart';
import '../../../../model/utils/image_resource.dart';
import '../../../../model/utils/string_resource.dart';
import '../../../../model/utils/style_resource.dart';
import '../../../../enum/routing/routes/app_pages.dart';
import '../../../widgets/button_view/common_button.dart';
import '../../../widgets/image_provider/image_provider.dart';
import '../../../widgets/image_provider/image_selection_util.dart';
import '../../../widgets/no_data_screen/no_data_screen.dart';
import '../../../widgets/text_field_view/common_textfield.dart';
import '../../auth_view/select_prefer.dart';
import '../../base_view/base_view_screen.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return BaseView(
      onAppBarTitleBuilder: (context, controller) => TitleBarCentered(
        titleText: StringResource.profile,
      ),
      onActionBuilder: (context, controller) => [
        InkWell(
          onTap: () {
            Get.toNamed(Routes.settingView);
          },
          child:  Icon(
            Icons.settings_outlined,
            color: ColorResource.white,
            size:screenWidth<500? 24:34,
          ),
        )
      ],
      onBackClicked: (context, controller) {
        Get.back();
      },
      viewControl: ProfileController(),
      onPageBuilder: (context, controller) =>
          _mainPageBuilder(context, controller),
    );
  }

  Widget _mainPageBuilder(BuildContext context, ProfileController controller) {
    final screenWidth  = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Stack(
        children: [
          Scaffold(
          backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            bottomNavigationBar: Obx(() {
              return Container(
                color: ColorResource.secondaryColor,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CommonButton(
                      height: screenWidth <500 ?45:70,
                      text: StringResource.updateProfile,
                      loading: controller.isPrefLoading.value,
                      onPressed: controller.onUpdate,
                      radius: 0,
                    ),
                    Container(
                      height: Platform.isIOS ? 20 : 0,
                      color: ColorResource.secondaryColor,
                    )
                  ],
                ),
              );
            }),
            body: SingleChildScrollView(
              physics: const ClampingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: DimensionResource.marginSizeDefault),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                         SizedBox(
                          height:screenWidth<500? DimensionResource.marginSizeLarge:DimensionResource.marginSizeExtraLarge+12,
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              width: 30,
                            ),
                            SizedBox(
                              height: screenWidth < 500 ? 93 : 160,
                              width: screenWidth < 500 ? 93 : 166,
                              child: Card(
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  side: BorderSide(
                                    color: ColorResource.primaryColor.withOpacity(0.4),
                                    width: 1.3,
                                  ),
                                ),
                                color: ColorResource.primaryColor.withOpacity(0.4),
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Obx(() => controller.selectedImage.value == ""
                                    ? cachedNetworkImage(
                                    Get.find<AuthService>().user.value.profileImage ?? "")
                                    : imageContainer(
                                  "",
                                  imageProvider: Image.file(
                                    File(controller.selectedImage.value),
                                    fit: BoxFit.cover,
                                  ),
                                )),
                              ),
                            ),
                            InkWell(
                              onTap: () => controller.pickImageAndUpload(),
                              child: Card(
                                shadowColor: ColorResource.secondaryColor,
                                elevation: 4,
                                margin: EdgeInsets.zero,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                color: ColorResource.white,
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                child: Padding(
                                  padding: EdgeInsets.all(screenWidth < 500 ? 5.0 : 20),
                                  child: Image.asset(
                                    ImageResource.instance.editIcon,
                                    color: ColorResource.primaryColor,
                                    height: screenWidth < 500 ? 11 : 24,
                                  ),
                                ),
                              ),
                            ),
      
                          ],
                        ),
                         SizedBox(
                          height: screenWidth<500? DimensionResource.marginSizeExtraLarge:DimensionResource.marginSizeExtraLarge+20,
                        ),
                        Form(
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          key: controller.profileFormKey,
                          child: Obx(
                            () => Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  StringResource.yourInfo,
                                  style: TextStyle(fontFamily: 'DMSans',fontSize: 14,fontWeight: FontWeight.w500,),
                                ),
                                 SizedBox(
                                  height:screenWidth<500? DimensionResource.marginSizeSmall: DimensionResource.marginSizeDefault,
                                ),
                                CommonTextField(
                                  label: StringResource.name,
                                  controller: controller.nameController.value,
                                  hintText: StringResource.enterName,
                                  keyboardType: TextInputType.name,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      controller.nameError.value =
                                          StringResource.emptyNameError;
                                      return "";
                                    }
                                    // else if(!value.isValidEmail()){
                                    //   controller.emailError.value ="Please enter valid email address";
                                    //   return "";
                                    // }
                                    else {
                                      controller.nameError.value = "";
                                      return null;
                                    }
                                  },
                                  errorText: controller.nameError.value,
                                ),

                                
                                CommonTextField(
                                  label: StringResource.email,
                                  readOnly:
                                      Get.find<AuthService>().user.value.email ==
                                                  null ||
                                              Get.find<AuthService>()
                                                      .user
                                                      .value
                                                      .email ==
                                                  ""
                                          ? false
                                          : true,
                                  controller: controller.emailController.value,
                                  hintText: StringResource.enterEmail,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      controller.emailError.value =
                                          StringResource.emptyEmailError;
                                      return "";
                                    } else if (!value.isValidEmail()) {
                                      controller.emailError.value =
                                          StringResource.validEmailError;
                                      return "";
                                    } else {
                                      controller.emailError.value = "";
                                      return null;
                                    }
                                  },
                                  errorText: controller.emailError.value,
                                  suffix: Container(
                                    margin: const EdgeInsets.only(left: 16.0), // Add margin as needed
                                    child: Padding(
                                      padding:  EdgeInsets.only(
                                        left: 22.0,
                                        top: screenWidth<500? 16.0:13,
                                        bottom: 16.0,
                                        right: 0.0,
                                      ),
                                      child: Image.asset(
                                        ImageResource.instance.editIcon,
                                        color: ColorResource.buttonTextColor, // Change this to your desired purple color
                                        height:11,
                                      ),
                                    ),
                                  ),
      
                                ),
                                CommonTextField(
                                  label: "Mobile",
                                  readOnly: controller
                                          .mobileController.value.text.isEmpty
                                      ? false
                                      : true,
                                  controller: controller.mobileController.value,
                                  hintText: StringResource.enterMobile,
                                  keyboardType: TextInputType.phone,
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      controller.mobileError.value =
                                          StringResource.emptyPhoneError;
                                      return "";
                                    } else if (!value.isValidNumber()) {
                                      controller.mobileError.value =
                                          StringResource.correctPhoneError;
                                      return "";
                                    } else {
                                      controller.mobileError.value = "";
                                      return null;
                                    }
                                  },
                                  errorText: controller.mobileError.value,
                                ),
                                CommonTextField(
                                  label: "dob",
                                  readOnly: true,
                                  onTap: () async {
                                    await showDatePicker(
                                            context: context,
                                            builder: (context, child) {
                                              return Theme(
                                                
                                                data: Theme.of(context).copyWith(
                                                  colorScheme:
                                                      const ColorScheme.light(
                                                    primary: ColorResource
                                                        .primaryColor, // header background color
                                                    onPrimary: Colors
                                                        .white, // header text color
                                                    onSurface: ColorResource
                                                        .secondaryColor, // body text color
                                                  ),
                                                  textButtonTheme:
                                                      TextButtonThemeData(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor: ColorResource
                                                          .primaryColor, // button text color
                                                    ),
                                                  ),
                                                ),
                                                child: child!,
                                              );
                                            },
                                            initialDate: DateTime(
                                                DateTime.now().year - 8, 01, 01),
                                            firstDate: DateTime(1960),
                                            lastDate: DateTime(
                                                DateTime.now().year - 8, 12, 31))
                                        .then((value) {
                                      if (value != null) {
                                        controller.dobController.value.text =
                                            DateFormat(
                                                    StringResource.dobDateFormat)
                                                .format(value);
                                        controller.selectedDoB.value = value;
                                      }
                                    });
                                  },
                                  controller: controller.dobController.value,
                                  hintText: StringResource.enterDob,
                                  keyboardType: TextInputType.phone,
                                  suffix: Container(
                                    margin: const EdgeInsets.only(left: 16.0), // Add margin as needed
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                        left: 14.0,
                                        top: 14.0,
                                        bottom: 14.0,
                                        right: 0.0,
                                      ),
                                      child: Image.asset(
                                        ImageResource.instance.dateIcon,
                                        color: ColorResource.borderColor,
                                        height: 11,
                                      ),
                                    ),
                                  ),
      
                                  inputFormatters: [
                                    FilteringTextInputFormatter.allow(
                                        RegExp("[0-9]")),
                                  ],
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      controller.dobError.value =
                                          StringResource.emptyDobError;
                                      return "";
                                    } else {
                                      controller.dobError.value = "";
                                      return null;
                                    }
                                  },
                                  errorText: controller.dobError.value,
                                ),
                              ],
                            ),
                          ),
                        ),
                   
                         SizedBox(
                          height:screenWidth<500? DimensionResource.marginSizeDefault:DimensionResource.marginSizeLarge,
                        ),
                        Text(
                          StringResource.choiceOfInterest,
                          style: StyleResource.instance.styleMedium(
                              fontSize:screenWidth<500? DimensionResource.fontSizeDefault:DimensionResource.fontSizeDoubleExtraLarge),
                        ),
                         SizedBox(
                          height:screenWidth<500? DimensionResource.marginSizeExtraSmall - 3:DimensionResource.marginSizeSmall-2,
                        ),
                        Text(
                          '(${StringResource.interestCanSelect})',
                          style: StyleResource.instance.styleLight(
                              fontSize:screenWidth<500? DimensionResource.fontSizeSmall - 1:DimensionResource.fontSizeLarge),
                        ),
                         SizedBox(
                          height:screenWidth<500? DimensionResource.marginSizeSmall:DimensionResource.marginSizeDefault,
                        ),
                        Obx(() {
                          return Wrap(
                              runSpacing: DimensionResource.marginSizeSmall,
                              spacing: DimensionResource.marginSizeSmall,
                              children: !controller.isTagLoading.value
                                  ? List.generate(
                                      controller.tagsData.value.data?.length ?? 0,
                                      (index) {
                                      category.Datum data = controller
                                          .tagsData.value.data!
                                          .elementAt(index);
                                      return Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          buildSelectedContainer(() {
                                            if (controller.selectedTags.any(
                                                (element) =>
                                                    element.id == data.id)) {
                                              controller.selectedTags.removeWhere(
                                                  (element) =>
                                                      element.id == data.id);
                                            } else {
                                              controller.selectedTags.add(data);
                                            }
                                          },
                                              controller.selectedTags.any(
                                                  (element) =>
                                                      element.id == data.id),
                                              data.title ?? ""),
                                        ],
                                      );
                                    })
                                  : List.generate(3, (index) {
                                      return Shimmer.fromColors(
                                        baseColor: Colors.grey[300]!,
                                        highlightColor: Colors.grey[100]!,
                                        enabled: true,
                                        child: Container(
                                          height: 40,
                                          width: 75,
                                          margin: EdgeInsets.only(
                                              right: index != 2
                                                  ? DimensionResource
                                                      .marginSizeSmall
                                                  : 0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                              border: Border.all(
                                                  color:
                                                      ColorResource.borderColor)),
                                        ),
                                      );
                                    }));
                        }),
                        const SizedBox(
                          height: DimensionResource.marginSizeLarge,
                        ),
                      
                        // ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: DimensionResource.marginSizeExtraLarge + 10,
                  ),
                ],
              ),
            ),
          ),
          Obx(() {
            return Visibility(
              visible: controller.isLogOutLoading.value,
              child: Container(
                  color: ColorResource.white.withOpacity(0.4),
                  child: const CommonCircularIndicator()),
            );
          })
        ],
      ),
    );
  }
}

Container imageContainer(String url,
    {double? height = 85,
    double? width = 90,
    double? radius = 12,
    BoxFit fit = BoxFit.cover,
    Widget? imageProvider,
    Color? borderColor = Colors.transparent,
    double? borderWidth = 0}) {
  return Container(
    height: height,
    width: width,
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius!),
        border: Border.all(color: borderColor!, width: borderWidth!)),
    child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: imageProvider ?? cachedNetworkImage(url, fit: fit)),
  );
}
