class LoginPageDataModel {
  LoginPageDataModel({
    this.status,
    this.promotionalText,
    this.promotionalTextColor,
    this.buttonText,
    this.image,
    this.buttonColor,
    this.buttonBackColor,
  });

  bool? status;
  String? promotionalText;
  String? image;
  String? promotionalTextColor;
  String? buttonText;
  String? buttonColor;
  String? buttonBackColor;

  factory LoginPageDataModel.fromJson(Map<String, dynamic> json) =>
      LoginPageDataModel(
        status: json["status"],
        promotionalText: json['data']['promotional_text'],
        image: json['data']['images']['image_one'],
        promotionalTextColor: json['data']['promotional_text_color'],
        buttonText: json['data']['button_text'],
        buttonColor: json['data']['button_color'],
        buttonBackColor: json['data']['button_back_color'],
      );

  // Map<String, dynamic> toJson() => {
  //       "status": status,
  //       "data": List<dynamic>.from(data?.map((x) => x.toJson()) ?? []),
  //       "message": message,
  //     };
}
