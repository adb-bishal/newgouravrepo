import 'package:get/get.dart';

class StringResource {
  static StringResource? _instance;

  static StringResource get instance => _instance ??= StringResource._init();

  StringResource._init();

  String get currentUser => 'currentUser';
  String get guestUser => 'guest';
  String get loginKey => "isLoggedIn";
  String get remember => "remember";
  String get token => "token";
  String get fcmToken => "fcmToken";
  String get isPermission => 'isPermission';
  String get activeTime => 'activeTime';
  String get lastTime => 'lastTime';
  String get trainingTooltips => 'trainingTooltips';
  String get classLevel => 'classLevel';
  final String selectedDatesKey = "selected_dates";


  String get appName => "Stock Pathshala";


  static String downloading = "Downloading";
  static String notDownload = "notDownload";
  static String downloaded = "Downloaded";
  static String downloadProcessing = "downloadProcessing";

  /// no data string
  static String noFileFound =
      "There is some update in this course please Re-Download".tr;
  static String seeAllText = "Select Your 'Choice of Interest' to ".tr;
  static String addDataToWatchLater = "Add Some Courses to Watch Later".tr;
  static String viewBlogContent = "View Blogs".tr;
  static String listenPodcasts = "Listen Stock Pathshala Podcasts".tr;
  static String listenAudioCourse = "Listen Audio Courses".tr;
  static String listenVideoLesson = "Watch Video Lessons".tr;
  static String listenVideoCourse = "Watch Video Courses".tr;
  static String readTextCourse = "Read Text Courses".tr;
  static String askStoragePermission =
      "Allow Stockpathshala to access your device's storage? We need access to download videos for offline viewing."
          .tr;
  static String noUserPromoData =
      "Attend Quizzes or Refer App to Avail Promocodes.".tr;

  /// login
  static String proRequireText =
      "Quickly Buy Pro to access all Premium Stock Market Content. Continue?"
          .tr;
  static String liveCountText = "You Have".tr;
  static String quizAttempted = "You have already attempted this quiz".tr;
  static String noInternetAccess =
      "Check your Wi-Fi or Internet connection: Make sure that your device is properly connected to your Mobile Network or Wi-Fi."
          .tr;
  static String okay = "Okay".tr;
  static String userPromoCode = "List of Promo Codes for You".tr;
  // static String redeemNow = "Redeem Now".tr;
  static String liveSubTitleCountText = "Free Live Classes".tr;
  static String liveSubTitleCountSingularText = "Free Live Class".tr;
  static String signInRequireText =
      "Please Sign in/up to Stock Pathshala in order to access this feature now!"
          .tr;
  static String paymentSuccess = "Payment Success".tr;
  static String paymentFail = "Payment Failed".tr;
  static String successPayment =
      "Your payment was successful\nNow you can watch our pro courses".tr;
  static String failPayment =
      "We can't process your payment\nPlease try again\nFeel free to contact us."
          .tr;
  static String confirmPayment =
      "Your payment is under process\nPlease wait while we confirm your payment\nFeel free to contact us."
          .tr;
  static String goBack = "Go Back".tr;
  static String skip = "Skip".tr;
  static String courses = "Chapters".tr;
  static String chapter = "Chapter".tr;
  static String feedbackEmptyError = "Please enter your feedback".tr;
  static String feedbackCorrectError = "Please enter at least one character".tr;
  static String yourInfo = "Your Info".tr;
  static String quizFilter = "Quiz Filter".tr;
  static String onDownloadButton =
      "Please Complete The Course And Quiz To Download The Certificate.".tr;
  static String onDownloadQuiz =
      "Please Complete The Course To Attempt The Quiz.".tr;
  static String videoLessons = "Video Lessons".tr;
  static String videoHeadLessons = "Stock Pathshala Videos".tr;
  static String blogHeadLessons = "Stock Pathshala Blogs".tr;
  static String audioLessons = "Audio Lessons & Podcasts".tr;
  static String audioHeadLessons = "Stock Pathshala Podcasts".tr;
  static String alreadyApplied = "This Coupon Already Applied".tr;
  static String name = "Name".tr;
  static String signUpWith = "Sign Up with".tr;
  static String email = "Email".tr;
  static String reviewAdded = "Your review submitted successfully".tr;
  static String choiceOfInterest = "Choice of Interest".tr;
  static String interestCanSelect = "Any no. of Interests can be Selected".tr;
  static String welcomeTo = "Welcome to".tr;
  static String explore = "Explore".tr;
  static String viewAllChapter = "View all Chapters related to".tr;
  static String emailValidError =
      "Please enter your email address or mobile number".tr;
  static String emailInvalidError = "Please enter valid email".tr;
  static String nameInvalidError = "Please enter valid name".tr;
  static String mobileInvalidError = "Entered mobile number is invalid".tr;

