import 'package:easy_get/models/app_download.dart';
import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/widgets/organisms/download_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsTemplate extends StatelessWidget {
  final String heroTag;
  const DetailsTemplate({super.key, required this.heroTag});

  @override
  Widget build(BuildContext context) {
    final DownloadProvider downloadProvider =
        Provider.of<DownloadProvider>(context);

    final AppDownload download = downloadProvider.tasks.firstWhere(
      (task) => task.id == heroTag,
    
    );    

    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [Hero(tag: "download_card_tag", child: DownloadCard(heroTag: heroTag, task: download,))],
      ),
    );
  }
}
