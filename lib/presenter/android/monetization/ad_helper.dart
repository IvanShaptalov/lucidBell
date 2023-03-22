import 'dart:io';

import 'package:flutter_lucid_bell/model/singletons_data.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static InitializationStatus? status;
  static Duration loadTimeout = const Duration(seconds: 10);

  static bool get showAds {
    // if not active - show ads, else not show
    return !(appData.subscriptionIsActive);
  }

  static String get rewardedAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-4618505570484622/7719749288";
      return "ca-app-pub-3940256099942544/5224354917"; // test ad
    } /* else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } */
    else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      // return "ca-app-pub-4618505570484622/9034746675";
      return "ca-app-pub-3940256099942544/6300978111"; // test ad
    } /* else if (Platform.isIOS) {
      return "ca-app-pub-3940256099942544/1712485313";
    } */
    else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  static Future<InitializationStatus> initAsync() async {
    status = await MobileAds.instance.initialize();
    return await MobileAds.instance.initialize();
  }
}
