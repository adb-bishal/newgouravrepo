import 'dart:convert';

SingleCourseModel singalCourseModelFromJson(String str) => SingleCourseModel.fromJson(json.decode(str));

String singalCourseModelToJson(SingleCourseModel data) => json.encode(data.toJson());

class SingleCourseModel {
  SingleCourseModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory SingleCourseModel.fromJson(Map<String, dynamic> json) => SingleCourseModel(
    status: json["status"],
    data: json["data"] ==null ? Data(): Data.fromJson(json["data"]),
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
    data: json["data"] == null ? []: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pagination: json["pagination"] == null ? Pagination(): Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data?.map((x) => x.toJson())??[]),
    "pagination": pagination?.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.categoryId,
    this.levelId,
    this.languageId,
    this.providerId,
    this.tagId,
    this.title,
    this.image,
    this.description,
    this.fileUrl,
    this.thumbnail,
    this.rating,
    this.isFree,
    this.isActive,
    this.wishlists,
    this.category,
    this.tag,
    this.fileType,
    this.provider,
    this.duration,
    this.createdAt,
    this.isWishlist,
    this.courseId,
    this.topicTitle,
    this.courseContent,
    this.banner,
    this.index,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  int? categoryId;
  int? levelId;
  int? languageId;
  int? providerId;
  int? tagId;
  String? title;
  String? image;
  String? description;
  String? fileUrl;
  String? fileType;
  String? thumbnail;
  double? rating;
  dynamic duration;
  DateTime? createdAt;
  int? isFree;
  int? isWishlist;
  int? isActive;
  List<Wishlist>? wishlists;
  Category? category;
  Tag? tag;
  Provider? provider;
  int? courseId;
  String? topicTitle;
  String? courseContent;
  String? banner;
  int? index;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    categoryId: json["category_id"],
    levelId: json["level_id"],
    languageId: json["language_id"],
    providerId: json["provider_id"],
    duration: json["duration"],
    createdAt:json["created_at"] ==null ? DateTime(1999): DateTime.parse(json["created_at"]),
    tagId: json["tag_id"],
    isWishlist: json["is_wishlist"],
    title: json["title"],
    image: json["image"],
    description: json["description"],
    fileUrl: json["file_url"],
    fileType: json["file_type"],
    thumbnail: json["thumbnail"],
    rating: json["avg_rating"] == null ? 0.0:double.parse(json["avg_rating"].toString()),
    isFree: json["is_free"],
    isActive: json["is_active"],
    wishlists:json["wishlists"] ==null?[]: List<Wishlist>.from(json["wishlists"].map((x) => Wishlist.fromJson(x))),
    category:json["category"] == null ? Category(): Category.fromJson(json["category"]),
    tag: json["tag"] == null ? Tag():Tag.fromJson(json["tag"]),
    provider:json["provider"] == null ? Provider(): Provider.fromJson(json["provider"]),
    courseId: json["course_id"],
    topicTitle: json["topic_title"],
    courseContent: json["course_content"],
    banner: json["banner"],
    index: json["index"],
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "level_id": levelId,
    "language_id": languageId,
    "provider_id": providerId,
    "tag_id": tagId,
    "is_wishlist": isWishlist,
    "title": title,
    "duration":duration,
    "created_at":createdAt?.toIso8601String(),
    "image": image,
    "description": description,
    "file_url": fileUrl,
    "file_type": fileType,
    "thumbnail": thumbnail,
    "avg_rating": rating,
    "is_free": isFree,
    "is_active": isActive,
    "wishlists": List<dynamic>.from(wishlists?.map((x) => x.toJson())??[]),
    "category": category?.toJson(),
    "tag": tag?.toJson(),
    "provider": provider?.toJson(),
    "course_id": courseId,
    "topic_title": topicTitle,
    "course_content": courseContent,
    "banner": banner,
    "index": index,
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
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
  dynamic description;
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
    createdAt:json["created_at"] ==null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] ==null ? DateTime(1999): DateTime.parse(json["updated_at"]),
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
    createdAt: json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
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
    createdAt: json["created_at"] == null ? DateTime(1999):  DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999):  DateTime.parse(json["updated_at"]),
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

class Wishlist {
  Wishlist({
    this.id,
    this.type,
    this.userId,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? type;
  int? userId;
  String? modelType;
  int? modelId;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Wishlist.fromJson(Map<String, dynamic> json) => Wishlist(
    id: json["id"],
    type: json["type"],
    userId: json["user_id"],
    modelType: json["model_type"],
    modelId: json["model_id"],
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "user_id": userId,
    "model_type": modelType,
    "model_id": modelId,
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
