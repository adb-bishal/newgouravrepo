// To parse this JSON data, do
//
//     final offerBannerModel = offerBannerModelFromJson(jsonString);

import 'dart:convert';

OfferBannerModel offerBannerModelFromJson(String str) => OfferBannerModel.fromJson(json.decode(str));

String offerBannerModelToJson(OfferBannerModel data) => json.encode(data.toJson());

class OfferBannerModel {
  OfferBannerModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  List<Datum>? data;
  String? message;

  factory OfferBannerModel.fromJson(Map<String, dynamic> json) => OfferBannerModel(
    status: json["status"],
    data:json["data"] == null ? []: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": List<dynamic>.from(data?.map((x) => x.toJson())??[]),
    "message": message,
  };
}

class Datum {
  Datum({
    this.id,
    this.title,
    this.description,
    this.icon,
    this.iconTitle,
    this.image,
    this.isActive,
    this.index,
  });

  int? id;
  String? title;
  String? description;
  String? icon;
  String? iconTitle;
  String? image;
  int? isActive;
  int? index;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    title: json["title"],
    description: json["description"],
    icon: json["icon"],
    iconTitle: json["icon_title"],
    image: json["image"],
    isActive: json["is_active"],
    index: json["index"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "description": description,
    "icon": icon,
    "icon_title": iconTitle,
    "image": image,
    "is_active": isActive,
    "index": index,
  };
}
