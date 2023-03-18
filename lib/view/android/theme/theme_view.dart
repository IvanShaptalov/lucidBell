import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/ad_helper.dart';
import 'package:flutter_lucid_bell/view/android/home_view/ad_widgets.dart/rewarder_ad_theme.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:flutter_lucid_bell/view/view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: must_be_immutable
class CustomThemes extends StatefulWidget {
  Function updateCallback;
  static Themes _themeValue = View.currentTheme.themeEnum;
  // bool cancelWait = false;

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
  @override
  void initState() {
    super.initState();
  }

  /// =============================================[REWARDED THEME DIALOG]====================================

  /// =============================================[REWARDED THEME DIALOG]====================================

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
                if (AdHelper.showAds) {
                  RewardedAdThemeDialog.changeThemeRewardedAd(
                      context, setTheme, Themes.orange);
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
                if (AdHelper.showAds) {
                  RewardedAdThemeDialog.changeThemeRewardedAd(
                      context, setTheme, Themes.brown);
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
                if (AdHelper.showAds) {
                  RewardedAdThemeDialog.changeThemeRewardedAd(
                      context, setTheme, Themes.grey);
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
                if (AdHelper.showAds) {
                  RewardedAdThemeDialog.changeThemeRewardedAd(
                      context, setTheme, Themes.green);
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
                if (AdHelper.showAds) {
                  RewardedAdThemeDialog.changeThemeRewardedAd(
                      context, setTheme, Themes.blueDefault);
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
                if (AdHelper.showAds) {
                  RewardedAdThemeDialog.changeThemeRewardedAd(
                      context, setTheme, Themes.purple);
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
