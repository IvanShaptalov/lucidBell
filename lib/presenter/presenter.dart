import 'dart:async';

import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/permission_service/permission_service.dart';

/// USE PRESENTER TO IMPLEMENT SOME MODEL LOGIC AND CONNECT IT TO VIEW AND CURRENT PLATFORM
// import 'package:flutter_lucid_bell/presenter/android/init_services.dart';
// import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
// import 'package:flutter_lucid_bell/presenter/android/permission_service/permission_service.dart';
class BellPresenter {
  static AndroidBell? bell;
  static StreamSubscription? watcherSub;
  static List<Function> callbacksTrigger = [];
  static bool isBellRunning() {
    if (bell == null) {
      return false;
    }
    return bell!.getRunning();
  }

  static Future<bool> init() async {
    // load permissions
    await PermissionService.checkPermissions();
    await PermissionService.checkSpecificPermissions();

    // load bell
    if (watcherSub != null) {
      await watcherSub!.cancel();
    }
    bool result = await AndroidBell.initServicesAsync();
    assert(result, true);
    bell = await AndroidBell.loadFromStorage();
    var watcher = AndroidBellStorageManager.getBellFileWatcher();
    watcherSub = watcher.events.listen((event) async {
      bell = await AndroidBell.loadFromStorage();
    });
    return true;
  }

  static void updateCallbacks() {
    for (var f in callbacksTrigger) {
      f();
    }
  }

  static void addIfEmpty(Function f) {
    if (callbacksTrigger.isEmpty) {
      callbacksTrigger.add(f);
    }
  }

  static void clearCallbackTriggers() {
    callbacksTrigger.clear();
  }
}
