enum ReminderSoundEnum {
  defaultReminder,
  uwu,
  iphone,
  glass,
  drip,
  cricket,
  kpk
}

class CustomReminderSound {
  String? rawPath;
  String channel;
  bool playSound;

  CustomReminderSound(this.rawPath, this.channel, {this.playSound = false});

  static CustomReminderSound defaultReminder() {
    return CustomReminderSound(null, 'default reminder', playSound: false);
  }

  static CustomReminderSound uwu() {
    return CustomReminderSound('uwu_reminder', 'uwu reminder', playSound: true);
  }

  static CustomReminderSound iphone() {
    return CustomReminderSound('iphone_reminder', 'iphone reminder',
        playSound: true);
  }

  static CustomReminderSound glass() {
    return CustomReminderSound('glass_reminder', 'glass reminder',
        playSound: true);
  }

  static CustomReminderSound drip() {
    return CustomReminderSound('drip_reminder', 'drip reminder',
        playSound: true);
  }

  static CustomReminderSound cricket() {
    return CustomReminderSound('cricket_reminder', 'cricket reminder',
        playSound: true);
  }

  static CustomReminderSound kpk() {
    return CustomReminderSound('kpk_reminder', 'kpk reminder', playSound: true);
  }
}

final defaultReminder = CustomReminderSound.defaultReminder();
final iphoneReminder = CustomReminderSound.iphone();
final uwuReminder = CustomReminderSound.uwu();
final glassReminder = CustomReminderSound.glass();
final dripReminder = CustomReminderSound.drip();
final cricketReminder = CustomReminderSound.cricket();
final kpkReminder = CustomReminderSound.kpk();
