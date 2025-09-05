// To parse this JSON data, do
//
//     final singleAudioModel = singleAudioModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';
import 'package:stockpathshala_beta/model/models/course_models/course_by_id_model.dart';
import 'package:stockpathshala_beta/model/models/course_models/single_video_detail_model.dart';

SingleAudioModel singleAudioModelFromJson(String str) => SingleAudioModel.fromJson(json.decode(str));

String singleAudioModelToJson(SingleAudioModel data) => json.encode(data.toJson());

class SingleAudioModel {
  SingleAudioModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory SingleAudioModel.fromJson(Map<String, dynamic> json) => SingleAudioModel(
    status: json["status"],
    data: json["data"] == null ? Data():Data.fromJson(json["data"]),
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
    this.courseTitle,
    this.courseCategory,
    this.typeId,
    this.thumbnails,
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
    this.courseDetailCount,
    this.courseDetail,
    this.reviews,
    this.quiz,
    this.duration,
    this.teaserType,
    this.matchCriteria,
    this.durationSec
  });

  int? id;
  int? categoryId;
  int? levelId;
  int? languageId;
  int? providerId;
  int? tagId;
  String? title;
  String? courseTitle;
  String? description;
  String? fileUrl;
  String? thumbnail;
  double? rating;
  int? isFree;
  int? isActive;
  int? wishlistsCount;
  Category? category;
  Category? courseCategory;
  Tag? tag;
  Language? language;
  Level? level;
  Provider? provider;
  RxInt? isWishlist;

  int? typeId;
  String? duration;
  String? durationSec;
  String? thumbnails;
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
  int? courseDetailCount;
  List<CourseDetail>? courseDetail;
  List<dynamic>? reviews;
  Quiz? quiz;
  MatchCriteria? matchCriteria;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    categoryId: json["category_id"],
    levelId: json["level_id"],
    languageId: json["language_id"],
    providerId: json["provider_id"],
    tagId: json["tag_id"],
    title: json["title"],
    courseTitle: json["course_title"],
    description: json["description"],
    fileUrl: json["file_url"],
    thumbnail: json["thumbnail"],
    rating: json["avg_rating"] == null ? 0.0 : double.parse(json["avg_rating"].toString()),
    isFree: json["is_free"],
    isActive: json["is_active"],
    wishlistsCount: json["wishlists_count"],
    category:json["category"] == null?Category(): Category.fromJson(json["category"]),
    courseCategory:json["course_category"] == null?Category(): Category.fromJson(json["course_category"]),
    tag:json["tag"] == null?Tag(): Tag.fromJson(json["tag"]),
    language: json["language"] == null?Language(): Language.fromJson(json["language"]),
    level:json["level"] ==null?Level(): Level.fromJson(json["level"]),
    provider: json["provider"] == null ? Provider():Provider.fromJson(json["provider"]),
    isWishlist: json["is_wishlist"] == null ? 0.obs:int.parse(json["is_wishlist"].toString()).obs,
    typeId: json["type_id"],
    duration: json["duration"].toString(),
    durationSec: json["duration_sec"].toString(),
    teaserType: json["teaser_type"],
    thumbnails: json["thumbnail"],
    isQuiz: json["is_quiz"],
    quizId: json["quiz_id"],
    image: json["image"],
    preview: json["preview"],
    themeColor: json["theme_color"],
    buttonColor: json["button_color"],
    avgRating: json["avg_rating"] == null ? 0.0:double.parse(json["avg_rating"].toString()),
    totalRating: json["total_rating"],
    totalComment: json["total_comment"],
    teaserUrl: json["teaser_url"],
    matchCriteria: json["match_criteria"] == null ? MatchCriteria(): MatchCriteria.fromJson(json["match_criteria"]),
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    courseType:json["course_type"] == null? CourseT(): CourseT.fromJson(json["course_type"]),
    courseTag: json["course_tag"] == null? CourseT():  CourseT.fromJson(json["course_tag"]),
    courseDetailCount: json["course_detail_count"],
    courseDetail: json["course_detail"] == null ?[]: List<CourseDetail>.from(json["course_detail"].map((x) => CourseDetail.fromJson(x))),
    reviews: json["reviews"] == null?[]: List<dynamic>.from(json["reviews"].map((x) => x)),
    quiz: json["quiz"] == null ? Quiz(): Quiz.fromJson(json["quiz"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "level_id": levelId,
    "language_id": languageId,
    "provider_id": providerId,
    "tag_id": tagId,
    "title": title,
    "course_title": courseTitle,
    "duration_sec": durationSec,
    "description": description,
    "file_url": fileUrl,
    "thumbnail": thumbnail,
    "avg_rating": rating,
    "is_free": isFree,
    "is_active": isActive,
    "wishlists_count": wishlistsCount,
    "category": category?.toJson(),
    "course_category": courseCategory?.toJson(),
    "tag": tag?.toJson(),
    "language": language?.toJson(),
    "level": level?.toJson(),
    "provider": provider?.toJson(),
    "is_wishlist": isWishlist?.value,
    "type_id": typeId,
    "duration":duration,
    "teaser_type": teaserType,
    "is_quiz": isQuiz,
    "quiz_id": quizId,
    "image": image,
    "preview": preview,
    "theme_color": themeColor,
    "button_color": buttonColor,
    "total_rating": totalRating,
    "total_comment": totalComment,
    "teaser_url": teaserUrl,
    "created_at": createdAt?.toIso8601String(),
    "course_type": courseType?.toJson(),
    "match_criteria": matchCriteria?.toJson(),
    "course_tag": courseTag?.toJson(),
    "course_detail_count": courseDetailCount,
    "course_detail": List<dynamic>.from(courseDetail?.map((x) => x.toJson())??[]),
    "reviews": List<dynamic>.from(reviews?.map((x) => x)??[]),
    "quiz": quiz?.toJson(),
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
    createdAt: json["created_at"] == null ?DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ?DateTime(1999): DateTime.parse(json["updated_at"]),
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
    createdAt: json["created_at"] == null ?DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ?DateTime(1999): DateTime.parse(json["updated_at"]),
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
    createdAt:json["created_at"] == null ?DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"] == null ?DateTime(1999): DateTime.parse(json["updated_at"]),
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
    this.mobileNo,
    this.email,
    this.password,
    this.companyLogo,
    this.commission,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? providerName;
  String? companyName;
  String? mobileNo;
  String? email;
  String? password;
  String? companyLogo;
  int? commission;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Provider.fromJson(Map<String, dynamic> json) => Provider(
    id: json["id"],
    providerName: json["provider_name"],
    companyName: json["company_name"],
    mobileNo: json["mobile_no"],
    email: json["email"],
    password: json["password"],
    companyLogo: json["company_logo"],
    commission: json["commission"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null ?DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ?DateTime(1999): DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "provider_name": providerName,
    "company_name": companyName,
    "mobile_no": mobileNo,
    "email": email,
    "password": password,
    "company_logo": companyLogo,
    "commission": commission,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Tag {
  Tag({
    this.id,
    this.tagName,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? tagName;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Tag.fromJson(Map<String, dynamic> json) => Tag(
    id: json["id"],
    tagName: json["tag_name"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null ?DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ?DateTime(1999): DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tag_name": tagName,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
