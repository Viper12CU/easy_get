import 'package:easy_get/models/app_download.dart';
import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/widgets/molecules/details_options.dart';
import 'package:easy_get/widgets/molecules/details_table.dart';
import 'package:easy_get/widgets/molecules/download_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsTemplate extends StatelessWidget {
  final String heroTag;
  const DetailsTemplate({super.key, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final DownloadProvider downloadProvider = Provider.of<DownloadProvider>(
      context,
    );

    AppDownload? download;
    for (final task in downloadProvider.tasks) {
      if (task.id == heroTag) {
        download = task;
        break;
      }
    }

    if (download == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (context.mounted && Navigator.canPop(context)) {
          Navigator.pop(context);
        }
      });

      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        spacing: 20.0,
        children: [
          Hero(
            curve: Curves.easeInOut,
            tag: heroTag,
            child: DownloadCard(
              heroTag: heroTag,
              task: download,
              showButton: false,
            ),
          ),
          SizedBox(height: 20.0),
          Expanded(child: DetailsTable(download: download)),
          DetailsOptions(download: download),
        ],
      ),
    );
  }
}
