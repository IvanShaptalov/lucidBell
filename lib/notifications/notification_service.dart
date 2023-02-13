// ignore_for_file: depend_on_referenced_packages

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/config.dart';

class CustomNotificationService {
  List<DateTime> notificationStack = [];

  Future<void> init() async {
    //Initialization Settings for Android
  }

  void scheduleNotifications(Duration delayDuration) async {
    try {
      print('delayed to $delayDuration');
      Future.delayed(delayDuration).then((value) async=> await NotificationPlayer.playSound());
      
      print('delayed and played');
      
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Stream<Bell> bellListener(Bell bell) async* {
    print(
        'started listed inner bell {$bell.hashcode},\n now : {$bell.running}');
    //create shall copy
    Bell innerBell = Bell(
        interval: const Duration(days: 1),
        running: false,
        startEveryHour: false);
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      if (innerBell != bell) {
        // UPDATE AND SAVE BELL
        Bell innerBell = Bell.clone(bell);

        LocalPathProvider.saveBell(bell.toJson());
        yield innerBell;
      }
    }
  }

  void clearNotifications() async {
    if(notificationStack.isNotEmpty){
      notificationStack.clear();
    }
  }

  Future<bool> isNotificationsShowed() async {
    return Future.value(true);
  }

  void circleNotification(Bell innerBell, Function nextBellCallback) async {
    assert(notificationStack.length <=
        1); // notification stack always contain one or not contains notifications;
    // NOTIFICATION SCHEDULING LOGIC HERE
    if (innerBell.running) {
      // SERVICE STARTED
      Duration duration;
      DateTime dt;
      if (innerBell.startEveryHour) {
        // IF START ON EVERY HOUR: ADD new schedule
        int minutesToAdd = 60 - DateTime.now().minute;
        duration = Duration(minutes: minutesToAdd);
      } else {
        duration = innerBell.interval;
      }
      print(notificationStack.length);
      print(notificationStack);
      dt = DateTime.now().add(duration);
      // ADD SCHEDULE TO NOTIFICATION STACK
      if (notificationStack.isEmpty) {
        scheduleNotifications(duration);
        notificationStack.add(dt); // add notification to stack if scheduled
        print('next bell on $dt');
        nextBellCallback('next bell on $dt');
      }
      // IF SCHEDULE ALREADY EXIST DELETE IT WHEN TIME COME
      else {
        var notificationDate = notificationStack.first;
        // CLEAR NOTIFICATIONS STACK
        if (DateTime.now()
            .isAfter(notificationDate.add(Duration(seconds: 15)))) {
          print('***************notification played');
          clearNotifications();
        }
      }
    } else {
      clearNotifications();
    }
  }
}

class NotificationPlayer {
  static final assetsAudioPlayer = AssetsAudioPlayer();

  static Future<void> playSound() async{
    await assetsAudioPlayer.open(Audio(Config.bellPath));
  }
}
