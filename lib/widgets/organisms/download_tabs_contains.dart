import 'package:easy_get/models/app_download.dart';
import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/widgets/atoms/download_status_group.dart';
import 'package:easy_get/widgets/atoms/empty_state.dart';
import 'package:easy_get/widgets/atoms/loader_animation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DownloadTab { all, finished, active }

class DownloadTabsContents extends StatelessWidget {
  final DownloadTab tab;
  const DownloadTabsContents({super.key, required this.tab});

  @override
  Widget build(BuildContext context) {
    final DownloadProvider provider = Provider.of<DownloadProvider>(context);

    final List<Widget> content = getContent(tab, context);
    return provider.initLoading
        ? const Center(child: LoaderAnimation(size: 50.0))
        : content.isEmpty
        ? EmptyState()
        : ListView(children: getContent(tab, context));
  }

  List<Widget> getContent(DownloadTab tab, BuildContext context) {
    final List<AppDownload> tasks = Provider.of<DownloadProvider>(context).tasks
        .where((download) {
          switch (tab) {
            case DownloadTab.all:
              return true;
            case DownloadTab.finished:
              return download.status == AppDownloadStatus.completed ||
                  download.status == AppDownloadStatus.canceled ||
                  download.status == AppDownloadStatus.error;
            case DownloadTab.active:
              return download.status == AppDownloadStatus.downloading ||
                  download.status == AppDownloadStatus.paused ||
                  download.status == AppDownloadStatus.queued;
          }
        })
        .toList();

    if (tasks.isEmpty) {
      return [];
    }

    switch (tab) {
      case DownloadTab.all:
        return [
          DownloadStatusGroup(status: AppDownloadStatus.downloading),
          DownloadStatusGroup(status: AppDownloadStatus.paused),
          DownloadStatusGroup(status: AppDownloadStatus.queued),
          DownloadStatusGroup(status: AppDownloadStatus.completed),
          DownloadStatusGroup(status: AppDownloadStatus.canceled),
          DownloadStatusGroup(status: AppDownloadStatus.error),
        ];
      case DownloadTab.finished:
        return [
          DownloadStatusGroup(status: AppDownloadStatus.completed),
          DownloadStatusGroup(status: AppDownloadStatus.canceled),
          DownloadStatusGroup(status: AppDownloadStatus.error),
        ];
      case DownloadTab.active:
        return [
          DownloadStatusGroup(status: AppDownloadStatus.downloading),
          DownloadStatusGroup(status: AppDownloadStatus.queued),
          DownloadStatusGroup(status: AppDownloadStatus.paused),
        ];
    }
  }
}
