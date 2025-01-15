import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/bloc/theme_bloc.dart';

class AppFonts {
  static const String headingFont = 'Bebas Neue';
  static const String bodyFont = 'Lato';

  // Spacing and Styling
  static const double headingLetterSpacing = 1.0;
  static const double bodyLineHeight = 1.4;

  static const Color primaryColor = Color(0xFF041E42);
  static const Color secondaryColor = Color(0xFFBB0021);
  static const Color tertiaryColor = Color(0xFF009688); // Sporty green

  static const Color primaryLight = Color(
      0xFF36618E); // Lighter variation of primary
  static const Color secondaryLight = Color(
      0xFFD9535F); // Lighter variation of secondary
  //Fonts
  static const double displayLargeFontSize = 48.0;
  static const double bodyMediumFontSize = 16.0;
  static const double headlineLargeFontSize = 32.0; // Example value
  static const double bodyLargeFontSize = 20.0;
  static const FontWeight headingFontWeight = FontWeight.w700;

  // Larger Font Sizes for Accessibility
  static const double accessibleBodyFontSize = 24.0;
  static const double accessibleHeadingFontSize = 36.0;

  // High Contrast Colors for Accessibility
  static const Color highContrastBlack = Color(0xFF000000); // Pure black
  static const Color highContrastWhite = Color(0xFFFFFFFF); // Pure white
  // Gradients
  static const LinearGradient appBarGradient = LinearGradient(
    colors: [primaryColor, primaryLight],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
  final ThemeData highContrastLightTheme = ThemeData(
    brightness: Brightness.light,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppFonts.highContrastBlack,
      onPrimary: AppFonts.highContrastWhite,
      onSecondary: AppFonts.highContrastWhite,
      onSurface: AppFonts.highContrastWhite,
    ),
    // ... other high contrast properties for light theme
  );

  final ThemeData highContrastDarkTheme = ThemeData(
    brightness: Brightness.dark,
    colorScheme: ColorScheme.fromSeed(
      seedColor: AppFonts.highContrastWhite,
      onPrimary: AppFonts.highContrastBlack,
      onSecondary: AppFonts.highContrastBlack,
      onSurface: AppFonts.highContrastBlack,
    ),
    // ... other high contrast properties for dark theme
  );

}

class AppThemes {
  static ThemeData get lightTheme => lightTheme;
  static ThemeData get darkTheme => darkTheme;

  static ThemeBloc _themeBloc = ThemeBloc(); // Add this line

  // Access theme properties like this:
  // Access theme properties like this:
  static TextStyle? get headline5 =>
      _themeBloc.currentTheme.textTheme.headlineMedium?.copyWith(
        fontFamily: AppFonts.headingFont,
        fontWeight: AppFonts.headingFontWeight,
        color: _themeBloc.currentTheme.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      );
  static TextStyle? get headline6 =>
      _themeBloc.currentTheme.textTheme.headlineLarge?.copyWith(
        fontFamily: AppFonts.headingFont,
        fontWeight: AppFonts.headingFontWeight,
        letterSpacing: AppFonts.headingLetterSpacing,
        color: _themeBloc.currentTheme.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      );
  static TextStyle? get subtitle1 =>
      _themeBloc.currentTheme.textTheme.headlineSmall?.copyWith(
        fontFamily: AppFonts.bodyFont,
        fontWeight: FontWeight.w500,
        color: _themeBloc.currentTheme.brightness == Brightness.light
            ? Colors.black87
            : Colors.white70,
      );
  static TextStyle? get subtitle2 =>
      _themeBloc.currentTheme.textTheme.bodyMedium?.copyWith(
        fontFamily: AppFonts.bodyFont,
        height: AppFonts.bodyLineHeight,
        color: _themeBloc.currentTheme.brightness == Brightness.light
            ? Colors.black54
            : Colors.white60,
      );

  static TextStyle? get bodyText1 =>
      _themeBloc.currentTheme.textTheme.bodyLarge?.copyWith(
        fontFamily: AppFonts.bodyFont,
        color: _themeBloc.currentTheme.brightness == Brightness.light
            ? Colors.black
            : Colors.white,
      );

  static TextStyle? get bodyText2 =>
      _themeBloc.currentTheme.textTheme.bodyMedium?.copyWith(
        fontFamily: AppFonts.bodyFont,
        color: _themeBloc.currentTheme.brightness == Brightness.light
            ? Colors.black87
            : Colors.white70,
      );

