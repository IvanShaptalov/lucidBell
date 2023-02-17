import 'package:flutter/material.dart';

class AppLocales {
  static String appName = "SimplestLucidBell";
}

class Config {
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
