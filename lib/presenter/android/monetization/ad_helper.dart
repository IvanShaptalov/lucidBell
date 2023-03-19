import 'dart:io';

import 'package:flutter_lucid_bell/presenter/android/config_presenter.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static InitializationStatus? status;
  static Duration loadTimeout = const Duration(seconds: 10);

  static bool get showAds {
    return ConfigAd.showAds;
  }



  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      return "ca-app-pub-4618505570484622/7719749288";
      // return "ca-app-pub-3940256099942544/5224354917";  // test ad
    } /* else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } */ else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static Future<InitializationStatus> initAsync() async {
    status = await MobileAds.instance.initialize();
    return await MobileAds.instance.initialize();
  }
}
