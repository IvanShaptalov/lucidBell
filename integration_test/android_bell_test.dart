import 'package:flutter_lucid_bell/model/config_model.dart';
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();
  group('ANDROID BELL', () {
    test(
        'bell initialized , nextNotification set',
        () => expect(
            AndroidBell.mockBell().getNextNotificationOn() != null, true));

    test(
        'bell has three cashed length always is ${BellConfig.maxCashedIntervals}',
        () {
      AndroidBell bell = AndroidBell.mockBell();
      expect(
          bell.getThreeCashedIntervals.length == BellConfig.maxCashedIntervals,
          true);
    });

    test('notification cleared after bell stops', () {
      AndroidBell bell = AndroidBell.mockBell();
      bell.setRunning(false);
      expect(bell.getNextNotificationOn() == null, true);
    });

    test('new cashed interval test', () {
      AndroidBell bell = AndroidBell.mockBell();
      bell.setInterval(const Duration(hours: 2));
      expect(bell.getThreeCashedIntervals.peek, const Duration(hours: 2));
    });

    test('bell clone test', () {
      AndroidBell bell = AndroidBell.mockBell();
      AndroidBell newBell = bell.clone();
      expect(bell.hashCode == newBell.hashCode, true);
    });

    test('bell to json and from json ', () {
      AndroidBell bell = AndroidBell.mockBell();
      String jsonBell = bell.toJson();
      AndroidBell newBell = AndroidBell.fromJson(jsonBell);

      expect(bell.hashCode, newBell.hashCode);
    });

    test('bell to json and from json without nextNotification', () {
      AndroidBell bell = AndroidBell.mockBell();
      // just for test
      // ignore: invalid_use_of_protected_member
      bell.clearNextNotificationTime();
      String jsonBell = bell.toJson();
      AndroidBell newBell = AndroidBell.fromJson(jsonBell);

      expect(bell.hashCode, newBell.hashCode);
    });

    test('bell IO save load', () async {
      AndroidBell bell = AndroidBell.mockBell();
      bell.setInterval(const Duration(minutes: 45)); // set bell not mock
      await LocalPathProvider.initAsync();
      // just for test
      // ignore: invalid_use_of_protected_member
      expect(await bell.saveToStorage(), true);

      AndroidBell newBell = await AndroidBell.loadFromStorage();

      expect(bell.hashCode, newBell.hashCode);
    });

    test('bell services INITSERVICES',
        () async => expect(await AndroidBell.initServices(), true));

    test('end-to-end all functionality test from mock', () async {
      // TODO test
      AndroidBell bell = AndroidBell.mockBell();
    });

    test('end-to-end all functionality test from cash', () async {
      // TODO test
      AndroidBell bell = await AndroidBell.loadFromStorage();
    });
  });
}
