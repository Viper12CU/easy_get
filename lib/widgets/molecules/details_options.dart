import 'package:easy_get/models/app_download.dart';
import 'package:easy_get/models/button_details_model.dart';
import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/widgets/atoms/app_confirm_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DetailsOptions extends StatefulWidget {
  final AppDownload download;
  const DetailsOptions({super.key, required this.download});

  @override
  State<DetailsOptions> createState() => _DetailsOptionsState();
}

class _DetailsOptionsState extends State<DetailsOptions> {
  final List<ButtonContent> buttonContents = [];

  void _initializeButtonContents() {
    final DownloadProvider downloadProvider = Provider.of<DownloadProvider>(
      context,
    );
    buttonContents.clear();

    switch (widget.download.status) {
      case AppDownloadStatus.downloading:
        buttonContents.addAll([
          ButtonContent(
            label: "Pause",
            onTap: () async => {
              await downloadProvider.pauseDownload(widget.download.id),
              debugPrint("Pause ${widget.download.toString()}"),
            },
          ),
          ButtonContent(
            label: "Cancel",
            onTap: () async {
              final bool result = await showAppConfirmDialog(
                context,
                title: "Cancelar esta descarga",
                message: "¿Desea detener la descarga de este archivo?",
                tone: ConfirmTone.warning,
                confirmLabel: "Detener",
              );
              if (result) {
                await downloadProvider.cancelDownload(widget.download.id);
                debugPrint("Cancel ${widget.download.toString()}");
              }
            },
          ),
        ]);
        break;
      case AppDownloadStatus.paused:
        buttonContents.addAll([
          ButtonContent(
            label: "Resume",
            onTap: () async => {
              await downloadProvider.resumeDownload(widget.download.id),
              debugPrint("Resume ${widget.download.toString()}"),
            },
          ),
          ButtonContent(
            label: "Cancel",
            onTap: () async {
              final bool result = await showAppConfirmDialog(
                context,
                title: "Cancelar esta descarga",
                message: "¿Desea detener la descarga de este archivo?",
                tone: ConfirmTone.warning,
                confirmLabel: "Detener",
              );

              if (result) {
                await downloadProvider.cancelDownload(widget.download.id);
                debugPrint("Cancel ${widget.download.toString()}");
              }
            },
          ),
        ]);
        break;
      case AppDownloadStatus.error:
        buttonContents.addAll([
          ButtonContent(
            label: "Retry",
            onTap: () async => {
              await downloadProvider.retryDownload(widget.download.id),
              debugPrint("Retry ${widget.download.toString()}"),
            },
          ),
        ]);

        break;
      case AppDownloadStatus.queued:
        buttonContents.addAll([
          ButtonContent(
            label: "Pause",
            onTap: () async => {
              await downloadProvider.pauseDownload(widget.download.id),
              debugPrint("Pause ${widget.download.toString()}"),
            },
          ),
          ButtonContent(
            label: "Cancel",
            onTap: () async {
              final bool result = await showAppConfirmDialog(
                context,
                title: "Cancelar esta descarga",
                message: "¿Desea detener la descarga de este archivo?",
                tone: ConfirmTone.warning,
                confirmLabel: "Detener",
              );

              if (result) {
                await downloadProvider.cancelDownload(widget.download.id);
                debugPrint("Cancel ${widget.download.toString()}");
              }
            },
          ),
        ]);
        break;
      case AppDownloadStatus.completed:
        buttonContents.addAll([
          ButtonContent(
            label: "Open",
            onTap: () async {
              await showAppConfirmDialog(
                context,
                title: "Ver en la carpeta",
                message: "Abrir archivo descargado en la carpeta de origen",
                tone: ConfirmTone.info,
                confirmLabel: "Abrir",
              );
            },
          ),
          ButtonContent(
            label: "Delete",
            onTap: () async {
              final bool result = await showAppConfirmDialog(
                context,
                title: "Eliminar esta descarga",
                message: "¿Desea eliminar este registro completado?",
                tone: ConfirmTone.warning,
                confirmLabel: "Detener",
              );

              if (result && mounted) {
                Navigator.pop(context);
                await downloadProvider.removeCompletedDownload(
                  widget.download.id,
                );
                debugPrint("Delete ${widget.download.toString()}");
              }
            },
          ),
        ]);

        break;
      case AppDownloadStatus.canceled:
        buttonContents.addAll([
          ButtonContent(
            label: "Retry",
            onTap: () async => {
              await downloadProvider.retryDownload(widget.download.id),
              debugPrint("Retry ${widget.download.toString()}"),
            },
          ),
          ButtonContent(
            label: "Delete",
            onTap: () async {
              final bool result = await showAppConfirmDialog(
                context,
                title: "Eliminar esta registro",
                message: "¿Desea eliminar este registro canceldo?",
                tone: ConfirmTone.warning,
                confirmLabel: "Eliminar",
              );

              if (result && mounted) {
                Navigator.pop(context);
                await downloadProvider.removeDownload(widget.download.id);
                debugPrint("Delete ${widget.download.toString()}");
              }
            },
          ),
        ]);

        break;
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _initializeButtonContents();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      spacing: 10.0,
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: buttonContents.map((buttonContent) {
        return Expanded(
          child: ElevatedButton(
            onPressed: buttonContent.onTap,
            child: Text(buttonContent.label),
          ),
        );
      }).toList(),
    );
  }
}
