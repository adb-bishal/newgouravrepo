// To parse this JSON data, do
//
//     final updateVersionModel = updateVersionModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

UpdateVersionModel updateVersionModelFromJson(String str) => UpdateVersionModel.fromJson(json.decode(str));

String updateVersionModelToJson(UpdateVersionModel data) => json.encode(data.toJson());

class UpdateVersionModel {
  RxBool? status;
  VersionData? data;
  String? message;

  UpdateVersionModel({
    this.status,
    this.data,
    this.message,
  });

  factory UpdateVersionModel.fromJson(Map<String, dynamic> json) => UpdateVersionModel(
    status: RxBool(json["status"]),
    data: json["data"] == null ? VersionData():VersionData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class VersionData {
  bool? forceUpdate;
  List<Detail>? details;

  VersionData({
    this.forceUpdate,
    this.details,
  });

  factory VersionData.fromJson(Map<String, dynamic> json) => VersionData(
    forceUpdate: json["force_update"],
    details:json["details"] == null ? []: List<Detail>.from(json["details"].map((x) => Detail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "force_update": forceUpdate,
    "details": List<dynamic>.from(details?.map((x) => x.toJson())??[]),
  };
}

class Detail {
  int? id;
  String? versionName;
  String? description;

  Detail({
    this.id,
    this.versionName,
    this.description,
  });

  factory Detail.fromJson(Map<String, dynamic> json) => Detail(
    id: json["id"],
    versionName: json["version_name"],
    description: json["description"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "version_name": versionName,
    "description": description,
  };
}
