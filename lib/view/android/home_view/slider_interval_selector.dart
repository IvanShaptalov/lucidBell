// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderIntervalSelector extends StatefulWidget {
  const SliderIntervalSelector({super.key});

  @override
  State<SliderIntervalSelector> createState() => _SliderIntervalSelectorState();
}

class _SliderIntervalSelectorState extends State<SliderIntervalSelector> {
  double localValue = BellPresenter.bell!.getInterval().inMinutes.toDouble();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(BellPresenter.bell!
            .humanLikeDuration(Duration(minutes: localValue.toInt()))),
        SfSlider(
          min: BellPresenter.bell!.intervalLowerBound,
          max: BellPresenter.bell!.intervalUpperBound,
          interval: 15,
          stepSize: 5,
          value: localValue,
          onChanged: (value) async {
            setState(() {
              // update notifications
            });
            localValue = value;
          },
          onChangeStart: (value) {
// need to be empty
          },
          onChangeEnd: (value) {
            BellPresenter.bell!.setInterval(Duration(minutes: value.toInt()));
          },
        ),
      ],
    );
  }
}
