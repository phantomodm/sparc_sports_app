import 'dart:async';
import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/themes/app_themes.dart';


class ThemeBloc {
  final _themeController = StreamController<ThemeData>.broadcast();
  Stream<ThemeData> get themeStream => _themeController.stream;

  void changeTheme(ThemeData newTheme) {
    _themeController.sink.add(newTheme);
  }
  void changeFontSize(double newFontSize, ThemeData currentTheme) {
    TextTheme newTextTheme = currentTheme.textTheme.copyWith(
      displayLarge: currentTheme.textTheme.displayLarge?.copyWith(
        fontSize: newFontSize + 10,
      ),
      bodyMedium: currentTheme.textTheme.bodyMedium?.copyWith(
        fontSize: newFontSize,
      ),
      headlineLarge: currentTheme.textTheme.headlineLarge?.copyWith(
        fontSize: newFontSize + 6,
      ),
      bodyLarge: currentTheme.textTheme.bodyLarge?.copyWith(
        fontSize: newFontSize + 2,
      ),
      // ... update other text styles as needed
    );
    _themeController.sink.add(currentTheme.copyWith(textTheme: newTextTheme));
  }

  void toggleDarkMode(ThemeData currentTheme) {
    _themeController.sink.add(
      currentTheme.brightness == Brightness.light ? darkTheme : lightTheme,
    );
  }

  void toggleLargeFonts(bool isEnabled, ThemeData currentTheme) {
    TextTheme newTextTheme = isEnabled
        ? currentTheme.textTheme.copyWith(
      bodyLarge: currentTheme.textTheme.bodyLarge?.copyWith(
        fontSize: AppFonts.accessibleBodyFontSize,
      ),
      headlineLarge: currentTheme.textTheme.headlineLarge?.copyWith(
        fontSize: AppFonts.accessibleHeadingFontSize,
      ),
      // ... adjust other text styles as needed
    )
        : currentTheme.textTheme; // Revert to the original textTheme

    _themeController.sink.add(currentTheme.copyWith(textTheme: newTextTheme));
  }

  void toggleHighContrast(bool isEnabled, ThemeData currentTheme) {
    if (isEnabled) {
      // Apply high contrast theme based on current brightness
      _themeController.sink.add(
        currentTheme.brightness == Brightness.light
            ? highContrastLightTheme
            : highContrastDarkTheme,
      );
    } else {
      // Revert to the original theme based on current brightness
      _themeController.sink.add(
        currentTheme.brightness == Brightness.light ? lightTheme : darkTheme,
      );
    }
  }

  // --------------------------------------

  void dispose() {
    _themeController.close();
  }
}