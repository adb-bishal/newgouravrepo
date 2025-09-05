// To parse this JSON data, do
//
//     final liveClassDetailModel = liveClassDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

import '../course_models/single_video_detail_model.dart';

LiveClassDetailModel liveClassDetailModelFromJson(String str) =>
    LiveClassDetailModel.fromJson(json.decode(str));

String liveClassDetailModelToJson(LiveClassDetailModel data) =>
    json.encode(data.toJson());

class LiveClassDetailModel {
  LiveClassDetailModel({this.status, this.data, this.message, this.serverTime});

  bool? status;
  Data? data;
  String? message;
  String? serverTime;

  factory LiveClassDetailModel.fromJson(Map<String, dynamic> json) =>
      LiveClassDetailModel(
        status: json["status"],
        data: json["data"] == null ? Data() : Data.fromJson(json["data"]),
        message: json["message"],
        serverTime: json["server_time"],
      );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
    "server_time": serverTime,
  };
}

class Data {
  Data({
    this.id,
    this.categoryId,
    this.levelId,
    this.languageId,
    this.userId,
    this.batchId,
    this.batchStartDate,
    this.index,
    this.title,
    this.description,
    this.startTime,
    this.endDate,
    this.duration,
    this.meetingLink,
    this.hostLink,
    this.moderatorLink,
    this.participantLink,
    this.image,
    this.preview,
    this.thumbnail,
    this.schedule,
    this.totalClasses,
    this.rating,
    this.totalReviews,
    this.totalComments,
    this.isHome,
    this.isFree,
    this.isActive,
    this.category,
    this.language,
    this.level,
    this.createdAt,
    this.shortDescription,
    this.isRegister,
    this.matchCriteria,
    this.fileUrl,
    this.price,
    this.isPurchased,
    this.isTrial, // Existing field
    this.expiredUserPopup, // New field
    this.userNamePrompt,
    this.teacher,
    this.ui_data,
  });

