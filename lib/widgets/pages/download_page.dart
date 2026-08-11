import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/widgets/templates/download_template.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    Future<void> _addSampleDownload(BuildContext context) async {
      // Ya no hace falta resolver el directorio a mano: background_downloader
      // usa BaseDirectory.applicationDocuments + un subdirectorio por nombre.
      await context.read<DownloadProvider>().addDownload(
        url: 'https://github.com/Viper12CU/link_chest/releases/download/v0.5.2/link-chest-0.5.2.apk',
      );
    }

    return Scaffold(
      body: DownloadTemplate(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _addSampleDownload(context);

          if (!context.mounted) return;
          
          await showModalBottomSheet(
            context: context,
            builder: (_) => Center(child: Text("Bottom Sheet")),
          );
        },
        tooltip: 'New Download',
        child: const Icon(Icons.add),
      ),
    );
  }
}
