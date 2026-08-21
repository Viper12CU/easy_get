import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/widgets/atoms/app_confirm_dialog.dart';
import 'package:easy_get/widgets/atoms/wifi_only_checkbox_row.dart';
import 'package:easy_get/widgets/molecules/add_download_header.dart';
import 'package:easy_get/widgets/molecules/directory_priority_selectors.dart';
import 'package:easy_get/widgets/molecules/file_detect_section.dart';
import 'package:easy_get/widgets/molecules/url_input_field.dart';
import 'package:easy_get/widgets/organisms/add_download_sheet_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddDownloadBottonSheet extends StatefulWidget {
  const AddDownloadBottonSheet({super.key});

  @override
  State<AddDownloadBottonSheet> createState() => _AddDownloadBottonSheetState();
}

class _AddDownloadBottonSheetState extends State<AddDownloadBottonSheet> {
  // Controladores y clave del formulario persistentes
  final TextEditingController _controller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Variables para mostrar la información detectada
  String? _detectedFileName;
  String? _detectedFileSize;

  // Valores del dropdown
  String _selectedDirectory = "Otros";
  int _selectedPriority = 5;

  // Wifi
  bool _wifiDownload = true;

  bool _isLoadingGetFile = false;
  bool _isLoadingSubmit = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final DownloadProvider downloadProvider = Provider.of<DownloadProvider>(
      context,
    );

    Future<void> addDownload() async {
      bool result = true;

      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _isLoadingSubmit = true;
      });

      try {
        if (!_wifiDownload) {
          result = await showAppConfirmDialog(
            context,
            title: "Descarga sin Wi-Fi",
            message:
                "Por el tamaño del archivo se recomienda usar una red WIFI. ¿Continuar igualmente?",
            tone: ConfirmTone.warning,
          );
        }

        if (result) {
          await downloadProvider.addDownload(
            url: _controller.text,
            requiresWifi: _wifiDownload,
            priority: _selectedPriority,
          );

          if (!context.mounted) {
            return;
          }

          Navigator.pop(context);
        }
      } catch (e) {
        debugPrint(e.toString());
      } finally {
        setState(() {
          _isLoadingSubmit = false;
        });
      }
    }

    Future<void> detectFile() async {
      if (!_formKey.currentState!.validate()) {
        return;
      }

      setState(() {
        _isLoadingGetFile = true;
      });

      final task = downloadProvider.detectFile(_controller.text);
      final name = await task.task.withSuggestedFilename();
      final size = await task.task.expectedFileSize();

      if (!mounted) {
        return;
      }

      setState(() {
        _detectedFileName = name.filename;
        _detectedFileSize = formatSize(size);
        _isLoadingGetFile = false;
      });
    }

    return AddDownloadSheetScaffold(
      header: const AddDownloadHeader(),
      urlInput: UrlInputField(formKey: _formKey, controller: _controller),
      detectSection: FileDetectSection(
        isLoading: _isLoadingGetFile,
        detectedFileName: _detectedFileName,
        detectedFileSize: _detectedFileSize,
        onDetect: detectFile,
      ),
      selectors: DirectoryPrioritySelectors(
        selectedDirectory: _selectedDirectory,
        selectedPriority: _selectedPriority,
        onDirectoryChanged: (value) {
          setState(() {
            _selectedDirectory = value;
          });
        },
        onPriorityChanged: (value) {
          setState(() {
            _selectedPriority = value;
          });
        },
      ),
      wifiOption: WifiOnlyCheckboxRow(
        value: _wifiDownload,
        onChanged: (value) {
          setState(() {
            _wifiDownload = value;
          });
        },
      ),
      isLoadingSubmit: _isLoadingSubmit,
      onSubmit: addDownload,
    );
  }

  String formatSize(int? bytes) {
    if (bytes == null || bytes < 0) {
      return '—';
    }

    if (bytes >= 1024 * 1024 * 1024) {
      return '${(bytes / (1024 * 1024 * 1024)).toStringAsFixed(1)} GB';
    }

    if (bytes >= 1024 * 1024) {
      return '${(bytes / (1024 * 1024)).toStringAsFixed(0)} MB';
    }

    if (bytes >= 1024) {
      return '${(bytes / 1024).toStringAsFixed(0)} KB';
    }

    return '$bytes B';
  }
}
