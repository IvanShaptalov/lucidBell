import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/bell/bell.dart';
import 'package:flutter_lucid_bell/model/data_structures/data_structures.dart';
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';

///Implement android platform dependencies, Cashing, work in background, notification service
class AndroidBell extends Bell with AndroidBellStorageManager {
//=====================================================CONSTRUCTORS==================================================
  AndroidBell(running, interval, threeCashedIntervals)
      : super(running, interval, threeCashedIntervals);

  static AndroidBell mockBell() {
    return AndroidBell(true, const Duration(minutes: 15), CashedIntervals());
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

//======================================================IO=============================================================
  static Future<AndroidBell> loadFromStorage() async {
    return await AndroidBellStorageManager.loadBellFromStorage();
  }

  static AndroidBell saveToStorage() {
    return AndroidBellStorageManager.saveBellToStorage();
  }
}
