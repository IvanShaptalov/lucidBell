import 'package:flutter_lucid_bell/constant.dart';
import 'package:flutter_lucid_bell/model/config_model.dart';
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/android_reminder_text.dart';
import 'package:flutter_lucid_bell/presenter/android/notifications/notification_service.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:flutter_lucid_bell/view/view.dart';
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
      await LocalManager.initAsync();
      // just for test
      // ignore: invalid_use_of_protected_member
      expect(await bell.saveToStorageAsync(), true);

      AndroidBell newBell = await AndroidBell.loadFromStorage();

      expect(bell.hashCode, newBell.hashCode);
    });

    test('bell IO load from empty file', () async {
      await app.main();
      await AndroidBell.initServicesAsync();

      await LocalManager.writeToFile(LocalManager.localBellFilePath!, "");

      AndroidBell newBell = await AndroidBell.loadFromStorage();

      expect(newBell.hashCode, AndroidBell.mockBell().hashCode);
    });

    test('bell IO load from broken json file', () async {
      await app.main();
      await AndroidBell.initServicesAsync();

      await LocalManager.writeToFile(
          LocalManager.localBellFilePath!, "json broken file");

      AndroidBell newBell = await AndroidBell.loadFromStorage();

      expect(newBell.hashCode, AndroidBell.mockBell().hashCode);
    });

    test('bell IO load mock without background work', () async {
      await app.main();
      await AndroidBell.initServicesAsync();

      await LocalManager.writeToFile(LocalManager.localBellFilePath!, "");

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

      bell.sendNotification('reminder', 'reminder', defaultReminder);

      expect(await CustomNotificationService.isNotificationSent(), false);

      await bell.cancelIntervalTask();

      expect(await CustomNotificationService.isNotificationSent(),
          true); // exception throwed
    });
  });

  group('ANDROID reminderText', () {
    test('initialized', () async {
      await Presenter.initAsync();
      expect(PresenterTextReminder.reminderText != null, true);
    });
    test('empty reminderText to json and from json ', () {
      AndroidReminderText reminderText = AndroidReminderText();
      String jsonreminderText = reminderText.toJson();
      AndroidReminderText newreminderText =
          AndroidReminderText.fromJson(jsonreminderText);

      expect(reminderText.hashCode, newreminderText.hashCode);
    });

    test('full reminderText to json and from json ', () {
      AndroidReminderText reminderText = AndroidReminderText()
        ..setReminderText(
            'PreloadedReminderTexts.breathingText') // set reminderText not mock
        ..setReminderText(
            'PreloadedReminderTexts.meditationText') // set reminderText not mock
        ..setReminderText("oaoaoaoao");
      String jsonreminderText = reminderText.toJson();
      AndroidReminderText newreminderText =
          AndroidReminderText.fromJson(jsonreminderText);

      expect(reminderText.hashCode, newreminderText.hashCode);
    });

    test('reminderText IO save load', () async {
      AndroidReminderText reminderText = AndroidReminderText()
        ..setReminderText(
            'PreloadedReminderTexts.breathingText') // set reminderText not mock
        ..setReminderText(
            'PreloadedReminderTexts.meditationText') // set reminderText not mock
        ..setReminderText(
            'PreloadedReminderTexts.customTextEnum'); // set reminderText not mock

      await LocalManager.initAsync();
      // just for test
      // ignore: invalid_use_of_protected_member
      expect(await reminderText.saveToStorageAsync(), true);

      AndroidReminderText newreminderText =
          await AndroidReminderText.loadFromStorageAsync();

      expect(reminderText.hashCode, newreminderText.hashCode);
    });

    test('reminderText IO load from empty file', () async {
      await app.main();

      await LocalManager.writeToFile(LocalManager.reminderTextFilePath!, "");

      AndroidReminderText newreminderText =
          await AndroidReminderText.loadFromStorageAsync();

      expect(newreminderText.hashCode, AndroidReminderText().hashCode);
    });

    test('reminderText IO load from broken file', () async {
      await app.main();

      await LocalManager.writeToFile(
          LocalManager.reminderTextFilePath!, "broken json file");

      AndroidReminderText newreminderText =
          await AndroidReminderText.loadFromStorageAsync();

      expect(newreminderText.hashCode, AndroidReminderText().hashCode);
    });

    group('THEME', () {
      test('initialized', () async {
        expect(await View.initAsync(), true);
      });

      test('theme loaded from storage', () async {
        await View.initAsync();
        View.currentTheme = CustomTheme.selectTheme(theme: Themes.green);
        await View.currentTheme.saveToStorageAsync(View.currentTheme.themeEnum);
        View.currentTheme = CustomTheme.selectTheme(theme: Themes.grey);
        await View.initAsync();

        expect(View.currentTheme.themeEnum, Themes.green);
      });

      test('set default theme', () async {
        await LocalManager.initAsync();

        await LocalManager.writeToFile(LocalManager.themeFilePath!, "oaoaoa");

        await View.initAsync();

        expect(View.currentTheme, CustomTheme.blueDefault());
      });
    });
  });
}
