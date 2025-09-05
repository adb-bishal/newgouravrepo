// To parse this JSON data, do
//
//     final serviceDataModel = serviceDataModelFromJson(jsonString);

import 'dart:convert';

ServiceDataModel serviceDataModelFromJson(String str) => ServiceDataModel.fromJson(json.decode(str));

String serviceDataModelToJson(ServiceDataModel data) => json.encode(data.toJson());

class ServiceDataModel {
  ServiceDataModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory ServiceDataModel.fromJson(Map<String, dynamic> json) => ServiceDataModel(
    status: json["status"],
    data:json["data"]== null? Data(): Data.fromJson(json["data"]),
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
    this.razorpayAppId,
    this.razorpayAppSecret,
    this.kommunicateAppId,
    this.titleTwo,
    this.typeTwo,this.titleOne,this.typeOne

  });

  String? razorpayAppId;
  String? razorpayAppSecret;
  String? kommunicateAppId;
  String? titleOne;
  String? typeOne;
  String? titleTwo;
  String? typeTwo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    razorpayAppId: json["razorpay_app_id"],
    razorpayAppSecret: json["razorpay_app_secret"],
    kommunicateAppId: json["kommunicate_app_id"],
    typeOne: json["free_option_trading_type_one"],
    titleOne: json["free_option_trading_title_one"],
    typeTwo: json["free_option_trading_type_two"],
    titleTwo: json["free_option_trading_title_two"],
  );

  Map<String, dynamic> toJson() => {
    "razorpay_app_id": razorpayAppId,
    "razorpay_app_secret": razorpayAppSecret,
    "kommunicate_app_id": kommunicateAppId,
    "free_option_trading_title_one": titleOne,
    "free_option_trading_type_one": typeOne,
    "free_option_trading_title_two": titleTwo,
    "free_option_trading_type_two": typeTwo
  };
}
