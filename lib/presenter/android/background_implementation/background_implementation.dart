import 'package:workmanager/workmanager.dart' show Workmanager;

mixin AndroidBellBackgroundManager {
  static bool initialized = false;

  static cancelPreviousTasksAsync() async {
    await Workmanager().cancelAll();
    return true;
  }

  static Future<bool> registerIntervalTaskAsync(Duration innerInterval) async {
    await Workmanager().cancelAll();
    await Workmanager().registerPeriodicTask('interval task', 'interval task',
        frequency: innerInterval);
    return true;
  }
}
