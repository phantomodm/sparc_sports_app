// privacy_settings_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/profile/model/user_settings_model.dart';

class PrivacySettingsScreen extends StatefulWidget {
  final UserSettings userSettings;

  const PrivacySettingsScreen({Key? key, required this.userSettings}) : super(key: key);

  @override
  State<PrivacySettingsScreen> createState() => _PrivacySettingsScreenState();
}

class _PrivacySettingsScreenState extends State<PrivacySettingsScreen> {
  bool _showNsfwContent = false;

  @override
  void initState() {
    super.initState();
    _showNsfwContent = widget.userSettings.showNsfwContent;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy'),
      ),
      body: ListView(
        children: [
          SwitchListTile(
            title: const Text('Show NSFW Content'),
            value: _showNsfwContent,
            onChanged: (value) {
              setState(() {
                _showNsfwContent = value;
              });
              // TODO: Update user settings in database or local storage
            },
          ),
          // ... add more privacy settings
        ],
      ),
    );
  }
}