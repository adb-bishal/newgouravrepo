class LiveClassRatingModel {
  final bool status;
  final String message;
  final ClassDetails classDetails;

  LiveClassRatingModel({
    required this.status,
    required this.message,
    required this.classDetails,
  });

  factory LiveClassRatingModel.fromJson(Map<String, dynamic> json) {
    return LiveClassRatingModel(
      status: json['status'] ?? false,
      message: json['message'] ?? '',
      classDetails: ClassDetails.fromJson(json['class_details']),
    );
  }
}

class ClassDetails {
  final int id;
  final String title;
  final String startDateTime;
  final String endDateTime;
  final Teacher teacher;

  ClassDetails({
    required this.id,
    required this.title,
    required this.startDateTime,
    required this.endDateTime,
    required this.teacher,
  });

  factory ClassDetails.fromJson(Map<String, dynamic> json) {
    return ClassDetails(
      id: json['id'],
      title: json['title'],
      startDateTime: json['start_datetime'],
      endDateTime: json['end_datetime'],
      teacher: Teacher.fromJson(json['teacher']),
    );
  }
}

class Teacher {
  final int id;
  final String name;
  final String email;

  Teacher({
    required this.id,
    required this.name,
    required this.email,
  });

  factory Teacher.fromJson(Map<String, dynamic> json) {
    return Teacher(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}
