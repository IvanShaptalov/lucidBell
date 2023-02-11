import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/main.dart';

// ignore: must_be_immutable
class TimeSelector extends StatefulWidget {
  TimeSelector({super.key, required this.bell, required this.callback});

  Function callback;
  Bell bell;

  @override
  State<TimeSelector> createState() => _TimeSelectorState();
}

class _TimeSelectorState extends State<TimeSelector> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Text('on start every hour'),
        Switch(
            value: widget.bell.startEveryHour,
            onChanged: ((value) {
              setState(() {
                widget.callback();
                widget.bell.switchStartEveryHour(value);
                InitServices.notificationService.clearNotifications();
              });
            })),
      ],
    );
  }
}
