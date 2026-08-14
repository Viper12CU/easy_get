import 'package:dotted_border/dotted_border.dart';
import 'package:easy_get/widgets/molecules/detected_file_preview_card.dart';
import 'package:flutter/material.dart';

class FileDetectSection extends StatelessWidget {
  final bool isLoading;
  final VoidCallback onDetect;
  final String? detectedFileName;
  final String? detectedFileSize;

  const FileDetectSection({
    super.key,
    required this.isLoading,
    required this.onDetect,
    this.detectedFileName,
    this.detectedFileSize,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      spacing: 5.0,
      children: [
        DottedBorder(
          options: RectDottedBorderOptions(
            strokeCap: StrokeCap.round,
            color: theme.colorScheme.outline,
            strokeWidth: 2,
            dashPattern: const [5, 4],
          ),
          child: GestureDetector(
            onTap: onDetect,
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: isLoading
                  ? Row(
                      spacing: 15.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                        const Text('Loading file...'),
                      ],
                    )
                  : const Text('Detect file'),
            ),
          ),
        ),
        if (detectedFileName != null && detectedFileSize != null && !isLoading)
          DetectedFilePreviewCard(
            fileName: detectedFileName!,
            fileSize: detectedFileSize!,
          ),
      ],
    );
  }
}
