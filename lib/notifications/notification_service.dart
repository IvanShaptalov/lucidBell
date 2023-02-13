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
        if (currentId == id && InitServices.bell.running) {
          print('play');

          // Clear notification stack
          notificationStack.clear();
          return await NotificationPlayer.playSound();

        } else {
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
      // YIELD IF NOTIFICATION STACK IS EMPTY
      if (InitServices.notificationService.notificationStack.isEmpty){
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

  /// select corresponding to start on every hour or using interval
  Duration _selectIntervalModeDuration(Bell innerBell) {
    Duration duration;
    if (innerBell.startEveryHour) {
      // IF START ON EVERY HOUR: ADD new schedule
      int minutesToAdd = 60 - DateTime.now().minute;
      duration = Duration(minutes: minutesToAdd);
    } else {
      duration = innerBell.interval;
    }

    return duration;
  }

  DateTime _convertDurationToDatetime(Duration duration) {
    return DateTime.now().add(duration);
  }

  void circleNotification(Bell innerBell, Function nextBellCallback) async {
    // NOTIFICATION STACK ALWAYS CONTAIN ONE OR NOT CONTAINS NOTIFICATIONS;
    assert(notificationStack.length <=
        1); 
    // NOTIFICATION SCHEDULING LOGIC HERE
    if (innerBell.running) {
      // SERVICE STARTED
      Duration duration = _selectIntervalModeDuration(innerBell);
      DateTime dt = _convertDurationToDatetime(duration);

      print('try add notification');
      // ADD SCHEDULE TO NOTIFICATION STACK and uniq id to notification
      if (notificationStack.isEmpty) {
        scheduleNotifications(duration, rand.nextInt(1000000));
        notificationStack.add(dt); // add notification to stack if scheduled
        print('next bell on $dt');
        // SET NEXTBELL ON TEXT
        nextBellCallback('next bell on $dt');
      }
      // IF SCHEDULE ALREADY EXIST DELETE IT WHEN TIME COME
      else {
        // CLEAR NOTIFICATIONS STACK
        print('***************notification played');
        clearNotifications();
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
