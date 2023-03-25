import 'package:flutter/material.dart' show BorderRadius, BoxDecoration, BuildContext, Center, Colors, Container, EdgeInsets, MainAxisAlignment, Radius, Row, State, StatefulWidget, Text, TextAlign, TextButton, Widget;
import 'package:flutter_lucid_bell/presenter/presenter.dart' show BellPresenter;
import 'package:flutter_lucid_bell/view/config_view.dart' show SizeConfig;
import 'package:flutter_lucid_bell/view/view.dart' show View;

class CashedButtons extends StatefulWidget {
  const CashedButtons({super.key});

  @override
  State<CashedButtons> createState() => _CashedButtonsState();
}

class _CashedButtonsState extends State<CashedButtons> {
  @override
  void initState() {
    super.initState();
    BellPresenter.callbacksTrigger.add(update);
  }

  void update() => setState(() {});

  @override
  Widget build(BuildContext context) {
    BellPresenter.addIfEmpty(update);

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

// ignore: must_be_immutable
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
      height: SizeConfig.getMediaHeight(context) * 0.065, //5%
      width: SizeConfig.getMediaWidth(context) * 0.22, //22%
      margin: EdgeInsets.symmetric(
          horizontal: SizeConfig.getMediaWidth(context) * 0.002), //%0.2
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(40)),
          gradient:
              View.currentTheme.threeCashedButtonTheme.cashedButtonGradient),
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
            View.humanLikeDuration(widget.interval, shortLabel: true),
            maxLines: 1,
            textAlign: TextAlign.center,
          )),
    );
  }
}
