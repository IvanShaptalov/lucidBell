import 'package:permission_handler/permission_handler.dart';

class PermissionService {
  // NESSESARY PERMISSIONS
  static bool notificationPermissionGranted = false;
  static bool batteryOptimizationDisabled = false;
  static bool silentModeDisabled = false;
  static bool specificPermission = false;

  static String notificationsTitle = 'notifications enabled';
  static String batteryTitle = 'battery optimization disabled';
  static String silentModeDisabledTitle = 'silent mode disabled';
  static String specificPermissionTitle = 'specific permission';


  static Future<void> checkPermissions() async {
    // NOTIFICATION GRANT
    notificationPermissionGranted = await Permission.notification.isGranted;
    // BATTERY GRANT
    batteryOptimizationDisabled =
        await Permission.ignoreBatteryOptimizations.isGranted;

    // SILENT DISABLED
    silentModeDisabled = await isSilentModeDisabled();

    specificPermission = true;
  }

  static Future<bool> isSilentModeDisabled() async {
    // bool? result = await PermissionHandler.permissionsGranted;
    // if (result == true) {
    //   return true;
    // }
    return true;
  }

  static Future<bool> checkForSpecificPermissions() async {
    // return (await specific.isAutoStartAvailable.timeout(const Duration(seconds: 10))) ?? true;
    return true;
  }

  static Future<bool> grantPermission(Permission permission, bool saveAnswer) async {
    saveAnswer = await permission.request().isGranted;
    return saveAnswer;
  }

  static Future<bool> disableSilentMode() async {
    return true;
  }
}