  static String signIn = "Sign In".tr;
  static String courseFilter = "Course Filter".tr;
  static String imageUpdateSuccess = "Image Successfully Updated".tr;
  static String or = "or".tr;
  static String openAccountText =
      "Open Exclusive Free Demat Account With Zero AMC & Low Brokerage".tr;
  static String terms = "Terms And Conditions".tr;
  static String start = "Start".tr;
  static String logOut = "LOGOUT".tr;
  static String deleteAccount = "Delete Account".tr;
  static String updateProfile = "UPDATE PROFILE".tr;
  static String profile = "Profile".tr;
  static String dontHaveAccount = "Don’t Have an Account?".tr;
  static String signUp = "Sign Up".tr;
  static String bySignUp = "By signing up, you accept the".tr;
  static String privacyPolicy = "Privacy Policy".tr;
  static String privacyPolicyCheck = "Please accept Privacy Policy".tr;
  static String offApp = "of the app.".tr;
  static String selectASubscription = "Please select a plan".tr;
  static String enterOfferCode = "Please enter promocode".tr;
  static String signWith = "Sign up with".tr;
  static String enter4Digit =
      "Please Enter the 4 digits code that you\nreceived on your Mobile.".tr;
  static String resendCode = "RESEND CODE".tr;
  static String verifyAndProcess = "Verify & Proceed".tr;
  static String contentRelate = "Content related to".tr;
  static String typeAMessage = "Type a message...".tr;
  static String typeAComment = "Write a comment...".tr;
  static String courseLevel = "Courses Level".tr;
  static String blogsFilter = "Blogs Filter".tr;
  static String exploreAll = "Explore All".tr;
  static String exploreAllCategory = "EXPLORE ALL CATEGORIES".tr;
  static String exploreAllCategories = "Explore all the categories".tr;
  static String viewAll = "View All".tr;
  static String relateTo = "related to".tr;
  static String chapters = "Chapters".tr;
  static String hello = "Hello".tr;
  static String totalUp = "TOTAL".tr;
  static String redeemNow = "REDEEM NOW".tr;
  static String achievment = "Achievements".tr;
  static String attendedQuiz = "Attended Quizzes".tr;
  static String avgQuiz = "Average Quiz Score".tr;
  static String streaks = "Streaks".tr;
  static String setGoal = "Set Goal".tr;
  static String minutes = "Minutes".tr;
  static String pleaseEnterMinute = "Please enter minutes".tr;
  static String enterCorrectMinute = "Please enter correct minutes".tr;
  static String enterMin = "Enter minutes".tr;
  static String add = "ADD".tr;
  static String delete = "DELETE".tr;
  static String userAvgTime = "User Average Time".tr;
  static String achiever = "ACHIEVER".tr;
  static String courseComplete = "Courses Completed".tr;
  static String awesome = 'AWESOME'.tr;
  static String subscription = "Be a Pro".tr;
  static String applyCoupon = "Enter a promo Code".tr;
  static String apply = "APPLY".tr;
  static String applied = "APPLIED".tr;
  static String select = "SELECT".tr;
  static String viewMoreOffers = "View More Offers".tr;
  static String buyNow = "Be a Pro".tr;
  static String buyNowAgain = "Buy Now".tr;

