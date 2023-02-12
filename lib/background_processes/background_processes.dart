import 'dart:developer';
import 'dart:math' as math;

import 'package:flutter_lucid_bell/app.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:workmanager/workmanager.dart';

class BackgroundWorker {
  static Workmanager bgManager = Workmanager();

  @pragma(
      'vm:entry-point') // Mandatory if the App is obfuscated or using Flutter 3.1+
  static void bgCallbackDispatcher() async {
    log('started');
    try {
      Bell? bell;
      var bellJson = await LocalPathProvider.getBellJson();
      if (bellJson != null) {
        bell = Bell.fromJson(bellJson);
      }

      if (bell != null && bell.running == false) {
        bgManager.executeTask((task, inputData) async {
          bool success = await InitServices.notificationService
              .scheduleNotifications(
                  title: 'notification background',
                  time: DateTime.now().add(Duration(seconds: 10)),
                  body: 'some text',
                  id: math.Random().nextInt(1000000));
          return Future.value(true);
        });
      }
    } catch (e) {
      log(e.toString());
    }
  }

  static void cancelTask() {
    print('task cancelled');
    bgManager.cancelAll();
  }

  static void init(MyApp app) {
    bgManager.initialize(
        bgCallbackDispatcher, // The top level function, aka callbackDispatcher
        isInDebugMode:
            false // If enabled it will post a notification whenever the task is running. Handy for debugging tasks
        );
    bgManager.registerPeriodicTask(
      "periodic-task-identifier",
      "simplePeriodicTask",
      // When no frequency is provided the default 15 minutes is set.
      // Minimum frequency is 15 min. Android will automatically change your frequency to 15 min if you have configured a lower frequency.
      frequency: InitServices.bell.interval,
    );
  }
}
