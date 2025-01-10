import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;

class AppTranslations {
  late Map<String, String> _localizedStrings;

  static AppTranslations of(BuildContext context) {
    return Localizations.of<AppTranslations>(context, AppTranslations)!;
  }

  Future<bool> load(Locale locale) async {
    final jsonStr =
        await rootBundle.loadString('lang/${locale.languageCode}.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonStr);
    _localizedStrings = jsonMap.map((key, value) {
      return MapEntry(key, value.toString());
    });
    return true;
  }

  String trans(BuildContext context, String key,
      {Map<String, String>? arguments}) {
    return AppTranslations.of(context).translate(key);
  }

  String translate(String key) {
    return _localizedStrings[key] ?? key;
  }
}

class AppTranslationsDelegate extends LocalizationsDelegate<AppTranslations> {
  const AppTranslationsDelegate();

  @override
  bool isSupported(Locale locale) {
    // Add all supported language codes here
    return ['en', 'es', 'ja', 'zh', 'de'].contains(locale.languageCode);
  }

  @override
  Future<AppTranslations> load(Locale locale) async {
    final translations = AppTranslations();
    await translations.load(locale);
    return translations;
  }

  @override
  bool shouldReload(AppTranslationsDelegate old) => false;

  bool isRTL(BuildContext context) {
    return Localizations.localeOf(context).languageCode == 'ar' ||
        Localizations.localeOf(context).languageCode == 'he';
  }
}
