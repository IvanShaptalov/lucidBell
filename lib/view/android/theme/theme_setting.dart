import 'package:flutter/material.dart' show Alignment, BottomAppBarTheme, Brightness, Color, Colors, FontStyle, FontWeight, LinearGradient, TextStyle, TextTheme, ThemeData;
import 'package:flutter_lucid_bell/presenter/android/IO/theme_io.dart' show ThemeIO;

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

class SliderTheme {
  Color activeSliderColor;
  Color inactiveSliderColor;

  SliderTheme(this.activeSliderColor, this.inactiveSliderColor);
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

class SubscriptionStoreTheme {
  Color bottomSheetBackgroundColor;
  Color tileColor;

  SubscriptionStoreTheme(this.bottomSheetBackgroundColor, this.tileColor);
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

class CustomTheme with ThemeIO {
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

  /// ===============================================[OVERRIDES]=================================
  @override
  String toString() {
    return _themeName.name;
  }

  @override
  int get hashCode => _themeName.hashCode;

  @override
  bool operator ==(Object other) {
    return other is CustomTheme && other.hashCode == hashCode;
  }

  /// ===============================================[WIDGET INSTANCES]==========================
  BellInfoTheme bellInfoTheme;
  HomeScreenTheme homeScreenTheme;
  ReminderTextTheme reminderTextTheme;
  SwitchButtonTheme switchButtonTheme;
  ThreeCashedButtonTheme threeCashedButtonTheme;
  AppTheme appTheme;
  SliderTheme sliderTheme;
  SubscriptionStoreTheme storeTheme;
  Themes _themeName;

  Themes get themeEnum => _themeName;

  CustomTheme(
      this.bellInfoTheme,
      this.homeScreenTheme,
      this.reminderTextTheme,
      this.switchButtonTheme,
      this.threeCashedButtonTheme,
      this.appTheme,
      this.sliderTheme,
      this.storeTheme,
      this._themeName);

