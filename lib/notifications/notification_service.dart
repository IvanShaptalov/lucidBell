// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/config.dart';
import 'package:flutter_lucid_bell/main.dart';

class CustomNotificationService {
  List<DateTime> notificationStack = [];
  int currentId = 0;
  Random rand = Random();
  Future<void> init() async {
    //Initialization Settings for Android
  }
  //id to identify new notification
  void scheduleNotifications(Duration delayDuration, int id) async {
    try {
      // chack that notification is not changed, if changed: ignore;
      print("$currentId");
      currentId = id;
      print('current id $currentId id $id');

      print('delayed to $delayDuration');
      Future.delayed(delayDuration).then((value) async {
        if (currentId == id) {
          print('play');
          return await NotificationPlayer.playSound();
        }
        else{
          print('different ids ignore it');
        }
      });

      print('delayed and played');
    } catch (e) {
      // ignore: avoid_print
      print(e);
    }
  }

  Stream<Bell> bellListener() async* {
    print(
        'started listed inner bell {$InitServices.bell.hashcode},\n now : {$InitServices.bell.running}');
    //create shall copy
    Bell innerBell = Bell(
        interval: const Duration(days: 1),
        running: false,
        startEveryHour: false);
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      if (innerBell != InitServices.bell) {
        // UPDATE AND SAVE BELL
        innerBell = Bell.clone(InitServices.bell);
        await LocalPathProvider.saveBell(innerBell.toJson());
        print('bell saved ${innerBell.toJson()}');
        yield innerBell;
      }
    }
  }

  void clearNotifications() async {
    if (notificationStack.isNotEmpty) {
      notificationStack.clear();
    }
    //todo change notification flag
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
      // ADD SCHEDULE TO NOTIFICATION STACK and uniq id to notification
      if (notificationStack.isEmpty) {
        scheduleNotifications(duration, rand.nextInt(1000000));
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
  static Audio audio = Audio(Config.bellPath);

  static Future<void> playSound() async {
    await assetsAudioPlayer.open(audio);
    print('played****************************************8');
  }
}
