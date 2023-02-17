import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/config.dart';
import 'package:flutter_lucid_bell/main.dart';

// ignore: must_be_immutable
class SwitchBell extends StatefulWidget {
  Bell bell;
  Function callback;

  SwitchBell({super.key, required this.bell, required this.callback});

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
              AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: widget.bell.running ? 1 : 0,
                  duration: Duration(milliseconds: 500),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: Text('running')),
              Switch(
                  value: widget.bell.running,
                  onChanged: ((value) {
                    setState(() {
                      widget.callback();
                      widget.bell.switchRun(value);
                      InitServices.bell.clearNotifications();
                    });
                  })),
            ],
          ),
        ),
      ],
    );
  }
}
