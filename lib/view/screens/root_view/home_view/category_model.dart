class CounsellingData {
  final int totalMentors;
  final List<Mentor> mentors;
  final List<CounsellingCategory> categories;
  final List<BookedCounselling> bookedCounselling;
  final List<WaitedCounselling>? waitedCounselling;
  final UiConfig ui;
  final String serverTime;
  final dynamic counsellingPrice;

  CounsellingData({
    required this.totalMentors,
    required this.mentors,
    required this.categories,
    required this.bookedCounselling,
    this.waitedCounselling,
    required this.ui,
    required this.serverTime,
    this.counsellingPrice,
  });

  factory CounsellingData.fromJson(Map<String, dynamic> json) {
    return CounsellingData(
      totalMentors: (json['total_mentors'] as num?)?.toInt() ?? 0,
      counsellingPrice: json['counselling_price'] ?? 0,
      mentors: (json['mentors'] as List<dynamic>? ?? [])
          .map((e) => Mentor.fromJson(e is Map<String, dynamic> ? e : {}))
          .where((mentor) => mentor.id != 0)
          .toList(),
      categories: (json['counselling_category'] as List<dynamic>? ?? [])
          .map((e) =>
              CounsellingCategory.fromJson(e is Map<String, dynamic> ? e : {}))
          .where((category) => category.id != 0)
          .toList(),
      bookedCounselling: (json['booked_counsellings'] as List<dynamic>? ?? [])
          .map((e) =>
              BookedCounselling.fromJson(e is Map<String, dynamic> ? e : {}))
          .where((booking) => booking.id != 0)
          .toList(),
      waitedCounselling: (json['waiting_counsellings'] as List<dynamic>? ?? [])
          .map((e) =>
              WaitedCounselling.fromJson(e is Map<String, dynamic> ? e : {}))
          .where((booking) => booking.id != 0)
          .toList(),
      ui: UiConfig.fromJson(
          json['ui'] is Map<String, dynamic> ? json['ui']! : {}),
      serverTime: json['server_time']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_mentors': totalMentors,
      'counselling_price': counsellingPrice,
      'mentors': mentors.map((mentor) => mentor.toJson()).toList(),
      'counselling_category':
          categories.map((category) => category.toJson()).toList(),
      'booked_counsellings':
          bookedCounselling.map((booking) => booking.toJson()).toList(),
      'ui': ui.toJson(),
      'server_time': serverTime,
    };
  }
}

class Mentor {
  final int id;
  final String name;
  final int experience;
  final int experienceId;
  final double ratings;
  final int liveClasses;
  final String certification;
  final String imageUrl;
  final String price;
  final String availability;
  final Expertise expertise;