  int? id;
  int? categoryId;
  int? levelId;
  int? languageId;
  int? userId;
  int? batchId;
  int? batchStartDate;
  int? index;
  int? isRegister;
  String? title;
  String? shortDescription;
  String? description;
  DateTime? startTime;
  DateTime? endDate;
  int? duration;
  String? meetingLink;
  dynamic hostLink;
  dynamic moderatorLink;
  RxString? participantLink;
  String? fileUrl;
  String? image;
  String? preview;
  String? thumbnail;
  String? schedule;
  String? totalClasses;
  double? rating;
  double? price;
  int? totalReviews;
  int? totalComments;
  int? isHome;
  int? isFree;
  int? isActive;
  int? isTrial; // Existing field
  int? isPurchased;
  Category? category;
  Language? language;
  Level? level;
  MatchCriteria? matchCriteria;
  dynamic createdAt;
  ExpiredUserPopup? expiredUserPopup; // New field
  UserNamePrompt? userNamePrompt;
  Teacher? teacher;
  UiData? ui_data; // Added teacher field

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    categoryId: json["category_id"],
    levelId: json["level_id"],
    languageId: json["language_id"],
    userId: json["user_id"],
    batchId: json['batch_id'],
    batchStartDate: json['batch_start_date'],
    index: json["index"],
    isPurchased: json["is_purchased"],
    title: json["title"],
    fileUrl: json["recording_url"],
    description: json["description"],
    shortDescription: json["short_description"],
    matchCriteria: json["match_criteria"] == null
        ? MatchCriteria()
        : MatchCriteria.fromJson(json["match_criteria"]),
    startTime: json["start_datetime"] == null
        ? DateTime(2024)
        : DateTime.parse(json["start_datetime"]),
    endDate: json["end_datetime"] == null
        ? DateTime(2024)
        : DateTime.parse(json["end_datetime"]),
    duration: json["duration"],
    meetingLink: json["meeting_link"],
    hostLink: json["host_link"],
    moderatorLink: json["moderator_link"],
    participantLink: json["participant_link"] == null
        ? "".obs
        : json["participant_link"].toString().obs,
    image: json["image"],
    price: json["price"] == null
        ? 0.0
        : double.parse(json["price"].toString()),
    preview: json["preview"],
    thumbnail: json["thumbnail"],
    schedule: json["schedule"],
    totalClasses: json["total_classes"],
    rating: json["rating"] == null
        ? 0.0
        : double.parse(json['rating'].toString()),
    totalReviews: json["total_reviews"],
    totalComments: json["total_comments"],
    isHome: json["is_home"],
    isRegister: json["is_register"],
    isFree: json["is_free"],
    isTrial: json["is_trial"],
    isActive: json["is_active"],
    category: json["category"] == null
        ? Category()
        : Category.fromJson(json["category"]),
    language: json["language"] == null
        ? Language()
        : Language.fromJson(json["language"]),
    level: json["level"] == null ? Level() : Level.fromJson(json["level"]),
    createdAt: json["created_at"],
    expiredUserPopup: json["expired_user_popup"] == null
        ? null
        : ExpiredUserPopup.fromJson(json["expired_user_popup"]),
    teacher: json["teachers"] == null
        ? null
        : Teacher.fromJson(json["teachers"]),
    ui_data:
    json["ui_data"] == null ? null : UiData.fromJson(json["ui_data"]),
    // Parse teacher
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "level_id": levelId,
    "recording_url": fileUrl,
    "language_id": languageId,
    "user_id": userId,
    'batch_id': batchId,
    'batch_start_date': batchStartDate,
    "index": index,
    "title": title,
    "is_purchased": isPurchased,
    "description": description,
    "short_description": shortDescription,
    "start_time": startTime?.toIso8601String(),
    "end_time": endDate?.toIso8601String(),
    "duration": duration,
    "meeting_link": meetingLink,
    "host_link": hostLink,
    "moderator_link": moderatorLink,
    "participant_link": participantLink?.value,
    "image": image,
    "price": price,
    "preview": preview,
    "thumbnail": thumbnail,
    "schedule": schedule,
    "total_classes": totalClasses,
    "rating": rating,
    "total_reviews": totalReviews,
    "total_comments": totalComments,
    "is_trial": isTrial,
    "is_home": isHome,
    "is_free": isFree,
    "is_register": isRegister,
    "is_active": isActive,
    "category": category?.toJson(),
    "match_criteria": matchCriteria?.toJson(),
    "language": language?.toJson(),
    "level": level?.toJson(),
    "created_at": createdAt,
    "expired_user_popup": expiredUserPopup?.toJson(),
    "user_name_prompt_data": userNamePrompt?.toJson(),
    "teachers": teacher?.toJson(),
    "ui_data": ui_data, // Serialize teacher
  };
}

class Teacher {
  Teacher({
    this.userId,
    this.name,
    this.totalExperience,
    this.profileImage,
    this.certificationText,
    this.expertise,
    this.categoryId,
    this.tradingStyle,
    this.rating,
    this.studentsLearn,
    this.teachingHours,
    this.languageId,
    this.bio,
  });

  int? userId;
  String? name;
  int? totalExperience;
  String? profileImage;
  String? certificationText;
  String? expertise;
  int? categoryId;
  String? tradingStyle;
  int? rating;
  int? studentsLearn;
  int? teachingHours;
  int? languageId;
  String? bio;

  factory Teacher.fromJson(Map<String, dynamic> json) => Teacher(
    userId: json["user_id"],
    name: json["name"],
    totalExperience: json["total_experience"],
    profileImage: json["profile_image"],
    certificationText: json["certification_text"],
    expertise: json["expertise"],
    categoryId: json["category_id"],
    tradingStyle: json["trading_style"],
    rating: json["rating"],
    studentsLearn: json["students_learn"],
    teachingHours: json["teaching_hours"],
    languageId: json["language_id"],
    bio: json["bio"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "name": name,
    "total_experience": totalExperience,
    "profile_image": profileImage,
    "certification_text": certificationText,
    "expertise": expertise,
    "category_id": categoryId,
    "trading_style": tradingStyle,
    "rating": rating,
    "students_learn": studentsLearn,
    "teaching_hours": teachingHours,
    "language_id": languageId,
    "bio": bio,
  };
}

class UiData {
  UiData({this.tutor_detail_title});

