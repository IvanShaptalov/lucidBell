import 'dart:convert';
import 'dart:io';
// ignore: depend_on_referenced_packages
import 'package:flutter/foundation.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/config_android_presenter.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:watcher/watcher.dart';

class LocalPathProvider {
  static String?
      appDocPath; //use createAppDirAsync to set appDocPath to string path
  static String?
      cashLocalPath; // use createAppDirAsync to set cashLocalPath to string path

  static String? logPath;

  static bool get _notInitialized {
    return LocalPathProvider.appDocPath == null ||
        LocalPathProvider.cashLocalPath == null ||
        LocalPathProvider.logPath == null;
  }

  static bool get initialized {
    return !_notInitialized;
  }

  static Future<bool> initAsync() async {
    if (_notInitialized) {
      Directory appDir = await getApplicationSupportDirectory();

      appDocPath = await _createAppDir(appDir.path).then((dir) => dir.path);

      // create local file to store data
      await _createCashLocal();
      await _createLogFile();

      if (kDebugMode) {
        print(' localpath: ${LocalPathProvider.appDocPath}');
      }
    }
    return initialized;
  }

  static Future<bool> deleteAppFolder() async {
    // return true if deleted
    assert(appDocPath is String, true);
    assert(cashLocalPath is String, true);
    var dir = Directory(appDocPath!);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
    return !await dir.exists();
  }

  static Future<String?> getFileAsync() async {
    assert(cashLocalPath != null);
    var file = File(cashLocalPath!);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return null;
  }

  static Future<bool> saveFile(String dataToSave) async {
    //create cash file if not exists
    await _createCashLocal();

    assert(cashLocalPath is String);
    // ensure that file exists
    var file = File(cashLocalPath!);
    if (await file.exists()) {
      await file.writeAsString(dataToSave);
      // file saved
      return true;
    }
    // file not exists
    return false;
  }

  // use this method to create appDocPath
  static Future<Directory> _createAppDir(String docDir) async {
    var appDirPath = p.join(docDir, ConfigAppLocales.appName);

    Directory dir = Directory(appDirPath);
    // if dir not exists, create it
    if (!await Directory(appDirPath).exists()) {
      dir = await Directory(appDirPath).create(recursive: true);
    }
    assert(await dir.exists());
    return dir;
  }

  static Future<void> _createCashLocal() async {
    // appDocPath directory must be created, use
    assert(appDocPath is String);
    String path = p.join(appDocPath!, ConfigAppLocales.localInfoPath);
    cashLocalPath = path;

    // create if not exists
    if (!await File(path).exists()) {
      await File(path).create();
    }
  }

  static Future<void> _createLogFile() async {
    // appDocPath directory must be created, use
    assert(appDocPath is String);
    String path = p.join(appDocPath!, 'backLog.txt');
    logPath = path;

    // create if not exists
    if (!await File(logPath!).exists()) {
      await File(logPath!).create();
    }
  }

  static DirectoryWatcher getFileBellListener() {
    return DirectoryWatcher(p.absolute(LocalPathProvider.appDocPath!));
  }

  static Future<bool> logBackground(String log) async {
    //create log file if not exists
    await _createLogFile();

    assert(logPath is String);
    // ensure that file exists
    var file = File(logPath!);
    if (await file.exists()) {
      await file.writeAsString("$log \n", mode: FileMode.append);
      // file saved
      return true;
    }
    // file not exists
    return false;
  }

  static Future<String?> getBackgroundLogAsync() async {
    assert(logPath != null);
    var file = File(logPath!);
    if (await file.exists()) {
      return await file.readAsString();
    }
    return '';
  }
}

mixin AndroidBellStorageManager {
  static Future<bool> initAsync() async {
    return await LocalPathProvider.initAsync();
  }

  static Future<AndroidBell> loadBellFromStorage() async {
    String? jsonBell = await LocalPathProvider.getFileAsync();
    AndroidBell? bell;
    if (jsonBell != null && jsonBell != "") {
      bell = AndroidBell.fromJson(jsonBell);
      // return loaded bell
      return bell;
    }
    // return mock bell
    return AndroidBell.mockBell();
  }

  static Future<bool> saveBellToStorageAsync(AndroidBell bell) async {
    bool result = await LocalPathProvider.saveFile(bell.toJson());
    return result;
  }
}
