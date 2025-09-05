// To parse this JSON data, do
//
//     final coursesModel = coursesModelFromJson(jsonString);

import 'dart:convert';

CoursesModel coursesModelFromJson(String str) =>
    CoursesModel.fromJson(json.decode(str));

String coursesModelToJson(CoursesModel data) => json.encode(data.toJson());

class CoursesModel {
  CoursesModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory CoursesModel.fromJson(Map<String, dynamic> json) => CoursesModel(
        status: json["status"],
        data: Data.fromJson(json["data"]),
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
    this.data,
    this.pagination,
  });

  List<Datum>? data;
  Pagination? pagination;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null
            ? Pagination()
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        "pagination": pagination?.toJson(),
      };
}

class Datum {
  Datum({
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
    this.isTrial,
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
  int? isTrial;

  int? isActive;
  int? isQuiz;
  int? quizId;
  String? image;
  String? preview;
  String? themeColor;
  String? buttonColor;
  double? avgRating;
  int? totalRating;
  int? totalComment;
  String? teaserUrl;
  DateTime? createdAt;
  CourseType? courseType;
  CourseTag? courseTag;
  CourseCategory? courseCategory;
  int? courseDetailCount;
  int? isWishlist;
  Language? language;
  List<Review>? reviews;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
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
        isTrial: json["is_trial"],
        isActive: json["is_active"],
        isQuiz: json["is_quiz"],
        quizId: json["quiz_id"],
        image: json["image"],
        preview: json["preview"],
        themeColor: json["theme_color"],
        buttonColor: json["button_color"],
        avgRating: json["avg_rating"] == null
            ? 0.0
            : double.tryParse(json["avg_rating"].toString()),
        totalRating: json["total_rating"],
        totalComment: json["total_comment"],
        teaserUrl: json["teaser_url"],
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
        courseType: json["course_type"] == null
            ? CourseType()
            : CourseType.fromJson(json["course_type"]),
        courseTag: json["course_tag"] == null
            ? CourseTag()
            : CourseTag.fromJson(json["course_tag"]),
        courseCategory: json["course_category"] == null
            ? CourseCategory()
            : CourseCategory.fromJson(json["course_category"]),
        courseDetailCount: json["course_detail_count"],
        isWishlist: json["is_wishlist"],
        language: json["language"] == null
            ? Language()
            : Language.fromJson(json["language"]),
        reviews: json["reviews"] == null
            ? []
            : List<Review>.from(json["reviews"].map((x) => Review.fromJson(x))),
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
        "is_trial": isTrial,
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
        "is_wishlist": isWishlist,
        "language": language?.toJson(),
        "reviews": List<dynamic>.from(reviews?.map((x) => x.toJson()) ?? []),
      };
}

class CourseCategory {
  CourseCategory({
    this.id,
    this.title,
  });

  int? id;
  String? title;

  factory CourseCategory.fromJson(Map<String, dynamic> json) => CourseCategory(
        id: json["id"],
        title: json["title"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "title": title,
      };
}

class CourseTag {
  CourseTag({
    this.id,
    this.tagName,
  });

  int? id;
  String? tagName;

  factory CourseTag.fromJson(Map<String, dynamic> json) => CourseTag(
        id: json["id"],
        tagName: json["tag_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "tag_name": tagName,
      };
}

class CourseType {
  CourseType({
    this.id,
    this.typeName,
  });

  int? id;
  String? typeName;

  factory CourseType.fromJson(Map<String, dynamic> json) => CourseType(
        id: json["id"],
        typeName: json["type_name"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "type_name": typeName,
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
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["updated_at"]),
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
