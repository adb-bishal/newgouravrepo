// To parse this JSON data, do
//
//     final tagsModel = tagsModelFromJson(jsonString);

import 'dart:convert';

TagsModel? tagsModelFromJson(String str) => TagsModel.fromJson(json.decode(str));

String tagsModelToJson(TagsModel? data) => json.encode(data!.toJson());

class TagsModel {
  TagsModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  List<Datum?>? data;
  String? message;

  factory TagsModel.fromJson(Map<String, dynamic> json) => TagsModel(
    status: json["status"],
    data: json["data"] == null ? [] : List<Datum?>.from(json["data"]!.map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x!.toJson())),
    "message": message,
  };
}

class Datum {
  Datum({
    this.id,
    this.tagName,
  });

  int? id;
  String? tagName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    tagName: json["tag_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "tag_name": tagName,
  };
}
