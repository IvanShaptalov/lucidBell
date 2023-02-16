// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:workmanager/workmanager.dart';

class CustomNotificationService {
  int currentId = 0;
  Random rand = Random();
  bool _notificationCashedFlag = false;
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // #1
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings =
        InitializationSettings(android: androidSetting);

    // #3
    await _localNotificationsPlugin.initialize(initSettings).then((_) {
      debugPrint('setupPlugin: setup success');
    }).catchError((Object error) {
      debugPrint('Error: $error');
    });
  }

  Future<void> playSound(
    title,
    body,
    endTime,
    channel,
  ) async {
    // #1
    
    tzData.initializeTimeZones();
    final scheduleTime =
        tz.TZDateTime.fromMillisecondsSinceEpoch(tz.local, endTime);

// #2
    final androidDetail = AndroidNotificationDetails(
        channel, // channel Id
        channel // channel Name
        );


    final noticeDetail = NotificationDetails(
      android: androidDetail,
    );

// #3
    final id = 0;

// #4
    await _localNotificationsPlugin.zonedSchedule(
      id,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }

  //id to identify new notification
  Future<void> scheduleNotifications(String title, String body) async {
    try {
      await playSound(
          title, body, DateTime.now().millisecondsSinceEpoch + 1000, 'testing');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Stream<Bell> bellListener() async* {
    print(
        'started listed inner bell {$InitServices.bell.hashcode},\n now : {$InitServices.bell.running}');
    //create shall copy
    Bell innerBell = Bell(
        interval: const Duration(days: 1),
        running: false,
        startEveryHour: false,
        notificationStack: []);
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      if (innerBell != InitServices.bell) {
        // UPDATE AND SAVE BELL
        innerBell = Bell.clone(InitServices.bell);
        print('bell saved ${innerBell.toJson()}');
        await LocalPathProvider.saveBell(innerBell.toJson());

        yield innerBell;
      }
    }
  }

  Future<bool> isNotificationsShowed() async {
    return Future.value(true);
  }

  /// select corresponding to start on every hour or using interval
  Duration _selectIntervalModeDuration(Bell innerBell) {
    Duration duration;

    // if notification stack not empty and date not expired, calculate time to it
    if (innerBell.notificationStack.isNotEmpty) {
      DateTime cashedNotification = innerBell.notificationStack.first;
      // not empty and not expired
      if (cashedNotification.isAfter(DateTime.now())) {
        print('cashed notification is not expired');
        // assert, cashed must not be EXPIRED
        assert(cashedNotification.isAfter(DateTime.now()));
        duration = cashedNotification.difference(DateTime.now());
        //set flag that notification come from cash
        _notificationCashedFlag = true;
        return duration;
      }
    }
    if (innerBell.startEveryHour) {
      // IF START ON EVERY HOUR: ADD new schedule
      int minutesToAdd = 60 - DateTime.now().minute;
      duration = Duration(minutes: minutesToAdd);
    } else {
      duration = innerBell.interval;
    }

    return duration;
  }

  DateTime _convertDurationToDatetime(Duration duration) {
    return DateTime.now().add(duration);
  }

  void circleNotification(Bell innerBell) async {
    // NOTIFICATION STACK ALWAYS CONTAIN ONE OR NOT CONTAINS NOTIFICATIONS;

    // NOTIFICATION SCHEDULING LOGIC HERE
    if (innerBell.running) {
      Duration duration = _selectIntervalModeDuration(innerBell);
      DateTime dt = _convertDurationToDatetime(duration);

    
      print('try add notification');
      if (innerBell.startEveryHour) {
        // cancel all tasks

        Workmanager().cancelAll();
        print('period hour');
        Workmanager().registerPeriodicTask("one-hour-task", "simpleOnHourTask",
            frequency: const Duration(hours: 1), initialDelay: duration);

        print('one task');
        Workmanager().registerOneOffTask("one-hour-notification", "simpleOnHourNotificationTask", inputData: <String, dynamic>{'next_in_seconds': duration.inSeconds});
      } else {
        // add new task
        Workmanager().cancelAll();
        Workmanager().registerPeriodicTask("interval-task", "simpleIntervalTask",
            frequency: InitServices.bell.interval);
      }
    } else {
      InitServices.bell.clearNotifications();
      Workmanager().cancelAll();
    }
  }
}
