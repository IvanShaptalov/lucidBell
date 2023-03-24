import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/presenter/android/android_reminder_text.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/monetization.dart';
import 'package:flutter_lucid_bell/presenter/android/permission_service/permission_service.dart';

/// USE PRESENTER TO IMPLEMENT SOME MODEL LOGIC AND CONNECT IT TO VIEW AND CURRENT PLATFORM
// import 'package:flutter_lucid_bell/presenter/android/init_services.dart';
// import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
// import 'package:flutter_lucid_bell/presenter/android/permission_service/permission_service.dart';
class BellPresenter {
  static AndroidBell? bell;
  static StreamSubscription? watcherSub;
  static List<Function> callbacksTrigger = [];
  static bool logToFile = false;

  static bool showFeaturesPage = true;
  static bool isBellRunning() {
    if (bell == null) {
      return false;
    }
    return bell!.getRunning();
  }

  static Future<void> setFeaturesPage(bool showFeatures) async {
    showFeaturesPage = showFeatures;
    await StorageAppStartManager.saveWelcomePageDataAsync(showFeatures);
  }

  static Future<bool> initAsync() async {
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

    // load features
    showFeaturesPage = await StorageAppStartManager.getWelcomePageDataAsync();
    if (kDebugMode) {
      print("show features : $showFeaturesPage");
    }

    // add file watcher
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

class PresenterTextReminder {
  static AndroidReminderText? reminderText;
  static Future<bool> initAsync() async {
    reminderText = await AndroidReminderText.loadFromStorageAsync();
    reminderText!.loadDefaults();
    return true;
  }
}

class Presenter {
  static Future<bool> initAsync() async {
    bool bellPresenter = await BellPresenter.initAsync();
    bool textReminder = await PresenterTextReminder.initAsync();
    bool storeInited = false;
    try {
      storeInited = await StoreConfig.initStoreAsync();
    } catch (e) {
      debugPrint(e.toString());
    }

    AdHelper.initAsync();
    return bellPresenter && textReminder && storeInited;
  }
}
