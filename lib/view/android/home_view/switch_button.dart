import 'package:flutter/material.dart' show BuildContext, Column, MainAxisAlignment, SizedBox, State, StatefulWidget, Switch, Transform, Widget;
import 'package:flutter_lucid_bell/presenter/presenter.dart' show BellPresenter;
import 'package:flutter_lucid_bell/view/view.dart' show View;

// ignore: must_be_immutable
class SwitchBell extends StatefulWidget {
  Function callback;

  SwitchBell({super.key, required this.callback});

  @override
  State<SwitchBell> createState() => _SwitchBellState();
}

class _SwitchBellState extends State<SwitchBell> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Transform.scale(
                scale: View.currentTheme.switchButtonTheme.switchScale,
                child: Switch(
                  activeColor: View.currentTheme.switchButtonTheme.switchColor,

                    value: BellPresenter.isBellRunning(),
                    onChanged: ((value) {
                      setState(() {
                        widget.callback();
                        BellPresenter.bell!.setRunning(value);
                      });
                    })),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
