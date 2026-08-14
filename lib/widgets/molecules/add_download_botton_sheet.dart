import 'dart:math' as math;

import 'package:dotted_border/dotted_border.dart';
import 'package:easy_get/models/app_download.dart';
import 'package:easy_get/providers/download_provider.dart';
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
  bool wifiDownload = true;

  bool _isLoadingGetFile = false;
  bool _isLoadingSubmit = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final DownloadProvider downloadProvider = Provider.of<DownloadProvider>(
      context,
    );

    void addDownload() async {
      if (_formKey.currentState!.validate()) {
        setState(() {
          _isLoadingSubmit = true;
        });
        await downloadProvider.addDownload(
          url: _controller.text,
          requiresWifi: wifiDownload,
          priority: _selectedPriority,
        );
        setState(() {
          _isLoadingSubmit = false;
        });
        if (!context.mounted) return;
        Navigator.pop(context);
      }
    }

    return DraggableScrollableSheet(
      initialChildSize: 0.7, // Altura inicial: 60% de la pantalla
      minChildSize: 0.3, // Mínimo: 30%
      maxChildSize: 1, // Máximo: 95% (casi toda la pantalla)
      expand: false,
      builder: (context, scrollController) => Padding(
        // Padding dinámico para evitar que el teclado tape el contenido
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        child: SingleChildScrollView(
          // Scroll para contenido largo
          child: Container(
            padding: const EdgeInsets.symmetric(
              vertical: 18.0,
              horizontal: 12.0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              spacing: 25,
              children: [
                _title(theme),
                _textField(theme),
                _detectButton(theme, downloadProvider),
                _selectionRow(theme),
                _wifiOption(),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => addDownload(),
                    child: _isLoadingSubmit
                        ? const CircularProgressIndicator()
                        : const Text("Start Download"),
                  ),
                ),

                // Mostrar la información detectada si existe
              ],
            ),
          ),
        ),
      ),
    );
  }

  Row _wifiOption() {
    return Row(
      children: [
        Checkbox(
          value: wifiDownload,
          onChanged: (value) {
            setState(() {
              wifiDownload = value ?? false;
            });
          },
        ),
        Text("Realizar descarga usando red WiFi"),
      ],
    );
  }

  Row _selectionRow(ThemeData theme) {
    final List<String> directorySelect = [
      "Aplicaciones",
      "Audio",
      "Video",
      "Documentos",
      "Otros",
    ];

    final List<Map<String, dynamic>> prioritySelect = [
      {"label": "1", "value": 1},
      {"label": "2", "value": 2},
      {"label": "3", "value": 3},
      {"label": "4", "value": 4},
      {"label": "5", "value": 5},
    ];

    return Row(
      spacing: 12.0,
      children: [
        Flexible(
          flex: 2,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5.0,
            children: [
              Text("Directory", style: theme.textTheme.labelSmall),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: theme.colorScheme.outline,
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    value: _selectedDirectory,
                    hint: Text("Select directory"),
                    items: directorySelect
                        .map(
                          (item) => DropdownMenuItem<String>(
                            value: item,
                            child: Text(item),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedDirectory = value ?? "Otros";
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
        Flexible(
          flex: 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 5.0,
            children: [
              Text("Priority", style: theme.textTheme.labelSmall),
              DropdownButtonHideUnderline(
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    color: theme.colorScheme.outline,
                  ),
                  child: DropdownButton(
                    isExpanded: true,
                    icon: Icon(Icons.keyboard_arrow_down_rounded),
                    value: _selectedPriority,
                    hint: Text("Select directory"),
                    items: prioritySelect
                        .map(
                          (item) => DropdownMenuItem<int>(
                            value: item["value"],
                            child: Text(item["label"]),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedPriority = value ?? 5;
                      });
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
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

  // Widget del botón de detección (sin setState que afecte al TextField)
  Widget _detectButton(ThemeData theme, DownloadProvider downloadProvider) {
    return Column(
      spacing: 5.0,
      children: [
        DottedBorder(
          options: RectDottedBorderOptions(
            strokeCap: StrokeCap.round,
            color: theme.colorScheme.outline,
            strokeWidth: 2,
            dashPattern: [5, 4],
          ),
          child: GestureDetector(
            onTap: () async {
              if (_formKey.currentState!.validate()) {
                setState(() {
                  _isLoadingGetFile = true;
                });
                final AppDownload task = downloadProvider.detectFile(
                  _controller.text,
                );
                final name = await task.task.withSuggestedFilename();
                final size = await task.task.expectedFileSize();

                // Actualizar solo las variables de estado (no reconstruye el TextField)
                setState(() {
                  _detectedFileName = name.filename;
                  _detectedFileSize = formatSize(size);
                });
                setState(() {
                  _isLoadingGetFile = false;
                });
              }
            },
            child: Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: _isLoadingGetFile
                  ? Row(
                      spacing: 15.0,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(
                          color: theme.colorScheme.primary,
                        ),
                        Text("Loading file..."),
                      ],
                    )
                  : const Text("Detect file"),
            ),
          ),
        ),
        if ((_detectedFileName != null || _detectedFileSize != null) &&
            _isLoadingGetFile == false)
          Container(
            padding: const EdgeInsets.all(12.0),
            color: theme.colorScheme.primary,
            child: Row(
              spacing: 15.0,
              children: [
                Transform.rotate(
                  angle: 45 * -math.pi / 180,
                  child: Container(
                    height: 39,
                    width: 39,
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surface,
                      borderRadius: BorderRadius.circular(12.0),
                    ),
                    child: Transform.rotate(
                      angle: -45 * -math.pi / 180,
                      child: Center(child: Icon(Icons.file_present_rounded)),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _detectedFileName!,
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    Text(
                      _detectedFileSize!,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
      ],
    );
  }

  // Widget del campo de texto
  Widget _textField(ThemeData theme) {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 5.0,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Text("Link", style: theme.textTheme.labelSmall),
          ),
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'https://example.com/archive.zip',
            ),
            controller: _controller,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return "This field can't be empty";
              }
              return null;
            },
          ),
        ],
      ),
    );
  }

  // Widget del título
  Widget _title(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Add a new download", style: theme.textTheme.headlineSmall),
        Text(
          "Paste the link and we'll detect the file for you.",
          style: theme.textTheme.labelSmall,
        ),
      ],
    );
  }
}
