class ImageResource {
  static ImageResource? _instance;
  static ImageResource get instance => _instance ??= ImageResource._init();
  ImageResource._init();

  String toIcons(String name) => 'assets/images/icons/$name';
  String toBanners(String name) => 'assets/images/banners/$name';
  String toViewImage(String name) => 'assets/images/view_images/$name';
  String toAppLogo(String name) => 'assets/images/app_logo/$name';
  String toPlaceholderAndError(String name) =>
      'assets/images/placeholder_and_error/$name';
  String get subsBackground => toViewImage("subscription_background.png");

  String get somethingImage => toViewImage('something.png');
  String get dataNotImage => toPlaceholderAndError('noDataFound.gif');
  String get trading => toPlaceholderAndError('trading.gif');
  String get updateVersionImage => toPlaceholderAndError('update_version.json');
  String get comingSoonImage => toPlaceholderAndError('comingSoon.json');

  /// buttonIcon
  String get arrowCircleIcon => toIcons('circle_right.png');

  String get networkBanner =>
      "https://d2gg9evh47fn9z.cloudfront.net/1600px_COLOURBOX41725446.jpg";

  String get containerBg1 => "https://i.ibb.co/xgw5GgB/img04.jpg";
  String get containerBg2 => "https://iili.io/H03fEiB.jpg";

  /// place holder
  String get errorImage => toPlaceholderAndError('error.png');

  /// app logo
  String get appLogo => toAppLogo('logo.png');

  /// login
  String get celebrations => toPlaceholderAndError('celebrations.gif');
  String get homeCelebrations => toPlaceholderAndError('giphy.gif');
  String get partCelebrations =>
      toPlaceholderAndError('party-celebration.json');
  String get loginBg => toViewImage('sign-in.png');
  String get caution => toPlaceholderAndError('caution.gif');
  String get hello => toPlaceholderAndError('hello.gif');
  String get signUpBg => toViewImage('sign-up.png');
  String get otpImage => toViewImage('illustration.png');
  String get bottomTriangle => toViewImage('bottomTriangle.png');
  String get translateImage => toViewImage('multi-language.png');
  String get googleIcon => toIcons('google.png');
  String get successIcon => toIcons('success.png');
  String get expiredIcon => toIcons('expired.png');
  String get emailIcon => toIcons('email.png');
  String get phoneCallIcon => toIcons('phone_call.png');
  String get facebookIcon => toIcons('facebook.png');
  String get appleIcon => toIcons('apple.png');
  String get checkIcon => toIcons('check_icon.png');
  String get mentorCheckIcon => toIcons('mentor_check.png');
  String get restartIcon => toIcons('restart.png');

  /// root view
  ///
  String get enjoy => toIcons('enjoy.png');
  String get homeIcon => toIcons('people.png');
  String get liveClassesGirl => toIcons('live_classes_girl.jpg');
  String get liveClasses => toIcons('live_classes.jpg');
  String get liveOnePng => toIcons('live_one.png');
  String get liveTwoPng => toIcons('live_two.png');
  String get liveThreePng => toIcons('live_three.png');
  String get liveIconRed => toIcons('live_red.png');

  String get quizOne => toIcons('quiz_one.svg');
  String get quizTwoPng => toIcons('quiz_two.png');

  String get liveIcon => toIcons('live-streaming-01.png');
  String get coursesIcon => toIcons('Component 10 – 1.png');
  String get scalpsIcon => toIcons('video_player.png');
  String get proIcon => toIcons('star.png');
  String get crownIcon => toIcons('crown.png');
  String get trialIcon => toIcons('faq.png');
  String get trialExpireIcon => toIcons('bad-quality.png');
  String get christmasIcon => toIcons('christmas.png');
  String get proExpireIcon => toIcons('faq.png');
  String get proTick => toIcons('protick.png');
  String get overviewIcon => toIcons('overview.png');
  String get receiptsIcon => toIcons('recepits.png');
  String get camaraIcon => toIcons('camara.png');
  String get drawerIcon => toIcons('drawer_icon.png');
  String get notificationIcon => toIcons('notification.png');

  /// drawer icon
  String get closeIcon => toIcons('closeIcon.png');
  String get dashboardIcon => toIcons('dashboard.png');
  String get watchLaterIcon => toIcons('watchLaterIcon.png');
  String get tradingAccountIcon => toIcons('demat.png');
  String get downloadDIcon => toIcons('download.png');
  String get liveClassIcon => toIcons('trader.png');
  String get quizzesIcon => toIcons('grant.png');
  String get promoCodeIcon => toIcons('coupon.png');
  String get shareAppIcon => toIcons('sharing.png');
  String get feedbackIcon => toIcons('comment.png');
  String get faqIcon => toIcons('question-mark.png');
  String get tncIcon => toIcons('tncIcon.png');
  String get phoneIcon => toIcons('phone.png');
  String get referNEarnIcon => toIcons('referral.png');
  String get pastLiveIcon => toIcons('streaming.png');
  String get logoutIcon => toIcons("Sign_Out.png");

