

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sparc_sports_app/src/sparc/profile/model/user_settings_model.dart';

class UserService {
  // TODO Replace type for UserActivity
  Future<List<dynamic>> getRecentActivityForUser(String userId) async {
    // ... your implementation to fetch activity data from your backend or database
    return [];
  }
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> updateUserSettings(UserSettings userSettings, String userId) async {
    try {
      await _firestore.collection('userSettings').doc(userId).set(userSettings.toMap());
    } catch (e) {
      print('Error updating user settings: $e');
      // TODO: Handle error appropriately
    }
  }
}