import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/config_android_presenter.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class CustomRewardedAd {
  static bool adCondition(RewardedAd? rewardedAd) {
    if (kDebugMode) {
      print('add condition: ${rewardedAd != null}');
    }
    return ConfigAd.showAds;
  }

  static void showRewardedAd(context, RewardedAd? rewardedAd, String header,
      String description, Function targetFunction,
      {arg}) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
              title: Text(header),
              content: Text(description),
              actions: [
                TextButton(
                  child: Text('cancel'.toUpperCase()),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                rewardedAd == null
                    ? const Text('ad loading')
                    : TextButton(
                        child: Text('watch ad'.toUpperCase()),
                        onPressed: () {
                          Navigator.pop(context);

                          rewardedAd.show(
                            onUserEarnedReward: (_, reward) {
                              if (arg == null) {
                                targetFunction();
                              } else {
                                targetFunction(arg);
                              }
                            },
                          );
                        })
              ]);
        });
  }

  static void showEditingRewardedAd(
      context, RewardedAd? rewardedAd, Function targetFunction) {
    showRewardedAd(context, rewardedAd, 'Edit text',
        'watch ad to edit reminder text', targetFunction);
  }

  static void changeThemeRewardedAd(context, RewardedAd? rewardedAd,
      Function targetFunction, Themes themeName) {
    showRewardedAd(context, rewardedAd, 'Change theme',
        'watch ad to change theme', targetFunction,
        arg: themeName);
  }
}
