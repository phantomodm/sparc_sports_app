import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/store/classes/sparc_classes.dart';
import 'package:sparc_sports_app/src/store/enum/toasts_enums.dart';
import 'package:sparc_sports_app/src/store/services/api_service.dart';
import 'package:sparc_sports_app/src/store/utils/toasts/toast_notification.dart';

abstract class SparcStatefulWidget extends StatefulWidget {
  @override
  StatefulElement createElement() => StatefulElement(this);

  late final dynamic controller;

  /// State name
  final String? state;
  final State? child;

  SparcStatefulWidget(String? path, {Key? key, this.child})
      : state = path,
        super(key: key);

  @override
  // ignore: no_logic_in_create_state
  State<StatefulWidget> createState() {
    if (child != null) {
      return child!;
    }
    throw UnimplementedError();
  }
}

abstract class SparcState<T extends StatefulWidget> extends State<T> {
  @override
  BuildContext get context => super.context;

  /// Contains a map for all the loading keys.
  final Map<String, bool> _loadingMap = {};

  /// Contains a map for all the locked states.
  final Map<String, bool> _lockMap = {};
  String? stateName;

  bool isLocked(String name) {
    if (_lockMap.containsKey(name) == false) {
      _lockMap[name] = false;
    }
    return _lockMap[name]!;
  }

  /// Checks the value from your loading map.
  /// Provide the [name] of the loader.
  bool  isLoading({String name = 'default'}) {
    if (_loadingMap.containsKey(name) == false) {
      _loadingMap[name] = false;
    }
    return _loadingMap[name]!;
  }

  awaitData(
      {String name = 'default',
      required Function perform,
      bool shouldSetStateBefore = true,
      bool shouldSetStateAfter = true}) async {
    _updateLoadingState(
        shouldSetState: shouldSetStateBefore, name: name, value: true);

    try {
      await perform();
    } on Exception catch (e) {
      SparcLogger().
error(e.toString());
    }

    _updateLoadingState(
        shouldSetState: shouldSetStateAfter, name: name, value: false);
  }

  _updateLoadingState(
      {required bool shouldSetState,
      required String name,
      required bool value}) {
    if (shouldSetState == true) {
      setState(() {
        _setLoader(name, value: value);
      });
    } else {
      _setLoader(name, value: value);
    }
  }

  _setLoader(String name, {required bool value}) {
    _loadingMap[name] = value;
  }

  /// Set the value of a loading key by padding a true or false
  setLoading(bool value, {String name = 'default', bool resetState = true}) {
    if (resetState) {
      setState(() {
        _loadingMap[name] = value;
      });
    } else {
      _loadingMap[name] = value;
    }
  }

  lockRelease(String name,
      {required Function perform, bool shouldSetState = true}) async {
    if (isLocked(name) == true) {
      return;
    }
    _updateLockState(shouldSetState: shouldSetState, name: name, value: true);

    try {
      await perform();
    } on Exception catch (e) {
      SparcLogger().
error(e.toString());
    }

    _updateLockState(shouldSetState: shouldSetState, name: name, value: false);
  }

  /// Update the lock state.
  _updateLockState(
      {required bool shouldSetState,
      required String name,
      required bool value}) {
    if (shouldSetState == true) {
      setState(() {
        _setLock(name, value: value);
      });
    } else {
      _setLock(name, value: value);
    }
  }

  /// Set the state of the lock.
  /// E.g.setLock('updating_user', value: true);
  ///
  /// Provide a [name] and boolean value.
  _setLock(String name, {required bool value}) {
    _lockMap[name] = value;
  }

  dynamic data({String? key}) {
    return ModalRoute.of(context)!.settings.arguments;
  }

  /// Helper to get the [MediaQueryData].
  MediaQueryData get mediaQuery => MediaQuery.of(context);

  dynamic queryParameters() => (ModalRoute.of(context)!.settings.name);

  dynamic getParameters(String key) {
    return queryParameters()
        ?.split('?')[1]
        .split('&')
        .firstWhere((element) => element.contains(key))
        ?.split('=')[1];
  }

  /// Pop the current widget from the stack.
  pop({dynamic result}) {
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  /// Show a toast notification
  showToast(
      {ToastNotificationStyleType style = ToastNotificationStyleType.SUCCESS,
      required String title,
      required String description,
      IconData? icon,
      Duration? duration}) {
    if (!mounted) return;
    ToastHelper().showToastNotification(
      context,
      style: style,
      title: title,
      description: description,
      icon: icon,
      duration: duration,
    );
  }

  validate(
      {required Map<String, String> rules,
      required Map<String, dynamic> data,
      Map<String, dynamic> messages = const {},
      bool showAlert = true,
      Duration? alertDuration,
      ToastNotificationStyleType alertStyle =
          ToastNotificationStyleType.WARNING,
      required Function()? onSuccess,
      Function(Exception exception)? onFailure,
      String? lockRelease}) {
    if (!mounted) return;
    if (lockRelease != null) {
      this.lockRelease(lockRelease, perform: () async {
        try {
          // SparcValidator.check(
          //   rules: rules,
          //   data: data,
          //   messages: messages,
          //   context: context,
          //   showAlert: showAlert,
          //   alertDuration: alertDuration,
          //   alertStyle: alertStyle,
          // );

          if (onSuccess == null) return;
          await onSuccess();
        } on Exception catch (exception) {
          SparcLogger().
error(exception.toString());
          if (onFailure == null) return;
          onFailure(exception);
        }
      });
      return;
    }
    try {
      // SparcValidator.check(
      //   rules: rules,
      //   data: data,
      //   messages: messages,
      //   context: context,
      //   showAlert: showAlert,
      //   alertDuration: alertDuration,
      //   alertStyle: alertStyle,
      // );

      if (onSuccess == null) return;
      onSuccess();
    } on Exception catch (exception) {
      SparcLogger().
error(exception.toString());
      if (onFailure == null) return;
      onFailure(exception);
    }
  }
}

abstract class BaseController {
  BuildContext? context;
  NyApiService? request;
  String? state;

  BaseController({this.context, this.request, this.state = "/"});

  /// Returns any data passed through a [Navigator] or [routeTo] method.
  //dynamic data({String? key}) => this.request!.data(key: key);

  /// Returns any query parameters passed in a route
  /// e.g. /my-page?hello=world
  /// Result {"hello": "world"}
  //dynamic queryParameters() => request!.queryParameters();

  /// Initialize your controller with this method.
  /// It contains same [BuildContext] as the [SparcStatefulWidget].
  @mustCallSuper
  construct(BuildContext context) async {
    this.context = context;
  }
}
