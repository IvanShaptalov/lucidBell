import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/bell/local_path_provider.dart';
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
  static List<DateTime> notificationStack = [];

  static Future<void> init() async {
    await notificationService.init();
    print('notification initialized');
    await LocalPathProvider.init();
    print('local path initialized');
    bellListenerSub = notificationService.bellListener(bell).listen((event) {
      // NOTIFICATION SCHEDULING LOGIC HERE
      if (bell.running) {

        // SERVICE STARTED
        DateTime dt;
        if (bell.startEveryHour) {
          // IF START ON EVERY HOUR: ADD new schedule
          int minutesToAdd = 60 - DateTime.now().minute;
          dt = DateTime.now().add(Duration(minutes: minutesToAdd));
        } else {
          dt = DateTime.now().add(bell.interval);
        }

        // ADD SCHEDULE TO NOTIFICATION STACK
        if (notificationStack.isEmpty) {
          notificationService.scheduleNotifications(title: 'notification',time: dt, body: 'some text', id: Random().nextInt(1000000));
          notificationStack.add(dt);
          print('next bell on $dt');
        }
        // IF SCHEDULE ALREADY EXIST DELETE IT WHEN TIME COME
        else {
          var notificationDate = notificationStack.first;
          // CLEAR NOTIFICATIONS STACK
          if (DateTime.now().compareTo(notificationDate.add(Duration(seconds: 5))) == 1) {
            print('***************notification played');
            notificationService.cancelNotifications();
            notificationStack.clear();
          }
        }
      } else {
        notificationService.cancelNotifications();
        notificationStack.clear();
      }
    });
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init services
  print('************************************start init');
  InitServices.init();
  runApp(const MyApp());
}
