import 'dart:io';

import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/background_implementation/background_implementation.dart';
import 'package:flutter_lucid_bell/presenter/android/notifications/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  group('IO', () {
    testWidgets('files created', (tester) async {
      await LocalManager.initAsync();

      expect(await File(LocalManager.logFilePath!).exists(), true);
      expect(await File(LocalManager.localBellFilePath!).exists(), true);
      expect(await File(LocalManager.reminderTextFilePath!).exists(), true);
      expect(
          await File(LocalManager.onStartApplicationFilePath!).exists(), true);
           expect(
          await File(LocalManager.themeFilePath!).exists(), true);
    });

    testWidgets('directories created', (tester) async {
      await LocalManager.initAsync();
      expect(await Directory(LocalManager.logDirectoryPath).exists(), true);
      expect(await Directory(LocalManager.localBellDirectoryPath).exists(), true);
      expect(await Directory(LocalManager.reminderTextDirectoryPath).exists(), true);
      expect(await Directory(LocalManager.onStartApplicationDirectoryPath).exists(),
          true);
    });
  });

  group('background service initialized', () {
    testWidgets('background initialized', (tester) async {
      await AndroidBell.initServicesAsync();
      await app.main();

      expect(AndroidBellBackgroundManager.initialized, true);
    });
    testWidgets('back task sent', (tester) async {
      await AndroidBell.initServicesAsync();
      AndroidBell bell = AndroidBell.mockBellWithoutBackground();
      
      expect(await bell.registerIntervalTask(), true);
    });
  });

  group('custom notification service initialized', () {
    testWidgets('notification initialized', (tester) async {
      await app.main();
      // ignore: unused_local_variable
      AndroidBell bell = AndroidBell.mockBell();
      await AndroidBell.initServicesAsync();

      expect(CustomNotificationService.initSettings != null, true);
      expect(CustomNotificationService.androidSetting != null, true);
    });
    testWidgets('notification sent', (tester) async {
      await app.main();
      AndroidBell bell = AndroidBell.mockBell();
      await AndroidBell.initServicesAsync();
      bool result =
          await bell.sendNotification('reminder', 'reminder');
      expect(result, true);
    });
  });
}
