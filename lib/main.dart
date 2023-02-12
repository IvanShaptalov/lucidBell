import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';

import 'app.dart';

///Use awaitinitCashThenBell] then await[init] to correct work
class InitServices {
  static CustomNotificationService notificationService =
      CustomNotificationService();
  static Bell? bell;

  static Future<Bell> initCashThenBell() async {
    /// INIT BELL FIRST
    await LocalPathProvider.init();
    print('local path initialized');

    bell = await Bell.loadLocalSettings();

    bell ??= Bell(
        running: false,
        interval: const Duration(minutes: 5),
        startEveryHour: false);

    // save bell to json
    assert(await LocalPathProvider.saveBell(bell!.toJson()), true);
    return bell!;
  }

  static StreamSubscription? bellListenerSub;

  static Future<bool> init(MyApp app) async {
    //LOAD BELL FIRST
    await notificationService.init();
    print('notification initialized');
    bellListenerSub = notificationService.bellListener(bell!).listen((event) {
      notificationService.circleNotification(
          bell!, app.homeScreen.homeScreenState.nextBellCallback);
    });
    return true;
  }
}

void main() async {
  // load widgets firstry
  WidgetsFlutterBinding.ensureInitialized();

  await InitServices.initCashThenBell();
  var myApp = MyApp();
  // init services
  print('************************************start init');
  await InitServices.init(myApp);
  runApp(myApp);
}
