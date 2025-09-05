class SubscriptionDescriptionModel {
  SubscriptionDescriptionModel({
    this.status,
    this.title,
    this.description,
    this.bottomDescription,
    this.image,
    this.image_1,
    this.image_2,
    this.image_3,
    this.addTitle,
    this.buttonTitle,
    this.bottomTitle,
    this.buttonBgColor,
  });

  bool? status;
  String? title;
  List<dynamic>? description;

  String? bottomDescription;
  String? image;
  String? image_1;
  String? image_2;
  String? image_3;
  String? addTitle;
  String? buttonBgColor;
  String? buttonTitle;
  String? bottomTitle;

  factory SubscriptionDescriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionDescriptionModel(
        status: json["status"],
        title: json['title'],
        description: json['descriptions'] ?? [],
        image: json['image'],
        image_1: json['image_1'],
        image_2: json['image_2'],
        image_3: json['image_3'],
        bottomDescription: json['bottom_description'],
        bottomTitle: json['bottom_title'],
        buttonTitle: json['button_title'],
        addTitle: json['add_title'],
        buttonBgColor: json['button_bg_color'],
      );

  // Map<String, dynamic> toJson() => {
  //       "status": status,
  //       "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
  //       "message": message,
  //     };
}
