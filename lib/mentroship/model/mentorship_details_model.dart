class MentorshipDetailData {
  final int id;
  final String aboutTitle;
  final String price;
  final String actualPrice;
  final String mentorshipDetailFirst;
  final String mentorshipTitle;
  final String mentorshipStartDate;
  final String mentorshipEndDate;
  final String cardImage;
  final String quote;
  final int seatsLeft;
  final int isPurchased;
  final int isPlus;
  final int totalRatings;
  final int allowPurchase;

  final String descriptionWeb;
  final String shortDescription;
  final int daysLeft;
  final String mentorshipStatus;
  final bool isBooked;
  final List<Faq> faqs;
  final List<MentorshipClasses> mentorshipClasses;
  final Teacher teacher; // Add Teacher object
  final MentorshipPopup mentorshipPopup;
  final UserNamePrompt userNamePrompt;
  final MentorshipDetailUI mentorshipDetailUI;
  final RecommendedMentorship recommendedMentorship;
  final RecommendedMentorshipPopup recommendedMentorshipPopup;

  MentorshipDetailData({
    required this.id,
    required this.aboutTitle,
    required this.mentorshipTitle,
    required this.price,
    required this.actualPrice,
    required this.mentorshipDetailFirst,
    required this.mentorshipStartDate,
    required this.mentorshipEndDate,
    required this.quote,
    required this.cardImage,
    required this.isPurchased,
    required this.isPlus,
    required this.totalRatings,
    required this.allowPurchase,
    required this.seatsLeft,
    required this.descriptionWeb,
    required this.shortDescription,
    required this.daysLeft,
    required this.mentorshipStatus,
    required this.isBooked,
    required this.faqs,
    required this.mentorshipClasses,
    required this.teacher,
    required this.mentorshipPopup,
    required this.userNamePrompt,
    required this.mentorshipDetailUI,
    required this.recommendedMentorship,
    required this.recommendedMentorshipPopup,
  });

  factory MentorshipDetailData.fromJson(Map<String, dynamic> json) {
    var faqList = json["faqs"] as List?;
    List<Faq> faqs =
        faqList != null ? faqList.map((faq) => Faq.fromJson(faq)).toList() : [];

    var mentorshipClassesList = json["mentorship_classes"] as List?;
    List<MentorshipClasses> mentorshipClasses = mentorshipClassesList != null
        ? mentorshipClassesList
            .map((mentorshipClass) =>
                MentorshipClasses.fromJson(mentorshipClass))
            .toList()
        : [];

    // Parse the teacher data
    Teacher teacher = Teacher.fromJson(json["teacher"] ?? {});
    MentorshipPopup mentorshipPopup =
        MentorshipPopup.fromJson(json["buy_mentorship_popup"] ?? {});

    UserNamePrompt userNamePrompt =
        UserNamePrompt.fromJson(json["user_name_prompt_data"] ?? {});

    MentorshipDetailUI mentorshipDetailUI =
        MentorshipDetailUI.fromJson(json["ui"] ?? {});

    RecommendedMentorship recommendedMentorship =
        RecommendedMentorship.fromJson(json["recommended_mentorship"] ?? {});
    RecommendedMentorshipPopup recommendedMentorshipPopup =
        RecommendedMentorshipPopup.fromJson(
            json["recommend_mentorship_popup"] ?? {});

    return MentorshipDetailData(
        id: json["id"] ?? 0,
        aboutTitle: json["about_title"] ?? "",
        mentorshipTitle: json["title"] ?? "",
        actualPrice: json["actual_price"]?.toString() ?? "0",
        price: json["price"]?.toString() ?? "0",
        mentorshipDetailFirst: json["mentorship_detail_first"] ?? "",
        mentorshipStartDate: json["mentorship_start_date"] ?? "",
        mentorshipEndDate: json["mentorship_end_date"] ?? "",
        quote: json["quote"] ?? "",
        cardImage: json["app_card_image"] ?? "",
        seatsLeft: json["seats_left"] ?? 0,
        isPurchased: json["is_purchased"] ?? 0,
        isPlus: json["is_plus"] ?? 0,
        totalRatings: json["total_ratings"] ?? 0,
        allowPurchase: json["allow_purchase"] ?? 0,
        descriptionWeb: json["description_web"] ?? "",
        shortDescription: json["short_description"] ?? "",
        daysLeft: json["days_left"] ?? 0,
        mentorshipStatus: json["mentorship_status"] ?? 0,
        isBooked: json["is_booked"] ?? false,
        faqs: faqs,
        mentorshipClasses: mentorshipClasses,
        teacher: teacher, // Add the teacher object here
        mentorshipPopup: mentorshipPopup,
        userNamePrompt: userNamePrompt,
        mentorshipDetailUI: mentorshipDetailUI,
        recommendedMentorship: recommendedMentorship,
        recommendedMentorshipPopup: recommendedMentorshipPopup);
  }
}

