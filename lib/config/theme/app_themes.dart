import 'package:flutter/material.dart';

ThemeData theme() {
  return ThemeData(
    scaffoldBackgroundColor: Colors.white,
    primaryColor: const Color(0xFF4A90E2),
    fontFamily: 'Muli',
    colorScheme: ColorScheme.fromSwatch().copyWith(
      primary: const Color(0xFF4A90E2),
      secondary: const Color(0xFF50E3C2),
    ),
    inputDecorationTheme: inputDecorationTheme(),
    elevatedButtonTheme: elevatedButtonThemeData(),
    appBarTheme: appBarTheme(),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Color(0xFF121212)),
      bodyMedium: TextStyle(color: Color(0xFF6E6E6E)),
    ),
  );
}

AppBarTheme appBarTheme() {
  return const AppBarTheme(
    backgroundColor: Colors.white,
    elevation: 1,
    centerTitle: true,
    iconTheme: IconThemeData(color: Color(0xFF4A4A4A)),
    titleTextStyle: TextStyle(
      color: Color(0xFF4A4A4A),
      fontSize: 18,
      fontWeight: FontWeight.w600,
    ),
  );
}

InputDecorationTheme inputDecorationTheme() {
  return const InputDecorationTheme(
    contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide: BorderSide(color: Color(0xFFE0E0E0)), // light gray
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      borderSide:
          BorderSide(color: Color(0xFF4A90E2), width: 1.5), // primary blue
    ),
  );
}

ElevatedButtonThemeData elevatedButtonThemeData() {
  return ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF4A90E2),
      foregroundColor: Colors.white,
      textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      padding: const EdgeInsets.symmetric(vertical: 16),
    ),
  );
}
