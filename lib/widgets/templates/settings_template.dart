import 'package:easy_get/providers/preferences_provider.dart';
import 'package:easy_get/widgets/atoms/preference_counter.dart';
import 'package:easy_get/widgets/atoms/preference_switch.dart';
import 'package:easy_get/widgets/atoms/preferences_category.dart';
import 'package:easy_get/widgets/atoms/preferences_drop_down.dart';
import 'package:easy_get/widgets/molecules/preferences_option.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SettingsTemplate extends StatefulWidget {
  const SettingsTemplate({super.key});

  @override
  State<SettingsTemplate> createState() => _SettingsTemplateState();
}

class _SettingsTemplateState extends State<SettingsTemplate> {
  @override
  Widget build(BuildContext context) {
    final PreferencesProvider preferencesProvider =
        Provider.of<PreferencesProvider>(context);

    final controllerSwitchWifi = ValueNotifier<bool>(
      preferencesProvider.wifiDownload,
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
                      initialValue: true,
                      onChange: (value) =>
                          preferencesProvider.wifiDownload = value,
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
                        {
                          "label": "Programas",
                          "value": "Programas",
                        },
                        {
                          "label": "Imágenes",
                          "value": "Imágenes",
                        },
                        {
                          "label": "Videos",
                          "value": "Videos",
                        },
                        {
                          "label": "Documentos",
                          "value": "Documentos",
                        },
                        {
                          "label": "Otros",
                          "value": "Otros",
                        },
                      ],
                      initialValue: preferencesProvider.defaultFile,
                      onChanged: (value) {
                        preferencesProvider.defaultFile = value ?? "Otros";
                      },
                    ),
                  ),
                ],
              ),
            ),
            PreferencesCategory(
              label: "Reintento",
              child: Column(children: [SizedBox(height: 200)]),
            ),
            PreferencesCategory(
              label: "Notificaciones",
              child: Column(children: [SizedBox(height: 200)]),
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
                        {
                          "label": "Claro",
                          "value": "Claro",
                        },
                        {
                          "label": "Oscuro",
                          "value": "Oscuro",
                        },
                        {
                          "label": "Sistema",
                          "value": "Sistema",
                        },
                      ],
                      initialValue: preferencesProvider.themeMode == ThemeMode.light
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
          ],
        ),
      ),
    );
  }
}
