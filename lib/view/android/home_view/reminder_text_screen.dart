import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

// ignore: must_be_immutable
class ReminderTextScreen extends StatefulWidget {
  const ReminderTextScreen({super.key});
  static bool isCustomState = false;

  @override
  State<ReminderTextScreen> createState() => _ReminderTextScreenState();
}

class _ReminderTextScreenState extends State<ReminderTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
            width: SizeConfig.getMediaWidth(context) * 0.9, //90 %
            child: AnimatedCrossFade(
                firstChild: ReminderWidget(),
                secondChild: const SizedBox.shrink(),
                crossFadeState: BellPresenter.isBellRunning()
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                duration: const Duration(milliseconds: 750))));
  }
}

// ignore: must_be_immutable
class ReminderWidget extends StatefulWidget {
  final _textController = TextEditingController();
  ReminderWidget({super.key});
  int maxLength = 100;
  int maxLines = 3;
  static String tmpValue = PresenterTextReminder.reminderText!.getReminderText;

  @override
  State<ReminderWidget> createState() => _ReminderWidgetState();
}

class _ReminderWidgetState extends State<ReminderWidget> {
  @override
  void initState() {
    super.initState();
    widget._textController.text = ReminderWidget.tmpValue;
  }

  @override
  Widget build(BuildContext context) {
    widget._textController.text = ReminderWidget.tmpValue;
    widget._textController.selection = TextSelection.fromPosition(
        TextPosition(offset: ReminderWidget.tmpValue.length));

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          IconButton(
              onPressed: () {
                setState(() {
                  ReminderTextScreen.isCustomState =
                      !ReminderTextScreen.isCustomState;
                });
              },
              icon: const Icon(Icons.flip)),
          ReminderTextScreen.isCustomState
              ? TextField(
                  controller: widget._textController,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  keyboardType: TextInputType.text,
                  onSubmitted: (value) {
                    setState(() {
                      widget._textController.text = value;
                      PresenterTextReminder.reminderText!
                          .setReminderText(value);
                    });
                    PresenterTextReminder.reminderText!.saveToStorageAsync();
                  },
                  onChanged: (value) {
                    ReminderWidget.tmpValue = value;
                  },
                )
              : Text(PresenterTextReminder.reminderText!.getReminderText),
        ],
      ),
    );
  }
}
