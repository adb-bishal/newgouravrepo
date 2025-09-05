// To parse this JSON data, do
//
//     final categoryDetailModel = categoryDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:stockpathshala_beta/model/models/course_models/blog_detail_model.dart';

CategoryDetailModel categoryDetailModelFromJson(String str) =>
    CategoryDetailModel.fromJson(json.decode(str));

String categoryDetailModelToJson(CategoryDetailModel data) =>
    json.encode(data.toJson());

class CategoryDetailModel {
  CategoryDetailModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory CategoryDetailModel.fromJson(Map<String, dynamic> json) =>
      CategoryDetailModel(
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
  Data({
    this.id,
    this.title,
    this.description,
    this.image,
    this.index,
    this.videos,
    this.audios,
    this.blogs,
    this.courseVideos,
    this.courseTexts,
    this.courseAudios,
  });

  int? id;
  String? title;
  dynamic description;
  String? image;
  dynamic index;
  List<Audio>? videos;
  List<Audio>? audios;
  List<Audio>? blogs;
  List<Course>? courseVideos;
  List<Course>? courseTexts;
  List<Course>? courseAudios;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        id: json["id"],
        title: json["title"],
        description: json["description"],
        image: json["image"],
        index: json["index"],
        videos: json["videos"] == null
            ? []
            : List<Audio>.from(json["videos"].map((x) => Audio.fromJson(x))),
        audios: json["audios"] == null
            ? []
            : List<Audio>.from(json["audios"].map((x) => Audio.fromJson(x))),
        blogs: json["blogs"] == null
            ? []
            : List<Audio>.from(json["blogs"].map((x) => Audio.fromJson(x))),
        courseVideos: json["course_videos"] == null
            ? []
            : List<Course>.from(
                json["course_videos"].map((x) => Course.fromJson(x))),
        courseTexts: json["course_texts"] == null
            ? []
            : List<Course>.from(
                json["course_texts"].map((x) => Course.fromJson(x))),
        courseAudios: json["course_audios"] == null
            ? []
            : List<Course>.from(
                json["course_audios"].map((x) => Course.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
        "description": description,
        "image": image,
        "index": index,
        "videos": List<dynamic>.from(videos!.map((x) => x.toJson())),
        "audios": List<dynamic>.from(audios!.map((x) => x.toJson())),
        "blogs": List<dynamic>.from(blogs!.map((x) => x.toJson())),
        "course_videos":
            List<dynamic>.from(courseVideos!.map((x) => x.toJson())),
        "course_texts": List<dynamic>.from(courseTexts!.map((x) => x.toJson())),
        "course_audios":
            List<dynamic>.from(courseAudios!.map((x) => x.toJson())),
      };
}

class Audio {
  Audio(
      {this.id,
      this.categoryId,
      this.levelId,
      this.languageId,
      this.providerId,
      this.tagId,
      this.title,
      this.description,
      this.fileUrl,
      this.thumbnail,
      this.rating,
      this.isFree,
      this.isActive,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.videoTime,
      this.image,
      this.category,
      this.avgRating,
      this.isWishlist});

  int? id;
  int? categoryId;
  int? levelId;
  int? languageId;
  int? providerId;
  int? tagId;
  double? avgRating;
  String? title;
  String? image;
  String? description;
  String? fileUrl;
  String? thumbnail;
  int? rating;
  int? isFree;
  int? isWishlist;
  int? isActive;
  Category? category;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? videoTime;

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
        id: json["id"],
        categoryId: json["category_id"],
        levelId: json["level_id"],
        languageId: json["language_id"],
        providerId: json["provider_id"],
        tagId: json["tag_id"],
        title: json["title"],
        image: json["image"],
        description: json["description"],
        fileUrl: json["file_url"],
        thumbnail: json["thumbnail"],
        avgRating: json["avg_rating"] == null
            ? 0.0
            : double.parse(json["avg_rating"].toString()),
        rating: json["rating"],
        isFree: json["is_free"],
        isWishlist: json["is_wishlist"],
        isActive: json["is_active"],
        category: json["category"] == null
            ? Category()
            : Category.fromJson(json['category']),
        deletedAt: json["deleted_at"],
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["updated_at"]),
        videoTime: json["video_time"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "category_id": categoryId,
        "level_id": levelId,
        "language_id": languageId,
        "avg_rating": avgRating,
        "provider_id": providerId,
        "tag_id": tagId,
        "image": image,
        "is_wishlist": isWishlist,
        "title": title,
        "description": description,
        "file_url": fileUrl,
        "thumbnail": thumbnail,
        "category": category?.toJson(),
        "rating": rating,
        "is_free": isFree,
        "is_active": isActive,
        "deleted_at": deletedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "video_time": videoTime,
      };
}

class Course {
  Course(
      {this.id,
      this.levelId,
      this.languageId,
      this.typeId,
      this.categoryId,
      this.tagId,
      this.quizId,
      this.courseTitle,
      this.description,
      this.thumbnails,
      this.image,
      this.preview,
      this.themeColor,
      this.buttonColor,
      this.avgRating,
      this.totalRating,
      this.totalComment,
      this.teaserUrl,
      this.quizzLink,
      this.isFree,
      this.isActive,
      this.isQuiz,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.isWishlist});

  int? id;
  int? levelId;
  int? languageId;
  int? typeId;
  int? categoryId;
  int? tagId;
  int? quizId;
  int? isWishlist;
  String? courseTitle;
  String? description;
  String? thumbnails;
  String? image;
  String? preview;
  String? themeColor;
  String? buttonColor;
  double? avgRating;
  int? totalRating;
  int? totalComment;
  String? teaserUrl;
  dynamic quizzLink;
  int? isFree;
  int? isActive;
  int? isQuiz;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
        id: json["id"],
        levelId: json["level_id"],
        languageId: json["language_id"],
        typeId: json["type_id"],
        categoryId: json["category_id"],
        tagId: json["tag_id"],
        quizId: json["quiz_id"],
        isWishlist: json["is_wishlist"],
        courseTitle: json["course_title"],
        description: json["description"],
        thumbnails: json["thumbnail"],
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
        quizzLink: json["quizz_link"],
        isFree: json["is_free"],
        isActive: json["is_active"],
        isQuiz: json["is_quiz"],
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
        "level_id": levelId,
        "language_id": languageId,
        "type_id": typeId,
        "category_id": categoryId,
        "tag_id": tagId,
        "quiz_id": quizId,
        "course_title": courseTitle,
        "description": description,
        "thumbnail": thumbnails,
        "image": image,
        "preview": preview,
        "is_wishlist": isWishlist,
        "theme_color": themeColor,
        "button_color": buttonColor,
        "avg_rating": avgRating,
        "total_rating": totalRating,
        "total_comment": totalComment,
        "teaser_url": teaserUrl,
        "quizz_link": quizzLink,
        "is_free": isFree,
        "is_active": isActive,
        "is_quiz": isQuiz,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
      };
}
