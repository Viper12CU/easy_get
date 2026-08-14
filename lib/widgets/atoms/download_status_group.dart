import 'package:easy_get/models/app_download.dart';
import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/widgets/molecules/download_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadStatusGroup extends StatelessWidget {
  final AppDownloadStatus status;
  const DownloadStatusGroup({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    


    String labelFor(AppDownloadStatus d) {
      switch (d) {
        case AppDownloadStatus.downloading:
          return 'Descargando';
        case AppDownloadStatus.paused:
          return 'Pausadas';
        case AppDownloadStatus.queued:
          return 'En cola';
        case AppDownloadStatus.error:
          return 'Error';
        case AppDownloadStatus.completed:
          return 'Completadas';
        case AppDownloadStatus.canceled:
          return 'Canceladas';
      }
    }

    return Consumer<DownloadProvider>(
      builder: (context, provider, _) {
         final List<AppDownload> downloadsForStatus = provider.tasks
        .where((download) => download.status == status)
        .toList();

        if (downloadsForStatus.isEmpty) {
          return SizedBox.shrink();
        }
        return Column(
          spacing: 10.0,
          children: [
          Align(
            alignment: AlignmentGeometry.centerStart,
            child: Text("${labelFor(status)} · ${downloadsForStatus.length}", style: Theme.of(context).textTheme.labelSmall,)),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: downloadsForStatus.length,
              itemBuilder: (context, index) {
                final download = downloadsForStatus[index];
                return Padding(
                  padding: const EdgeInsets.only(bottom: 25.0),
                  child: DownloadCard(heroTag: download.id, task: download,),
                );
              },
            ),
          ],
        );
      },
      
    );
  }
}