import 'package:flutter/material.dart';

class LabeledDropdownField<T> extends StatelessWidget {
  final String label;
  final T value;
  final String hintText;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;

  const LabeledDropdownField({
    super.key,
    required this.label,
    required this.value,
    required this.hintText,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      spacing: 5.0,
      children: [
        Text(label, style: theme.textTheme.labelSmall),
        DropdownButtonHideUnderline(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8.0),
              color: theme.colorScheme.outline,
            ),
            child: DropdownButton<T>(
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down_rounded),
              value: value,
              hint: Text(hintText),
              items: items,
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }
}
