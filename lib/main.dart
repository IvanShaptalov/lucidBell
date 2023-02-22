// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/model/bell/bell.dart';
import 'package:flutter_lucid_bell/model/data_structures/data_structures.dart';
import 'package:flutter_lucid_bell/presenter/android/android_bell.dart';
import 'package:flutter_lucid_bell/view/app.dart';

class MainBell{
  static AndroidBell? bell;
  static Future<void> init() async{
    bool result = await AndroidBell.initServicesAsync();
    assert(result, true);
    bell = await AndroidBell.loadFromStorage();
  }
}
void main() async {
  // // load widgets firstly
  WidgetsFlutterBinding.ensureInitialized();
  await MainBell.init();
  

  runApp(const MyApp());
}
