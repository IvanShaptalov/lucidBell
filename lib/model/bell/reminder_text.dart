class ReminderText {
  /// =================================================[FIELDS, GETTERS and SETTERS]===========================================
  String _reminderText = 'Not forget it';

  void setReminderText(PreloadedReminderTexts preloaded, {String? customText}) {
    // set custom text
    // set preloaded text
    _reminderText = preloaded.getValue(customText: customText);

    // delete if exists, set to first position
    if (_historyOfReminderTexts.contains(_reminderText)) {
      _historyOfReminderTexts.remove(_reminderText);
    }
    _historyOfReminderTexts.add(_reminderText);
  }

  void clearHistory(){
    _historyOfReminderTexts.clear();
  }

  get getReminderText => _reminderText;

  final List<String> _historyOfReminderTexts = [];

  get getHistoryOfReminderTexsts => _historyOfReminderTexts;

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
