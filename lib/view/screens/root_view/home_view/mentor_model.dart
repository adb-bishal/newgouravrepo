class MentorData {
  final int totalMentors;
  final List<Mentors> mentors;
  final String serverTime;
  final dynamic counsellingPrice;

  MentorData({
    required this.totalMentors,
    required this.mentors,
    required this.serverTime,
    this.counsellingPrice,
  });

  factory MentorData.fromJson(Map<String, dynamic> json) {
    return MentorData(
      totalMentors: (json['total_mentors'] as num?)?.toInt() ?? 0,
      counsellingPrice: json['counselling_price'] ?? 0,
      mentors: (json['mentors'] as List<dynamic>? ?? [])
          .map((e) => Mentors.fromJson(e is Map<String, dynamic> ? e : {}))
          .where((mentor) => mentor.id != 0)
          .toList(),
      serverTime: json['server_time']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_mentors': totalMentors,
      'counselling_price': counsellingPrice,
      'mentors': mentors.map((mentor) => mentor.toJson()).toList(),
      'server_time': serverTime,
    };
  }
}

class Mentors {
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

  Mentors({
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

  factory Mentors.fromJson(Map<String, dynamic> json) {
    return Mentors(
      id: (json['id'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? 'Unknown Mentor',
      experience: (json['total_experience'] as num?)?.toInt() ?? 0,
      experienceId: (json['expertise_id'] as num?)?.toInt() ?? 0,
      ratings: (json['ratings'] is num? ? (json['ratings'] as num?)?.toDouble() :
      double.tryParse(json['ratings']?.toString() ?? '0')) ?? 0.0,
      liveClasses: (json['total_live_classes'] as num?)?.toInt() ?? 0,
      certification: json['certification_text']?.toString() ?? 'Not Certified',
      imageUrl: json['profile_image']?.toString() ?? '',
      price: json['counselling_price']?.toString() ?? 'Price not available',
      availability: json['availability']?.toString() ?? '',
      expertise: Expertise.fromJson(json['expertise'] is Map<String, dynamic> ? json['expertise']! : {}),
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