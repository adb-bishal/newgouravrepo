// To parse this JSON data, do
//
//     final promoCodeModel = promoCodeModelFromJson(jsonString);

import 'dart:convert';

PromoCodeModel promoCodeModelFromJson(String str) => PromoCodeModel.fromJson(json.decode(str));

String promoCodeModelToJson(PromoCodeModel data) => json.encode(data.toJson());

class PromoCodeModel {
  PromoCodeModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory PromoCodeModel.fromJson(Map<String, dynamic> json) => PromoCodeModel(
    status: json["status"],
    data: json["data"] == null ? Data(): Data.fromJson(json["data"]),
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
    this.data,
    this.pagination,
  });

  List<Datum>? data;
  Pagination? pagination;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    data: json["data"] == null ? []: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pagination: json["pagination"] == null ? Pagination(): Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data?.map((x) => x.toJson())??[]),
    "pagination": pagination?.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.code,
    this.description,
    this.userId,
    this.discountType,
    this.discountValue,
    this.maxDiscount,
    this.minCartAmount,
    this.createdAt,
    this.expireAt
  });

  int? id;
  String? code;
  String? description;
  int? userId;
  String? discountType;
  int? discountValue;
  int? maxDiscount;
  int? minCartAmount;
  DateTime? createdAt;
  DateTime? expireAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    code: json["code"],
    description: json["description"],
    userId: json["user_id"],
    discountType: json["discount_type"].toString(),
    discountValue: json["discount_value"],
    maxDiscount: json["max_discount"],
    createdAt:json["created_at"] == null ?DateTime(1999): DateTime.parse(json["created_at"]),
    expireAt:json["expired_at"] == null ?DateTime(1999): DateTime.parse(json["expired_at"]),
    minCartAmount: json["min_cart_amount"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "code": code,
    "description": description,
    "user_id": userId,
    "discount_type": discountType,
    "discount_value": discountValue,
    "created_at": createdAt?.toIso8601String(),
    "expired_at": expireAt?.toIso8601String(),
    "max_discount": maxDiscount,
    "min_cart_amount": minCartAmount,
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
