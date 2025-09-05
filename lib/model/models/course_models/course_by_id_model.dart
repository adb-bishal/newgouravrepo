// To parse this JSON data, do
//
//     final courseByIdModel = courseByIdModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/course_models/single_video_detail_model.dart';

CourseByIdModel courseByIdModelFromJson(String str) =>
    CourseByIdModel.fromJson(json.decode(str));

String courseByIdModelToJson(CourseByIdModel data) =>
    json.encode(data.toJson());

class CourseByIdModel {
  CourseByIdModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory CourseByIdModel.fromJson(Map<String, dynamic> json) =>
      CourseByIdModel(
        status: json["status"],
        data: json["data"] == null ? Data() : Data.fromJson(json["data"]),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
      };
}

class Data {
  Data(
      {this.id,
      this.levelId,
      this.languageId,
      this.typeId,
      this.categoryId,
      this.tagId,
      this.courseTitle,
      this.description,
      this.thumbnails,
      this.isFree,
      this.isActive,
      this.isQuiz,
      this.quizId,
      this.image,
      this.preview,
      this.themeColor,
      this.buttonColor,
      this.avgRating,
      this.totalRating,
      this.totalComment,
      this.teaserUrl,
      this.createdAt,
      this.courseType,
      this.courseTag,
      this.courseCategory,
      this.courseDetailCount,
      this.courseDetail,
      this.isWishlist,
      this.language,
      this.reviews,
      this.quiz,
      this.duration,
      this.teaserType,
      this.matchCriteria,
      this.certificateCriteria,
        this.expiredUserPopup, // New field

        this.isTrialCourse});

  int? id;
  int? levelId;
  int? languageId;
  int? typeId;
  int? categoryId;
  int? tagId;
  String? duration;
  String? courseTitle;
  String? description;
  String? thumbnails;
  int? isFree;
  int? isActive;
  int? isQuiz;
  int? quizId;
  String? image;
  String? preview;
  String? themeColor;
  String? buttonColor;
  String? teaserType;
  double? avgRating;
  int? totalRating;
  int? totalComment;
  String? teaserUrl;
  DateTime? createdAt;
  CourseT? courseType;
  CourseT? courseTag;
  CourseCategory? courseCategory;
  int? courseDetailCount;
  List<CourseDetail>? courseDetail;
  RxInt? isWishlist;
  Language? language;
  List<dynamic>? reviews;
  Quiz? quiz;
  MatchCriteria? matchCriteria;
  double? certificateCriteria;
  ExpiredUserPopup? expiredUserPopup; // New field

