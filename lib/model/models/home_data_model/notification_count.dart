// To parse this JSON data, do
//
//     final notificationCountModel = notificationCountModelFromJson(jsonString);

import 'dart:convert';

NotificationCountModel notificationCountModelFromJson(String str) =>
    NotificationCountModel.fromJson(json.decode(str));

String notificationCountModelToJson(NotificationCountModel data) =>
    json.encode(data.toJson());

class NotificationCountModel {
  NotificationCountModel({
    this.status,
    this.count,
    this.data,
  });

  bool? status;
  int? count;
  List<Datum>? data;

  factory NotificationCountModel.fromJson(Map<String, dynamic> json) =>
      NotificationCountModel(
        status: json["status"],
        count: json["count"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "count": count,
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
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
  Data? data;
  DateTime? readAt;
  String? createdAtFormat;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: json["data"] == null ? Data() : Data.fromJson(json["data"]),
        readAt: json["read_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["read_at"]),
        createdAtFormat: json["created_at_format"],
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
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

class Data {
  Data({
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
  dynamic icon;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
        userId: json["user_id"],
        title: json["title"],
        message: json["message"],
        url: json["url"],
        type: '${json["type"]}',
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
