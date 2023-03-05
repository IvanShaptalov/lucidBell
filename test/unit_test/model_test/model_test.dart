import 'package:flutter_lucid_bell/model/bell/bell.dart';
import 'package:flutter_lucid_bell/model/bell/reminder_text.dart';
import 'package:flutter_lucid_bell/model/config_model.dart';
import 'package:flutter_lucid_bell/model/data_structures/data_structures.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('CashedNotifications', () {
    test('cashed notification work correct', () {
      var cashedNotifications = CashedIntervals();
      expect(cashedNotifications.length == BellConfig.maxCashedIntervals, true);
    });

    test('to list of seconds', () {
      var cashedNotifications = CashedIntervals();
      expect(cashedNotifications.length == BellConfig.maxCashedIntervals, true);
      List<int> listOfSeconds = cashedNotifications.toListOfSeconds();

      expect(listOfSeconds.length, BellConfig.maxCashedIntervals);
    });

    test('from list of seconds', () {
      var cashedNotifications = CashedIntervals();
      expect(cashedNotifications.length == BellConfig.maxCashedIntervals, true);
      List<int> listOfSeconds = cashedNotifications.toListOfSeconds();
      CashedIntervals newCashed =
          CashedIntervals.fromListOfSeconds(listOfSeconds);
      expect(newCashed == cashedNotifications, true);
    });

    test('bell has three cashed length always is 3, first is 25', () {
      var cashedNotifications = CashedIntervals();
      cashedNotifications.push(const Duration(minutes: 25));
      cashedNotifications.push(const Duration(minutes: 25));
      expect(cashedNotifications.length == BellConfig.maxCashedIntervals, true);
      expect(cashedNotifications.peek, const Duration(minutes: 25));
    });

    test('expect first in, last out, not in if not unique', () {
      var cashedNotifications = CashedIntervals();

      // check unique stability

      cashedNotifications.push(const Duration(minutes: 25));
      cashedNotifications.push(const Duration(minutes: 25));
      cashedNotifications.push(const Duration(minutes: 25));

      expect(cashedNotifications.length == BellConfig.maxCashedIntervals, true);
      expect(cashedNotifications.peek, const Duration(minutes: 25));

      expect(cashedNotifications.getByIndex(0), const Duration(minutes: 30));
      expect(cashedNotifications.getByIndex(1), const Duration(minutes: 60));

      // check updates

      cashedNotifications.push(const Duration(minutes: 1));
      cashedNotifications.push(const Duration(minutes: 2));
      cashedNotifications.push(const Duration(minutes: 3));

      expect(cashedNotifications.getByIndex(0), const Duration(minutes: 1));
      expect(cashedNotifications.getByIndex(1), const Duration(minutes: 2));
      expect(cashedNotifications.getByIndex(2), const Duration(minutes: 3));
    });
  });

  group('BASE BELL', () {
    test('bell initialized , nextNotification set',
        () => expect(Bell.mockBell().getNextNotificationOn() != null, true));

    test('bell has three cashed length always is 3', () {
      Bell bell = Bell.mockBell();
      expect(
          bell.getThreeCashedIntervals.length == BellConfig.maxCashedIntervals,
          true);
    });

    test('notification cleared after bell stops', () {
      Bell bell = Bell.mockBell();
      bell.setRunning(false);
      expect(bell.getNextNotificationOn() == null, true);
    });

    test('new cashed interval test', () {
      Bell bell = Bell.mockBell();
      bell.setInterval(const Duration(hours: 2));
      expect(bell.getThreeCashedIntervals.peek, const Duration(hours: 2));
    });

    test('bell clone test', () {
      Bell bell = Bell.mockBell();
      Bell newBell = bell.clone();
      expect(bell.hashCode == newBell.hashCode, true);
    });

    test('bell to json and from json ', () {
      Bell bell = Bell.mockBell();
      String jsonBell = bell.toJson();
      Bell newBell = Bell.fromJson(jsonBell);

      expect(bell.hashCode, newBell.hashCode);
    });

    test('bell to json and from json without nextNotification', () {
      Bell bell = Bell.mockBell();
      // just for test
      // ignore: invalid_use_of_protected_member
      bell.clearNextNotificationTime();
      String jsonBell = bell.toJson();
      Bell newBell = Bell.fromJson(jsonBell);

      expect(bell.hashCode, newBell.hashCode);
    });
  });

  group('Base Reminder text', () {
    test('Reminder text initialized from enum', () async {
      var rem = ReminderText();

      expect(rem.getReminderText, 'Not forget it');
    });

    test('Reminder text test history', () {
      var rem = ReminderText();
      rem.setReminderText(PreloadedReminderTexts.breathingText);
      var remEnum = PreloadedReminderTexts.breathingText;
      expect(rem.getReminderText, remEnum.getValue());

      expect(rem.getHistoryOfReminderTexsts.last, remEnum.getValue());

      rem.setReminderText(PreloadedReminderTexts.mueingText);
      expect(rem.getHistoryOfReminderTexsts.length, 2);

      rem.setReminderText(PreloadedReminderTexts.mueingText);
      expect(rem.getHistoryOfReminderTexsts.length, 2);

      rem.setReminderText(PreloadedReminderTexts.breathingText);
      expect(rem.getHistoryOfReminderTexsts.length, 2);

      expect(rem.getHistoryOfReminderTexsts.last, remEnum.getValue());

      rem.setReminderText(PreloadedReminderTexts.customTextEnum,
          customText: 'Custom text');

      expect(rem.getHistoryOfReminderTexsts.length, 3);

      expect(rem.getHistoryOfReminderTexsts.last, 'Custom text');

      rem.setReminderText(PreloadedReminderTexts.breathingText);

      expect(rem.getHistoryOfReminderTexsts.length, 3);

      expect(rem.getHistoryOfReminderTexsts.last, remEnum.getValue());
    });
  });
}
