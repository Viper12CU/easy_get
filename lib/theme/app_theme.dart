import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Paleta completa de la app como [ThemeExtension], para poder acceder a
/// los colores que no tienen un lugar natural en [ColorScheme] (superficies
/// navy, colores de estado pastel, el fondo del ícono-rombo, etc.) mediante
/// `Theme.of(context).extension<AppColors>()!`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.background,
    required this.surface,
    required this.surfaceAlt,
    required this.stroke,
    required this.textPrimary,
    required this.textDim,
    required this.accent,
    required this.ink,
    required this.diamondBackground,
    required this.diamondIcon,
    required this.statusDownloading,
    required this.statusPaused,
    required this.statusQueued,
    required this.statusError,
    required this.statusDone,
  });

  /// --navy-bg — fondo base de la pantalla.
  final Color background;

  /// --navy-surface — tarjetas neutras, inputs, chips no seleccionados.
  final Color surface;

  /// --navy-surface-2 — un nivel más de contraste (botones de stepper, etc.).
  final Color surfaceAlt;

  /// --navy-stroke — bordes y separadores sutiles.
  final Color stroke;

  /// --text-light — texto principal sobre `background`/`surface`.
  final Color textPrimary;

  /// --text-dim — texto secundario/labels sobre `background`/`surface`.
  final Color textDim;

  /// --lime — acento primario (tabs activos, FAB, switches, botón primario).
  final Color accent;

  /// --ink — texto oscuro usado SOBRE las tarjetas pastel (no sobre el fondo).
  final Color ink;

  /// --diamond-bg — fondo del ícono-rombo. Se mantiene fijo en ambos temas,
  /// es el ancla visual de marca.
  final Color diamondBackground;

  /// Color del glifo dentro del rombo.
  final Color diamondIcon;

  /// --lavender — tarjeta de descarga en curso.
  final Color statusDownloading;

  /// --peach — tarjeta de descarga pausada.
  final Color statusPaused;

  /// --mint — tarjeta de descarga en cola.
  final Color statusQueued;

  /// --cyan — tarjeta de descarga con error.
  final Color statusError;

  /// --lime (variante de tarjeta) — tarjeta de descarga completada.
  final Color statusDone;

  static const light = AppColors(
    background: Color(0xFFF5F6FB),
    surface: Color(0xFFEAECF6),
    surfaceAlt: Color(0xFFDFE2F0),
    stroke: Color(0xFFD7DAEA),
    textPrimary: Color(0xFF1B2444),
    textDim: Color(0xFF6B7196),
    accent: Color(0xFFBCDF82),
    ink: Color(0xFF16203F),
    diamondBackground: Color(0xFF1B2444),
    diamondIcon: Color(0xFFF2F3FB),
    statusDownloading: Color(0xFFC3AEE6),
    statusPaused: Color(0xFFF0BD8C),
    statusQueued: Color(0xFFA6E2AB),
    statusError: Color(0xFF7CD3EA),
    statusDone: Color(0xFFBCDF82),
  );

  static const dark = AppColors(
    background: Color(0xFF1B2444),
    surface: Color(0xFF232D54),
    surfaceAlt: Color(0xFF2B3563),
    stroke: Color(0xFF313C6B),
    textPrimary: Color(0xFFF2F3FB),
    textDim: Color(0xFF9AA3CF),
    accent: Color(0xFFCBE896),
    ink: Color(0xFF16203F),
    diamondBackground: Color(0xFF10152C),
    diamondIcon: Color(0xFFF2F3FB),
    statusDownloading: Color(0xFFCDBDEA),
    statusPaused: Color(0xFFF4C99E),
    statusQueued: Color(0xFFB9E8BD),
    statusError: Color(0xFF93DCED),
    statusDone: Color(0xFFCBE896),
  );

  @override
  AppColors copyWith({
    Color? background,
    Color? surface,
    Color? surfaceAlt,
    Color? stroke,
    Color? textPrimary,
    Color? textDim,
    Color? accent,
    Color? ink,
    Color? diamondBackground,
    Color? diamondIcon,
    Color? statusDownloading,
    Color? statusPaused,
    Color? statusQueued,
    Color? statusError,
    Color? statusDone,
  }) {
    return AppColors(
      background: background ?? this.background,
      surface: surface ?? this.surface,
      surfaceAlt: surfaceAlt ?? this.surfaceAlt,
      stroke: stroke ?? this.stroke,
      textPrimary: textPrimary ?? this.textPrimary,
      textDim: textDim ?? this.textDim,
      accent: accent ?? this.accent,
      ink: ink ?? this.ink,
      diamondBackground: diamondBackground ?? this.diamondBackground,
      diamondIcon: diamondIcon ?? this.diamondIcon,
      statusDownloading: statusDownloading ?? this.statusDownloading,
      statusPaused: statusPaused ?? this.statusPaused,
      statusQueued: statusQueued ?? this.statusQueued,
      statusError: statusError ?? this.statusError,
      statusDone: statusDone ?? this.statusDone,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      background: Color.lerp(background, other.background, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      surfaceAlt: Color.lerp(surfaceAlt, other.surfaceAlt, t)!,
      stroke: Color.lerp(stroke, other.stroke, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textDim: Color.lerp(textDim, other.textDim, t)!,
      accent: Color.lerp(accent, other.accent, t)!,
      ink: Color.lerp(ink, other.ink, t)!,
      diamondBackground: Color.lerp(
        diamondBackground,
        other.diamondBackground,
        t,
      )!,
      diamondIcon: Color.lerp(diamondIcon, other.diamondIcon, t)!,
      statusDownloading: Color.lerp(
        statusDownloading,
        other.statusDownloading,
        t,
      )!,
      statusPaused: Color.lerp(statusPaused, other.statusPaused, t)!,
      statusQueued: Color.lerp(statusQueued, other.statusQueued, t)!,
      statusError: Color.lerp(statusError, other.statusError, t)!,
      statusDone: Color.lerp(statusDone, other.statusDone, t)!,
    );
  }

  /// Devuelve el color pastel de tarjeta según el estado de la descarga.
  /// `status` acepta: downloading, paused, queued, error, done.
  Color forStatus(String status) {
    switch (status) {
      case 'downloading':
        return statusDownloading;
      case 'paused':
        return statusPaused;
      case 'queued':
        return statusQueued;
      case 'error':
        return statusError;
      case 'done':
        return statusDone;
      default:
        return surface;
    }
  }
}

/// Construye el [TextTheme]: Poppins para títulos/labels (bold, geométrica),
/// Inter para cuerpo de texto — igual que en el prototipo HTML.
TextTheme _buildTextTheme(Color primaryText, Color dimText) {
  return TextTheme(
    displayLarge: GoogleFonts.poppins(
      fontSize: 29,
      fontWeight: FontWeight.w800,
      color: primaryText,
      letterSpacing: -0.2,
    ),
    headlineSmall: GoogleFonts.poppins(
      fontSize: 20,
      fontWeight: FontWeight.w700,
      color: primaryText,
    ),
    titleLarge: GoogleFonts.poppins(
      fontSize: 17,
      fontWeight: FontWeight.w700,
      color: primaryText,
    ),
    titleMedium: GoogleFonts.poppins(
      fontSize: 14.5,
      fontWeight: FontWeight.w700,
      color: primaryText,
    ),
    titleSmall: GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: dimText,
      letterSpacing: 0.9,
    ),
    labelLarge: GoogleFonts.poppins(
      fontSize: 13.5,
      fontWeight: FontWeight.w700,
      color: primaryText,
    ),
    labelSmall: GoogleFonts.poppins(
      fontSize: 11,
      fontWeight: FontWeight.w700,
      color: dimText,
    ),
    bodyMedium: GoogleFonts.inter(
      fontSize: 13,
      fontWeight: FontWeight.w500,
      color: primaryText,
    ),
    bodySmall: GoogleFonts.inter(
      fontSize: 11.5,
      fontWeight: FontWeight.w500,
      color: dimText,
    ),
  );
} //

