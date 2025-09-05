// To parse this JSON data, do
//
//     final blogDetailModel = blogDetailModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

BlogDetailModel blogDetailModelFromJson(String str) => BlogDetailModel.fromJson(json.decode(str));

String blogDetailModelToJson(BlogDetailModel data) => json.encode(data.toJson());

class BlogDetailModel {
  BlogDetailModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory BlogDetailModel.fromJson(Map<String, dynamic> json) {
    return BlogDetailModel(
      status: json["status"],
      data: json["data"] == null ? Data():Data.fromJson(json["data"]),
      message: json["message"],
    );
  }

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class Data {
  Data({
    this.id,
    this.levelId,
    this.providerId,
    this.categoryId,
    this.languageId,
    this.title,
    this.image,
    this.description,
    this.index,
    this.blogMedia,
    this.isFree,
    this.blogRating,
    this.isActive,
    this.category,
    this.language,
    this.createdAt,
    this.updatedAt,
    this.isWishlist,
    this.fileUrl,
    this.fileType,
    this.audioUrl,
    this.videoUrl,
    this.videoType
  });

  int? id;
  dynamic levelId;
  dynamic providerId;
  int? categoryId;
  int? languageId;
  String? title;
  String? image;
  String? description;
  int? index;
  String? blogMedia;
  String? fileUrl;
  String? audioUrl;
  String? videoUrl;
  String? videoType;
  String? fileType;
  int? isFree;
  double? blogRating;
  int? isActive;
  Category? category;
  Language? language;
  DateTime? createdAt;
  DateTime? updatedAt;
  RxInt? isWishlist;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    levelId: json["level_id"],
    providerId: json["provider_id"],
    categoryId: json["category_id"],
    languageId: json["language_id"],
    title: json["title"],
    image: json["image"],
    description: json["description"],
    index: json["index"],
    blogMedia: json["blog_media"],
    isFree: json["is_free"],
    fileUrl: json["file_url"],
    fileType: json["file_type"],
    audioUrl: json["audio_url"],
    videoUrl: json["video_url"],
    videoType: json["video_type"],
    blogRating: json["avg_rating"] == null ? 0.0:double.parse(json["avg_rating"].toString()),
    isActive: json["is_active"],
    category: json["category"] == null ? Category():Category.fromJson(json["category"]),
    language: json["language"] == null ? Language():Language.fromJson(json["language"]),
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    isWishlist: json["is_wishlist"] == null ? 0.obs : int.parse(json["is_wishlist"].toString()).obs,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "level_id": levelId,
    "provider_id": providerId,
    "category_id": categoryId,
    "language_id": languageId,
    "title": title,
    "image": image,
    "description": description,
    "index": index,
    "file_type": fileType,
    "file_url": fileUrl,
    "audio_url": audioUrl,
    "video_type": videoType,
    "video_url": videoUrl,
    "blog_media": blogMedia,
    "is_free": isFree,
    "blog_rating": blogRating,
    "is_active": isActive,
    "category": category?.toJson(),
    "language": language?.toJson(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "is_wishlist": isWishlist?.value,
  };
}

class Category {
  Category({
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

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    index: json["index"],
    title: json["title"],
    description: json["description"],
    image: json["image"],
    isActive: json["is_active"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
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