class MentorshipDetailUI {
  final String? mentorshipCardBgColor1;
  final String? mentorshipCardBgColor2;
  final String? mentorshipPlusCardBgColor1;
  final String? mentorshipPlusCardBgColor2;
  final String? mentorshipPlusLabel;
  final String? mentorshipTitleColor;
  final String? mentorDetailHeadingColor;
  final String? mentorDetailTextColor;
  final String? classDetailTextColor;
  final String? classListTitleColor;
  final String? classTitleColor;
  final String? tutorInfoTitle;

  final String? propertyHeading;
  final String? faqTitleColor;
  final String? faqQuestionColor;
  final String? faqAnswerColor;
  final String? callbackTitle;
  final String? callbackTitleColor;
  final String? callbackSubtitle;
  final String? callbackSubtitleColor;
  final String? callbackButtonText;
  final String? callbackButtonBgColor;
  final String? quoteTextColor;
  final String? quoteLineColor;
  final String? footerBgColor;
  final String? footerTitle;
  final String? footerTitleColor;
  final String? footerButtonText;
  final String? footerButtonTextColor;
  final String? footerButtonBgColor;
  final List<String> property;
  final String? propertyIconUrl;
  final String? callbackImageUrl;
  final String? stampIconUrl;

  // New properties added
  final String? joinButtonText;
  final String? joinButtonColor;
  final String? unlockButtonText;
  final String? unlockButtonColor;
  final String? unlockButtonTextColor;
  final String? recordingText;
  final String? timerButtonColor;
  final String? upcomingClassOneTitle;
  final String? upcomingClassTwoTitle;

  MentorshipDetailUI({
    this.mentorshipCardBgColor1,
    this.mentorshipCardBgColor2,
    this.mentorshipPlusCardBgColor1,
    this.mentorshipPlusCardBgColor2,
    this.mentorshipPlusLabel,
    this.mentorshipTitleColor,
    this.mentorDetailHeadingColor,
    this.mentorDetailTextColor,
    this.classDetailTextColor,
    this.classListTitleColor,
    this.classTitleColor,
    this.tutorInfoTitle,
    this.propertyHeading,
    this.faqTitleColor,
    this.faqQuestionColor,
    this.faqAnswerColor,
    this.callbackTitle,
    this.callbackTitleColor,
    this.callbackSubtitle,
    this.callbackSubtitleColor,
    this.callbackButtonText,
    this.callbackButtonBgColor,
    this.quoteTextColor,
    this.quoteLineColor,
    this.footerBgColor,
    this.footerTitle,
    this.footerTitleColor,
    this.footerButtonText,
    this.footerButtonTextColor,
    this.footerButtonBgColor,
    required this.property,
    this.propertyIconUrl,
    this.callbackImageUrl,
    this.stampIconUrl,

    // New properties
    this.joinButtonText,
    this.joinButtonColor,
    this.unlockButtonText,
    this.unlockButtonColor,
    this.unlockButtonTextColor,
    this.recordingText,
    this.timerButtonColor,
    this.upcomingClassOneTitle,
    this.upcomingClassTwoTitle,
  });

