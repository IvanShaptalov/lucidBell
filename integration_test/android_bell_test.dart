import 'package:flutter_lucid_bell/model/config_model.dart';
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/notifications/notification_service.dart';
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
            AndroidBell.mockBellWithoutBackground().getNextNotificationOn() !=
                null,
            true));

    test(
        'bell cashed notification length always is ${BellConfig.maxCashedIntervals}',
        () {
      AndroidBell bell = AndroidBell.mockBellWithoutBackground();
      expect(
          bell.getThreeCashedIntervals.length == BellConfig.maxCashedIntervals,
          true);
    });

    test('notification cleared after bell stops', () {
      AndroidBell bell = AndroidBell.mockBellWithoutBackground();
      bell.setRunning(false);
      expect(bell.getNextNotificationOn() == null, true);
    });

    test('new cashed interval test', () {
      AndroidBell bell = AndroidBell.mockBellWithoutBackground();
      bell.setInterval(const Duration(hours: 2));
      expect(bell.getThreeCashedIntervals.peek, const Duration(hours: 2));
    });

    test('bell clone test', () {
      AndroidBell bell = AndroidBell.mockBellWithoutBackground();
      AndroidBell newBell = bell.clone();
      expect(bell.hashCode == newBell.hashCode, true);
    });

    test('bell to json and from json ', () {
      AndroidBell bell = AndroidBell.mockBellWithoutBackground();
      String jsonBell = bell.toJson();
      AndroidBell newBell = AndroidBell.fromJson(jsonBell);

      expect(bell.hashCode, newBell.hashCode);
    });

    test('bell to json and from json without nextNotification', () {
      AndroidBell bell = AndroidBell.mockBellWithoutBackground();
      // just for test
      // ignore: invalid_use_of_protected_member
      bell.clearNextNotificationTime();
      String jsonBell = bell.toJson();
      AndroidBell newBell = AndroidBell.fromJson(jsonBell);

      expect(bell.hashCode, newBell.hashCode);
    });

    test('bell IO save load', () async {
      AndroidBell bell = AndroidBell.mockBellWithoutBackground();
      bell.setInterval(const Duration(minutes: 45)); // set bell not mock
      await LocalPathProvider.initAsync();
      // just for test
      // ignore: invalid_use_of_protected_member
      expect(await bell.saveToStorageAsync(), true);

      AndroidBell newBell = await AndroidBell.loadFromStorage();

      expect(bell.hashCode, newBell.hashCode);
    });

    test('bell IO load from empty file', () async {
      await app.main();
      await AndroidBell.initServicesAsync();

      await LocalPathProvider.saveFile("");

      AndroidBell newBell = await AndroidBell.loadFromStorage();

      expect(newBell.hashCode, AndroidBell.mockBell().hashCode);
    });

    test('bell IO load mock without background work', () async {
      await app.main();
      await AndroidBell.initServicesAsync();

      await LocalPathProvider.saveFile("");

      await AndroidBell.loadFromStorage(disabledBackgroundWork: true);

      expect(await CustomNotificationService.isNotificationSent(),
          true); // exception throwed
    });

    test('bell services INITSERVICES',
        () async => expect(await AndroidBell.initServicesAsync(), true));

    test('bell cancel notification', () async {
      await app.main();
      await AndroidBell.initServicesAsync();
      var bell = AndroidBell.mockBell();

      bell.sendNotification('reminder', 'reminder');

      expect(await CustomNotificationService.isNotificationSent(), false);

      await bell.cancelIntervalTask();

      expect(await CustomNotificationService.isNotificationSent(),
          true); // exception throwed
    });
  });
}


    // AndroidBell bell = await AndroidBell.loadFromStorage(disabledBackgroundWork: true);
