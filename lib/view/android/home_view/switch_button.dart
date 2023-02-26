import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

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
          height: SizeConfig.getMediaHeight(context) * 0.3,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Transform.scale(
                scale: 1.2,
                child: Switch(
                  activeColor: Colors.greenAccent,

                    
                    // activeColor: Color.fromARGB(255, 51, 182, 142),
                    value: BellPresenter.bell!.getRunning(),
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
