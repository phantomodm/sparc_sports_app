import 'package:flutter/foundation.dart';

class SparcLogger {
  static void log(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
  static void error(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
  static void info(String message) {
    if (kDebugMode) {
      print(message);
    }
  }
}