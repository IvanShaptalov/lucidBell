import 'dart:convert';

import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:workmanager/workmanager.dart';

class Bell {
  bool running;
  Duration interval; // duration in minutes
  double intervalLowerBound = 15;
  double intervalUpperBound = 180;
  bool startEveryHour;
  List notificationStack = [];

  Future<void> clearNotifications() async {
    if (notificationStack.isNotEmpty) {
      notificationStack.clear();
    }
    await Workmanager().cancelAll();
    await InitServices.notificationService.clearNotifications();
    //todo change notification flag
  }

  @override
  String toString() {
    return "${super.toString()} $interval $startEveryHour $running $notificationStack";
  }

  @override
  bool operator ==(other) => other is Bell && toString() == other.toString();

  @override
  int get hashCode => toString().hashCode;

  String convertFromMinutesToH(Duration bellInterval) {
    int totalHours = bellInterval.inHours;
    int minutesLeft = bellInterval.inMinutes - (totalHours * 60);

    if (totalHours == 0) {
      return '$minutesLeft Minutes';
    } else if (minutesLeft == 0) {
      return '$totalHours Hours';
    } else {
      return '$totalHours Hours $minutesLeft Minutes';
    }
  }

  void switchRun(value) {
    running = value;
    print('running changed to: $running');
  }

  void switchStartEveryHour(value) {
    startEveryHour = value;
    print('every hour changed to: $value');
  }

  Bell(
      {required this.running,
      required this.interval,
      required this.startEveryHour,
      required this.notificationStack});

  factory Bell.clone(Bell source) {
    return Bell(
        running: source.running,
        interval: source.interval,
        startEveryHour: source.startEveryHour,
        notificationStack: source.notificationStack);
  }

  factory Bell.fromJson(String jsonString) {
    Map<String, dynamic> map = jsonDecode(jsonString);
    return Bell(
        running: map['running'],
        interval: Duration(seconds: map['interval']),
        startEveryHour: map['startEveryHour'],
        notificationStack: map['notificationStack'].map((jsonDatetime) {
          return DateTime.parse(jsonDatetime);
        }).toList());
  }

  String toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'running': running,
      'interval': interval.inSeconds,
      'startEveryHour': startEveryHour,
      'notificationStack': notificationStack.map((datetime) {
        return datetime.toString();
      }).toList(),
    };
    return jsonEncode(map);
  }

  static Future<Bell?> loadLocalSettings() async {
    try {
      Bell bell;
      var jsonBell = await LocalPathProvider.getBellJsonAsync();
      if (jsonBell is String) {
        bell = Bell.fromJson(jsonBell);
        return bell;
      }
      return null; // return null if bell not exists
    } catch (e) {
      print(e);
      return null; //same
    }
  }
}
