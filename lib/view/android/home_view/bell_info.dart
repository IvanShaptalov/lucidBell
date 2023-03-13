import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';
import 'package:flutter_lucid_bell/view/view.dart';

class BellInfo extends StatefulWidget {
  const BellInfo({super.key});

  @override
  State<BellInfo> createState() => _BellInfoState();
}

class _BellInfoState extends State<BellInfo> {
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

  Widget bellCondition(int seconds) {
    if (seconds <= 0) {
      return SizedBox(
          height: SizeConfig.getMediaHeight(context) * 0.1, //10% height

          child: const Icon(Icons.alarm));
    } else {
      String dateStringFormat = View.formatLeftSeconds(seconds);
      return SizedBox(
        height: SizeConfig.getMediaHeight(context) * 0.1, //10% height

        child: Text(dateStringFormat,
            style: View.currentTheme.bellInfoTheme.textLeftSecondStyle),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return bellCondition(toNextBellInSeconds);
  }
}
