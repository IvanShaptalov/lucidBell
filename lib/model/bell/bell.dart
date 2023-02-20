import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/config_model.dart';
import 'package:flutter_lucid_bell/model/data_structures/data_structures.dart';

abstract class BaseBell {
  // ======================================FIELDS, GETTERS AND SETTERS====================================================
  late bool _running;

  /// true if [running] set, false if not
  bool setRunning(bool running);
  bool getRunning();

  late Duration _interval;

  /// false if [_interval] not set, true if set,  set[_nextNotificationOn] here
  bool setInterval(Duration interval);
  Duration getInterval();

  DateTime? _nextNotificationOn;

  DateTime? getNextNotificationOn();
  // ============================================CONSTRUCTORS============================================================

  BaseBell init();

  BaseBell clone();

  // ======================================ABSTRACT METHODS===============================================================

  /// true if [_nextNotification] cleared, false if not
  @protected
  bool clearNextNotificationTime();

  @protected
  DateTime setNextNotificationTime();

  /// present duration to human readable style
  String humanLikeDuration(Duration duration);

  /// convert bell to json
  String toJson();

  /// load bell from implemented storage
  // =================================================IO==================================================================
  BaseBell loadFromStorage();

  BaseBell saveToStorage();
}

/// =========================================[MAIN LOGIC IMPLEMENTATION] |[class Bell]====================================
class Bell extends BaseBell {
// ======================================CONSTANTS======================================================================

  final double intervalLowerBound = BellConfig.bellMinutesLowerBound;
  final double intervalUpperBound = BellConfig.bellMinutesUpperBound;

// =========================================FIELDS, GETTERS, SETTERS (IN METHOD IMPLEMENTATION)===========================
  late CashedIntervals _threeCashedIntervals;

  CashedIntervals get getThreeCashedIntervals => _threeCashedIntervals;

  @override
  bool setRunning(bool running) {
    _running = running;
    // if run, set new Notification time
    if (running) {
      setNextNotificationTime();
    }
    // esle clear it
    else {
      clearNextNotificationTime();
    }
    return running;
  }

  @override
  Duration getInterval() => _interval;

  @override
  bool setInterval(Duration interval) {
    assert(interval.inMinutes <= intervalUpperBound);
    assert(interval.inMinutes >= intervalLowerBound);

    _interval = interval;
    _threeCashedIntervals.push(interval);
    setNextNotificationTime();
    return (_nextNotificationOn != null);
  }

  @override
  DateTime setNextNotificationTime() {
    _nextNotificationOn = DateTime.now().add(_interval);
    return _nextNotificationOn!;
  }

  @protected
  @override
  bool clearNextNotificationTime() {
    _nextNotificationOn = null;
    return (_nextNotificationOn == null);
  }

  @override
  bool getRunning() => _running;

  @override
  DateTime? getNextNotificationOn() => _nextNotificationOn;

// =========================================CONSTRUCTORS AND INIT METHODS=================================================

  @override
  Bell init() {
    throw UnimplementedError();
  }

  @override
  Bell(bool running, Duration interval, this._threeCashedIntervals) {
    setInterval(interval);
    setRunning(running);
  }

  factory Bell.mockBell() =>
      Bell(true, const Duration(minutes: 15), CashedIntervals());

  @protected
  Bell.protectedCreating(bool running, Duration interval,
      CashedIntervals threeCashedIntervals, DateTime? nextNotificationOn) {
    _running = running;
    _interval = interval;
    _threeCashedIntervals = threeCashedIntervals;
    _nextNotificationOn = nextNotificationOn;
  }

  @override
  Bell clone() {
    return Bell.protectedCreating(
        _running, _interval, _threeCashedIntervals, _nextNotificationOn);
  }

// ==========================================UTILS METHODS ================================================================

  @override
  String humanLikeDuration(Duration duration) {
    assert(duration.inMinutes > 0);
    int totalHours = duration.inHours;
    int minutesLeft = duration.inMinutes - (totalHours * 60);
    String strHours = "";
    String strMinutes = "";
    switch (totalHours) {
      case 0:
        strMinutes = "";
        break;
      case 1:
        strMinutes = "$minutesLeft Hour";
        break;
      default:
        strMinutes = "$minutesLeft Hours";
    }

    switch (minutesLeft) {
      case 0:
        strMinutes = "";
        break;
      case 1:
        strMinutes = "$minutesLeft Minute";
        break;
      default:
        strMinutes = "$minutesLeft Minutes";
    }
    return "$strHours $strMinutes";
  }

// =========================================================JSON METHODS==================================================

  @override
  String toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'running': _running,
      'intervalInSeconds': _interval.inSeconds,
      'nextNotificationOn':
          _nextNotificationOn != null ? _nextNotificationOn!.toString() : null,
      'threeCashedIntervalsInSeconds': _threeCashedIntervals.toListOfSeconds()
    };
    return jsonEncode(map);
  }

  @override
  factory Bell.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    String? nextNotificationOn = map['nextNotificationOn'];
    return Bell.protectedCreating(
      map['running'],
      Duration(seconds: map['intervalInSeconds']),
      CashedIntervals.fromListOfSeconds(map['threeCashedIntervalsInSeconds']),
      nextNotificationOn != null ? 
      DateTime.parse(nextNotificationOn) 
      : null,
    );
  }

// ==========================================================IO METHODS=======================================================
  // not implement in this class!
  @override
  BaseBell saveToStorage() {
    throw UnimplementedError();
  }

  @override
  BaseBell loadFromStorage() {
    throw UnimplementedError();
  }

// ================================================BASE OVERRIDE METHODS======================================================
  @override
  String toString() {
    return "running: $_running, intervalInMilliseconds ${_interval.inMilliseconds} ${_threeCashedIntervals.toString()} ";
  }

  @override
  int get hashCode => toString().hashCode;

  @override
  bool operator ==(Object other) {
    return other is Bell && toString() == toString();
  }
}

mixin BellStorageManager {
  Bell loadBellFromStorage() {
    throw UnimplementedError();
  }

  Bell saveBellToStorage() {
    throw UnimplementedError();
  }
}
