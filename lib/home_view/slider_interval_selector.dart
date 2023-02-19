// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderIntervalSelector extends StatefulWidget {
  const SliderIntervalSelector({super.key});

  @override
  State<SliderIntervalSelector> createState() => _SliderIntervalSelectorState();
}

class _SliderIntervalSelectorState extends State<SliderIntervalSelector> {
  double localValue = InitServices.bell.getInterval.inMinutes.toDouble();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(InitServices.bell
            .convertFromMinutesToH(Duration(minutes: localValue.toInt()))),
        SfSlider(
          min: InitServices.bell.intervalLowerBound,
          max: InitServices.bell.intervalUpperBound,
          interval: 15,
          stepSize: 5,
          value: localValue,
          onChanged: (value) async {
            setState(() {});
            localValue = value;
          },
          onChangeStart: (value) {
            print('start change');
            InitServices.isSliderChanging = true;
          },
          onChangeEnd: (value) async {
            InitServices.bell.setInterval = Duration(minutes: value.round());
            await InitServices.bell.clearNotifications();

            Future.delayed(const Duration(milliseconds: 300))
                .then((value) => InitServices.isSliderChanging = false);
            print('end change');
            assert(InitServices
                .bell.notificationStack.isEmpty); // need to be empty
            // widget.callBackIsChanged(false);
          },
        ),
      ],
    );
  }
}
