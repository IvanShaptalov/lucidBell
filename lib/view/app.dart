import 'package:flutter/material.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/home_view/home_screen.dart';
import 'package:flutter_lucid_bell/view/android/permission_page/permission_page.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  MyApp({super.key});
  final List<Widget> _pages = [const HomeScreen(), const PermissionPage()];

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPage = 0;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    // ignore: invalid_use_of_protected_member

    return MaterialApp(
        title: 'Lucid Bell Simplest',
        debugShowCheckedModeBanner: false,
        theme: ThemeSetting.loadCalmTheme(),
        home: Container(
          decoration: BoxDecoration(
              gradient: BellPresenter.bell!.getRunning() // active
                  ? const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight, // #380036 > #0CBABA
                      colors: [
                          Color.fromARGB(197, 66, 119, 253),
                          Color.fromARGB(180, 15, 4, 11)
                        ])
                  : const LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight, // #380036 > #0CBABA
                      colors: [
                          Color.fromARGB(199, 88, 37, 147),
                          Color.fromARGB(91, 21, 14, 25)
                        ])),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            body: widget._pages.elementAt(currentPage),
            bottomNavigationBar: BottomNavigationBar(
                backgroundColor: Colors.transparent,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: "home",
                      backgroundColor: Colors.transparent),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings),
                      label: "settings",
                      backgroundColor: Colors.transparent),
                ],
                currentIndex: currentPage,
                fixedColor: Colors.red,
                onTap: (int inIndex) {
                  setState(() {
                    currentPage = inIndex;
                  });
                }),
          ),
        ));
  }
}
