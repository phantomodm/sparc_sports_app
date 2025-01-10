import 'package:sparc_sports_app/src/store/config/event_bus/speedforce_event_bus.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ToastHelper {
  //SpeedForce flash = SpeedForce();

  void showToast({
    required BuildContext context,
    String? title,
    required String description,
    ToastNotificationStyleType? style,
    ToastGravity gravity = ToastGravity.BOTTOM,
  }) {
    // Determine the background color based on the style
    Color backgroundColor;
    Color textColor = Colors.white;
    switch (style) {
      case ToastNotificationStyleType.SUCCESS:
        backgroundColor = Colors.green;
        break;
      case ToastNotificationStyleType.DANGER:
        backgroundColor = Colors.red;
        break;
      case ToastNotificationStyleType.WARNING:
        backgroundColor = Colors.orange;
        break;
      // Add more cases for other ToastNotificationStyleType values
      default:
        backgroundColor = Colors.grey; // Default color
    }

    Fluttertoast.showToast(
      msg: description,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  

  void showToastNotification(
    BuildContext context,
    {required String title,
    String? subtitle,
    required String description,
    required ToastNotificationStyleType style,
    IconData? icon,
    dynamic duration = 3,
  }) {
    switch (style) {
      case ToastNotificationStyleType.SUCCESS:
        showToastSuccess(
          context: context,
          title: title,
          description: description,
          style: style,
        );
        break;
      case ToastNotificationStyleType.DANGER:
        showToastError(
          context: context,
          title: title,
          description: description,
          style: style,
        );
        break;
      case ToastNotificationStyleType.WARNING:
        showToastWarning(
          context: context,
          title: title,
          description: description,
          style: style,
        );
        break;
      case ToastNotificationStyleType.INFO:
        showToastInfo(
          context: context,
          title: title,
          description: description,
          style: style,
        );
        break;
      // Add more cases for other ToastNotificationStyleType values as needed
      default:
        // Handle the default case or throw an error
        showToast(
          context: context,
          title: title,
          description: '$title\n$description',
          style: style,
        );
    }
  }

  /// Displays a Toast message containing "Sorry" for the title, you
  /// only need to provide a [description].
  static void showToastSuccess(
      {required BuildContext context,
      String? title,
      required String description,
      required ToastNotificationStyleType style}) {
    SpeedForce.instance.fire(ToastSuccessEvent(
      context:context,
      title: title ?? "Success",
      description: description,
      style: style,
      icon: Icons.check_circle,
    ));
  }

  /// Displays a Toast message containing "Oops" for the title, you
  /// only need to provide a [description].
  static void showToastOops(
      {required BuildContext context,
      String? title,
      required String description,
      required ToastNotificationStyleType style}) {
    SpeedForce.instance.fire(ToastWarningEvent(
      context:context,
      title: title ?? "Oops!",
      description: description,
      style: style,
      icon: Icons.report_problem
    ));
  }

  static void showToastError(
      {required BuildContext context,
      String? title,
      required String description,
      required ToastNotificationStyleType style}) {
    SpeedForce.instance.fire(ToastErrorEvent(
      context:context,
      title: title ?? "Error",
      description: description,
      style: style,
      icon: Icons.error,
    ));
  }

  /// Displays a Toast message containing "Warning" for the title, you
  /// only need to provide a [description].
  static void showToastWarning(
      {required BuildContext context,
      String? title,
      required String description,
      required ToastNotificationStyleType style}) {
    SpeedForce.instance.fire(ToastWarningEvent(
      context:context,
      title: title ?? "Warning",
      description: description,
      style: style,
      icon: Icons.warning,
    ));
  }

  /// Displays a Toast message containing "Error" for the title, you
  /// only need to provide a [description].
  static void showToastDanger(
      {required BuildContext context,
      String? title,
      required String description,
      required ToastNotificationStyleType style}) {
    SpeedForce.instance.fire(ToastErrorEvent(
      context:context,
      title: title ?? "Danger",
      description: description,
      style: style,
      icon: Icons.report_problem
    ));
  }

  static void showToastCustom(
      {required BuildContext context,
      String? title,
      required String description,
      required ToastNotificationStyleType style}) {
    SpeedForce.instance.fire(ToastInfoCustom(
      context:context,
      title: title ?? "Custom",
      description: description,
      style: style,
    ));
  }

  /// Displays a Toast message containing "Info" for the title, you
  /// only need to provide a [description].
  static void showToastInfo(
      {required BuildContext context,
      String? title,
      required String description,
      required ToastNotificationStyleType style}) {
    SpeedForce.instance.fire(ToastInfoEvent(
      context:context,
      title: title ?? "Info",
      description: description,
      style: style,
      icon: Icons.info,
    ));
  }
}

class ToastEvent {
  final String title;
  final String description;
  final ToastNotificationStyleType style;
  final BuildContext context;
  final IconData? icon;

  ToastEvent({
    required this.context,
    required this.title,
    required this.description,
    required this.style,
    this.icon
  });
}

// Define toast event classes
class ToastSuccessEvent extends ToastEvent {
  ToastSuccessEvent({
    required super.context,
    required super.title,
    required super.description,
    required super.style,
    super.icon
  });
}

class ToastErrorEvent extends ToastEvent {
  ToastErrorEvent({
    required super.context,
    required super.title,
    required super.description,
    required super.style,
    super.icon
  });
}

class ToastWarningEvent extends ToastEvent {
  ToastWarningEvent({
    required super.context,
    required super.title,
    required super.description,
    required super.style,
    super.icon
  });
}

class ToastInfoEvent extends ToastEvent {
  ToastInfoEvent({
    required super.context,
    required super.title,
    required super.description,
    required super.style,
    super.icon
  });
}

class ToastDangerEvent extends ToastEvent {
  ToastDangerEvent({
    required super.context,
    required super.title,
    required super.description,
    required super.style,
    super.icon
  });
}

class ToastInfoCustom extends ToastEvent {
  ToastInfoCustom({
    required super.context,
    required super.title,
    required super.description,
    required super.style,
    super.icon
  });
}
