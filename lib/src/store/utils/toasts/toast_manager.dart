//import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:fluttertoast/fluttertoast.dart';


/// Toast manager, manage toast list.
class ToastManager {
  ToastManager._();

  /// Instance of [ToastManager].
  static ToastManager? _instance;

  /// Factory to create [ToastManager] singleton.
  factory ToastManager() {
    _instance ??= ToastManager._();
    return _instance!;
  }

  /// [Set] used to save [ToastFuture].
  Set<dynamic> toastSet = {};

  void showToast({
    required String message,
    required dynamic style,
  }) {
    // Check if a toast with the same message is already showing
    if (toastSet.any((toast) => toast.message == message)) {
      return; // Don't show the same toast again
    }

    // Create the toast
    final toast = Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: style.backgroundColor,
      textColor: style.textColor,
      fontSize: style.fontSize,
    );

    // Add the toast to the set
    toastSet.add(toast);

    // Remove the toast from the set when it's dismissed
    toast.then((value) {
      toastSet.remove(toast);
    });
  }

  /// Dismiss all toast.
  void dismissAll({
    bool showAnim = false,
  }) {
    toastSet.toList().forEach((v) {
      v.dismiss(showAnim: showAnim);
    });
  }

  /// Remove [ToastFuture].
  void removeFuture(ToastFuture future) {
    toastSet.remove(future);
  }

  /// Add [ToastFuture].
  void addFuture(ToastFuture future) {
    toastSet.add(future);
  }
 
}



