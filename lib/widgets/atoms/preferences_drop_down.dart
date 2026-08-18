
import 'package:flutter/material.dart';

class PreferencesDropDown extends StatelessWidget {
  final List<Map<String, dynamic>> items;
  final String? initialValue;
  final ValueChanged? onChanged;

  const PreferencesDropDown({
    super.key,
    required this.items,
    this.initialValue,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DropdownButtonHideUnderline(
      child: DropdownButton(
        isExpanded: true,
        icon: const Icon(Icons.keyboard_arrow_down_rounded),
        items: items.map((item) {
          return DropdownMenuItem(
            value: item['value'],
            child: Text(
              item['label'],
              style: theme.textTheme.bodyMedium,
            ),
          );
        }).toList(),
        value: initialValue,
        onChanged: (value) { onChanged!.call(value);},
      ),
    );
  }
}
