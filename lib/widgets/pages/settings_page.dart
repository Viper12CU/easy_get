import 'package:easy_get/widgets/atoms/custom_icon_button.dart';
import 'package:easy_get/widgets/templates/settings_template.dart';
import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        leading: Padding(
          padding: const EdgeInsets.all(12.0),
          child: CustomIconButton(icon: Icons.arrow_back_rounded, onTap: () {
            Navigator.pop(context);
          }),
        ),
        title: Text("Configuración", style: Theme.of(context).textTheme.headlineSmall,)
      ),
      body: SettingsTemplate(),
    );
  }
}