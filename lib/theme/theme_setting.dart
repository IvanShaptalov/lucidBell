import 'package:flutter/material.dart';

class ThemeSetting {
  static dynamic loadTheme() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black87,
      primaryColor: Colors.lightBlue[800],

      // Define the default font family.
      fontFamily: 'Georgia',

      // Define the default `TextTheme`. Use this to specify the default
      // text styling for headlines, titles, bodies of text, and more.
      textTheme: const TextTheme(
        displayLarge: TextStyle(fontSize: 72.0, fontWeight: FontWeight.bold),
        titleLarge: TextStyle(fontSize: 36.0, fontStyle: FontStyle.italic),
        bodyMedium: TextStyle(fontSize: 14.0, fontFamily: 'Hind'),
      ),
    );
  }
}
