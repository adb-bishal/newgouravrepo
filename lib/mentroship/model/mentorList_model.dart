class MentorList {
  final bool status;
  final List<MentorData> data;

  MentorList({required this.status, required this.data});

  factory MentorList.fromJson(Map<String, dynamic> json) {
    return MentorList(
      status: json['status'],
      data: (json['data'] as Map<String, dynamic>).entries.map((entry) {
        return MentorData.fromJson(entry.value);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'data': data.map((mentor) => mentor.toJson()).toList(),
    };
  }
}

class MentorData {
  final int id;
  final String name;
  final String image;

  MentorData({required this.id, required this.name, required this.image});

  factory MentorData.fromJson(Map<String, dynamic> json) {
    return MentorData(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'image': image,
    };
  }
}
