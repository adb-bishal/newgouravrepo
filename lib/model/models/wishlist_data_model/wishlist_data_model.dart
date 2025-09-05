// To parse this JSON data, do
//
//     final wishListDataModel = wishListDataModelFromJson(jsonString);

import 'dart:convert';

WishListDataModel wishListDataModelFromJson(String str) => WishListDataModel.fromJson(json.decode(str));

String wishListDataModelToJson(WishListDataModel data) => json.encode(data.toJson());

class WishListDataModel {
  WishListDataModel({
    this.status,
    this.data,
    this.message,
  });

  bool? status;
  Data? data;
  String? message;

  factory WishListDataModel.fromJson(Map<String, dynamic> json) => WishListDataModel(
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
    this.video,
    this.audio,
    this.blog,
    this.short,
    this.courseText,
    this.courseAudio,
    this.courseVideo,
  });

  List<Audio>? video;
  List<Audio>? audio;
  List<Blog>? blog;
  List<dynamic>? short;
  List<Course>? courseText;
  List<Course>? courseAudio;
  List<Course>? courseVideo;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    video: json["video"] == null? []:List<Audio>.from(json["video"].map((x) => Audio.fromJson(x))),
    audio: json["audio"] == null? []: List<Audio>.from(json["audio"].map((x) => Audio.fromJson(x))),
    blog: json["blog"] == null? []: List<Blog>.from(json["blog"].map((x) => Blog.fromJson(x))),
    short: json["short"] == null? []: List<dynamic>.from(json["short"].map((x) => x)),
    courseText:json["course_text"] == null? []: List<Course>.from(json["course_text"].map((x) => Course.fromJson(x))),
    courseAudio: json["course_audio"] == null? []: List<Course>.from(json["course_audio"].map((x) => Course.fromJson(x))),
    courseVideo: json["course_video"] == null? []: List<Course>.from(json["course_video"].map((x) => Course.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "video": List<dynamic>.from(video?.map((x) => x.toJson())??[]),
    "audio": List<dynamic>.from(audio?.map((x) => x.toJson())??[]),
    "blog": List<dynamic>.from(blog?.map((x) => x.toJson())??[]),
    "short": List<dynamic>.from(short?.map((x) => x)??[]),
    "course_text": List<dynamic>.from(courseText?.map((x) => x.toJson())??[]),
    "course_audio": List<dynamic>.from(courseAudio?.map((x) => x.toJson())??[]),
    "course_video": List<dynamic>.from(courseVideo?.map((x) => x.toJson())??[]),
  };
}

class Audio {
  Audio({
    this.id,
    this.type,
    this.userId,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
    this.model,
    this.user,
    this.isWishList
  });

  int? id;
  String? type;
  int? userId;
  String? modelType;
  int? modelId;
  DateTime? createdAt;
  DateTime? updatedAt;
  AudioModel? model;
  int? isWishList;
  User? user;

  factory Audio.fromJson(Map<String, dynamic> json) => Audio(
    id: json["id"],
    type: json["type"],
    userId: json["user_id"],
    isWishList: 1,
    modelType: json["model_type"],
    modelId: json["model_id"],
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    model: json["model"] == null? AudioModel():AudioModel.fromJson(json["model"]),
    user: json["user"] == null ? User():User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "is_wishlist": isWishList,
    "user_id": userId,
    "model_type": modelType,
    "model_id": modelId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "model": model?.toJson(),
    "user": user?.toJson(),
  };
}

class AudioModel {
  AudioModel({
    this.id,
    this.categoryId,
    this.levelId,
    this.languageId,
    this.providerId,
    this.tagId,
    this.title,
    this.index,
    this.fileType,
    this.description,
    this.fileUrl,
    this.thumbnail,
    this.rating,
    this.isFree,
    this.isHome,
  this.isWishList,
    this.isActive,
    this.deletedAt,
    this.createdAt,
    this.updatedAt,
    this.videoTime,
  });

  int? id;
  int? isWishList;
  int? categoryId;
  int? levelId;
  int? languageId;
  int? providerId;
  int? tagId;
  String? title;
  dynamic index;
  String? fileType;
  String? description;
  String? fileUrl;
  String? thumbnail;
  int? rating;
  int? isFree;
  int? isHome;
  int? isActive;
  dynamic deletedAt;
  DateTime? createdAt;
  DateTime? updatedAt;
  String? videoTime;

