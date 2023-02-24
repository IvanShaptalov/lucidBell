import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:intl/intl.dart';

class BellInfo extends StatefulWidget {
  const BellInfo({super.key});

  @override
  State<BellInfo> createState() => _BellInfoState();
}

class _BellInfoState extends State<BellInfo> {
  late Timer timer;
  int toNextBellInSeconds = 0;
  int lastLoadedData = 0;

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // NOT UPDATE IF SLIDER  CHANGING OR BELL NOT RUN
      if (!BellPresenter.bell!.getRunning()) {
        print('paused');
        setState(() {});
      } else {
        print('i work');
        setState(() {
          toNextBellInSeconds =
              BellPresenter.bell!.getSecondsToNextNotification();

          // update bell info
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

  Widget bellCondition(int seconds) {
    if (seconds <= 0) {
      return const Icon(Icons.alarm);
    } else {
      return Text(seconds.toString(),
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 36));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Text(DateFormat('h:mm:ss a').format(DateTime.now()),
          style: const TextStyle(
              color: Color.fromARGB(255, 255, 255, 255), fontSize: 42),
              maxLines: 1,),
      AnimatedOpacity(
          // If the widget is visible, animate to 0.0 (invisible).
          // If the widget is hidden, animate to 1.0 (fully visible).

          opacity: BellPresenter.bell!.getRunning() ? 1 : 0,
          duration: const Duration(milliseconds: 500),
          child: bellCondition(toNextBellInSeconds))
    ]);
  }
}
