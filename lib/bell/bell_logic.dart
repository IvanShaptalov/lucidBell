import 'dart:convert';

import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:workmanager/workmanager.dart';

class Bell {
  bool running;
  late Duration _interval; // duration in minutes
  double intervalLowerBound = 15;
  double intervalUpperBound = 180;
  List notificationStack = [];

  // not bigger and lower of bounds
  // if you change interval, you clear next notification
  set setInterval(Duration duration) {
    assert(duration.inMinutes >= intervalLowerBound);
    assert(duration.inMinutes <= intervalUpperBound);
    _interval = duration;
    // clear notification to commit changes
  }

  Duration get getInterval {
    return _interval;
  }

  Future<void> clearNotifications() async {
    if (notificationStack.isNotEmpty) {
      notificationStack.clear();
    }
    await Workmanager().cancelAll();
    // await InitServices.notificationService.clearNotifications(); // not clear, because sending deleted 5 seconds before playing, not schedule notificaionts
    LocalPathProvider.saveBell(this);
    //todo change notification flag
  }

  @override
  String toString() {
    return "${super.toString()} $_interval $running $notificationStack";
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

  Bell(this.running, this.notificationStack, Duration interval) {
    this.setInterval = interval;
  }

  factory Bell.clone(Bell source) {
    return Bell(source.running, source.notificationStack, source.getInterval);
  }

  factory Bell.fromJson(String jsonString) {
    Map<String, dynamic> map = jsonDecode(jsonString);
    return Bell(
      map['running'],
      map['notificationStack'].map((jsonDatetime) {
        return DateTime.parse(jsonDatetime);
      }).toList(),
      Duration(seconds: map['interval']),
    );
  }

  String toJson() {
    Map<String, dynamic> map = <String, dynamic>{
      'running': running,
      'interval': _interval.inSeconds,
      'notificationStack': notificationStack.isNotEmpty
          ? notificationStack.map((datetime) {
              return datetime.toString();
            }).toList()
          : [],
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
