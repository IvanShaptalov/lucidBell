// import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/app.dart';

void main() async {
  // // load widgets firstly
  WidgetsFlutterBinding.ensureInitialized();
  await BellPresenter.init();

  runApp(MyApp());
}
