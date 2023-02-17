// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
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

  int get lastToNextBell {
    if (InitServices.bell.notificationStack.isNotEmpty) {
      return DateTime.now()
          .difference(DateTime.now().add(InitServices.bell.interval))
          .inSeconds;
    }
    return 0;
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      print('i work');
      setState(() {
        toNextBellInSeconds = lastToNextBell;
      });
      

    });

    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [Text('to next bell in seconds: $toNextBellInSeconds'),
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
