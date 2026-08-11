import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/providers/tab_selected_provider.dart';
import 'package:easy_get/widgets/atoms/downloads_tabs.dart';
import 'package:easy_get/widgets/molecules/custom_app_bar.dart';
import 'package:easy_get/widgets/organisms/download_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadTemplate extends StatelessWidget {
  const DownloadTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildDownloadsTabs(int index) {
      switch (index) {
        case 0:
          return Consumer<DownloadProvider>(
            builder: (context, provider, _) {
              if (provider.tasks.isEmpty) {
                return const Center(child: Text('No hay descargas todavía'));
              }
              return ListView.builder(
                itemCount: provider.tasks.length,
                itemBuilder: (context, index) {
                  final download = provider.tasks[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 25.0),
                    child: DownloadCard(heroTag: download.id, task: download,),
                  );
                },
              );
            },
          );

        case 1:
          return const Center(child: Text("Completed Downloads"));
        case 2:
          return const Center(child: Text("All Downloads"));
        default:
          return const Center(child: Text("Unknown Tab"));
      }
    }

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            CustomAppBar(),
            SizedBox(height: 20.0),
            DownloadsTabs(),
            SizedBox(height: 20.0),
            Expanded(
              child: Consumer<TabSelectedProvider>(
                builder: (context, tabSelectedProvider, _) {
                  return buildDownloadsTabs(tabSelectedProvider.selectedIndex);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
