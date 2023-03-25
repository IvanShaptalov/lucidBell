import 'package:flutter/material.dart' show Alignment, AnnotatedRegion, BottomNavigationBar, BottomNavigationBarItem, BoxDecoration, Brightness, BuildContext, Colors, Container, Icon, Icons, MaterialApp, Scaffold, Stack, State, StatefulWidget, Widget;
import 'package:flutter/services.dart' show Brightness, DeviceOrientation, SystemChrome, SystemUiOverlayStyle;
import 'package:flutter_lucid_bell/presenter/presenter.dart' show BellPresenter;
import 'package:flutter_lucid_bell/view/android/home_view/home_screen.dart' show HomeScreen;
import 'package:flutter_lucid_bell/view/android/permission_page/permission_page.dart' show PermissionPage;
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart' show CustomTheme;
import 'package:flutter_lucid_bell/view/android/welcome_screen/welcome_screen.dart' show WelcomeScreen;
import 'package:flutter_lucid_bell/view/view.dart' show View;
import 'package:google_mobile_ads/google_mobile_ads.dart' show BannerAd;
import 'package:upgrader/upgrader.dart' show UpgradeAlert;

// ignore: must_be_immutable
class MyApp extends StatefulWidget {
  BannerAd? bannerAd;

  MyApp({super.key});
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
      PermissionPage(updateCallback)
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
      child: UpgradeAlert(
        child: MaterialApp(
            title: 'Lucid Bell Simplest',
            debugShowCheckedModeBanner: false,
            theme: CustomTheme.loadBasicTheme(),
            home: BellPresenter.showFeaturesPage
                ? WelcomeScreen(updateCallback)
                : Container(
                    decoration: BoxDecoration(
                        gradient: BellPresenter.isBellRunning() // active
                            ? View.currentTheme.appTheme.activeBellGradient
                            : View.currentTheme.appTheme.unactiveBellGradient),
                    child: Scaffold(
                      resizeToAvoidBottomInset: false,
                      backgroundColor: Colors.transparent,

                      /// ===================[Home SCREEN & PERSMISSION PAGE]===================================================

                      body: Stack(alignment: Alignment.bottomCenter, children: [
                        pages.elementAt(currentPage)
                      ]),
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
                              ? View.currentTheme.appTheme
                                  .activeBottomNavigationBarColor
                              : View.currentTheme.appTheme
                                  .unactiveBottomNavigationBarColor,
                          onTap: (int inIndex) {
                            setState(() {
                              BellPresenter.clearCallbackTriggers();

                              currentPage = inIndex;
                            });
                          }),
                    ),
                  )),
      ),
    );
  }
}
