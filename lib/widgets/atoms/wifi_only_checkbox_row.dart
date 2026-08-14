import 'package:flutter/material.dart';

class WifiOnlyCheckboxRow extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;
  final String label;

  const WifiOnlyCheckboxRow({
    super.key,
    required this.value,
    required this.onChanged,
    this.label = 'Realizar descarga usando red WiFi',
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: value,
          onChanged: (nextValue) {
            onChanged(nextValue ?? false);
          },
        ),
        Text(label),
      ],
    );
  }
}
