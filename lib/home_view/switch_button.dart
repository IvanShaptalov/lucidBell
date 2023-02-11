import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
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
    return Row(
      children: [
        widget.bell.running ? const Text('running') : const Text('stopped'),
        Switch(
            value: widget.bell.running,
            onChanged: ((value) {
              setState(() {
                widget.callback();
                widget.bell.switchRun(value);
                InitServices.notificationStack.clear();
                InitServices.notificationService.cancelNotifications();
              });
            })),
      ],
    );
  }
}
