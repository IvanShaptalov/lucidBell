class Bell {
  bool running;
  int interval;
  bool startEveryHour;

  void switchRun(value) {
    running = value;
    print('running changed to: $running');
  }

  void switchStartEveryHour(value) {
    startEveryHour = value;
    print('every hour changed to: $running');
  }

  Bell(
      {required this.running,
      required this.interval,
      required this.startEveryHour});

  // Bell loadLocalSettings() async {
  //   return
  // }

}
