// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderIntervalSelector extends StatefulWidget {

  SliderIntervalSelector({super.key});

  @override
  State<SliderIntervalSelector> createState() => _SliderIntervalSelectorState();
}

class _SliderIntervalSelectorState extends State<SliderIntervalSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(InitServices.bell.convertFromMinutesToH(InitServices.bell.getInterval)),
        SfSlider(
          min: InitServices.bell.intervalLowerBound,
          max: InitServices.bell.intervalUpperBound,
          interval: 15,
          stepSize: 5,
          value: InitServices.bell.getInterval.inMinutes.toDouble(),
          onChanged: (value) {
            setState(() {
              // update notifications
            });
            InitServices.bell.setInterval = Duration(minutes: value.round());
            InitServices.bell.clearNotifications();
            assert(InitServices.bell.notificationStack.isEmpty);// need to be empty
          },
          onChangeStart: (value) async {
            InitServices.isSliderChanging = true;
            // widget.callBackIsChanged(true);
          },
          onChangeEnd: (value) async {
            await Future.delayed(const Duration(milliseconds: 300));
            
            InitServices.isSliderChanging = false;
            assert(InitServices.bell.notificationStack.isEmpty);// need to be empty
            // widget.callBackIsChanged(false);
          },
        ),
      ],
    );
  }
}
