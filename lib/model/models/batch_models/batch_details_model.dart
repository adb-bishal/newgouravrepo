class BatchClassViewModel {
  bool? status;
  PaginationData? data;
  String? message;

  BatchClassViewModel({this.status, this.data, this.message});

  BatchClassViewModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? PaginationData.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class PaginationData {
  List<BatchClassViewData>? data;
  Pagination? pagination;

  PaginationData({this.data, this.pagination});

  PaginationData.fromJson(Map<String, dynamic> json) {
    if (json['data'] != null) {
      data = <BatchClassViewData>[];
      json['data'].forEach((v) {
        data!.add(BatchClassViewData.fromJson(v));
      });
    }
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    return data;
  }
}

class BatchClassViewData {
  int? id;
  int? categoryId;
  int? levelId;
  int? languageId;
  int? userId;
  int? batchId;
  int? batchStartDate;
  int? index;
  String? title;
  String? description;
  String? shortDescription;
  String? startDatetime;
  String? endDatetime;
  String? batchTitle;
  int? duration;
  String? meetingLink;
  String? hostLink;
  String? moderatorLink;
  String? participantLink;
  String? image;
  String? preview;
  String? thumbnail;
  String? schedule;
  String? totalClasses;
  double? avgRating;
  int? ratingCount;
  int? commentCount;
  int? price;
  int? isHome;
  int? isFree;
  int? isLive;
  int? isDoubt;
  int? isWorkshop;
  int? isActive;
  String? recordingUrl;
  Category? category;
  Language? language;
  Level? level;
  String? createdAt;

  BatchClassViewData(
      {this.id,
      this.categoryId,
      this.levelId,
      this.languageId,
      this.userId,
      this.batchId,
      this.batchStartDate,
      this.index,
      this.title,
      this.description,
      this.shortDescription,
      this.startDatetime,
      this.endDatetime,
      this.duration,
      this.meetingLink,
      this.hostLink,
      this.batchTitle,
      this.moderatorLink,
      this.participantLink,
      this.image,
      this.preview,
      this.thumbnail,
      this.schedule,
      this.totalClasses,
      this.avgRating,
      this.ratingCount,
      this.commentCount,
      this.price,
      this.isHome,
      this.isFree,
      this.isLive,
      this.isDoubt,
      this.isWorkshop,
      this.isActive,
      this.recordingUrl,
      this.category,
      this.language,
      this.level,
      this.createdAt});

  BatchClassViewData.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    categoryId = json['category_id'];
    levelId = json['level_id'];
    languageId = json['language_id'];
    userId = json['user_id'];
    batchId = json['batch_id'];
    batchTitle = json['batch_title'];
    batchStartDate = json['batch_start_date'];
    index = json['index'];
    title = json['title'];
    description = json['description'];
    shortDescription = json['short_description'];
    startDatetime = json['start_datetime'];
    endDatetime = json['end_datetime'];
    duration = json['duration'];
    meetingLink = json['meeting_link'];
    hostLink = json['host_link'];
    moderatorLink = json['moderator_link'];
    participantLink = json['participant_link'];
    image = json['image'];
    preview = json['preview'];
    thumbnail = json['thumbnail'];
    schedule = json['schedule'];
    totalClasses = json['total_classes'];
    avgRating = json['avg_rating']*1.0;
    ratingCount = json['rating_count'];
    commentCount = json['comment_count'];
    price = json['price'];
    isHome = json['is_home'];
    isFree = json['is_free'];
    isLive = json['is_live'];
    isDoubt = json['is_doubt'];
    isWorkshop = json['is_workshop'];
    isActive = json['is_active'];
    recordingUrl = json['recording_url'];
    category =
        json['category'] != null ? Category.fromJson(json['category']) : null;
    language =
        json['language'] != null ? Language.fromJson(json['language']) : null;
    level = json['level'] != null ? Level.fromJson(json['level']) : null;
    createdAt = json['created_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['category_id'] = categoryId;
    data['level_id'] = levelId;
    data['language_id'] = languageId;
    data['user_id'] = userId;
    data['batch_id'] = batchId;
    data['batch_title'] = batchTitle;
    data['batch_start_date'] = batchStartDate;
    data['index'] = index;
    data['title'] = title;
    data['description'] = description;
    data['short_description'] = shortDescription;
    data['start_datetime'] = startDatetime;
    data['end_datetime'] = endDatetime;
    data['duration'] = duration;
    data['meeting_link'] = meetingLink;
    data['host_link'] = hostLink;
    data['moderator_link'] = moderatorLink;
    data['participant_link'] = participantLink;
    data['image'] = image;
    data['preview'] = preview;
    data['thumbnail'] = thumbnail;
    data['schedule'] = schedule;
    data['total_classes'] = totalClasses;
    data['avg_rating'] = avgRating;
    data['rating_count'] = ratingCount;
    data['comment_count'] = commentCount;
    data['price'] = price;
    data['is_home'] = isHome;
    data['is_free'] = isFree;
    data['is_live'] = isLive;
    data['is_doubt'] = isDoubt;
    data['is_workshop'] = isWorkshop;
    data['is_active'] = isActive;
    data['recording_url'] = recordingUrl;
    if (category != null) {
      data['category'] = category!.toJson();
    }
    if (language != null) {
      data['language'] = language!.toJson();
    }
    if (level != null) {
      data['level'] = level!.toJson();
    }
    data['created_at'] = createdAt;
    return data;
  }
}

class Category {
  int? id;
  String? title;

  Category({this.id, this.title});

  Category.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    return data;
  }
}

class Language {
  int? id;
  String? languageName;

  Language({this.id, this.languageName});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    languageName = json['language_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['language_name'] = languageName;
    return data;
  }
}

class Level {
  int? id;
  String? level;

  Level({this.id, this.level});

  Level.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    level = json['level'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['level'] = level;
    return data;
  }
}

class Pagination {
  int? total;
  int? count;
  int? perPage;
  int? currentPage;
  int? lastPage;

  Pagination(
      {this.total, this.count, this.perPage, this.currentPage, this.lastPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    total = json['total'];
    count = json['count'];
    perPage = json['per_page'];
    currentPage = json['current_page'];
    lastPage = json['last_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total'] = total;
    data['count'] = count;
    data['per_page'] = perPage;
    data['current_page'] = currentPage;
    data['last_page'] = lastPage;
    return data;
  }
}
