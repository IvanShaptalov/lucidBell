import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/config_android_presenter.dart';
import 'package:workmanager/workmanager.dart';

mixin AndroidBellBackgroundManager {
  static bool _initialized = false;

  static get initialized => _initialized;

  static cancelPreviousTasksAsync() async {
    await Workmanager().cancelAll();
    return true;
  }

  static registerIntervalTaskAsync(Duration innerInterval) async {
    await Workmanager().registerPeriodicTask('interval task', 'interval task',
        frequency: innerInterval);
    return true;
  }
}
