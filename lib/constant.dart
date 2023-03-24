enum ReminderSoundEnum { defaultReminder, uwu, drip, kpk }

class CustomReminderSound {
  String? rawPath;
  String channel;
  bool playSound;
  ReminderSoundEnum enumName;

  CustomReminderSound(this.rawPath, this.channel, this.enumName,
      {this.playSound = false});

  static CustomReminderSound defaultReminder() {
    return CustomReminderSound(
        null, 'default reminder', ReminderSoundEnum.defaultReminder,
        playSound: false);
  }

  static CustomReminderSound uwu() {
    return CustomReminderSound(
        'uwu_reminder', 'uwu reminder', ReminderSoundEnum.uwu,
        playSound: true);
  }

  static CustomReminderSound drip() {
    return CustomReminderSound(
        'drip_reminder', 'drip reminder', ReminderSoundEnum.drip,
        playSound: true);
  }

  static CustomReminderSound kpk() {
    return CustomReminderSound(
        'kpk_reminder', 'kpk reminder', ReminderSoundEnum.kpk,
        playSound: true);
  }
}

final defaultReminder = CustomReminderSound.defaultReminder();
final uwuReminder = CustomReminderSound.uwu();
final dripReminder = CustomReminderSound.drip();
final kpkReminder = CustomReminderSound.kpk();
