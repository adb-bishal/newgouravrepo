// To parse this JSON data, do
//
//     final applyOfferModel = applyOfferModelFromJson(jsonString);

import 'dart:convert';

ApplyOfferModel applyOfferModelFromJson(String str) => ApplyOfferModel.fromJson(json.decode(str));

String applyOfferModelToJson(ApplyOfferModel data) => json.encode(data.toJson());

class ApplyOfferModel {
  ApplyOfferModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory ApplyOfferModel.fromJson(Map<String, dynamic> json) => ApplyOfferModel(
    status: json["status"],
    data: json["data"] == null ? Data():Data.fromJson(json["data"]),
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
    this.id,
    this.code,
    this.description,
    this.userId,
    this.perUserUse,
    this.discountType,
    this.discountValue,
    this.maxDiscount,
    this.used,
    this.minCartAmount,
    this.isScholarship,
    this.isSpecialSale,
    this.isAuto,
    this.isActive,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.discountedAmount,
    this.discount,
  });

  int? id;
  String? code;
  String? description;
  dynamic userId;
  int? perUserUse;
  String? discountType;
  double? discountValue;
  double? maxDiscount;
  int? used;
  int? minCartAmount;
  int? isScholarship;
  int? isSpecialSale;
  int? isAuto;
  int? isActive;
  DateTime? expiredAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  String? discountedAmount;
  double? discount;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    code: json["code"],
    description: json["description"],
    userId: json["user_id"],
    perUserUse: json["per_user_use"],
    discountType: json["discount_type"],
    discountValue: json["discount_value"] == null ? 0.0 : double.parse((json["discount_value"].toString())),
    maxDiscount: json["max_discount"] == null ? 0.0 : double.parse(json["max_discount"].toString()),
    used: json["used"],
    minCartAmount: json["min_cart_amount"],
    isScholarship: json["is_scholarship"],
    isSpecialSale: json["is_special_sale"],
    isAuto: json["is_auto"],
    isActive: json["is_active"],
    expiredAt:json["expired_at"] == null ? DateTime(1999): DateTime.parse(json["expired_at"]),
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
    discountedAmount: json["discounted_amount"],
    discount: json["discount"] == null ? 0.0:double.tryParse(json["discount"].toString()),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "description": description,
    "user_id": userId,
    "per_user_use": perUserUse,
    "discount_type": discountType,
    "discount_value": discountValue,
    "max_discount": maxDiscount,
    "used": used,
    "min_cart_amount": minCartAmount,
    "is_scholarship": isScholarship,
    "is_special_sale": isSpecialSale,
    "is_auto": isAuto,
    "is_active": isActive,
    "expired_at": expiredAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
    "discounted_amount": discountedAmount,
    "discount": discount,
  };
}
