import 'package:flutter_lucid_bell/model/bell/reminder_text.dart';
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_reminder_text.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();
  group('ANDROID reminderText', () {
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
            PreloadedReminderTexts.breathingText) // set reminderText not mock
        ..setReminderText(
            PreloadedReminderTexts.meditationText) // set reminderText not mock
        ..setReminderText(PreloadedReminderTexts.customTextEnum,
            customText: "oaoaoaoao");
      String jsonreminderText = reminderText.toJson();
      AndroidReminderText newreminderText =
          AndroidReminderText.fromJson(jsonreminderText);

      expect(reminderText.hashCode, newreminderText.hashCode);
    });

    test('reminderText IO save load', () async {
      AndroidReminderText reminderText = AndroidReminderText()
        ..setReminderText(
            PreloadedReminderTexts.breathingText) // set reminderText not mock
        ..setReminderText(
            PreloadedReminderTexts.meditationText) // set reminderText not mock
        ..setReminderText(PreloadedReminderTexts.customTextEnum,
            customText: "oaoaoaoao"); // set reminderText not mock
            
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
  });
}