  static String updatePlan = "Upgrade Plan".tr;
  static String likes = "Likes".tr;
  static String like = "Like".tr;
  static String comments = "Comments".tr;
  static String comment = "Comment".tr;
  static String share = "Share".tr;
  static String shares = "Shares".tr;
  static String submit = "SUBMIT".tr;
  static String continueLearning = "Let’s Continue Learning".tr;
  static String tradingCourses = "Trending $course".tr;
  static String liveWebinar = "Live $webinar".tr;
  static String liveClassHeading = "LIVE STOCK MARKET CLASSES".tr;
  static String batchesHeading = 'LIVE BATCHES'.tr;

  static String scalps = "Scalps".tr;
  static String topTen = "Top 10 Stock Market Courses".tr;
  static String quickQuiz = "Let’s Take a Quick Quiz".tr;
  static String blogs = "Blogs".tr;
  static String videos = "Videos".tr;
  static String specialSale = "SPECIAL SALE".tr;
  static String offerAndBeneifits = "Offers & Benefits".tr;
  static String goodMorning = 'Good Morning'.tr;
  static String goodEvening = 'Good Evening'.tr;
  static String goodAfternoon = 'Good Afternoon'.tr;
  static String paymentSummery = 'Payment Summary'.tr;
  static String batchDetails = 'Batch Details'.tr;
  static String chooseBatch = '1. Choose Batch'.tr;
  static String subBatch = '2. Choose Batch Date'.tr;
  static String subTotal = 'Sub Total'.tr;
  static String couponApplied = 'Coupon Applied'.tr;
  static String discount = 'Discount'.tr;

  static String tax = 'Tax'.tr;
  static String totalPayable = 'Total Payable'.tr;
  static String remove = 'REMOVE'.tr;
  static String cancel = "Cancel".tr;
  static String yes = "Yes".tr;
  static String callBackArrange = 'Your Callback has been arranged.'.tr;
  static String shallArrangeCall =
      '"Great! Shall we arrange a quick callback?"'.tr;
  static String chooseOneLanguage =
      '"Only one Language can be selected at once"'.tr;
  static String choosePrefferLang = "Choose Your Preferred Language".tr;

  static String enterReferCode = "Enter Referral Code".tr;
  static String emptyReferError = "Please enter refer code".tr;
  static const String emailOrMobile = "Email or Mobile Number";
  static const String mobileNumber = "Enter Phone Number";
  static const String enterEmail = "Email Address";
  static const String enterMobile = "Mobile Number";
  static const String enterOtpF = "OTP";
  static const String enterDob = "Date of Birth";
  static const String enterName = "Name";

  /// drawer list tile title
  static const String dashboard = "Dashboard";
  static const String watchLater = "Watch Later";
  static const String scalpsText = 'Scalps';
  static const String openTradingAccount = "Ask Anything";
  static const String arrangeCallback = "Arrange a Callback";
  static const String drawerCourses = "Courses";

  static const String downloads = "Downloads";
  static const String myLiveClasses = "My Live Classes";
  static const String quizzes = "Quizzes";
  static const String pastLiveClasses = "Class Recordings";

  static const String promoCodes = "Promocodes";
  static const String shareApp = "Share App";
  static const String feedback = "Give Feedback";
  static const String faq = "FAQ's";
  static const String tnc = "Terms & Conditions";
  static const String referNEarn = "Refer & Earn";
  static const String becomeAPro = "Become a Pro";
  static const String setting = "Setting";
  static const String udios = "Setting";
  static String coupon = "Coupons".tr;

  /// Navbar titles
  static const String home = 'Counselling';

  static const String course = 'Courses';
  static const String mentorship = 'Mentorship';
  static const String batches = 'Batches';
  static const String webinar = 'Webinar';
  static const String batchSub = 'Buy Pro';
  static const String noMentor = 'No Mentors Found ';

  static const String gtUser = 'Guest User';
  static const String freshUser = 'Fresh User';
  static const String trialUser = 'Offers';
  static const String trialExpiredUser = 'Offers';
  static const String batchSub2 = 'Pro User';
  static const String proExpiredUser = 'Offers';
  static const String paymentInProgress = 'Payment in Progress..';

  /// quizes
  static String allQuizzes = "List of Quizzes".tr;

