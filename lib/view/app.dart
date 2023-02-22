import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/view/android/home_view/home_screen.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MyApp({super.key});

  HomeScreen homeScreen = HomeScreen(title: 'Lucid Bell Simplest');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Lucid Bell Simplest',
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: homeScreen,
      ),
    );
  }
}
