import 'package:flutter/material.dart' show protected;

class ReminderText {
  /// =================================================[FIELDS, GETTERS and SETTERS]===========================================
  @protected
  String innerReminderText = 'Meditation 🧘';

  @protected
  List innerHistoryOfReminderTexts = [
    'Meditation 🧘',
    'Eat healty 🥦',
    'Mewing 😝',
    'Mindfulness 🌅',
    'Drink Water 💧',
    'Practice good posture 🤸‍♀️',
    'Deep breath 🌬',
    'Take break on work ☕️',
    'Train avoiding multitasking and focus on one task at a time 👀',
    'regular eye training  👓',
  ];

  static List defaultInnerHistoryOfReminderTexts = [
    'Meditation 🧘',
    'Eat healty 🥦',
    'Mewing 😝',
    'Mindfulness 🌅',
    'Drink Water 💧',
    'Practice good posture 🤸‍♀️',
    'Deep breath 🌬',
    'Take break on work ☕️',
    'Train avoiding multitasking and focus on one task at a time 👀',
    'regular eye training  👓',
  ];

  void loadDefaults() {
    var tmpList = List.from(innerHistoryOfReminderTexts)
      ..addAll(defaultInnerHistoryOfReminderTexts);
    innerHistoryOfReminderTexts = tmpList.toSet().toList();
  }

  void setReminderText(String customText) {
    // set custom text
    // set preloaded text
    innerReminderText = customText;

    // add defaults
    loadDefaults();

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
