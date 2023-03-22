import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/monetization.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomBannerAd {
  static BannerAd? bannerAd;

  static bool exists() {
    return bannerAd != null && AdHelper.showAds;
  }

  static void loadBannerAd(Function updateCallback) async {
    bannerAd = null;
    if (AdHelper.showAds) {
      BannerAd(
        adUnitId: AdHelper.bannerAdUnitId,
        request: const AdRequest(),
        size: AdSize.banner,
        listener: BannerAdListener(
          onAdLoaded: (ad) {
            bannerAd = ad as BannerAd;
            updateCallback();
          },
          onAdFailedToLoad: (ad, err) {
            if (kDebugMode) {
              print('Failed to load a banner ad: ${err.message}');
            }
            ad.dispose();
          },
        ),
      ).load();
    }
  }

  static Widget showBanner() {
    return exists()
        ? Align(
            alignment: Alignment.bottomCenter,
            child: SizedBox(
              width: CustomBannerAd.bannerAd!.size.width.toDouble(),
              height: CustomBannerAd.bannerAd!.size.height.toDouble(),
              child: AdWidget(ad: CustomBannerAd.bannerAd!),
            ),
          )
        : const SizedBox.shrink();
  }
}
