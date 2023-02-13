// ignore_for_file: depend_on_referenced_packages

import 'dart:math';

import 'package:assets_audio_player/assets_audio_player.dart';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/config.dart';
import 'package:flutter_lucid_bell/main.dart';

class CustomNotificationService {
  int currentId = 0;
  Random rand = Random();
  bool _notificationCashedFlag = false;
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
          InitServices.bell.notificationStack.clear();
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
        startEveryHour: false,
        notificationStack: []);
    while (true) {
      await Future.delayed(const Duration(seconds: 1));
      if (innerBell != InitServices.bell) {
        // UPDATE AND SAVE BELL
        innerBell = Bell.clone(InitServices.bell);
        print('bell saved ${innerBell.toJson()}');
        await LocalPathProvider.saveBell(innerBell.toJson());

        yield innerBell;
      }
      // YIELD IF NOTIFICATION STACK IS EMPTY
      if (InitServices.bell.notificationStack.isEmpty) {
        yield innerBell;
      }
    }
  }

  Future<bool> isNotificationsShowed() async {
    return Future.value(true);
  }

  /// select corresponding to start on every hour or using interval
  Duration _selectIntervalModeDuration(Bell innerBell) {
    Duration duration;

    // if notification stack not empty and date not expired, calculate time to it
    if (innerBell.notificationStack.isNotEmpty) {
      DateTime cashedNotification = innerBell.notificationStack.first;
      // not empty and not expired
      if (cashedNotification.isAfter(DateTime.now())) {
        print('cashed notification is not expired');
        // assert, cashed must not be EXPIRED
        assert(cashedNotification.isAfter(DateTime.now()));
        duration = cashedNotification.difference(DateTime.now());
        //set flag that notification come from cash
        _notificationCashedFlag = true;
        return duration;
      }
    }
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
    assert(InitServices.bell.notificationStack.length <= 1);

    // NOTIFICATION SCHEDULING LOGIC HERE
    if (innerBell.running) {
      // SERVICE STARTED
      // ADD CONDITION IF NOTIFICATION EXISTS IN STACK, ADD CUSTOM DURATION
      Duration duration = _selectIntervalModeDuration(innerBell);
      DateTime dt = _convertDurationToDatetime(duration);

      print('try add notification');

      // ADD SCHEDULE TO NOTIFICATION STACK and uniq id to notification if
      // Stack empty or notification flag
      if (InitServices.bell.notificationStack.isEmpty ||
          (InitServices.bell.notificationStack.isNotEmpty &&
              _notificationCashedFlag)) {
        // assert, duration MUST BE POSITIVE ;p
        assert(!duration.isNegative);
        scheduleNotifications(duration, rand.nextInt(1000000));

        // if notification cashed, we don't update it
        if (!_notificationCashedFlag) {
          InitServices.bell.notificationStack.add(dt);
          print('bell saved ${innerBell.toJson()}');
          await LocalPathProvider.saveBell(innerBell.toJson());
        }

        // add notification to stack if scheduled
        print('next bell on $dt');
        // SET NEXTBELL ON TEXT
        nextBellCallback('next bell on $dt');
      }
      // IF SCHEDULE ALREADY EXIST DELETE IT WHEN TIME COME
      else {
        // CLEAR NOTIFICATIONS STACK
        print('***************notification played');
        InitServices.bell.clearNotifications();
      }
    } else {
      InitServices.bell.clearNotifications();
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
