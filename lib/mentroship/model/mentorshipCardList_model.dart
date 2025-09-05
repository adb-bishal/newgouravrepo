class MentorshipCardList {
  bool? status;
  List<MentorCardData>? data;
  Pagination? pagination;

  MentorshipCardList({
    this.status,
    this.data,
    this.pagination,
  });

  factory MentorshipCardList.fromJson(Map<String, dynamic> json) {
    return MentorshipCardList(
      status: json['status'],
      data: (json['data'] as List<dynamic>?)
          ?.map((item) => MentorCardData.fromJson(item))
          .toList(),
      pagination: json['pagination'] != null
          ? Pagination.fromJson(json['pagination'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data?.map((item) => item.toJson()).toList(),
      'pagination': pagination?.toJson(),
    };
  }
}

class MentorCardData {
  int? id;
  String? aboutTitle;
  int? actualPrice;
  int? addCourseOffer;
  String? mentorshipDetailFirst;
  String? mentorshipEndDate;
  String? mentorshipStartDate;
  String? mentorshipVideo;
  int? categoryId;
  int? isPlus;
  String? classForDescription;
  String? classForTitle;
  String? classLearnTitle;
  String? courseOfferTitle;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  String? descImage;
  String? descriptionWeb;
  int? discountPrice;
  String? discountText;
  String? discountTextTwo;
  String? faqTitle;
  String? image;
  int? index;
  int? isActive;
  int? isTop;
  int? languageId;
  String? learnForDescription;
  int? levelId;
  String? mentorTitle;
  String? moreCourseTitle;
  String? overviewDesc;
  String? overviewTitle;
  String? shortDescription;
  String? sidebarTitle;
  String? slug;
  String? title;
  int? totalLearners;
  int? totalRatings;
  int? totalStudentsEnrolled;
  String? videoListTitle;
  String? webThumbnailImage;
  String? webThumbnailVideo;
  int? seatsLeft;
  String? seatsLeftLable;
  int? info1;
  int? info2;
  int? info3;
  String? monthName;
  String? mentorshipStartDateFormatted;
  String? mentorshipEndDateFormatted;
  MentorCardData(
      {this.id,
      this.aboutTitle,
      this.actualPrice,
      this.addCourseOffer,
      this.mentorshipDetailFirst,
      this.mentorshipEndDate,
      this.mentorshipStartDate,
      this.mentorshipVideo,
      this.categoryId,
      this.isPlus,
      this.classForDescription,
      this.classForTitle,
      this.classLearnTitle,
      this.courseOfferTitle,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.descImage,
      this.descriptionWeb,
      this.discountPrice,
      this.discountText,
      this.discountTextTwo,
      this.faqTitle,
      this.image,
      this.index,
      this.isActive,
      this.isTop,
      this.languageId,
      this.learnForDescription,
      this.levelId,
      this.mentorTitle,
      this.moreCourseTitle,
      this.overviewDesc,
      this.overviewTitle,
      this.shortDescription,
      this.sidebarTitle,
      this.slug,
      this.title,
      this.totalLearners,
      this.totalRatings,
      this.totalStudentsEnrolled,
      this.videoListTitle,
      this.webThumbnailImage,
      this.webThumbnailVideo,
      this.seatsLeft,
      this.seatsLeftLable,
      this.info1,
      this.info2,
      this.info3,
      this.monthName,
      this.mentorshipStartDateFormatted,
      this.mentorshipEndDateFormatted
      });
  factory MentorCardData.fromJson(Map<String, dynamic> json) {
    return MentorCardData(
      id: json['id'],
      aboutTitle: json['about_title'],
      actualPrice: json['actual_price'],
      addCourseOffer: json['add_course_offer'],
      mentorshipDetailFirst: json['mentorship_detail_first'],
      mentorshipEndDate: json['mentorship_end_date'],
      mentorshipStartDate: json['mentorship_start_date'],
      mentorshipVideo: json['mentorship_video'],
      categoryId: json['category_id'],
      isPlus: json['is_plus'],
      classForDescription: json['class_for_description'],
      classForTitle: json['class_for_title'],
      classLearnTitle: json['class_learn_title'],
      courseOfferTitle: json['course_offer_title'],
      deletedAt: json['deleted_at'],
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      descImage: json['desc_image'],
      descriptionWeb: json['description_web'],
      discountPrice: json['discount_price'],
      discountText: json['discount_text'],
      discountTextTwo: json['discount_text_two'],
      faqTitle: json['faq_title'],
      image: json['image'],
      index: json['index'],
      isActive: json['is_active'],
      isTop: json['is_top'],
      languageId: json['language_id'],
      learnForDescription: json['learn_for_description'],
      levelId: json['level_id'],
      mentorTitle: json['mentor_title'],
      moreCourseTitle: json['more_course_title'],
      overviewDesc: json['overview_desc'],
      overviewTitle: json['overview_title'],
      shortDescription: json['short_description'],
      sidebarTitle: json['sidebar_title'],
      slug: json['slug'],
      title: json['title'],
      totalLearners: json['total_learners'],
      totalRatings: json['total_ratings'],
      totalStudentsEnrolled: json['total_students_enrolled'],
      videoListTitle: json['video_list_title'],
      webThumbnailImage: json['web_thumbnail_image'],
      webThumbnailVideo: json['web_thumbnail_video'],
      seatsLeft: json['seats_left'],
      seatsLeftLable: json['seats_left_label'],
      info1: json['info_1'],
      info2: json['info_2'],
      info3: json['info_3'],
      monthName: json['month_name'],
      mentorshipStartDateFormatted: json['mentorship_start_date_formatted'],
      mentorshipEndDateFormatted: json['mentorship_end_date_formatted'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'about_title': aboutTitle,
      'actual_price': actualPrice,
      'add_course_offer': addCourseOffer,
      'mentorship_detail_first': mentorshipDetailFirst,
      'mentorship_end_date': mentorshipEndDate,
      'mentorship_start_date': mentorshipStartDate,
      'mentorship_video': mentorshipVideo,
      'category_id': categoryId,
      'is_plus': isPlus,
      'class_for_description': classForDescription,
      'class_for_title': classForTitle,
      'class_learn_title': classLearnTitle,
      'course_offer_title': courseOfferTitle,
      'deleted_at': deletedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'desc_image': descImage,
      'description_web': descriptionWeb,
      'discount_price': discountPrice,
      'discount_text': discountText,
      'discount_text_two': discountTextTwo,
      'faq_title': faqTitle,
      'image': image,
      'index': index,
      'is_active': isActive,
      'is_top': isTop,
      'language_id': languageId,
      'learn_for_description': learnForDescription,
      'level_id': levelId,
      'mentor_title': mentorTitle,
      'more_course_title': moreCourseTitle,
      'overview_desc': overviewDesc,
      'overview_title': overviewTitle,
      'short_description': shortDescription,
      'sidebar_title': sidebarTitle,
      'slug': slug,
      'title': title,
      'total_learners': totalLearners,
      'total_ratings': totalRatings,
      'total_students_enrolled': totalStudentsEnrolled,
      'video_list_title': videoListTitle,
      'web_thumbnail_image': webThumbnailImage,
      'web_thumbnail_video': webThumbnailVideo,
      'seats_left': seatsLeft,
      'info_1': info1,
      'info_2': info2,
      'info_3': info3,
      'month_name': monthName,
      'mentorship_start_date_formatted': mentorshipStartDateFormatted,
    };
  }
}

class Pagination {
  int? currentPage;
  int? perPage;
  int? total;
  int? lastPage;
  dynamic nextPage;
  dynamic prevPage;

  Pagination({
    this.currentPage,
    this.perPage,
    this.total,
    this.lastPage,
    this.nextPage,
    this.prevPage,
  });

  factory Pagination.fromJson(Map<String, dynamic> json) {
    return Pagination(
      currentPage: json['current_page'],
      perPage: json['per_page'],
      total: json['total'],
      lastPage: json['last_page'],
      nextPage: json['next_page'],
      prevPage: json['prev_page'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'next_page': nextPage,
      'prev_page': prevPage,
    };
  }
}