  String? tutor_detail_title;

  factory UiData.fromJson(Map<String, dynamic> json) => UiData(
    tutor_detail_title: json["tutor_detail_title"],
  );

  Map<String, dynamic> toJson() => {
    "tutor_detail_title": tutor_detail_title,
  };
}

class ExpiredUserPopup {
  ExpiredUserPopup({
    this.title,
    this.subtitle,
    this.buttonTitle,
    this.imageUrl,
  });

  String? title; // New field
  String? subtitle; // New field
  String? buttonTitle;
  String? imageUrl;

  factory ExpiredUserPopup.fromJson(Map<String, dynamic> json) =>
      ExpiredUserPopup(
        title: json["title"], // Parsing new field
        subtitle: json["subtitle"], // Parsing new field
        buttonTitle: json["button_title"],
        imageUrl: json["image_url"],
      );

  Map<String, dynamic> toJson() => {
    "title": title, // Serializing new field
    "subtitle": subtitle, // Serializing new field
    "button_title": buttonTitle,
    "image_url": imageUrl,
  };
}

class Category {
  Category({
    this.id,
    this.title,
  });

  int? id;
  String? title;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

class Language {
  Language({
    this.id,
    this.languageName,
  });

  int? id;
  String? languageName;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"],
    languageName: json["language_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language_name": languageName,
  };
}

class Level {
  Level({
    this.id,
    this.level,
  });

  int? id;
  String? level;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
    id: json["id"],
    level: json["level"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "level": level,
  };
}

class UserNamePrompt {
  UserNamePrompt({
    required this.promptTitle,
    required this.promptTitleColor,
    required this.promptDescription,
    required this.promptDescriptionColor,
    required this.promptInputPlaceholder,
    required this.promptConfirmButton,
    required this.promptConfirmButtonColor,
    required this.promptConfirmBtnTextColor,
    required this.promptImageUrl,
    required this.promptImageSize,
  });

  final String promptTitle;
  final String promptTitleColor;
  final String promptDescription;
  final String promptDescriptionColor;
  final String promptInputPlaceholder;
  final String promptConfirmButton;
  final String promptConfirmButtonColor;
  final String promptConfirmBtnTextColor;
  final String promptImageUrl;
  final int promptImageSize;

  factory UserNamePrompt.fromJson(Map<String, dynamic> json) => UserNamePrompt(
    promptTitle: json["title"] ?? "",
    promptTitleColor: json["title_color"] ?? "",
    promptDescription: json["description"] ?? "",
    promptDescriptionColor: json["description_color"] ?? "",
    promptInputPlaceholder: json["user_name_input_placeholder"] ?? "",
    promptConfirmButton: json["confirm_button"] ?? "",
    promptConfirmButtonColor: json["confirm_button_color"] ?? "",
    promptConfirmBtnTextColor: json["confirm_btn_text_color"] ?? "",
    promptImageUrl: json["image_url"] ?? "",
    promptImageSize: json["image_size"] ?? 0,
  );

  Map<String, dynamic> toJson() => {
    "title": promptTitle,
    "title_color": promptTitleColor,
    "description": promptDescription,
    "description_color": promptDescriptionColor,
    "user_name_input_placeholder": promptInputPlaceholder,
    "confirm_button": promptConfirmButton,
    "confirm_button_color": promptConfirmButtonColor,
    "confirm_btn_text_color": promptConfirmBtnTextColor,
    "image_url": promptImageUrl,
    "image_size": promptImageSize,
  };
}
