import 'package:flutter/material.dart';
// import 'package:flutter_lucid_bell/view/theme/theme_setting.dart';

// import 'home_view/home_screen.dart';

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // HomeScreen homeScreen = HomeScreen(title: 'Lucid Bell Simplest');

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Lucid Bell Simplest',
      debugShowCheckedModeBanner: false,
      // theme: ThemeSetting.loadCalmTheme(),
      home: Scaffold(
        body: Text('ok with it'),
      ),
    );
  }
}
