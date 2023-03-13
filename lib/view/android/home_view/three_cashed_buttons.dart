import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';
import 'package:flutter_lucid_bell/view/view.dart';

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
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(15)),
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Color.fromARGB(255, 56, 25, 76),
            Color.fromARGB(255, 75, 53, 147),
          ],
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
            View.humanLikeDuration(widget.interval, shortLabel: true),
            maxLines: 1,
            textAlign: TextAlign.center,
          )),
    );
  }
}
