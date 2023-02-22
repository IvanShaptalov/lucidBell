import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/config_android_presenter.dart';
import 'package:workmanager/workmanager.dart';

mixin AndroidBellBackgroundManager {
  static bool _initialized = false;

  static get initialized => _initialized;
  @pragma(
      'vm:entry-point') // needed if using Flutter 3.1+ or your code obfuscated
  static void backGroundWork() {
    Workmanager().executeTask((task, inputData) async {
      // NESSESARY INITIALIZATION
      await LocalPathProvider.initAsync();

      AndroidBell bell = await AndroidBell.loadFromStorage();

      String nextBellOnMessage = 'Reminder';

      try {
        // expect that notification updated

        assert(bell.updateNextNotificationOn(), true);

        nextBellOnMessage += ', next bell on ${bell.getNextNotificationOn()}';

        // send notification
        bool result = await bell.sendNotification(
            'bell notification', nextBellOnMessage);

        // WAIT FOR NOTIFICATION

        bell.saveToStorage();
        
        return Future.value(result);
      } catch (e) {
        print(e.toString());
        return Future.error(e.toString());
        // }
      }
    });
  }

  static Future<bool> initAsync() async {
    try {
       Workmanager().initialize(
        backGroundWork, // The top level function, aka callbackDispatcher
        isInDebugMode: ConfigBackgroundManager
            .debugMode // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
      
    } catch (e) {
      print("ERROR IN AndroidBellBackgroundManager ${e.toString()}");
      _initialized = false;
      return false;
    }
    _initialized = true;
    return true;
  }

  static Future<bool> registerIntervalTaskAsync(Duration frequency) async {
    await Workmanager().cancelAll();
    await Workmanager().registerPeriodicTask('unique periodic task', 'u p task', frequency: frequency);
    
    return true;
  }

  static Future<void> cancelPreviousTasksAsync() async{
    await Workmanager().cancelAll();
  }
}
