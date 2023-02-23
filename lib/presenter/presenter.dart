import 'dart:async';

import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:watcher/watcher.dart';
import 'package:path/path.dart' as p;

/// USE PRESENTER TO IMPLEMENT SOME MODEL LOGIC AND CONNECT IT TO VIEW AND CURRENT PLATFORM
// import 'package:flutter_lucid_bell/presenter/android/init_services.dart';
// import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
// import 'package:flutter_lucid_bell/presenter/android/permission_service/permission_service.dart';
class BellPresenter {
  static AndroidBell? bell;
  static StreamSubscription? watcherSub;
  static List<Function> callbacksTrigger = [];
  
  static Future<bool> init() async {
    if (watcherSub != null){
      await watcherSub!.cancel();
    }
    bool result = await AndroidBell.initServicesAsync();
    assert(result, true);
    bell = await AndroidBell.loadFromStorage();
    print('start listen file');
    var watcher = LocalPathProvider.getFileBellListener();
    watcherSub = watcher.events.listen((event) async{
      print(event);
      print('data modified');
      bell = await AndroidBell.loadFromStorage();
    });
    return true;
  }

  static void updateCallbacks(){
    print('========================================================trigger length: ${callbacksTrigger.length}');
    for (var f in callbacksTrigger){

      f();
    }
  }


}
