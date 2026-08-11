import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/widgets/atoms/custom_icon_button.dart';
import 'package:easy_get/widgets/pages/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storage_info/flutter_storage_info.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatefulWidget {
  const CustomAppBar({super.key});

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();
}

class _CustomAppBarState extends State<CustomAppBar> {
  double _usedSpace = 0;
  double _totalSpace = 0;

  void loadStorage() async {
    final usedSpace =
        (await FlutterStorageInfo.storageUsedSpace) / (1024 * 1024 * 1024);
    final totalSpace =
        (await FlutterStorageInfo.storageTotalSpace) / (1024 * 1024 * 1024);

    setState(() {
      _usedSpace = usedSpace;
      _totalSpace = totalSpace;
    });

  }

  @override
  void initState() {
    super.initState();
    loadStorage();
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final DownloadProvider downloadProvider = Provider.of<DownloadProvider>(context);

    final int active = downloadProvider.activeCount;
    final int quote = downloadProvider.queuedCount;

    return Stack(
      children: [
        Column(
          spacing: 3,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Gestor de descargas", style: textTheme.bodyMedium),
            Text("Descargas", style: textTheme.headlineMedium),
            Text.rich(
              TextSpan(
                style: textTheme.labelSmall,
                children: [
                  TextSpan(
                    text: _usedSpace.toStringAsFixed(2),
                    style: TextStyle(color: textTheme.labelMedium!.color),
                  ),
                  TextSpan(
                    text: " / ${_totalSpace.toStringAsFixed(2)} GB usados - ",
                  ),
                  TextSpan(
                    text: active.toString(),
                    style: TextStyle(color: textTheme.labelMedium!.color),
                  ),
                  TextSpan(text: " activa - "),
                  TextSpan(
                    text: "$quote",
                    style: TextStyle(color: textTheme.labelMedium!.color),
                  ),
                  TextSpan(text: " en cola"),
                ],
              ),
            ),
          ],
        ),
        Align(
          alignment: AlignmentGeometry.bottomRight,
          child: Padding(
            padding: const EdgeInsets.only(top: 12.0),
            child: CustomIconButton(
              icon: Icons.settings_rounded,
              onTap: () {
                Navigator.of(
                  context,
                ).push(MaterialPageRoute(builder: (_) => SettingsPage()));
              },
            ),
          ),
        ),
      ],
    );
  }
}
