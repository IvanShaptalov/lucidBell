// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/bell/bell.dart';
import 'package:flutter_lucid_bell/model/data_structures/data_structures.dart';
import 'package:flutter_lucid_bell/view/app.dart';
// import 'package:flutter_lucid_bell/bell/bell_logic.dart';
// import 'package:flutter_lucid_bell/model/config_model.dart';
// // import 'package:flutter_lucid_bell/notifications/notification_service.dart';
// import 'package:workmanager/workmanager.dart';

// import 'view/app.dart';

void main() async {
  Bell(true, const Duration(minutes: 15), CashedIntervals());
  // // load widgets firstry
  WidgetsFlutterBinding.ensureInitialized();

  // // init services
  // print('************************************start init');

  // await InitServices.init();

  runApp(const MyApp());
}