  ///mentor screen
  static String chooseYourMentor = "Choose Your Mentor".tr;
  static String skipAndBookCounselling = "Skip & Book Counselling".tr;
  static String reviewAndConfirmCounselling = "Review and confirm your counselling".tr;
  static String skipAndPay = "Skip and pay".tr;
  static String confirmAndPay = "Confirm & Pay".tr;
  static String whatsappConfirmationNote = "You'll receive a confirmation via Whatsapp after booking".tr;
  static String selectYourPreferredDateForCounselling = "Select your preferred date for counselling".tr;
  static String bookCounselling = "Book Counselling".tr;
  static String pnlVerified = "PnL Verified".tr;
  static String chooseSlot = "Choose Slot".tr;
  /// rating
  static String noRatingFound = "No Rating Available".tr;
  static String seeAllReview = "SEE ALL REVIEWS".tr;
  static String addReview = "GIVE REVIEWS".tr;
  static String courseRatingHeading = " Ratings & Reviews".tr;

  /// promocode
  static String availNow = "AVAIL NOW";
  static String availNowSmall = "Avail Now";
  static String expireOn = "Expires on";

  /// audio
  static String description = "Description";
  static const String audios = "Audios";
  static const String videoss = "Videos";

  static String nowPlaying = "NOW PLAYING";
  static String download = "Download";
  static String moreLike = "More like this";

  /// error
  static String noDataFound = "No Data Found";
  static String emptyTagsError = "Please select at least two interest";
  static const String validPasswordError =
      "Enter a password with minimum of 8 characters containing at least one number, one capital letter, and one special character";
  static const String enterPasswordError = "Please enter password";
  static const String oldPasswordError = "Please enter old password";
  static const String notMatchedPasswordError = "Your password doesn't match";
  static const String validEmailPhoneError =
      "Please enter email address / contact number";
  static const String correctPhoneError = "Please enter correct contact number";
  static const String emptyPhoneError = "Please enter contact number";
  static const String enterOtp = "Please enter OTP";
  static const String validEmailError = "Please enter valid email address";
  static const String emptyEmailError = "Please enter email address";
  static const String emptyDobError = "Please select date of birth";
  static const String emptyLastError = "Please enter last name";
  static const String emptyFirstError = "Please enter first name";
  static const String emptyBusinessError = "Please enter business name";

  static const String emptyAddressError = "Please enter address";
  static const String emptyItemError = "Please enter item name";
  static const String emptyNameError = "Please enter name";

  static const String correctNameError = "Please Enter Correct Name";
  static const String emptyMessageError = "Please Enter Message";
  // courses view
  static const String coursesHeading = "Courses";
  static const String allCourses = "All Courses";
  static const String freeOptionTrading = "FREE OPTION TRADING COURSES";
  // wishlist view
  static const String singleVideo = "Single Category Videos";
  static const String singleAudio = "Single Category Audio";
  static const String videoCourses = "Video Courses";
  static const String audioCourses = "Audio Courses";
  static const String textCourses = "Text Courses";
  static const String buyPro = "Buy Pro";

  static const String blogsL = "Blogs";
  // quiz
  static const String question = "QUESTION";
  static const String questionL = "Question";
  static const String quizComplete = "Quiz Completed";
  static const String oops = "OOPS!";
  static const String congratulations = "Congratulations!";
  static const String score = "SCORE";
  static const String freeNotEligableQuiz =
      "Oops you are not eligible, Please retake this Quiz.";
  static const String notEligableQuiz =
      "Oops you are not eligible to get the reward, Please retake this Quiz.";
  static const String timeUp = "Your time is up, Kindly retake\nthe quiz.";
  static const String retake = "RETAKE";
  static const String continueText = "CONTINUE";
  static const String eligableQuiz =
      "You are eligible for certificate, kindly\ndownload it from here";
  static const String downloadCertificate = "Download Certificate";
  static const String credits = "Credits";
  static const String code = "Code";
  static const String viewOtherCourses = "VIEW OTHER COURSES";

  static const String dobDateFormat = "dd/MM/yyyy";

  /// guest user
  static const String guestUserName = "Guest";
}

extension MyString on String {
  String get seperateWithCommas => _withCommas(this);

  _withCommas(String data) {
    RegExp reg = RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))');
    mathFunc(Match match) => '${match[1]},';

    return data.replaceAllMapped(reg, mathFunc);
  }
}
