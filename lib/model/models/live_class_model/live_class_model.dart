import 'dart:convert';

LiveClassModel liveClassModelFromJson(String str) =>
    LiveClassModel.fromJson(json.decode(str));

String liveClassModelToJson(LiveClassModel data) => json.encode(data.toJson());

class LiveClassModel {
  LiveClassModel({
    this.status,
    this.data,
    this.message,
    this.serverTime,
    this.cardUi,
  });

  bool? status;
  Data? data;
  String? message;
  String? serverTime;
  CardUI? cardUi; // Added the CardUI field

  factory LiveClassModel.fromJson(Map<String, dynamic> json) => LiveClassModel(
        status: json["status"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
        message: json["message"],
        serverTime: json["server_time"],
        cardUi:
            json["card_ui"] == null ? null : CardUI.fromJson(json["card_ui"]),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
        "server_time": serverTime,
        "card_ui": cardUi?.toJson(), // Serialize card_ui
      };
}

class CardUI {
  CardUI({
    this.titleColor,
    this.cardBgColor,
    this.cardColor1,
    this.cardColor2,
    this.certificationTextColor,
    this.certificationBgColor,
    this.unlockButtonText,
    this.unlockButtonColor,
    this.unlockButtonTextColor,
    this.joinButtonText,
    this.joinButtonColor,
    this.joinButtonTextColor,
    this.registerButtonText,
    this.registerButtonColor,
    this.registerButtonTextColor,
    this.playButtonText,
    this.playButtonColor,
    this.playButtonTextColor,
    this.timerButtonColor,
    this.timerButtonTextColor,
    this.bottomChipBgColor,
    this.bottomChipTextColor,
    this.dateTimeChipBgColor,
    this.dateTimeChipTextColor,
  });

  String? titleColor;
  String? cardBgColor;
  String? cardColor1;
  String? cardColor2;
  String? certificationTextColor;
  String? certificationBgColor;
  String? unlockButtonText;
  String? unlockButtonColor;
  String? unlockButtonTextColor;
  String? joinButtonText;
  String? joinButtonColor;
  String? joinButtonTextColor;
  String? registerButtonText;
  String? registerButtonColor;
  String? registerButtonTextColor;
  String? playButtonText;
  String? playButtonColor;
  String? playButtonTextColor;
  String? timerButtonColor;
  String? timerButtonTextColor;
  String? bottomChipBgColor;
  String? bottomChipTextColor;
  String? dateTimeChipBgColor;
  String? dateTimeChipTextColor;

  factory CardUI.fromJson(Map<String, dynamic> json) => CardUI(
        titleColor: json["title_color"],
        cardBgColor: json["card_bg_color"],
        cardColor1: json["card_color_1"],
        cardColor2: json["card_color_2"],
        certificationTextColor: json["certification_text_color"],
        certificationBgColor: json["certification_bg_color"],
        unlockButtonText: json["unlock_button_text"],
        unlockButtonColor: json["unlock_button_color"],
        unlockButtonTextColor: json["unlock_button_text_color"],
        joinButtonText: json["join_button_text"],
        joinButtonColor: json["join_button_color"],
        joinButtonTextColor: json["join_button_text_color"],
        registerButtonText: json["register_button_text"],
        registerButtonColor: json["register_button_color"],
        registerButtonTextColor: json["register_button_text_color"],
        playButtonText: json["play_button_text"],
        playButtonColor: json["play_button_color"],
        playButtonTextColor: json["play_button_text_color"],
        timerButtonColor: json["timer_button_color"],
        timerButtonTextColor: json["timer_button_text_color"],
        bottomChipBgColor: json["bottom_chip_bg_color"],
        bottomChipTextColor: json["bottom_chip_text_color"],
        dateTimeChipBgColor: json["date_time_chip_bg_color"],
        dateTimeChipTextColor: json["date_time_chip_text_color"],
      );

