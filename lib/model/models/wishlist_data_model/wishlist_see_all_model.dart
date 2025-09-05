// To parse this JSON data, do
//
//     final wishListSeeAllModel = wishListSeeAllModelFromJson(jsonString);

import 'dart:convert';

WishListSeeAllModel wishListSeeAllModelFromJson(String str) => WishListSeeAllModel.fromJson(json.decode(str));

String wishListSeeAllModelToJson(WishListSeeAllModel data) => json.encode(data.toJson());

class WishListSeeAllModel {
  WishListSeeAllModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory WishListSeeAllModel.fromJson(Map<String, dynamic> json) => WishListSeeAllModel(
    status: json["status"],
    data:json["data"] == null ?Data(): Data.fromJson(json["data"]),
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
    data: json["data"] == null ? []:List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pagination: json["pagination"] == null ? Pagination():Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data?.map((x) => x.toJson())??[]),
    "pagination": pagination?.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.type,
    this.userId,
    this.modelType,
    this.modelId,
    this.user,
    this.model,
    this.createdAt,
  });

  int? id;
  String? type;
  int? userId;
  String? modelType;
  int? modelId;
  User? user;
  Model? model;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
    userId: json["user_id"],
    modelType: json["model_type"],
    modelId: json["model_id"],
    user: json["user"] == null ? User(): User.fromJson(json["user"]),
    model: json["model"] == null ? Model():Model.fromJson(json["model"]),
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "user_id": userId,
    "model_type": modelType,
    "model_id": modelId,
    "user": user?.toJson(),
    "model": model?.toJson(),
    "created_at": createdAt?.toIso8601String(),
  };
}

class Model {
  Model({
    this.id,
    this.levelId,
    this.languageId,
    this.providerId,
    this.typeId,
    this.categoryId,
    this.tagId,
    this.quizId,
    this.certificateCriteria,
    this.courseTitle,
    this.index,
    this.description,
    this.thumbnail,
    this.image,
    this.preview,
    this.themeColor,
    this.buttonColor,
    this.avgRating,
    this.ratingCount,
    this.commentCount,
    this.teaserType,
    this.teaserUrl,
    this.fieldLabel,
    this.quizLink,
    this.isHome,
    this.isTop,
    this.isFree,
    this.isActive,
    this.isQuiz,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.courseDetailCount,
  });

  int? id;
  int? levelId;
  int? languageId;
  int? providerId;
  int? typeId;
  int? categoryId;
  dynamic tagId;
  int? quizId;
  int? certificateCriteria;
  String? courseTitle;
  int? index;
  String? description;
  String? thumbnail;
  String? image;
  String? preview;
  String? themeColor;
  dynamic buttonColor;
  double? avgRating;
  int? ratingCount;
  int? commentCount;
  String? teaserType;
  String? teaserUrl;
  int? fieldLabel;
  dynamic quizLink;
  int? isHome;
  int? isTop;
  int? isFree;
  int? isActive;
  int? isQuiz;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? courseDetailCount;

  factory Model.fromJson(Map<String, dynamic> json) => Model(
    id: json["id"],
    levelId: json["level_id"],
    languageId: json["language_id"],
    providerId: json["provider_id"],
    typeId: json["type_id"],
    categoryId: json["category_id"],
    tagId: json["tag_id"],
    quizId: json["quiz_id"],
    certificateCriteria: json["certificate_criteria"],
    courseTitle: json["course_title"],
    index: json["index"],
    description: json["description"],
    thumbnail: json["thumbnail"],
    image: json["image"],
    preview: json["preview"],
    themeColor: json["theme_color"],
    buttonColor: json["button_color"],
    avgRating: json["avg_rating"] == null ? 0.0 : double.parse(json['avg_rating'].toString()),
    ratingCount: json["rating_count"],
    commentCount: json["comment_count"],
    teaserType: json["teaser_type"],
    teaserUrl: json["teaser_url"],
    fieldLabel: json["field_label"],
    quizLink: json["quiz_link"],
    isHome: json["is_home"],
    isTop: json["is_top"],
    isFree: json["is_free"],
    isActive: json["is_active"],
    isQuiz: json["is_quiz"],
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    courseDetailCount: json["course_detail_count"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "level_id": levelId,
    "language_id": languageId,
    "provider_id": providerId,
    "type_id": typeId,
    "category_id": categoryId,
    "tag_id": tagId,
    "quiz_id": quizId,
    "certificate_criteria": certificateCriteria,
    "course_title": courseTitle,
    "index": index,
    "description": description,
    "thumbnail": thumbnail,
    "image": image,
    "preview": preview,
    "theme_color": themeColor,
    "button_color": buttonColor,
    "avg_rating": avgRating,
    "rating_count": ratingCount,
    "comment_count": commentCount,
    "teaser_type": teaserType,
    "teaser_url": teaserUrl,
    "field_label": fieldLabel,
    "quiz_link": quizLink,
    "is_home": isHome,
    "is_top": isTop,
    "is_free": isFree,
    "is_active": isActive,
    "is_quiz": isQuiz,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "course_detail_count": courseDetailCount,
  };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.profileImage,
  });

  int? id;
  String? name;
  String? email;
  String? mobileNo;
  String? profileImage;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "profile_image": profileImage,
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
