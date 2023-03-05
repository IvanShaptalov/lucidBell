import 'package:flutter/material.dart';

class ReminderText {
  /// =================================================[FIELDS, GETTERS and SETTERS]===========================================
  @protected
  String innerReminderText = 'Not forget it';

  @protected
  List innerHistoryOfReminderTexts = [];

  void setReminderText(PreloadedReminderTexts preloaded, {String? customText}) {
    // set custom text
    // set preloaded text
    innerReminderText = preloaded.getValue(customText: customText);

    // delete if exists, set to first position
    if (innerHistoryOfReminderTexts.contains(innerReminderText)) {
      innerHistoryOfReminderTexts.remove(innerReminderText);
    }
    innerHistoryOfReminderTexts.add(innerReminderText);
  }

  void clearHistory() {
    innerHistoryOfReminderTexts.clear();
  }

  get getReminderText => innerReminderText;

  get getHistoryOfReminderTexsts => innerHistoryOfReminderTexts;

  /// ================================================[CONSTRUCTORS]==========================================================

  ReminderText();
}

/// ============================================[PRELOADED REMINDERS TEXTS ENUM]============================================
enum PreloadedReminderTexts {
  realityCheckText,
  breathingText,
  meditationText,
  mueingText,
  customTextEnum;

  /// use [customText] parameter if you set custom enum
  String getValue({String? customText}) {
    String value;
    switch (this) {
      case PreloadedReminderTexts.realityCheckText:
        value = "time to check reality";

        break;
      case PreloadedReminderTexts.breathingText:
        value = "time to breathe";

        break;
      case PreloadedReminderTexts.meditationText:
        value = "time to meditation";

        break;
      case PreloadedReminderTexts.mueingText:
        value = "time to mueing";

        break;
      case PreloadedReminderTexts.customTextEnum:
        value = customText!;

        break;
      default:
        value = 'Not forget it';
    }
    return value;
  }
}
