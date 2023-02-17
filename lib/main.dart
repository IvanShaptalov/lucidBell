import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/config.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  // WidgetsFlutterBinding.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    // NESSESARY INITIALIZATION

    if (LocalPathProvider.notInitialized) {
      await LocalPathProvider.init();
    }
    assert(LocalPathProvider.initialized);

    String? bellJson = await LocalPathProvider.getBellJsonAsync();
    Bell? bell;

    if (bellJson != null) {
      bell = Bell.fromJson(bellJson);
    }

    String nextBellOn = 'Reminder';

    //FIND OUT TASK
    try {
      switch (task) {
        case Config.intervalTask:
          assert(bell != null);

          nextBellOn += ', next bell on ${DateTime.now().add(bell!.interval)}';

          await InitServices.notificationService
              .scheduleNotifications('bell notification', nextBellOn);

          break;
        // ONE HOUR NOTIFICATION TASK
        case Config.oneHourNotificationTask:
          assert(inputData != null);
          var duration = Duration(seconds: inputData!['next_in_seconds']);
          nextBellOn += ', next bell on ${DateTime.now().add(duration)}';

          await InitServices.notificationService
              .scheduleNotifications('bell notification', nextBellOn);

          break;
        // ONE HOUR PERIODIC TASK
        case Config.oneHourPeriodicTask:
          assert(bell!.interval.inMinutes == 60);
          assert(inputData != null);

          var duration = Duration(seconds: inputData!['next_in_seconds']);
          if (duration.inSeconds != 0) {
            await Future.delayed(duration).then((value) async {
              await InitServices.notificationService
                  .scheduleNotifications('bell notification', nextBellOn);
            });
            print('clear next in seconds');
            inputData['next_in_seconds'] = 0;
          } else {
            assert (duration.inSeconds == 0);
            await InitServices.notificationService
                .scheduleNotifications('bell notification', nextBellOn);
          }

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

  static Bell bell = mockBell();
  static Bell mockBell() => Bell(
      running: false,
      interval: const Duration(minutes: 15),
      startEveryHour: false,
      notificationStack: []);

  static var myApp = MyApp();

  static StreamSubscription? bellListenerSub;

  static Future<bool> init() async {
    await LocalPathProvider.init();
    print('local path initialized');
    await notificationService.init();
    print('notification initialized');
    print('bell registered');
    registerBellListener();
    var cashedBell = await Bell.loadLocalSettings();

    bell = cashedBell ?? bell;
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
