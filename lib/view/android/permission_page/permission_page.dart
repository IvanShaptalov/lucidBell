import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/android/permission_service/permission_service.dart';
import 'package:flutter_lucid_bell/view/android/home_view/ad_widgets.dart/banner_ad.dart';
import 'package:flutter_lucid_bell/view/android/permission_page/inapp_review_tile.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_view.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

// ignore: must_be_immutable
class PermissionPage extends StatefulWidget {
  Function updateCallback;
  PermissionPage(this.updateCallback, {super.key});

  @override
  State<PermissionPage> createState() => _PermissionPageState();
}

class _PermissionPageState extends State<PermissionPage> {
  Timer? timer;
  @override
  void initState() {
    CustomBannerAd.loadBannerAd(widget.updateCallback);
    timer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      await PermissionService.checkPermissions();
      setState(() {
        PermissionService.notification;
        PermissionService.batteryOptimization;
      });
    });
    super.initState();
  }

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
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            children: [
              Container(
                  margin: EdgeInsets.only(
                      top: SizeConfig.getMediaHeight(context) * 0.1), //10%
                  child: Transform.scale(
                      scale: 3,
                      child: Container(
                        child: PermissionService.allGranted
                            ? const Text(
                                '😊',
                                style: TextStyle(fontSize: 30),
                              )
                            : const Text('😔', style: TextStyle(fontSize: 30)),
                      ))),
              SizedBox(
                height: SizeConfig.getMediaHeight(context) * 0.5,
                child: ListView(
                  children: [
                    const InAppReviewTile(),
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
              CustomThemes(widget.updateCallback),
              CustomBannerAd.showBanner()
            ],
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
