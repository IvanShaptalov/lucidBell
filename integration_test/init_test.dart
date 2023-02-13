import 'dart:io';

import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:flutter_lucid_bell/notifications/notification_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('initialization notifications, listener, bell', (tester) async {
    app.main();
    await tester.pumpAndSettle();

    expect(await Directory(LocalPathProvider.appDocPath!).exists(), true);
    expect(await File(LocalPathProvider.cashLocalPath!).exists(), true);

    // LISTENER
    expect(InitServices.bellListenerSub!.isPaused, false);

    // NOTIFICATION SERVICE
    expect(InitServices.notificationService != null, true);
    expect(InitServices.notificationService.notificationStack != null, true);

    // BELL
    expect(InitServices.bell != null, true);
    expect(InitServices.bellListenerSub != null, true);
  });
}
