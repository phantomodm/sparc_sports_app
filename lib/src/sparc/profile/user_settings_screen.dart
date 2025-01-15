// user_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/profile/model/user_settings_model.dart';

class UserSettingsScreen extends StatefulWidget {
  const UserSettingsScreen({Key? key}) : super(key: key);

  @override
  State<UserSettingsScreen> createState() => _UserSettingsScreenState();
}

class _UserSettingsScreenState extends State<UserSettingsScreen> {
  late Future<UserSettings> _userSettings; // Use a Future to handle async fetching

  @override
  void initState() {
    super.initState();
    _userSettings = _fetchUserSettings(); // Fetch settings when the screen initializes
  }

  Future<UserSettings> _fetchUserSettings() async {
    // TODO: Implement fetching user settings from database or local storage
    // For now, return a default UserSettings object
    return UserSettings(
      darkMode: false,
      favoriteSports: [],
      notifications: [],
      onboarding: {},
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: FutureBuilder<UserSettings>( // Use FutureBuilder to handle async fetching
        future: _userSettings,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            final settings = snapshot.data!;
            return ListView(
              children: [
                // Profile Settings
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Edit Profile'),
                  onTap: () {
                    // Navigate to EditProfileScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditProfileScreen(userSettings: settings),
                      ),
                    );
                  },
                ),

                // Notification Settings
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  onTap: () {
                    // Navigate to NotificationSettingsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NotificationSettingsScreen(userSettings: settings),
                      ),
                    );
                  },
                ),

                // Privacy Settings
                ListTile(
                  leading: const Icon(Icons.lock),
                  title: const Text('Privacy'),
                  onTap: () {
                    // Navigate to PrivacySettingsScreen
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PrivacySettingsScreen(userSettings: settings),
                      ),
                    );
                  },
                ),

                // Other settings (e.g., logout, delete account)
                // ...
              ],
            );
          }
        },
      ),
    );
  }
}