  factory MentorshipDetailUI.fromJson(Map<String, dynamic> json) {
    return MentorshipDetailUI(
      mentorshipCardBgColor1: json['mentorship_card_bg_color_1'],
      mentorshipCardBgColor2: json['mentorship_card_bg_color_2'],
      mentorshipPlusCardBgColor1: json['mentorship_plus_card_bg_color_1'],
      mentorshipPlusCardBgColor2: json['mentorship_plus_card_bg_color_2'],
      mentorshipPlusLabel: json['mentorship_plus_label'],
      mentorshipTitleColor: json['mentorship_title_color'],
      mentorDetailHeadingColor: json['mentor_detail_heading_color'],
      mentorDetailTextColor: json['mentor_detail_text_color'],
      classDetailTextColor: json['class_detail_text_color'],
      classListTitleColor: json['class_list_title_color'],
      classTitleColor: json['class_title_color'],
      tutorInfoTitle: json['tutor_info_title'],
      propertyHeading: json['property_heading'],
      faqTitleColor: json['faq_title_color'],
      faqQuestionColor: json['faq_question_color'],
      faqAnswerColor: json['faq_answer_color'],
      callbackTitle: json['callback_title'],
      callbackTitleColor: json['callback_title_color'],
      callbackSubtitle: json['callback_subtitle'],
      callbackSubtitleColor: json['callback_subtitle_color'],
      callbackButtonText: json['callback_button_text'],
      callbackButtonBgColor: json['callback_button_bg_color'],
      quoteTextColor: json['quote_text_color'],
      quoteLineColor: json['quote_line_color'],
      footerBgColor: json['footer_bg_color'],
      footerTitle: json['footer_title'],
      footerTitleColor: json['footer_title_color'],
      footerButtonText: json['footer_button_text'],
      footerButtonTextColor: json['footer_button_text_color'],
      footerButtonBgColor: json['footer_button_bg_color'],
      property: List<String>.from(json['property']),
      propertyIconUrl: json['property_icon_url'],
      callbackImageUrl: json['callback_image_url'],
      stampIconUrl: json['stamp_icon_url'],

      // New properties from JSON
      joinButtonText: json['join_button_text'],
      joinButtonColor: json['join_button_color'],
      unlockButtonText: json['unlock_button_text'],
      unlockButtonColor: json['unlock_button_color'],
      unlockButtonTextColor: json['unlock_button_text_color'],
      recordingText: json['recording_text'],
      timerButtonColor: json['timer_button_color'],
      upcomingClassOneTitle: json['upcoming_class_1_title'],
      upcomingClassTwoTitle: json['upcoming_class_2_title'],
    );
  }
}

class UserNamePrompt {
  final String prompttitle;
  final String prompttitleColor;
  final String promptdescription;
  final String promptdescriptionColor;
  final String promptinputPlaceholder;
  final String promptconfirmButton;
  final String promptconfirmButtonColor;
  final String promptconfirmBtnTextColor;
  final String promptimageUrl;
  final int promptimageSize;

  UserNamePrompt({
    required this.prompttitle,
    required this.prompttitleColor,
    required this.promptdescription,
    required this.promptdescriptionColor,
    required this.promptinputPlaceholder,
    required this.promptconfirmButton,
    required this.promptconfirmButtonColor,
    required this.promptconfirmBtnTextColor,
    required this.promptimageUrl,
    required this.promptimageSize,
  });

  factory UserNamePrompt.fromJson(Map<String, dynamic> json) {
    return UserNamePrompt(
      prompttitle: json["title"] ?? "",
      prompttitleColor: json["title_color"] ?? "",
      promptdescription: json["description"] ?? "",
      promptdescriptionColor: json["description_color"] ?? "",
      promptinputPlaceholder: json["user_name_input_placeholder"] ?? "",
      promptconfirmButton: json["confirm_button"] ?? "",
      promptconfirmButtonColor: json["confirm_button_color"] ?? "",
      promptconfirmBtnTextColor: json["confirm_btn_text_color"] ?? "",
      promptimageUrl: json["image_url"] ?? "",
      promptimageSize: json["image_size"] ?? 0,
    );
  }
}

