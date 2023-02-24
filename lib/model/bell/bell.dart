import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/config_model.dart';
import 'package:flutter_lucid_bell/model/data_structures/data_structures.dart';

abstract class BaseBell {
  // ======================================FIELDS, GETTERS AND SETTERS====================================================
  @protected
  late bool innerRunning;

  /// true if [running] set, false if not
  bool setRunning(bool running);
  bool getRunning();

  @protected
  late Duration innerInterval;

  /// false if [interval] not set, true if set,  set[nextNotificationOn] here
  bool setInterval(Duration interval);
  Duration getInterval();

  @protected
  DateTime? innerNextNotificationOn;

  DateTime? getNextNotificationOn();
  // ============================================CONSTRUCTORS============================================================

  BaseBell clone();

  // ======================================ABSTRACT METHODS===============================================================

  /// true if [nextNotification] cleared, false if not
  @protected
  bool clearNextNotificationTime();

  @protected
  DateTime setNextNotificationTime();

  /// present duration to human readable style
  String humanLikeDuration(Duration duration);

  /// load bell from implemented storage
}

/// =========================================[MAIN LOGIC IMPLEMENTATION] |[class Bell]====================================
class Bell extends BaseBell {
// ======================================CONSTANTS======================================================================

  final double intervalLowerBound = BellConfig.bellMinutesLowerBound;
  final double intervalUpperBound = BellConfig.bellMinutesUpperBound;

// =========================================FIELDS, GETTERS, SETTERS (IN METHOD IMPLEMENTATION)===========================
  @protected
  late CashedIntervals innerThreeCashedIntervals;

  CashedIntervals get getThreeCashedIntervals => innerThreeCashedIntervals;

  @override
  bool setRunning(bool running) {
    innerRunning = running;
    // if run, set new Notification time
    if (innerRunning) {
      setNextNotificationTime();
    }
    // esle clear it
    else {
      clearNextNotificationTime();
    }
    return innerRunning;
  }

  @override
  Duration getInterval() => innerInterval;

  @override
  bool setInterval(Duration interval) {
    assert(interval.inMinutes <= intervalUpperBound);
    assert(interval.inMinutes >= intervalLowerBound);

    innerInterval = interval;

    // update cashed buttons
    innerThreeCashedIntervals.push(innerInterval);

    // update notification time
    setNextNotificationTime();

    return (innerNextNotificationOn != null);
  }

  @override
  DateTime setNextNotificationTime() {
    innerNextNotificationOn = DateTime.now().add(innerInterval);
    return innerNextNotificationOn!;
  }

  @protected
  @override
  bool clearNextNotificationTime() {
    innerNextNotificationOn = null;
    return (innerNextNotificationOn == null);
  }

  @override
  bool getRunning() => innerRunning;

  @override
  DateTime? getNextNotificationOn() => innerNextNotificationOn;

// =========================================CONSTRUCTORS AND INIT METHODS=================================================

  static Future<bool> initServices() async {
    return Future.value(true);
  }

  @override
  Bell(bool running, Duration interval, this.innerThreeCashedIntervals) {
    innerInterval = interval;
    innerRunning = running;
    setInterval(interval);
    setRunning(running);
  }

  static Bell mockBell() {
    return Bell(true, const Duration(minutes: 15), CashedIntervals());
  }

  @protected
  Bell.protectedCreating(bool running, Duration interval,
      CashedIntervals threeCashedIntervals, DateTime? nextNotificationOn) {
    innerRunning = running;
    innerInterval = interval;
    innerThreeCashedIntervals = threeCashedIntervals;
    innerNextNotificationOn = nextNotificationOn;
  }

  @override
  Bell clone() {
    return Bell.protectedCreating(innerRunning, innerInterval,
        innerThreeCashedIntervals, innerNextNotificationOn);
  }

// ==========================================UTILS METHODS ================================================================

  bool updateNextNotificationOn() {
    return setInterval(innerInterval);
  }

  @override
  String humanLikeDuration(Duration duration) {
    assert(duration.inMinutes > 0);
    int totalHours = duration.inHours;
    int minutesLeft = duration.inMinutes - (totalHours * 60);
    String strHours = "";
    String strMinutes = "";
    switch (totalHours) {
      case 0:
        strHours = "";
        break;
      case 1:
        strHours = "$totalHours hour";
        break;
      default:
        strHours = "$totalHours hours";
    }

    switch (minutesLeft) {
      case 0:
        strMinutes = "";
        break;
      case 1:
        strMinutes = "$minutesLeft minute";
        break;
      default:
        strMinutes = "$minutesLeft minutes";
    }
    return "$strHours $strMinutes";
  }

// =========================================================JSON METHODS==================================================

  String toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'running': innerRunning,
      'intervalInSeconds': innerInterval.inSeconds,
      'nextNotificationOn': innerNextNotificationOn != null
          ? innerNextNotificationOn!.toString()
          : null,
      'threeCashedIntervalsInSeconds':
          innerThreeCashedIntervals.toListOfSeconds()
    };
    return jsonEncode(map);
  }

  static Bell fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    String? nextNotificationOn = map['nextNotificationOn'];
    return Bell.protectedCreating(
      map['running'],
      Duration(seconds: map['intervalInSeconds']),
      CashedIntervals.fromListOfSeconds(map['threeCashedIntervalsInSeconds']),
      nextNotificationOn != null ? DateTime.parse(nextNotificationOn) : null,
    );
  }

// ================================================BASE OVERRIDE METHODS======================================================
  @override
  String toString() {
    return "running: $innerRunning, intervalInMilliseconds ${innerInterval.inMilliseconds} ${innerThreeCashedIntervals.toString()} ";
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(Object other) {
    return other is Bell && toString() == toString();
  }
}
