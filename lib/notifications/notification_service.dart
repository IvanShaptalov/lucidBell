// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/config.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tzData;
import 'package:workmanager/workmanager.dart';

class CustomNotificationService {
  int currentId = 0;
  Random rand = Random();
  final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    // #1
    const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');

    const initSettings = InitializationSettings(android: androidSetting);

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
        notificationStack: []);
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      if (innerBell != InitServices.bell) {
        // UPDATE AND SAVE BELL
        innerBell = Bell.clone(InitServices.bell);
        print('bell saved ${innerBell.toJson()}');
        await LocalPathProvider.saveBell(innerBell.toJson());

        yield innerBell;
      } else if (innerBell.running && innerBell.notificationStack.isEmpty) {
        yield innerBell; // notification stack must be always with notification if running, when load
        // from cash it can be empty
      }
    }
  }

  Future<bool> isNotificationsShowed() async {
    return Future.value(true);
  }

  /// select corresponding to start on every hour or using interval

  DateTime _convertDurationToDatetime(Duration duration) {
    return DateTime.now().add(duration);
  }

  Future<void> clearNotifications() async {
    await _localNotificationsPlugin.cancelAll();
  }

  void circleNotification(Bell innerBell) async {
    // NOTIFICATION STACK ALWAYS CONTAIN ONE OR NOT CONTAINS NOTIFICATIONS;

    // NOTIFICATION SCHEDULING LOGIC HERE
    if (innerBell.running) {
      print('try add notification');

      // add new task
      if (InitServices.bell.notificationStack.isEmpty) {
        await InitServices.bell.clearNotifications();
        InitServices.bell.notificationStack = [
          DateTime.now().add(InitServices.bell.interval)
        ];
        await LocalPathProvider.saveBell(innerBell.toJson());

        await Workmanager().registerPeriodicTask(
            Config.intervalTask, Config.intervalTask,
            frequency: InitServices.bell.interval);
      }
    } else {
      await InitServices.bell.clearNotifications();
    }
  }
}
