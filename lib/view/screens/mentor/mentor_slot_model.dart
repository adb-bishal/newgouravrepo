class MentorSlotModel {
  final bool success;
  final Data data;

  MentorSlotModel({required this.success, required this.data});

  factory MentorSlotModel.fromJson(Map<String, dynamic> json) {
    return MentorSlotModel(
      success: json['success'] ?? false,
      data: Data.fromJson(json['data'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'data': data.toJson(),
    };
  }
}

class Data {
  final String counsellingPrice;
  final Mentor mentor;
  final Map<String, List<Slot>> slots;
  final Ui ui;

  Data({
    required this.counsellingPrice,
    required this.mentor,
    required this.slots,
    required this.ui,
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    Map<String, List<Slot>> parsedSlots = {};
    if (json['slots'] != null) {
      json['slots'].forEach((date, slotList) {
        parsedSlots[date] = (slotList as List)
            .map((slot) => Slot.fromJson(slot))
            .toList();
      });
    }

    return Data(
      counsellingPrice: json['counselling_price'] ?? '',
      mentor: Mentor.fromJson(json['mentor'] ?? {}),
      slots: parsedSlots,
      ui: Ui.fromJson(json['ui'] ?? {}),
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> slotsJson = {};
    slots.forEach((date, slotList) {
      slotsJson[date] = slotList.map((slot) => slot.toJson()).toList();
    });

    return {
      'counselling_price': counsellingPrice,
      'mentor': mentor.toJson(),
      'slots': slotsJson,
      'ui': ui.toJson(),
    };
  }
}

class Mentor {
  final int id;
  final String name;
  final String ratings;
  final String profileImage;
  final dynamic expertise;

  Mentor({
    required this.id,
    required this.name,
    required this.ratings,
    required this.profileImage,
    this.expertise,
  });

  factory Mentor.fromJson(Map<String, dynamic> json) {
    return Mentor(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      ratings: json['ratings'] ?? '',
      profileImage: json['profile_image'] ?? '',
      expertise: json['expertise'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'ratings': ratings,
      'profile_image': profileImage,
      'expertise': expertise,
    };
  }
}

class Slot {
  final int id;
  final int mentorId;
  final String slotStart;
  final String slotEnd;
  final dynamic bookedBy;
  final dynamic bookedAt;
  final String createdAt;
  final String updatedAt;

  Slot({
    required this.id,
    required this.mentorId,
    required this.slotStart,
    required this.slotEnd,
    this.bookedBy,
    this.bookedAt,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Slot.fromJson(Map<String, dynamic> json) {
    return Slot(
      id: json['id'] ?? 0,
      mentorId: json['mentor_id'] ?? 0,
      slotStart: json['slot_start'] ?? '',
      slotEnd: json['slot_end'] ?? '',
      bookedBy: json['booked_by'],
      bookedAt: json['booked_at'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'mentor_id': mentorId,
      'slot_start': slotStart,
      'slot_end': slotEnd,
      'booked_by': bookedBy,
      'booked_at': bookedAt,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}

class Ui {
  final String promoCardBgColor;
  final String promoCardTitle;
  final String heroCardBgColor;
  final String heroCardTitle;
  final String bookButtonText;
  final String bookButtonBgColor;
  final List<Faq> faq;
  final String promoCardImageUrl;
  final String heroCardImageUrl;

  Ui({
    required this.promoCardBgColor,
    required this.promoCardTitle,
    required this.heroCardBgColor,
    required this.heroCardTitle,
    required this.bookButtonText,
    required this.bookButtonBgColor,
    required this.faq,
    required this.promoCardImageUrl,
    required this.heroCardImageUrl,
  });

  factory Ui.fromJson(Map<String, dynamic> json) {
    List<Faq> faqList = [];
    if (json['faq'] != null) {
      faqList = (json['faq'] as List)
          .map((faq) => Faq.fromJson(faq))
          .toList();
    }

    return Ui(
      promoCardBgColor: json['promo_card_bg_color'] ?? '',
      promoCardTitle: json['promo_card_title'] ?? '',
      heroCardBgColor: json['hero_card_bg_color'] ?? '',
      heroCardTitle: json['hero_card_title'] ?? '',
      bookButtonText: json['book_button_text'] ?? '',
      bookButtonBgColor: json['book_button_bg_color'] ?? '',
      faq: faqList,
      promoCardImageUrl: json['promo_card_image_url'] ?? '',
      heroCardImageUrl: json['hero_card_image_url'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'promo_card_bg_color': promoCardBgColor,
      'promo_card_title': promoCardTitle,
      'hero_card_bg_color': heroCardBgColor,
      'hero_card_title': heroCardTitle,
      'book_button_text': bookButtonText,
      'book_button_bg_color': bookButtonBgColor,
      'faq': faq.map((f) => f.toJson()).toList(),
      'promo_card_image_url': promoCardImageUrl,
      'hero_card_image_url': heroCardImageUrl,
    };
  }
}

class Faq {
  final String question;
  final String answer;

  Faq({required this.question, required this.answer});

  factory Faq.fromJson(Map<String, dynamic> json) {
    return Faq(
      question: json['question'] ?? '',
      answer: json['answer'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'question': question,
      'answer': answer,
    };
  }
}