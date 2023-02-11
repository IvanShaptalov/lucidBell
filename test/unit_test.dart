import 'dart:io';
import 'package:flutter_lucid_bell/bell/local_path_provider.dart';
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
  });
}
