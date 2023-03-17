import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/ad_helper.dart';
import 'package:flutter_lucid_bell/presenter/android/monetization/banner_ad.dart';
import 'package:flutter_lucid_bell/presenter/presenter.dart';
import 'package:flutter_lucid_bell/view/android/home_view/home_screen.dart';
import 'package:flutter_lucid_bell/view/android/permission_page/permission_page.dart';
import 'package:flutter_lucid_bell/view/android/theme/theme_setting.dart';
import 'package:flutter_lucid_bell/view/android/welcome_screen/welcome_screen.dart';
import 'package:flutter_lucid_bell/view/view.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:upgrader/upgrader.dart';

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

  @override
  void initState() {
    BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          widget.bannerAd = ad as BannerAd;
          print(" widget on load${widget.bannerAd}");

          updateCallback();
        },
        onAdFailedToLoad: (ad, err) {
          if (kDebugMode) {
            print('Failed to load a banner ad: ${err.message}');
          }
          ad.dispose();
        },
      ),
    ).load();
    print(" widget after load${widget.bannerAd}");
    super.initState();
  }

  @override
  void dispose() {
    widget.bannerAd?.dispose();

    super.dispose();
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

                      body: Stack(children: [
                        if (CustomBannerAd.adCondition(widget.bannerAd))
                          CustomBannerAd.showBanner(widget.bannerAd!),
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
