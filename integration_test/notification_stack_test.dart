import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';

import 'package:flutter_lucid_bell/main.dart' as app;

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  app.main();
  testWidgets('notification added and saved in cash', (tester) async {
    await tester.pumpAndSettle();
    //MOCK BELL
    InitServices.bell.running = true;
    InitServices.bell.setInterval = const Duration(minutes: 1);

    await tester.pumpAndSettle(const Duration(seconds: 5));
    // EXPECT THAT STACK NOT EMPTY
    expect(InitServices.bell.notificationStack.length == 1, true);

    // EXPECT THAT CASHED BELL SAVED AND TWO BELLS IS THE SAME
    var bellJson = await LocalPathProvider.getBellJsonAsync();
    await tester.pumpAndSettle(const Duration(seconds: 2));

    var cashedBell = Bell.fromJson(bellJson!);

    // NOTIFICATION SAVED
    expect(cashedBell.notificationStack.length == 1, true);
    //
    expect(cashedBell == InitServices.bell, true);
  });
}
