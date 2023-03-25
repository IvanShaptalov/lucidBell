import 'dart:convert' show jsonDecode, jsonEncode;
import 'dart:io' show Directory, File, FileMode;
// ignore: depend_on_referenced_packages
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart' show AndroidBell;
import 'package:flutter_lucid_bell/presenter/presenter.dart' show BellPresenter;
import 'package:flutter_lucid_bell/view/view.dart' show View;
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' show join;
import 'package:path_provider/path_provider.dart' show getApplicationSupportDirectory;
import 'package:watcher/watcher.dart' show FileWatcher;

class LocalManager {
  /// ===========================[ROOT]=========================================
  ///
  static String? storageDirectoryPath;

  /// ==========================[DIRECTORY PATHS]===============================
  ///
  static String localBellDirectoryPath = 'localBellDir';
  static String logDirectoryPath = 'logDir';
  static String reminderTextDirectoryPath = 'rTextDir';
  static String onStartApplicationDirectoryPath = 'onStartDir';

  /// ==========================[FILES PATHS]====================================
  ///
  static String? localBellFilePath;
  static String? logFilePath;
  static String? reminderTextFilePath;
  static String? onStartApplicationFilePath;
  static String? themeFilePath;

  ///============================[FILE NAMES]====================================
  ///
  static String localBellFileName = 'bellInfo.txt';
  static String logFileName = 'logFile.txt';
  static String rTextFileName = 'reminderText.txt';
  static String onStartFileName = 'onStart.txt';
  static String themeFileName = 'currentTheme.txt';

  /// ============================[UTIL]=========================================
  static bool dirExists(String? dirPath) {
    if (dirPath == null) {
      return false;
    } else {
      return Directory(dirPath).existsSync();
    }
  }

  static bool fileExists(String? filePath) {
    if (filePath == null) {
      return false;
    } else {
      return File(filePath).existsSync();
    }
  }

  /// ==========================[INITIALIZATION]=================================

  static bool get initialized {
    return
        // DIRECTORIES EXISTS
        dirExists(storageDirectoryPath) &&
            dirExists(localBellDirectoryPath) &&
            dirExists(logDirectoryPath) &&
            dirExists(reminderTextDirectoryPath) &&
            dirExists(onStartApplicationDirectoryPath) &&
            // FILES EXISTS
            fileExists(localBellFilePath) &&
            fileExists(logFilePath) &&
            fileExists(reminderTextFilePath) &&
            fileExists(onStartApplicationFilePath) &&
            fileExists(themeFilePath);
  }

  static Future<String> createAppDirectoryPath() async {
    // var externalDir = await getExternalStorageDirectory();
    var externalDir = await getApplicationSupportDirectory();
    // var appDir = externalDir ?? (await getApplicationSupportDirectory());
    var appDir = externalDir;
    var created = createDirectory(appDir.path);
    assert(created, true);
    return appDir.path;
  }

  static Future<bool> mountPathsAsync() async {
    storageDirectoryPath = await createAppDirectoryPath();
    assert(storageDirectoryPath != null);
//=========================MOUNT DIRECTORIES=============================================
    localBellDirectoryPath =
        join(storageDirectoryPath!, localBellDirectoryPath);
    logDirectoryPath = join(storageDirectoryPath!, logDirectoryPath);
    reminderTextDirectoryPath =
        join(storageDirectoryPath!, reminderTextDirectoryPath);
    onStartApplicationDirectoryPath =
        join(storageDirectoryPath!, onStartApplicationDirectoryPath);

    for (String dirPath in [
      localBellDirectoryPath,
      logDirectoryPath,
      reminderTextDirectoryPath,
      onStartApplicationDirectoryPath
    ]) {
      createDirectory(dirPath);
    }

//========================MOUNT FILES====================================================

    localBellFilePath = join(localBellDirectoryPath, localBellFileName);
    logFilePath = join(logDirectoryPath, logFileName);
    reminderTextFilePath = join(reminderTextDirectoryPath, rTextFileName);
    onStartApplicationFilePath =
        join(onStartApplicationDirectoryPath, onStartFileName);
    themeFilePath = join(onStartApplicationDirectoryPath, themeFileName);

    for (String filePath in [
      localBellFilePath!,
      logFilePath!,
      reminderTextFilePath!,
      onStartApplicationFilePath!,
      themeFilePath!
    ]) {
      createFile(filePath);
    }
    assert(initialized == true);
    return initialized;
  }

