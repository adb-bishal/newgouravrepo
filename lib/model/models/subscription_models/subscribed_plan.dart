class SubscribedPlan {
  int? subscriptionId;
  String? message;
  String? created_date;
  int? days;
  SubscribedPlan({
    this.subscriptionId,
    this.message,
    this.created_date,
    this.days,
  });
// [GETX] {subscription_id: 17, is_trial: 1, start_date: 2024-06-18, end_date: 2024-06-22}
  factory SubscribedPlan.fromJson(Map<String, dynamic> json) => SubscribedPlan(
        subscriptionId: json["subscription_id"] ?? 0,
        message: json["message"] ?? "",
        created_date: json["created_date"] ?? "",
        days: json["days"] ?? 0,
      );

  Map<String, dynamic> toJson() => {
        "subscription_id": subscriptionId,
        "message": message,
        "created_date": created_date,
        "days": days,
      };
}
