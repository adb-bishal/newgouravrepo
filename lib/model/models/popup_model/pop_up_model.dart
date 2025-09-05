import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';

class PopUpModel {
  final String heading;
  final int isTrial;
  final int isPro;
  final String description;
  final String title1;
  final String subTitle1;
  final String image1;
  final String title2;
  final String subTitle2;
  final String image2;
  final String title3;
  final String subTitle3;
  final String image3;
  final String title4;
  final String subTitle4;
  final String image4;
  final String headingColor;
  final String titleColorAll;
  final int days;
  final String titleColorText;
  final String descriptionColor;

  // Maps for storing prompt-related and background data
  final Map<String, String> trialPromptData;
  final Map<String, String> backgroundData;

  // Constructor
  PopUpModel({
    required this.heading,
    required this.isTrial,
    required this.isPro,
    required this.description,
    required this.title1,
    required this.subTitle1,
    required this.image1,
    required this.title2,
    required this.subTitle2,
    required this.image2,
    required this.title3,
    required this.subTitle3,
    required this.image3,
    required this.title4,
    required this.subTitle4,
    required this.image4,
    required this.headingColor,
    required this.titleColorAll,
    required this.days,
    required this.titleColorText,
    required this.descriptionColor,
    required this.trialPromptData,
    required this.backgroundData,
  });

  // Factory constructor to create an instance from JSON
  factory PopUpModel.fromJson(Map<String, dynamic> json) {
    final trialPrompt = json['data']?[0]?['trial_activated_user_name_prompt'] ?? {};
    final background = json['data']?[0]?['background'] ?? {};

    return PopUpModel(
      heading: json['data'][0]['title'] ?? '',
      isTrial: Get.find<AuthService>().isGuestUser.value ? 0 : json["data"][0]["user"]["is_trial"] ?? 0,
      isPro: Get.find<AuthService>().isGuestUser.value ? 0 : json["data"][0]["user"]["is_pro"] ?? 0,
      description: json['data'][0]['description'] ?? '',
      title1: json['data'][0]['title_one']['title_one'] ?? '',
      subTitle1: json['data'][0]['title_one']['title_text_one'] ?? '',
      image1: json['data'][0]['title_one']['image_one'] ?? '',
      title2: json['data'][0]['title_two']['title_two'] ?? '',
      subTitle2: json['data'][0]['title_two']['title_text_two'] ?? '',
      image2: json['data'][0]['title_two']['image_two'] ?? '',
      title3: json['data'][0]['title_three']['title_three'] ?? '',
      subTitle3: json['data'][0]['title_three']['title_text_three'] ?? '',
      image3: json['data'][0]['title_three']['image_three'] ?? '',
      title4: json['data'][0]['title_four']['title_four'] ?? '',
      subTitle4: json['data'][0]['title_four']['title_text_four'] ?? '',
      image4: json['data'][0]['title_four']['image_four'] ?? '',
      headingColor: json['data'][0]['title_color'] ?? '#000000',
      titleColorAll: json['data'][0]['title_color_all'] ?? '#000000',
      days: json['data'][0]['days'] ?? 0,
      titleColorText: json['data'][0]['title_color_text'] ?? '#000000',
      descriptionColor: json['data'][0]['description_color'] ?? '#000000',

      // Initialize prompt data as a Map
      trialPromptData: {
        'title': trialPrompt['title'] ?? '',
        'titleColor': trialPrompt['title_color'] ?? '#000000',
        'description': trialPrompt['description'] ?? '',
        'descriptionColor': trialPrompt['description_color'] ?? '#000000',
        'confirmButtonText': trialPrompt['confirm_button'] ?? 'Confirm',
        'confirmButtonColor': trialPrompt['confirm_button_color'] ?? '#000000',
        'confirmButtonTextColor': trialPrompt['confirm_btn_text_color'] ?? '#ffffff',
        'userNameInputPlaceholder': trialPrompt['user_name_input_placeholder'] ?? '',
        'image_url': trialPrompt['image_url'] ?? '', // New field for image URL
      },

      // Initialize background data as a Map
      backgroundData: {
        'bgType': background['type'] ?? 'color',
        'bgColor': background['bg_color'] ?? '#FFFFFF',
        'bgImage': background['bg_image'] ?? '',
      },
    );
  }

  // Convert PopUpModel instance to JSON map
  Map<String, dynamic> toJson() => {
    'heading': heading,
    'isTrial': isTrial,
    'isPro': isPro,
    'description': description,
    'title1': title1,
    'subTitle1': subTitle1,
    'image1': image1,
    'title2': title2,
    'subTitle2': subTitle2,
    'image2': image2,
    'title3': title3,
    'subTitle3': subTitle3,
    'image3': image3,
    'title4': title4,
    'subTitle4': subTitle4,
    'image4': image4,
    'headingColor': headingColor,
    'titleColorAll': titleColorAll,
    'days': days,
    'titleColorText': titleColorText,
    'descriptionColor': descriptionColor,
    'trialPromptData': trialPromptData,
    'backgroundData': backgroundData,
  };
}






