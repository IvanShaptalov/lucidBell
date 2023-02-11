// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class CustomNotificationService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  List<DateTime> notificationStack = [];

  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');

    //Initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    tz.initializeTimeZones();
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  Future<bool> scheduleNotifications({id, title, body, time}) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          tz.TZDateTime.from(time, tz.local),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  channelDescription: 'your channel description')),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
      return true; //notification delivered
    } catch (e) {
      // ignore: avoid_print
      print(e);
      return false; // error
    }
  }

  Future<void> cancelNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Stream<Bell> bellListener(Bell bell) async* {
    print(
        'started listed inner bell {$bell.hashcode},\n now : {$bell.running}');
    //create shall copy
    Bell innerBell = Bell.clone(bell);
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      if (innerBell != bell) {
        Bell innerBell = Bell.clone(bell);

        yield innerBell;
      }
    }
  }

  void clearNotifications() async {
    await cancelNotifications();
    notificationStack.clear();
  }

  Future<bool> isNotificationsShowed() async {
    return (await flutterLocalNotificationsPlugin.pendingNotificationRequests())
        .isEmpty;
  }

  void circleNotification(Bell innerBell, Function nextBellCallback) async {
    assert(notificationStack.length <= 1);  // notification stack always contain one or not contains notifications;
    // NOTIFICATION SCHEDULING LOGIC HERE
    if (innerBell.running) {
      // SERVICE STARTED
      DateTime dt;
      if (innerBell.startEveryHour) {
        // IF START ON EVERY HOUR: ADD new schedule
        int minutesToAdd = 60 - DateTime.now().minute;
        dt = DateTime.now().add(Duration(minutes: minutesToAdd));
      } else {
        dt = DateTime.now().add(innerBell.interval);
      }
      print(notificationStack.length);
      print(notificationStack);
      print(
          (await flutterLocalNotificationsPlugin.pendingNotificationRequests())
              .length);
      // ADD SCHEDULE TO NOTIFICATION STACK
      if (notificationStack.isEmpty) {
        bool success = await scheduleNotifications(
            title: 'notification',
            time: dt,
            body: 'some text',
            id: Random().nextInt(1000000));
        if (success) {
          notificationStack.add(dt);  // add notification to stack if scheduled
        }
        print('next bell on $dt');
        nextBellCallback('next bell on $dt');
      }
      // IF SCHEDULE ALREADY EXIST DELETE IT WHEN TIME COME
      else {
        var notificationDate = notificationStack.first;
        // CLEAR NOTIFICATIONS STACK
        if (DateTime.now().isAfter(notificationDate.add(Duration(seconds: 15)))) {
          print('***************notification played');
          clearNotifications();
        }
      }
    } else {
      clearNotifications();
    }
  }
}
