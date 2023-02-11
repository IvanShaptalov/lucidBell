import 'package:flutter/material.dart';

import 'home_view/home_screen.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  HomeScreen homeScreen =  HomeScreen(title: 'Lucid Bell Simplest');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: homeScreen,
    );
  }
}
