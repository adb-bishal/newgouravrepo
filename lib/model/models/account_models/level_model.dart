// To parse this JSON data, do
//
//     final levelModel = levelModelFromJson(jsonString);

import 'dart:convert';

LevelModel? levelModelFromJson(String str) => LevelModel.fromJson(json.decode(str));

String levelModelToJson(LevelModel? data) => json.encode(data!.toJson());

class LevelModel {
  LevelModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  List<Datum?>? data;
  String? message;

  factory LevelModel.fromJson(Map<String, dynamic> json) => LevelModel(
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
    this.level,
  });

  int? id;
  String? level;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    level: json["level"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "level": level,
  };
}
