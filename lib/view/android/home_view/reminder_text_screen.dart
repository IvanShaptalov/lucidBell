import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/bell/reminder_text.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

// ignore: must_be_immutable
class ReminderTextScreen extends StatefulWidget {
  ReminderTextScreen({super.key});
  final _textController = TextEditingController();
  int maxLength = 100;
  int maxLines = 3;
  static String tmpValue = TextReminderPresenter.reminderText!.getReminderText;
  // static String tmpText = TextReminderPresenter.reminderText!.getReminderText;
  @override
  State<ReminderTextScreen> createState() => _ReminderTextScreenState();
}

class _ReminderTextScreenState extends State<ReminderTextScreen> {
  @override
  void initState() {
    super.initState();
    widget._textController.text = ReminderTextScreen.tmpValue;
  }

  @override
  Widget build(BuildContext context) {
    widget._textController.text = ReminderTextScreen.tmpValue;
    widget._textController.selection = TextSelection.fromPosition(
        TextPosition(offset: ReminderTextScreen.tmpValue.length));
    return Center(
      child: SizedBox(
        width: SizeConfig.getMediaWidth(context) * 0.65, //65 %
        child: TextField(
          controller: widget._textController,
          maxLines: widget.maxLines,
          maxLength: widget.maxLength,
          keyboardType: TextInputType.text,
          onSubmitted: (value) {
            setState(() {
              widget._textController.text = value;
              TextReminderPresenter.reminderText!.setReminderText(
                  PreloadedReminderTexts.customTextEnum,
                  customText: value);
            });
            TextReminderPresenter.reminderText!.saveToStorageAsync();
          },
          onChanged: (value) {
            ReminderTextScreen.tmpValue = value;
          },
        ),
      ),
    );
  }
}
