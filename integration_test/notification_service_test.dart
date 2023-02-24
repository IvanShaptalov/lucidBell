
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
