import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/bell/bell.dart';
import 'package:flutter_lucid_bell/model/data_structures/data_structures.dart';
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/background_implementation/background_implementation.dart';
import 'package:flutter_lucid_bell/presenter/android/notifications/notification_service.dart';

///Implement android platform dependencies, Cashing, work in background, notification service
class AndroidBell extends Bell
    with
        AndroidBellStorageManager,
        AndroidBellNotificationService,
        AndroidBellBackgroundManager {
//======================================================FIELDS GETTERS, SETTERS=======================================
  static const Duration notificationTimeout =
      AndroidBellNotificationService.notificationTimeout;

  int getSecondsToNextNotification() {
    int seconds = innerNextNotificationOn!.difference(DateTime.now()).inSeconds;
    return seconds <= 0 ? 0 : seconds;
  }

  @override
  bool setRunning(bool running) {
    innerRunning = running;
    // if run, set new Notification time
    if (innerRunning) {
      setNextNotificationTime();
      registerIntervalTask();
    }
    // esle clear it
    else {
      clearNextNotificationTime();
      cancelIntervalTask();
    }
    saveToStorageAsync();
    return innerRunning;
  }

  @override
  bool setInterval(Duration interval, {bool fromBackgound = false}) {
    assert(interval.inMinutes <= intervalUpperBound);
    assert(interval.inMinutes >= intervalLowerBound);

    innerInterval = interval;

    // update cashed buttons
    innerThreeCashedIntervals.push(innerInterval);

    // update notification time
    setNextNotificationTime();

    // run task if bell running
    if (innerRunning && !fromBackgound) {
      registerIntervalTask();
    }

    saveToStorageAsync();
    return (innerNextNotificationOn != null);
  }

  @override
  bool updateNextNotificationOn() {
    innerNextNotificationOn = DateTime.now().add(innerInterval);
    return true;
  }

//=====================================================CONSTRUCTORS==================================================
  AndroidBell(running, interval, threeCashedIntervals)
      : super(running, interval, threeCashedIntervals);

  static AndroidBell mockBell() {
    return AndroidBell(false, const Duration(minutes: 15), CashedIntervals());
  }

  static Future<bool> initServicesAsync() async {
    // init storage
    bool storageInit = await LocalManager.initAsync();
    bool notificationInit = await AndroidBellNotificationService.initAsync();

    bool allInited = storageInit && notificationInit;
    assert(allInited);

    return allInited;
  }

  @protected
  AndroidBell.protectedCreating(bool running, Duration interval,
      CashedIntervals threeCashedIntervals, DateTime? nextNotificationOn)
      : super.protectedCreating(
            running, interval, threeCashedIntervals, nextNotificationOn);

  @override
  AndroidBell clone() {
    return AndroidBell.protectedCreating(innerRunning, innerInterval,
        innerThreeCashedIntervals, innerNextNotificationOn);
  }

  static AndroidBell fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    String? nextNotificationOn = map['nextNotificationOn'];
    return AndroidBell.protectedCreating(
      map['running'],
      Duration(seconds: map['intervalInSeconds']),
      CashedIntervals.fromListOfSeconds(map['threeCashedIntervalsInSeconds']),
      nextNotificationOn != null ? DateTime.parse(nextNotificationOn) : null,
    );
  }

  factory AndroidBell.mockBellWithoutBackground() =>
      AndroidBell.protectedCreating(
          false, const Duration(minutes: 15), CashedIntervals(), DateTime.now());
//======================================================IO===============================================================
  static Future<AndroidBell> loadFromStorage(
      {bool disabledBackgroundWork = false}) async {
    return await AndroidBellStorageManager.loadBellFromStorage(
        disabledBackgroundWork: disabledBackgroundWork);
  }

  Future<bool> saveToStorageAsync() async {
    return await AndroidBellStorageManager.saveBellToStorageAsync(this);
  }

//==================================================BACKGROUND SERVICE===================================================

  Future<bool> registerIntervalTask() async {
    await AndroidBellBackgroundManager.cancelPreviousTasksAsync();
    return await AndroidBellBackgroundManager.registerIntervalTaskAsync(
        innerInterval);
  }

  Future<bool> cancelIntervalTask() async {
    await AndroidBellNotificationService.cancelNotification();
    return await AndroidBellBackgroundManager.cancelPreviousTasksAsync();
  }

//===================================================NOTIFICATION SERVICE================================================

  Future<bool> sendNotification(String title, String body,
      {Duration timeout = notificationTimeout}) async {
    return await AndroidBellNotificationService.playNotification(
        title, body, timeout);
  }
//====================================================PERMISSIONS SERVICE================================================
}
