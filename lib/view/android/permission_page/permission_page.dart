import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/permission_service/permission_service.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

class PermissionPage extends StatefulWidget {
  const PermissionPage({super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  Timer? timer;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await PermissionService.checkPermissions();
      // NOT UPDATE IF SLIDER  CHANGING OR BELL NOT RUN
      setState(() {
        PermissionService.notificationPermissionGranted;
        PermissionService.silentModeDisabled;
        PermissionService.batteryOptimizationDisabled;
        PermissionService.specificPermission;
      });
    });

    super.initState();
  }

  /// return false by default by default

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.getMediaHeight(context) * 0.1), //10%
              child: Transform.scale(
                  scale: 4, child: const Icon(Icons.emoji_emotions))),
          Container(
            // color: Colors.blue,
            child: SizedBox(
              height: SizeConfig.getMediaHeight(context) * 0.6,
              child: ListView(
                children: [
                  PermissionListTile(PermissionService.notificationsTitle,
                      PermissionService.notificationPermissionGranted),
                  PermissionListTile(PermissionService.silentModeDisabledTitle,
                      PermissionService.silentModeDisabled),
                  PermissionListTile(PermissionService.batteryTitle,
                      PermissionService.batteryOptimizationDisabled),
                  PermissionListTile(PermissionService.specificPermissionTitle,
                      PermissionService.specificPermission)
                ],
              ),
            ),
          ),
        ],
      )),
      backgroundColor: Colors.transparent,
    );
  }
}

// ignore: must_be_immutable
class PermissionListTile extends StatelessWidget {
  PermissionListTile(this.permissionTitle, this.granted, {super.key});
  String permissionTitle;
  bool granted;

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: Text(permissionTitle),
        leading: granted ? const Icon(Icons.check) : const Icon(Icons.close));
  }
}
