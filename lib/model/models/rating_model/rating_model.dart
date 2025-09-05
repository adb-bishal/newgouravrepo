// To parse this JSON data, do
//
//     final getReviewModel = getReviewModelFromJson(jsonString);

import 'dart:convert';

GetReviewModel getReviewModelFromJson(String str) =>
    GetReviewModel.fromJson(json.decode(str));

String getReviewModelToJson(GetReviewModel data) => json.encode(data.toJson());

class GetReviewModel {
  GetReviewModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory GetReviewModel.fromJson(Map<String, dynamic> json) => GetReviewModel(
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
  Datum(
      {this.id,
      this.userId,
      this.reviewableType,
      this.reviewableId,
      this.comment,
      this.reply,
      this.isActive,
      this.count,
      this.user,
      this.rating,
      this.reviewable,
      this.createdAt});

  int? id;
  int? userId;
  String? reviewableType;
  int? reviewableId;
  double? rating;
  String? comment;
  dynamic reply;
  int? isActive;
  int? count;
  User? user;
  Reviewable? reviewable;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        userId: json["user_id"],
        // count: json[],
        rating: json["rating"] == null
            ? 0.0
            : double.parse(json["rating"].toString()),
        reviewableType: json["reviewable_type"],
        reviewableId: json["reviewable_id"],
        comment: json["comment"],
        reply: json["reply"],
        isActive: json["is_active"],
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
        user: json["user"] == null ? User() : User.fromJson(json["user"]),
        reviewable: json["reviewable"] == null
            ? Reviewable()
            : Reviewable.fromJson(json["reviewable"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "user_id": userId,
        "rating": rating,
        "reviewable_type": reviewableType,
        "reviewable_id": reviewableId,
        "comment": comment,
        "reply": reply,
        "is_active": isActive,
        "reviewable": reviewable?.toJson(),
        "user": user?.toJson(),
        "created_at": createdAt?.toIso8601String()
      };
}

class Reviewable {
  Reviewable({
    this.id,
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
    this.providerId,
    this.title,
    this.fileUrl,
    this.thumbnail,
    this.videoTime,
    this.rating,
  });

  int? id;
  int? levelId;
  int? languageId;
  int? typeId;
  int? categoryId;
  int? tagId;
  int? quizId;
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
  int? providerId;
  String? title;
  String? fileUrl;
  String? thumbnail;
  String? videoTime;
  int? rating;

  factory Reviewable.fromJson(Map<String, dynamic> json) => Reviewable(
        id: json["id"],
        levelId: json["level_id"],
        languageId: json["language_id"],
        typeId: json["type_id"],
        categoryId: json["category_id"],
        tagId: json["tag_id"],
        quizId: json["quiz_id"],
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
        providerId: json["provider_id"],
        title: json["title"],
        fileUrl: json["file_url"],
        thumbnail: json["thumbnail"],
        videoTime: json["video_time"],
        rating: json["rating"],
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
        "thumbnails": thumbnails,
        "image": image,
        "preview": preview,
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
        "provider_id": providerId,
        "title": title,
        "file_url": fileUrl,
        "thumbnail": thumbnail,
        "video_time": videoTime,
        "rating": rating,
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
