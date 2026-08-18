
import 'package:flutter/material.dart';
import 'package:flutter_advanced_switch/flutter_advanced_switch.dart';

class PreferenceSwitch extends StatelessWidget {
  final ValueNotifier<bool> controller;
  final bool? initialValue;
  final ValueChanged<bool>? onChange;
  const PreferenceSwitch( {super.key, required this.controller, this.initialValue, this.onChange,});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);


    return AdvancedSwitch(
      controller: controller,
      activeColor: theme.colorScheme.primary,
      inactiveColor: theme.colorScheme.outline,
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(7)),
      height: 27.0,
      width: 55.0,
      initialValue: initialValue ?? true,
      onChanged: (value) {
        onChange!.call(value);
      },

    );
  }
}