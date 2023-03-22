class AppData {
  static final AppData _appData = AppData._internal();

  bool _subscriptionIsActive = false; //has premium
  set subscriptionIsActive(bool value) =>
      _subscriptionIsActive = value; //has premium

  bool get subscriptionIsActive {
    // check that subscription exists
    print('check for subscription');
    return _subscriptionIsActive;
  }

  String appUserId = '';

  factory AppData() {
    return _appData;
  }

  AppData._internal();
}

final appData = AppData();
