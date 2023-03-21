
enum SubscribtionPlan { week, month, sixMonth, year, lifetime }

class SubscriptionApiKeys {
  static const String apiKey = '';
}

class Subscription {
  static void startSubscription(SubscribtionPlan sPlan) {}

  static void renewSubscription(SubscribtionPlan sPlan) {}

  static void cancelSubscription(SubscribtionPlan sPlan) {}

  // static Future<bool> initAsync() async {
  // }
}