  Map<String, dynamic> toJson() => {
        "title_color": titleColor,
        "card_bg_color": cardBgColor,
        "card_color_1": cardColor1,
        "card_color_2": cardColor2,
        "certification_text_color": certificationTextColor,
        "certification_bg_color": certificationBgColor,
        "unlock_button_text": unlockButtonText,
        "unlock_button_color": unlockButtonColor,
        "unlock_button_text_color": unlockButtonTextColor,
        "join_button_text": joinButtonText,
        "join_button_color": joinButtonColor,
        "join_button_text_color": joinButtonTextColor,
        "register_button_text": registerButtonText,
        "register_button_color": registerButtonColor,
        "register_button_text_color": registerButtonTextColor,
        "play_button_text": playButtonText,
        "play_button_color": playButtonColor,
        "play_button_text_color": playButtonTextColor,
        "timer_button_color": timerButtonColor,
        "timer_button_text_color": timerButtonTextColor,
        "bottom_chip_bg_color": bottomChipBgColor,
        "bottom_chip_text_color": bottomChipTextColor,
        "date_time_chip_bg_color": dateTimeChipBgColor,
        "date_time_chip_text_color": dateTimeChipTextColor,
      };
}

class Data {
  Data({
    this.data,
    this.pagination,
    this.userNamePrompt,
    this.expiredUserPopup, // Add the new field here
  });

  List<Datum>? data;
  Pagination? pagination;
  UserNamePrompt? userNamePrompt;
  ExpiredUserPopup? expiredUserPopup; // New field

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null
            ? null
            : Pagination.fromJson(json["pagination"]),
        userNamePrompt: json["user_name_prompt_data"] == null
            ? null
            : UserNamePrompt.fromJson(json["user_name_prompt_data"]),
        expiredUserPopup: json["expired_user_popup"] == null
            ? null
            : ExpiredUserPopup.fromJson(
                json["expired_user_popup"]), // Deserialize the new field
      );

  Map<String, dynamic> toJson() => {
        "data": data == null
            ? []
            : List<dynamic>.from(data!.map((x) => x.toJson())),
        "pagination": pagination?.toJson(),
        "user_name_prompt_data": userNamePrompt?.toJson(),
        "expired_user_popup":
            expiredUserPopup?.toJson(), // Serialize the new field
      };
}

class Datum {
  Datum({
    this.id,
    this.categoryId,
    this.levelId,
    this.languageId,
    this.userId,
    this.index,
    this.title,
    this.classPoints,
    this.isTrial,
    this.description,
    this.startTime,
    this.endDate,
    this.duration,
    this.lastWatchedSecond,
    this.meetingLink,
    this.image,
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
    this.recordingUrl,
    this.level,
    this.createdAt,
    this.isPurchased,
    this.isRegister,
    this.teacher, // Added teacher field
  });

