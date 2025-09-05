// To parse this JSON data, do
//
//     final notificationModel = notificationModelFromJson(jsonString);

import 'dart:convert';

NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));

String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());

class NotificationModel {
  NotificationModel({
    this.status,
    this.data,
  });

  bool? status;
  NotificationModelData? data;

  factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
    status: json["status"],
    data:json["data"] == null ? NotificationModelData(): NotificationModelData.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
  };
}

class NotificationModelData {
  NotificationModelData({
    this.data,
    this.pagination,
  });

  List<Datum>? data;
  Pagination? pagination;

  factory NotificationModelData.fromJson(Map<String, dynamic> json) => NotificationModelData(
    data: json["data"] == null ? []: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
    this.notifiableType,
    this.notifiableId,
    this.data,
    this.readAt,
    this.createdAtFormat,
    this.createdAt,
  });

  String? id;
  String? type;
  String? notifiableType;
  int? notifiableId;
  DatumData? data;
  DateTime? readAt;
  String? createdAtFormat;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    type: json["type"],
    notifiableType: json["notifiable_type"],
    notifiableId: json["notifiable_id"],
    data: json["data"] == null ? DatumData():DatumData.fromJson(json["data"]),
    readAt:json["read_at"] == null ? DateTime(1999): DateTime.parse(json["read_at"]),
    createdAtFormat: json["created_at_format"],
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "notifiable_type": notifiableType,
    "notifiable_id": notifiableId,
    "data": data?.toJson(),
    "read_at": readAt?.toIso8601String(),
    "created_at_format": createdAtFormat,
    "created_at": createdAt?.toIso8601String(),
  };
}

class DatumData {
  DatumData({
    this.userId,
    this.title,
    this.message,
    this.url,
    this.type,
    this.icon,
  });

  int? userId;
  String? title;
  String? message;
  String? url;
  String? type;
  String? icon;

  factory DatumData.fromJson(Map<String, dynamic> json) => DatumData(
    userId: json["user_id"],
    title: json["title"],
    message: json["message"],
    url: json["url"],
    type: json["type"],
    icon: json["icon"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "title": title,
    "message": message,
    "url": url,
    "type": type,
    "icon": icon,
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
