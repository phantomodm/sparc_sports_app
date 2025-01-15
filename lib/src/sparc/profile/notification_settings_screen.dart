// notification_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/profile/model/user_settings_model.dart'; // Import your theme and models

class NotificationSettingsScreen extends StatefulWidget {
  final UserSettings userSettings;

  const NotificationSettingsScreen({Key? key, required this.userSettings}) : super(key: key);

  @override
  State<NotificationSettingsScreen> createState() => _NotificationSettingsScreenState();
}

class _NotificationSettingsScreenState extends State<NotificationSettingsScreen> {
  bool _receiveEmailNotifications = false;
  bool _receivePushNotifications = false;

  @override
  void initState() {
    super.initState();
    _receiveEmailNotifications = widget.userSettings.receiveEmailNotifications;
    _receivePushNotifications = widget.userSettings.receivePushNotifications;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Notifications'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Receive Email Notifications'),
            value: _receiveEmailNotifications,
            onChanged: (value) {
              setState(() {
                _receiveEmailNotifications = value;
              });
              // TODO: Update user settings in database or local storage
            },
          ),
          SwitchListTile(
            title: const Text('Receive Push Notifications'),
            value: _receivePushNotifications,
            onChanged: (value) {
              setState(() {
                _receivePushNotifications = value;
              });
              // TODO: Update user settings in database or local storage
            },
          ),
          // ... add more notification settings
        ],
      ),
    );
  }
}