class AppTheme {
  AppTheme._();

  static ThemeData get light => _build(AppColors.light, Brightness.light);
  static ThemeData get dark => _build(AppColors.dark, Brightness.dark);

  static ThemeData _build(AppColors colors, Brightness brightness) {
    final textTheme = _buildTextTheme(colors.textPrimary, colors.textDim);

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      scaffoldBackgroundColor: colors.background,
      fontFamily: GoogleFonts.inter().fontFamily,
      colorScheme: ColorScheme(
        brightness: brightness,
        primary: colors.accent,
        onPrimary: colors.ink,
        secondary: colors.statusDownloading,
        onSecondary: colors.ink,
        error: colors.statusError,
        onError: colors.ink,
        surface: colors.background,
        onSurface: colors.textPrimary,
        surfaceContainerHighest: colors.surface,
        outline: colors.stroke,
        outlineVariant: colors.stroke,
      ),
      textTheme: textTheme,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.background,
        foregroundColor: colors.textPrimary,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: textTheme.titleLarge,
        iconTheme: IconThemeData(color: colors.textPrimary),
      ),
      cardTheme: CardThemeData(
        color: colors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: colors.ink.withValues(alpha: 0.14),
        labelStyle: textTheme.labelSmall?.copyWith(color: colors.ink),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
        shape: const StadiumBorder(),
        side: BorderSide.none,
      ),
      dividerTheme: DividerThemeData(
        color: colors.stroke,
        thickness: 1,
        space: 1,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: const WidgetStatePropertyAll(Colors.white),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? colors.accent
              : colors.surfaceAlt,
        ),
        trackOutlineColor: const WidgetStatePropertyAll(Colors.transparent),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: colors.accent,
        foregroundColor: colors.ink,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.accent,
          foregroundColor: colors.ink,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: textTheme.labelLarge,
          shape: const StadiumBorder(),
          elevation: 0,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.statusPaused,
          backgroundColor: colors.surface,
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          textStyle: textTheme.labelLarge,
          side: BorderSide.none,
          shape: const StadiumBorder(),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: colors.textDim,
          textStyle: textTheme.labelSmall,
        ),
      ),
      iconTheme: IconThemeData(color: colors.textPrimary),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surface,
        hintStyle: textTheme.bodyMedium?.copyWith(color: colors.textDim),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 13,
          vertical: 12,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: colors.accent, width: 2),
        ),
      ),
      progressIndicatorTheme: ProgressIndicatorThemeData(
        color: colors.ink.withValues(alpha: 0.62),
        linearTrackColor: colors.ink.withValues(alpha: 0.14),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: colors.surface,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      bottomSheetTheme: BottomSheetThemeData(
        backgroundColor: colors.background,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
        ),
      ),
      extensions: [colors],
    );
  }
}

/// Atajo: `context.appColors.statusDownloading`, etc.
extension AppColorsX on BuildContext {
  AppColors get appColors => Theme.of(this).extension<AppColors>()!;
}
