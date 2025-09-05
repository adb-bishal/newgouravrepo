// To parse this JSON data, do
//
//     final homeDataModel = homeDataModelFromJson(jsonString);

import 'dart:convert';

import 'package:get/get.dart';

import '../batch_models/all_batch_model.dart';

HomeDataModel homeDataModelFromJson(String str) =>
    HomeDataModel.fromJson(json.decode(str));

String homeDataModelToJson(HomeDataModel data) => json.encode(data.toJson());

class HomeDataModel {
  HomeDataModel({
    this.status,
    this.data,
    this.message,
    this.homepageUi,
  });

  bool? status;
  List<HomeDataModelDatum>? data;
  String? message;
  HomepageUi? homepageUi;

  factory HomeDataModel.fromJson(Map<String, dynamic> json) => HomeDataModel(
        status: json['status'],
        data: json['data'] == null
            ? []
            : List<HomeDataModelDatum>.from(
                json['data'].map((x) => HomeDataModelDatum.fromJson(x))),
        message: json['message'],
        homepageUi: json['homepage_ui'] == null
            ? null
            : HomepageUi.fromJson(json['homepage_ui']),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'data': List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
        'message': message,
        'homepage_ui': homepageUi?.toJson(),
      };
}

class HomepageUi {
  HomepageUi({
    this.bgImageUrl,
    this.userGreetingColor,
    this.userNameColor,
  });

  String? bgImageUrl;
  String? userGreetingColor;
  String? userNameColor;

  factory HomepageUi.fromJson(Map<String, dynamic> json) => HomepageUi(
        bgImageUrl: json['bg_image_url'],
        userGreetingColor: json['user_greeting_color'],
        userNameColor: json['user_name_color'],
      );

  Map<String, dynamic> toJson() => {
        'bg_image_url': bgImageUrl,
      };
}

class HomeDataModelDatum {
  HomeDataModelDatum({
    this.key,
    this.title,
    this.data,
    this.isActive,
  });

  String? key;
  String? title;
  int? isActive;
  List<DatumDatum>? data;

