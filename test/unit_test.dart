import 'dart:io';
import 'package:flutter_lucid_bell/background_processes/local_path_provider.dart';
import 'package:flutter_lucid_bell/bell/bell_logic.dart';
import 'package:flutter_lucid_bell/main.dart';
import 'package:flutter_test/flutter_test.dart';
// ignore: depend_on_referenced_packages

void main() {
  group('IO', () {
    test(
        'document directory exists, and application directory created, path exists',
        () async {
      // test check that music real loading from path, expect string
      await LocalPathProvider.init();
      expect(await Directory(LocalPathProvider.appDocPath!).exists(), true);
    });

    test('cash file created. path exists', () async {
      // test check that music real loading from path, expect string
      await LocalPathProvider.init();
      expect(await File(LocalPathProvider.cashLocalPath!).exists(), true);
    });

    test('cash log created. path exists', () async {
      // test check that music real loading from path, expect string
      await LocalPathProvider.init();
      expect(await File(LocalPathProvider.logPath!).exists(), true);
    });

    test('test bell serialize', () async {
      // test check that music real loading from path, expect string
      Bell bell = InitServices.mockBell();

      var jsonBell = bell.toJson();

      Bell newBell = Bell.fromJson(jsonBell);

      expect(bell.getInterval.compareTo(newBell.getInterval), 0);

      expect(bell.running == newBell.running, true);

      expect(bell == newBell, true);
    });

    test('test bell saving in file', () async {
      await LocalPathProvider.init();
      // test check that music real loading from path, expect string
      Bell bell = InitServices.mockBell();

      //SAVE TO FILE
      LocalPathProvider.saveBell(bell);

      //LOAD BELL FROM FILE
      //EXPECTED TO BE NULL
      Bell newBell = (await Bell.loadLocalSettings())!;
      // ignore: unnecessary_null_comparison
      expect(newBell != null, true);

      //CHECK IDENTITY
      expect(bell.getInterval.compareTo(newBell.getInterval), 0);

      expect(bell.running == newBell.running, true);

      expect(bell == newBell, true);
    });

    test('test empty notification bell saving in file', () async {
      await LocalPathProvider.init();
      // test check that music real loading from path, expect string
      Bell bell = InitServices.mockBell();
      bell.setInterval = const Duration(hours: 2);
      bell.notificationStack = [DateTime.now().add(const Duration(hours: 4))];
      //SAVE TO FILE
      LocalPathProvider.saveBell(bell);

      //LOAD BELL FROM FILE
      //EXPECTED TO BE NULL
      Bell newBell = (await Bell.loadLocalSettings())!;
      // ignore: unnecessary_null_comparison
      expect(newBell != null, true);

      //CHECK IDENTITY
      expect(bell.getInterval.compareTo(newBell.getInterval), 0);

      expect(bell.running == newBell.running, true);

      expect(bell == newBell, true);
    });
  });
}
