import 'package:flutter_lucid_bell/presenter/android/config_android_presenter.dart';

class CustomRewardedAd {
  static Duration loadTimeout = const Duration(seconds: 20);
  static bool get showAds {
    return ConfigAd.showAds;
  }
}
