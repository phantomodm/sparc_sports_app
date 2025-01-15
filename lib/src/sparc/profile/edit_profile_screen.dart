// edit_profile_screen.dart

import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/sparc/profile/model/user_settings_model.dart';

class EditProfileScreen extends StatefulWidget {
  final UserSettings userSettings;

  const EditProfileScreen({Key? key, required this.userSettings}) : super(key: key);

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _bioController = TextEditingController();
  // ... controllers for other profile fields

  @override
  void initState() {
    super.initState();
    _firstNameController.text = _authService.getCurrentUser()?.firstName ?? '';
    _lastNameController.text = _authService.getCurrentUser()?.lastName ?? '';
    _bioController.text = _authService.getCurrentUser()?.bio ?? '';
    // ... initialize other controllers
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _bioController.dispose();
    // ... dispose other controllers
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: Form(
        key: _formKey,
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _firstNameController,
                decoration: const InputDecoration(labelText: 'First Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _lastNameController,
                decoration: const InputDecoration(labelText: 'Last Name'),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bioController,
                decoration: const InputDecoration(labelText: 'Bio'),
                maxLines: 5,
              ),
              // ... add fields for other profile information
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _updateProfile();
                  }
                },
                child: const Text('Update Profile'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateProfile() async {
    try {
      // Update user profile in database
      final updatedUser = _authService.getCurrentUser()!.copyWith(
        firstName: _firstNameController.text,
        lastName: _lastNameController.text,
        bio: _bioController.text,
        // ... update other fields
      );
      await UserService().updateUser(updatedUser); // Assuming you have a UserService

      // Update user settings in database (if applicable)
      final updatedSettings = widget.userSettings.copyWith(
        // ... update settings based on form fields
      );
      await UserSettingsService().updateUserSettings(updatedSettings, updatedUser.userId!);

      // Show a success message and navigate back
      // ...
    } catch (e) {
      // ...
    };
    }
  }
}