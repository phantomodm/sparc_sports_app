import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:sparc_sports_app/bloc_observer.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/core/bloc/theme_bloc.dart';
import 'package:sparc_sports_app/src/core/boot/init.dart';
import 'package:sparc_sports_app/src/core/language/app_translations.dart';
import 'package:sparc_sports_app/src/core/routes/routes.dart';
import 'package:sparc_sports_app/src/core/themes/themes.dart';
import 'package:sparc_sports_app/src/store/bloc/state_management.dart';
import 'package:sparc_sports_app/src/store/pages/pages.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:woosignal/woosignal.dart';


Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized(); //GetIt Instances
  await Hive.initFlutter();
  setupLocator();
  await dotenv.load(fileName: '.env');
  await WooSignal.instance
      .init(appKey: dotenv.env['APP_KEY'])
      .then((value) => print('WooSignal initialized'));
  Bloc.observer = const SparcBlocObserver();
  initApp();
  runApp(MultiBlocProvider(
      providers: [
      BlocProvider<ProductBloc>(create: (context) => locator<ProductBloc>()),
      BlocProvider<CartBloc>(create: (context) => locator<CartBloc>()),
      BlocProvider<CheckoutBloc>(create: (context) => locator<CheckoutBloc>()),
      BlocProvider<DatastoreBloc>(
      create: (context) => locator<DatastoreBloc>()),
  ],
  child: const SparcApp()));

}

class SparcApp extends StatefulWidget {
  const SparcApp({super.key});

  @override
  State<SparcApp> createState() => _SparcAppState();
}

class _SparcAppState extends State<SparcApp> {
  final themeBloc = ThemeBloc();
  ThemeMode _currentThemeMode = ThemeMode.system;
  ThemeData _currentTheme = lightTheme;
  bool _largeFontsEnabled = false;

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
  }

  void _toggleLargeFonts() {
    setState(() {
      _largeFontsEnabled = !_largeFontsEnabled;
    });
  }

  void _toggleTheme() {
    setState(() {
      _currentThemeMode = _currentThemeMode == ThemeMode.light
          ? ThemeMode.dark
          : ThemeMode.light;
    });
  }

  // Add this function to your _MyAppState class
  void updateAppTheme(ThemeData newTheme) {
    setState(() {
      _currentTheme = newTheme;
    });
  }

  void _changeFontSize(double newFontSize) {
    // 1. Create a new TextTheme with the updated font size
    TextTheme newTextTheme = Theme
        .of(context)
        .textTheme
        .copyWith(
      displayLarge: Theme
          .of(context)
          .textTheme
          .displayLarge
          ?.copyWith(
        fontSize: newFontSize + 10,
      ),
      bodyMedium: Theme
          .of(context)
          .textTheme
          .bodyMedium
          ?.copyWith(
        fontSize: newFontSize,
      ),
      headlineLarge: Theme
          .of(context)
          .textTheme
          .headlineLarge
          ?.copyWith(
        fontSize: newFontSize + 6,
      ),
      bodyLarge: Theme
          .of(context)
          .textTheme
          .bodyLarge
          ?.copyWith(
        fontSize: newFontSize + 2,
      ),
      // ... update other text styles as needed
    );

    // 2. Update the app's theme
    setState(() {
      _currentTheme = Theme.of(context).copyWith(textTheme: newTextTheme);
    });
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<ThemeData>( // Use a StreamBuilder
        stream: themeBloc.themeStream,
        initialData: lightTheme, // Provide an initial theme
        builder: (context, snapshot) {
          _currentTheme = snapshot.data ?? lightTheme;
          return MaterialApp(
            title: 'Sparc Sports App',
            localizationsDelegates: const [
              AppTranslationsDelegate(), // Your translations delegate
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en', 'US'),
              Locale('es', 'ES'),
              Locale('ja', 'JP'),
              Locale('zh', 'CN'),
              Locale('de', 'DE'),
            ],
            theme: _currentTheme,
            // Use _currentTheme here
            darkTheme: darkTheme,
            // You can still have a separate darkTheme
            themeMode: _currentThemeMode,
            // Add this to enable dynamic theme switching
            home: HomePage(),
            routes: appRoutes,
          );
        }
    );
  }
}