  factory HomeDataModelDatum.fromJson(Map<String, dynamic> json) =>
      HomeDataModelDatum(
        key: json['key'] as String? ?? '',
        title: json['title'] as String? ?? '',
        isActive: json['is_active'] as int? ?? 0,
        data: json['data'] == null
            ? []
            : List<DatumDatum>.from(
                json['data'].map((x) => DatumDatum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        'key': key,
        'title': title,
        'is_active': isActive,
        'data': List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
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
        id: json['id'],
        title: json['title'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
      };
}

class DatumDatum {
  DatumDatum({
    this.id,
    this.title,
    this.image,
    this.type,
    this.pageType,
    this.bannerableType,
    this.bannerableId,
    this.location,
    this.url,
    this.batchId,
    this.batchDetails,
    this.batchDiscount,
    this.batchDiscountText,
    this.batchPrice,
    this.batchTeachers,
    this.batchSubBatches,
    this.bannerType,
    this.isActive,
    this.createdAt,
    this.updatedAt,
    this.deletedAt,
    this.index,
    this.description,
    this.levelId,
    this.languageId,
    this.typeId,
    this.categoryId,
    this.tagId,
    this.quizId,
    this.certificateCriteria,
    this.courseTitle,
    this.thumbnails,
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
    this.isTrial,
    this.isHome,
    this.isQuiz,
    this.thumbnail,
    this.videoUrl,
    this.totalLikes,
    this.totalComments,
    this.totalShares,
    this.fileType,
    this.category,
    this.banner,
    this.isWishlist,
    this.isLiked,
    this.startDate,
    this.endDate,
    this.isScholarship,
    this.isAttempted,
    this.isPromotional,
    this.duration,
    this.trackable,
  });

  int? id;
  String? title;
  String? image;
  String? type;
  String? pageType;
  String? bannerableType;
  String? bannerableId;
  String? location;
  String? banner;
  String? url;
  int? batchId;
  String? batchDetails;
  String? batchDiscountText;
  int? batchDiscount;
  int? batchPrice;
  List<int>? batchTeachers;
  List<SubBatch>? batchSubBatches;
  int? bannerType;
  int? isActive;
  RxInt? isLiked;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? createdAt;
  DateTime? updatedAt;
  dynamic deletedAt;
  int? index;
  String? description;
  int? levelId;
  int? isScholarship;
  int? isAttempted;
  int? languageId;
  int? typeId;
  int? isPromotional;
  int? categoryId;
  int? tagId;
  int? quizId;
  RxInt? isWishlist;
  int? certificateCriteria;
  String? courseTitle;
  String? thumbnails;
  String? preview;
  String? themeColor;
  String? buttonColor;
  double? avgRating;
  int? totalRating;
  String? totalComment;
  String? teaserUrl;
  dynamic quizLink;
  String? teaserType;
  int? isFree;
  int? isTrial;

  int? isHome;
  int? isQuiz;
  String? thumbnail;
  String? videoUrl;
  String? totalLikes;
  int? totalComments;
  String? totalShares;
  String? fileType;
  Category? category;
  int? duration;
  Trackable? trackable; // New property for Trackable

  factory DatumDatum.fromJson(Map<String, dynamic> json) => DatumDatum(
        id: json['id'],
        title: json['title'],
        image: json['image'],
        type: json['type'],
        pageType: json['page_type'],
        bannerableType: json['bannerable_type'],
        bannerableId: json['bannerable_id'],
        location: json['location'],
        url: json['url'],
        batchId: json['batch_id'],
        batchDetails: json['short_description'],
        batchDiscountText: json['discount_text'],
        batchDiscount: json['discount_price'],
        batchPrice: json['actual_price'],
        batchTeachers: json['teachers']?.cast<int>(),
        batchSubBatches: json['sub_batch'] != null
            ? List<SubBatch>.from(
                json['sub_batch']?.map((v) => SubBatch.fromJson(v)))
            : null,
        banner: json['banner'],
        isPromotional: json['is_promotional'],
        isAttempted: json['is_attempted'],
        isScholarship: json['is_scholarship'],
        bannerType: json['banner_type'],
        isActive: json['is_active'],
        startDate: json['start_datetime'] == null
            ? DateTime(1999)
            : DateTime.parse(json['start_datetime']),
        endDate: json['end_datetime'] == null
            ? DateTime(1999)
            : DateTime.parse(json['end_datetime']),
        createdAt: json['created_at'] == null
            ? DateTime(1999)
            : DateTime.parse(json['created_at']),
        updatedAt: json['updated_at'] == null
            ? DateTime(1999)
            : DateTime.parse(json['updated_at']),
        deletedAt: json['deleted_at'],
        index: json['index'],
        isLiked: json['is_liked'] == null
            ? 0.obs
            : int.parse(json['is_liked'].toString()).obs,
        description: json['description'],
        levelId: json['level_id'],
        languageId: json['language_id'],
        typeId: json['type_id'],
        categoryId: json['category_id'],
        tagId: json['tag_id'],
        quizId: json['quiz_id'],
        certificateCriteria: json['certificate_criteria'],
        courseTitle: json['course_title'],
        thumbnails: json['thumbnail'],
        preview: json['preview'],
        themeColor: json['theme_color'],
        buttonColor: json['button_color'],
        avgRating: json['avg_rating'] == null
            ? 0.0
            : double.parse(json['avg_rating'].toString()),
        totalRating: json['total_rating'],
        totalComment: json['comment_count'] == null
            ? '0'
            : json['comment_count'].toString(),
        teaserUrl: json['teaser_url'],
        quizLink: json['quiz_link'],
        teaserType: json['teaser_type'],
        isFree: json['is_free'],
        isTrial: json['is_trial'],
        isHome: json['is_home'],
        isQuiz: json['is_quiz'],
        thumbnail: json['thumbnail'],
        videoUrl: json['video_url'],
        totalLikes:
            json['total_likes'] == null ? '0' : json['total_likes'].toString(),
        totalComments: json['total_comments'],
        totalShares: json['total_shares'] == null
            ? '0'
            : json['total_shares'].toString(),
        fileType: json['file_type'],
        isWishlist: json['is_wishlist'] == null
            ? 0.obs
            : int.parse(json['is_wishlist'].toString()).obs,
        category: json['category'] == null
            ? Category()
            : Category.fromJson(json['category']),
        duration: json['duration'],
        trackable: json['trackable'] != null
            ? Trackable.fromJson(json['trackable'])
            : null, // Deserialize Trackable
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'is_attempted': isAttempted,
        'image': image,
        'is_scholarship': isScholarship,
        'type': type,
        'page_type': pageType,
        'bannerable_type': bannerableType,
        'bannerable_id': bannerableId,
        'location': location,
        'url': url,
        'batch_id': batchId,
        'short_description': batchDetails,
        'discount_text': batchDiscountText,
        'discount_price': batchDiscount,
        'actual_price': batchPrice,
        'teachers': batchTeachers,
        'sub_batch': batchSubBatches?.map((v) => v.toJson()).toList(),
        'banner_type': bannerType,
        'is_active': isActive,
        'is_liked': isLiked?.value,
        'start_datetime': startDate?.toIso8601String(),
        'end_datetime': endDate?.toIso8601String(),
        'created_at': createdAt?.toIso8601String(),
        'updated_at': updatedAt?.toIso8601String(),
        'deleted_at': deletedAt,
        'index': index,
        'is_promotional': isPromotional,
        'description': description,
        'level_id': levelId,
        'banner': banner,
        'language_id': languageId,
        'type_id': typeId,
        'category_id': categoryId,
        'tag_id': tagId,
        'quiz_id': quizId,
        'certificate_criteria': certificateCriteria,
        'course_title': courseTitle,
        'thumbnail': thumbnails,
        'preview': preview,
        'theme_color': themeColor,
        'button_color': buttonColor,
        'avg_rating': avgRating,
        'total_rating': totalRating,
        'total_comment': totalComment,
        'teaser_url': teaserUrl,
        'quiz_link': quizLink,
        'teaser_type': teaserType,
        'is_free': isFree,
        'is_trial': isTrial,
        'is_home': isHome,
        'is_quiz': isQuiz,
        'video_url': videoUrl,
        'total_likes': totalLikes,
        'total_comments': totalComments,
        'total_shares': totalShares,
        'file_type': fileType,
        'category': category?.toJson(),
        'is_wishlist': isWishlist?.value,
        'duration': duration,
        'trackable': trackable?.toJson(), // Serialize Trackable
      };
}

class Trackable {
  final int id;
  final int index;
  final int levelId;
  final int languageId;
  final int providerId;
  final int typeId;
  final int categoryId;
  final int? tagId;
  final int? quizId;
  final int certificateCriteria;
  final String courseTitle;
  final String description;
  final String thumbnail;
  final String webThumbnailImage;
  final String? webThumbnailVideo;
  final String? videoListTitle;
  final String sidebarTitle;
  final String slug;
  final String overviewTitle;
  final String? overviewDesc;
  final String descriptionWeb;
  final String? aboutTitle;
  final String? moreCourseTitle;
  final String? courseRecomTitle;
  final String image;
  final String preview;
  final String themeColor;
  final String? buttonColor;
  final double avgRating;
  final int ratingCount;
  final int commentCount;
  final String? teaserType;
  final String? teaserUrl;
  final int fieldLabel;
  final String? quizLink;
  final int isHome;
  final int isTrending;
  final int trendingIndex;
  final int isTop;
  final int isFree;
  final int isActive;
  final int isQuiz;
  final int isTrial;
  final String? deletedAt;
  final String createdAt;
  final String updatedAt;

  Trackable({
    required this.id,
    required this.index,
    required this.levelId,
    required this.languageId,
    required this.providerId,
    required this.typeId,
    required this.categoryId,
    this.tagId,
    this.quizId,
    required this.certificateCriteria,
    required this.courseTitle,
    required this.description,
    required this.thumbnail,
    required this.webThumbnailImage,
    this.webThumbnailVideo,
    this.videoListTitle,
    required this.sidebarTitle,
    required this.slug,
    required this.overviewTitle,
    this.overviewDesc,
    required this.descriptionWeb,
    this.aboutTitle,
    this.moreCourseTitle,
    this.courseRecomTitle,
    required this.image,
    required this.preview,
    required this.themeColor,
    this.buttonColor,
    required this.avgRating,
    required this.ratingCount,
    required this.commentCount,
    this.teaserType,
    this.teaserUrl,
    required this.fieldLabel,
    this.quizLink,
    required this.isHome,
    required this.isTrending,
    required this.trendingIndex,
    required this.isTop,
    required this.isFree,
    required this.isActive,
    required this.isQuiz,
    required this.isTrial,
    this.deletedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Trackable.fromJson(Map<String, dynamic> json) {
    return Trackable(
      id: json['id'],
      index: json['index'],
      levelId: json['level_id'],
      languageId: json['language_id'],
      providerId: json['provider_id'],
      typeId: json['type_id'],
      categoryId: json['category_id'],
      tagId: json['tag_id'],
      quizId: json['quiz_id'],
      certificateCriteria: json['certificate_criteria'],
      courseTitle: json['course_title'],
      description: json['description'],
      thumbnail: json['thumbnail'],
      webThumbnailImage: json['web_thumbnail_image'],
      webThumbnailVideo: json['web_thumbnail_video'],
      videoListTitle: json['video_list_title'],
      sidebarTitle: json['sidebar_title'],
      slug: json['slug'],
      overviewTitle: json['overview_title'],
      overviewDesc: json['overview_desc'],
      descriptionWeb: json['description_web'],
      aboutTitle: json['about_title'],
      moreCourseTitle: json['more_course_title'],
      courseRecomTitle: json['course_recom_title'],
      image: json['image'],
      preview: json['preview'],
      themeColor: json['theme_color'],
      buttonColor: json['button_color'],
      avgRating: json['avg_rating'].toDouble(),
      ratingCount: json['rating_count'],
      commentCount: json['comment_count'],
      teaserType: json['teaser_type'],
      teaserUrl: json['teaser_url'],
      fieldLabel: json['field_label'],
      quizLink: json['quiz_link'],
      isHome: json['is_home'],
      isTrending: json['is_trending'],
      trendingIndex: json['trending_index'],
      isTop: json['is_top'],
      isFree: json['is_free'],
      isActive: json['is_active'],
      isQuiz: json['is_quiz'],
      isTrial: json['is_trial'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'index': index,
      'level_id': levelId,
      'language_id': languageId,
      'provider_id': providerId,
      'type_id': typeId,
      'category_id': categoryId,
      'tag_id': tagId,
      'quiz_id': quizId,
      'certificate_criteria': certificateCriteria,
      'course_title': courseTitle,
      'description': description,
      'thumbnail': thumbnail,
      'web_thumbnail_image': webThumbnailImage,
      'web_thumbnail_video': webThumbnailVideo,
      'video_list_title': videoListTitle,
      'sidebar_title': sidebarTitle,
      'slug': slug,
      'overview_title': overviewTitle,
      'overview_desc': overviewDesc,
      'description_web': descriptionWeb,
      'about_title': aboutTitle,
      'more_course_title': moreCourseTitle,
      'course_recom_title': courseRecomTitle,
      'image': image,
      'preview': preview,
      'theme_color': themeColor,
      'button_color': buttonColor,
      'avg_rating': avgRating,
      'rating_count': ratingCount,
      'comment_count': commentCount,
      'teaser_type': teaserType,
      'teaser_url': teaserUrl,
      'field_label': fieldLabel,
      'quiz_link': quizLink,
      'is_home': isHome,
      'is_trending': isTrending,
      'trending_index': trendingIndex,
      'is_top': isTop,
      'is_free': isFree,
      'is_active': isActive,
      'is_quiz': isQuiz,
      'is_trial': isTrial,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
