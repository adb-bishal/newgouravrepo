// To parse this JSON data, do
// final userModel = userModelFromJson(jsonString);

import 'dart:convert';

// import 'package:stockpathshala_beta/view/widgets/log_print/log_print_condition.dart';

UserModel userModelFromJson(String str) => UserModel.fromJson(json.decode(str));

String userModelToJson(UserModel data) => json.encode(data.toJson());

class UserModel {
  bool? status;
  Data? data;
  String? message;

  UserModel({this.status, this.data, this.message});

  UserModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    data = json['data'] != null ? Data.fromJson(json['data']) : null;
    message = json['message'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    data['message'] = message;
    return data;
  }
}

class Data {
  int? id;
  bool? isGuest;
  String? name;
  String? email;
  String? mobileNo;
  String? profileImage;
  dynamic gender;
  dynamic active;
  dynamic referredBy;
  String? referralCode;
  dynamic dob;
  dynamic referralAmount;
  int? totalPoints;
  int? languageId;
  Language? language;
  dynamic levelId;
  dynamic level;
  List<Categories>? tags;
  List<Categories>? categories;
  int? liveCount;
  dynamic newsletterNotify;
  int? isPro;
  int? isTrial;
  DateTime? proExpireAt;
  dynamic pushNotify;
  String? lastLogin;
  UserSubscription? userSubscription;
  List<AllUserSubscription>? allUserSubscription;
  String? createdAt;

  // Add userRoleIcons property of type UserRoleIcons
  UserRoleIcons? userRoleIcons;

  Data({
    this.id,
    this.isGuest,
    this.name,
    this.email,
    this.mobileNo,
    this.profileImage,
    this.gender,
    this.active,
    this.referredBy,
    this.referralCode,
    this.dob,
    this.referralAmount,
    this.totalPoints,
    this.languageId,
    this.language,
    this.levelId,
    this.level,
    this.tags,
    this.categories,
    this.liveCount,
    this.newsletterNotify,
    this.isPro,
    this.isTrial,
    this.proExpireAt,
    this.pushNotify,
    this.lastLogin,
    this.userSubscription,
    this.allUserSubscription,
    this.createdAt,
    this.userRoleIcons,
  });

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    isGuest = json['is_guest'] ?? false;
    name = json['name'];
    email = json['email'];
    mobileNo = json['mobile_no'];
    profileImage = json['profile_image'];
    gender = json['gender'];
    active = json['active'];
    referredBy = json['referred_by'];
    referralCode = json['referral_code'];
    dob = json['dob'];
    referralAmount = json['referral_amount'];
    totalPoints = json['total_points'];
    languageId = json['language_id'];
    language =
    json['language'] != null ? Language.fromJson(json['language']) : null;
    levelId = json['level_id'];
    level = json['level'];
    if (json['tags'] != null) {
      tags = <Categories>[];
      json['tags'].forEach((v) {
        tags!.add(Categories.fromJson(v));
      });
    }
    if (json['categories'] != null) {
      categories = <Categories>[];
      json['categories'].forEach((v) {
        categories!.add(Categories.fromJson(v));
      });
    }
    liveCount = json['free_live_class_count'];
    newsletterNotify = json['newsletter_notify'];
    isPro = json['is_pro'];
    isTrial = json['is_trial'];
    proExpireAt = DateTime.tryParse(json['pro_expired_at'] ?? '');
    pushNotify = json['push_notify'];
    lastLogin = json['last_login'];
    userSubscription = json['user_subscription'] != null
        ? UserSubscription.fromJson(json['user_subscription'])
        : null;
    if (json['all_user_subscription'] != null) {
      allUserSubscription = <AllUserSubscription>[];
      json['all_user_subscription'].forEach((v) {
        allUserSubscription!.add(AllUserSubscription.fromJson(v));
      });
    }
    createdAt = json['created_at'];

    // Initialize userRoleIcons as an instance of UserRoleIcons
    userRoleIcons = json['user_role_icons'] != null
        ? UserRoleIcons.fromJson(json['user_role_icons'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['is_guest'] = isGuest;
    data['name'] = name;
    data['email'] = email;
    data['mobile_no'] = mobileNo;
    data['profile_image'] = profileImage;
    data['gender'] = gender;
    data['active'] = active;
    data['referred_by'] = referredBy;
    data['referral_code'] = referralCode;
    data['dob'] = dob;
    data['referral_amount'] = referralAmount;
    data['total_points'] = totalPoints;
    data['language_id'] = languageId;
    if (language != null) {
      data['language'] = language!.toJson();
    }
    data['level_id'] = levelId;
    data['level'] = level;
    if (tags != null) {
      data['tags'] = tags!.map((v) => v.toJson()).toList();
    }
    if (categories != null) {
      data['categories'] = categories!.map((v) => v.toJson()).toList();
    }
    data['free_live_class_count'] = liveCount;
    data['newsletter_notify'] = newsletterNotify;
    data['is_pro'] = isPro;
    data['pro_expired_at'] = proExpireAt.toString();
    data['push_notify'] = pushNotify;
    data['last_login'] = lastLogin;
    if (userSubscription != null) {
      data['user_subscription'] = userSubscription!.toJson();
    }
    if (allUserSubscription != null) {
      data['all_user_subscription'] =
          allUserSubscription!.map((v) => v.toJson()).toList();
    }
    data['created_at'] = createdAt;

    // Add userRoleIcons to JSON output
    if (userRoleIcons != null) {
      data['user_role_icons'] = userRoleIcons!.toJson();
    }

    return data;
  }
}

class UserRoleIcons {
  String? freshUserIconUrl;
  String? trialUserIconUrl;
  String? trialExpiredUserIconUrl;
  String? proUserIconUrl;
  String? proExpiredUserIconUrl;

