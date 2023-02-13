import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/background_processes/background_processes.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';

import 'app.dart';

class InitServices {
  static CustomNotificationService notificationService =
      CustomNotificationService();

  static Bell bell = mockBell();
  static Bell mockBell() => Bell(running: false,interval: const Duration(minutes: 1),startEveryHour: false, notificationStack: []);

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
  BackgroundWorker.init(InitServices.myApp);
  runApp(InitServices.myApp);
}