class Teacher {
  final int id;
  final String name;
  final int totalExperience;
  final int totalLiveClasses;
  final int hoursOfTeaching;
  final String certificationText;
  final String profile_image;

  Teacher({
    required this.id,
    required this.name,
    required this.totalExperience,
    required this.totalLiveClasses,
    required this.hoursOfTeaching,
    required this.certificationText,
    required this.profile_image,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json["id"] ?? 0,
      name: json["name"] ?? "",
      totalExperience: json["total_experience"] ?? 0,
      totalLiveClasses: json["total_live_classes"] ?? 0,
      hoursOfTeaching: json["hours_of_teaching"] ?? 0,
      certificationText: json["certification_text"] ?? "",
      profile_image: json["profile_image"] ?? "",
    );
  }
}

class MentorshipPopup {
  final String popUptitle;
  final String popUpsubtitle;
  final String popUpbuttonTitle;
  final String popUpImageUrl;
  final String? popUpTitleColor;
  final String? popUpSubtitleColor;
  final String? popUpButtonTextColor;
  final String? popUpButtonBgColor;
  final String? popUpBgColor;
  // final int popUpImageSize;

  MentorshipPopup({
    required this.popUptitle,
    required this.popUpsubtitle,
    required this.popUpbuttonTitle,
    required this.popUpImageUrl,
    this.popUpTitleColor,
    this.popUpSubtitleColor,
    this.popUpButtonTextColor,
    this.popUpButtonBgColor,
    this.popUpBgColor,
    // required this.popUpImageSize,
  });

  factory MentorshipPopup.fromJson(Map<String, dynamic> json) {
    return MentorshipPopup(
      popUptitle: json["title"] ?? "",
      popUpsubtitle: json["subtitle"] ?? "",
      popUpbuttonTitle: json["button_title"] ?? "",
      popUpImageUrl: json["image_url"] ?? "",
      popUpTitleColor: json["title_color"],
      popUpSubtitleColor: json["subtitle_color"],
      popUpButtonTextColor: json["button_text_color"],
      popUpButtonBgColor: json["button_bg_color"],
      popUpBgColor: json["popup_bg_color"],
      // popUpImageSize: json["image_size"] ?? 0,
    );
  }
}

class MentorshipClasses {
  // New fields from the provided data
  final int id;
  final String title;
  final int temporaryClass;
  final int? lastWatchedSecond;
  final String classStatus;
  // final String description;
  // final String slug;
  final String startDatetime;
  final String endDatetime;
  final int duration; // This is an int
  // final String price; // price remains a String
  // final String fieldLabel;
  // final String classId;
  // final String meetingLink;
  // final String hostLink;
  // final String moderatorLink;
  // final String participantLink;
  // final String image;
  // final String preview;
  final String recordingUrl;
  final int isJoined;
  final int isRegister;
  // final String pdfUrl;
  // final int totalClasses; // This should be an int
  // final int ratingCount; // This should be an int
  // final double avgRating; // This should be a double
  // final int commentCount; // This should be an int
  // final bool isCompleted; // This should be a bool
  // final bool isActive; // This should be a bool
  // final bool isFree; // This should be a bool

