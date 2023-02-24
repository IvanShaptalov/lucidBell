import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/background_implementation/background_implementation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

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
}
