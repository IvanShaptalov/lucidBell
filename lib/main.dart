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

  static Bell bell = Bell(running: false,interval: const Duration(minutes: 15),startEveryHour: false);

  static var myApp = MyApp();

  static StreamSubscription? bellListenerSub;

  static Future<bool> init() async {
    await LocalPathProvider.init();
    print('local path initialized');
    //LOAD BELL FIRST
    await notificationService.init();
    print('notification initialized');
    print('bell registered');
    registerBellListener();
    var cashedBell = await Bell.loadLocalSettings();

    bell = cashedBell ?? bell;
    return true;
  }

  static void registerBellListener() {
    bellListenerSub = notificationService.bellListener(bell).listen((event) {
      notificationService.circleNotification(
          bell, myApp.homeScreen.homeScreenState.nextBellCallback);
    });
    notificationService.clearNotifications();
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
