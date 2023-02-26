import 'package:permission_handler/permission_handler.dart';
import 'package:sound_mode/permission_handler.dart';

class PermissionService {
  // NESSESARY PERMISSIONS
  bool notificationPermissionGranted = false;
  bool batteryOptimizationDisabled = false;
  bool silentModeDisabled = false;
  bool specificPermission = false;

  Future<void> init() async {
    await checkForPermissions();
  }

  Future<void> checkForPermissions() async {
    // NOTIFICATION GRANT
    notificationPermissionGranted = await Permission.notification.isGranted;
    // BATTERY GRANT
    batteryOptimizationDisabled =
        await Permission.ignoreBatteryOptimizations.isGranted;

    // SILENT DISABLED
    silentModeDisabled = await isSilentModeDisabled();

    specificPermission = false;
  }

  Future<bool> isSilentModeDisabled() async {
    bool? result = await PermissionHandler.permissionsGranted;
    if (result == true) {
      return true;
    }
    return false;
  }

  Future<bool> checkForSpecificPermissions() async {
    // return (await specific.isAutoStartAvailable.timeout(const Duration(seconds: 10))) ?? true;
    return true;
  }

  Future<bool> grantPermission(Permission permission, bool saveAnswer) async {
    saveAnswer = await permission.request().isGranted;
    return saveAnswer;
  }

  Future<bool> disableSilentMode() async {
    await PermissionHandler.openDoNotDisturbSetting();
    return isSilentModeDisabled();
  }
}
