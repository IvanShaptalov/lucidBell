import 'package:flutter/material.dart';

class AppLocales {
  static String appName = "SimplestLucidBell";
}

class Config {
  static String bellPath = 'assets/sound/chill_bell.mp3';
  static const String oneHourNotificationTask = 'one-hour-notification';
  static const String oneHourPeriodicTask = 'one-hour-periodic-task';
  static const String intervalTask = 'interval-task';
}

class SizeConfig {
  static double getMediaHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static double getMediaWidth(context) {
    return MediaQuery.of(context).size.width;
  }
}