  static TextStyle? get caption =>
      _themeBloc.currentTheme.textTheme.bodySmall?.copyWith(
        fontFamily: AppFonts.bodyFont,
        color: _themeBloc.currentTheme.brightness == Brightness.light
            ? Colors.black54
            : Colors.white60,
      );
  static Color? get primaryColor => _themeBloc.currentTheme.primaryColor;
}

final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  buttonTheme: ButtonThemeData(
    alignedDropdown: false,
    colorScheme: ColorScheme(
      surface: Color(0xFF212121),
      // Use surface for background
      brightness: Brightness.dark,
      error: Color(0xFFFF9800),
// ... (You might want to adjust other ColorScheme values
//     for better contrast in dark mode)
      onSurface: Color(0xFFEEEEEE),

      primary: Color(0xFF29435C),
      secondary: Color(0xFFBB0021),
      tertiary: Color(0xFF00796B),
      onPrimary: Color(0xFFFFFFFF),
      onSecondary: Color(0xFFFFFFFF),
      onError: Color(0xFFFFFFFF),
    ),
  ),
  canvasColor: Color(0xFF121212),
  cardColor: Color(0xFF212121),
  colorScheme: ColorScheme(
    surface: Color(0xFF212121),
    // Use surface for background
    brightness: Brightness.dark,
    error: Color(0xFFFF9800),
// ... (You might want to adjust other ColorScheme values
//     for better contrast in dark mode)
    onSurface: Color(0xFFEEEEEE),
    // For elements on the surface
    primary: Color(0xFF29435C),
    secondary: Color(0xFFBB0021),
    tertiary: Color(0xFF00796B),
    onPrimary: Color(0xFFFFFFFF),
    onSecondary: Color(0xFFFFFFFF),
    onError: Color(0xFFFFFFFF),
  ),
  dialogBackgroundColor: Color(0xFF121212),
  dividerColor: Color(0x1FFFFFFF),
  iconTheme: IconThemeData(
    color: Color(0xFFBDBDBD),
  ),
  indicatorColor: Color(0xFF29435C),
  primaryTextTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFF121212),
// ... (other text styles)
    ),
// ... (other text styles)
  ),
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppFonts.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  scaffoldBackgroundColor: Color(0xFF121212),
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: AppFonts.headingFont,
      letterSpacing: AppFonts.headingLetterSpacing,
      fontSize: AppFonts.displayLargeFontSize,
      fontWeight: AppFonts.headingFontWeight,
      color: Colors.white, // Explicitly set color for dark theme
    ),
    bodyMedium: TextStyle(
      fontFamily: AppFonts.bodyFont,
      letterSpacing: 0.25, // Use letterSpacing, not bodyLineHeight
      height: AppFonts.bodyLineHeight,
      fontSize: AppFonts.bodyMediumFontSize,
      color: Colors.white, // Explicitly set color for dark theme
      fontFamilyFallback: const [
        'Open Sans',
        'Segoe UI',
        'Verdana',
      ],
    ),
    headlineLarge: TextStyle(
      fontFamily: AppFonts.headingFont,
      letterSpacing: AppFonts.headingLetterSpacing,
      fontSize: AppFonts.headlineLargeFontSize, // Use the new font size constant
      color: Colors.white, // Explicitly set color for dark theme
      fontFamilyFallback: const [
        'Roboto Condensed',
        'Oswald',
        'Arial',
        'Helvetica',
      ],
    ),
    bodyLarge: TextStyle(
      fontFamily: AppFonts.bodyFont, // Use bodyFont, not headingFont
      fontSize: AppFonts.bodyLargeFontSize, // Use the new font size constant
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.white, // Explicitly set color for dark theme
    ),
  ),
  appBarTheme: AppBarTheme(
    backgroundColor: Color(0xFF29435C),
    foregroundColor: Colors.white,
    elevation: 4,
  ),
);

final ThemeData highContrastDarkTheme = ThemeData(
  brightness: Brightness.dark,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppFonts.highContrastWhite,
    onPrimary: AppFonts.highContrastBlack,
    onSecondary: AppFonts.highContrastBlack,
    onSurface: AppFonts.highContrastBlack,
  ),
  // ... other high contrast properties for dark theme
);


