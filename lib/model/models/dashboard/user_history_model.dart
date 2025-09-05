// To parse this JSON data, do
//
//     final userHistoryModel = userHistoryModelFromJson(jsonString);

import 'dart:convert';

UserHistoryModel userHistoryModelFromJson(String str) => UserHistoryModel.fromJson(json.decode(str));

String userHistoryModelToJson(UserHistoryModel data) => json.encode(data.toJson());

class UserHistoryModel {
  UserHistoryModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory UserHistoryModel.fromJson(Map<String, dynamic> json) => UserHistoryModel(
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
    this.startDate,
    this.endDate,
    this.userAverageTime,
    this.maxTime
  });

  DateTime? startDate;
  DateTime? endDate;
  List<UserAverageTime>? userAverageTime;
  int? maxTime;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    startDate:json["start_date"] == null ? DateTime(1999):DateTime.parse(json["start_date"]),
    endDate:  json["end_date"]   == null ? DateTime(1999):DateTime.parse(json["end_date"]),
    userAverageTime:json["user_average_time"] == null ? []: List<UserAverageTime>.from(json["user_average_time"].map((x) => UserAverageTime.fromJson(x))),
    maxTime:json["max_time"]??0,
  );

  Map<String, dynamic> toJson() => {
    "start_date": startDate?.toIso8601String(),
    "end_date": endDate?.toIso8601String(),
    "max_time": maxTime,
    "user_average_time": List<dynamic>.from(userAverageTime?.map((x) => x.toJson())??[]),
  };
}

class UserAverageTime {
  UserAverageTime({
    this.id,
    this.userId,
    this.user,
    this.date,
    this.avgTime,
  });

  int? id;
  int? userId;
  User? user;
  DateTime? date;
  String? avgTime;

  factory UserAverageTime.fromJson(Map<String, dynamic> json) => UserAverageTime(
    id: json["id"],
    userId: json["user_id"],
    user:json["user"] == null ? User(): User.fromJson(json["user"]),
    date:json["date"] == null ? DateTime(1999): DateTime.parse(json["date"]),
    avgTime: json["avg_time"].toString(),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "user": user?.toJson(),
    "date": date?.toIso8601String(),
    "avg_time": avgTime,
  };
}

class User {
  User({
    this.id,
    this.name,
    this.mobileNo,
    this.email,
  });

  int? id;
  String? name;
  String? mobileNo;
  String? email;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    mobileNo: json["mobile_no"],
    email: json["email"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "mobile_no": mobileNo,
    "email": email,
  };
}
