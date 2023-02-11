import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/bell/local_path_provider.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';

import 'app.dart';

class InitServices {
  static CustomNotificationService notificationService = CustomNotificationService();
  static Bell bell = Bell(running: false, interval: 5, startEveryHour: false);

  static Future<void> init() async {
    await notificationService.init();
    await LocalPathProvider.init();
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // init services
  InitServices.init();
  runApp(const MyApp());
}
