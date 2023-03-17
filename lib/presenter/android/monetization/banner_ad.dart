import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/ad_helper.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBannerAd {
  static bool adCondition(BannerAd? bannerInstance) {
    if (kDebugMode) {
      print('add condition: ${bannerInstance != null}');
    }
    return bannerInstance != null && AdHelper.showAds;
  }

  static Widget showBanner(BannerAd bannerInstance) {
    return Align(
      alignment: Alignment.topCenter,
      child: SizedBox(
        width: bannerInstance.size.width.toDouble(),
        height: bannerInstance.size.height.toDouble(),
        child: AdWidget(ad: bannerInstance),
      ),
    );
  }
}
