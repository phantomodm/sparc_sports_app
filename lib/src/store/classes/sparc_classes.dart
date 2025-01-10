import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sparc_sports_app/src/store/bloc/state_management.dart';
import 'package:sparc_sports_app/src/core/boot/init.dart';
import 'package:sparc_sports_app/src/core/bloc/locator.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';
import '../helpers/shared_pref/shared_key.dart';
import '../models/cart_models.dart';


class SparcLogger {

   debug(dynamic message, {bool alwaysPrint = false}) {
    _loggerPrint(message ?? "", 'debug', alwaysPrint);
  }

  /// Logs an error [message] to the console.
  /// It will only print if your app's environment is in debug mode.
  /// You can override this by setting [alwaysPrint] = true.
   error(dynamic message, {bool alwaysPrint = false}) {
    if (message.runtimeType.toString() == 'Exception') {
      _loggerPrint(message.toString(), 'error', alwaysPrint);
    }
    _loggerPrint(message, 'error', alwaysPrint);
  }

  /// Log an info [message] to the console.
  /// It will only print if your app's environment is in debug mode.
  /// You can override this by setting [alwaysPrint] = true.
   info(dynamic message, {bool alwaysPrint = false}) {
    _loggerPrint(message ?? "", 'info', alwaysPrint);
  }

  /// Dumps a [message] with a tag.
   dump(dynamic message, String? tag, {bool alwaysPrint = false}) {
    _loggerPrint(message ?? "", tag, alwaysPrint);
  }

  /// Log json data [message] to the console.
  /// It will only print if your app's environment is in debug mode.
  /// You can override this by setting [alwaysPrint] = true.
   json(dynamic message, {bool alwaysPrint = false}) {
    bool canPrint = (getEnv('APP_DEBUG', defaultValue: true));
    if (!canPrint && !alwaysPrint) return;
    try {
      //log(jsonEncode(message));
    } on Exception catch (e) {
      SparcLogger().error(e.toString());
    }
  }

  /// Print a new log message
   _loggerPrint(dynamic message, String? type, bool alwaysPrint) {
    bool canPrint = (getEnv('APP_DEBUG', defaultValue: true));
    final dataStore = locator<DatastoreBloc>();
    dataStore.add(ReadData('SHOW_LOG',defaultValue: false  ));
    var state = dataStore.state;
    bool showLog = state is DatastoreLoaded ? state.data['SHOW_LOG'] : false;
    if (!showLog && !canPrint && !alwaysPrint) return;
    if (showLog) {
      dataStore.add(SetData('SHOW_LOG', false));
    }
    DateTime dateTime = DateTime.now();
    String dateTimeFormatted =
        "${dateTime.year}-${dateTime.month}-${dateTime.day} ${dateTime.hour}:${dateTime.minute}:${dateTime.second}";
    print('[$dateTimeFormatted] ${type != null ? "$type " : ""}$message');
  }

}

abstract class Model {
  final dataStore = locator<DatastoreBloc>();

  /// Authenticate the model.
  Future<void> auth({String? key}) async {
    await Auth.set(this, key: key);
  }

  Future save(String key, {bool inDatastore = false}) async {
    await SparcStorage().store(key, this);
    if (inDatastore == true) {
      dataStore.add(SetData(key, this));
    }
  }

  /// Convert the model toJson.
  Map<String, dynamic> toJson();

}

/// Storage manager for Nylo.
class StorageManager {
   final storage = FlutterSecureStorage();
}
/// Base class to help manage local storage
class SparcStorage {

  late SharedPreferences _prefs;
  final storage = StorageManager().storage;
  final dataStore = locator<DatastoreBloc>();

  // Generic methods for different data types
  Future<bool> setString(String key, String value) async {
    return await _prefs.setString(key, value);
  }

  Future<bool> setStringList(String key, List<String> value) async {
    return await _prefs.setStringList(key, value);
  }

  dynamic getString(String key) {
    return _prefs.getString(jsonDecode(key));
  }

  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }

  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  /// Saves an [object] to local storage.
  Future store(String key, object, {bool inDatastore = false}) async {
    if (inDatastore == true) {
      dataStore.add(SetData(key, object));
    }

    if (!(object is Model)) {
      return await StorageManager().storage
          .write(key: key, value: object.toString());
    }

    try {
      Map<String, dynamic> json = object.toJson();
      return await StorageManager().storage
          .write(key: key, value: jsonEncode(json));
    } on NoSuchMethodError catch (_) {
      SparcLogger().error(
          '[SparcStorage.store] ${object.runtimeType
              .toString()} model needs to implement the toJson() method.');
    }
  }

  /// Read a value from the local storage
  Future<dynamic> read<T>(String key, {dynamic defaultValue}) async {
    String? data = await StorageManager().storage.read(key: key);
    if (data == null) {
      return defaultValue;
    }

    if (T.toString() == "String") {
      return data.toString();
    }

    if (T.toString() == "int") {
      return int.parse(data.toString());
    }

    if (T.toString() == "double") {
      return double.parse(data);
    }

    if (_isInteger(data)) {
      return int.parse(data);
    }

    if (_isDouble(data)) {
      return double.parse(data);
    }

   /* if (T.toString() != 'dynamic') {
      try {
        String? data = await StorageManager().storage.read(key: key);
        if (data == null) return null;
        return dataToModel<T>(data: jsonDecode(data));
      } on Exception catch (e) {
        SparcLogger().error(e.toString());
        return null;
      }
    }*/
    return data;
  }

  /// Deletes all keys with associated values.
  Future deleteAll({bool andFromDatastore = false}) async {
    if (andFromDatastore == true) {
      dataStore.add(DeleteAllData());
    }
    await StorageManager().storage.deleteAll();
  }

  /// Decrypts and returns all keys with associated values.
  Future<Map<String, String>> readAll() async =>
      await StorageManager().storage.readAll();

  /// Deletes associated value for the given [key].
  Future delete(String key, {bool andFromDatastore = false}) async {
    if (andFromDatastore == true) {
      dataStore.add(DeleteData(key));
    }
    return await StorageManager().storage.delete(key: key);
  }

  saveCartToPref({required List<CartLineItem> cartLineItems}) async {
    String json = jsonEncode(cartLineItems.map((i) => i.toJson()).toList());
    await prefs.setString(SharedKey.cart, json);
  }


  /// Attempts to call toJson() on an [object].
  Map<String, dynamic>? _objectToJson(dynamic object) {
    try {
      Map<String, dynamic> json = object.toJson();
      return json;
    } on NoSuchMethodError catch (_) {
      SparcLogger().error(
          '[SparcStorage.store] ${object.runtimeType
              .toString()} model needs to implement the toJson() method.');
    }
    return null;
  }

  /// Checks if the value is an integer.
  bool _isInteger(String? s) {
    if (s == null) {
      return false;
    }

    RegExp regExp = RegExp(
      r"^-?[0-9]+$",
      caseSensitive: false,
      multiLine: false,
    );

    return regExp.hasMatch(s);
  }

  /// Checks if the value is a double.
  bool _isDouble(String? s) {
    if (s == null) {
      return false;
    }

    RegExp regExp = RegExp(
      r"^[0-9]{1,13}([.]?[0-9]*)?$",
      caseSensitive: false,
      multiLine: false,
    );

    return regExp.hasMatch(s);
  }
}

