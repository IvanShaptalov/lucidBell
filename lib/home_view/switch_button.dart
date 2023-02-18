import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/config.dart';
import 'package:flutter_lucid_bell/main.dart';

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
              AnimatedOpacity(
                  // If the widget is visible, animate to 0.0 (invisible).
                  // If the widget is hidden, animate to 1.0 (fully visible).
                  opacity: InitServices.bell.running ? 1 : 0,
                  duration: const Duration(milliseconds: 500),
                  // The green box must be a child of the AnimatedOpacity widget.
                  child: const Text('running')),
              Switch(
                  value: InitServices.bell.running,
                  onChanged: ((value) {
                    setState(() {
                      widget.callback();
                      InitServices.bell.switchRun(value);
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
