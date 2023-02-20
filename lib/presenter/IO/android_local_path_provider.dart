// import 'dart:io';
// // ignore: depend_on_referenced_packages
// import 'package:flutter/foundation.dart';
// import 'package:flutter_lucid_bell/bell/bell_logic.dart';
// import 'package:flutter_lucid_bell/config.dart';
// // ignore: depend_on_referenced_packages
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';

// class LocalPathProvider {
//   static String?
//       appDocPath; //use createAppDirAsync to set appDocPath to string path
//   static String?
//       cashLocalPath; // use createAppDirAsync to set cashLocalPath to string path

//   static String? logPath;

//   static bool get notInitialized {
//     return LocalPathProvider.appDocPath == null ||
//         LocalPathProvider.cashLocalPath == null ||
//         LocalPathProvider.logPath == null;
//   }

//   static bool get initialized {
//     return !notInitialized;
//   }

//   static Future<bool> init() async {
//     Directory appDir = await getApplicationSupportDirectory();

//     appDocPath = await _createAppDir(appDir.path).then((dir) => dir.path);

//     // create local file to store data
//     await _createCashLocal();
//     await _createLogFile();

//     if (kDebugMode) {
//       print(' localpath: ${LocalPathProvider.appDocPath}');
//     }

//     return true;
//   }

//   static Future<bool> deleteAppFolder() async {
//     // return true if deleted
//     assert(appDocPath is String, true);
//     assert(cashLocalPath is String, true);
//     var dir = Directory(appDocPath!);
//     if (await dir.exists()) {
//       await dir.delete(recursive: true);
//     }
//     return !await dir.exists();
//   }

//   static Future<String?> getBellJsonAsync() async {
//     assert(cashLocalPath != null);
//     var file = File(cashLocalPath!);
//     if (await file.exists()) {
//       return await file.readAsString();
//     }
//     return null;
//   }

//   static Future<bool> saveBell(Bell bell) async {
//     //create cash file if not exists
//     await _createCashLocal();

//     assert(cashLocalPath is String);
//     // ensure that file exists
//     var file = File(cashLocalPath!);
//     if (await file.exists()) {
//       await file.writeAsString(bell.toJson());
//       // file saved
//       return true;
//     }
//     // file not exists
//     return false;
//   }

//   // use this method to create appDocPath
//   static Future<Directory> _createAppDir(String docDir) async {
//     var appDirPath = p.join(docDir, AppLocales.appName);

//     Directory dir = Directory(appDirPath);
//     // if dir not exists, create it
//     if (!await Directory(appDirPath).exists()) {
//       dir = await Directory(appDirPath).create(recursive: true);
//     }
//     assert(await dir.exists());
//     return dir;
//   }

//   static Future<void> _createCashLocal() async {
//     // appDocPath directory must be created, use
//     assert(appDocPath is String);
//     String path = p.join(appDocPath!, 'localInfo.txt');
//     cashLocalPath = path;

//     // create if not exists
//     if (!await File(path).exists()) {
//       await File(path).create();
//     }
//   }

//   static Future<void> _createLogFile() async {
//     // appDocPath directory must be created, use
//     assert(appDocPath is String);
//     String path = p.join(appDocPath!, 'backLog.txt');
//     logPath = path;

//     // create if not exists
//     if (!await File(logPath!).exists()) {
//       await File(logPath!).create();
//     }
//   }

//   static Future<bool> logBackground(String log) async {
//     //create log file if not exists
//     await _createLogFile();

//     assert(logPath is String);
//     // ensure that file exists
//     var file = File(logPath!);
//     if (await file.exists()) {
//       await file.writeAsString("$log \n", mode: FileMode.append);
//       // file saved
//       return true;
//     }
//     // file not exists
//     return false;
//   }

//   static Future<String?> getBackgroundLogAsync() async {
//     assert(logPath != null);
//     var file = File(logPath!);
//     if (await file.exists()) {
//       return await file.readAsString();
//     }
//     return '';
//   }
// }
