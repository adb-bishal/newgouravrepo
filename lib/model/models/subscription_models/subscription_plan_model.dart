/// To parse this JSON data, do
/// final subscriptionTypeModel = subscriptionTypeModelFromJson(jsonString);

import 'dart:convert';

SubscriptionTypeModel subscriptionTypeModelFromJson(String str) =>
    SubscriptionTypeModel.fromJson(json.decode(str));

String subscriptionTypeModelToJson(SubscriptionTypeModel data) =>
    json.encode(data.toJson());

class SubscriptionTypeModel {
  SubscriptionTypeModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  List<Datum>? data;
  String? message;

  factory SubscriptionTypeModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionTypeModel(
        status: json["status"],
        data: json["data"] == null
            ? []
            : List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
        message: json["message"],
      );

  Map<String, dynamic> toJson() => {
        "status": status,
        "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        "message": message,
      };
}

class Datum {
  int? id;
  int? index;
  String? title;
  String? description;
  int? price;
  int? days;
  int? batchId;
  int? superSub;
  String? subscriptionType;
  int? isStandard;
  int? isActive;
  String? createdAt;
  String? updatedAt;
  String? deletedAt;
  List<SubBatch>? subBatch;
  int? disable;

  Datum({
    this.id,
    this.index,
    this.title,
    this.description,
    this.price,
    this.days,
    this.batchId,
    this.superSub,
    this.subscriptionType,
    this.isStandard,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.subBatch,
    this.disable,
  });

  Datum.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    index = json['index'];
    title = json['title'];
    description = json['description'];
    price = json['price'];
    days = json['days'];
    batchId = json['batch_id'];
    superSub = json['super_subscription'];
    subscriptionType = json['subscription_type'];
    isStandard = json['is_standard'];
    isActive = json['is_active'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    if (json['sub_batch'] != null) {
      subBatch = <SubBatch>[];
      json['sub_batch'].forEach((v) {
        subBatch!.add(SubBatch.fromJson(v));
      });
    }
    disable = json['disable'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['index'] = index;
    data['title'] = title;
    data['description'] = description;
    data['price'] = price;
    data['days'] = days;
    data['batch_id'] = batchId;
    data['super_subscription'] = superSub;
    data['subscription_type'] = subscriptionType;
    data['is_standard'] = isStandard;
    data['is_active'] = isActive;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['disable'] = disable;
    if (subBatch != null) {
      data['sub_batch'] = subBatch!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SubBatch {
  int? id;
  String? startDate;

  SubBatch({this.id, this.startDate});

  SubBatch.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    startDate = json['start_date'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['start_date'] = startDate;
    return data;
  }
}
