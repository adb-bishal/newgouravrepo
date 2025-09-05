class DimensionResource {
  static DimensionResource? _instance;
  static DimensionResource get instance =>
      _instance ??= DimensionResource._init();
  DimensionResource._init();

  /// size 10
  static const double fontSizeExtraSmall = 10;

  /// size 12
  static const double fontSizeSmall = 12;

  /// size 14
  static const double fontSizeDefault = 14;

  /// size 16
  static const double fontSizeLarge = 16;

  /// size 18
  static const double fontSizeExtraLarge = 18;

  /// size 20
  static const double fontSizeDoubleExtraLarge = 20;

  /// size 24
  static const double fontSizeOverLarge = 24;

  /// size 26
  static const double fontSizeOverExtraLarge = 26;

  /// size 5
  static const double paddingSizeExtraSmall = 5;

  /// size 10
  static const double paddingSizeSmall = 10;

  /// size 15
  static const double paddingSizeDefault = 15;

  /// size 18
  static const double paddingSizeLarge = 18;

  /// size 20
  static const double paddingExtraSizeLarge = 20;

  /// size 25
  static const double paddingSizeExtraLarge = 25;

  /// size 5
  static const double marginSizeExtraSmall = 5;

  /// size 10
  static const double marginSizeSmall = 10;

  /// size 15
  static const double marginSizeDefault = 15;

  /// size 20
  static const double marginSizeLarge = 20;

  /// size 25
  static const double marginSizeExtraLarge = 25;

  /// size 45
  static const double marginSizeOverExtraLarge = 45;

  /// size 12
  static const double iconSizeExtraSmall = 12;

  /// size 18
  static const double iconSizeSmall = 18;

  /// size 24
  static const double iconSizeDefault = 24;

  /// size 28
  static const double iconSizeLarge = 28;

  /// size 40
  static const double iconSizeExtraLarge = 40;

  /// size 8
  static const double appDefaultRadius = 8;

  /// size 12
  static const double appDefaultContainerRadius = 12;

  /// size 50
  static const double roundButtonRadius = 50;

  /// size of 8
  static const double borderRadiusDefault = 8;

  /// size of 14
  static const double borderRadiusMedium = 14;

  /// size of 30
  static const double borderRadiusExtraLarge = 30;
}
