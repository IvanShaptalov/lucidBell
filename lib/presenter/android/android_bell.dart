import 'package:flutter_lucid_bell/model/bell/bell.dart';
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart';
import 'package:flutter_lucid_bell/presenter/android/background_implementation/background_implementation.dart';
import 'package:flutter_lucid_bell/presenter/android/notifications/notification_service.dart';
///Implement android platform dependencies, Cashing, work in background, notification service
class AndroidBell extends Bell
    with
        AndroidBellStorageManager,
        AndroidBellBackgroundManager,
        AndroidBellNotificationService {

  AndroidBell(super.running, super.interval, super.threeCashedIntervals);

}
