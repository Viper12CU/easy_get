import 'package:easy_get/widgets/molecules/add_download_botton_sheet.dart';
import 'package:easy_get/widgets/templates/download_template.dart';
import 'package:flutter/material.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      body: DownloadTemplate(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {

          if (!context.mounted) return;
          
          await showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (_) => AddDownloadBottonSheet(),
          );
        },
        tooltip: 'New Download',
        child: const Icon(Icons.add),
      ),
    );
  }
}