  factory AudioModel.fromJson(Map<String, dynamic> json) => AudioModel(
    id: json["id"],
    isWishList: 1,
    categoryId: json["category_id"],
    levelId: json["level_id"],
    languageId: json["language_id"],
    providerId: json["provider_id"],
    tagId: json["tag_id"],
    title: json["title"],
    index: json["index"],
    fileType: json["file_type"],
    description: json["description"],
    fileUrl: json["file_url"],
    thumbnail: json["thumbnail"],
    rating: json["rating"],
    isFree: json["is_free"],
    isHome: json["is_home"],
    isActive: json["is_active"],
    deletedAt: json["deleted_at"],
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    videoTime: json["video_time"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_wishlist": isWishList,
    "category_id": categoryId,
    "level_id": levelId,
    "language_id": languageId,
    "provider_id": providerId,
    "tag_id": tagId,
    "title": title,
    "index": index,
    "file_type": fileType,
    "description": description,
    "file_url": fileUrl,
    "thumbnail": thumbnail,
    "rating": rating,
    "is_free": isFree,
    "is_home": isHome,
    "is_active": isActive,
    "deleted_at": deletedAt,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "video_time": videoTime,
  };
}

class User {
  User({
    this.id,
    this.name,
    this.email,
    this.mobileNo,
    this.profileImage,
  });

  int? id;
  String? name;
  String? email;
  String? mobileNo;
  String? profileImage;

  factory User.fromJson(Map<String, dynamic> json) => User(
    id: json["id"],
    name: json["name"],
    email: json["email"],
    mobileNo: json["mobile_no"],
    profileImage: json["profile_image"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "name": name,
    "email": email,
    "mobile_no": mobileNo,
    "profile_image": profileImage,
  };
}

class Blog {
  Blog({
    this.id,
    this.type,
    this.userId,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
    this.model,
    this.user,
    this.isWishList
  });

  int? id;
  String? type;
  int? userId;
  int? isWishList;
  String? modelType;
  int? modelId;
  DateTime? createdAt;
  DateTime? updatedAt;
  BlogModel? model;
  User? user;

  factory Blog.fromJson(Map<String, dynamic> json) => Blog(
    id: json["id"],
    type: json["type"],
    userId: json["user_id"],
    isWishList: 1,
    modelType: json["model_type"],
    modelId: json["model_id"],
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    model: json["model"] == null? BlogModel():BlogModel.fromJson(json["model"]),
    user: json["user"] == null? User():User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "is_wishlist": isWishList,
    "user_id": userId,
    "model_type": modelType,
    "model_id": modelId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "model": model?.toJson(),
    "user": user?.toJson(),
  };
}

class BlogModel {
  BlogModel({
    this.id,
    this.isWishList,
    this.levelId,
    this.providerId,
    this.categoryId,
    this.languageId,
    this.title,
    this.image,
    this.description,
    this.index,
    this.blogMedia,
    this.isFree,
    this.blogRating,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
  });

  int? id;
  dynamic levelId;
  dynamic providerId;
  int? categoryId;
  int? isWishList;
  int? languageId;
  String? title;
  String? image;
  String? description;
  int? index;
  String? blogMedia;
  int? isFree;
  int? blogRating;
  int? isActive;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory BlogModel.fromJson(Map<String, dynamic> json) => BlogModel(
    id: json["id"],
    isWishList: 1,
    levelId: json["level_id"],
    providerId: json["provider_id"],
    categoryId: json["category_id"],
    languageId: json["language_id"],
    title: json["title"],
    image: json["image"],
    description: json["description"],
    index: json["index"],
    blogMedia: json["blog_media"],
    isFree: json["is_free"],
    blogRating: json["blog_rating"],
    isActive: json["is_active"],
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_wishlist": isWishList,
    "level_id": levelId,
    "provider_id": providerId,
    "category_id": categoryId,
    "language_id": languageId,
    "title": title,
    "image": image,
    "description": description,
    "index": index,
    "blog_media": blogMedia,
    "is_free": isFree,
    "blog_rating": blogRating,
    "is_active": isActive,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}

class Course {
  Course({
    this.id,
    this.type,
    this.userId,
    this.modelType,
    this.modelId,
    this.createdAt,
    this.updatedAt,
    this.isWishList,
    this.model,
    this.user,
  });

