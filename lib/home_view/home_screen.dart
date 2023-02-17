// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/config.dart';
import 'package:flutter_lucid_bell/home_view/slider_interval_selector.dart';
import 'package:flutter_lucid_bell/home_view/switch_button.dart';
import 'package:flutter_lucid_bell/main.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key, required this.title});

  final String title;

  var homeScreenState = _HomeScreenState();

  @override
  // ignore: no_logic_in_create_state
  State<HomeScreen> createState() => homeScreenState;
}

class _HomeScreenState extends State<HomeScreen> {
  late Timer timer;
  int toNextBellInSeconds = 0;

  int lastToNextBell() {
    if (InitServices.bell.notificationStack.isEmpty ||
        toNextBellInSeconds <= 0) {
      Future.sync(() async {
        print('updated');
        var jsonBell = await LocalPathProvider.getBellJsonAsync();
        if (jsonBell != null) {
          InitServices.bell = Bell.fromJson(jsonBell);
          return true;
        }
        return false;
      });
    }
    if (InitServices.bell.notificationStack.isNotEmpty) {
      int seconds = InitServices.bell.notificationStack.first
          .difference(DateTime.now())
          .inSeconds;
      print(seconds);
      if (seconds < 0) {
        return 0;
      }
      return seconds;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isSliderChange()) {
        print('paused');
      } else {
        print('i work');
        setState(() {
          toNextBellInSeconds = lastToNextBell();
        });
      }
    });

    super.initState();
  }

  /// return false by default by default
  bool isSliderChange({bool now = false}) {
    return now;
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  Widget selectCountDownWidget() {
    if (InitServices.bell.running) {
      if (toNextBellInSeconds == 0) {
        return const Text('loading bell ...');
      } else {
        return Text('to next $toNextBellInSeconds');
      }
    } else {
      return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight, // #380036 > #0CBABA
              colors: [
            Color.fromARGB(203, 71, 167, 167),
            Color.fromARGB(54, 11, 85, 38)
          ])),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(
                  height: SizeConfig.getMediaHeight(context) / 3, // 30%
                  width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
                  child: Center(
                    child: AnimatedOpacity(
                      // If the widget is visible, animate to 0.0 (invisible).
                      // If the widget is hidden, animate to 1.0 (fully visible).
                      opacity: InitServices.bell.running ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      // The green box must be a child of the AnimatedOpacity widget.
                      child: selectCountDownWidget(),
                    ),
                  )),

              // show TimeSelector if bell is running

              SizedBox(
                height: SizeConfig.getMediaHeight(context) / 3, // 30%
                width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SwitchBell(bell: InitServices.bell, callback: callback),
                  ],
                ),
              ),
              SizedBox(
                height: SizeConfig.getMediaHeight(context) / 3, // 30%
                width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
                child: AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: InitServices.bell.running ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: SliderIntervalSelector(
                      bell: InitServices.bell,
                      callBackIsChanged: isSliderChange),
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
