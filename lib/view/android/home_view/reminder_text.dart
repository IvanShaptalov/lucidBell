import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

// ignore: must_be_immutable
class ReminderTextScreen extends StatefulWidget {
  ReminderTextScreen({super.key});
  final _textController = TextEditingController();
  int maxLines = 3;
  String text = "remider";
  @override
  State<ReminderTextScreen> createState() => _ReminderTextScreenState();
}

class _ReminderTextScreenState extends State<ReminderTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: SizeConfig.getMediaWidth(context) * 0.65, //65 %
        child: TextField(
          controller: widget._textController,
          maxLines: widget.maxLines,
          keyboardType: TextInputType.text,
          onTap: () {},
          onEditingComplete: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onSubmitted: (value) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onTapOutside: (event) {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          onChanged: (text) {
            setState(() {});
          },
        ),
      ),
    );
  }
}