  int? id;
  int? categoryId;
  int? levelId;
  int? lastWatchedSecond;
  int? languageId;
  int? userId;
  int? index;
  String? title;
  String? recordingUrl;
  int? isTrial;
  String? description;
  DateTime? startTime;
  DateTime? endDate;
  int? duration;
  String? meetingLink;
  String? image;
  String? schedule;
  String? classPoints;
  String? totalClasses;
  int? rating;
  int? totalReviews;
  int? totalComments;
  int? isHome;
  int? isFree;
  int? isActive;
  Category? category;
  Language? language;
  Level? level;
  dynamic createdAt;
  int? isPurchased;
  int? isRegister;
  Teacher? teacher; // Added teacher field

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        categoryId: json["category_id"],
        levelId: json["level_id"],
        languageId: json["language_id"],
        userId: json["user_id"],
        index: json["index"],
        lastWatchedSecond: json["last_watched_second"],
        image: json["preview"],
        classPoints: json["class_points"],
        title: json["title"],
        recordingUrl: json["recording_url"],
        isTrial: json["is_trial"],
        isRegister: json["is_register"],
        isPurchased: json["is_purchased"],
        description: json["description"],
        startTime: json["start_datetime"] == null
            ? null
            : DateTime.tryParse(json["start_datetime"]),
        endDate: json["end_datetime"] == null
            ? null
            : DateTime.tryParse(json["end_datetime"]),
        duration: json["duration"],
        meetingLink: json["meeting_link"],
        schedule: json["schedule"],
        totalClasses: json["total_classes"],
        rating: json["rating"],
        totalReviews: json["total_reviews"],
        totalComments: json["total_comments"],
        isHome: json["is_home"],
        isFree: json["is_free"],
        isActive: json["is_active"],
        category: json["category"] == null
            ? null
            : Category.fromJson(json["category"]),
        language: json["language"] == null
            ? null
            : Language.fromJson(json["language"]),
        level: json["level"] == null ? null : Level.fromJson(json["level"]),
        createdAt: json["created_at"],
        teacher: json["teachers"] == null
            ? null
            : Teacher.fromJson(json["teachers"]), // Parse teacher
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "level_id": levelId,
        "language_id": languageId,
        'last_watched_second': lastWatchedSecond,
        "user_id": userId,
        "index": index,
        "title": title,
        "recording_url": recordingUrl,
        "is_trial": isTrial,
        "preview": image,
        "class_points": classPoints,
        "description": description,
        "start_datetime": startTime?.toIso8601String(),
        "end_datetime": endDate?.toIso8601String(),
        "duration": duration,
        "meeting_link": meetingLink,
        "schedule": schedule,
        "total_classes": totalClasses,
        "rating": rating,
        "total_reviews": totalReviews,
        "total_comments": totalComments,
        "is_home": isHome,
        "is_free": isFree,
        "is_active": isActive,
        "category": category?.toJson(),
        "language": language?.toJson(),
        "level": level?.toJson(),
        "created_at": createdAt,
        "is_register": isRegister,
        "is_purchased": isPurchased,
        "teachers": teacher?.toJson(), // Serialize teacher
      };
}

class ExpiredUserPopup {
  ExpiredUserPopup({
    this.imageUrl,
    this.buttonTitle,
    this.title,
    this.subtitle,
  });

  String? imageUrl;
  String? buttonTitle;
  String? title;
  String? subtitle;

  factory ExpiredUserPopup.fromJson(Map<String, dynamic> json) =>
      ExpiredUserPopup(
        imageUrl: json["image_url"],
        buttonTitle: json["button_title"],
        title: json["title"],
        subtitle: json["subtitle"],
      );

  Map<String, dynamic> toJson() => {
        "image_url": imageUrl,
        "button_title": buttonTitle,
        "title": title,
        "subtitle": subtitle,
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
    this.index,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? languageName;
  int? index;
  int? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
        id: json["id"],
        languageName: json["language_name"],
        index: json["index"],
        isActive: json["is_active"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "language_name": languageName,
        "index": index,
        "is_active": isActive,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Level {
  Level({
    this.id,
    this.level,
    this.image,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? level;
  String? image;
  int? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Level.fromJson(Map<String, dynamic> json) => Level(
        id: json["id"],
        level: json["level"],
        image: json["image"],
        isActive: json["is_active"],
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? null
            : DateTime.tryParse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.tryParse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "level": level,
        "image": image,
        "is_active": isActive,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class Pagination {
  Pagination({
    this.total,
    this.count,
    this.perPage,
    this.currentPage,
    this.lastPage,
  });

  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? lastPage;

  factory Pagination.fromJson(Map<String, dynamic> json) => Pagination(
        total: json["total"],
        count: json["count"],
        perPage: json["per_page"],
        currentPage: json["current_page"],
        lastPage: json["last_page"],
      );

  Map<String, dynamic> toJson() => {
        "total": total,
        "count": count,
        "per_page": perPage,
        "current_page": currentPage,
        "last_page": lastPage,
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
