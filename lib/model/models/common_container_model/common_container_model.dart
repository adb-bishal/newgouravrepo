import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/utils/color_resource.dart';

import '../course_models/blog_detail_model.dart';

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

class CommonDatum {
  CommonDatum({
    this.id,
    this.categoryId,
    this.levelId,
    this.languageId,
    this.language,
    this.teacher,
    this.providerId,
    this.tagId,
    this.title,
    this.description,
    this.fileUrl,
    this.thumbnail,
    this.batchId,
    this.batchStartDate,
    this.rating,
    this.isFree,
    this.isTrial,
    this.isLive,
    this.isDoubt,
    this.isWorkshop,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.videoTime,
    this.typeId,
    this.quizId,
    this.courseTitle,
    this.thumbnails,
    this.image,
    this.classPoints,
    this.preview,
    this.themeColor,
    this.buttonColor,
    this.avgRating,
    this.totalRating,
    this.totalComment,
    this.teaserUrl,
    this.quizzLink,
    this.isQuiz,
    this.category,
    this.courseDetailCount,
    this.isWishlist,
    this.startTime,
    this.model,
    this.duration,
    this.isPurchased,
    this.isRegister,
    this.isLoading,
    this.isvalidbool,
    this.endTime,
    this.level, // Added level field
  });

  int? id;
  int? categoryId;
  int? levelId;
  int? languageId;
  Language? language;
  Teacher? teacher;
  int? providerId;
  int? tagId;
  Category? category;
  String? title;
  String? description;
  String? fileUrl;
  String? thumbnail;
  int? batchId;
  int? batchStartDate;
  int? rating;
  int? isFree;
  int? isTrial;
  int? isLive;
  int? isDoubt;
  int? isWorkshop;
  int? isActive;
  int? isPurchased;
  int? isRegister;
  int? duration;
  dynamic deletedAt;
  DateTime? endTime;
  DateTime? startTime;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? videoTime;
  int? typeId;
  int? quizId;
  int? courseDetailCount;
  String? courseTitle;
  String? thumbnails;
  String? image;
  String? classPoints;
  String? preview;
  Color? themeColor;
  Color? buttonColor;
  double? avgRating;
  int? totalRating;
  String? totalComment;
  String? teaserUrl;
  dynamic quizzLink;
  int? isQuiz;
  RxInt? isWishlist;
  Model? model;
  bool? isLoading;
  bool? isvalidbool;
  Level? level; // New field

  factory CommonDatum.fromJson(Map<String, dynamic> json) {
    return CommonDatum(
      id: json["id"],
      categoryId: json["category_id"],
      levelId: json["level_id"],
      languageId: json["language_id"],
      language: json["language"] == null
          ? Language()
          : Language.fromJson(json["language"]),
      teacher: json["teachers"] == null
          ? Teacher()
          : Teacher.fromJson(json["teachers"]),
      providerId: json["provider_id"],
      tagId: json["tag_id"],
      title: json["title"],
      description: json["description"],
      fileUrl: json["recording_url"],
      duration: json["duration"],
      thumbnail: json["thumbnail"],
      batchId: json['batch_id'],
      batchStartDate: json['batch_start_date'],
      rating: json["rating"],
      isFree: json["is_free"],
      isTrial: json["is_trial"],
      isvalidbool: json["is_valid_bool"],
      isLive: json['is_live'],
      isDoubt: json['is_doubt'],
      isWorkshop: json['is_workshop'],
      isRegister: json["is_register"],
      isPurchased: json["is_purchased"],
      isActive: json["is_active"],
      deletedAt: json["deleted_at"],
      startTime: json["start_datetime"] == null
          ? DateTime(1999)
          : DateTime.parse(json["start_datetime"]),
      endTime: json["end_datetime"] == null
          ? null
          : DateTime.tryParse(json["end_datetime"]),
      createdAt: json["created_at"] == null
          ? DateTime(1999)
          : DateTime.parse(json["created_at"]),
      updatedAt: json["updated_at"] == null
          ? DateTime(1999)
          : DateTime.parse(json["updated_at"]),
      videoTime: json["video_time"],
      typeId: json["type_id"],
      quizId: json["quiz_id"],
      courseTitle: json["course_title"],
      courseDetailCount: json["course_detail_count"],
      thumbnails: json["thumbnails"],
      image: json["image"],
      classPoints: json["class_points"].toString(),
      category: json["category"] == null
          ? Category()
          : Category.fromJson(json["category"]),
      model: json["model"] == null ? Model() : Model.fromJson(json["model"]),
      preview: json["preview"],
      themeColor: json["theme_color"] == null
          ? Colors.transparent
          : json["theme_color"].runtimeType == Color
          ? json["theme_color"]
          : ColorResource.parseHex(json["theme_color"]),
      buttonColor: json["button_color"] == null
          ? Colors.transparent
          : json["button_color"].runtimeType == Color
          ? json["button_color"]
          : ColorResource.parseHex(json["button_color"]),
      avgRating: json["avg_rating"] == null
          ? 0.0
          : double.parse(json["avg_rating"].toString()),
      totalRating: json["total_rating"],
      totalComment: json["total_comment"],
      teaserUrl: json["teaser_url"],
      quizzLink: json["quizz_link"],
      isQuiz: json["is_quiz"],
      isLoading: json['isLoading'] as bool? ?? false,
      isWishlist: json["is_wishlist"] == null
          ? 0.obs
          : int.parse(json["is_wishlist"].toString()).obs,
      level: json["level"] == null
          ? null
          : Level.fromJson(json["level"]), // Parse level
    );
  }

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "level_id": levelId,
    "language_id": languageId,
    "language": language?.toJson(),
    "teachers": teacher?.toJson(),
    "duration": duration,
    "provider_id": providerId,
    "tag_id": tagId,
    "title": title,
    "course_detail_count": courseDetailCount,
    "description": description,
    "recording_url": fileUrl,
    "thumbnail": thumbnail,
    'batch_id': batchId,
    'batch_start_date': batchStartDate,
    "rating": rating,
    "category": category?.toJson(),
    "model": model?.toJson(),
    "is_free": isFree,
    "is_trial": isTrial,
    'is_live': isLive,
    'is_doubt': isDoubt,
    'is_workshop': isWorkshop,
    "is_active": isActive,
    "deleted_at": deletedAt,
    "start_datetime": startTime?.toIso8601String(),
    "end_datetime": endTime?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "video_time": videoTime,
    "type_id": typeId,
    "quiz_id": quizId,
    "course_title": courseTitle,
    "thumbnails": thumbnails,
    "image": image,
    "class_points": classPoints,
    "preview": preview,
    "theme_color": themeColor,
    "button_color": buttonColor,
    "avg_rating": avgRating,
    "total_rating": totalRating,
    "total_comment": totalComment,
    "teaser_url": teaserUrl,
    "quizz_link": quizzLink,
    "is_quiz": isQuiz,
    "is_wishlist": isWishlist?.value,
    "is_register": isRegister,
    "is_purchased": isPurchased,
    'isLoading': isLoading,
    "level": level?.toJson(), // Serialize level
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
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
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


class Model {
  Model(
      {this.id,
      this.categoryId,
      this.levelId,
      this.languageId,
      this.providerId,
      this.tagId,
      this.title,
      this.index,
      this.description,
      this.fileType,
      this.fileUrl,
      this.thumbnail,
      this.thumbnails,
      this.duration,
      this.fieldLabel,
      this.videoTime,
      this.avgRating,
      this.ratingCount,
      this.commentCount,
      this.isFree,
      this.isTrial,
      this.isHome,
      this.isActive,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.isWishlist,
      this.courseTitle,
      this.themeColor});

