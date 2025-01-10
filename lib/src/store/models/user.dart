//  Label StoreMax
//
//  Created by Anthony Gordon.
//  2023, WooSignal Ltd. All rights reserved.
//

//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

import 'dart:convert';

import 'package:sparc_sports_app/src/store/classes/sparc_classes.dart';
import 'package:sparc_sports_app/src/store/helpers/helpers.dart';


class User extends Model {
  String? userId;
  String? token;

  User();
  User.fromUserAuthResponse({this.userId, this.token});

  @override
  toJson() => {"token": token, "user_id": userId};

  User.fromJson(dynamic data) {
    token = data['token'];
    userId = data['user_id'];
  }
}

class Auth {
  /// Set the auth user
  static Future<void> set(dynamic auth, {String? key}) async {
    final authJson = auth.toJson(); // Convert auth object to JSON
    String storageKey = getEnv('AUTH_USER_KEY', defaultValue: 'AUTH_USER');
    if (key != null) {
      storageKey = key;
    }
    await SparcStorage().setString(storageKey, authJson); // Store in SparcStorage()
  }

  /// Login a auth user for a given [key].
  static Future<void> login(dynamic auth, {String? key}) async =>
      await set(auth, key: key);

  /// Get the auth user
  static T? user<T>({String? key}) {
    String storageKey = getEnv('AUTH_USER_KEY', defaultValue: 'AUTH_USER');
    if (key != null) {
      storageKey = key;
    }
    final authJson = SparcStorage().getString(storageKey); // Get from SparcStorage()
    if (authJson != null) {
      return fromJson<T>(jsonDecode(authJson)); // Deserialize from JSON
    }
    return null;
  }

  /// Remove the auth user for a given [key].
  static Future<void> remove({String? key}) async {
    String storageKey = getEnv('AUTH_USER_KEY', defaultValue: 'AUTH_USER');
    if (key != null) {
      storageKey = key;
    }
    await SparcStorage().delete(storageKey);
  }

  /// Logout the auth user for a given [key].
  static Future<void> logout({String? key}) async => await remove(key: key);

  /// Check if a user is logged in for a given [key].
  static Future<bool> loggedIn({String? key}) async {
    return (await user()) != null;
  }

  // Helper function to deserialize from JSON
  static T fromJson<T>(Map<String, dynamic> json) {
    // Implement your deserialization logic here based on the type T
    // This could involve using a factory constructor or other methods
    // to create an object of type T from the JSON data
    throw UnimplementedError();
  }
}
abstract class Model {
  /// Authenticate the model.
  Future<void> auth({String? key}) async {
    await Auth.set(this, key: key);
  }

  /// Save the object to secure storage using a unique [key].
  /// E.g. User class
  ///
  /// User user = new User();
  /// user.name = "Anthony";
  /// user.save('com.company.app.auth_user');
  ///
  /// Get user
  /// User user = await SparcStorage().read< User >('com.company.app.auth_user', model: new User());
  Future<void> save(String key) async {
    final modelJson = toJson(); // Convert to JSON
    final modelJsonString = jsonEncode(modelJson); // Encode JSON to string
    await SparcStorage().setString(key, modelJsonString);
  }

  /// Convert the model toJson.
  Map<String, dynamic> toJson();

  /// Save an item to a collection
  /// E.g. List of numbers
  ///
  /// User userAnthony = new User(name: 'Anthony');
  /// await userAnthony.saveToCollection('mystoragekey');
  ///
  /// User userKyle = new User(name: 'Kyle');
  /// await userKyle.saveToCollection('mystoragekey');
  ///
  /// Get the collection back with the user included.
  /// List<User> users = await SparcStorage().read<List<User>>('mystoragekey');
  ///
  /// The [key] is the collection you want to access.
  
}
