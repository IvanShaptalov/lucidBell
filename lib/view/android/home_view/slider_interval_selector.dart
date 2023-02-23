// ignore_for_file: must_be_immutable

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/theme/view.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';
import 'package:timezone/timezone.dart';

class SliderIntervalSelector extends StatefulWidget {
  const SliderIntervalSelector({super.key});

  @override
  State<SliderIntervalSelector> createState() => _SliderIntervalSelectorState();
}

class _SliderIntervalSelectorState extends State<SliderIntervalSelector> {
  double localValue = BellPresenter.bell!.getInterval().inMinutes.toDouble();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BellPresenter.callbacksTrigger.add(update);
  }

  void update() => setState(() {
        localValue = BellPresenter.bell!.getInterval().inMinutes.toDouble();
        print('update slider');
      });

  @override
  Widget build(BuildContext context) {
    print('slider ***');

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
            print('update!!!!!!!!!!!!!!!!!!!');
            BellPresenter.updateCallbacks();
          },
        ),
      ],
    );
  }
}
