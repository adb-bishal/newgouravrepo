import 'dart:convert';

import 'package:flutter/material.dart';

import '../../utils/color_resource.dart';

DashboardModel dashboardModelFromJson(String str) => DashboardModel.fromJson(json.decode(str));

String dashboardModelToJson(DashboardModel data) => json.encode(data.toJson());

class DashboardModel {
  DashboardModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory DashboardModel.fromJson(Map<String, dynamic> json) => DashboardModel(
    status: json["status"],
    data:json["data"] == null?Data(): Data.fromJson(json["data"]),
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
    this.totalCourseComplete,
    this.totalTextCourse,
    this.totalAudioCourse,
    this.totalVideoCourse,
    this.badge,
    this.totalAttendedQuiz,
    this.totalQuizScore,
    this.totalPoints,
    this.goal
  });

  int? totalCourseComplete;
  int? totalTextCourse;
  int? totalAudioCourse;
  int? totalVideoCourse;
  List<Badge>? badge;
  Goal? goal;
  int? totalAttendedQuiz;
  double? totalQuizScore;
  int? totalPoints;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    totalCourseComplete: json["total_course_complete"],
    totalTextCourse: json["total_text_course"],
    totalAudioCourse: json["total_audio_course"],
    totalVideoCourse: json["total_video_course"],
    badge: json["badge"] == null ? []:List<Badge>.from(json["badge"].map((x) => Badge.fromJson(x))),
    totalAttendedQuiz: json["total_attended_quiz"],
    totalQuizScore: json["total_quiz_score"] == null ? 0.0: double.tryParse(json["total_quiz_score"].toString()),
    totalPoints: json["total_points"],
    goal: json["goal"] == null ? Goal():Goal.fromJson(json["goal"]),
  );

  Map<String, dynamic> toJson() => {
    "total_course_complete": totalCourseComplete,
    "total_text_course": totalTextCourse,
    "total_audio_course": totalAudioCourse,
    "total_video_course": totalVideoCourse,
    "badge": List<dynamic>.from(badge?.map((x) => x.toJson())??[]),
    "total_attended_quiz": totalAttendedQuiz,
    "total_quiz_score": totalQuizScore,
    "total_points": totalPoints,
    "goal": goal,
  };
}

class Badge {
  Badge({
    this.id,
    this.title,
    this.icon,
    this.target,
    this.index,
    this.color

  });

  int? id;
  String? title;
  Color? color;
  String? icon;
  String? target;
  int? index;

  factory Badge.fromJson(Map<String, dynamic> json) => Badge(
    id: json["id"],
    title: json["title"],
    color: json["color"] == null ? Colors.transparent:json["color"].runtimeType == Color ? json["color"] : ColorResource.parseHex(json["color"]),
    icon: json["icon"],
    target: json["target"],
    index: json["index"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
    "icon": icon,
    "target": target,
    "index": index,
    "color": color,

  };
}


class Goal {
  Goal({
    this.id,
    this.userId,
    this.time,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  int? userId;
  int? time;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json["id"],
    userId: json["user_id"],
    time: json["time"],
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_id": userId,
    "time": time,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}