// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
                onPressed: () async {
                  await InitServices.notificationService.playSound(
                      'test',
                      'test',
                      DateTime.now().millisecondsSinceEpoch + 1000,
                      'testing');
                },
                icon: Icon(Icons.ac_unit)),
            // show TimeSelector if bell is running

            SwitchBell(bell: InitServices.bell, callback: callback),
            SliderIntervalSelector(bell: InitServices.bell),
          ],
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
