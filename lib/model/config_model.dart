
class AppLocales {
  static String appName = "SimplestLucidBell";
}

class Config {
  static const String intervalTask = 'interval-task';
}



class BellConfig {
  static const double bellMinutesLowerBound = 15;
  static const double bellMinutesUpperBound = 180;
  static const List<Duration> cashedIntervals = [
    Duration(minutes: 15),
    Duration(minutes: 30),
    Duration(minutes: 60)
  ];
  static const int maxCashedIntervals = 3;
  static const String humanLikeDurationFormat = "hh:mm:ss";
}
