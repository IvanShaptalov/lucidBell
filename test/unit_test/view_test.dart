import 'package:flutter_lucid_bell/view/view.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Bell info', () {
    test('convert seconds correct', () {
      expect(View.formatLeftSeconds(30), '30');

      expect(View.formatLeftSeconds(59), '59');
      expect(View.formatLeftSeconds(120), '02:00');
      expect(View.formatLeftSeconds(3600), '01:00:00');
      expect(View.formatLeftSeconds(3660), '01:01:00');
    });

    test('human like duration', () {
      expect(View.humanLikeDuration(const Duration(minutes: 30)), '30 minutes');
      expect(View.humanLikeDuration(const Duration(minutes: 60)), '1 hour');
      expect(View.humanLikeDuration(const Duration(minutes: 120)), '2 hours');
      expect(View.humanLikeDuration(const Duration(minutes: 125)), '2 hours 5 minutes');
      expect(View.humanLikeDuration(const Duration(minutes: 121)), '2 hours 1 minute');
      expect(View.humanLikeDuration(const Duration(minutes: 0)), '');
      expect(View.humanLikeDuration(const Duration(minutes: -1)), '-1 minutes');
    });
    test('human like duration short labels', () {
      expect(View.humanLikeDuration(const Duration(minutes: 30), shortLabel: true), '30 min');
      expect(View.humanLikeDuration(const Duration(minutes: 60), shortLabel: true), '1 h');
      expect(View.humanLikeDuration(const Duration(minutes: 120), shortLabel: true), '2 h');
      expect(View.humanLikeDuration(const Duration(minutes: 125), shortLabel: true), '2 h 5 min');
      expect(View.humanLikeDuration(const Duration(minutes: 121), shortLabel: true), '2 h 1 min');
      expect(View.humanLikeDuration(const Duration(minutes: 0), shortLabel: true), '');
      expect(View.humanLikeDuration(const Duration(minutes: -1), shortLabel: true), '-1 min');
    });
  });
}
