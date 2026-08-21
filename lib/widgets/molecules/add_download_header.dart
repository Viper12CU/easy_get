import 'package:flutter/material.dart';

class AddDownloadHeader extends StatelessWidget {
  const AddDownloadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Añadir una nueva descarga', style: theme.textTheme.headlineSmall),
        Text(
          "Pega el enlace y detectaremos el archivo por ti.",
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
