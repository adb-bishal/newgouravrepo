// To parse this JSON data, do
//
//     final languageModel = languageModelFromJson(jsonString);

import 'dart:convert';

LanguageModel? languageModelFromJson(String str) => LanguageModel.fromJson(json.decode(str));

String languageModelToJson(LanguageModel? data) => json.encode(data!.toJson());

class LanguageModel {
  LanguageModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  List<Datum?>? data;
  String? message;

  factory LanguageModel.fromJson(Map<String, dynamic> json) => LanguageModel(
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
    this.languageName,
  });

  int? id;
  String? languageName;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    languageName: json["language_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language_name": languageName,
  };
}
