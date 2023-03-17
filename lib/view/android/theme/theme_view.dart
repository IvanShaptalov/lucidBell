import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/ad_helper.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:flutter_lucid_bell/view/view.dart';
import 'package:google_fonts/google_fonts.dart';
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
  /// =====================================================[REWARDED AD]===================================
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

  Future<bool>? waitResult() async {
    for (var i = 0; i < AdHelper.loadTimeout.inSeconds; i++) {
      await Future.delayed(const Duration(seconds: 1));
      if (kDebugMode) {
        print("rewarded ad: $_rewardedAd");
      }
      if (_rewardedAd != null) {
        return true;
      }
    }
    if (kDebugMode) {
      print("timeout");
    }
    return false;
  }

  void showRewardedAd(
      context, String header, String description, Function targetFunction,
      {arg}) {
    showDialog(
        context: context,
        builder: (context) {
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
                      style: GoogleFonts.poppins(
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
                                  const Padding(
                                    padding: EdgeInsets.only(top: 16),
                                    child: Text('Watch ad'),
                                  ),
                                ]
                              : <Widget>[
                                  const Icon(
                                    Icons.error,
                                    color: Color.fromARGB(255, 225, 167, 95),
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
                              color: Color.fromARGB(255, 244, 158, 54),
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

  void changeThemeRewardedAd(
      context, Function targetFunction, Themes themeName) {
    showRewardedAd(
        context, 'Change theme', 'watch ad to change theme', targetFunction,
        arg: themeName);
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
                if (AdHelper.showAds) {
                  changeThemeRewardedAd(context, setTheme, Themes.orange);
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
                  changeThemeRewardedAd(context, setTheme, Themes.brown);
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
                  changeThemeRewardedAd(context, setTheme, Themes.grey);
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
                  changeThemeRewardedAd(context, setTheme, Themes.green);
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
                  changeThemeRewardedAd(context, setTheme, Themes.blueDefault);
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
                  changeThemeRewardedAd(context, setTheme, Themes.purple);
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
