class AskForRatingModel {
  final int? liveClassId;
  final String? title;
  final String? subtitle;

  AskForRatingModel({
    this.liveClassId,
    this.title,
    this.subtitle,
  });

  // Factory constructor for creating a new instance from JSON
  factory AskForRatingModel.fromJson(Map<String, dynamic> json) {
    return AskForRatingModel(
      liveClassId: json['live_class_id'] as int?, // Allow nullable int
      title: json['title'] as String?, // Allow nullable string
      subtitle: json['subtitle'] as String?, // Allow nullable string
    );
  }

  // Method for converting an instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'live_class_id': liveClassId,
      'title': title,
      'subtitle': subtitle,
    };
  }
}
