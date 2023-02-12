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

     test('bell initialized', () async {
      // test check that music real loading from path, expect string
      await InitServices.initCashThenBell();
      expect(await File(LocalPathProvider.cashLocalPath!).exists(), true);
      expect(InitServices.bell is Bell, true);

    });

    

    test('test bell serialize', () async {
      // test check that music real loading from path, expect string
      Bell bell = Bell(
          running: true, interval: Duration(hours: 1), startEveryHour: false);

      var jsonBell = bell.toJson();

      Bell newBell = Bell.fromJson(jsonBell);

      expect(bell.interval.compareTo(newBell.interval), 0);

      expect(bell.running == newBell.running, true);

      expect(bell.startEveryHour == newBell.startEveryHour, true);

      expect(bell == newBell, true);
    });

    test('test bell saving in file', () async {

      await LocalPathProvider.init();
      // test check that music real loading from path, expect string
      Bell bell = Bell(
          running: true, interval: Duration(hours: 1), startEveryHour: false);

      var jsonBell = bell.toJson();

      //SAVE TO FILE
      LocalPathProvider.saveBell(jsonBell);
      var newJsonBell = await LocalPathProvider.getBellJson();

      //LOAD BELL FROM FILE
      //EXPECTED TO BE NULL
      Bell newBell = (await Bell.loadLocalSettings())!;
      // ignore: unnecessary_null_comparison
      expect(newBell != null, true);


      //CHECK IDENTITY
      expect(bell.interval.compareTo(newBell.interval), 0);

      expect(bell.running == newBell.running, true);

      expect(bell.startEveryHour == newBell.startEveryHour, true);

      expect(bell == newBell, true);
    });
  });
}
