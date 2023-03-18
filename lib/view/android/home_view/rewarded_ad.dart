import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/ad_helper.dart';
import 'package:flutter_lucid_bell/view/android/home_view/reminder_text_screen.dart';
import 'package:flutter_lucid_bell/view/view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

// ignore: must_be_immutable
class RewardedAdDialog extends StatefulWidget {
  RewardedAdDialog(this.targetFunction, {super.key});
  RewardedAd? _rewardedAd;
  Function targetFunction;

  @override
  State<RewardedAdDialog> createState() => RewardedAdDialogState();
}

class RewardedAdDialogState extends State<RewardedAdDialog> {
  @override
  void initState() {
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
                widget._rewardedAd = null;
              });
              // _loadRewardedAd();
            },
          );

          setState(() {
            widget._rewardedAd = ad;
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
      if (kDebugMode) {
        print("rewarded ad: ${widget._rewardedAd}");
      }
      if (widget._rewardedAd != null) {
        print('return true');
        cancelWait = false;
        return true;
      }
      if (cancelWait) {
        print('cancel wait');
        cancelWait = false;
        return false;
      }
      await Future.delayed(const Duration(seconds: 1));
    }
    if (kDebugMode) {
      print("timeout");
    }
    cancelWait = false;
    return false;
  }

  bool cancelWait = false;

  void showRewardedAd(
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
                                          widget._rewardedAd?.show(
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
                      cancelWait = true;
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
            )
          ]);
        });
  }

  void showEditingRewardedAd(context, Function targetFunction) {
    showRewardedAd(
        context, 'Edit text', 'watch ad to edit reminder text', targetFunction);
  }

  IconButton rewardedAdWithIconButton(Function targetFunction) {
    return IconButton(
        onPressed: () {
          if (AdHelper.showAds && ReminderTextScreen.isEditing == false) {
            showEditingRewardedAd(context, targetFunction);
          } else {
            targetFunction();
          }
        },
        icon: Transform.scale(
          scale: 0.7,
          child: ReminderTextScreen.isEditing
              ? const Icon(Icons.arrow_back)
              : const Icon(Icons.edit),
        ));
  }

  @override
  Widget build(BuildContext context) {
    return rewardedAdWithIconButton(widget.targetFunction);
  }
}
