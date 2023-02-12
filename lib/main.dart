import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';

import 'app.dart';

class InitServices {
  static CustomNotificationService notificationService =
      CustomNotificationService();
  static Bell bell = Bell(
      running: false,
      interval: const Duration(minutes: 5),
      startEveryHour: false);

  static Future<void> initCash() async {
    /// INIT BELL FIRST
    await LocalPathProvider.init();
    print('local path initialized');
  }

  static Future<Bell?> tryLoadBellFromFiles() async {
    return await Bell.loadLocalSettings();
  }

  static StreamSubscription? bellListenerSub;

  static Future<bool> init(MyApp app) async {
    //LOAD BELL FIRST
    await notificationService.init();
    print('notification initialized');
    bellListenerSub = notificationService.bellListener(bell).listen((event) {
      notificationService.circleNotification(
          bell, app.homeScreen.homeScreenState.nextBellCallback);
    });
    notificationService.clearNotifications();
    var cashedBell = await Bell.loadLocalSettings();
    
    updateBellManually(cashedBell);
    return true;
  }

  static void updateBellManually(Bell? newBell) {
    if (newBell != null) {
      bell.interval = newBell.interval;
      bell.running = newBell.running;
      bell.startEveryHour = newBell.startEveryHour;
      print('bell updated');
    }
    print('bell NOT UPDATED');
  }
}

void main() async {
  // load widgets firstry
  WidgetsFlutterBinding.ensureInitialized();

  await InitServices.initCash();
  var myApp = MyApp();
  // init services
  print('************************************start init');
  await InitServices.init(myApp);
  runApp(myApp);
}
