import 'package:flutter/material.dart';

class ThemeConfig {
  static Color lightPrimary = Colors.white;
  static Color darkPrimary = const Color(0xFF1F1F1F);
  static Color lightAccent = const Color(0xFFFFD700); // Yellow color
  static Color darkAccent = const Color(0xFFFFD700);
  static Color lightBG = Color.fromARGB(255, 255, 128, 0); // Adjusted dark peach color
  static Color darkBG = const Color(0xFF1F1F1F);

  static ThemeData lightTheme = ThemeData(
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: lightBG,
      brightness: Brightness.light,
    ),
    primaryColor: lightPrimary,
    scaffoldBackgroundColor: lightBG,
    appBarTheme: AppBarTheme(
      color: lightBG,
      elevation: 0.0,
      titleTextStyle: const TextStyle(
        color: Colors.black,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: const IconThemeData(
        color: Colors.black,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: lightAccent ?? Colors.blue, // Use yellow color for button background
        onPrimary: lightBG ?? Colors.white, // Use peach color for button text color
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: lightAccent ?? Colors.blue, // Use yellow color for text button text color
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSwatch().copyWith(
      secondary: darkBG,
      brightness: Brightness.dark,
    ),
    primaryColor: darkPrimary,
    scaffoldBackgroundColor: darkBG,
    appBarTheme: AppBarTheme(
      color: darkBG,
      elevation: 0.0,
      titleTextStyle: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        primary: darkAccent ?? Colors.blue,
        onPrimary: darkBG ?? Colors.black,
      ),
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        primary: darkAccent ?? Colors.blue,
      ),
    ),
  );
}
