import 'dart:convert';

import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';

class Bell {
  bool running;
  Duration interval; // duration in minutes
  double intervalLowerBound = 1;
  double intervalUpperBound = 180;
  bool startEveryHour;
  Duration? nextBellOn;

  @override
  String toString() {
    // TODO: implement toString
    return "${super.toString()} $interval $startEveryHour ${nextBellOn.toString()}";
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
      required this.startEveryHour});

  factory Bell.clone(Bell source) {
    return Bell(
        running: source.running,
        interval: source.interval,
        startEveryHour: source.startEveryHour);
  }

  factory Bell.fromJson(String json) {
    Map<String, dynamic> map = jsonDecode(json);
    return Bell(
        running: map['running'],
        interval: Duration(seconds: map['interval']),
        startEveryHour: map['startEveryHour']);
  }

  String toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'running': running,
      'interval': interval.inSeconds,
      'startEveryHour': startEveryHour
    };
    return jsonEncode(map);
  }

  static Future<Bell?> loadLocalSettings() async {
    try {
      Bell bell;
      var jsonBell = await LocalPathProvider.getBellJson();
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