  /// quiz icons
  String get quizBg => toViewImage('quiz-vector.png');
  String get quizResultBg => toViewImage('quiz-background.jpg');
  String get timerClockIcon => toIcons('timerClock.png');
  String get retakeIcon => toIcons('retakeIcon.png');
  String get quizResultImage1 => toViewImage('vector 2.png');
  String get quizResultImage2 => toViewImage('quizImage.png');
  String get quizResultImage3 => toViewImage('worldCup.png');
  String get copyIcon => toViewImage('worldCup.png');
  String get schTriangle => toIcons('schTriangle.png');
  String get triangle => toIcons('triangle.png');

  /// home
  String get homeBg => toViewImage('homebg.jpg');
  String get homeBoxBackgroundImage => toBanners('vector-bg-1.png');
  String get notebookIcon => toIcons('notebook.png');
  String get cBg1Icon => toViewImage('bg01.jpg');
  String get cBg2Icon => toViewImage('bg-2.jpg');
  String get starIcon => toIcons('star_icon.png');
  String get starOutLineIcon => toIcons('star_icon.png');
  String get likeIcon => toIcons('addIcon.png');
  String get heartIcon => toIcons('heart_outline.png');
  String get filledHeartIcon => toIcons('heart_icon.png');
  String get filledLikeIcon => toIcons('check_icon.png');
  String get commentIcon => toIcons('message_icon.png');
  String get shareIcon => toIcons('share.png');
  String get topArrowIcon => toIcons('top_arrow.png');
  String get homeBannerTwo => toBanners('banner1.jpg');
  String get homeBannerThree => toBanners('banner2.jpg');
  String get audioScreenLayer => toBanners('audio-layer.png');
  String get volumeIcon => toIcons('volumeIcon.png');
  String get filterIcon => toIcons('filter.png');
  String get batchIcon => toIcons('batch.png');
  String get arrowDownIcon => toIcons('arrow-down.png');
  String get quoteBanner => toIcons('quote.png');
  String get langIcon => toIcons('languageTranslate.png');
  String get playIcon => toIcons('playIcon.png');
  String get lockIcon => toIcons('lock.png');
  String get pauseIcon => toIcons('pause.png');
  String get nextIcon => toIcons('nextIcon.png');
  String get previousIcon => toIcons('previousIcon.png');
  String get stretchIcon => toIcons('streachIcon.png');
  String get shrinkIcon => toIcons('acacca.png');
  String get downloadIcon => toIcons('downloadIcon.png');
  String get saveIcon => toIcons('saveIcon.png');
  String get addIcon => toIcons('addIcon.png');

  /// chat screen
  String get chatBg => toViewImage('banner.jpg');
  String get sendMessage => toIcons('sendMessage.png');

  /// dashboard screen
  String get achievementIcon => toIcons('playIcon.png');
  String get paymentSuccessImg => toViewImage('counselling_success.png');
  String get paymentFailureImg => toViewImage('counselling_failed.png');
  String get coinsIcon => toIcons('coin.png');
  String get silverAchievement => toViewImage('silver.png');
  String get triangleImage => toViewImage('triangle.png');
  String get bronzeAchievement => toIcons('bronze.png');
  String get goldAchievement => toIcons('gold.png');

  /// profile
  String get calendarIcon => toIcons("calander.png");
  String get searchIcon => toIcons("search.png");
  String get dateIcon => toIcons("calendar.png");
  String get editIcon => toIcons("pen.png");

  /// course view
  String get videoCourseIcon => toIcons("AUDIO FILE.png");
  String get audioCourseIcon => toIcons("Component 11 – 1.png");
  String get textCourseIcon => toIcons("acc.png");
  String get batchMedalIcon => toIcons("medal.png");

  // mentorship
  String get mentorshipIcon => toIcons("graduation.png");
  String get profile => toIcons("profile.png");

  /// subscription
  String get subBg => toViewImage("subscription.png");
  String get selectedSubscriptionBoxBG => toViewImage("subscriptionDark.png");
  String get unSelectedSubscriptionBoxBG => toViewImage("subBGlight.png");
  String get offerBg => toViewImage("couponBg.png");
  String get paymentRefund => toIcons("refund.png");

  /// refer and earn
  String get referNEarnBG => toViewImage("referandearn.png");
  String get referNEarnPOPBG => toViewImage("referBG.png");
  String get paymentSuccess => toPlaceholderAndError("succesfull-payment.gif");
  String get paymentFailed => toPlaceholderAndError("payment-failed.gif");
  String get paymentProcessing =>
      toPlaceholderAndError("payment-processing.gif");
  String get paymentProcessing2 =>
      toPlaceholderAndError("payment-processing-2.gif");

  /// no data found
  String get noDataFoundIcon => toPlaceholderAndError("noDataFound.gif");
  String get noInternetIcon => toPlaceholderAndError("disconnect.gif");
  String get contactUs => toPlaceholderAndError("contactUs.json");

  ///  default images
  static const String defaultUser =
      "https://www.dmu.edu/wp-content/uploads/2016/10/default-profile-320x320.jpg";

  /// permission screen
  String get photoPermissionIcon => toIcons('photo_permission.png');
  String get camaraPermissionIcon => toIcons('camara_permission.png');
  String get permissionSettingsIcon => toIcons('permission-settings.png');
}
