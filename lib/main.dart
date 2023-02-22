// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/background_implementation/background_implementation.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/app.dart';

import 'dart:async';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {

  Workmanager().executeTask((task, inputData) async {
    // NESSESARY INITIALIZATION
    await AndroidBell.initServicesAsync();

    AndroidBell bell = await AndroidBell.loadFromStorage();

    String nextBellOnMessage = 'Reminder';

    try {
      // expect that notification updated

      bell.updateNextNotificationOn();

      nextBellOnMessage += ', next bell on ${bell.getNextNotificationOn()}';

      // send notification
      bool result =
          await bell.sendNotification('bell notification', nextBellOnMessage);

      // WAIT FOR NOTIFICATION

      await bell.saveToStorageAsync();

      return Future.value(result);
    } catch (e) {
      print(e.toString());
      return Future.error(e.toString());
    }
  });
}

Future<void> main() async {
  // load widgets firstry
  WidgetsFlutterBinding.ensureInitialized();

  // init services
  await BellPresenter.init();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode:
          true // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  AndroidBellBackgroundManager.initialized = true;

  runApp(MyApp());
}
