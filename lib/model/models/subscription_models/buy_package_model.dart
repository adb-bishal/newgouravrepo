// To parse this JSON data, do
//
//     final buyPackageModel = buyPackageModelFromJson(jsonString);

import 'dart:convert';

BuyPackageModel buyPackageModelFromJson(String str) => BuyPackageModel.fromJson(json.decode(str));

String buyPackageModelToJson(BuyPackageModel data) => json.encode(data.toJson());

class BuyPackageModel {
  BuyPackageModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory BuyPackageModel.fromJson(Map<String, dynamic> json) => BuyPackageModel(
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
    this.userId,
    this.subscriptionId,
    this.orderRefNo,
    this.amount,
    this.startDate,
    this.endDate,
    this.updatedAt,
    this.createdAt,
    this.id,
  });

  int? userId;
  int? subscriptionId;
  String? orderRefNo;
  int? amount;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    userId: json["user_id"],
    subscriptionId: json["subscription_id"],
    orderRefNo: json["order_ref_no"],
    amount: json["amount"],
    startDate:json["start_date"] == null ? DateTime(1999): DateTime.parse(json["start_date"]),
    endDate:  json["end_date"]   == null ? DateTime(1999): DateTime.parse(json["end_date"]  ),
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "subscription_id": subscriptionId,
    "order_ref_no": orderRefNo,
    "amount": amount,
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
