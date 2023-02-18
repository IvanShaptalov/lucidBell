// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderIntervalSelector extends StatefulWidget {
  Bell bell;

  SliderIntervalSelector({super.key, required this.bell});

  @override
  State<SliderIntervalSelector> createState() => _SliderIntervalSelectorState();
}

class _SliderIntervalSelectorState extends State<SliderIntervalSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(widget.bell.convertFromMinutesToH(widget.bell.interval)),
        SfSlider(
          min: widget.bell.intervalLowerBound,
          max: widget.bell.intervalUpperBound,
          interval: 15,
          stepSize: 5,
          value: widget.bell.interval.inMinutes.toDouble(),
          onChanged: (value) {
            setState(() {
              // update notifications
            });
            widget.bell.interval = Duration(minutes: value.round());

            InitServices.bell.clearNotifications();
          },
          onChangeStart: (value) {
            InitServices.isSliderChanging = true;
            // widget.callBackIsChanged(true);
          },
          onChangeEnd: (value) async {
            InitServices.isSliderChanging = false;

            // widget.callBackIsChanged(false);
          },
        ),
      ],
    );
  }
}
