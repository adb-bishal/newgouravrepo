// To parse this JSON data, do
//
//     final wishListSaveModel = wishListSaveModelFromJson(jsonString);

import 'dart:convert';

WishListSaveModel wishListSaveModelFromJson(String str) => WishListSaveModel.fromJson(json.decode(str));

String wishListSaveModelToJson(WishListSaveModel data) => json.encode(data.toJson());

class WishListSaveModel {
  WishListSaveModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  bool? data;
  String? message;

  factory WishListSaveModel.fromJson(Map<String, dynamic> json) => WishListSaveModel(
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
