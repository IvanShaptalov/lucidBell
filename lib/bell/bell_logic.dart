class Bell {
  bool running;
  Duration interval; // duration in minutes
  double intervalLowerBound = 1;
  double intervalUpperBound = 180;
  bool startEveryHour;
  Duration? nextBellOn;

  String convertFromMinutesToH(Duration bellInterval) {
    int totalHours = bellInterval.inHours;
    int minutesLeft = bellInterval.inMinutes - (totalHours * 60);

    if (totalHours == 0) {
      return '$minutesLeft Minute';
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

  // Bell loadLocalSettings() async {
  //   return
  // }

}
