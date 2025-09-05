// To parse this JSON data, do
//
//     final courseDetailModel = courseDetailModelFromJson(jsonString);

import 'dart:convert';

CourseDetailModel courseDetailModelFromJson(String str) => CourseDetailModel.fromJson(json.decode(str));

String courseDetailModelToJson(CourseDetailModel data) => json.encode(data.toJson());

class CourseDetailModel {
  CourseDetailModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory CourseDetailModel.fromJson(Map<String, dynamic> json) => CourseDetailModel(
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
  });

  int? id;
  int? levelId;
  int? languageId;
  int? typeId;
  int? categoryId;
  int? tagId;
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
  int? avgRating;
  int? totalRating;
  int? totalComment;
  String? teaserUrl;
  DateTime? createdAt;
  CourseT? courseType;
  CourseT? courseTag;
  CourseCategory? courseCategory;
  int? courseDetailCount;
  List<CourseDetail>? courseDetail;
  int? isWishlist;
  Language? language;
  List<Review>? reviews;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    levelId: json["level_id"],
    languageId: json["language_id"],
    typeId: json["type_id"],
    categoryId: json["category_id"],
    tagId: json["tag_id"],
    courseTitle: json["course_title"],
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
    avgRating: json["avg_rating"],
    totalRating: json["total_rating"],
    totalComment: json["total_comment"],
    teaserUrl: json["teaser_url"],
    createdAt:json["created_at"] == null?DateTime(1999): DateTime.parse(json["created_at"]),
    courseType: json["course_type"] == null? CourseT():CourseT.fromJson(json["course_type"]),
    courseTag:json["course_tag"] == null? CourseT(): CourseT.fromJson(json["course_tag"]),
    courseCategory: json["course_category"] == null ? CourseCategory():CourseCategory.fromJson(json["course_category"]),
    courseDetailCount: json["course_detail_count"],
    courseDetail:json["course_detail"] == null?[]: List<CourseDetail>.from(json["course_detail"].map((x) => CourseDetail.fromJson(x))),
    isWishlist: json["is_wishlist"],
    language: json["language"] == null ? Language():Language.fromJson(json["language"]),
    reviews: json["reviews"] == null? []: List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "level_id": levelId,
    "language_id": languageId,
    "type_id": typeId,
    "category_id": categoryId,
    "tag_id": tagId,
    "course_title": courseTitle,
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
    "course_tag": courseTag?.toJson(),
    "course_category": courseCategory?.toJson(),
    "course_detail_count": courseDetailCount,
    "course_detail": List<dynamic>.from(courseDetail?.map((x) => x.toJson())??[]),
    "is_wishlist": isWishlist,
    "language": language?.toJson(),
    "reviews": List<dynamic>.from(reviews?.map((x) => x.toJson())??[]),
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
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
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

class CourseDetail {
  CourseDetail({
    this.id,
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
  });

  int? id;
  int? courseId;
  String? topicTitle;
  String? courseContent;
  int? isActive;
  String? image;
  String? banner;
  int? index;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory CourseDetail.fromJson(Map<String, dynamic> json) => CourseDetail(
    id: json["id"],
    courseId: json["course_id"],
    topicTitle: json["topic_title"],
    courseContent: json["course_content"],
    isActive: json["is_active"],
    image: json["image"],
    banner: json["banner"],
    index: json["index"],
    createdAt:  json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt:  json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "topic_title": topicTitle,
    "course_content": courseContent,
    "is_active": isActive,
    "image": image,
    "banner": banner,
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
    createdAt:  json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt:  json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
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
    createdAt:  json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt:  json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
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

class Review {
  Review({
    this.id,
    this.userId,
    this.type,
    this.rating,
    this.reviewableType,
    this.reviewableId,
    this.comment,
    this.reply,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  String? type;
  int? rating;
  String? reviewableType;
  int? reviewableId;
  String? comment;
  dynamic reply;
  int? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Review.fromJson(Map<String, dynamic> json) => Review(
    id: json["id"],
    userId: json["user_id"],
    type: json["type"],
    rating: json["rating"],
    reviewableType: json["reviewable_type"],
    reviewableId: json["reviewable_id"],
    comment: json["comment"],
    reply: json["reply"],
    isActive: json["is_active"],
    deletedAt: json["deleted_at"],
    createdAt:  json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt:  json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "type": type,
    "rating": rating,
    "reviewable_type": reviewableType,
    "reviewable_id": reviewableId,
    "comment": comment,
    "reply": reply,
    "is_active": isActive,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}
