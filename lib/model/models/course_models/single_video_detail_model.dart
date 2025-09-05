// To parse this JSON data, do
//
//     final singleVideoModel = singleVideoModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

SingleVideoModel singleVideoModelFromJson(String str) => SingleVideoModel.fromJson(json.decode(str));

String singleVideoModelToJson(SingleVideoModel data) => json.encode(data.toJson());

class SingleVideoModel {
  SingleVideoModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory SingleVideoModel.fromJson(Map<String, dynamic> json) => SingleVideoModel(
    status: json["status"],
    data: json["data"] == null?Data():Data.fromJson(json["data"]),
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
    this.wishlistsCount,
    this.category,
    this.tag,
    this.language,
    this.level,
    this.provider,
    this.isWishlist,
    this.matchCriteria,
    this.fileType,
    this.downloadUrl,
    this.fileUrlDownload
  });

  int? id;
  int? categoryId;
  int? levelId;
  int? languageId;
  int? providerId;
  int? tagId;
  String? title;
  String? description;
  String? fileUrl;
  String? fileUrlDownload;
  String? thumbnail;
  double? rating;
  String? fileType;
  String? downloadUrl;
  int? isFree;
  int? isActive;
  int? wishlistsCount;
  Category? category;
  Tag? tag;
  Language? language;
  Level? level;
  Provider? provider;
  RxInt? isWishlist;
  MatchCriteria? matchCriteria;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    categoryId: json["category_id"],
    levelId: json["level_id"],
    languageId: json["language_id"],
    providerId: json["provider_id"],
    tagId: json["tag_id"],
    title: json["title"],
    downloadUrl: json["download_url"],
    description: json["description"],
    fileUrl: json["file_url"],
    fileUrlDownload: json["file_url_download"],
    fileType: json["file_type"],
    thumbnail: json["thumbnail"],
    rating: json["avg_rating"] == null ? 0.0: double.parse(json['avg_rating'].toString()),
    isFree: json["is_free"],
    isActive: json["is_active"],
    wishlistsCount: json["wishlists_count"],
    category: json["category"] == null ? Category(): Category.fromJson(json["category"]),
    matchCriteria: json["match_criteria"] == null ? MatchCriteria(): MatchCriteria.fromJson(json["match_criteria"]),
    tag: json["tag"] == null ? Tag(): Tag.fromJson(json["tag"]),
    language: json["language"] == null ?Language():Language.fromJson(json["language"]),
    level: json["level"] == null ? Level():Level.fromJson(json["level"]),
    provider:json["provider"] == null ?Provider(): Provider.fromJson(json["provider"]),
    isWishlist: json["is_wishlist"] == null ? 0.obs:int.parse(json["is_wishlist"].toString()).obs,
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "level_id": levelId,
    "language_id": languageId,
    "provider_id": providerId,
    "tag_id": tagId,
    "download_url": downloadUrl,
    "file_url_download": fileUrlDownload,
    "title": title,
    "file_type": fileType,
    "description": description,
    "file_url": fileUrl,
    "thumbnail": thumbnail,
    "avg_rating": rating,
    "is_free": isFree,
    "is_active": isActive,
    "wishlists_count": wishlistsCount,
    "category": category?.toJson(),
    "match_criteria": matchCriteria?.toJson(),
    "tag": tag?.toJson(),
    "language": language?.toJson(),
    "level": level?.toJson(),
    "provider": provider?.toJson(),
    "is_wishlist": isWishlist?.value,
  };
}
class MatchCriteria {
  MatchCriteria({
    this.categoryId,
    this.matchCriteriaId,
    this.criteria,
    this.category,
    this.matchCriteria,
  });

  int? categoryId;
  int? matchCriteriaId;
  int? criteria;
  MatchCriteriaClass? category;
  MatchCriteriaClass? matchCriteria;

  factory MatchCriteria.fromJson(Map<String, dynamic> json) => MatchCriteria(
    categoryId: json["category_id"],
    matchCriteriaId: json["match_criteria_id"],
    criteria: json["criteria"],
    category:json["category"] == null? MatchCriteriaClass(): MatchCriteriaClass.fromJson(json["category"]),
    matchCriteria: json["match_criteria"] == null? MatchCriteriaClass(): MatchCriteriaClass.fromJson(json["match_criteria"]),
  );

  Map<String, dynamic> toJson() => {
    "category_id": categoryId,
    "match_criteria_id": matchCriteriaId,
    "criteria": criteria,
    "category": category?.toJson(),
    "match_criteria": matchCriteria?.toJson(),
  };
}
class MatchCriteriaClass {
  MatchCriteriaClass({
    this.id,
    this.title,
  });

  int?id;
  String? title;

  factory MatchCriteriaClass.fromJson(Map<String, dynamic> json) => MatchCriteriaClass(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
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
    createdAt: json["created_at"] == null ?DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ?DateTime(1999): DateTime.parse(json["updated_at"]),
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

class Provider {
  Provider({
    this.id,
    this.providerName,
    this.companyName,
  });

  int? id;
  String? providerName;
  String? companyName;

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    id: json["id"],
    providerName: json["provider_name"],
    companyName: json["company_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "provider_name": providerName,
    "company_name": companyName,
  };
}

class Tag {
  Tag({
    this.id,
    this.tagName,
  });

  int? id;
  String? tagName;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json["id"],
    tagName: json["tag_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tag_name": tagName,
  };
}
