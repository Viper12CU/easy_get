import 'package:easy_get/providers/preferences_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTemplate extends StatelessWidget {
  const SettingsTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    final PreferencesProvider preferencesProvider = Provider.of<PreferencesProvider>(
      context,
    );

    return Center(
      child: ElevatedButton(
        onPressed: () {
          if (preferencesProvider.themeMode == ThemeMode.light ) {
            preferencesProvider.setThemeMode(ThemeMode.dark);
          } else {
            preferencesProvider.setThemeMode(ThemeMode.light);
            
          }
        },
        child: Text(preferencesProvider.themeMode == ThemeMode.light ? "Dark Mode" : "Light Mode"),
      ),
    );
  }
}
