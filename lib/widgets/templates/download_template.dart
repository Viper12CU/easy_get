import 'package:easy_get/providers/tab_selected_provider.dart';
import 'package:easy_get/widgets/atoms/downloads_tabs.dart';
import 'package:easy_get/widgets/molecules/custom_app_bar.dart';
import 'package:easy_get/widgets/organisms/download_tabs_contains.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadTemplate extends StatelessWidget {
  const DownloadTemplate({super.key});

  @override
  Widget build(BuildContext context) {
    Widget buildDownloadsTabs(int index) {
      switch (index) {
        case 0:
          return const DownloadTabsContents(tab: DownloadTab.active);
        case 1:
          return const DownloadTabsContents(tab: DownloadTab.finished);
        case 2:
          return const DownloadTabsContents(tab: DownloadTab.all);
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
