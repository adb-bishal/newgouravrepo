// To parse this JSON data, do
//
//     final scalpDataModel = scalpDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

ScalpDataModel scalpDataModelFromJson(String str) => ScalpDataModel.fromJson(json.decode(str));

String scalpDataModelToJson(ScalpDataModel data) => json.encode(data.toJson());

class ScalpDataModel {
  ScalpDataModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory ScalpDataModel.fromJson(Map<String, dynamic> json) => ScalpDataModel(
    status: json["status"],
    data:json["data"] == null ? Data(): Data.fromJson(json["data"]),
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
    this.title,
    this.thumbnail,
    this.videoUrl,
    this.fileType,
    this.totalLikes,
    this.totalComment,
    this.isFree,
    this.category,
    this.createdAt,
    this.description,
    this.totalShares,
    this.isLiked
  });

  int? id;
  String? title;
  String? thumbnail;
  String? videoUrl;
  Category? category;
  String? fileType;
  RxString? totalLikes;
  RxString? totalComment;
  int? isFree;
  RxInt? isLiked;
  String? description;
  RxString? totalShares;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"]??0,
    title: json["title"]??"",
    thumbnail: json["thumbnail"]??"",
    category: json["category"] == null ? Category():Category.fromJson(json["category"]),
    videoUrl: json["video_url"]??"",
    fileType: json["file_type"]??"",
    totalLikes: json["total_likes"] == null ? "0".obs:json["total_likes"].toString().obs,
    totalComment: json["comment_count"] == null ? "0".obs:json["comment_count"].toString().obs,
    description: json["description"]??"",
    totalShares: json["total_shares"] == null ? "0".obs:json["total_shares"].toString().obs,
    isFree: json["is_free"]??0,
    isLiked: json["is_liked"] == null ? 0.obs:int.parse((json["is_liked"]??"0").toString()).obs,
    createdAt: DateTime.tryParse(json["created_at"]??"1999"),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "thumbnail": thumbnail,
    "category": category?.toJson(),
    "video_url": videoUrl,
    "file_type": fileType,
    "is_liked": isLiked?.value,
    "total_likes": totalLikes,
    "comment_count": totalComment,
    "is_free": isFree,
    "description": description,
    "total_shares": totalShares,
    "created_at": createdAt?.toIso8601String(),
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
