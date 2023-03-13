import 'package:flutter/material.dart';

/// ==============================================[WIDGET SETTINGS]=================================
class BellInfoTheme {
  TextStyle textLeftSecondStyle;
  TextStyle textNowTimeStyle;

  BellInfoTheme(this.textLeftSecondStyle, this.textNowTimeStyle);
}

class HomeScreenTheme {
  Color backgroundColor;
  HomeScreenTheme(this.backgroundColor);
}

class ReminderTextTheme {
  Color transparentDialog;
  LinearGradient dialogBackgroundGradient;
  ReminderTextTheme(
    this.transparentDialog,
    this.dialogBackgroundGradient,
  );
}

class SwitchButtonTheme {
  Color switchColor;
  double switchScale;

  SwitchButtonTheme(this.switchColor, this.switchScale);
}

class ThreeCashedButtonTheme {
  LinearGradient cashedButtonGradient;

  ThreeCashedButtonTheme(this.cashedButtonGradient);
}

class AppTheme {
  LinearGradient activeBellGradient;
  LinearGradient unactiveBellGradient;
  Color activeBottomNavigationBarColor;
  Color unactiveBottomNavigationBarColor;

  AppTheme(
      this.activeBellGradient,
      this.unactiveBellGradient,
      this.activeBottomNavigationBarColor,
      this.unactiveBottomNavigationBarColor);
}

/// ===============================================[THEME SETTINGS]================================

class CustomTheme {
  static loadBasicTheme() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black87,
      primaryColor: const Color.fromARGB(148, 0, 0, 0),
      bottomAppBarTheme: const BottomAppBarTheme(color: Colors.black),

      // Define the default font family.
      fontFamily: 'WakeUpToday',
      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    );
  }

  /// ===============================================[WIDGET INSTANCES]==========================
  BellInfoTheme bellInfoTheme;
  HomeScreenTheme homeScreenTheme;
  ReminderTextTheme reminderTextTheme;
  SwitchButtonTheme switchButtonTheme;
  ThreeCashedButtonTheme threeCashedButtonTheme;
  AppTheme appTheme;

  CustomTheme(this.bellInfoTheme, this.homeScreenTheme, this.reminderTextTheme,
      this.switchButtonTheme, this.threeCashedButtonTheme, this.appTheme);

  // factory CustomTheme.orange() {
  //   return CustomTheme(
  //       bellInfoTheme,
  //       homeScreenTheme,
  //       reminderTextTheme,
  //       sliderIntervalTheme,
  //       switchButtonTheme,
  //       threeCashedButtonTheme,
  //       appTheme);
  // }

  // factory CustomTheme.brown() {
  //   return CustomTheme(
  //       bellInfoTheme,
  //       homeScreenTheme,
  //       reminderTextTheme,
  //       sliderIntervalTheme,
  //       switchButtonTheme,
  //       threeCashedButtonTheme,
  //       appTheme);
  // }

  // factory CustomTheme.grey() {
  //   return CustomTheme(
  //       bellInfoTheme,
  //       homeScreenTheme,
  //       reminderTextTheme,
  //       sliderIntervalTheme,
  //       switchButtonTheme,
  //       threeCashedButtonTheme,
  //       appTheme);
  // }

  // factory CustomTheme.green() {
  //   return CustomTheme(
  //       bellInfoTheme,
  //       homeScreenTheme,
  //       reminderTextTheme,
  //       sliderIntervalTheme,
  //       switchButtonTheme,
  //       threeCashedButtonTheme,
  //       appTheme);
  // }

  // factory CustomTheme.blue() {
  //   return CustomTheme(
  //       bellInfoTheme,
  //       homeScreenTheme,
  //       reminderTextTheme,
  //       sliderIntervalTheme,
  //       switchButtonTheme,
  //       threeCashedButtonTheme,
  //       appTheme);
  // }

  // factory CustomTheme.pink() {
  //   return CustomTheme(
  //       bellInfoTheme,
  //       homeScreenTheme,
  //       reminderTextTheme,
  //       sliderIntervalTheme,
  //       switchButtonTheme,
  //       threeCashedButtonTheme,
  //       appTheme);
  // }

  factory CustomTheme.purpledefault() {
    return CustomTheme(
        BellInfoTheme(
            const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 36),
            const TextStyle(
                color: Color.fromARGB(255, 255, 255, 255), fontSize: 42)),
        HomeScreenTheme(Colors.transparent),
        ReminderTextTheme(
          Colors.transparent,
          const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color.fromARGB(197, 39, 65, 130),
                Color.fromARGB(180, 15, 4, 11)
              ]),
        ),
        SwitchButtonTheme(Colors.greenAccent, 1),
        ThreeCashedButtonTheme(
          const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(255, 56, 25, 76),
              Color.fromARGB(255, 75, 53, 147),
            ],
          ),
        ),
        AppTheme(
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(197, 66, 119, 253),
                  Color.fromARGB(180, 15, 4, 11)
                ]),
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(199, 88, 37, 147),
                  Color.fromARGB(91, 21, 14, 25)
                ]),
            Colors.green,
            Colors.deepPurple));
  }

  // factory CustomTheme.red() {
  //   return CustomTheme(
  //       bellInfoTheme,
  //       homeScreenTheme,
  //       reminderTextTheme,
  //       sliderIntervalTheme,
  //       switchButtonTheme,
  //       threeCashedButtonTheme,
  //       appTheme);
  // }

  static CustomTheme selectTheme(
      {ThemesEnum theme = ThemesEnum.purpleDefault}) {
    switch (ThemesEnum) {
      // case ThemesEnum.orange:
      //   return CustomTheme.orange();
      // case ThemesEnum.brown:
      //   return CustomTheme.brown();
      // case ThemesEnum.grey:
      //   return CustomTheme.grey();
      // case ThemesEnum.green:
      //   return CustomTheme.green();
      // case ThemesEnum.blue:
      //   return CustomTheme.blue();
      // case ThemesEnum.pink:
      //   return CustomTheme.pink();
      // case ThemesEnum.red:
      //   return CustomTheme.red();

      default:
        return CustomTheme.purpledefault();
    }
  }
}

enum ThemesEnum { orange, brown, grey, green, blue, pink, purpleDefault, red }
