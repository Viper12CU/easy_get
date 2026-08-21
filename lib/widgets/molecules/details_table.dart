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
        _buildRow("Nombre del archivo", download.fileName, context),
        Divider(),
        _buildRow("Origen", download.task.hostName, context),
        Divider(),
        _buildRow("URL", download.task.url, context),
        Divider(),
        _buildRow("Tamaño", download.formattedSize, context),
        Divider(),
        _buildRow("Ruta del archivo", download.task.directory, context),
        Divider(),
        _buildRow("Estado", _statusLabel(download.status), context),
        Divider(),
      ],
    );
  }

  String _statusLabel(AppDownloadStatus status) {
    switch (status) {
      case AppDownloadStatus.queued:
        return "En cola";
      case AppDownloadStatus.downloading:
        return "Descargando";
      case AppDownloadStatus.paused:
        return "Pausada";
      case AppDownloadStatus.completed:
        return "Completada";
      case AppDownloadStatus.error:
        return "Error";
      case AppDownloadStatus.canceled:
        return "Cancelada";
    }
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
