// To parse this JSON data, do
//
//     final termsAndConditionModel = termsAndConditionModelFromJson(jsonString);

import 'dart:convert';

TermsAndConditionModel termsAndConditionModelFromJson(String str) => TermsAndConditionModel.fromJson(json.decode(str));

String termsAndConditionModelToJson(TermsAndConditionModel data) => json.encode(data.toJson());

class TermsAndConditionModel {
  TermsAndConditionModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  String? data;
  String? message;

  factory TermsAndConditionModel.fromJson(Map<String, dynamic> json) => TermsAndConditionModel(
    status: json["status"],
    data: json["data"],
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data,
    "message": message,
  };
}
