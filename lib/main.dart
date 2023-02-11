import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/background_processes/background_processes.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/bell/local_path_provider.dart';
import 'package:flutter_lucid_bell/home_view/home_screen.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';

import 'app.dart';

class InitServices {
  static CustomNotificationService notificationService =
      CustomNotificationService();
  static Bell bell = Bell(
      running: false,
      interval: const Duration(minutes: 5),
      startEveryHour: false);

  static StreamSubscription? bellListenerSub;

  static Future<void> init(MyApp app) async {
    await notificationService.init();
    print('notification initialized');
    await LocalPathProvider.init();
    print('local path initialized');
    bellListenerSub = notificationService.bellListener(bell).listen((event) {
      notificationService.circleNotification(
          bell, app.homeScreen.homeScreenState.nextBellCallback);
    });
  }
}

void main() async {
  var myApp = MyApp();
  WidgetsFlutterBinding.ensureInitialized();
  // init services
  print('************************************start init');
  InitServices.init(myApp);
  runApp(myApp);
}