final ThemeData lightTheme = ThemeData(
  appBarTheme: AppBarTheme(

    backgroundColor: Color(0xFF041E42), // Your primary color
    foregroundColor: Colors.white, // Text and icon color
    elevation: 4, // Add a subtle shadow

  ),
  buttonTheme: ButtonThemeData(
    alignedDropdown: false,
    colorScheme: ColorScheme(
      surface: Color(0xFFFFFFFF),
      brightness: Brightness.light,
      error: Color(0xFFFF9800),
      errorContainer: Color(0xFFFFE9C4),
      inversePrimary: Color(0xFFA0CAFD),
      inverseSurface: Color(0xFF2E3135),
      onSurface: Color(0xFF191C20),
      onError: Color(0xFFFFFFFF),
      onErrorContainer: Color(0xFF410002),
      onInverseSurface: Color(0xFFEFF0F7),
      onPrimary: Color(0xFFFFFFFF),
      onPrimaryContainer: Color(0xFF001B3F),
      onSecondary: Color(0xFFFFFFFF),
      onSecondaryContainer: Color(0xFF410005),
      onSurfaceVariant: Color(0xFF43474E),
      onTertiary: Color(0xFFFFFFFF),
      onTertiaryContainer: Color(0xFF251431),
      outline: Color(0xFF73777F),
      outlineVariant: Color(0xFFC3C7CF),
      primary: Color(0xFF041E42),
      primaryContainer: Color(0xFFD7E2FF),
      scrim: Color(0xFF000000),
      secondary: Color(0xFFBB0021),
      secondaryContainer: Color(0xFFFFDAD7),
      shadow: Color(0xFF000000),
      surfaceContainerHighest: Color(0xFFE1E2E8),
      surfaceTint: Color(0xFF36618E),
      tertiary: Color(0xFF009688),
      tertiaryContainer: Color(0xFFF2DAFF),
    ),
    height: 36,
    layoutBehavior: ButtonBarLayoutBehavior.padded,
    minWidth: 88,
    padding: EdgeInsets.symmetric(horizontal: 16),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.elliptical(2, 2)),
      side: BorderSide(
        color: Color(0xFF000000),
        strokeAlign: BorderSide.strokeAlignInside,
        style: BorderStyle.none,
        width: 0,
      ),
    ),
    textTheme: ButtonTextTheme.normal,
  ),
  canvasColor: Color(0xFFFFFFFF),
  cardColor: Color(0xFFF5F5F5),
  colorScheme: ColorScheme(
    surface: Color(0xFFFFFFFF),
    brightness: Brightness.light,
    error: Color(0xFFFF9800),
    errorContainer: Color(0xFFFFE9C4),
    inversePrimary: Color(0xFFA0CAFD),
    inverseSurface: Color(0xFF2E3135),
    onSurface: Color(0xFF191C20),
    onError: Color(0xFFFFFFFF),
    onErrorContainer: Color(0xFF410002),
    onInverseSurface: Color(0xFFEFF0F7),
    onPrimary: Color(0xFFFFFFFF),
    onPrimaryContainer: Color(0xFF001B3F),
    onSecondary: Color(0xFFFFFFFF),
    onSecondaryContainer: Color(0xFF410005),
    onSurfaceVariant: Color(0xFF43474E),
    onTertiary: Color(0xFFFFFFFF),
    onTertiaryContainer: Color(0xFF251431),
    outline: Color(0xFF73777F),
    outlineVariant: Color(0xFFC3C7CF),
    primary: Color(0xFF041E42),
    primaryContainer: Color(0xFFD7E2FF),
    scrim: Color(0xFF000000),
    secondary: Color(0xFFBB0021),
    secondaryContainer: Color(0xFFFFDAD7),
    shadow: Color(0xFF000000),
    surfaceContainerHighest: Color(0xFFE1E2E8),
    surfaceTint: Color(0xFF36618E),
    tertiary: Color(0xFF009688),
    tertiaryContainer: Color(0xFFF2DAFF),
  ),
  dialogBackgroundColor: Color(0xFFFFFFFF),
  disabledColor: Color(0x61000000),
  dividerColor: Color(0x1F191C20),
  focusColor: Color(0x1F000000),
  fontFamily: AppFonts.bodyFont,
  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      backgroundColor: AppFonts.primaryColor,
      foregroundColor: Colors.white,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      textStyle: const TextStyle(fontSize: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
    ),
  ),
  highlightColor: Color(0x66BCBCBC),
  hintColor: Color(0x99000000),
  hoverColor: Color(0x0A000000),
  iconTheme: IconThemeData(
    color: Color(0xDD000000),
  ),
  indicatorColor: Color(0xFFFFFFFF),
  inputDecorationTheme: InputDecorationTheme(
    alignLabelWithHint: false,
    filled: false,
    floatingLabelAlignment: FloatingLabelAlignment.start,
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    isCollapsed: false,
    isDense: false,
  ),
  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
  platform: TargetPlatform.windows,
  primaryColor: Color(0xFF041E42),
  primaryColorDark: Color(0xFF1976D2),
  primaryColorLight: Color(0xFFBBDEFB),
  primaryIconTheme: IconThemeData(
    color: Color(0xFFFFFFFF),
  ),
  primaryTextTheme: TextTheme(
    bodyLarge: TextStyle(
      color: Color(0xFFFFFFFF),
      decoration: TextDecoration.none,
      decorationColor: Color(0xFFFFFFFF),
      fontFamily: AppFonts.headingFont,
      fontSize: 16,
      fontWeight: FontWeight.w400,
      inherit: false,
      letterSpacing: 0.5,
      textBaseline: TextBaseline.alphabetic,
    ),
    bodyMedium: TextStyle(
      color: Color(0xFFFFFFFF),
      decoration: TextDecoration.none,
      decorationColor: Color(0xFFFFFFFF),
      fontFamily: AppFonts.bodyFont,
      fontSize: 14,
      fontWeight: FontWeight.w400,
      inherit: false,
      letterSpacing: 0.25,
      textBaseline: TextBaseline.alphabetic,
    ),
    // ... (rest of the text styles)
  ),
  scaffoldBackgroundColor: Color(0xFFFFFFFF),
  secondaryHeaderColor: Color(0xFFE3F2FD),
  shadowColor: Color(0xFF000000),
  splashColor: Color(0x66C8C8C8),
  splashFactory: InkRipple.splashFactory,
  textTheme: TextTheme(
    displayLarge: TextStyle(
      fontFamily: AppFonts.headingFont,
      letterSpacing: AppFonts.headingLetterSpacing,
      fontSize: AppFonts.displayLargeFontSize,
      fontWeight: AppFonts.headingFontWeight,
      color: Colors.black, // Explicitly set color for light theme
    ),
    bodyMedium: TextStyle(
      fontFamily: AppFonts.bodyFont,
      letterSpacing: 0.25, // Use letterSpacing, not bodyLineHeight
      height: AppFonts.bodyLineHeight,
      fontSize: AppFonts.bodyMediumFontSize,
      color: Colors.black, // Explicitly set color for light theme
      fontFamilyFallback: const [
        'Open Sans',
        'Segoe UI',
        'Verdana',
      ],
    ),
    headlineLarge: TextStyle(
      fontFamily: AppFonts.headingFont,
      letterSpacing: AppFonts.headingLetterSpacing,
      fontSize: AppFonts.headlineLargeFontSize, // Use the new font size constant
      color: Colors.black, // Explicitly set color for light theme
      fontFamilyFallback: const [
        'Roboto Condensed',
        'Oswald',
        'Arial',
        'Helvetica',
      ],
    ),
    bodyLarge: TextStyle(
      fontFamily: AppFonts.bodyFont, // Use bodyFont, not headingFont
      fontSize: AppFonts.bodyLargeFontSize, // Use the new font size constant
      fontWeight: FontWeight.w400,
      letterSpacing: 0.5,
      color: Colors.black, // Explicitly set color for light theme
    ),
    // High contrast theme for accessibility
  ),

  typography: Typography.material2021(
    dense: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        inherit: false,
        leadingDistribution: TextLeadingDistribution.even,
        letterSpacing: 0.5,
        textBaseline: TextBaseline.ideographic,
      ),
    ),
    englishLike: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        inherit: false,
        leadingDistribution: TextLeadingDistribution.even,
        letterSpacing: 0.5,
        textBaseline: TextBaseline.alphabetic,
      ),
      // ... (rest of the text styles)
    ),
    tall: TextTheme(
      bodyLarge: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 1.5,
        inherit: false,
        leadingDistribution: TextLeadingDistribution.even,
        letterSpacing: 0.5,
        textBaseline: TextBaseline.alphabetic,
      ),
      // ... (rest of the text styles)
    ),
  ),
  unselectedWidgetColor: Color(0x8A000000),
  useMaterial3: true,
  visualDensity: VisualDensity.compact,
);

final ThemeData highContrastLightTheme = ThemeData(
  brightness: Brightness.light,
  colorScheme: ColorScheme.fromSeed(
    seedColor: AppFonts.highContrastBlack,
    onPrimary: AppFonts.highContrastWhite,
    onSecondary: AppFonts.highContrastWhite,
    onSurface: AppFonts.highContrastWhite,
  ),
  // ... other high contrast properties for light theme
);
