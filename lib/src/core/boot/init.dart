import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:sparc_sports_app/src/store/classes/app_config.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import 'package:sparc_sports_app/src/store/services/product_service.dart';
import 'package:woosignal/models/response/woosignal_app.dart';
import 'package:woosignal/woosignal.dart';
import 'package:wp_json_api/wp_json_api.dart';

import '../../store/bloc/state_management.dart';
import '../themes/themes.dart';


class Environment {
  Future<void> loadEnv(path) async {
    await dotenv.load(fileName: path);
  }

  String get app_key {
    return dotenv.env['APP_KEY'] ?? 'APP_KEY';
  }

  bool get app_debug {
    return dotenv.env['APP_DEBUG']?.toLowerCase() == 'true' || false;
  }

  String get app_name {
    return dotenv.env['APP_NAME'] ?? 'Sparc';
  }

  String get product_placeholder_image {
    return dotenv.env['PRODUCT_PLACEHOLDER_IMAGE'] ??
        'https://via.placeholder.com/150';
  }

  bool get stripe_live {
    return dotenv.env['STRIPE_LIVE_MODE']?.toLowerCase() == 'true' || false;
  }

  String get stripe_account {
    return dotenv.env['STRIPE_ACCOUNT'] ?? 'STRIPE_ACCOUNT';
  }

  String get api_base_url {
    return dotenv.env['API_BASE_URL'] ?? 'API_BASE_URL';
  }

  String get encrypt_key {
    return dotenv.env['ENCRYPT_KEY'] ?? 'NULL';
  }

  String get encrypt_secret {
    return dotenv.env['ENCRYPT_SECRET'] ?? 'NULL';
  }

  String get default_locale {
    return dotenv.env['DEFAULT_LOCALE'] ?? 'en';
  }
}

final env = Environment();
late final SharedPreferences prefs;
ProductService productService = locator<ProductService>();

Future<void> initApp() async {
  prefs = await SharedPreferences.getInstance();
  print('Initiating App');

  final productData = await WooSignal.instance.getProducts();

  // 1. Set up device orientation
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final appConfig = AppConfig(
    fontFamily: 'Poppins',
    primaryColor: const Color(0xFF041e42),
    secondaryColor: const Color(0xFFBB0021),
    appBarBackgroundColor: const Color(0xFF041e42),
    appBarTextColor: Colors.white,
    bodyTextColor: Colors.white,
    hintTextColor: Colors.white54,
    iconColor: Colors.white,
    lightTheme: lightTheme,
    darkTheme: darkTheme,
  );

  // Initialize DataStore with a name
  final dataStore = locator<DatastoreBloc>();
  dataStore.add(SetData('sparc', appConfig));

  locator.registerSingleton<AppConfig>(appConfig);
  AppHelper.instance.appConfig = WooSignalApp();
  AppHelper.instance.appConfig!.themeFont = "Poppins";

  // 3. Fetch WooSignal app data
  WooSignalApp? wooSignalApp =
      await (appWooSignal((api) => api.getApp(encrypted: shouldEncrypt()))) ??
          WooSignalApp(); // Use default WooSignalApp if null

  // 4. Determine locale
  Locale locale;
  if (wooSignalApp?.locale != null) {
    locale = Locale(wooSignalApp?.locale ?? 'en');
  } else {
    locale = Locale(envVal('DEFAULT_LOCALE', defaultValue: 'en'));
  }

  AppHelper.instance.appConfig?.locale = locale.languageCode;

  if (wooSignalApp != null) {
    AppHelper.instance.appConfig = wooSignalApp;

    if (wooSignalApp.wpLoginEnabled == 1) {
      if (wooSignalApp.wpLoginBaseUrl == null) {
        AppHelper.instance.appConfig?.wpLoginEnabled = 0;
        print(
            'Set your stores domain on WooSignal. Go to Features > WP Login and add your domain to "Store Base Url"');
      }

      if (wooSignalApp.wpLoginWpApiPath == null) {
        AppHelper.instance.appConfig?.wpLoginEnabled = 0;
        print(
            'Set your stores Wp JSON path on WooSignal. Go to Features > WP Login and add your Wp JSON path to "WP API Path"');
      }

      WPJsonAPI.instance.init(
        baseUrl: wooSignalApp.wpLoginBaseUrl ?? "",
        shouldDebug: env.app_debug,
        wpJsonPath: wooSignalApp.wpLoginWpApiPath ?? "",
      );
    }


  }

  // 6. (Optional) Initialize WPJsonAPI if needed
  if (AppHelper.instance.appConfig!.wpLoginEnabled == 1) {
    WPJsonAPI.instance.init(
      baseUrl: AppHelper.instance.appConfig!.wpLoginBaseUrl ?? "",
      shouldDebug: env.app_debug,
      wpJsonPath: AppHelper.instance.appConfig!.wpLoginWpApiPath ?? "",
    );
  }


}
