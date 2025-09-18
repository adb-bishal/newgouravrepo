class QuestionData {
  final int? id;
  final String? title;
  final String? slug;
  final int? isActive;
  final String? createdAt;
  final String? updatedAt;

  QuestionData({
    this.id,
    this.title,
    this.slug,
    this.isActive,
    this.createdAt,
    this.updatedAt,
  });

  factory QuestionData.fromJson(Map<String, dynamic> json) {
    return QuestionData(
      id: json['id'] as int?,
      title: json['title'] as String?,
      slug: json['slug'] as String?,
      isActive: json['is_active'] as int?,
      createdAt: json['created_at'] as String?,
      updatedAt: json['updated_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'slug': slug,
    'is_active': isActive,
    'created_at': createdAt,
    'updated_at': updatedAt,
  };
}
