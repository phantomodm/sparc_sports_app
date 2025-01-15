// fcm_service.dart

import 'package:firebase_messaging/firebase_messaging.dart';

class FCMService {
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> sendNotification(String to, String title, String body) async {
    try {
      await _firebaseMessaging.sendMessage(
        to: to, // The FCM token of the recipient
        notification: RemoteNotification(
          title: title,
          body: body,
        ),
      );
    } catch (e) {
      print('Error sending notification: $e');
      // TODO: Handle error appropriately
    }
  }

// ... other FCM-related methods (e.g., handling incoming messages, subscribing to topics)
}