  int? isTrialCourse;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
      id: json["id"],
      levelId: json["level_id"],
      languageId: json["language_id"],
      typeId: json["type_id"],
      categoryId: json["category_id"],
      tagId: json["tag_id"],
      duration: json["duration"],
      teaserType: json["teaser_type"],
      courseTitle: json["course_title"],
      certificateCriteria: json["certificate_criteria"] == null
          ? 0.0
          : double.tryParse(json["certificate_criteria"].toString()),
      description: json["description"],
      thumbnails: json["thumbnail"],
      isFree: json["is_free"],
      isActive: json["is_active"],
      isQuiz: json["is_quiz"],
      quizId: json["quiz_id"],
      image: json["image"],
      preview: json["preview"],
      themeColor: json["theme_color"],
      buttonColor: json["button_color"],
      avgRating: json["avg_rating"] == null
          ? 0.0
          : double.parse(json["avg_rating"].toString()),
      totalRating: json["total_rating"],
      totalComment: json["total_comment"],
      teaserUrl: json["teaser_url"],
      matchCriteria: json["match_criteria"] == null
          ? MatchCriteria()
          : MatchCriteria.fromJson(json["match_criteria"]),
      createdAt: json["created_at"] == null
          ? DateTime(1999)
          : DateTime.parse(json["created_at"]),
      courseType: json["course_type"] == null
          ? CourseT()
          : CourseT.fromJson(json["course_type"]),
      courseTag: json["course_tag"] == null
          ? CourseT()
          : CourseT.fromJson(json["course_tag"]),
      courseCategory: json["course_category"] == null
          ? CourseCategory()
          : CourseCategory.fromJson(json["course_category"]),
      courseDetailCount: json["course_detail_count"],
      courseDetail: json["course_detail"] == null
          ? []
          : List<CourseDetail>.from(
              json["course_detail"].map((x) => CourseDetail.fromJson(x))),
      isWishlist: json["is_wishlist"] == null
          ? 0.obs
          : int.parse(json["is_wishlist"].toString()).obs,
      language: json["language"] == null
          ? Language()
          : Language.fromJson(json["language"]),
      reviews: json["reviews"] == null
          ? []
          : List<dynamic>.from(json["reviews"].map((x) => x)),
      quiz: json["quiz"] == null ? Quiz() : Quiz.fromJson(json["quiz"]),
      expiredUserPopup
          : json["expired_user_popup"] == null
          ? null
          : ExpiredUserPopup.fromJson(json["expired_user_popup"]),
      isTrialCourse: json["is_trial"]);

  Map<String, dynamic> toJson() => {
        "id": id,
        "level_id": levelId,
        "language_id": languageId,
        "type_id": typeId,
        "duration": duration,
        "category_id": categoryId,
        "tag_id": tagId,
        "teaser_type": teaserType,
        "course_title": courseTitle,
        "certificate_criteria": certificateCriteria,
        "description": description,
        "thumbnail": thumbnails,
        "is_free": isFree,
        "is_active": isActive,
        "is_quiz": isQuiz,
        "quiz_id": quizId,
        "image": image,
        "preview": preview,
        "theme_color": themeColor,
        "button_color": buttonColor,
        "avg_rating": avgRating,
        "total_rating": totalRating,
        "total_comment": totalComment,
        "teaser_url": teaserUrl,
        "created_at": createdAt?.toIso8601String(),
        "course_type": courseType?.toJson(),
        "match_criteria": matchCriteria?.toJson(),
        "course_tag": courseTag?.toJson(),
        "course_category": courseCategory?.toJson(),
        "course_detail_count": courseDetailCount,
        "course_detail":
            List<dynamic>.from(courseDetail?.map((x) => x.toJson()) ?? []),
        "is_wishlist": isWishlist?.value,
        "language": language?.toJson(),
        "reviews": List<dynamic>.from(reviews?.map((x) => x) ?? []),
        "quiz": quiz?.toJson(),
    "expired_user_popup": expiredUserPopup?.toJson(),

    "is_trial": isTrialCourse,
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


class CourseCategory {
  CourseCategory({
    this.id,
    this.index,
    this.title,
    this.description,
    this.image,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  dynamic index;
  String? title;
  String? description;
  String? image;
  int? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory CourseCategory.fromJson(Map<String, dynamic> json) => CourseCategory(
        id: json["id"],
        index: json["index"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        isActive: json["is_active"],
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
        "index": index,
        "title": title,
        "description": description,
        "image": image,
        "is_active": isActive,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
      };
}

class CourseDetail {
  CourseDetail(
      {this.id,
      this.courseId,
      this.topicTitle,
      this.courseContent,
      this.isActive,
      this.image,
      this.banner,
      this.index,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.fileType,
      this.duration,
      this.durationSec,
      this.courseContentDownload});

  int? id;
  int? courseId;
  String? topicTitle;
  String? courseContent;
  String? courseContentDownload;
  int? isActive;
  String? image;
  String? banner;
  String? fileType;
  String? duration;
  String? durationSec;
  int? index;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
        id: json["id"],
        courseId: json["course_id"],
        topicTitle: json["topic_title"],
        courseContent: json["course_content"],
        courseContentDownload: json["course_content_download"],
        isActive: json["is_active"],
        image: json["image"],
        banner: json["banner"],
        duration: json["duration"].toString(),
        durationSec: json["duration_sec"].toString(),
        fileType: json["file_type"],
        index: json["index"],
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "course_id": courseId,
        "topic_title": topicTitle,
        "course_content": courseContent, //m3u8
        "course_content_download": courseContentDownload, //mp4
        "is_active": isActive,
        "duration_sec": durationSec,
        "image": image,
        "duration": duration,
        "banner": banner,
        "file_type": fileType,
        "index": index,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}

class CourseT {
  CourseT({
    this.id,
    this.tagName,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.typeName,
  });

  int? id;
  String? tagName;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? typeName;

  factory CourseT.fromJson(Map<String, dynamic> json) => CourseT(
        id: json["id"],
        tagName: json["tag_name"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag_name": tagName,
        "is_active": isActive,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
        "type_name": typeName,
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
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["updated_at"]),
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

class Quiz {
  Quiz(
      {this.id,
      this.categoryId,
      this.languageId,
      this.title,
      this.description,
      this.banner,
      this.quizTimer,
      this.isActive,
      this.isScholarship,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.isAttempted});

  int? id;
  int? categoryId;
  int? languageId;
  String? title;
  String? description;
  String? banner;
  int? quizTimer;
  int? isAttempted;
  int? isActive;
  int? isScholarship;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Quiz.fromJson(Map<String, dynamic> json) => Quiz(
        id: json["id"],
        categoryId: json["category_id"],
        languageId: json["language_id"],
        title: json["title"],
        description: json["description"],
        banner: json["banner"],
        quizTimer: json["quiz_timer"],
        isAttempted: json["is_attempted"],
        isActive: json["is_active"],
        isScholarship: json["is_scholarship"],
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "language_id": languageId,
        "title": title,
        "is_attempted": isAttempted,
        "description": description,
        "banner": banner,
        "quiz_timer": quizTimer,
        "is_active": isActive,
        "is_scholarship": isScholarship,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
