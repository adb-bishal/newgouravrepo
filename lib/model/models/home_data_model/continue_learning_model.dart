// To parse this JSON data, do
//
//     final getContinueData = getContinueDataFromJson(jsonString);

import 'dart:convert';

GetContinueData getContinueDataFromJson(String str) => GetContinueData.fromJson(json.decode(str));

String getContinueDataToJson(GetContinueData data) => json.encode(data.toJson());

class GetContinueData {
  GetContinueData({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory GetContinueData.fromJson(Map<String, dynamic> json) => GetContinueData(
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
    this.data,
    this.title,
    this.index,
    this.pagination,
  });

  List<Datum>? data;
  String? title;
  int? index;
  Pagination? pagination;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] ==  null ? []:List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    title: json["title"],
    index: json["index"],
    pagination:json["pagination"] == null ? Pagination(): Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data?.map((x) => x.toJson())??[]),
    "title": title,
    "index": index,
    "pagination": pagination?.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.type,
    this.userId,
    this.user,
    this.trackableType,
    this.trackableId,
    this.trackable,
    this.status,
    this.createdAt,
  });

  int? id;
  String? type;
  int? userId;
  User? user;
  String? trackableType;
  int? trackableId;
  Trackable? trackable;
  int? status;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
    userId: json["user_id"],
    user: json["user"] == null? User():User.fromJson(json["user"]),
    trackableType: json["trackable_type"],
    trackableId: json["trackable_id"],
    trackable: json["trackable"] == null ? Trackable():Trackable.fromJson(json["trackable"]),
    status: json["status"],
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "user_id": userId,
    "user": user?.toJson(),
    "trackable_type": trackableType,
    "trackable_id": trackableId,
    "trackable": trackable?.toJson(),
    "status": status,
    "created_at": createdAt?.toIso8601String(),
  };
}

class Trackable {
  Trackable({
    this.id,
    this.index,
    this.categoryId,
    this.levelId,
    this.languageId,
    this.providerId,
    this.tagId,
    this.title,
    this.description,
    this.fileType,
    this.duration,
    this.fileUrl,
    this.thumbnail,
    this.avgRating,
    this.ratingCount,
    this.commentCount,
    this.fieldLabel,
    this.isHome,
    this.isFree,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.category,
    this.typeId,
    this.quizId,
    this.certificateCriteria,
    this.courseTitle,
    this.image,
    this.preview,
    this.themeColor,
    this.buttonColor,
    this.teaserType,
    this.teaserUrl,
    this.quizLink,
    this.isTop,
    this.isQuiz,
  });

  int? id;
  int? index;
  int? categoryId;
  int? levelId;
  int? languageId;
  int? providerId;
  dynamic tagId;
  String? title;
  String? description;
  String? fileType;
  int? duration;
  String? fileUrl;
  String? thumbnail;
  double? avgRating;
  int? ratingCount;
  int? commentCount;
  int? fieldLabel;
  int? isHome;
  int? isFree;
  int? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  Category? category;
  int? typeId;
  int? quizId;
  int? certificateCriteria;
  String? courseTitle;
  String? image;
  String? preview;
  String? themeColor;
  dynamic buttonColor;
  String? teaserType;
  String? teaserUrl;
  dynamic quizLink;
  int? isTop;
  int? isQuiz;

  factory Trackable.fromJson(Map<String, dynamic> json) => Trackable(
    id: json["id"],
    index: json["index"],
    categoryId: json["category_id"],
    levelId: json["level_id"],
    languageId: json["language_id"],
    providerId: json["provider_id"],
    tagId: json["tag_id"],
    title: json["title"],
    description: json["description"],
    fileType: json["file_type"],
    duration: json["duration"],
    fileUrl: json["file_url"],
    thumbnail: json["thumbnail"],
    avgRating: json["avg_rating"] == null ? 0.0 : double.parse(json["avg_rating"].toString()),
    ratingCount: json["rating_count"],
    commentCount: json["comment_count"],
    fieldLabel: json["field_label"],
    isHome: json["is_home"],
    isFree: json["is_free"],
    isActive: json["is_active"],
    deletedAt: json["deleted_at"],
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    category: json["category"] == null ? Category():Category.fromJson(json["category"]),
    typeId: json["type_id"],
    quizId: json["quiz_id"],
    certificateCriteria: json["certificate_criteria"],
    courseTitle: json["course_title"],
    image: json["image"],
    preview: json["preview"],
    themeColor: json["theme_color"],
    buttonColor: json["button_color"],
    teaserType: json["teaser_type"],
    teaserUrl: json["teaser_url"],
    quizLink: json["quiz_link"],
    isTop: json["is_top"],
    isQuiz: json["is_quiz"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "index": index,
    "category_id": categoryId,
    "level_id": levelId,
    "language_id": languageId,
    "provider_id": providerId,
    "tag_id": tagId,
    "title": title,
    "description": description,
    "file_type": fileType,
    "duration": duration,
    "file_url": fileUrl,
    "thumbnail": thumbnail,
    "avg_rating": avgRating,
    "rating_count": ratingCount,
    "comment_count": commentCount,
    "field_label": fieldLabel,
    "is_home": isHome,
    "is_free": isFree,
    "is_active": isActive,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "category": category?.toJson(),
    "type_id": typeId,
    "quiz_id": quizId,
    "certificate_criteria": certificateCriteria,
    "course_title": courseTitle,
    "image": image,
    "preview": preview,
    "theme_color": themeColor,
    "button_color": buttonColor,
    "teaser_type": teaserType,
    "teaser_url": teaserUrl,
    "quiz_link": quizLink,
    "is_top": isTop,
    "is_quiz": isQuiz,
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
