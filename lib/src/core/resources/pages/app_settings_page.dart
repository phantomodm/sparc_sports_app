import 'package:flutter/material.dart';
import 'package:sparc_sports_app/src/core/bloc/theme_bloc.dart';

import '../../themes/themes.dart';

class AppSettingsPage extends StatefulWidget {
  final bool largeFontsEnabled; //
  final VoidCallback onLargeFontsToggle; // Add this property
  final VoidCallback onThemeToggle;
  final Function(double) onChangeFontSize;
  final ThemeBloc themeBloc; // Add this property
  const AppSettingsPage({Key? key,required this.themeBloc, required this.onChangeFontSize, required this.largeFontsEnabled, required this.onLargeFontsToggle, required this.onThemeToggle}) : super(key: key);

  @override
  State<AppSettingsPage> createState() => _AppSettingsPageState();
}

class _AppSettingsPageState extends State<AppSettingsPage> {
  bool _darkModeEnabled = false;
  double _fontSize = 16.0;
  String _language = 'English';
  bool _highContrastEnabled = false;

  String _selectedTheme = 'Light'; // Start with 'Light' theme
  List<String> _themeOptions = ['Light', 'Dark'];

  ThemeData _getThemeDataForStyle(String styleName) {
    switch (styleName) {
      case 'Light':
        return lightTheme;
      case 'Dark':
        return darkTheme;
      default:
        return lightTheme;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('App Settings'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: const Text('Theme Style'),
            trailing: DropdownButton<String>(
              value: _selectedTheme,
              onChanged: (value) {
                setState(() {
                  _selectedTheme = value!;
                });
                // Call the ThemeBloc method to change the theme
                widget.themeBloc.changeTheme(
                  _getThemeDataForStyle(value!), // Get ThemeData based on the selected style
                );
              },
              items: _themeOptions.map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          // Dark Mode Toggle
          ListTile(
            title: const Text('Dark Mode'),
            trailing: Switch(
              value: _darkModeEnabled,
              onChanged: (value) {
                setState(() {
                  _darkModeEnabled = value;
                });
                widget.onThemeToggle();
              },
            ),
          ),
          ListTile(
            title: const Text('High Contrast'),
            trailing: Switch(
              value: _highContrastEnabled,
              onChanged: (value) {
                setState(() {
                  _highContrastEnabled = value;
                });
                // Call the ThemeBloc method
                widget.themeBloc.toggleHighContrast(value, Theme.of(context));
              },
            ),
          ),
          // Font Size Slider
          ListTile(
            title: const Text('Font Size'),
            trailing: SizedBox(
              width: 200,
              child: Slider(
                value: _fontSize,
                min: 14.0,
                max: 24.0,
                divisions: 10,
                label: _fontSize.round().toString(),
                onChanged: (value) {
                  setState(() {
                    _fontSize = value;
                  });
                  widget.themeBloc.changeFontSize(value, Theme.of(context));
                },
              ),
            ),
          ),
          // Language Dropdown
          ListTile(
            title: const Text('Language'),
            trailing: DropdownButton<String>(
              value: _language,
              onChanged: (value) {
                setState(() {
                  _language = value!;
                });
                // TODO: Implement logic to change language
              },
              items: <String>['English', 'Spanish', 'French', 'German']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
          ListTile(
            title: const Text('Large Fonts'),
            trailing: Switch(
              value: widget.largeFontsEnabled, // Access the value from MyApp
              onChanged: (value) {
                widget.onLargeFontsToggle(); // Call the function from MyApp
              },
            ),
          ),

          // Add more settings here...
        ],
      ),
    );
  }
}