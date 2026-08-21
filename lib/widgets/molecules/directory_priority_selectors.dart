import 'package:easy_get/widgets/atoms/labeled_dropdown_field.dart';
import 'package:flutter/material.dart';

class DirectoryPrioritySelectors extends StatelessWidget {
  final String selectedDirectory;
  final int selectedPriority;
  final ValueChanged<String> onDirectoryChanged;
  final ValueChanged<int> onPriorityChanged;

  const DirectoryPrioritySelectors({
    super.key,
    required this.selectedDirectory,
    required this.selectedPriority,
    required this.onDirectoryChanged,
    required this.onPriorityChanged,
  });

  static const List<String> directoryOptions = [
    'Aplicaciones',
    'Audio',
    'Video',
    'Documentos',
    'Otros',
  ];

  static const List<int> priorityOptions = [1, 2, 3, 4, 5];

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 12.0,
      children: [
        Flexible(
          flex: 2,
          child: LabeledDropdownField<String>(
            label: 'Directorio',
            value: selectedDirectory,
            hintText: 'Selecciona un directorio',
            items: directoryOptions
                .map(
                  (item) => DropdownMenuItem<String>(
                    value: item,
                    child: Text(item),
                  ),
                )
                .toList(),
            onChanged: (value) => onDirectoryChanged(value ?? 'Otros'),
          ),
        ),
        Flexible(
          flex: 1,
          child: LabeledDropdownField<int>(
            label: 'Prioridad',
            value: selectedPriority,
            hintText: 'Selecciona una prioridad',
            items: priorityOptions
                .map(
                  (value) => DropdownMenuItem<int>(
                    value: value,
                    child: Text('$value'),
                  ),
                )
                .toList(),
            onChanged: (value) => onPriorityChanged(value ?? 5),
          ),
        ),
      ],
    );
  }
}
