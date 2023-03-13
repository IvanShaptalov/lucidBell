import 'package:flutter/material.dart';

class ReminderText {
  /// =================================================[FIELDS, GETTERS and SETTERS]===========================================
  @protected
  String innerReminderText = 'Not forget it';

  @protected
  List innerHistoryOfReminderTexts = [];

  void setReminderText(String customText) {
    // set custom text
    // set preloaded text
    innerReminderText = customText;

    // delete if exists, set to first position
    if (innerHistoryOfReminderTexts.contains(innerReminderText)) {
      innerHistoryOfReminderTexts.remove(innerReminderText);
    }
    innerHistoryOfReminderTexts.add(innerReminderText);
  }

  void clearHistory() {
    innerHistoryOfReminderTexts.clear();
  }

  String get getReminderText => innerReminderText;

  List get getHistoryOfReminderTexts => innerHistoryOfReminderTexts;

  /// ================================================[CONSTRUCTORS]==========================================================

  ReminderText();
}

