import 'dart:io';

import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();

  group('IO', () {
    testWidgets(
        'document directory exists, and application directory created, path exists',
        (tester) async {
      await LocalPathProvider.initAsync();
      expect(await Directory(LocalPathProvider.appDocPath!).exists(), true);
    });

    testWidgets('cash file created. path exists', (tester) async {
      await LocalPathProvider.initAsync();
      expect(await File(LocalPathProvider.cashLocalPath!).exists(), true);
    });

    testWidgets('cash log created, path exists', (tester) async {
      await LocalPathProvider.initAsync();
      expect(await File(LocalPathProvider.logPath!).exists(), true);
    });
  });
}
