import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart' show WidgetsFlutterBinding, runApp;
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart' show StorageLogger;
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart' show AndroidBell;
import 'package:flutter_lucid_bell/presenter/android/background_implementation/background_implementation.dart' show AndroidBellBackgroundManager;
import 'package:flutter_lucid_bell/presenter/android/config_presenter.dart' show ConfigBackgroundManager;
import 'package:flutter_lucid_bell/presenter/presenter.dart' show Presenter, PresenterTextReminder;
import 'package:flutter_lucid_bell/view/app.dart' show MyApp;
import 'package:flutter_lucid_bell/view/view.dart' show View;

import 'dart:async';
import 'package:workmanager/workmanager.dart';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((task, inputData) async {
    // NESSESARY INITIALIZATION
    await AndroidBell.initServicesAsync();
    await PresenterTextReminder.initAsync();

    AndroidBell bell =
        await AndroidBell.loadFromStorage(disabledBackgroundWork: true);

    try {
      // expect that notification updated

      bell.updateNextNotificationOn();

      String justNextBell =
          "next 🔔 on ${bell.getNextNotificationOnFormatted()}";
      String nextBellOnMessage =
          PresenterTextReminder.reminderText!.getReminderText;
      if (kDebugMode) {
        print(nextBellOnMessage);
      }
      // send notification
      bool result =
          await bell.sendNotification(justNextBell, nextBellOnMessage);

      // WAIT FOR NOTIFICATION

      await bell.saveToStorageAsync();

      return Future.value(result);
    } catch (e) {
      await StorageLogger.logBackgroundAsync(
          'error in background: ${e.toString()}');
      return Future.error(e.toString());
    }
  });
}

Future<void> main() async {
  // load widgets firstry
  WidgetsFlutterBinding.ensureInitialized();

  // init services
  await Presenter.initAsync();
  await View.initAsync();

  Workmanager().initialize(
      callbackDispatcher, // The top level function, aka callbackDispatcher
      isInDebugMode: ConfigBackgroundManager
          .debugMode // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
      );
  AndroidBellBackgroundManager.initialized = true;

  runApp(MyApp());
}
