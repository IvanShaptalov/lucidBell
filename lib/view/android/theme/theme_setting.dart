import 'package:flutter/material.dart';

class ThemeSetting {
  static loadCalmTheme() {
    return ThemeData(
      // Define the default brightness and colors.
      brightness: Brightness.dark,
      scaffoldBackgroundColor: Colors.black87,
      primaryColor: Color.fromARGB(148, 0, 0, 0),
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
}
