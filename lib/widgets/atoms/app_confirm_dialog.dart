// widgets/app_confirm_dialog.dart
//
// Diálogo de confirmación reutilizable. El rombo de arriba cambia de
// color según el "tono" (info / warning / danger / success), tomando
// los mismos colores de estado que ya usan las tarjetas de descarga —
// así una sola alerta sirve para cualquier acción destructiva de la
// app sin inventar un estilo nuevo cada vez.

import 'dart:ui';

import 'package:easy_get/theme/app_theme.dart';
import 'package:flutter/material.dart';



enum ConfirmTone { info, warning, danger, success }

class AppConfirmDialog extends StatelessWidget {
  const AppConfirmDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmLabel = 'Confirmar',
    this.cancelLabel = 'Cancelar',
    this.tone = ConfirmTone.info,
    this.icon,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final String cancelLabel;
  final ConfirmTone tone;
  final IconData? icon;

  Color _toneColor(AppColors colors) {
    switch (tone) {
      case ConfirmTone.info:
        return colors.statusDownloading;
      case ConfirmTone.warning:
        return colors.statusPaused;
      case ConfirmTone.danger:
        return colors.statusError;
      case ConfirmTone.success:
        return colors.statusDone;
    }
  }

  IconData _defaultIcon() {
    switch (tone) {
      case ConfirmTone.info:
        return Icons.info_outline_rounded;
      case ConfirmTone.warning:
        return Icons.priority_high_rounded;
      case ConfirmTone.danger:
        return Icons.delete_outline_rounded;
      case ConfirmTone.success:
        return Icons.check_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final textTheme = Theme.of(context).textTheme;
    final toneColor = _toneColor(colors);

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 32),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(26),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 32, 24, 20),
            decoration: BoxDecoration(
              color: colors.surface.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(26),
              border: Border.all(color: colors.stroke),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Transform.rotate(
                  angle: 0.785398, // 45°
                  child: Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      color: toneColor,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Transform.rotate(
                      angle: -0.785398,
                      child: Icon(icon ?? _defaultIcon(), color: colors.ink, size: 24),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Text(title, style: textTheme.headlineSmall, textAlign: TextAlign.center),
                const SizedBox(height: 8),
                Text(
                  message,
                  style: textTheme.bodyMedium?.copyWith(color: colors.textDim),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 26),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(false),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: colors.textPrimary,
                          backgroundColor: colors.surfaceAlt,
                          side: BorderSide.none,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                        ),
                        child: Text(cancelLabel),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => Navigator.of(context).pop(true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: toneColor,
                          foregroundColor: colors.ink,
                          shape: const StadiumBorder(),
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          elevation: 0,
                        ),
                        child: Text(confirmLabel),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Muestra el diálogo y devuelve `true` si el usuario confirmó,
/// `false` en cualquier otro caso (canceló o cerró tocando afuera).
///
/// Ejemplo:
/// ```dart
/// final confirmed = await showAppConfirmDialog(
///   context,
///   title: '¿Cancelar descarga?',
///   message: 'Se va a perder el progreso y el archivo parcial se elimina.',
///   tone: ConfirmTone.danger,
///   confirmLabel: 'Cancelar descarga',
/// );
/// if (confirmed) {
///   downloadProvider.cancelDownload(task.id);
/// }
/// ```
Future<bool> showAppConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  String confirmLabel = 'Confirmar',
  String cancelLabel = 'Cancelar',
  ConfirmTone tone = ConfirmTone.info,
  IconData? icon,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    builder: (_) => AppConfirmDialog(
      title: title,
      message: message,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      tone: tone,
      icon: icon,
    ),
  );
  return result ?? false;
}
