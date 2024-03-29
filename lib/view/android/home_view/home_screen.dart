// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/monetization.dart';

import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/home_view/ad_widgets/banner_ad.dart';
import 'package:flutter_lucid_bell/view/android/home_view/bell_info.dart';
import 'package:flutter_lucid_bell/view/android/home_view/reminder_text_screen.dart';
import 'package:flutter_lucid_bell/view/android/home_view/review_dialog.dart';
import 'package:flutter_lucid_bell/view/android/home_view/slider_interval_selector.dart';
import 'package:flutter_lucid_bell/view/android/home_view/switch_button.dart';
import 'package:flutter_lucid_bell/view/android/home_view/three_cashed_buttons.dart';
import 'package:flutter_lucid_bell/view/android/home_view/time_now.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';
import 'package:flutter_lucid_bell/view/view.dart';

class HomeScreen extends StatefulWidget {
  Function updateCallback;
  HomeScreen(this.updateCallback, {super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    Subscription.premiumActivatedAsync();
    CustomBannerAd.loadBannerAd(callback);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ReviewDialog.showReviewDialog(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: View.currentTheme.homeScreenTheme.backgroundColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
                child: Padding(
                  padding: EdgeInsets.only(
                    top: SizeConfig.getMediaHeight(context) * 0.1,
                  ), //10%
                  child: Center(
                    child: Column(
                      children: [
                        const TimeNow(),
                        AnimatedOpacity(
                          // If the widget is visible, animate to 0.0 (invisible).
                          // If the widget is hidden, animate to 1.0 (fully visible).

                          opacity: BellPresenter.isBellRunning() ? 1 : 0,
                          duration: const Duration(milliseconds: 300),

                          /// ================================================================[BELL INFO]
                          child: const BellInfo(),
                        ),
                      ],
                    ),
                  ),
                )),

            // show TimeSelector if bell is running
            Center(
                child: SizedBox(
              height: SizeConfig.getMediaHeight(context) * 0.2,
              width: SizeConfig.getMediaWidth(context) * 0.65, //65 %
              child: AnimatedCrossFade(
                /// ============================================================================[REMINDER TEXT SCREEN]
                firstChild: const ReminderTextScreen(),
                secondChild: const SizedBox.shrink(),
                firstCurve: Curves.bounceInOut,
                secondCurve: Curves.easeInBack,
                crossFadeState: BellPresenter.isBellRunning()
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 300),
                reverseDuration: const Duration(milliseconds: 300),
              ),
            )),

            SizedBox(
              width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedOpacity(
                    // If the widget is visible, animate to 0.0 (invisible).
                    // If the widget is hidden, animate to 1.0 (fully visible).
                    opacity: BellPresenter.isBellRunning() ? 0.65 : 0.4,
                    duration: const Duration(milliseconds: 600),
                    // The green box must be a child of the AnimatedOpacity widget.
                    /// ================================================================================[SWITCH BELL]
                    child: SwitchBell(callback: callback),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
              child: AnimatedOpacity(
                opacity: BellPresenter.isBellRunning() ? 1 : 0,
                duration: const Duration(milliseconds: 300),

                /// ====================================================================================[SLIDER]
                child: const SliderIntervalSelector(),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                  bottom: SizeConfig.getMediaHeight(context) *
                      0.05), // 5% from bottom
              child: SizedBox(
                width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
                child: AnimatedOpacity(
                  opacity: BellPresenter.isBellRunning() ? 1 : 0,
                  duration: const Duration(milliseconds: 300),

                  /// =======================================================================================[CASHED BUTTONS]
                  child: const CashedButtons(),
                ),
              ),
            ),
            CustomBannerAd.showBanner(context),
          ],
        ),
      ),
    );
  }

  void callback() {
    setState(() {});
    widget.updateCallback();
  }
}
