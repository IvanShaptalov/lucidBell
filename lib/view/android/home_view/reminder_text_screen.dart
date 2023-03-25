import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' show AlertDialog, AnimatedCrossFade, BoxDecoration, BuildContext, Center, Colors, Column, Container, CrossFadeState, Curves, EdgeInsets, FocusManager, FontWeight, Icon, IconButton, Icons, ListTile, ListView, MainAxisAlignment, Navigator, Row, SizedBox, State, StatefulBuilder, StatefulWidget, Text, TextAlign, TextEditingController, TextField, TextInputType, TextPosition, TextSelection, Transform, Widget, showDialog;
import 'package:flutter_lucid_bell/model/bell/reminder_text.dart' show ReminderText;
import 'package:flutter_lucid_bell/presenter/android/monetization/monetization.dart' show AdHelper;
import 'package:flutter_lucid_bell/presenter/presenter.dart' show PresenterTextReminder;
import 'package:flutter_lucid_bell/view/android/home_view/ad_widgets/rewarded_ad.dart' show RewardedAdDialogTextEdit;
import 'package:flutter_lucid_bell/view/config_view.dart' show SizeConfig;
import 'package:flutter_lucid_bell/view/view.dart' show View;
import 'package:google_fonts/google_fonts.dart' show GoogleFonts;

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

  /// ================================================[HISTORY DIALOG]================================

  Future<void> _showSimpleHistoryDialog() async {
    
    await showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              insetPadding: EdgeInsets.only(
                  top: SizeConfig.getMediaHeight(context) * 0.4),
              backgroundColor:
                  View.currentTheme.reminderTextTheme.transparentDialog,
              content: _setupHistoryDialoadContainer(setState),
              actions: <Widget>[
                Center(
                  child: IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_downward),
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
      decoration: BoxDecoration(
          gradient:
              View.currentTheme.reminderTextTheme.dialogBackgroundGradient),
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
              style: GoogleFonts.roboto(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            leading: SizedBox(
              width: SizeConfig.getMediaWidth(context) * 0.1,
              child: ReminderText.defaultInnerHistoryOfReminderTexts
                      .contains(items[index])
                  ? const Icon(Icons.all_inclusive_sharp)
                  : IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () async {
                        setStateCallback(() {
                          PresenterTextReminder
                              .reminderText!.getHistoryOfReminderTexts
                              .remove(items[index]);
                          items.removeAt(index);
                        });
                        await PresenterTextReminder.reminderText!
                            .saveToStorageAsync();
                      },
                    ),
            ),
            onTap: () {
              // todo Changed
              textSubmitted(items[index]);
              Navigator.of(context).pop();
              setStateCallback(() {});
            },
          );
        },
      ),
    );
  }

  /// =================================================[END HISTORY DIALOG]===========================

  Future<void> textSubmitted(value) async {
    setState(() {
      widget._textController.text = value;
      PresenterTextReminder.reminderText!.setReminderText(value);
    });
    await PresenterTextReminder.reminderText!.saveToStorageAsync();
    ReminderWidget.tmpValue = value;

    FocusManager.instance.primaryFocus?.unfocus();
  }

  void updateEditing() {
    if (kDebugMode) {
      print('======================UPDATE EDITING');
    }

    /// update text when click back button or pan
    textSubmitted(ReminderWidget.tmpValue);
    setState(() {
      ReminderTextScreen.isEditing = !ReminderTextScreen.isEditing;
    });
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
              /// ===========================================[REWARDED AD]==============================
              IconButton(
                  onPressed: () {
                    if (AdHelper.showAds &&
                        ReminderTextScreen.isEditing == false) {
                      RewardedAdDialogTextEdit.showEditingRewardedAd(
                          context, updateEditing);
                    } else {
                      updateEditing();
                    }
                  },
                  icon: Transform.scale(
                    scale: 0.7,
                    child: ReminderTextScreen.isEditing
                        ? const Icon(Icons.save)
                        : const Icon(Icons.edit),
                  )),
              AnimatedCrossFade(
                firstChild: IconButton(
                    onPressed: _showSimpleHistoryDialog,
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
                  autofocus: false,
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
                  style: GoogleFonts.roboto(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
        ],
      ),
    );
  }
}
