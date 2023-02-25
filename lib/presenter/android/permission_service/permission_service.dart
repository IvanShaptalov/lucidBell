import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // NESSESARY PERMISSIONS
  bool notificationPermissionGranted = false;
  bool batteryOptimizationDisabled = false;

  Future<void> init() async {
    await grantPermissions();
    await grantSpecificPermissions();
  }

  Future<void> checkForPermissions() async {
    // NOTIFICATION GRANT
    notificationPermissionGranted = await Permission.notification.isGranted;
    // BATTERY GRANT
    batteryOptimizationDisabled =
        await Permission.ignoreBatteryOptimizations.isGranted;
  }

  Future<bool> checkForSpecificPermissions() async {
    // return (await specific.isAutoStartAvailable.timeout(const Duration(seconds: 10))) ?? true;
    return true;
  }

  Future<bool> grantSpecificPermissions() async {
    // print('try check');
    // if (await checkForSpecificPermissions()) {
    //   print('**************it is normal android');
    //   return true;
    // } else {
    //   print('try grant');
    //   await specific.getAutoStartPermission().timeout(const Duration(seconds: 10));
    //   return true;
    // }
    return true;
  }

  Future<bool> grantPermissions() async {
    // NOTIFICATIONS
    await checkForPermissions();
    if (!notificationPermissionGranted) {
      notificationPermissionGranted =
          await Permission.notification.request().isGranted;
    }

    // BATTERY OPTIMIZATION
    if (!batteryOptimizationDisabled) {
      batteryOptimizationDisabled =
          await Permission.ignoreBatteryOptimizations.request().isGranted;
    }

    // todo create xiaomi task
    return notificationPermissionGranted;
  }
}
