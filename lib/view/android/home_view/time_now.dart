import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/view.dart';

class TimeNow extends StatefulWidget {
  const TimeNow({super.key});

  @override
  State<TimeNow> createState() => _TimeNowState();
}

class _TimeNowState extends State<TimeNow> {
  late Timer timer;
  int toNextBellInSeconds = 0;
  int lastLoadedData = 0;

  void update() {
    setState(() {});
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      // NOT UPDATE IF SLIDER  CHANGING OR BELL NOT RUN
      if (!BellPresenter.isBellRunning()) {
        setState(() {});
      } else {
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

  @override
  Widget build(BuildContext context) {
    return Text(
        maxLines: 1,
        View.formatTime(DateTime.now()),
        style: View.currentTheme.bellInfoTheme.textNowTimeStyle);
  }
}
