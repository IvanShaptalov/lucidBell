// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/home_view/bell_info.dart';
import 'package:flutter_lucid_bell/view/android/home_view/slider_interval_selector.dart';
import 'package:flutter_lucid_bell/view/android/home_view/switch_button.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.title});

  final String title;

  var homeScreenState = _HomeScreenState();

  @override
  // ignore: no_logic_in_create_state
  State<HomeScreen> createState() => homeScreenState;
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: BellPresenter.bell!.getRunning() // active
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight, // #380036 > #0CBABA
                  colors: [
                      Color.fromARGB(197, 66, 119, 253),
                      Color.fromARGB(180, 15, 4, 11)
                    ])
              : const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight, // #380036 > #0CBABA
                  colors: [
                      Color.fromARGB(199, 88, 37, 147),
                      Color.fromARGB(91, 21, 14, 25)
                    ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: SizeConfig.getMediaHeight(context) * 0.35, // 35%
                  width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
                  child: Padding(
                    padding: EdgeInsets.only(
                      top: SizeConfig.getMediaHeight(context) * 0.1,
                    ), //10%
                    child: const Center(child: BellInfo()),
                  )),

              // show TimeSelector if bell is running

              SizedBox(
                height: SizeConfig.getMediaHeight(context) * 0.30, // 30%
                width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: BellPresenter.bell!.getRunning() ? 0.65 : 0.4,
                      duration: const Duration(milliseconds: 600),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: SwitchBell(callback: callback),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.getMediaHeight(context) * 0.2, // 30%
                width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
                child: AnimatedOpacity(
                  opacity: BellPresenter.bell!.getRunning() ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  child: const SliderIntervalSelector(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void callback() {
    setState(() {
      print('updated');
    });
  }
}
