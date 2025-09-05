import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/services/auth_service.dart';

class PopUpModel {
  PopUpModel({
    required this.heading,
    required this.isTrial,
    required this.isPro,
    required this.title1,
    required this.sub_title1,
    required this.image1,
    required this.title2,
    required this.sub_title2,
    required this.image2,
    required this.description,
    required this.days,
    required this.title_color_all,
    required this.title_color_text,
    required this.heading_color,
    required this.description_color,
  });
  final String heading;
  final int isTrial;
  final int isPro;
  final String description;
  final String title1;
  final String sub_title1;
  final String image1;
  final String title2;
  final String sub_title2;
  final String image2;
  final String heading_color;
  final String title_color_all;
  final int days;
  final String title_color_text;
  final String description_color;

  factory PopUpModel.fromJson(Map<String, dynamic> json) => PopUpModel(
        isTrial: Get.find<AuthService>().isGuestUser.value
            ? 0
            : json["data"][0]["user"]["is_trial"] ?? 0,
        isPro: Get.find<AuthService>().isGuestUser.value
            ? 0
            : json["data"][0]["user"]["is_pro"] ?? 0,
        heading: json!['data'][0]['title'] ?? "",
        description: json['data'][0]['description'] ?? "",
        title1: json!['data'][0]['title_one']['title_one'] ?? "",
        sub_title1: json['data'][0]['title_one']['title_text_one'] ?? "",
        title2: json['data'][0]['title_two']['title_two'] ?? "",
        sub_title2: json['data'][0]['title_two']['title_text_two'] ?? "",
        image2: json['data'][0]['title_two']['image_two'] ?? "",
        image1: json['data'][0]['title_one']['image_one'] ?? "",
        description_color: json['data'][0]['description_color'] ?? "",
        title_color_all: json['data'][0]['title_color_all'] ?? "",
        days: json['data'][0]['days'] ?? "",
        title_color_text: json['data'][0]['title_color_text'] ?? "",
        heading_color: json['data'][0]['title_color'] ?? "",
      );

  // Map<String, dynamic> toJson() => {
  //       "status": status,
  //       "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
  //       "message": message,
  //     };
}
