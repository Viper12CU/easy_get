import 'package:easy_get/providers/tab_selected_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tabbar_lite/flutter_tabbar_lite.dart';
import 'package:provider/provider.dart';

class DownloadsTabs extends StatefulWidget {
  const DownloadsTabs({super.key});

  @override
  State<DownloadsTabs> createState() => _DownloadsTabsState();
}

class _DownloadsTabsState extends State<DownloadsTabs> {
  @override
  Widget build(BuildContext context) {
    final TabSelectedProvider tabSelectedProvider =
        Provider.of<TabSelectedProvider>(context);
    final ThemeData theme = Theme.of(context); 


    final List<String> titles = const ["Active", "Finished", "All"];


    return FlutterTabBarLite.horizontal(
      scrollable: false,
      titles: titles,
      backgroundColor: theme.colorScheme.outline,
      selectedItemBgColor: theme.colorScheme.primary,
      selectedTextColor: theme.colorScheme.onPrimary,
      unselectedItemTextColor: theme.textTheme.labelSmall!.color!,
      borderRadius: 18,
      itemBorderRadius: 14,
      itemMargin: EdgeInsets.all(4.0),
      itemPadding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      onTabChange: (index) {
        tabSelectedProvider.setSelectedIndex(index);
      },
    );
  }
}
