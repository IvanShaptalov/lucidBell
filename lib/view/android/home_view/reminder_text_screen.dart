import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';
import 'package:google_fonts/google_fonts.dart';

// ignore: must_be_immutable
class ReminderTextScreen extends StatefulWidget {
  const ReminderTextScreen({super.key});
  static bool isEditing = false;

  @override
  State<ReminderTextScreen> createState() => _ReminderTextScreenState();
}

class _ReminderTextScreenState extends State<ReminderTextScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
        child: SizedBox(
      height: SizeConfig.getMediaHeight(context) * 0.2,
      width: SizeConfig.getMediaWidth(context) * 0.65, //65 %
      child: AnimatedCrossFade(
        firstChild: ReminderWidget(),
        secondChild: const SizedBox.shrink(),
        firstCurve: Curves.bounceInOut,
        secondCurve: Curves.easeInBack,
        crossFadeState: BellPresenter.isBellRunning()
            ? CrossFadeState.showFirst
            : CrossFadeState.showSecond,
        duration: const Duration(milliseconds: 300),
        reverseDuration: const Duration(milliseconds: 300),
      ),
    ));
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
                  ReminderTextScreen.isEditing = !ReminderTextScreen.isEditing;
                });
              },
              icon: Transform.scale(
                scale: 0.7,
                child: const Icon(Icons.edit),
              )),
          ReminderTextScreen.isEditing
              ? TextField(
                  controller: widget._textController,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  onSubmitted: (value) async {
                    setState(() {
                      widget._textController.text = value;
                      PresenterTextReminder.reminderText!
                          .setReminderText(value);
                    });
                    await PresenterTextReminder.reminderText!
                        .saveToStorageAsync();

                    ReminderTextScreen.isEditing = false;

                    FocusManager.instance.primaryFocus?.unfocus();
                  },
                  onChanged: (value) {
                    ReminderWidget.tmpValue = value;
                  },
                )
              : Text(
                  PresenterTextReminder.reminderText!.getReminderText,
                  maxLines: 4,
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }
}
