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
//======================================================FIELDS=======================================================
  static const Duration notificationTimeout = AndroidBellNotificationService.notificationTimeout;

//=====================================================CONSTRUCTORS==================================================
  AndroidBell(running, interval, threeCashedIntervals)
      : super(running, interval, threeCashedIntervals);

  static AndroidBell mockBell() {
    return AndroidBell(true, const Duration(minutes: 15), CashedIntervals());
  }

  
  @override
  static Future<bool> initServices() async {
    // init storage
    bool storageInit = await AndroidBellStorageManager.initAsync();
    bool backgroundInit = await AndroidBellBackgroundManager.initAsync();
    bool notificationInit = await AndroidBellNotificationService.initAsync();

    bool allInited = storageInit && backgroundInit && notificationInit;
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

//======================================================IO===============================================================
  static Future<AndroidBell> loadFromStorage() async {
    return await AndroidBellStorageManager.loadBellFromStorage();
  }

  Future<bool> saveToStorage() async {
    return await AndroidBellStorageManager.saveBellToStorageAsync(this);
  }

//==================================================BACKGROUND SERVICE===================================================

  Future<bool> registerIntervalTask() async{
    await AndroidBellBackgroundManager.cancelPreviousTasksAsync();
    return await AndroidBellBackgroundManager.registerIntervalTaskAsync(innerInterval);

  }

//===================================================NOTIFICATION SERVICE================================================

  Future<bool> sendNotification(
      String title, String body, {Duration timeout = notificationTimeout}) async {
    return await AndroidBellNotificationService.playNotification(
        title, body, timeout);
  }
//====================================================PERMISSIONS SERVICE================================================
}
