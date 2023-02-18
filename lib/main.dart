import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/config.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';

@pragma('vm:entry-point')

/// [callbackDispatcher] is background task that started in [InitServices.notificationService.circleNotification]
/// load bell from file, add new interval save new bell to file and schedule notification to 1 seconds;
void callbackDispatcher() {
  // WidgetsFlutterBinding.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    // NESSESARY INITIALIZATION

    if (LocalPathProvider.notInitialized) {
      await LocalPathProvider.init();
    }
    assert(LocalPathProvider.initialized);

    Bell? bell = await Bell.loadLocalSettings();

    String nextBellOn = 'Reminder';
    assert(bell != null);

    //FIND OUT TASK
    try {
      switch (task) {
        case Config.intervalTask:
          assert(bell != null);
          DateTime nextBell = DateTime.now().add(bell!.getInterval);

          nextBellOn += ', next bell on $nextBell';

          bell.notificationStack = [nextBell];
          

          await InitServices.notificationService
              .scheduleNotifications('bell notification', nextBellOn);

          // WAIT FOR NOTIFICATION
          await Future.delayed(const Duration(seconds: 5));

          LocalPathProvider.saveBell(bell);

          break;
      }

      return Future.value(true);
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  });
}

class InitServices {
  static CustomNotificationService notificationService =
      CustomNotificationService();
  static bool isSliderChanging = false;
  static Bell bell = mockBell();
  static Bell mockBell() => Bell(false, [], const Duration(minutes: 15));

  static var myApp = MyApp();

  static StreamSubscription? bellListenerSub;

  static Future<bool> init() async {
    await LocalPathProvider.init();
    print('local path initialized');
    await notificationService.init();
    print('notification initialized');
    print('bell registered');
    Bell? cashedBell = await Bell.loadLocalSettings();
    if (cashedBell != null) {
      InitServices.bell = cashedBell;
    }
    // if bell cashed, yield bell if bell listener condition;

    registerBellListener();

    return true;
  }

  static void registerBellListener() {
    bellListenerSub = notificationService.bellListener().listen((event) {
      notificationService.circleNotification(bell);
    });
    // notification clearing here
  }
}

void main() async {
  // load widgets firstry
  WidgetsFlutterBinding.ensureInitialized();

  // init services
  print('************************************start init');

  await InitServices.init();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );

  runApp(InitServices.myApp);
}
