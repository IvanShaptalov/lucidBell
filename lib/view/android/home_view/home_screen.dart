// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/home_view/bell_info.dart';
import 'package:flutter_lucid_bell/view/android/home_view/reminder_text_screen.dart';
import 'package:flutter_lucid_bell/view/android/home_view/slider_interval_selector.dart';
import 'package:flutter_lucid_bell/view/android/home_view/switch_button.dart';
import 'package:flutter_lucid_bell/view/android/home_view/three_cashed_buttons.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

class HomeScreen extends StatefulWidget {
  Function updateCallback;
  HomeScreen(this.updateCallback, {super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
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
                  child: AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).

                      opacity: BellPresenter.isBellRunning() ? 1 : 0,
                      duration: const Duration(milliseconds: 300),
                      child: const Center(child: BellInfo())),
                )),

            // show TimeSelector if bell is running
            ReminderTextScreen(),

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
                  child: const CashedButtons(),
                ),
              ),
            ),
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
