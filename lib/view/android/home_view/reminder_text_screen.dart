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
    return ReminderWidget();
  }
}

// ignore: must_be_immutable
class ReminderWidget extends StatefulWidget {
  final _textController = TextEditingController();
  ReminderWidget({super.key});
  int maxLength = 100;
  int maxLines = 2;
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

  Future<void> _showSimpleDialog() async {
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.only(
                  top: SizeConfig.getMediaHeight(context) * 0.4),
              backgroundColor: Colors.transparent,
              content: _setupHistoryDialoadContainer(setState),
              actions: <Widget>[
                Center(
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back),
                  ),
                ),
              ],
            );
          },
        );
      },
    );
  }

  Widget _setupHistoryDialoadContainer(Function setStateCallback) {
    var items = PresenterTextReminder
        .reminderText!.getHistoryOfReminderTexts.reversed
        .toList();

    return Container(
      decoration: const BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight, // #380036 > #0CBABA
              colors: [
            Color.fromARGB(197, 39, 65, 130),
            Color.fromARGB(180, 15, 4, 11)
          ])),
      width: SizeConfig.getMediaWidth(context) * 0.6, // 70%
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: items.length,
        itemBuilder: (BuildContext context, int index) {
          return ListTile(
            title: Text(
              items[index],
              maxLines: 2,
              softWrap: true,
              style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                setStateCallback(() {
                  PresenterTextReminder.reminderText!.getHistoryOfReminderTexts
                      .remove(items[index]);
                  items.removeAt(index);
                });
                await PresenterTextReminder.reminderText!.saveToStorageAsync();
              },
            ),
            onTap: () async {
              await textSubmitted(items[index]);
              Navigator.of(context).pop();
              setStateCallback(() {});
            },
          );
        },
      ),
    );
  }

  Future<void> textSubmitted(value) async {
    setState(() {
      widget._textController.text = value;
      PresenterTextReminder.reminderText!.setReminderText(value);
    });
    await PresenterTextReminder.reminderText!.saveToStorageAsync();
    ReminderWidget.tmpValue = value;

    ReminderTextScreen.isEditing = false;

    FocusManager.instance.primaryFocus?.unfocus();
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
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                  onPressed: () {
                    setState(() {
                      ReminderTextScreen.isEditing =
                          !ReminderTextScreen.isEditing;
                    });
                  },
                  icon: Transform.scale(
                    scale: 0.7,
                    child: const Icon(Icons.edit),
                  )),
              AnimatedCrossFade(
                firstChild: IconButton(
                    onPressed: _showSimpleDialog,
                    icon: Transform.scale(
                      scale: 0.7,
                      child: const Icon(Icons.history),
                    )),
                secondChild: const SizedBox.shrink(),
                firstCurve: Curves.bounceInOut,
                secondCurve: Curves.easeInBack,
                crossFadeState: ReminderTextScreen.isEditing
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 100),
                reverseDuration: const Duration(milliseconds: 100),
              ),
            ],
          ),
          ReminderTextScreen.isEditing
              ? TextField(
                  controller: widget._textController,
                  maxLines: widget.maxLines,
                  maxLength: widget.maxLength,
                  keyboardType: TextInputType.text,
                  autofocus: true,
                  onSubmitted: textSubmitted,
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
