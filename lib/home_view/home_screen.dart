// ignore_for_file: must_be_immutable


import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/config.dart';
import 'package:flutter_lucid_bell/home_view/bell_info.dart';
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
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          gradient: InitServices.bell.running // active
              ? const LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight, // #380036 > #0CBABA
                  colors: [
                      Color.fromARGB(198, 68, 233, 131),
                      Color.fromARGB(180, 14, 14, 126)
                    ])
              : const LinearGradient(
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
                  height: SizeConfig.getMediaHeight(context) *0.35, // 35%
                  width: SizeConfig.getMediaWidth(context) * 0.75, // 75% width
                  child: Padding(

                    padding: EdgeInsets.only(top: SizeConfig.getMediaHeight(context)*0.1, ), //10%
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
                      opacity: InitServices.bell.running ? 0.65 : 0.4,
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
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: InitServices.bell.running ? 1 : 0,
                  duration: const Duration(milliseconds: 300),
                  // The green box must be a child of the AnimatedOpacity widget.
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