  MentorshipClasses({
    // New fields
    required this.id,
    required this.title,
    required this.temporaryClass,
    required this.classStatus,
    // required this.description,
    // required this.slug,
    required this.startDatetime,
    required this.endDatetime,
    required this.duration,
    required this.isRegister,
    // required this.price,
    // required this.fieldLabel,
    // required this.classId,
    // required this.meetingLink,
    // required this.hostLink,
    // required this.moderatorLink,
    // required this.participantLink,
    // required this.image,
    // required this.preview,
    required this.recordingUrl,
    required this.isJoined,
    this.lastWatchedSecond,

    // required this.pdfUrl,
    // required this.totalClasses,
    // required this.ratingCount,
    // required this.avgRating,
    // required this.commentCount,
    // required this.isCompleted,
    // required this.isActive,
    // required this.isFree,
  });

  factory MentorshipClasses.fromJson(Map<String, dynamic> json) {
    return MentorshipClasses(
      // Mapping new fields
      id: json["id"] ?? 0,
      title: json["title"] ?? "",
      temporaryClass: json["is_temporary"] ?? 0,
      lastWatchedSecond: json["last_watched_second"] ?? 0,
      classStatus: json["class_status"] ?? "",
      // description: json["description"] ?? "",
      // slug: json["slug"] ?? "",
      startDatetime: json["start_datetime"] ?? "",
      endDatetime: json["end_datetime"] ?? "",
      duration: json["duration"] ?? 0,
      isRegister: json["is_register"] ?? 0,
      // price: json["price"]?.toString() ?? "0", // price is expected as a String
      // fieldLabel: json["field_label"] ?? "",
      // classId: json["class_id"] ?? "",
      // meetingLink: json["meeting_link"] ?? "",
      // hostLink: json["host_link"] ?? "",
      // moderatorLink: json["moderator_link"] ?? "",
      // participantLink: json["participant_link"] ?? "",
      // image: json["image"] ?? "",
      // preview: json["preview"] ?? "",
      recordingUrl: json["recording_url"] ?? "",
      isJoined: json["is_joined"] ?? 0,

      // pdfUrl: json["pdf_url"] ?? "",
      // totalClasses: json["total_classes"] ?? 0, // This is an int
      // ratingCount: json["rating_count"] ?? 0, // This is an int
      // avgRating: (json["avg_rating"] ?? 0.0).toDouble(), // avg_rating should be a double
      // commentCount: json["comment_count"] ?? 0, // This is an int
      // isCompleted: json["is_completed"] ?? false, // This is a bool
      // isActive: json["is_active"] ?? false, // This is a bool
      // isFree: json["is_free"] ?? false, // This is a bool
    );
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({
    required this.question,
    required this.answer,
  });

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'],
      answer: json['answer'],
    );
  }
}

class RecommendedMentorship {
  final int id;
  final String title;

  RecommendedMentorship({
    required this.id,
    required this.title,
  });

  factory RecommendedMentorship.fromJson(Map<String, dynamic> json) {
    return RecommendedMentorship(
      id: json['id'] ?? 0,
      title: json['title'] ?? "",
    );
  }
}

class RecommendedMentorshipPopup {
  final String title;
  final String subtitle;
  final String buttonTitle;
  final String popupBgColor;
  final String titleColor;
  final String subtitleColor;
  final String buttonTextColor;
  final String buttonBgColor;
  final String imageUrl;

  RecommendedMentorshipPopup({
    required this.title,
    required this.subtitle,
    required this.buttonTitle,
    required this.popupBgColor,
    required this.titleColor,
    required this.subtitleColor,
    required this.buttonTextColor,
    required this.buttonBgColor,
    required this.imageUrl,
  });

  factory RecommendedMentorshipPopup.fromJson(Map<String, dynamic> json) {
    return RecommendedMentorshipPopup(
      title: json['title'] ?? "",
      subtitle: json['subtitle'] ?? "",
      buttonTitle: json['button_title'] ?? "",
      popupBgColor: json['popup_bg_color'] ?? " ",
      titleColor: json['title_color'] ?? " ",
      subtitleColor: json['subtitle_color'] ?? " ",
      buttonTextColor: json['button_text_color'] ?? " ",
      buttonBgColor: json['button_bg_color'] ?? " ",
      imageUrl: json['image_url'] ?? " ",
    );
  }
}
