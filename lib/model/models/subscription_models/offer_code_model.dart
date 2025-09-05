// To parse this JSON data, do
//
//     final offerCodeModel = offerCodeModelFromJson(jsonString);

import 'dart:convert';

OfferCodeModel offerCodeModelFromJson(String str) =>
    OfferCodeModel.fromJson(json.decode(str));

String offerCodeModelToJson(OfferCodeModel data) => json.encode(data.toJson());

class OfferCodeModel {
  OfferCodeModel({
    this.status,
    this.data,
    this.message,
    this.specialSalePromo,
  });

  bool? status;
  Data? data;
  String? message;
  List<SpecialSalePromo>? specialSalePromo;

  factory OfferCodeModel.fromJson(Map<String, dynamic> json) => OfferCodeModel(
        status: json["status"],
        data: json["data"] == null ? Data() : Data.fromJson(json["data"]),
        message: json["message"],
        specialSalePromo: json["special_sale_promo"] == null
            ? null
            : List<SpecialSalePromo>.from(json["special_sale_promo"]
                .map((x) => SpecialSalePromo.fromJson(x))),
      );

  factory OfferCodeModel.fromJson2(Map<String, dynamic> json) => OfferCodeModel(
        status: json["status"],
        data: json["promocodes"] == null
            ? Data()
            : Data.fromJson2(json["promocodes"]),
        message: "",
        specialSalePromo: json["special_sale_promo"] == null
            ? null
            : List<SpecialSalePromo>.from(json["special_sale_promo"]
                .map((x) => SpecialSalePromo.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": data?.toJson(),
        "message": message,
        "special_sale_promo": specialSalePromo == null
            ? null
            : List<dynamic>.from(specialSalePromo!.map((x) => x.toJson())),
      };
}

class SpecialSalePromo {
  SpecialSalePromo({
    this.id,
    this.code,
    this.description,
    this.userId,
    this.perUserUse,
    this.discountType,
    this.discountValue,
    this.used,
    this.minCartAmount,
    this.isScholarship,
    this.isSpecialSale,
    this.isDisplay,
    this.isAuto,
    this.isActive,
    this.expiredAt,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  String? code;
  String? description;
  dynamic userId;
  int? perUserUse;
  String? discountType;
  int? discountValue;
  int? used;
  int? minCartAmount;
  int? isScholarship;
  int? isSpecialSale;
  int? isDisplay;
  int? isAuto;
  int? isActive;
  DateTime? expiredAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory SpecialSalePromo.fromJson(Map<String, dynamic> json) =>
      SpecialSalePromo(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        userId: json["user_id"],
        perUserUse: json["per_user_use"],
        discountType: json["discount_type"],
        discountValue: json["discount_value"],
        used: json["used"],
        minCartAmount: json["min_cart_amount"],
        isScholarship: json["is_scholarship"],
        isSpecialSale: json["is_special_sale"],
        isDisplay: json["is_display"],
        isAuto: json["is_auto"],
        isActive: json["is_active"],
        expiredAt: json["expired_at"] == null
            ? null
            : DateTime.parse(json["expired_at"]),
        createdAt: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null
            ? null
            : DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "user_id": userId,
        "per_user_use": perUserUse,
        "discount_type": discountType,
        "discount_value": discountValue,
        "used": used,
        "min_cart_amount": minCartAmount,
        "is_scholarship": isScholarship,
        "is_special_sale": isSpecialSale,
        "is_display": isDisplay,
        "is_auto": isAuto,
        "is_active": isActive,
        "expired_at": expiredAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "deleted_at": deletedAt,
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
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null
            ? Pagination()
            : Pagination.fromJson(json["pagination"]),
      );
  factory Data.fromJson2(Map<String, dynamic> json) => Data(
        data: json["promo"] == null
            ? []
            : List<Datum>.from(json["promo"].map((x) => Datum.fromJson(x))),
        pagination: json["pagination"] == null
            ? Pagination()
            : Pagination.fromJson(json["pagination"]),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        "pagination": pagination?.toJson(),
      };
}

class Datum {
  Datum({
    this.id,
    this.code,
    this.used,
    this.description,
    this.userId,
    this.discountType,
    this.discountValue,
    this.maxDiscount,
    this.minCartAmount,
    this.isScholarship,
    this.isSpecialSale,
    this.expiredAt,
    this.createdAt,
  });

  int? id;
  int? used;
  String? code;
  String? description;
  dynamic userId;
  String? discountType;
  int? discountValue;
  int? maxDiscount;
  int? minCartAmount;
  int? isScholarship;
  int? isSpecialSale;
  DateTime? expiredAt;
  DateTime? createdAt;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        code: json["code"],
        description: json["description"],
        // userId: json["user_id"],
        used: json["used"],
        discountType: json["discount_type"],
        discountValue: json["discount_value"],
        // maxDiscount: json["max_discount"],
        minCartAmount: json["min_cart_amount"],
        isScholarship: json["is_scholarship"],
        isSpecialSale: json["is_special_sale"],
        expiredAt: json["expired_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["expired_at"]),
        createdAt: json["created_at"] == null
            ? DateTime(1999)
            : DateTime.parse(json["created_at"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "code": code,
        "description": description,
        "user_id": userId,
        "discount_type": discountType,
        "discount_value": discountValue,
        "max_discount": maxDiscount,
        "min_cart_amount": minCartAmount,
        "is_scholarship": isScholarship,
        "is_special_sale": isSpecialSale,
        "expired_at": expiredAt?.toIso8601String(),
        "created_at": createdAt?.toIso8601String(),
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
