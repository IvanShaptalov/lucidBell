import 'package:device_info_plus/device_info_plus.dart' show AndroidDeviceInfo, DeviceInfoPlugin;
import 'package:flutter_lucid_bell/presenter/android/IO/android_local_path_provider.dart' show StorageLogger;
import 'package:permission_handler/permission_handler.dart';

class CustomPermission {
  bool granted;
  String title;
  String description;
  Permission primaryPermission;
  CustomPermission(
      this.granted, this.title, this.description, this.primaryPermission);
}

class SpecificCustomPermission {
  static String? title;
  static String? description;
  static String? link;

  static bool implemented = false;

  static Future<bool> implementSpecific() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    String manufacturer = androidInfo.manufacturer.toLowerCase();
    await StorageLogger.logBackgroundAsync('Running on $manufacturer');

/// ===================================[XIAOMI IMPLEMENTATION]====================================================
    if (manufacturer.contains('xiaomi')) {
      title = 'running on [XIAOMI] device: enable Autostart';
      description =
          """Autostart is nessesary option to correct Circle Bell work. Here instruction to enable Autostart service
    - Open the Security menu on your device.
    - Tap Permissions.
    - Tap Autostart.
    - Swipe to enable Autostart for Circle Bell.""";
      implemented = true;

/// ===================================[HONOR IMPLEMENTATION]======================================================
    } else if (manufacturer.contains('honor')) {
      title = 'running on [HONOR] device: add to Protected apps';
      description =
          """Add to Protected apps option is nessesary option to correct Circle Bell work\nFrom the app drawer, 
    - Tap Settings
    - Tap Advanced Settings.
    - Tap Battery Manager.
    - Tap Protected apps (or Close apps after screen lock).
    - Toggle Circle Bell to enable.""";
      implemented = true;

/// ===================================[LETV IMPLEMENTATION]=======================================================
    } else if (manufacturer.contains('letv')) {
      title = 'running on [LETV] device: enable Auto Launch';
      description =
          """Auto Launch is nessesary option to correct Circle Bell work\nFrom the app drawer, 
    - Tap Settings.
    - Tap Permissions.
    - Tap Manage Auto Launch.
    - Toggle Circle Bell to enable.""";
      implemented = true;

/// ===================================[OPPO IMPLEMENTATION]=======================================================
    } else if (manufacturer.contains('oppo')) {
      title = 'running on [OPPO] device: add to Auto Launch';
      description = """Auto Launch is nessesary option to correct Circle Bell work\nYou can go to [Settings] > [Apps] > [Auto launch] \n> Choose Circle Bell to auto-launch.""";
      implemented = true;

/// ======================================[VIVO IMPLEMENTATION]===================================================
    } else if (manufacturer.contains('vivo')) {
      title = 'running on [VIVO] device: add to Auto Start';
      description = """Auto Start is nessesary option to correct Circle Bell work\nYou can go to [Settings] > [More settings] > [Permission management(Applications)] \n> turn on Autostart to Circle Bell.""";
      implemented = true;
    } 
   
    else {
      implemented = false;
    }
    return implemented;
  }
}

/// =================================================[PERMISSION SERVICE]===================================================

class PermissionService {
  /// ===================================================[PERMISSIONS]======================================================
  static bool allGranted = false;
  
  static CustomPermission notification = CustomPermission(
      false,
      'notifications enabled',
      'enable notifications to hear bell.',
      Permission.notification);

  static CustomPermission batteryOptimization = CustomPermission(
      false,
      'battery optimization disabled',
      'some devices kill background tasks(bell work in background) if battery optimization is on,\nturn off battery optimization to get better expirience with app',
      Permission.ignoreBatteryOptimizations);

  /// =================================================[PERMISSION METHODS]================================================
  static Future<void> checkPermissions() async {
    // NOTIFICATION GRANT
    notification.granted = await Permission.notification.isGranted;
    // BATTERY GRANT
    batteryOptimization.granted =
        await Permission.ignoreBatteryOptimizations.isGranted;

    
    allGranted = notification.granted && batteryOptimization.granted;
  }

  static Future<void> checkSpecificPermissions() async {
    await SpecificCustomPermission.implementSpecific();
  }

  static Future<bool> grantPermission(CustomPermission cPermission) async {
    if (await cPermission.primaryPermission.isGranted) {
      cPermission.granted = true;
      return cPermission.granted;
    }

    cPermission.granted =
        await cPermission.primaryPermission.request().isGranted;
    return cPermission.granted;
  }
}
