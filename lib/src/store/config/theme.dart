import 'package:flutter/material.dart';

/*
|--------------------------------------------------------------------------
| Flutter Themes
| Run the below in the terminal to add a new theme.
| "dart run nylo_framework:main make:theme bright_theme"
|
| Learn more: https://nylo.dev/docs/5.x/themes-and-styling
|--------------------------------------------------------------------------
*/

// App Themes
// final List<BaseThemeConfig<ColorStyles>> appThemes = [
//   BaseThemeConfig<ColorStyles>(
//     id: getEnv('LIGHT_THEME_ID'),
//     description: "Light theme",
//     theme: lightTheme,
//     colors: LightThemeColors(),
//   ),
//   BaseThemeConfig<ColorStyles>(
//     id: getEnv('DARK_THEME_ID'),
//     description: "Dark theme",
//     theme: darkTheme,
//     colors: DarkThemeColors(),
//   ),
// ];

// Light Theme
ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  fontFamily: 'Poppins',
  primaryColor: const Color(0xFF041e42), // Primary color
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFFBB0021),
      brightness: Brightness.light), // Secondary color as seed
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFF041e42), // Primary color
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white, // Icons in app bar will be white
    ),
  ),
  scaffoldBackgroundColor: Colors.white, // White background
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Color(0xFF041e42), // Primary color for headlines
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      color: Color(0xFFBB0021), // Secondary color for titles
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.black87,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFFBB0021), // Secondary color for buttons
      foregroundColor: Colors.white, // Button text color
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: InputDecorationTheme(
    // Customize your text field theme here
    // hintStyle: TextStyle(color: const Color(0xFF041e42).withValues(alpha: 0.5))
    hintStyle: TextStyle(color: const Color(0xFF041e42).withOpacity(0.5)),
    // ... other text field styles
  ),
);

// Dark Theme
ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  fontFamily: 'Poppins',
  primaryColor: const Color(0xFFBB0021), // Secondary color (for contrast)
  colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF041e42),
      brightness: Brightness.dark,), // Primary color as seed
  appBarTheme: const AppBarTheme(
    backgroundColor: Color(0xFFBB0021), // Secondary color
    titleTextStyle: TextStyle(
      color: Colors.white,
      fontSize: 20,
      fontWeight: FontWeight.bold,
    ),
    iconTheme: IconThemeData(
      color: Colors.white, // Icons in app bar will be white
    ),
  ),
  scaffoldBackgroundColor: const Color(0xFF212121), // Dark background
  textTheme: const TextTheme(
    headlineSmall: TextStyle(
      fontSize: 24,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    ),
    titleLarge: TextStyle(
      fontSize: 20,
      color: Color(0xFF041e42), // Primary color for titles
    ),
    bodyMedium: TextStyle(
      fontSize: 16,
      color: Colors.white70,
    ),
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: const Color(0xFF041e42), // Primary color for buttons
      foregroundColor: Colors.white, // Button text color
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  inputDecorationTheme: const InputDecorationTheme(
    // Customize your text field theme here
    hintStyle: TextStyle(color: Colors.white54),
    // ... other text field styles
  ),
);