  UserRoleIcons({
    this.freshUserIconUrl,
    this.trialUserIconUrl,
    this.trialExpiredUserIconUrl,
    this.proUserIconUrl,
    this.proExpiredUserIconUrl,
  });

  // From JSON constructor
  UserRoleIcons.fromJson(Map<String, dynamic> json) {
    freshUserIconUrl = json['fresh_user_icon_url'];
    trialUserIconUrl = json['trial_user_icon_url'];
    trialExpiredUserIconUrl = json['trial_expired_user_icon_url'];
    proUserIconUrl = json['pro_user_icon_url'];
    proExpiredUserIconUrl = json['pro_expired_user_icon_url'];
  }

  // To JSON method
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['fresh_user_icon_url'] = freshUserIconUrl;
    data['trial_user_icon_url'] = trialUserIconUrl;
    data['trial_expired_user_icon_url'] = trialExpiredUserIconUrl;
    data['pro_user_icon_url'] = proUserIconUrl;
    data['pro_expired_user_icon_url'] = proExpiredUserIconUrl;
    return data;
  }
}


class Language {
  int? id;
  String? englishLanguageName;
  String? languageName;
  int? index;
  int? isActive;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;

  Language(
      {this.id,
      this.englishLanguageName,
      this.languageName,
      this.index,
      this.isActive,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  Language.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    englishLanguageName = json['english_language_name'];
    languageName = json['language_name'];
    index = json['index'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['english_language_name'] = englishLanguageName;
    data['language_name'] = languageName;
    data['index'] = index;
    data['is_active'] = isActive;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class Categories {
  int? id;
  int? index;
  String? title;
  String? description;
  String? tamilTitle;
  String? tamilDescription;
  String? hindiTitle;
  String? hindiDescription;
  String? gujaratiTitle;
  String? gujaratiDescription;
  String? teluguTitle;
  String? teluguDescription;
  String? image;
  String? categoryIds;
  int? isActive;
  String? deletedAt;
  String? createdAt;
  String? updatedAt;
  Pivot? pivot;

  Categories(
      {this.id,
      this.index,
      this.title,
      this.description,
      this.tamilTitle,
      this.tamilDescription,
      this.hindiTitle,
      this.hindiDescription,
      this.gujaratiTitle,
      this.gujaratiDescription,
      this.teluguTitle,
      this.teluguDescription,
      this.image,
      this.categoryIds,
      this.isActive,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.pivot});

  Categories.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    index = json['index'];
    title = json['title'];
    description = json['description'];
    tamilTitle = json['tamil_title'];
    tamilDescription = json['tamil_description'];
    hindiTitle = json['hindi_title'];
    hindiDescription = json['hindi_description'];
    gujaratiTitle = json['gujarati_title'];
    gujaratiDescription = json['gujarati_description'];
    teluguTitle = json['telugu_title'];
    teluguDescription = json['telugu_description'];
    image = json['image'];
    categoryIds = json['category_ids'];
    isActive = json['is_active'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    pivot = json['pivot'] != null ? Pivot.fromJson(json['pivot']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['index'] = index;
    data['title'] = title;
    data['description'] = description;
    data['tamil_title'] = tamilTitle;
    data['tamil_description'] = tamilDescription;
    data['hindi_title'] = hindiTitle;
    data['hindi_description'] = hindiDescription;
    data['gujarati_title'] = gujaratiTitle;
    data['gujarati_description'] = gujaratiDescription;
    data['telugu_title'] = teluguTitle;
    data['telugu_description'] = teluguDescription;
    data['image'] = image;
    data['category_ids'] = categoryIds;
    data['is_active'] = isActive;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    if (pivot != null) {
      data['pivot'] = pivot!.toJson();
    }
    return data;
  }
}

class Pivot {
  int? userId;
  int? categoryId;

  Pivot({this.userId, this.categoryId});

  Pivot.fromJson(Map<String, dynamic> json) {
    userId = json['user_id'];
    categoryId = json['category_id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['user_id'] = userId;
    data['category_id'] = categoryId;
    return data;
  }
}

class UserSubscription {
  int? id;
  int? userId;
  dynamic promoCode;
  dynamic promoCodeId;
  int? subscriptionId;
  int? batchId;
  int? batchStartDate;
  int? superSub;
  int? pastSubscription;
  dynamic paymentGatewayId;
  String? transactionId;
  dynamic orderRefNo;
  int? amount;
  dynamic discount;
  String? paymentStatus;
  int? status;
  String? startDate;
  DateTime? endDate;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;

  UserSubscription(
      {this.id,
      this.userId,
      this.promoCode,
      this.promoCodeId,
      this.subscriptionId,
      this.batchId,
      this.batchStartDate,
      this.superSub,
      this.pastSubscription,
      this.paymentGatewayId,
      this.transactionId,
      this.orderRefNo,
      this.amount,
      this.discount,
      this.paymentStatus,
      this.status,
      this.startDate,
      this.endDate,
      this.deletedAt,
      this.createdAt,
      this.updatedAt});

  UserSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    promoCode = json['promo_code'];
    promoCodeId = json['promo_code_id'];
    subscriptionId = json['subscription_id'];
    batchId = json['batch_id'];
    batchStartDate = json['batch_start_date'];
    superSub = json['super_subscription'];
    pastSubscription = json['past_subscription'];
    paymentGatewayId = json['payment_gateway_id'];
    transactionId = json['transaction_id'];
    orderRefNo = json['order_ref_no'];
    amount = json['amount'];
    discount = json['discount'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = DateTime.tryParse(json['end_date']) ?? DateTime.now();
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['promo_code'] = promoCode;
    data['promo_code_id'] = promoCodeId;
    data['subscription_id'] = subscriptionId;
    data['batch_id'] = batchId;
    data['batch_start_date'] = batchStartDate;
    data['super_subscription'] = superSub;
    data['past_subscription'] = pastSubscription;
    data['payment_gateway_id'] = paymentGatewayId;
    data['transaction_id'] = transactionId;
    data['order_ref_no'] = orderRefNo;
    data['amount'] = amount;
    data['discount'] = discount;
    data['payment_status'] = paymentStatus;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate.toString();
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    return data;
  }
}

class AllUserSubscription {
  int? id;
  int? userId;
  dynamic promoCode;
  dynamic promoCodeId;
  int? subscriptionId;
  int? batchId;
  int? batchStartDate;
  int? superSubscription;
  int? pastSubscription;
  dynamic paymentGatewayId;
  String? transactionId;
  dynamic orderRefNo;
  int? amount;
  dynamic discount;
  String? paymentStatus;
  int? status;
  String? startDate;
  String? endDate;
  dynamic deletedAt;
  String? createdAt;
  String? updatedAt;
  String? batchesDates;

  AllUserSubscription(
      {this.id,
      this.userId,
      this.promoCode,
      this.promoCodeId,
      this.subscriptionId,
      this.batchId,
      this.batchStartDate,
      this.superSubscription,
      this.pastSubscription,
      this.paymentGatewayId,
      this.transactionId,
      this.orderRefNo,
      this.amount,
      this.discount,
      this.paymentStatus,
      this.status,
      this.startDate,
      this.endDate,
      this.deletedAt,
      this.createdAt,
      this.updatedAt,
      this.batchesDates});

  AllUserSubscription.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    promoCode = json['promo_code'];
    promoCodeId = json['promo_code_id'];
    subscriptionId = json['subscription_id'];
    batchId = json['batch_id'];
    batchStartDate = json['batch_start_date'];
    superSubscription = json['super_subscription'];
    pastSubscription = json['past_subscription'];
    paymentGatewayId = json['payment_gateway_id'];
    transactionId = json['transaction_id'];
    orderRefNo = json['order_ref_no'];
    amount = json['amount'];
    discount = json['discount'];
    paymentStatus = json['payment_status'];
    status = json['status'];
    startDate = json['start_date'];
    endDate = json['end_date'];
    deletedAt = json['deleted_at'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    batchesDates = json['batches_dates'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['promo_code'] = promoCode;
    data['promo_code_id'] = promoCodeId;
    data['subscription_id'] = subscriptionId;
    data['batch_id'] = batchId;
    data['batch_start_date'] = batchStartDate;
    data['super_subscription'] = superSubscription;
    data['past_subscription'] = pastSubscription;
    data['payment_gateway_id'] = paymentGatewayId;
    data['transaction_id'] = transactionId;
    data['order_ref_no'] = orderRefNo;
    data['amount'] = amount;
    data['discount'] = discount;
    data['payment_status'] = paymentStatus;
    data['status'] = status;
    data['start_date'] = startDate;
    data['end_date'] = endDate;
    data['deleted_at'] = deletedAt;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['batches_dates'] = batchesDates;
    return data;
  }
}
