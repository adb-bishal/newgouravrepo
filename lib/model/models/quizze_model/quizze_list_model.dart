// To parse this JSON data, do
//
//     final quizzeListModel = quizzeListModelFromJson(jsonString);

import 'dart:convert';

QuizListModel quizzeListModelFromJson(String str) => QuizListModel.fromJson(json.decode(str));

String quizzeListModelToJson(QuizListModel data) => json.encode(data.toJson());

class QuizListModel {
  QuizListModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory QuizListModel.fromJson(Map<String, dynamic> json) => QuizListModel(
    status: json["status"],
    data: json["data"] == null? Data():Data.fromJson(json["data"]),
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
    data: json["data"] == null? []:List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pagination: json["pagination"] == null ? Pagination():Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data?.map((x) => x.toJson())??[]),
    "pagination": pagination?.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.categoryId,
    this.languageId,
    this.title,
    this.banner,
    this.quizTimer,
    this.isScholarship,
    this.category,
    this.language,
    this.isAttempted
  });

  int? id;
  int? categoryId;
  int? languageId;
  int? isAttempted;
  String? title;
  String? banner;
  int? quizTimer;
  int? isScholarship;
  Category? category;
  Language? language;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    categoryId: json["category_id"],
    languageId: json["language_id"],
    title: json["title"],
    isAttempted: json["is_attempted"],
    banner: json["banner"],
    quizTimer: json["quiz_timer"],
    isScholarship: json["is_scholarship"],
    category: json["category"] == null ? Category():Category.fromJson(json["category"]),
    language: json["language"] == null ? Language():Language.fromJson(json["language"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "language_id": languageId,
    "title": title,
    "banner": banner,
    "quiz_timer": quizTimer,
    "is_scholarship": isScholarship,
    "category": category?.toJson(),
    "language": language?.toJson(),
  };
}

class Category {
  Category({
    this.id,
    this.title,
  });

  int? id;
  String? title;

  factory Category.fromJson(Map<String, dynamic> json) => Category(
    id: json["id"],
    title: json["title"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "title": title,
  };
}

class Language {
  Language({
    this.id,
    this.languageName,
  });

  int? id;
  String? languageName;

  factory Language.fromJson(Map<String, dynamic> json) => Language(
    id: json["id"],
    languageName: json["language_name"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "language_name": languageName,
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