  /// init file tree if not initialized, use only await initAsync();
  static Future<bool> initAsync() async {
    if (!initialized) {
      await mountPathsAsync();
    }
    assert(initialized == true);
    return initialized;
  }

  /// ===========================[CRUD]===========================================
  static bool createDirectory(String path) {
    var dir = Directory(path);
    if (!dir.existsSync()) {
      dir.createSync(recursive: true);
    }
    return dir.existsSync();
  }

  static bool createFile(String path) {
    var file = File(path);
    if (!file.existsSync()) {
      file.createSync(recursive: true);
    }
    return file.existsSync();
  }

  static Future<bool> writeToFile(String path, String data,
      {FileMode fileMode = FileMode.write}) async {
    // init if not initialized
    await initAsync();

    await File(path).writeAsString(data, mode: fileMode);

    if (kDebugMode) {
      print('file to write: $data \npatj" $path');
    }

    return true;
  }

  static Future<String?> readFile(String path) async {
    // init if not initialized
    await initAsync();
    var file = File(path);
    var result = await file.readAsString();
    return result != "" ? result : null;
  }

  /// ==============================[LISTENERS]====================================
  static FileWatcher getFileWatcher(String filePath) {
    assert(File(filePath).existsSync(), true);
    return FileWatcher(filePath, pollingDelay: const Duration(seconds: 1));
  }
}

class AndroidBellStorageManager {
  static FileWatcher getBellFileWatcher() {
    return LocalManager.getFileWatcher(LocalManager.localBellFilePath!);
  }

  static Future<AndroidBell> loadBellFromStorage(
      {bool disabledBackgroundWork = false}) async {
    await LocalManager.initAsync();

    String? jsonBell =
        await LocalManager.readFile(LocalManager.localBellFilePath!);
    AndroidBell? bell;
    if (jsonBell != null) {
      try {
        bell = AndroidBell.fromJson(jsonBell);
        await StorageLogger.logBackgroundAsync('loaded bell: $bell');
        return bell;
      } catch (e) {
        await StorageLogger.logBackgroundAsync(
            'error while loading bell: ${e.toString()}');

        return AndroidBell.mockBell();
      }
    }
    // return mock bell
    if (disabledBackgroundWork) {
      await StorageLogger.logBackgroundAsync('mock bell without background');

      return AndroidBell.mockBellWithoutBackground();
    } else {
      await StorageLogger.logBackgroundAsync('mock bell with background');

      return AndroidBell.mockBell();
    }
  }

  static Future<bool> saveBellToStorageAsync(AndroidBell bell) async {
    await LocalManager.initAsync();

    bool result = await LocalManager.writeToFile(
        LocalManager.localBellFilePath!, bell.toJson());
    return result;
  }
}

class StorageLogger {
  static Future<bool> logBackgroundAsync(String log) async {
    if (BellPresenter.logToFile) {
      await LocalManager.initAsync();

      assert(LocalManager.initialized);

      LocalManager.writeToFile(LocalManager.logFilePath!,
          "${View.formatTime(DateTime.now())}: $log \n",
          fileMode: FileMode.append);

      // file saved
      return BellPresenter.logToFile;
    }
    return BellPresenter.logToFile;
  }
}

class StorageAppStartManager {
  static Future<bool> saveWelcomePageDataAsync(bool welcomeData) async {
    await LocalManager.initAsync();

    bool result = await LocalManager.writeToFile(
        LocalManager.onStartApplicationFilePath!, jsonEncode(welcomeData));
    return result;
  }

  static Future<bool> getWelcomePageDataAsync() async {
    await LocalManager.initAsync();

    String? rawResult =
        await LocalManager.readFile(LocalManager.onStartApplicationFilePath!);
    bool result = rawResult != null ? jsonDecode(rawResult) : true;
    return result;
  }
}
