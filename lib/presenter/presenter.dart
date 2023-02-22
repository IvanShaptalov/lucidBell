import 'package:flutter_lucid_bell/model/bell/bell.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';

/// USE PRESENTER TO IMPLEMENT SOME MODEL LOGIC AND CONNECT IT TO VIEW AND CURRENT PLATFORM
// import 'package:flutter_lucid_bell/presenter/android/init_services.dart';
// import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
// import 'package:flutter_lucid_bell/presenter/android/permission_service/permission_service.dart';
class BellPresenter {
  static AndroidBell? bell;
  static Future<bool> init() async {
    bool result = await AndroidBell.initServicesAsync();
    assert(result, true);
    bell = await AndroidBell.loadFromStorage();
    return true;
  }

}