  int? id;
  int? categoryId;
  int? levelId;
  int? languageId;
  int? providerId;
  int? tagId;
  String? title;
  String? courseTitle;
  int? index;
  String? description;
  String? fileType;
  String? fileUrl;
  String? thumbnail;
  String? thumbnails;
  int? duration;
  Color? themeColor;
  dynamic fieldLabel;
  String? videoTime;
  double? avgRating;
  dynamic ratingCount;
  dynamic commentCount;
  int? isFree;
  int? isTrial;
  int? isHome;
  int? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  RxInt? isWishlist;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
        id: json["id"],
        categoryId: json["category_id"],
        levelId: json["level_id"],
        languageId: json["language_id"],
        providerId: json["provider_id"],
        tagId: json["tag_id"],
        title: json["title"],
        courseTitle: json["course_title"],
        index: json["index"],
        themeColor: json["theme_color"] == null
            ? Colors.transparent
            : json["theme_color"].runtimeType == Color
                ? json["theme_color"]
                : ColorResource.parseHex(json["theme_color"]),
        description: json["description"],
        fileType: json["file_type"],
        fileUrl: json["recording_url"],
        thumbnail: json["thumbnail"],
        thumbnails: json["thumbnails"],
        duration: json["duration"],
        fieldLabel: json["field_label"],
        videoTime: json["video_time"],
        avgRating: json["avg_rating"] == null
            ? 0.0
            : double.parse(json['avg_rating'].toString()),
        ratingCount: json["rating_count"],
        commentCount: json["comment_count"],
        isFree: json["is_free"],
        isTrial: json["is_trial"],
        isHome: json["is_home"],
        isActive: json["is_active"],
        isWishlist:
            json["is_wishlist"] == null ? 1.obs : json["is_wishlist"].obs,
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["updated_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "categStringory_id": categoryId,
        "level_id": levelId,
        "language_id": languageId,
        "provider_id": providerId,
        "tag_id": tagId,
        "is_wishlist": isWishlist?.value,
        "title": title,
        "course_title": courseTitle,
        "index": index,
        "theme_color": themeColor,
        "description": description,
        "file_type": fileType,
        "recording_url": fileUrl,
        "thumbnail": thumbnail,
        "thumbnails": thumbnails,
        "duration": duration,
        "field_label": fieldLabel,
        "video_time": videoTime,
        "avg_rating": avgRating,
        "rating_count": ratingCount,
        "comment_count": commentCount,
        "is_free": isFree,
        "is_trial": isTrial,
        "is_home": isHome,
        "is_active": isActive,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}
