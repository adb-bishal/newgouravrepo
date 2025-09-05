// To parse this JSON data, do
//
//     final courseHistoryModel = courseHistoryModelFromJson(jsonString);

import 'dart:convert';

CourseHistoryModel courseHistoryModelFromJson(String str) => CourseHistoryModel.fromJson(json.decode(str));

String courseHistoryModelToJson(CourseHistoryModel data) => json.encode(data.toJson());

class CourseHistoryModel {
  CourseHistoryModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  List<Datum>? data;
  String? message;

  factory CourseHistoryModel.fromJson(Map<String, dynamic> json) => CourseHistoryModel(
    status: json["status"],
    data: json["data"] == null ? []:List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
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
    this.courseId,
    this.userId,
    this.courseCompleted,
    this.quizCompleted,
    this.createdAt,
    this.updatedAt,
    this.userCourseCourseDetails,
    this.course,
  });

  int? id;
  int? courseId;
  int? userId;
  int? courseCompleted;
  int? quizCompleted;
  DateTime? createdAt;
  DateTime? updatedAt;
  List<UserCourseCourseDetail>? userCourseCourseDetails;
  Course? course;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    courseId: json["course_id"],
    userId: json["user_id"],
    courseCompleted: json["course_completed"],
    quizCompleted: json["quiz_completed"],
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999):DateTime.parse(json["updated_at"]),
    userCourseCourseDetails: json["user_course_course_details"] == null ? []:List<UserCourseCourseDetail>.from(json["user_course_course_details"].map((x) => UserCourseCourseDetail.fromJson(x))),
    course: json["course"] == null ? Course():Course.fromJson(json["course"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_id": courseId,
    "user_id": userId,
    "course_completed": courseCompleted,
    "quiz_completed": quizCompleted,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "user_course_course_details": List<dynamic>.from(userCourseCourseDetails?.map((x) => x.toJson())??[]),
    "course": course?.toJson(),
  };
}

class Course {
  Course({
    this.id,
    this.courseTitle,
  });

  int? id;
  String? courseTitle;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    courseTitle: json["course_title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "course_title": courseTitle,
  };
}

class UserCourseCourseDetail {
  UserCourseCourseDetail({
    this.id,
    this.userCourseId,
    this.courseDetailsId,
    this.isComplete,
  });

  int? id;
  int? userCourseId;
  int? courseDetailsId;
  int? isComplete;

  factory UserCourseCourseDetail.fromJson(Map<String, dynamic> json) => UserCourseCourseDetail(
    id: json["id"],
    userCourseId: json["user_course_id"],
    courseDetailsId: json["course_details_id"],
    isComplete: json["is_complete"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "user_course_id": userCourseId,
    "course_details_id": courseDetailsId,
    "is_complete": isComplete,
  };
}
