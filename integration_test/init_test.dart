import 'dart:io';

import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  group('integration tests init', () {
    testWidgets('initialization cash', (tester) async {
      expect(await Directory(LocalPathProvider.appDocPath!).exists(), true);
      expect(await File(LocalPathProvider.cashLocalPath!).exists(), true);
    });

    testWidgets('initialization bell', (tester) async {
      // BELL
      // ignore: unnecessary_null_comparison
      expect(InitServices.bell != null, true);
      expect(InitServices.bellListenerSub != null, true);
    });

    testWidgets('initialization notificaton', (tester) async {
      // NOTIFICATION SERVICE
      // ignore: unnecessary_null_comparison
      expect(InitServices.notificationService != null, true);
      // ignore: unnecessary_null_comparison
      expect(InitServices.bell.notificationStack!= null, true);
    });

    testWidgets('initialization listener', (tester) async {
      // LISTENER
      expect(InitServices.bellListenerSub!.isPaused, false);
    });
  });
}
