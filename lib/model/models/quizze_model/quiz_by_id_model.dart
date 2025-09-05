// To parse this JSON data, do
//
//     final quizByIdModel = quizByIdModelFromJson(jsonString);

import 'dart:convert';

QuizByIdModel quizByIdModelFromJson(String str) => QuizByIdModel.fromJson(json.decode(str));

String quizByIdModelToJson(QuizByIdModel data) => json.encode(data.toJson());

class QuizByIdModel {
  QuizByIdModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory QuizByIdModel.fromJson(Map<String, dynamic> json) => QuizByIdModel(
    status: json["status"],
    data: json["data"] == null? Data(): Data.fromJson(json["data"]),
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
    this.id,
    this.categoryId,
    this.languageId,
    this.title,
    this.description,
    this.banner,
    this.quizTimer,
    this.isActive,
    this.isScholarship,
    this.quizQuestions,
    this.category,
    this.language,
    this.scholarshipDiscount,
    this.createdAt,
  });

  int? id;
  int? categoryId;
  int? languageId;
  String? title;
  String? description;
  String? banner;
  int? quizTimer;
  int? isActive;
  int? isScholarship;
  List<QuizQuestion>? quizQuestions;
  Category? category;
  Language? language;
  int? scholarshipDiscount;
  DateTime? createdAt;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    id: json["id"],
    categoryId: json["category_id"],
    languageId: json["language_id"],
    title: json["title"],
    description: json["description"],
    banner: json["banner"],
    quizTimer: json["quiz_timer"],
    isActive: json["is_active"],
    isScholarship: json["is_scholarship"],
    quizQuestions:json["quiz_questions"] == null ? []: List<QuizQuestion>.from(json["quiz_questions"].map((x) => QuizQuestion.fromJson(x))),
    category:json["category"] == null?Category(): Category.fromJson(json["category"]),
    language:json["language"] == null?Language(): Language.fromJson(json["language"]),
    scholarshipDiscount: json["scholarship_discount"],
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "category_id": categoryId,
    "language_id": languageId,
    "title": title,
    "description": description,
    "banner": banner,
    "quiz_timer": quizTimer,
    "is_active": isActive,
    "is_scholarship": isScholarship,
    "quiz_questions": List<dynamic>.from(quizQuestions?.map((x) => x.toJson())??[]),
    "category": category?.toJson(),
    "language": language?.toJson(),
    "scholarship_discount": scholarshipDiscount,
    "created_at": createdAt?.toIso8601String(),
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

class QuizQuestion {
  QuizQuestion({
    this.id,
    this.quizId,
    this.question,
    this.option1,
    this.option2,
    this.option3,
    this.option4,
    this.correctAns,
    this.image,
    this.points,
    this.isCorrect,
    this.ans
  });

  int? id;
  int? quizId;
  String? question;
  String? option1;
  String? option2;
  String? option3;
  String? option4;
  String? correctAns;
  String? image;
  bool? isCorrect;
  String? ans;
  int? points;

  factory QuizQuestion.fromJson(Map<String, dynamic> json) => QuizQuestion(
    id: json["id"],
    quizId: json["quiz_id"],
    question: json["question"],
    option1: json["option_1"],
    option2: json["option_2"],
    option3: json["option_3"],
    option4: json["option_4"],
    correctAns: json["correct_ans"],
    image: json["image"],
    ans: json["ans"],
    isCorrect: json["is_correct"],
    points: json["points"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "quiz_id": quizId,
    "question": question,
    "option_1": option1,
    "option_2": option2,
    "option_3": option3,
    "option_4": option4,
    "correct_ans": correctAns,
    "image": image,
    "is_correct": isCorrect,
    "ans": ans,
    "points": points,
  };
}
