import 'package:flutter/material.dart';

class AddDownloadHeader extends StatelessWidget {
  const AddDownloadHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Add a new download', style: theme.textTheme.headlineSmall),
        Text(
          "Paste the link and we'll detect the file for you.",
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
