
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:woosignal/models/response/woosignal_app.dart';

class AppConfig {
  AppConfig({

    this.wpLoginEnabled,
    this.wpLoginBaseUrl,
    this.wpLoginWpApiPath,
    this.locale,
    required this.lightTheme,
    required this.darkTheme,
    // Add other properties as needed
    required this.fontFamily,
    required this.primaryColor,
    required this.secondaryColor,
    required this.appBarBackgroundColor,
    required this.appBarTextColor,
    required this.bodyTextColor,
    required this.hintTextColor,
    required this.iconColor,
  });


  final int? wpLoginEnabled;
  final String? wpLoginBaseUrl;
  final String? wpLoginWpApiPath;
  final String? locale;
  final ThemeData lightTheme;
  final ThemeData darkTheme;

  // Additional properties for theme customization
  final String fontFamily;
  final Color primaryColor;
  final Color secondaryColor;
  final Color appBarBackgroundColor;
  final Color appBarTextColor;
  final Color bodyTextColor;
  final Color hintTextColor;
  final Color iconColor;
}

class AppHelper {
  AppHelper._privateConstructor();

  static final AppHelper instance = AppHelper._privateConstructor();

  WooSignalApp? appConfig;

  final Map<String, dynamic> _validationRules = {};

   /// Add [validators] to Nylo
  addValidationRules(Map<String, dynamic> validators) {
    _validationRules.addAll(validators);
  }

  /// Get [validators] from Nylo
  Map<String, dynamic> getValidationRules() => _validationRules;

}

class SharedKey {
  static const String authUser = "DEFAULT_SP_USER";
  static const String cart = "CART_SESSION";
  static const String customerBillingDetails = "CS_BILLING_DETAILS";
  static const String customerShippingDetails = "CS_SHIPPING_DETAILS";
  static const String wishlistProducts = "CS_WISHLIST_PRODUCTS";
}

