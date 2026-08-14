import 'dart:ui';

/// Modelo que representa el contenido de un botón.
class ButtonContent {
  final String label;
  final VoidCallback onTap; // Callback sin parámetros y sin retorno.

  ButtonContent({
    required this.label,
    required this.onTap,
  });
}