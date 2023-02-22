import 'dart:io';

import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/notifications/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  group('custom notification service initialized', () {
    testWidgets('notification initialized', (tester) async {
      AndroidBell bell = AndroidBell.mockBell();
      await AndroidBell.initServices();

      expect(CustomNotificationService.initSettings != null, true);
      expect(CustomNotificationService.androidSetting != null, true);
    });
    testWidgets('notification sent', (tester) async {
      AndroidBell bell = AndroidBell.mockBell();
      await AndroidBell.initServices();
      bool result =
          await bell.sendNotification('test notification', 'test notification');
      expect(result, true);
    });
  });
}
