class DrawerItemModel {
  final String title;
  final String icon;
  final String linkType;

  DrawerItemModel({
    required this.title,
    required this.icon,
    required this.linkType,
  });

  factory DrawerItemModel.fromJson(Map<String, dynamic> json) {
    return DrawerItemModel(
      title: json['title'] ?? '',
      icon: json['icon'] ?? '',
      linkType: json['link_type'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'icon': icon,
      'link_type': linkType,
    };
  }
}
