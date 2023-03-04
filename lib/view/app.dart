import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/home_view/home_screen.dart';
import 'package:flutter_lucid_bell/view/android/permission_page/permission_page.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:flutter_lucid_bell/view/android/welcome_screen/welcome_screen.dart';
import 'package:flutter_lucid_bell/view/config_view.dart';

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  const MyApp({super.key});
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int currentPage = 0;

  void updateCallback() {
    setState(() {});
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    // ignore: invalid_use_of_protected_member
    final List<Widget> pages = [
      HomeScreen(updateCallback),
      const PermissionPage()
    ];
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent, //top status bar
        systemNavigationBarColor:
            Colors.black, // navigation bar color, the one Im looking for
        statusBarIconBrightness: Brightness.dark, // status bar icons' color
        systemNavigationBarIconBrightness:
            Brightness.dark, //navigation bar icons' color
      ),
      child: MaterialApp(
          title: 'Lucid Bell Simplest',
          debugShowCheckedModeBanner: false,
          theme: ThemeSetting.loadCalmTheme(),
          home: BellPresenter.showFeaturesPage
              ? WelcomeScreen(updateCallback)
              : Container(
                  decoration: BoxDecoration(
                      gradient: BellPresenter.isBellRunning() // active
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
                    body: pages.elementAt(currentPage),
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
                        unselectedItemColor: Colors.grey,
                        fixedColor: BellPresenter.isBellRunning()
                            ? Colors.green
                            : Colors.deepPurple,
                        onTap: (int inIndex) {
                          setState(() {
                            BellPresenter.clearCallbackTriggers();

                            currentPage = inIndex;
                          });
                        }),
                  ),
                )),
    );
  }
}