  Mentor({
    required this.id,
    required this.name,
    required this.experience,
    required this.experienceId,
    required this.ratings,
    required this.liveClasses,
    required this.certification,
    required this.imageUrl,
    required this.price,
    required this.availability,
    required this.expertise,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Unknown Mentor',
      experience: (json['total_experience'] as num?)?.toInt() ?? 0,
      experienceId: (json['expertise_id'] as num?)?.toInt() ?? 0,
      ratings: (json['ratings'] is num?
              ? (json['ratings'] as num?)?.toDouble()
              : double.tryParse(json['ratings']?.toString() ?? '0')) ??
          0.0,
      liveClasses: (json['total_live_classes'] as num?)?.toInt() ?? 0,
      certification: json['certification_text']?.toString() ?? 'Not Certified',
      imageUrl: json['profile_image']?.toString() ?? '',
      price: json['counselling_price']?.toString() ?? 'Price not available',
      availability: json['availability']?.toString() ?? '',
      expertise: Expertise.fromJson(
          json['expertise'] is Map<String, dynamic> ? json['expertise']! : {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'total_experience': experience,
      'expertise_id': experienceId,
      'ratings': ratings,
      'total_live_classes': liveClasses,
      'certification_text': certification,
      'profile_image': imageUrl,
      'counselling_price': price,
      'availability': availability,
      'expertise': expertise.toJson(),
    };
  }
}

class Expertise {
  final int id;
  final String title;

  Expertise({required this.id, required this.title});

  factory Expertise.fromJson(Map<String, dynamic> json) {
    return Expertise(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? 'General Expertise',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
    };
  }
}

class CounsellingCategory {
  final int id;
  final String title;
  final String description;
  final String imageUrl;
  final int index;
  final List<String>? tags;

  CounsellingCategory({
    required this.id,
    required this.title,
    required this.description,
    required this.imageUrl,
    required this.index,
    this.tags,
  });

  factory CounsellingCategory.fromJson(Map<String, dynamic> json) {
    return CounsellingCategory(
      id: (json['id'] as num?)?.toInt() ?? 0,
      title: json['title']?.toString() ?? 'Untitled Category',
      description:
          json['description']?.toString() ?? 'No description available',
      imageUrl: json['image']?.toString() ?? '',
      index: (json['index'] as num?)?.toInt() ?? 0,
      tags: (json['tags'] as List?)?.map((e) => e.toString()).toList() ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'image': imageUrl,
      'index': index,
    };
  }
}

class UiConfig {
  final String? counsellingBookingSessionConfirmHeroTitle;
  final String? counsellingBookingSessionRequestHeroSubTitle;
  final String? counsellingBookingSessionRequestHeroSubTitleColor;
  final String? counsellingBookingSessionConfirmHeroTitleColor;
  final String? counsellingBookingSessionConfirmHeroPrepareTitle;
  final String? counsellingBookingSessionConfirmHeroPrepareTitleColor;
  final String? counsellingBookingSessionConfirmBgColor;
  final String? counsellingBookingSessionConfirmTitle;
  final String? counsellingBookingSessionRequestHeroTitle;
  final String? counsellingBookingSessionRequestHeroTitleColor;
  final String? counsellingBookingSessionRequestTitle;
  final String? counsellingBookingSessionRequestTitleColor;
  final String? counsellingBookingSessionRequestButtonTitle;
  final String? counsellingBookingSessionRequestButtonTitleColor;
  final String? counsellingBookingSessionRequestButtonBgColor;
  final String? counsellingBookingSessionRequestCardBgColor1;
  final String? counsellingBookingSessionRequestCardBgColor;
  final String? counsellingBookingSessionRequestCardBgColor2;
  final String? counsellingBookingSessionConfirmCardBgColor1;
  final String? counsellingBookingSessionConfirmCardBgColor2;
  final String? counsellingBookingSessionConfirmIconUrl;
  final String? counsellingBookingSessionRequestIconUrl;
  final String? counsellingBookingSessionConfirmTitleColor;
  final String? counsellingBookingSessionRequestNotifyTitle;
  final String? counsellingBookingSessionRequestNotifyTitleColor;
  final String? counsellingBookingSessionRequestAssignedTitle;
  final String? counsellingBookingSessionRequestAssignedTitleColor;
  final String? counsellingBookingSessionConfirm1Icon;

  final String? promoCardBgColor;
  final String? promoCardTitle;
  final String? promoCardTitleColor;
  final String? promoCardStripBgColor;
  final String? promoCardStripText;
  final String? promoCardStripTextColor;
  final String? promoCardButtonText;
  final String? promoCardButtonTextColor;
  final String? promoCardButtonBgColor;
  final String? heroCardBgColor;
  final String? heroCardBgColor2;
  final String? heroCardTitle;
  final String? heroCardTitleColor;
  final String? heroCardPricingLineText;
  final String? heroCardPricingLineTextColor;
  final String? heroCardMentorImageText;
  final String? heroCardMentorImageTextColor;
  final String? heroCardCounsellingButtonText;
  final String? heroCardCounsellingButtonTextColor;
  final String? heroCardCounsellingButtonBgColor;
  final String? heroCardPoint1Text;
  final String? heroCardPoint1TextColor;
  final String? heroCardPoint2Text;
  final String? heroCardPoint2TextColor;
  final String? heroCardPoint3Text;
  final String? heroCardPoint3TextColor;
  final String? marketingTitle;
  final String? marketingTitleColor;
  final String? marketingStrip1Title;
  final String? marketingStrip1TitleColor;
  final String? marketingStrip1Description;
  final String? marketingStrip1DescriptionColor;
  final String? marketingStrip2Title;
  final String? marketingStrip2TitleColor;
  final String? marketingStrip2Description;
  final String? marketingStrip2DescriptionColor;
  final String? marketingStrip3Title;
  final String? marketingStrip3TitleColor;
  final String? marketingStrip3Description;
  final String? marketingStrip3DescriptionColor;
  final String? authenticityCardPoint1Title;
  final String? authenticityCardPoint1TitleColor;
  final String? authenticityCardPoint1Description;
  final String? authenticityCardPoint1DescriptionColor;
  final String? authenticityCardPoint2Title;
  final String? authenticityCardPoint2TitleColor;
  final String? authenticityCardPoint2Description;
  final String? authenticityCardPoint2DescriptionColor;
  final String? authenticityCardPoint3Title;
  final String? authenticityCardPoint3TitleColor;
  final String? authenticityCardPoint3Description;
  final String? authenticityCardPoint3DescriptionColor;
  final String? authenticityCardPoint4Title;
  final String? authenticityCardPoint4TitleColor;
  final String? authenticityCardPoint4Description;
  final String? authenticityCardPoint4DescriptionColor;
  final String? slotSelectionTitle;
  final String? slotSelectionTitleColor;
  final String? dateSelectionTitle;
  final String? dateSelectionTitleColor;
  final String? timeSelectionTitle;
  final String? timeSelectionTitleColor;
  final String? selectedSlotBgColor;
  final String? selectedSlotBorderColor;
  final String? mentorListTitle;
  final String? mentorListTitleColor;
  final String? mentorListSubtitle;
  final String? mentorListSubtitleColor;
  final String? bookButtonText;
  final String? bookButtonTextColor;
  final String? bookButtonSubtext;
  final String? bookButtonSubtextColor;
  final String? bookButtonBgColor;
  final String? availabilityTextColor;
  final String? tutorNameTextColor;
  final String? tutorExpertiseTextColor;
  final String? tutorExperienceTextColor;
  final String? tutorLiveClassesTextColor;
  final String? tutorCertificationTextColor;
  final String? faqTitle;
  final String? faqTitleColor;
  final String? bookedCounsellingCardBgColor;
  final String? bookedCounsellingCardBgColor2;
  final String? bookedCounsellingSessionTitle;
  final String? bookedCounsellingSessionTitleColor;
  final String? bookedCounsellingSessionTutorNameColor;
  final String? bookedCounsellingSessionTutorExpertiseColor;
  final String? bookedCounsellingSessionStartTitle;
  final String? bookedCounsellingSessionStartTitleColor;
  final String? bookedCounsellingSessionStartDateAndTimeColor;
  final String? bookedCounsellingSessionTimerButtonBgColor;
  final String? bookedCounsellingSessionTimerButtonTextColor;
  final String? bookedCounsellingSessionJoinButtonBgColor;
  final String? bookedCounsellingSessionJoinButtonTextColor;
  final bool? bookedCounsellingSessionButtonVisibility;
  final bool? bookedCounsellingSessionDateTimeVisibility;
  final bool? bookedCounsellingSessionTutorDetailVisibility;
  final bool? bookedCounsellingSessionSubtitleVisibility;
  final String? bookingSuccessCongratsTitle;
  final String? bookingSuccessCongratsTitleColor;
  final String? bookingSuccessCongratsSubtitle;
  final String? bookingSuccessCongratsSubtitleColor;
  final String? bookingSuccessCongratsTutorNameColor;
  final String? bookingSuccessCongratsTutorExpertiseColor;
  final String? bookingSuccessCongratsDateColor;
  final String? bookingSuccessCongratsTimeColor;
  final String? bookingSuccessCongratsButtonTitle;
  final String? bookingSuccessCongratsButtonTitleColor;
  final String? bookingSuccessCongratsButtonBgColor;
  final String? counsellingFloatingButtonText;
  final String? counselingBookingModelTitle;
  final String? counselingBookingModelSubTitle;
  final String? counselingBookingModelMentorsSelectionTitle;
  final String? counselingBookingModelLoginSignupText;
  final String? counselingBookingModelLoginSignupButtonText;
  final String? counselingBookingModelLoginSignupButtonTextColor;
  final String? counselingBookingModelLoginSignupButtonBgColor;
  final String? counselingBookingModelMarketingLine1;
  final String? counselingBookingModelMarketingLine2;
  final List<FaqItem>? faq;
  final String? promoCardImageUrl;
  final String? heroCardImageUrl;
  final String? heroCardMentor1ImageUrl;
  final String? heroCardMentor2ImageUrl;
  final String? heroCardMentor3ImageUrl;
  final String? heroCardPoint1ImageUrl;
  final String? heroCardPoint2ImageUrl;
  final String? heroCardPoint3ImageUrl;
  final String? authenticityCardPoint1ImageUrl;
  final String? authenticityCardPoint2ImageUrl;
  final String? authenticityCardPoint3ImageUrl;
  final String? authenticityCardPoint4ImageUrl;
  final String? bookedCounsellingImageUrl;
  final String? bookingSuccessCongratsImageUrl;
  final String? counsellingFloatingButtonImageUrl;
  final List<String>? counsellingBookingThinkToPrepareTitle;

  UiConfig( {
    this.counsellingBookingSessionRequestHeroSubTitle,
    this.counsellingBookingSessionRequestHeroSubTitleColor,
    this.counsellingBookingSessionConfirm1Icon,
    this.counsellingBookingSessionRequestNotifyTitle,
    this.counsellingBookingSessionRequestNotifyTitleColor,
    this.counsellingBookingSessionRequestAssignedTitle,
    this.counsellingBookingSessionRequestAssignedTitleColor,
    this.counsellingBookingSessionConfirmTitleColor,
    this.counsellingBookingSessionConfirmIconUrl,
    this.counsellingBookingSessionRequestIconUrl,
    this.counsellingBookingSessionRequestCardBgColor,
    this.counsellingBookingSessionRequestCardBgColor1,
    this.counsellingBookingSessionRequestCardBgColor2,
    this.counsellingBookingSessionConfirmCardBgColor1,
    this.counsellingBookingSessionConfirmCardBgColor2,
    this.counsellingBookingSessionConfirmHeroTitle,
    this.counsellingBookingSessionConfirmHeroTitleColor,
    this.counsellingBookingSessionConfirmHeroPrepareTitle,
    this.counsellingBookingSessionConfirmHeroPrepareTitleColor,
    this.counsellingBookingSessionConfirmBgColor,
    this.counsellingBookingSessionConfirmTitle,
    this.counsellingBookingSessionRequestHeroTitle,
    this.counsellingBookingSessionRequestHeroTitleColor,
    this.counsellingBookingSessionRequestTitle,
    this.counsellingBookingSessionRequestTitleColor,
    this.counsellingBookingSessionRequestButtonTitle,
    this.counsellingBookingSessionRequestButtonTitleColor,
    this.counsellingBookingSessionRequestButtonBgColor,
    this.promoCardBgColor,
    this.promoCardTitle,
    this.promoCardTitleColor,
    this.promoCardStripBgColor,
    this.promoCardStripText,
    this.promoCardStripTextColor,
    this.promoCardButtonText,
    this.promoCardButtonTextColor,
    this.promoCardButtonBgColor,
    this.heroCardBgColor,
    this.heroCardBgColor2,
    this.heroCardTitle,
    this.heroCardTitleColor,
    this.heroCardPricingLineText,
    this.heroCardPricingLineTextColor,
    this.heroCardMentorImageText,
    this.heroCardMentorImageTextColor,
    this.heroCardCounsellingButtonText,
    this.heroCardCounsellingButtonTextColor,
    this.heroCardCounsellingButtonBgColor,
    this.heroCardPoint1Text,
    this.heroCardPoint1TextColor,
    this.heroCardPoint2Text,
    this.heroCardPoint2TextColor,
    this.heroCardPoint3Text,
    this.heroCardPoint3TextColor,
    this.marketingTitle,
    this.marketingTitleColor,
    this.marketingStrip1Title,
    this.marketingStrip1TitleColor,
    this.marketingStrip1Description,
    this.marketingStrip1DescriptionColor,
    this.marketingStrip2Title,
    this.marketingStrip2TitleColor,
    this.marketingStrip2Description,
    this.marketingStrip2DescriptionColor,
    this.marketingStrip3Title,
    this.marketingStrip3TitleColor,
    this.marketingStrip3Description,
    this.marketingStrip3DescriptionColor,
    this.authenticityCardPoint1Title,
    this.authenticityCardPoint1TitleColor,
    this.authenticityCardPoint1Description,
    this.authenticityCardPoint1DescriptionColor,
    this.authenticityCardPoint2Title,
    this.authenticityCardPoint2TitleColor,
    this.authenticityCardPoint2Description,
    this.authenticityCardPoint2DescriptionColor,
    this.authenticityCardPoint3Title,
    this.authenticityCardPoint3TitleColor,
    this.authenticityCardPoint3Description,
    this.authenticityCardPoint3DescriptionColor,
    this.authenticityCardPoint4Title,
    this.authenticityCardPoint4TitleColor,
    this.authenticityCardPoint4Description,
    this.authenticityCardPoint4DescriptionColor,
    this.slotSelectionTitle,
    this.slotSelectionTitleColor,
    this.dateSelectionTitle,
    this.dateSelectionTitleColor,
    this.timeSelectionTitle,
    this.timeSelectionTitleColor,
    this.selectedSlotBgColor,
    this.selectedSlotBorderColor,
    this.mentorListTitle,
    this.mentorListTitleColor,
    this.mentorListSubtitle,
    this.mentorListSubtitleColor,
    this.bookButtonText,
    this.bookButtonTextColor,
    this.bookButtonSubtext,
    this.bookButtonSubtextColor,
    this.bookButtonBgColor,
    this.availabilityTextColor,
    this.tutorNameTextColor,
    this.tutorExpertiseTextColor,
    this.tutorExperienceTextColor,
    this.tutorLiveClassesTextColor,
    this.tutorCertificationTextColor,
    this.faqTitle,
    this.faqTitleColor,
    this.bookedCounsellingCardBgColor,
    this.bookedCounsellingCardBgColor2,
    this.bookedCounsellingSessionTitle,
    this.bookedCounsellingSessionTitleColor,
    this.bookedCounsellingSessionTutorNameColor,
    this.bookedCounsellingSessionTutorExpertiseColor,
    this.bookedCounsellingSessionStartTitle,
    this.bookedCounsellingSessionStartTitleColor,
    this.bookedCounsellingSessionStartDateAndTimeColor,
    this.bookedCounsellingSessionTimerButtonBgColor,
    this.bookedCounsellingSessionTimerButtonTextColor,
    this.bookedCounsellingSessionJoinButtonBgColor,
    this.bookedCounsellingSessionJoinButtonTextColor,
    this.bookedCounsellingSessionButtonVisibility,
    this.bookedCounsellingSessionDateTimeVisibility,
    this.bookedCounsellingSessionTutorDetailVisibility,
    this.bookedCounsellingSessionSubtitleVisibility,
    this.bookingSuccessCongratsTitle,
    this.bookingSuccessCongratsTitleColor,
    this.bookingSuccessCongratsSubtitle,
    this.bookingSuccessCongratsSubtitleColor,
    this.bookingSuccessCongratsTutorNameColor,
    this.bookingSuccessCongratsTutorExpertiseColor,
    this.bookingSuccessCongratsDateColor,
    this.bookingSuccessCongratsTimeColor,
    this.bookingSuccessCongratsButtonTitle,
    this.bookingSuccessCongratsButtonTitleColor,
    this.bookingSuccessCongratsButtonBgColor,
    this.counsellingFloatingButtonText,
    this.counselingBookingModelTitle,
    this.counselingBookingModelSubTitle,
    this.counselingBookingModelMentorsSelectionTitle,
    this.counselingBookingModelLoginSignupText,
    this.counselingBookingModelLoginSignupButtonText,
    this.counselingBookingModelLoginSignupButtonTextColor,
    this.counselingBookingModelLoginSignupButtonBgColor,
    this.counselingBookingModelMarketingLine1,
    this.counselingBookingModelMarketingLine2,
    this.faq,
    this.promoCardImageUrl,
    this.heroCardImageUrl,
    this.heroCardMentor1ImageUrl,
    this.heroCardMentor2ImageUrl,
    this.heroCardMentor3ImageUrl,
    this.heroCardPoint1ImageUrl,
    this.heroCardPoint2ImageUrl,
    this.heroCardPoint3ImageUrl,
    this.authenticityCardPoint1ImageUrl,
    this.authenticityCardPoint2ImageUrl,
    this.authenticityCardPoint3ImageUrl,
    this.authenticityCardPoint4ImageUrl,
    this.bookedCounsellingImageUrl,
    this.bookingSuccessCongratsImageUrl,
    this.counsellingFloatingButtonImageUrl,
    this.counsellingBookingThinkToPrepareTitle,
  });

  factory UiConfig.fromJson(Map<String, dynamic> json) {
    return UiConfig(
        counsellingBookingSessionRequestNotifyTitle:
            json['counselling_booking_session_request_notify_title'],
        counsellingBookingSessionRequestHeroSubTitle:
        json['counselling_booking_session_request_hero_sub_title'],
        counsellingBookingSessionRequestHeroSubTitleColor:
        json['counselling_booking_session_request_hero_sub_title_color'],
        counsellingBookingSessionConfirm1Icon:
            json['counselling_booking_session_confirm_1_icon'],
        counsellingBookingSessionRequestNotifyTitleColor:
            json['counselling_booking_session_request_notify_title_color'],
        counsellingBookingSessionRequestAssignedTitle:
            json['counselling_booking_session_request_assigned_title'],
        counsellingBookingSessionRequestAssignedTitleColor:
            json['counselling_booking_session_request_assigned_title_color'],
        counsellingBookingSessionConfirmTitleColor:
            json['counselling_booking_session_confirm_title_color']?.toString(),
        counsellingBookingSessionRequestCardBgColor1:
            json['counselling_booking_session_request_card_bg_color_1']
                ?.toString(),
        counsellingBookingSessionConfirmIconUrl:
            json['counselling_booking_session_confirm_icon_url']?.toString(),
        counsellingBookingSessionRequestIconUrl:
            json['counselling_booking_session_request_icon_url']?.toString(),
        counsellingBookingSessionRequestCardBgColor:
            json['counselling_booking_session_request_bg_color']?.toString(),
        counsellingBookingSessionRequestCardBgColor2:
            json['counselling_booking_session_request_card_bg_color_2']
                ?.toString(),
        counsellingBookingSessionConfirmCardBgColor1:
            json['counselling_booking_session_confirm_card_bg_color_1']
                ?.toString(),
        counsellingBookingSessionConfirmCardBgColor2:
            json['counselling_booking_session_confirm_card_bg_color_2']
                ?.toString(),
        promoCardBgColor: json['promo_card_bg_color']?.toString() ?? '#b7bdf4',
        counsellingBookingSessionConfirmHeroTitle:
            json['counselling_booking_session_confirm_hero_title']?.toString() ??
                'Session Confirmed',
        counsellingBookingSessionConfirmHeroTitleColor:
            json['counselling_booking_session_confirm_hero_title_color']?.toString() ??
                '',
        counsellingBookingSessionConfirmTitle:
            json['counselling_booking_session_confirm_title']?.toString() ?? '',
        counsellingBookingSessionConfirmHeroPrepareTitle:
            json['counselling_booking_session_confirm_hero_prepare_title']?.toString() ?? '',
        counsellingBookingSessionConfirmHeroPrepareTitleColor: json['counselling_booking_session_confirm_hero_prepare_title_color']?.toString() ?? '',
        counsellingBookingSessionConfirmBgColor: json['counselling_booking_session_confirm_bg_color']?.toString() ?? '',
        counsellingBookingSessionRequestHeroTitle: json['counselling_booking_session_request_hero_title'],
        counsellingBookingSessionRequestHeroTitleColor: json['counselling_booking_session_request_hero_title_color'],
        counsellingBookingSessionRequestTitle: json['counselling_booking_session_request_title'],
        counsellingBookingSessionRequestTitleColor: json['counselling_booking_session_request_title_color'],
        counsellingBookingSessionRequestButtonTitle: json['counselling_booking_session_request_button_title'],
        counsellingBookingSessionRequestButtonTitleColor: json['counselling_booking_session_request_button_title_color'],
        counsellingBookingSessionRequestButtonBgColor: json['counselling_booking_session_request_button_bg_color'],
        promoCardTitle: json['promo_card_title']?.toString() ?? 'Get Unstuck with 1:1 Trading Counselling',
        promoCardTitleColor: json['promo_card_title_color']?.toString() ?? '#1f1f1f',
        promoCardStripBgColor: json['promo_card_strip_bg_color']?.toString() ?? '#903e38',
        promoCardStripText: json['promo_card_strip_text']?.toString() ?? 'Pro Plan',
        promoCardStripTextColor: json['promo_card_strip_text_color']?.toString() ?? '#b7bdf4',
        promoCardButtonText: json['promo_card_button_text']?.toString() ?? 'Join now!',
        promoCardButtonTextColor: json['promo_card_button_text_color']?.toString() ?? '#ffffff',
        promoCardButtonBgColor: json['promo_card_button_bg_color']?.toString() ?? '#ff6f61',
        heroCardBgColor: json['hero_card_bg_color']?.toString() ?? '#d7e0ff',
        heroCardBgColor2: json['hero_card_bg_color_2']?.toString() ?? '#365de7',
        heroCardTitle: json['hero_card_title']?.toString() ?? 'Get Unstuck with 1:1 Trading Counselling',
        heroCardTitleColor: json['hero_card_title_color']?.toString() ?? '#2e2e2e',
        heroCardPricingLineText: json['hero_card_pricing_line_text']?.toString() ?? 'Find the Perfect Mentor for Your Journey Starting at {₹1999}',
        heroCardPricingLineTextColor: json['hero_card_pricing_line_text_color']?.toString() ?? '#2e2e2e',
        heroCardMentorImageText: json['hero_card_mentor_image_text']?.toString() ?? '+[count] Mentors are online',
        heroCardMentorImageTextColor: json['hero_card_mentor_image_text_color']?.toString() ?? '#000000',
        heroCardCounsellingButtonText: json['hero_card_counselling_button_text']?.toString() ?? 'Book Your Counselling',
        heroCardCounsellingButtonTextColor: json['hero_card_counselling_button_text_color']?.toString() ?? '#ffffff',
        heroCardCounsellingButtonBgColor: json['hero_card_counselling_button_bg_color']?.toString() ?? '#4854fe',
        heroCardPoint1Text: json['hero_card_point_1_text']?.toString() ?? 'Verified Mentors',
        heroCardPoint1TextColor: json['hero_card_point_1_text_color']?.toString() ?? '#000000',
        heroCardPoint2Text: json['hero_card_point_2_text']?.toString() ?? 'Live QnA',
        heroCardPoint2TextColor: json['hero_card_point_2_text_color']?.toString() ?? '#000000',
        heroCardPoint3Text: json['hero_card_point_3_text']?.toString() ?? 'Pathway Guidance',
        heroCardPoint3TextColor: json['hero_card_point_3_text_color']?.toString() ?? '#000000',
        marketingTitle: json['marketing_title']?.toString() ?? 'Here\'s how our counselling has made an impact',
        marketingTitleColor: json['marketing_title_color']?.toString() ?? '#616161',
        marketingStrip1Title: json['marketing_strip_1_title']?.toString() ?? '500+',
        marketingStrip1TitleColor: json['marketing_strip_1_title_color']?.toString() ?? '#5768a4',
        marketingStrip1Description: json['marketing_strip_1_description']?.toString() ?? 'Counselling Delivered',
        marketingStrip1DescriptionColor: json['marketing_strip_1_description_color']?.toString() ?? '#5768a4',
        marketingStrip2Title: json['marketing_strip_2_title']?.toString() ?? '10000+',
        marketingStrip2TitleColor: json['marketing_strip_2_title_color']?.toString() ?? '#5768a4',
        marketingStrip2Description: json['marketing_strip_2_description']?.toString() ?? 'Traders Empowered',
        marketingStrip2DescriptionColor: json['marketing_strip_2_description_color']?.toString() ?? '#5768a4',
        marketingStrip3Title: json['marketing_strip_3_title']?.toString() ?? '10+',
        marketingStrip3TitleColor: json['marketing_strip_3_title_color']?.toString() ?? '#5768a4',
        marketingStrip3Description: json['marketing_strip_3_description']?.toString() ?? 'Profitable Mentors',
        marketingStrip3DescriptionColor: json['marketing_strip_3_description_color']?.toString() ?? '#5768a4',
        authenticityCardPoint1Title: json['authenticity_card_point_1_title']?.toString() ?? 'Personalized Guidance',
        authenticityCardPoint1TitleColor: json['authenticity_card_point_1_title_color']?.toString() ?? '#616161',
        authenticityCardPoint1Description: json['authenticity_card_point_1_description']?.toString() ?? 'No generic advice, only what fits your trading journey.',
        authenticityCardPoint1DescriptionColor: json['authenticity_card_point_1_description_color']?.toString() ?? '#616161',
        authenticityCardPoint2Title: json['authenticity_card_point_2_title']?.toString() ?? 'Verified Market Mentors',
        authenticityCardPoint2TitleColor: json['authenticity_card_point_2_title_color']?.toString() ?? '#616161',
        authenticityCardPoint2Description: json['authenticity_card_point_2_description']?.toString() ?? 'LIVE interaction with experienced traders and educators, not bots.',
        authenticityCardPoint2DescriptionColor: json['authenticity_card_point_2_description_color']?.toString() ?? '#616161',
        authenticityCardPoint3Title: json['authenticity_card_point_3_title']?.toString() ?? 'Clarity Before Commitment',
        authenticityCardPoint3TitleColor: json['authenticity_card_point_3_title_color']?.toString() ?? '#616161',
        authenticityCardPoint3Description: json['authenticity_card_point_3_description']?.toString() ?? 'Use the session to evaluate if mentorship fits your trading needs.',
        authenticityCardPoint3DescriptionColor: json['authenticity_card_point_3_description_color']?.toString() ?? '#616161',
        authenticityCardPoint4Title: json['authenticity_card_point_4_title']?.toString() ?? 'Flexible Scheduling',
        authenticityCardPoint4TitleColor: json['authenticity_card_point_4_title_color']?.toString() ?? '#616161',
        authenticityCardPoint4Description: json['authenticity_card_point_4_description']?.toString() ?? 'Choose your preferred time for the session.',
        authenticityCardPoint4DescriptionColor: json['authenticity_card_point_4_description_color']?.toString() ?? '#616161',
        slotSelectionTitle: json['slot_selection_title']?.toString() ?? 'Select your preferred Day for consultation',
        slotSelectionTitleColor: json['slot_selection_title_color']?.toString() ?? '#616161',
        dateSelectionTitle: json['date_selection_title']?.toString() ?? 'Date',
        dateSelectionTitleColor: json['date_selection_title_color']?.toString() ?? '#616161',
        timeSelectionTitle: json['time_selection_title']?.toString() ?? 'Time Slot',
        timeSelectionTitleColor: json['time_selection_title_color']?.toString() ?? '#616161',
        selectedSlotBgColor: json['selected_slot_bg_color']?.toString() ?? '#616161',
        selectedSlotBorderColor: json['selected_slot_border_color']?.toString() ?? '#616161',
        mentorListTitle: json['mentor_list_title']?.toString() ?? 'Available Mentorship Tutors',
        mentorListTitleColor: json['mentor_list_title_color']?.toString() ?? '#454545',
        mentorListSubtitle: json['mentor_list_subtitle']?.toString() ?? 'Book appointments with minimum wait-time',
        mentorListSubtitleColor: json['mentor_list_subtitle_color']?.toString() ?? '#616161',
        bookButtonText: json['book_button_text']?.toString() ?? 'Book Counselling',
        bookButtonTextColor: json['book_button_text_color']?.toString() ?? '#ffffff',
        bookButtonSubtext: json['book_button_subtext']?.toString() ?? 'at ₹1999 only',
        bookButtonSubtextColor: json['book_button_subtext_color']?.toString() ?? '#ffffff',
        bookButtonBgColor: json['book_button_bg_color']?.toString() ?? '#4854fe',
        availabilityTextColor: json['availability_text_color']?.toString() ?? '#01a320',
        tutorNameTextColor: json['tutor_name_text_color']?.toString() ?? '#000000',
        tutorExpertiseTextColor: json['tutor_expertise_text_color']?.toString() ?? '#000000',
        tutorExperienceTextColor: json['tutor_experience_text_color']?.toString() ?? '#000000',
        tutorLiveClassesTextColor: json['tutor_live_classes_text_color']?.toString() ?? '#000000',
        tutorCertificationTextColor: json['tutor_certification_text_color']?.toString() ?? '#000000',
        faqTitle: json['faq_title']?.toString() ?? 'Frequently Asked Questions',
        faqTitleColor: json['faq_title_color']?.toString() ?? '#454545',
        bookedCounsellingCardBgColor: json['booked_counselling_card_bg_color']?.toString() ?? '#d7e0ff',
        bookedCounsellingCardBgColor2: json['booked_counselling_card_bg_color_2']?.toString() ?? '#365de7',
        bookedCounsellingSessionTitle: json['booked_counselling_session_title']?.toString() ?? 'Your Counselling Session',
        bookedCounsellingSessionTitleColor: json['booked_counselling_session_title_color']?.toString() ?? '#000000',
        bookedCounsellingSessionTutorNameColor: json['booked_counselling_session_tutor_name_color']?.toString() ?? '#000000',
        bookedCounsellingSessionTutorExpertiseColor: json['booked_counselling_session_tutor_expertise_color']?.toString() ?? '#000000',
        bookedCounsellingSessionStartTitle: json['booked_counselling_session_start_title']?.toString() ?? 'Session Starting in',
        bookedCounsellingSessionStartTitleColor: json['booked_counselling_session_start_title_color']?.toString() ?? '#000000',
        bookedCounsellingSessionStartDateAndTimeColor: json['booked_counselling_session_start_date_and_time_color']?.toString() ?? '#000000',
        bookedCounsellingSessionTimerButtonBgColor: json['booked_counselling_session_timer_button_bg_color']?.toString() ?? '#e18c30',
        bookedCounsellingSessionTimerButtonTextColor: json['booked_counselling_session_timer_button_text_color']?.toString() ?? '#ffffff',
        bookedCounsellingSessionJoinButtonBgColor: json['booked_counselling_session_join_button_bg_color']?.toString() ?? '#be3030',
        bookedCounsellingSessionJoinButtonTextColor: json['booked_counselling_session_join_button_text_color']?.toString() ?? '#ffffff',
        bookedCounsellingSessionButtonVisibility: json['booked_counselling_session_button_visibility'] as bool? ?? true,
        bookedCounsellingSessionDateTimeVisibility: json['booked_counselling_session_date_time_visibility'] as bool? ?? false,
        bookedCounsellingSessionTutorDetailVisibility: json['booked_counselling_session_tutor_detail_visibility'] as bool? ?? false,
        bookedCounsellingSessionSubtitleVisibility: json['booked_counselling_session_subtitle_visibility'] as bool? ?? true,
        bookingSuccessCongratsTitle: json['booking_success_congrats_title']?.toString() ?? 'Booking Confirmed!',
        bookingSuccessCongratsTitleColor: json['booking_success_congrats_title_color']?.toString() ?? '#000000',
        bookingSuccessCongratsSubtitle: json['booking_success_congrats_subtitle']?.toString() ?? 'Your mentorship counselling session has been successfully scheduled.',
        bookingSuccessCongratsSubtitleColor: json['booking_success_congrats_subtitle_color']?.toString() ?? '#595959',
        bookingSuccessCongratsTutorNameColor: json['booking_success_congrats_tutor_name_color']?.toString() ?? '#000000',
        bookingSuccessCongratsTutorExpertiseColor: json['booking_success_congrats_tutor_expertise_color']?.toString() ?? '#595959',
        bookingSuccessCongratsDateColor: json['booking_success_congrats_date_color']?.toString() ?? '#595959',
        bookingSuccessCongratsTimeColor: json['booking_success_congrats_time_color']?.toString() ?? '#595959',
        bookingSuccessCongratsButtonTitle: json['booking_success_congrats_button_title']?.toString() ?? 'View Details',
        bookingSuccessCongratsButtonTitleColor: json['booking_success_congrats_button_title_color']?.toString() ?? '#ffffff',
        bookingSuccessCongratsButtonBgColor: json['booking_success_congrats_button_bg_color']?.toString() ?? '#475eb8',
        counsellingFloatingButtonText: json['counselling_floating_button_text']?.toString() ?? 'Counselling',
        counselingBookingModelTitle: json['counseling_booking_model_title']?.toString(),
        counselingBookingModelSubTitle: json['counseling_booking_model_sub_title']?.toString(),
        counselingBookingModelMentorsSelectionTitle: json['counseling_booking_model_mentors_selection_title']?.toString(),
        counselingBookingModelLoginSignupText: json['counseling_booking_model_login_signup_text']?.toString(),
        counselingBookingModelLoginSignupButtonText: json['counseling_booking_model_login_signup_button_text']?.toString(),
        counselingBookingModelLoginSignupButtonTextColor: json['counseling_booking_model_login_signup_button_text_color']?.toString() ?? '#000000',
        counselingBookingModelLoginSignupButtonBgColor: json['counseling_booking_model_login_signup_button_bg_color']?.toString() ?? '#000000',
        counselingBookingModelMarketingLine1: json['counseling_booking_model_marketing_line1']?.toString(),
        counselingBookingModelMarketingLine2: json['counseling_booking_model_marketing_line2']?.toString(),
        faq: (json['faq'] as List<dynamic>? ?? []).map((e) => FaqItem.fromJson(e is Map<String, dynamic> ? e : {})).where((faq) => faq.question.isNotEmpty).toList(),
        promoCardImageUrl: json['promo_card_image_url']?.toString() ?? '',
        heroCardImageUrl: json['hero_card_image_url']?.toString() ?? '',
        heroCardMentor1ImageUrl: json['hero_card_mentor_1_image_url']?.toString() ?? '',
        heroCardMentor2ImageUrl: json['hero_card_mentor_2_image_url']?.toString() ?? '',
        heroCardMentor3ImageUrl: json['hero_card_mentor_3_image_url']?.toString() ?? '',
        heroCardPoint1ImageUrl: json['hero_card_point_1_image_url']?.toString() ?? '',
        heroCardPoint2ImageUrl: json['hero_card_point_2_image_url']?.toString() ?? '',
        heroCardPoint3ImageUrl: json['hero_card_point_3_image_url']?.toString() ?? '',
        authenticityCardPoint1ImageUrl: json['authenticity_card_point_1_image_url']?.toString() ?? '',
        authenticityCardPoint2ImageUrl: json['authenticity_card_point_2_image_url']?.toString() ?? '',
        authenticityCardPoint3ImageUrl: json['authenticity_card_point_3_image_url']?.toString() ?? '',
        authenticityCardPoint4ImageUrl: json['authenticity_card_point_4_image_url']?.toString() ?? '',
        bookedCounsellingImageUrl: json['booked_counselling_image_url']?.toString() ?? '',
        bookingSuccessCongratsImageUrl: json['booking_success_congrats_image_url']?.toString() ?? '',
        counsellingFloatingButtonImageUrl: json['counselling_floating_button_image_url']?.toString() ?? '',
        counsellingBookingThinkToPrepareTitle: List<String>.from(json['counselling_booking_think_to_prepare_title'] ?? []));
  }

  Map<String, dynamic> toJson() {
    return {
      'counsellingBookingSessionConfirmHeroTitle':
          counsellingBookingSessionConfirmHeroTitle,
      'counsellingBookingSessionConfirmHeroTitleColor':
          counsellingBookingSessionConfirmHeroTitleColor,
      'counsellingBookingSessionConfirmHeroPrepareTitle':
          counsellingBookingSessionConfirmHeroPrepareTitle,
      'counsellingBookingSessionConfirmHeroPrepareTitleColor':
          counsellingBookingSessionConfirmHeroPrepareTitleColor,
      'counsellingBookingSessionConfirmBgColor':
          counsellingBookingSessionConfirmBgColor,
      'counsellingBookingSessionConfirmTitle':
          counsellingBookingSessionConfirmTitle,
      'counsellingBookingSessionRequestHeroTitle':
          counsellingBookingSessionRequestHeroTitle,
      'counsellingBookingSessionRequestHeroTitleColor':
          counsellingBookingSessionRequestHeroTitleColor,
      'counsellingBookingSessionRequestTitle':
          counsellingBookingSessionRequestTitle,
      'counsellingBookingSessionRequestTitleColor':
          counsellingBookingSessionRequestTitleColor,
      'counsellingBookingSessionRequestButtonTitle':
          counsellingBookingSessionRequestButtonTitle,
      'counsellingBookingSessionRequestButtonTitleColor':
          counsellingBookingSessionRequestButtonTitleColor,
      'counsellingBookingSessionRequestButtonBgColor':
          counsellingBookingSessionRequestButtonBgColor,
      'promo_card_bg_color': promoCardBgColor,
      'promo_card_title': promoCardTitle,
      'promo_card_title_color': promoCardTitleColor,
      'promo_card_strip_bg_color': promoCardStripBgColor,
      'promo_card_strip_text': promoCardStripText,
      'promo_card_strip_text_color': promoCardStripTextColor,
      'promo_card_button_text': promoCardButtonText,
      'promo_card_button_text_color': promoCardButtonTextColor,
      'promo_card_button_bg_color': promoCardButtonBgColor,
      'hero_card_bg_color': heroCardBgColor,
      'hero_card_bg_color_2': heroCardBgColor2,
      'hero_card_title': heroCardTitle,
      'hero_card_title_color': heroCardTitleColor,
      'hero_card_pricing_line_text': heroCardPricingLineText,
      'hero_card_pricing_line_text_color': heroCardPricingLineTextColor,
      'hero_card_mentor_image_text': heroCardMentorImageText,
      'hero_card_mentor_image_text_color': heroCardMentorImageTextColor,
      'hero_card_counselling_button_text': heroCardCounsellingButtonText,
      'hero_card_counselling_button_text_color':
          heroCardCounsellingButtonTextColor,
      'hero_card_counselling_button_bg_color': heroCardCounsellingButtonBgColor,
      'hero_card_point_1_text': heroCardPoint1Text,
      'hero_card_point_1_text_color': heroCardPoint1TextColor,
      'hero_card_point_2_text': heroCardPoint2Text,
      'hero_card_point_2_text_color': heroCardPoint2TextColor,
      'hero_card_point_3_text': heroCardPoint3Text,
      'hero_card_point_3_text_color': heroCardPoint3TextColor,
      'marketing_title': marketingTitle,
      'marketing_title_color': marketingTitleColor,
      'marketing_strip_1_title': marketingStrip1Title,
      'marketing_strip_1_title_color': marketingStrip1TitleColor,
      'marketing_strip_1_description': marketingStrip1Description,
      'marketing_strip_1_description_color': marketingStrip1DescriptionColor,
      'marketing_strip_2_title': marketingStrip2Title,
      'marketing_strip_2_title_color': marketingStrip2TitleColor,
      'marketing_strip_2_description': marketingStrip2Description,
      'marketing_strip_2_description_color': marketingStrip2DescriptionColor,
      'marketing_strip_3_title': marketingStrip3Title,
      'marketing_strip_3_title_color': marketingStrip3TitleColor,
      'marketing_strip_3_description': marketingStrip3Description,
      'marketing_strip_3_description_color': marketingStrip3DescriptionColor,
      'authenticity_card_point_1_title': authenticityCardPoint1Title,
      'authenticity_card_point_1_title_color': authenticityCardPoint1TitleColor,
      'authenticity_card_point_1_description':
          authenticityCardPoint1Description,
      'authenticity_card_point_1_description_color':
          authenticityCardPoint1DescriptionColor,
      'authenticity_card_point_2_title': authenticityCardPoint2Title,
      'authenticity_card_point_2_title_color': authenticityCardPoint2TitleColor,
      'authenticity_card_point_2_description':
          authenticityCardPoint2Description,
      'authenticity_card_point_2_description_color':
          authenticityCardPoint2DescriptionColor,
      'authenticity_card_point_3_title': authenticityCardPoint3Title,
      'authenticity_card_point_3_title_color': authenticityCardPoint3TitleColor,
      'authenticity_card_point_3_description':
          authenticityCardPoint3Description,
      'authenticity_card_point_3_description_color':
          authenticityCardPoint3DescriptionColor,
      'authenticity_card_point_4_title': authenticityCardPoint4Title,
      'authenticity_card_point_4_title_color': authenticityCardPoint4TitleColor,
      'authenticity_card_point_4_description':
          authenticityCardPoint4Description,
      'authenticity_card_point_4_description_color':
          authenticityCardPoint4DescriptionColor,
      'slot_selection_title': slotSelectionTitle,
      'slot_selection_title_color': slotSelectionTitleColor,
      'date_selection_title': dateSelectionTitle,
      'date_selection_title_color': dateSelectionTitleColor,
      'time_selection_title': timeSelectionTitle,
      'time_selection_title_color': timeSelectionTitleColor,
      'selected_slot_bg_color': selectedSlotBgColor,
      'selected_slot_border_color': selectedSlotBorderColor,
      'mentor_list_title': mentorListTitle,
      'mentor_list_title_color': mentorListTitleColor,
      'mentor_list_subtitle': mentorListSubtitle,
      'mentor_list_subtitle_color': mentorListSubtitleColor,
      'book_button_text': bookButtonText,
      'book_button_text_color': bookButtonTextColor,
      'book_button_subtext': bookButtonSubtext,
      'book_button_subtext_color': bookButtonSubtextColor,
      'book_button_bg_color': bookButtonBgColor,
      'availability_text_color': availabilityTextColor,
      'tutor_name_text_color': tutorNameTextColor,
      'tutor_expertise_text_color': tutorExpertiseTextColor,
      'tutor_experience_text_color': tutorExperienceTextColor,
      'tutor_live_classes_text_color': tutorLiveClassesTextColor,
      'tutor_certification_text_color': tutorCertificationTextColor,
      'faq_title': faqTitle,
      'faq_title_color': faqTitleColor,
      'booked_counselling_card_bg_color': bookedCounsellingCardBgColor,
      'booked_counselling_card_bg_color_2': bookedCounsellingCardBgColor2,
      'booked_counselling_session_title': bookedCounsellingSessionTitle,
      'booked_counselling_session_title_color':
          bookedCounsellingSessionTitleColor,
      'booked_counselling_session_tutor_name_color':
          bookedCounsellingSessionTutorNameColor,
      'booked_counselling_session_tutor_expertise_color':
          bookedCounsellingSessionTutorExpertiseColor,
      'booked_counselling_session_start_title':
          bookedCounsellingSessionStartTitle,
      'booked_counselling_session_start_title_color':
          bookedCounsellingSessionStartTitleColor,
      'booked_counselling_session_start_date_and_time_color':
          bookedCounsellingSessionStartDateAndTimeColor,
      'booked_counselling_session_timer_button_bg_color':
          bookedCounsellingSessionTimerButtonBgColor,
      'booked_counselling_session_timer_button_text_color':
          bookedCounsellingSessionTimerButtonTextColor,
      'booked_counselling_session_join_button_bg_color':
          bookedCounsellingSessionJoinButtonBgColor,
      'booked_counselling_session_join_button_text_color':
          bookedCounsellingSessionJoinButtonTextColor,
      'booked_counselling_session_button_visibility':
          bookedCounsellingSessionButtonVisibility,
      'booked_counselling_session_date_time_visibility':
          bookedCounsellingSessionDateTimeVisibility,
      'booked_counselling_session_tutor_detail_visibility':
          bookedCounsellingSessionTutorDetailVisibility,
      'booked_counselling_session_subtitle_visibility':
          bookedCounsellingSessionSubtitleVisibility,
      'booking_success_congrats_title': bookingSuccessCongratsTitle,
      'booking_success_congrats_title_color': bookingSuccessCongratsTitleColor,
      'booking_success_congrats_subtitle': bookingSuccessCongratsSubtitle,
      'booking_success_congrats_subtitle_color':
          bookingSuccessCongratsSubtitleColor,
      'booking_success_congrats_tutor_name_color':
          bookingSuccessCongratsTutorNameColor,
      'booking_success_congrats_tutor_expertise_color':
          bookingSuccessCongratsTutorExpertiseColor,
      'booking_success_congrats_date_color': bookingSuccessCongratsDateColor,
      'booking_success_congrats_time_color': bookingSuccessCongratsTimeColor,
      'booking_success_congrats_button_title':
          bookingSuccessCongratsButtonTitle,
      'booking_success_congrats_button_title_color':
          bookingSuccessCongratsButtonTitleColor,
      'booking_success_congrats_button_bg_color':
          bookingSuccessCongratsButtonBgColor,
      'counselling_floating_button_text': counsellingFloatingButtonText,
      'counseling_booking_model_title': counselingBookingModelTitle,
      'counseling_booking_model_sub_title': counselingBookingModelSubTitle,
      'counseling_booking_model_mentors_selection_title':
          counselingBookingModelMentorsSelectionTitle,
      'counseling_booking_model_login_signup_text':
          counselingBookingModelLoginSignupText,
      'counseling_booking_model_login_signup_button_text':
          counselingBookingModelLoginSignupButtonText,
      'counseling_booking_model_login_signup_button_text_color':
          counselingBookingModelLoginSignupButtonTextColor,
      'counseling_booking_model_login_signup_button_bg_color':
          counselingBookingModelLoginSignupButtonBgColor,
      'counseling_booking_model_marketing_line1':
          counselingBookingModelMarketingLine1,
      'counseling_booking_model_marketing_line2':
          counselingBookingModelMarketingLine2,
      'faq': faq?.map((faq) => faq.toJson()).toList(),
      'promo_card_image_url': promoCardImageUrl,
      'hero_card_image_url': heroCardImageUrl,
      'hero_card_mentor_1_image_url': heroCardMentor1ImageUrl,
      'hero_card_mentor_2_image_url': heroCardMentor2ImageUrl,
      'hero_card_mentor_3_image_url': heroCardMentor3ImageUrl,
      'hero_card_point_1_image_url': heroCardPoint1ImageUrl,
      'hero_card_point_2_image_url': heroCardPoint2ImageUrl,
      'hero_card_point_3_image_url': heroCardPoint3ImageUrl,
      'authenticity_card_point_1_image_url': authenticityCardPoint1ImageUrl,
      'authenticity_card_point_2_image_url': authenticityCardPoint2ImageUrl,
      'authenticity_card_point_3_image_url': authenticityCardPoint3ImageUrl,
      'authenticity_card_point_4_image_url': authenticityCardPoint4ImageUrl,
      'booked_counselling_image_url': bookedCounsellingImageUrl,
      'booking_success_congrats_image_url': bookingSuccessCongratsImageUrl,
      'counselling_floating_button_image_url':
          counsellingFloatingButtonImageUrl,
    };
  }
}

class WaitedCounselling {
  final int id;
  final int customerId;
  final String status;
  final String? participantLink;
  final String? recordingUrl;
  final String? hlsVideo;
  final Mentor? mentor;
  final int? slotId;
  final String? bookingStatus;

  WaitedCounselling({
    required this.id,
    required this.customerId,
    required this.status,
    this.participantLink,
    this.recordingUrl,
    this.hlsVideo,
    this.mentor,
    this.slotId,
    this.bookingStatus,
  });

  factory WaitedCounselling.fromJson(Map<String, dynamic> json) {
    return WaitedCounselling(
      id: (json['id'] as num?)?.toInt() ?? 0,
      customerId: (json['customer_id'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      participantLink: json['participant_link']?.toString(),
      recordingUrl: json['recording_url']?.toString(),
      hlsVideo: json['hls_video']?.toString(),
      mentor: _parseMentor(json['mentor']),
      slotId: (json['slot_id'] as num?)?.toInt(),
      bookingStatus: json['booking_status']?.toString(),
    );
  }

// Safe mentor parser helper
  static Mentor? _parseMentor(dynamic mentorData) {
    if (mentorData == null) return null;
    if (mentorData is Map<String, dynamic>) {
      try {
        return Mentor.fromJson(mentorData);
      } catch (e) {
        print('Error parsing mentor: $e');
        return null;
      }
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'status': status,
      'participant_link': participantLink,
      'recording_url': recordingUrl,
      'hls_video': hlsVideo,
      'mentor': mentor?.toJson(),
      'slot_id': slotId,
      'booking_status': bookingStatus,
    };
  }

  static List<WaitedCounselling> fromJsonList(List<dynamic> jsonList) {
    return jsonList.map((json) => WaitedCounselling.fromJson(json)).toList();
  }
}

class BookedCounselling {
  final int id;
  final int customerId;
  final String status;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String participantLink;
  final String? recordingUrl;
  final String? hlsVideo;
  final Mentor mentor;

  BookedCounselling({
    required this.id,
    required this.customerId,
    required this.status,
    required this.startDateTime,
    required this.endDateTime,
    required this.participantLink,
    this.recordingUrl,
    this.hlsVideo,
    required this.mentor,
  });

  factory BookedCounselling.fromJson(Map<String, dynamic> json) {
    return BookedCounselling(
      id: (json['id'] as num?)?.toInt() ?? 0,
      customerId: (json['customer_id'] as num?)?.toInt() ?? 0,
      status: json['status']?.toString() ?? '',
      startDateTime: DateTime.parse(
          json['start_date_time']?.toString() ?? DateTime.now().toString()),
      endDateTime: DateTime.parse(
          json['end_date_time']?.toString() ?? DateTime.now().toString()),
      participantLink: json['participant_link']?.toString() ?? '',
      recordingUrl: json['recording_url']?.toString(),
      hlsVideo: json['hls_video']?.toString(),
      mentor: Mentor.fromJson(
          json['mentor'] is Map<String, dynamic> ? json['mentor'] : {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_id': customerId,
      'status': status,
      'start_date_time': startDateTime.toIso8601String(),
      'end_date_time': endDateTime.toIso8601String(),
      'participant_link': participantLink,
      'recording_url': recordingUrl,
      'hls_video': hlsVideo,
      'mentor': mentor.toJson(),
    };
  }
}

class FaqItem {
  final String question;
  final String answer;

  FaqItem({required this.question, required this.answer});

  factory FaqItem.fromJson(Map<String, dynamic> json) {
    return FaqItem(
      question: json['question']?.toString() ?? '',
      answer: json['answer']?.toString() ?? 'No answer available',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}
