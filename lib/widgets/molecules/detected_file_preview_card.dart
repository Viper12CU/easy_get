import 'package:easy_get/widgets/atoms/diamond_file_icon.dart';
import 'package:flutter/material.dart';

class DetectedFilePreviewCard extends StatelessWidget {
  final String fileName;
  final String fileSize;

  const DetectedFilePreviewCard({
    super.key,
    required this.fileName,
    required this.fileSize,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(12.0),
      color: theme.colorScheme.primary,
      child: Row(
        spacing: 15.0,
        children: [
          DiamondFileIcon(
            backgroundColor: theme.colorScheme.surface,
            iconColor: theme.colorScheme.onSurface,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  fileName,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
                Text(
                  fileSize,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium!.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
