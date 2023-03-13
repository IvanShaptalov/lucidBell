import 'package:flutter/material.dart';

class ReminderTextHistory extends StatelessWidget {
  const ReminderTextHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return SimpleDialog(
      // <-- SEE HERE
      title: const Text('Select Booking Type'),
      children: <Widget>[
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('General'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Silver'),
        ),
        SimpleDialogOption(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Gold'),
        ),
      ],
    );
  }
}
