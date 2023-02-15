import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';
import 'package:workmanager/workmanager.dart';

import 'app.dart';

void callbackDispatcher() {
  WidgetsFlutterBinding.ensureInitialized();

  Workmanager().executeTask((task, inputData) async {
    try {
      WidgetsFlutterBinding.ensureInitialized();

      await Future.delayed(Duration(seconds: 15)).then((value) async {
        print('play after 15 sec &&&&&&&&&&&&&&&&&&&&&&&&&&&&7');
        return await InitServices.notificationService.scheduleNotifications();
      });
      print(
          "Native called background task: $task"); //simpleTask will be emitted here.

      return Future.value(true);
    } catch (e) {
      print(e.toString());
      return Future.error('lala');
    }
  });
}

class InitServices {
  static CustomNotificationService notificationService =
      CustomNotificationService();

  static Bell bell = mockBell();
  static Bell mockBell() => Bell(
      running: false,
      interval: const Duration(minutes: 1),
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
      notificationService.circleNotification(
          bell, myApp.homeScreen.homeScreenState.nextBellCallback);
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
          false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  Workmanager().registerOneOffTask("task-identifier", "simpleTask");
  runApp(InitServices.myApp);
}
