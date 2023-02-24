import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/theme/view.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

class CashedButtons extends StatefulWidget {
  const CashedButtons({super.key});

  @override
  State<CashedButtons> createState() => _CashedButtonsState();
}

class _CashedButtonsState extends State<CashedButtons> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BellPresenter.callbacksTrigger.add(update);
  }

  void update() => setState(() {
        print('update buttons');
      });

  @override
  Widget build(BuildContext context) {
    print('buttons ***');

    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          CashedButton(
              interval:
                  BellPresenter.bell!.getThreeCashedIntervals.getByIndex(0)),
          CashedButton(
              interval:
                  BellPresenter.bell!.getThreeCashedIntervals.getByIndex(1)),
          CashedButton(
              interval:
                  BellPresenter.bell!.getThreeCashedIntervals.getByIndex(2))
        ],
      ),
    );
  }
}

class CashedButton extends StatefulWidget {
  Duration interval;
  CashedButton({super.key, required this.interval});

  @override
  State<CashedButton> createState() => _CashedButtonState();
}

class _CashedButtonState extends State<CashedButton> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: SizeConfig.getMediaWidth(context) * 0.2, //20%
      height: SizeConfig.getMediaHeight(context) * 0.05, //10%
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(45)),
        
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [Color.fromARGB(255, 56, 25, 76), Color.fromARGB(255, 75, 53, 147), ],
        ),
      ),
      child: TextButton(
          style: TextButton.styleFrom(
            foregroundColor: Colors.white,
             // Text Color
          ),
          
          onPressed: () async {
            setState(() {
              BellPresenter.bell!.setInterval(widget.interval);
              BellPresenter.updateCallbacks();
            });
          },
          child: Text(
            '${widget.interval.inMinutes} min',
            maxLines: 1,
            textAlign: TextAlign.center,
          )),
    );
  }
}