  int? id;
  String? type;
  int? userId;
  int? isWishList;
  String? modelType;
  int? modelId;
  DateTime? createdAt;
  DateTime? updatedAt;
  CourseAudioModel? model;
  User? user;

  factory Course.fromJson(Map<String, dynamic> json) => Course(
    id: json["id"],
    type: json["type"],
    userId: json["user_id"],
    isWishList: 1,
    modelType: json["model_type"],
    modelId: json["model_id"],
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    model: json["model"] == null ? CourseAudioModel():CourseAudioModel.fromJson(json["model"]),
    user: json["user"] == null ?User(): User.fromJson(json["user"]),
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "type": type,
    "user_id": userId,
    "is_wishlist": isWishList,
    "model_type": modelType,
    "model_id": modelId,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "model": model?.toJson(),
    "user": user?.toJson(),
  };
}

class CourseAudioModel {
  CourseAudioModel({
    this.id,
    this.levelId,
    this.languageId,
    this.typeId,
    this.categoryId,
    this.tagId,
    this.quizId,
    this.certificateCriteria,
    this.courseTitle,
    this.index,
    this.description,
    this.thumbnails,
    this.image,
    this.preview,
    this.themeColor,
    this.buttonColor,
    this.avgRating,
    this.totalRating,
    this.totalComment,
    this.teaserUrl,
    this.quizLink,
    this.teaserType,
    this.isFree,
    this.isActive,
    this.isQuiz,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.isWishList
  });

  int? id;
  int? isWishList;
  int? levelId;
  int? languageId;
  int? typeId;
  int? categoryId;
  int? tagId;
  int? quizId;
  int? certificateCriteria;
  String? courseTitle;
  dynamic index;
  String? description;
  String? thumbnails;
  String? image;
  String? preview;
  String? themeColor;
  String? buttonColor;
  double? avgRating;
  int? totalRating;
  int? totalComment;
  String? teaserUrl;
  dynamic quizLink;
  String? teaserType;
  int? isFree;
  int? isActive;
  int? isQuiz;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;

  factory CourseAudioModel.fromJson(Map<String, dynamic> json) => CourseAudioModel(
    id: json["id"],
    isWishList: 1,
    levelId: json["level_id"],
    languageId: json["language_id"],
    typeId: json["type_id"],
    categoryId: json["category_id"],
    tagId: json["tag_id"],
    quizId: json["quiz_id"],
    certificateCriteria: json["certificate_criteria"],
    courseTitle: json["course_title"],
    index: json["index"],
    description: json["description"],
    thumbnails: json["thumbnail"],
    image: json["image"],
    preview: json["preview"],
    themeColor: json["theme_color"],
    buttonColor: json["button_color"],
    avgRating: json["avg_rating"] == null ? 0.0 : double.parse(json["avg_rating"].toString()),
    totalRating: json["total_rating"],
    totalComment: json["total_comment"],
    teaserUrl: json["teaser_url"],
    quizLink: json["quiz_link"],
    teaserType: json["teaser_type"],
    isFree: json["is_free"],
    isActive: json["is_active"],
    isQuiz: json["is_quiz"],
    createdAt: json["created_at"] == null ? DateTime(1999):DateTime.parse(json["created_at"]),
    updatedAt: json["updated_at"] == null ? DateTime(1999): DateTime.parse(json["updated_at"]),
    deletedAt: json["deleted_at"],
  );

  Map<String, dynamic> toJson() => {
    "id": id,
    "is_wishlist": isWishList,
    "level_id": levelId,
    "language_id": languageId,
    "type_id": typeId,
    "category_id": categoryId,
    "tag_id": tagId,
    "quiz_id": quizId,
    "certificate_criteria": certificateCriteria,
    "course_title": courseTitle,
    "index": index,
    "description": description,
    "thumbnail": thumbnails,
    "image": image,
    "preview": preview,
    "theme_color": themeColor,
    "button_color": buttonColor,
    "avg_rating": avgRating,
    "total_rating": totalRating,
    "total_comment": totalComment,
    "teaser_url": teaserUrl,
    "quiz_link": quizLink,
    "teaser_type": teaserType,
    "is_free": isFree,
    "is_active": isActive,
    "is_quiz": isQuiz,
    "created_at": createdAt?.toIso8601String(),
    "updated_at": updatedAt?.toIso8601String(),
    "deleted_at": deletedAt,
  };
}
