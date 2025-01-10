import 'package:flutter/material.dart';
//import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';
import 'package:fluttertoast/fluttertoast.dart';


class ToastStyle {
  final Color backgroundColor;
  final Color textColor;
  final double fontSize;
  final int toastLength;
  final ToastGravity gravity;
  final dynamic animationBuilder; // You might need to adjust the type based on your animation
  final Duration animationDuration;

  const ToastStyle({
    required this.backgroundColor,
    required this.textColor,
    required this.fontSize,
    required this.toastLength,
    required this.gravity,
    required this.animationBuilder,
    required this.animationDuration,
  });
}

class ToastStyles {
  static const successStyle = ToastStyle(
    backgroundColor: Colors.green,
    textColor: Colors.white,
    fontSize: 16.0,
    toastLength: 2,
    gravity: ToastGravity.BOTTOM,
    animationBuilder: _slideInAnimation,
    animationDuration: Duration(milliseconds: 300),
  );

  static const errorStyle = ToastStyle(
    backgroundColor: Colors.red,
    textColor: Colors.white,
    fontSize: 16.0,
    toastLength: 2,
    gravity: ToastGravity.BOTTOM,
    animationBuilder: _fadeInAnimation,
    animationDuration: Duration(milliseconds: 500),
  );

  static const warningStyle = ToastStyle(
    backgroundColor: Colors.orange,
    textColor: Colors.white,
    fontSize: 16.0,
    toastLength: 2,
    gravity: ToastGravity.TOP,
    animationBuilder: _scaleAnimation,
    animationDuration: Duration(milliseconds: 400),
  );

  static const infoStyle = ToastStyle(
    backgroundColor: Colors.blue,
    textColor: Colors.white,
    fontSize: 14.0,
    toastLength: 3,
    gravity: ToastGravity.CENTER,
    animationBuilder: _rotateAnimation,
    animationDuration: Duration(milliseconds: 600),
  );

  static Widget _scaleAnimation(
      BuildContext context,
      AnimationController controller,
      Duration duration,
      Widget child,
      ) {
    return ScaleTransition(
      scale: Tween<double>(begin: 0.8, end: 1.0).animate(controller),
      child: child,
    );
  }

  static Widget _rotateAnimation(
      BuildContext context,
      AnimationController controller,
      Duration duration,
      Widget child,
      ) {
    return RotationTransition(
      turns: Tween<double>(begin: 0.8, end: 1.0).animate(controller),
      child: child,
    );
  }

  // ... add more styles for warning, info, etc. ...

  static Widget _slideInAnimation(
  BuildContext context,
  AnimationController controller,
  Duration duration,
  Widget child,
) {
  return SlideTransition(
    position: Tween<Offset>(
      begin: const Offset(0.0, 1.0),
      end: Offset.zero,
    ).animate(controller),
    child: child,
  );
}

// _fadeInAnimation function
  static Widget _fadeInAnimation(
  BuildContext context,
  AnimationController controller,
  Duration duration,
  Widget child,
) {
  return FadeTransition(
    opacity: controller, // Use the controller for opacity animation
    child: child,
  );
}
}