// To parse this JSON data, do
//
//     final quizResultModel = quizResultModelFromJson(jsonString);

import 'dart:convert';

QuizResultModel quizResultModelFromJson(String str) => QuizResultModel.fromJson(json.decode(str));

String quizResultModelToJson(QuizResultModel data) => json.encode(data.toJson());

class QuizResultModel {
  QuizResultModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  QuizResultModelData? data;
  String? message;

  factory QuizResultModel.fromJson(Map<String, dynamic> json) => QuizResultModel(
    status: json["status"],
    data: json["data"] == null ?  QuizResultModelData():QuizResultModelData.fromJson(json["data"]),
    message: json["message"],
  );

  Map<String, dynamic> toJson() => {
    "status": status,
    "data": data?.toJson(),
    "message": message,
  };
}

class ScholarshipSlab {
  ScholarshipSlab({
    this.id,
    this.word,
    this.audioFile,
    this.slabTo,
    this.discount,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
  });

  int? id;
  String? word;
  String? audioFile;
  int? slabTo;
  int? discount;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;

  factory ScholarshipSlab.fromJson(Map<String, dynamic> json) => ScholarshipSlab(
    id: json["id"],
    word: json["word"],
    audioFile: json["audio_file"],
    slabTo: json["slab_to"],
    discount: json["discount"],
    deletedAt: json["deleted_at"],
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "word": word,
    "audio_file": audioFile,
    "slab_to": slabTo,
    "discount": discount,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
  };
}

class QuizResultModelData {
  QuizResultModelData({
    this.userId,
    this.courseId,
    this.quizId,
    this.totalQuestion,
    this.totalCorrect,
    this.totalWrong,
    this.discount,
    this.isScholarshipQuiz,
    this.isDiscountApply,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.dataFor,
    this.points,
    this.data,
    this.scholarshipSlab,
    this.result,
    this.percent
  });

  int? userId;
  dynamic courseId;
  int? quizId;
  int? totalQuestion;
  int? totalCorrect;
  int? totalWrong;
  double? percent;
  double? discount;
  int? isScholarshipQuiz;
  int? isDiscountApply;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;
  String? dataFor;
  String? result;
  String? points;
  DataData? data;
  ScholarshipSlab? scholarshipSlab;

  factory QuizResultModelData.fromJson(Map<String, dynamic> json) => QuizResultModelData(
    userId: json["user_id"],
    courseId: json["course_id"],
    quizId: json["quiz_id"],
    points: json["total_points"].toString(),
    result: json["result"],
    totalQuestion: json["total_question"],
    totalCorrect: json["total_correct"],
    totalWrong: json["total_wrong"],
    discount: json["discount"] == null ? 0.0: double.parse(json["discount"].toString()),
    percent: json["percent"] == null ? 0.0: double.parse(json["percent"].toString()),
    isScholarshipQuiz: json["is_scholarship_quiz"],
    isDiscountApply: json["is_discount_apply"],
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    createdAt: json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    id: json["id"],
    dataFor: json["for"],
    data: json["data"] == null ? DataData():DataData.fromJson(json["data"]),
    scholarshipSlab: json["scholarship_slab"] == null ? ScholarshipSlab():ScholarshipSlab.fromJson(json["scholarship_slab"]),
  );

  Map<String, dynamic> toJson() => {
    "user_id": userId,
    "course_id": courseId,
    "quiz_id": quizId,
    "total_points": points,
    "result": result,
    "total_question": totalQuestion,
    "total_correct": totalCorrect,
    "total_wrong": totalWrong,
    "discount": discount,
    "percent": percent,
    "is_scholarship_quiz": isScholarshipQuiz,
    "is_discount_apply": isDiscountApply,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
    "for": dataFor,
    "data": data?.toJson(),
    "scholarship_slab" : scholarshipSlab?.toJson()
  };
}

class DataData {
  DataData({
    this.code,
    this.description,
    this.perUserUse,
    this.discountType,
    this.discountValue,
    this.maxDiscount,
    this.minCartAmount,
    this.isActive,
    this.isScholarship,
    this.updatedAt,
    this.createdAt,
    this.id,
    this.levelId,
    this.categoryId,
    this.typeId,
    this.languageId
  });

  String? code;
  String? description;
  String? perUserUse;
  String? discountType;
  int? discountValue;
  int? categoryId;
  int? languageId;
  int? levelId;
  int? typeId;
  String? maxDiscount;
  int? minCartAmount;
  String? isActive;
  String? isScholarship;
  DateTime? updatedAt;
  DateTime? createdAt;
  int? id;

  factory DataData.fromJson(Map<String, dynamic> json) => DataData(
    code: json["code"],
    description: json["description"],
    perUserUse: json["per_user_use"],
    discountType: json["discount_type"],
    discountValue: json["discount_value"],
    categoryId: json["category_id"],
    languageId: json["language_id"],
    levelId: json["level_id"],
    typeId: json["type_id"],
    maxDiscount: json["max_discount"],
    minCartAmount: json["min_cart_amount"],
    isActive: json["is_active"],
    isScholarship: json["is_scholarship"],
    updatedAt:json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    createdAt:json["created_at"] == null ? DateTime(1999): DateTime.parse(json["created_at"]),
    id: json["id"],
  );

  Map<String, dynamic> toJson() => {
    "code": code,
    "description": description,
    "per_user_use": perUserUse,
    "discount_type": discountType,
    "discount_value": discountValue,
    "max_discount": maxDiscount,
    "category_id": categoryId,
    "language_id": languageId,
    "level_id": levelId,
    "type_id": typeId,
    "min_cart_amount": minCartAmount,
    "is_active": isActive,
    "is_scholarship": isScholarship,
    "updated_at": updatedAt?.toIso8601String(),
    "created_at": createdAt?.toIso8601String(),
    "id": id,
  };
}