  /// ================================================[ORANGE THEME]===============================
  factory CustomTheme.orange() {
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
                Color.fromARGB(197, 130, 94, 39),
                Color.fromARGB(180, 15, 4, 11)
              ]),
        ),
        SwitchButtonTheme(const Color.fromARGB(255, 240, 255, 114), 1),
        ThreeCashedButtonTheme(
          const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(197, 255, 200, 114),
              Color.fromARGB(180, 188, 96, 86)
            ],
          ),
        ),
        AppTheme(
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(197, 255, 200, 114),
                  Color.fromARGB(180, 188, 96, 86)
                ]),
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(180, 188, 145, 86),
                  Color.fromARGB(180, 15, 4, 11)
                ]),
            const Color.fromARGB(255, 240, 255, 114),
            const Color.fromARGB(255, 202, 103, 47)),
        SliderTheme(const Color.fromARGB(255, 205, 216, 97),
            const Color.fromARGB(255, 132, 140, 62)),
        SubscriptionStoreTheme(Colors.brown.shade400,
            Colors.brown.shade300),
        Themes.orange);
  }

  /// ==============================================[BROWN THEME]=======================================

  factory CustomTheme.brown() {
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
                Color.fromARGB(197, 130, 94, 39),
                Color.fromARGB(180, 15, 4, 11)
              ]),
        ),
        SwitchButtonTheme(const Color.fromARGB(255, 202, 168, 47), 1),
        ThreeCashedButtonTheme(
          const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(197, 46, 32, 11),
              Color.fromARGB(197, 130, 94, 39),
            ],
          ),
        ),
        AppTheme(
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(197, 130, 94, 39),
                  Color.fromARGB(180, 15, 4, 11)
                ]),
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(255, 47, 32, 10),
                  Color.fromARGB(255, 68, 67, 25),
                ]),
            const Color.fromARGB(255, 202, 168, 47),
            const Color.fromARGB(255, 100, 51, 23)),
        SliderTheme(const Color.fromARGB(255, 102, 52, 24),
            const Color.fromARGB(255, 59, 31, 14)),
        SubscriptionStoreTheme(Colors.brown.shade900, Colors.brown.shade700),
        Themes.brown);
  }

  /// ==============================================[GREY THEME]=======================================

  factory CustomTheme.grey() {
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
                Color.fromARGB(197, 47, 50, 52),
                Color.fromARGB(180, 15, 21, 28)
              ]),
        ),
        SwitchButtonTheme(Colors.blueGrey.shade200, 1),
        ThreeCashedButtonTheme(
          const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(197, 47, 50, 52),
              Color.fromARGB(180, 28, 37, 48)
            ],
          ),
        ),
        AppTheme(
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(197, 125, 129, 132),
                  Color.fromARGB(180, 44, 62, 80)
                ]),
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(197, 47, 50, 52),
                  Color.fromARGB(180, 15, 21, 28)
                ]),
            Colors.blueGrey,
            Colors.grey.shade400),
        SliderTheme(Colors.grey.shade400, Colors.blueGrey),
        SubscriptionStoreTheme(
            Colors.blueGrey.shade900, Colors.blueGrey.shade700),
        Themes.grey);
  }

  /// ==============================================[GREEN THEME]=======================================

  factory CustomTheme.green() {
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
                Color.fromARGB(197, 6, 190, 182),
                Color.fromARGB(180, 15, 4, 11)
              ]),
        ),
        SwitchButtonTheme(const Color.fromARGB(255, 80, 174, 183), 1),
        ThreeCashedButtonTheme(
          const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(219, 13, 124, 139),
              Color.fromARGB(255, 10, 84, 145),
            ],
          ),
        ),
        AppTheme(
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(197, 6, 190, 182),
                  Color.fromARGB(180, 15, 4, 11)
                ]),
            const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight, // #380036 > #0CBABA
                colors: [
                  Color.fromARGB(197, 13, 119, 114),
                  Color.fromARGB(180, 1, 7, 5)
                ]),
            const Color.fromARGB(255, 76, 167, 175),
            const Color.fromARGB(255, 44, 114, 113)),
        SliderTheme(Colors.blue, Colors.teal.shade900),
        SubscriptionStoreTheme(Colors.teal.shade900, Colors.teal.shade700),
        Themes.green);
  }

  /// ==============================================[BLUE THEME]=======================================

  factory CustomTheme.blueDefault() {
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
            Colors.blue.shade600),
        SliderTheme(Colors.indigo, Colors.indigo.shade800),
        SubscriptionStoreTheme(Colors.indigo.shade900, Colors.indigo.shade700),
        Themes.blueDefault);
  }

  /// ==============================================[PURPLE THEME]=======================================

  factory CustomTheme.purple() {
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
                Color.fromARGB(198, 59, 41, 81),
                Color.fromARGB(91, 0, 0, 0)
              ]),
        ),
        SwitchButtonTheme(Colors.deepPurple, 1),
        ThreeCashedButtonTheme(
          const LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [
              Color.fromARGB(199, 97, 67, 133),
              Color.fromARGB(91, 81, 99, 149)
            ],
          ),
        ),
        AppTheme(
          const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight, // #380036 > #0CBABA
              colors: [
                Color.fromARGB(199, 97, 67, 133),
                Color.fromARGB(91, 81, 99, 149)
              ]),
          const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight, // #380036 > #0CBABA
              colors: [
                Color.fromARGB(198, 59, 41, 81),
                Color.fromARGB(91, 0, 0, 0)
              ]),
          Colors.deepPurple,
          Colors.pink.shade900,
        ),
        SliderTheme(const Color.fromARGB(179, 99, 122, 184),
            const Color.fromARGB(91, 81, 99, 149)),
        SubscriptionStoreTheme(
            Colors.purple.shade900, const Color.fromARGB(199, 97, 67, 133)),
        Themes.purple);
  }

  static CustomTheme selectTheme({Themes theme = Themes.purple}) {
    switch (theme) {
      case Themes.orange:
        return CustomTheme.orange();
      case Themes.brown:
        return CustomTheme.brown();
      case Themes.grey:
        return CustomTheme.grey();
      case Themes.green:
        return CustomTheme.green();
      case Themes.purple:
        return CustomTheme.purple();

      default:
        return CustomTheme.blueDefault();
    }
  }
}

enum Themes { orange, brown, grey, green, blueDefault, purple }
