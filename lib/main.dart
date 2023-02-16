import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  // WidgetsFlutterBinding.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    try {
      await LocalPathProvider.init();
      print('play after 15 sec &&&&&&&&&&&&&&&&&&&&&&&&&&&&7');
      String? bellJson = await LocalPathProvider.getBellJsonAsync();
      Bell? bell;

      if (bellJson != null) {
        bell = Bell.fromJson(bellJson);
      }

      String nextBellOn = 'Reminder';

      if (bell != null) {
        nextBellOn += ', next bell on ${DateTime.now().add(bell.interval)}';
      }
      if (inputData != null) {
        nextBellOn =
            ', next bell on ${DateTime.now().add(Duration(seconds: inputData['next_in_seconds']))}';
      }

      await InitServices.notificationService
          .scheduleNotifications('bell notification', nextBellOn);

      print(
          "Native called background task: $task"); //simpleTask will be emitted here.

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
