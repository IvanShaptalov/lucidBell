import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz_data;

class CustomNotificationService {
  int currentId = 0;
  static Random rand = Random();
  static final _localNotificationsPlugin = FlutterLocalNotificationsPlugin();
  static AndroidInitializationSettings? androidSetting;
  static InitializationSettings? initSettings;

  static Future<bool> initAsync() async {
    // #1
    androidSetting = const AndroidInitializationSettings('@mipmap/ic_launcher');

    initSettings = InitializationSettings(android: androidSetting);

    // #3
    return await _localNotificationsPlugin.initialize(initSettings!).then((_) {
      debugPrint('setupPlugin: setup success');
      return true;
    }).catchError((Object error) {
      debugPrint('Error: $error');
      return false;
    });
  }

  // IF NOT PENDING NOTIFICATIONS - SENT;
  static Future<bool> isNotificationSent() async {
    return (await _localNotificationsPlugin.pendingNotificationRequests())
        .isEmpty;
  }

  static Future<void> registerNotification(
    title,
    body,
    endTime,
    channel,
  ) async {
    // #1

    tz_data.initializeTimeZones();
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
    await _localNotificationsPlugin.zonedSchedule(
      1,
      title,
      body,
      scheduleTime,
      noticeDetail,
      uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime,
      androidAllowWhileIdle: true,
    );
  }
}

mixin AndroidBellNotificationService {

  static const Duration notificationTimeout = Duration(seconds: 20);
  static Future<bool> initAsync() async {
    return await CustomNotificationService.initAsync();
  }

  static Future<bool> playNotification(
      String title, String body, Duration timeout) async {
    try {
      // register notification to play
      await CustomNotificationService.registerNotification(
          title, body, DateTime.now().millisecondsSinceEpoch + 1000, 'reminder');

      Future.delayed(timeout)
          .then((value) => throw Exception('notification timeout'));
      // wait for sending timeout time, throw exception if not sent
      while (!(await CustomNotificationService.isNotificationSent())) {
        await Future.delayed(const Duration(milliseconds: 100));
      }

      return true;
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false;
    }
  }
}
