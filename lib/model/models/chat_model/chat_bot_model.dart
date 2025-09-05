import 'dart:convert';

ChatBotData chatBotDataFromJson(String str) => ChatBotData.fromJson(json.decode(str));

String chatBotDataToJson(ChatBotData data) => json.encode(data.toJson());

class ChatBotData {
  ChatBotData({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory ChatBotData.fromJson(Map<String, dynamic> json) => ChatBotData(
    status: json["status"],
    data: Data.fromJson(json["data"]),
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
    data: json["data"] == null ? []: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
    pagination: json["pagination"] == null ? Pagination(): Pagination.fromJson(json["pagination"]),
  );

  Map<String, dynamic> toJson() => {
    "data": List<dynamic>.from(data!.map((x) => x.toJson())),
    "pagination": pagination?.toJson(),
  };
}

class Datum {
  Datum({
    this.id,
    this.question,
    this.type,
    this.options,
  });

  int? id;
  String? question;
  String? type;
  String? options;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
    id: json["id"],
    question: json["question"],
    type: json["type"],
    options: json["options"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "question": question,
    "type": type,
    "options": options,
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
