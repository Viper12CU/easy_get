import 'package:easy_get/models/app_download.dart';
import 'package:flutter/material.dart';

class DetailsTable extends StatelessWidget {
  final AppDownload download;
  const DetailsTable({super.key, required this.download});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Divider(),
        _buildRow("File Name", download.fileName, context),
        Divider(),
        _buildRow("Origin", download.task.hostName, context),
        Divider(),
        _buildRow("URL", download.task.url, context),
        Divider(),
        _buildRow("Size", download.formattedSize, context),
        Divider(),
        _buildRow("File Path", download.task.directory, context),
        Divider(),
        _buildRow("Status", download.status.name, context),
        Divider(),
      ],
    );
  }

  Widget _buildRow(String label, String value, BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: textTheme.labelSmall),
          SizedBox(
            width: 150,
            child: SelectableText(
              value,
              style: textTheme.bodyMedium!.copyWith(
                overflow: TextOverflow.clip,
              ),
              textAlign: TextAlign.right,
              minLines: 1,
              maxLines: 5,
            ),
          ),
        ],
      ),
    );
  }
}