//
// class PopUpModel {
//   PopUpModel({
//     required this.heading,
//     required this.isTrial,
//     required this.isPro,
//     required this.title1,
//     required this.subTitle1,
//     required this.image1,
//     required this.title2,
//     required this.subTitle2,
//     required this.image2,
//     required this.title3,
//     required this.subTitle3,
//     required this.image3,
//     required this.title4,
//     required this.subTitle4,
//     required this.image4,
//     required this.description,
//     required this.days,
//     required this.titleColorAll,
//     required this.titleColorText,
//     required this.headingColor,
//     required this.descriptionColor,
//     required this.trialPromptData, // Map for all prompt-related fields
//     required this.backgroundData,
//   });
//
//   final String heading;
//   final int isTrial;
//   final int isPro;
//   final String description;
//   final String title1;
//   final String subTitle1;
//   final String image1;
//   final String title2;
//   final String subTitle2;
//   final String image2;
//   final String title3;
//   final String subTitle3;
//   final String image3;
//   final String title4;
//   final String subTitle4;
//   final String image4;
//   final String headingColor;
//   final String titleColorAll;
//   final int days;
//   final String titleColorText;
//   final String descriptionColor;
//
//   // Map to store all prompt-related data
//   final Map<String, String> trialPromptData;
//   final Map<String, String> backgroundData;
//
//   // Updated factory constructor to initialize fields including prompt data as a map
//   factory PopUpModel.fromJson(Map<String, dynamic> json) {
//     final trialPrompt =
//         json['data']?[0]?['trial_activated_user_name_prompt'] ?? {};
//     final background = json['data']?[0]?['background'] ?? {};
//
//     return PopUpModel(
//       isTrial: Get.find<AuthService>().isGuestUser.value
//           ? 0
//           : json["data"][0]["user"]["is_trial"] ?? 0,
//       isPro: Get.find<AuthService>().isGuestUser.value
//           ? 0
//           : json["data"][0]["user"]["is_pro"] ?? 0,
//       heading: json['data'][0]['title'] ?? "",
//       description: json['data'][0]['description'] ?? "",
//
//       title1: json['data'][0]['title_one']['title_one'] ?? "",
//
//       subTitle1: json['data'][0]['title_one']['title_text_one'] ?? "",
//
//       title2: json['data'][0]['title_two']['title_two'] ?? "",
//
//       subTitle2: json['data'][0]['title_two']['title_text_two'] ?? "",
//
//       title4: json['data'][0]['title_four']['title_four'] ?? "",
//
//       subTitle4: json['data'][0]['title_four']['title_text_four'] ?? "",
//
//       title3: json['data'][0]['title_three']['title_three'] ?? "",
//
//       subTitle3: json['data'][0]['title_three']['title_text_three'] ?? "",
//
//       image2: json['data'][0]['title_two']['image_two'] ?? "",
//
//       image1: json['data'][0]['title_one']['image_one'] ?? "",
//
//       image3: json['data'][0]['title_three']['image_three'] ?? "",
//
//       image4: json['data'][0]['title_four']['image_four'] ?? "",
//
//       descriptionColor: json['data'][0]['description_color'] ?? "",
//       titleColorAll: json['data'][0]['title_color_all'] ?? "",
//       days: json['data'][0]['days'] ?? 0,
//       titleColorText: json['data'][0]['title_color_text'] ?? "",
//       headingColor: json['data'][0]['title_color'] ?? "",
//
//       // Initialize prompt data as a Map
//       trialPromptData: {
//         'title': trialPrompt['title'] ?? '',
//         'titleColor': trialPrompt['title_color'] ?? '#000000',
//         'description': trialPrompt['description'] ?? '',
//         'descriptionColor': trialPrompt['description_color'] ?? '#000000',
//         'confirmButtonText': trialPrompt['confirm_button'] ?? 'Confirm',
//         'confirmButtonColor': trialPrompt['confirm_button_color'] ?? '#000000',
//         'confirmButtonTextColor':
//             trialPrompt['confirm_btn_text_color'] ?? '#ffffff',
//         'userNameInputPlaceholder':
//             trialPrompt['user_name_input_placeholder'] ?? '',
//         'image_url': trialPrompt['image_url'] ?? '', // New field for image URL
//       },
//
//       backgroundData: {
//         'bgType': background['type'] ?? 'color',
//         'bgColor': background['bg_color'] ?? '#FFFFFF',
//         'bgImage': background['bg_image'] ?? '',
//       },
//     );
//
//     // Map<String, dynamic> toJson() => {
//     //       "status": status,
//     //       "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
//     //       "message": message,
//     //     };
//   }
// }
