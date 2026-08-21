import 'package:easy_get/providers/preferences_provider.dart';
import 'package:easy_get/services/storage_service.dart';
import 'package:easy_get/widgets/atoms/preference_counter.dart';
import 'package:easy_get/widgets/atoms/preference_switch.dart';
import 'package:easy_get/widgets/atoms/preferences_category.dart';
import 'package:easy_get/widgets/atoms/preferences_drop_down.dart';
import 'package:easy_get/widgets/molecules/preferences_option.dart';
import 'package:flutter/material.dart';
import 'package:flutter_storage_info/flutter_storage_info.dart';
import 'package:open_filex/open_filex.dart';
import 'package:provider/provider.dart';

class SettingsTemplate extends StatefulWidget {
  const SettingsTemplate({super.key});

  @override
  State<SettingsTemplate> createState() => _SettingsTemplateState();
}

class _SettingsTemplateState extends State<SettingsTemplate> {
  final StorageService _storageService = StorageService();
  String _storageSummary = "Cargando almacenamiento...";

  @override
  void initState() {
    super.initState();
    _refreshStorageInfo();
  }

  void _resetPreferences(PreferencesProvider preferencesProvider) {
    preferencesProvider.language = "system";
    preferencesProvider.notificationsEnabled = true;
    preferencesProvider.defaultPriority = 5;
    preferencesProvider.completionBehavior = "keep";
    preferencesProvider.downloadLocation =
        "Almacenamiento de la aplicación";

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Configuración restaurada")),
    );
  }

  void _changeDownloadLocation() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("La selección de carpetas estará disponible próximamente"),
      ),
    );
  }

  Future<void> _clearDownloadHistory() async {
    final shouldClear = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Limpiar historial"),
        content: const Text(
          "Se eliminarán los registros de descargas completadas. Esta acción no borra los archivos.",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text("Cancelar"),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text("Limpiar"),
          ),
        ],
      ),
    );

    if (shouldClear == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("El historial se limpiará próximamente")),
      );
    }
  }

  Future<void> _openDownloadFolder() async {
    final result = await _storageService.openDownloadDirectory();

    if (!mounted || result.type == ResultType.done) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          result.message,
        ),
      ),
    );
  }

  Future<void> _refreshStorageInfo() async {
    setState(() {
      _storageSummary = "Cargando almacenamiento...";
    });

    try {
      final usedBytes = await FlutterStorageInfo.storageUsedSpace;
      final totalBytes = await FlutterStorageInfo.storageTotalSpace;
      final usedGigabytes = usedBytes / (1024 * 1024 * 1024);
      final totalGigabytes = totalBytes / (1024 * 1024 * 1024);
      final freeGigabytes = totalGigabytes - usedGigabytes;

      if (!mounted) {
        return;
      }

      setState(() {
        _storageSummary =
            "Usado: ${usedGigabytes.toStringAsFixed(2)} GB · "
            "Libre: ${freeGigabytes.toStringAsFixed(2)} GB";
      });
    } catch (_) {
      if (!mounted) {
        return;
      }

      setState(() {
        _storageSummary = "Información de almacenamiento no disponible";
      });
    }
  }

  void _showAppInformation() {
    showAboutDialog(
      context: context,
      applicationName: "Easy Get",
      applicationVersion: "1.0.0",
      applicationLegalese: "Gestor de descargas",
      children: const [
        Text("Ayuda, versión y licencias de la aplicación."),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final PreferencesProvider preferencesProvider =
        Provider.of<PreferencesProvider>(context);

    final controllerSwitchWifi = ValueNotifier<bool>(
      preferencesProvider.wifiDownload,
    );

    final controllerSwitchRetrys = ValueNotifier<bool>(
      preferencesProvider.automaticRetry,
    );

    final controllerSwitchNotifications = ValueNotifier<bool>(
      preferencesProvider.notificationsEnabled,
    );

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: SingleChildScrollView(
        child: Column(
          spacing: 25,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PreferencesCategory(
              label: "Descargas",
              child: Column(
                children: [
                  PreferencesOption(
                    title: "Solo con WIFI",
                    subtitle:
                        "Evita consumir datos móviles en archivos grandes.",
                    action: PreferenceSwitch(
                      controller: controllerSwitchWifi,
                      initialValue: preferencesProvider.wifiDownload,
                      onChange: (value) {
                        preferencesProvider.wifiDownload = value;
                      },
                    ),
                  ),
                  Divider(),
                  PreferencesOption(
                    title: "Descargas simultáneas",
                    subtitle: "Más de 3 puede saturar tu red y disco.",
                    action: PreferenceCounter(
                      initialValue: preferencesProvider.simultaneousDownloads,
                      onChange: (value) =>
                          preferencesProvider.simultaneousDownloads = value,
                    ),
                  ),
                  Divider(),
                  PreferencesOption(
                    title: "Carpeta destino por defecto",
                    subtitle: "Se puede cambiar por descarga individual.",
                    action: PreferencesDropDown(
                      items: [
                        {"label": "Programas", "value": "Programas"},
                        {"label": "Imágenes", "value": "Imágenes"},
                        {"label": "Videos", "value": "Videos"},
                        {"label": "Documentos", "value": "Documentos"},
                        {"label": "Otros", "value": "Otros"},
                      ],
                      initialValue: preferencesProvider.defaultFile,
                      onChanged: (value) {
                        preferencesProvider.defaultFile = value ?? "Otros";
                      },
                    ),
                  ),
                  const Divider(),
                  PreferencesOption(
                    title: "Prioridad predeterminada",
                    subtitle: "Prioridad usada en nuevas descargas.",
                    action: PreferenceCounter(
                      initialValue: preferencesProvider.defaultPriority,
                      minValue: 1,
                      maxValue: 5,
                      onChange: (value) {
                        preferencesProvider.defaultPriority = value;
                      },
                    ),
                  ),
                  const Divider(),
                  PreferencesOption(
                    title: "Al finalizar una descarga",
                    subtitle: "Define qué ocurre cuando el archivo termina.",
                    action: PreferencesDropDown(
                      items: [
                        {"label": "Mantener archivo", "value": "keep"},
                        {"label": "Abrir archivo", "value": "open"},
                        {"label": "Mostrar notificación", "value": "notify"},
                      ],
                      initialValue: preferencesProvider.completionBehavior,
                      onChanged: (value) {
                        preferencesProvider.completionBehavior =
                            value ?? "keep";
                      },
                    ),
                  ),
                ],
              ),
            ),
            PreferencesCategory(
              label: "Reintento",
              child: Column(
                children: [
                  PreferencesOption(
                    title: "Reintentar automáticamente",
                    subtitle:
                        "Ante error de red, reintenta antes de pedirte acción.",
                    action: PreferenceSwitch(
                      controller: controllerSwitchRetrys,
                      onChange: (value) =>
                          preferencesProvider.automaticRetry = value,
                    ),
                  ),
                  Divider(),
                  PreferencesOption(
                    title: "Máximo de reintentos",
                    subtitle: "Antes de marcar la descarga como fallida.",
                    action: PreferenceCounter(
                      initialValue: preferencesProvider.maxRetries,
                      maxValue: 6,
                      onChange: (value) =>
                          preferencesProvider.maxRetries = value,
                    ),
                  ),
                ],
              ),
            ),
            PreferencesCategory(
              label: "Apariencia",
              child: Column(
                children: [
                  PreferencesOption(
                    title: "Tema de la aplicación",
                    subtitle:
                        "Cambia el tema de la aplicación entre claro y oscuro.",
                    action: PreferencesDropDown(
                      items: [
                        {"label": "Claro", "value": "Claro"},
                        {"label": "Oscuro", "value": "Oscuro"},
                        {"label": "Sistema", "value": "Sistema"},
                      ],
                      initialValue:
                          preferencesProvider.themeMode == ThemeMode.light
                          ? "Claro"
                          : preferencesProvider.themeMode == ThemeMode.dark
                          ? "Oscuro"
                          : "Sistema",
                      onChanged: (value) {
                        preferencesProvider.themeMode = value ?? "Sistema";
                      },
                    ),
                  ),
                ],
              ),
            ),
            PreferencesCategory(
              label: "Idioma",
              child: Column(
                children: [
                  PreferencesOption(
                    title: "Idioma de la aplicación",
                    subtitle:
                        "Selecciona el idioma de los textos y controles.",
                    action: PreferencesDropDown(
                      items: [
                        {"label": "Sistema", "value": "system"},
                        {"label": "Español", "value": "es"},
                        {"label": "Inglés", "value": "en"},
                      ],
                      initialValue: preferencesProvider.language,
                      onChanged: (value) {
                        preferencesProvider.language = value ?? "system";
                      },
                    ),
                  ),
                ],
              ),
            ),
            PreferencesCategory(
              label: "Notificaciones",
              child: Column(
                children: [
                  PreferencesOption(
                    title: "Notificaciones de descarga",
                    subtitle:
                        "Recibe avisos cuando una descarga termine o falle.",
                    action: PreferenceSwitch(
                      controller: controllerSwitchNotifications,
                      initialValue: preferencesProvider.notificationsEnabled,
                      onChange: (value) {
                        preferencesProvider.notificationsEnabled = value;
                      },
                    ),
                  ),
                ],
              ),
            ),
            PreferencesCategory(
              label: "Ubicación",
              child: Column(
                children: [
                  PreferencesOption(
                    title: "Ubicación de descarga",
                    subtitle: preferencesProvider.downloadLocation,
                    action: TextButton(
                      onPressed: _changeDownloadLocation,
                      child: const Text("Cambiar"),
                    ),
                  ),
                  const Divider(),
                  PreferencesOption(
                    title: "Abrir carpeta de descargas",
                    subtitle: "Accede rápidamente a tus archivos descargados.",
                    action: IconButton(
                      tooltip: "Abrir carpeta",
                      onPressed: _openDownloadFolder,
                      icon: const Icon(Icons.folder_open_rounded),
                    ),
                  ),
                ],
              ),
            ),
            PreferencesCategory(
              label: "Almacenamiento",
              child: Column(
                children: [
                  PreferencesOption(
                    title: "Información de almacenamiento",
                    subtitle: _storageSummary,
                    action: IconButton(
                      tooltip: "Actualizar almacenamiento",
                      onPressed: _refreshStorageInfo,
                      icon: const Icon(Icons.refresh_rounded),
                    ),
                  ),
                ],
              ),
            ),
            PreferencesCategory(
              label: "Mantenimiento",
              child: Column(
                children: [
                  PreferencesOption(
                    title: "Limpiar historial",
                    subtitle: "Elimina los registros de descargas completadas.",
                    action: TextButton(
                      onPressed: _clearDownloadHistory,
                      child: const Text("Limpiar"),
                    ),
                  ),
                  const Divider(),
                  PreferencesOption(
                    title: "Restaurar configuración",
                    subtitle:
                        "Vuelve a los valores predeterminados de Easy Get.",
                    action: TextButton(
                      onPressed: () => _resetPreferences(preferencesProvider),
                      child: const Text("Restaurar"),
                    ),
                  ),
                ],
              ),
            ),
            PreferencesCategory(
              label: "Información",
              child: Column(
                children: [
                  PreferencesOption(
                    title: "Acerca de Easy Get",
                    subtitle: "Versión, licencias y ayuda.",
                    action: IconButton(
                      tooltip: "Ver información",
                      onPressed: _showAppInformation,
                      icon: const Icon(Icons.info_outline_rounded),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
