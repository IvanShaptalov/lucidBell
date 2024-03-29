// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/view.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class SliderIntervalSelector extends StatefulWidget {
  const SliderIntervalSelector({super.key});

  @override
  State<SliderIntervalSelector> createState() => _SliderIntervalSelectorState();
}

class _SliderIntervalSelectorState extends State<SliderIntervalSelector> {
  double localValue = BellPresenter.bell!.getInterval().inMinutes.toDouble();

  @override
  void initState() {
    super.initState();
    BellPresenter.callbacksTrigger.add(update);
  }

  void update() => setState(() {
        localValue = BellPresenter.bell!.getInterval().inMinutes.toDouble();
      });

  @override
  Widget build(BuildContext context) {
    BellPresenter.addIfEmpty(update);
    return Column(
      children: [
        Text(
          View.humanLikeDuration(
            Duration(minutes: localValue.toInt()),
          ),
          style: GoogleFonts.roboto(
              color: const Color.fromARGB(255, 225, 223, 223),
              fontSize: 18,
              fontWeight: FontWeight.bold),
        ),
        SfSlider(
          min: BellPresenter.bell!.intervalLowerBound,
          max: BellPresenter.bell!.intervalUpperBound,
          interval: 15,
          stepSize: 5,
          activeColor: View.currentTheme.sliderTheme.activeSliderColor,
          inactiveColor: View.currentTheme.sliderTheme.inactiveSliderColor,
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
            BellPresenter.updateCallbacks();
          },
        ),
      ],
    );
  }
}
