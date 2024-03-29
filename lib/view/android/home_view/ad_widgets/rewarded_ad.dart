import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/monetization.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';
import 'package:flutter_lucid_bell/view/view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// =========================================[BASE REWARD AD DIALOG]=======
mixin RewardedAdDialog {
  static RewardedAd? _rewardedAd;

  static void _loadRewardedAd() {
    RewardedAd.load(
      adUnitId: AdHelper.rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              _loadRewardedAd();
            },
          );

          _rewardedAd = ad;
        },
        onAdFailedToLoad: (err) {
          if (kDebugMode) {
            print('Failed to load a rewarded ad: ${err.message}');
          }
        },
      ),
    );
  }

  static Future<bool>? waitResult() async {
    for (var i = 0; i < AdHelper.loadTimeout.inSeconds; i++) {
      await Future.delayed(const Duration(seconds: 1));

      if (_rewardedAd != null) {
        return true;
      }

      // cancel waiting
    }
    return false;
  }

  static void showRewardedAd(
      context, String header, String description, Function targetFunction,
      {arg}) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          // start load ad
          _loadRewardedAd();
          // wait for result
          Future<bool>? waitBool = waitResult();

          return AlertDialog(backgroundColor: Colors.transparent, actions: [
            Container(
              decoration: BoxDecoration(
                  gradient: View
                      .currentTheme.reminderTextTheme.dialogBackgroundGradient),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text(
                      description,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.roboto(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  FutureBuilder<bool>(
                      future:
                          waitBool, // a previously-obtained Future<String> or null
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        List<Widget> children;
                        if (snapshot.hasData) {
                          children = snapshot.data == true
                              ? <Widget>[
                                  Transform.scale(
                                    scale: 2,
                                    child: IconButton(
                                      icon: Icon(Icons.play_arrow,
                                          color: View.currentTheme.appTheme
                                              .activeBottomNavigationBarColor),
                                      onPressed: () {
                                        {
                                          Navigator.pop(context);
                                          _rewardedAd?.show(
                                            onUserEarnedReward: (_, reward) {
                                              if (arg == null) {
                                                targetFunction();
                                              } else {
                                                targetFunction(arg);
                                              }
                                            },
                                          );
                                        }
                                      },
                                    ),
                                  ),
                                ]
                              : <Widget>[
                                  const Icon(
                                    Icons.error,
                                    color: Color.fromARGB(255, 225, 143, 95),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text('Ad not loaded'),
                                  ),
                                ];
                        } else if (snapshot.hasError) {
                          children = <Widget>[
                            const Icon(
                              Icons.error,
                              color: Color.fromARGB(255, 54, 244, 114),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Ad not loaded'),
                            ),
                          ];
                        } else {
                          children = <Widget>[
                            SizedBox(
                              child: CircularProgressIndicator(
                                backgroundColor: View.currentTheme.sliderTheme
                                    .inactiveSliderColor,
                                color: View
                                    .currentTheme.sliderTheme.activeSliderColor,
                              ),
                            ),
                            const Padding(
                              padding: EdgeInsets.only(top: 16),
                              child: Text('Ad loading ...'),
                            ),
                          ];
                        }

                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: children,
                          ),
                        );
                      }),
                  const Padding(padding: EdgeInsets.all(10)),
                  const Divider(),
                  Center(
                    child: TextButton(
                        onPressed: () async {
                          Navigator.pop(context);
                          await Subscription.showStore(context);
                        },
                        child: const Text(
                          'upgrade 👑',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        )),
                  ),
                  const Padding(padding: EdgeInsets.all(10)),
                  const Divider(),
                  IconButton(
                    icon: const Icon(Icons.arrow_downward),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          ]);
        });
  }
}

class RewardedAdDialogTextEdit with RewardedAdDialog {
  static void showEditingRewardedAd(context, Function targetFunction) {
    RewardedAdDialog.showRewardedAd(
        context, 'Edit text', 'upgrade Circle Bell\nor watch ad \nto edit reminder text ', targetFunction);
  }
}

class RewardedAdThemeDialog with RewardedAdDialog {
  static void changeThemeRewardedAd(
      context, Function targetFunction, Themes themeName) {
    RewardedAdDialog.showRewardedAd(
        context, 'Change theme', 'watch ad to change theme', targetFunction,
        arg: themeName);
  }
}
