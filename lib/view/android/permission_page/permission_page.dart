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
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await PermissionService.checkPermissions();
      // NOT UPDATE IF SLIDER  CHANGING OR BELL NOT RUN
      setState(() {
        PermissionService.notification;
        PermissionService.batteryOptimization;
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
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Column(
        children: [
          Container(
              margin: EdgeInsets.symmetric(
                  vertical: SizeConfig.getMediaHeight(context) * 0.1), //10%
              child: Transform.scale(
                  scale: 4,
                  child: Container(
                    child: PermissionService.allGranted
                        ? const Text(
                            '😊',
                            style: TextStyle(fontSize: 30),
                          )
                        : const Text('😔', style: TextStyle(fontSize: 30)),
                  ))),
          SizedBox(
            height: SizeConfig.getMediaHeight(context) * 0.6,
            child: Column(
              children: [
                PermissionListTile(PermissionService.notification),
                PermissionListTile(PermissionService.batteryOptimization),
                Container(
                  padding: EdgeInsets.only(
                      top: SizeConfig.getMediaHeight(context) * 0.1), //10%
                  child: SpecificCustomPermission.implemented
                      ? const SpecificPermissionTile()
                      : const SizedBox.shrink(),
                ),
              ],
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
  PermissionListTile(this.cPermission, {super.key});
  CustomPermission cPermission;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(cPermission.title),
      leading: cPermission.granted
          ? const Icon(Icons.check)
          : const Icon(Icons.close),
      subtitle: Text(cPermission.description),
      onTap: () => PermissionService.grantPermission(cPermission),
    );
  }
}

// ignore: must_be_immutable
class SpecificPermissionTile extends StatelessWidget {
  const SpecificPermissionTile({super.key});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(SpecificCustomPermission.title!),
      leading: const Icon(Icons.info_outline),
      subtitle: Text(SpecificCustomPermission.description!),
      onTap: () {},
    );
  }
}
