
import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_lucid_bell/main.dart' as app;
import 'package:syncfusion_flutter_sliders/sliders.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();
  group('integration tests init', () {
    testWidgets('mock bell not find slider', (tester) async {
      await tester.pumpAndSettle();
      InitServices.bell = InitServices.mockBell();
      InitServices.bell.running = true;
      InitServices.bell.startEveryHour = true;

      await tester.pumpAndSettle(const Duration(seconds: 3));
      // Trigger a frame.
      expect(find.byType(Switch), findsNWidgets(2));
      expect(find.byType(SfSlider), findsNothing);
    });
  });
}
