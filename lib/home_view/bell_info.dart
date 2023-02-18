import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/main.dart';

class BellInfo extends StatefulWidget {
  const BellInfo({super.key});

  @override
  State<BellInfo> createState() => _BellInfoState();
}

class _BellInfoState extends State<BellInfo> {
  late Timer timer;
  Future<int>? toNextBellInSeconds;

  Future<int> lastToNextBell() async {
    if (InitServices.bell.notificationStack.isNotEmpty) {
      int seconds = InitServices.bell.notificationStack.first
          .difference(DateTime.now())
          .inSeconds;
      // if expired, update from stack
      if (seconds < 0) {
        var newBell = await Bell.loadLocalSettings();
        if (newBell != null) {
          InitServices.bell = newBell;
        }
        seconds = InitServices.bell.notificationStack.first
            .difference(DateTime.now())
            .inSeconds;
        if (seconds < 0) {
          return -1;
        }
        return seconds;
      }

      print(seconds);
      return seconds;
    } else {
      return 0;
    }
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // NOT UPDATE IF SLIDER  CHANGING OR BELL NOT RUN
      if (InitServices.isSliderChanging || !InitServices.bell.running) {
        print('paused');
      } else {
        print('i work');
        setState(() {
          // update bell info
          toNextBellInSeconds = lastToNextBell();
        });
      }
    });

    super.initState();
  }

  /// return false by default by default

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: Center(
        child: FutureBuilder<int>(
          future: toNextBellInSeconds,
          initialData: 0,
          builder: (
            BuildContext context,
            AsyncSnapshot<int> snapshot,
          ) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return const Text('Error');
              } else if (snapshot.hasData) {
                return Text(snapshot.data.toString(),
                    style: const TextStyle(
                        color: Color.fromARGB(255, 255, 255, 255),
                        fontSize: 36));
              } else {
                return const Text('Empty data');
              }
            } else {
              return const SizedBox.shrink();
            }
          },
        ),
      ),
    );
  }
}
