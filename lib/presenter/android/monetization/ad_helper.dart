import 'dart:io';

import 'package:flutter_lucid_bell/presenter/android/presenter_config.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static InitializationStatus? status;
  static Duration loadTimeout = const Duration(seconds: 20);

  static bool get showAds {
    return ConfigAd.showAds;
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return 'ca-app-pub-3940256099942544/6300978111';
    } else if (Platform.isIOS) {
      return 'ca-app-pub-3940256099942544/2934735716';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/1033173712";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/4411468910";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-3940256099942544/5224354917";
    } else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static Future<InitializationStatus> initAsync() async {
    status = await MobileAds.instance.initialize();
    return await MobileAds.instance.initialize();
  }
}
