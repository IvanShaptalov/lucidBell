import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/ad_helper.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/rewarded_ad.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:flutter_lucid_bell/view/view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: must_be_immutable
class CustomThemes extends StatefulWidget {
  Function updateCallback;
  static Themes _themeValue = View.currentTheme.themeEnum;

  CustomThemes(this.updateCallback, {super.key});

  void setTheme(Themes newTheme) {
    _themeValue = newTheme;
    View.currentTheme = CustomTheme.selectTheme(theme: newTheme);
    View.currentTheme.saveToStorageAsync(View.currentTheme.themeEnum);
    updateCallback();
  }

  @override
  State<CustomThemes> createState() => _CustomThemesState();
}

class _CustomThemesState extends State<CustomThemes> {
  RewardedAd? _rewardedAd;

  @override
  void initState() {
    _loadRewardedAd();

    super.initState();
  }

  void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              setState(() {
                ad.dispose();
                _rewardedAd = null;
              });
              _loadRewardedAd();
            },
          );

          setState(() {
            _rewardedAd = ad;
          });
        },
        onAdFailedToLoad: (err) {
          if (kDebugMode) {
            print('Failed to load a rewarded ad: ${err.message}');
          }
        },
      ),
    );
  }

  void setTheme(Themes themeName) {
    setState(() {
      widget.setTheme(themeName);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Radio(
              value: Themes.orange,
              groupValue: CustomThemes._themeValue,
              activeColor: const Color.fromARGB(255, 240, 255, 114),
              fillColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 240, 255, 114)),
              onChanged: (value) {
                if (CustomRewardedAd.adCondition(_rewardedAd)) {
                  CustomRewardedAd.changeThemeRewardedAd(
                      context, _rewardedAd, setTheme, Themes.orange);
                } else {
                  setTheme(Themes.orange);
                }
              },
            ),
            Radio(
              value: Themes.brown,
              groupValue: CustomThemes._themeValue,
              activeColor: const Color.fromARGB(255, 202, 168, 47),
              fillColor: MaterialStateColor.resolveWith(
                  (states) => const Color.fromARGB(255, 202, 168, 47)),
              onChanged: (value) {
                if (CustomRewardedAd.adCondition(_rewardedAd)) {
                  CustomRewardedAd.changeThemeRewardedAd(
                      context, _rewardedAd, setTheme, Themes.brown);
                } else {
                  setTheme(Themes.brown);
                }
              },
            ),
            Radio(
              value: Themes.grey,
              groupValue: CustomThemes._themeValue,
              activeColor: Colors.grey,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.grey),
              onChanged: (value) {
                if (CustomRewardedAd.adCondition(_rewardedAd)) {
                  CustomRewardedAd.changeThemeRewardedAd(
                      context, _rewardedAd, setTheme, Themes.grey);
                } else {
                  setTheme(Themes.grey);
                }
              },
            ),
            Radio(
              value: Themes.green,
              groupValue: CustomThemes._themeValue,
              activeColor: Colors.teal.shade400,
              fillColor: MaterialStateColor.resolveWith(
                  (states) => Colors.teal.shade400),
              onChanged: (value) {
                if (CustomRewardedAd.adCondition(_rewardedAd)) {
                  CustomRewardedAd.changeThemeRewardedAd(
                      context, _rewardedAd, setTheme, Themes.green);
                } else {
                  setTheme(Themes.green);
                }
              },
            ),
            Radio(
              value: Themes.blueDefault,
              groupValue: CustomThemes._themeValue,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.blue),
              activeColor: Colors.blue,
              onChanged: (value) {
                if (CustomRewardedAd.adCondition(_rewardedAd)) {
                  CustomRewardedAd.changeThemeRewardedAd(
                      context, _rewardedAd, setTheme, Themes.blueDefault);
                } else {
                  setTheme(Themes.blueDefault);
                }
              },
            ),
            Radio(
              value: Themes.purple,
              groupValue: CustomThemes._themeValue,
              fillColor:
                  MaterialStateColor.resolveWith((states) => Colors.deepPurple),
              activeColor: Colors.deepPurple,
              onChanged: (value) {
                if (CustomRewardedAd.adCondition(_rewardedAd)) {
                  CustomRewardedAd.changeThemeRewardedAd(
                      context, _rewardedAd, setTheme, Themes.purple);
                } else {
                  setTheme(Themes.purple);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
