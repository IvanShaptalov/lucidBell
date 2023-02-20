import 'package:flutter/material.dart';

class SizeConfig {
  static double getMediaHeight(context) {
    return MediaQuery.of(context).size.height;
  }

  static double getMediaWidth(context) {
    return MediaQuery.of(context).size.width;
  }
}