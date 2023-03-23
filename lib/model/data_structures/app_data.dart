class AppData {
  static final AppData _appData = AppData._internal();

  // if subscription active - delete ads
  bool subscriptionIsActive = false; 

  String appUserId = '';

  factory AppData() {
    return _appData;
  }

  AppData._internal();
}

final appData = AppData();
