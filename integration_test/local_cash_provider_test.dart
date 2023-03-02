import 'dart:io';

import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  group('IO', () {
    testWidgets('files created', (tester) async {
      await LocalManager.initAsync();

      expect(await File(LocalManager.logFilePath!).exists(), true);
      expect(await File(LocalManager.localBellFilePath!).exists(), true);
      expect(await File(LocalManager.reminderTextFilePath!).exists(), true);
      expect(
          await File(LocalManager.onStartApplicationFilePath!).exists(), true);
    });

    testWidgets('directories created', (tester) async {
      await LocalManager.initAsync();
      expect(await Directory(LocalManager.logDirectoryPath).exists(), true);
      expect(await Directory(LocalManager.localBellDirectoryPath).exists(), true);
      expect(await Directory(LocalManager.reminderTextDirectoryPath).exists(), true);
      expect(await Directory(LocalManager.onStartApplicationDirectoryPath).exists(),
          true);
    });
  });
}
