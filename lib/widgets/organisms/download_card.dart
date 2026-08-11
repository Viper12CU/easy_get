import 'dart:math' as math;

import 'package:easy_get/models/app_download.dart';
import 'package:easy_get/providers/download_provider.dart';
import 'package:easy_get/widgets/atoms/custom_icon_button.dart';
import 'package:easy_get/widgets/pages/details_page.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DownloadCard extends StatelessWidget {
  final AppDownload task;
  final String heroTag;
  const DownloadCard({super.key, required this.heroTag, required this.task});

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return SizedBox(
      height: 130,
      width: double.infinity,
      child: Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => DetailsPage(heroTag: heroTag),
                  ),
                );
              },
              child: ClipPath(
                clipper: ProjectCardClipper(),
                child: Container(
                  decoration: const BoxDecoration(color: Color(0xFFC8F39B)),
                  child: Stack(
                    children: [
                      label(theme),
                      Positioned(
                        top: 60,
                        left: 20,
                        child: SizedBox(
                          width: MediaQuery.of(context).size.width - 75,
                          child: Row(
                            spacing: 4,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              icon(theme),
                              SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  spacing: 2,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      task.fileName,
                                      style: theme.textTheme.bodyMedium!
                                          .copyWith(
                                            overflow: TextOverflow.ellipsis,
                                            color: theme.colorScheme.onPrimary,
                                          ),
                                    ),
                                    Text(
                                      "${task.formattedSize} · ${task.url}",
                                      style: theme.textTheme.labelSmall!
                                          .copyWith(
                                            fontSize: 10,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(width: 10),
                              actionButton(context),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          progress(theme),
        ],
      ),
    );
  }

  CustomIconButton actionButton(BuildContext context) {
    final DownloadProvider provider = Provider.of<DownloadProvider>(context, listen: false);

    final IconData icon;
    final void Function()? onPressed;


    
    switch (task.status) {
      case AppDownloadStatus.downloading:
        icon = Icons.pause;
        onPressed = () => provider.pauseDownload(task.id);
        break;
      case AppDownloadStatus.paused:
        icon = Icons.play_arrow;
        onPressed = () => provider.resumeDownload(task.id);
        break;
      case AppDownloadStatus.error:
        icon = Icons.refresh;
        onPressed = () => provider.retryDownload(task.id);
        break;
      case AppDownloadStatus.queued:
        icon = Icons.cancel;
        onPressed = () => provider.cancelDownload(task.id);
        break;
      case AppDownloadStatus.completed:
        icon = Icons.delete_rounded;
        onPressed = () => provider.removeCompletedDownload(task.id); // No action for completed downloads
        break;
      case AppDownloadStatus.canceled:
        icon = Icons.cancel;
        onPressed = () => provider.cancelDownload(task.id); // No action for canceled downloads
        break;
    }
  


    return CustomIconButton(
      icon: icon,
      onTap: () => onPressed?.call(),
    );
  }

  Positioned progress(ThemeData theme) {
    return Positioned(
      top: task.status == AppDownloadStatus.downloading ? 5 : 10,
      right: 10,
      child: Column(
        children: [
          Row(
            spacing: 9.0,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("${task.progressPercent}%", style: theme.textTheme.labelSmall),
              SizedBox(
                width: 130,
                child: LinearProgressIndicator(
                  borderRadius: BorderRadius.circular(12),
                  value: task.progress,
                  minHeight: 8,
                  backgroundColor: Colors.grey,
                  valueColor: AlwaysStoppedAnimation<Color>(
                    theme.colorScheme.primary,
                  ),
                ),
              ),
            ],
          ),
          if (task.status == AppDownloadStatus.downloading ) 
          ... [
            Text("${task.formattedSpeed} · ETA ${task.formattedEta}", style: theme.textTheme.labelSmall),
          ]
        ],
      ),
    );
  }

  Widget icon(ThemeData theme) {
    return Transform.rotate(
      angle: 45 * -math.pi / 180,
      child: Container(
        height: 49,
        width: 49,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Transform.rotate(
          angle: -45 * -math.pi / 180,
          child: Center(child: Icon(Icons.download_rounded)),
        ),
      ),
    );
  }

  Positioned label(ThemeData theme) {
    String labelFor(AppDownload d) {
      switch (d.status) {
        case AppDownloadStatus.downloading:
          return 'Descargando';
        case AppDownloadStatus.paused:
          return 'Pausado';
        case AppDownloadStatus.queued:
          return 'En cola';
        case AppDownloadStatus.error:
          return 'Error';
        case AppDownloadStatus.completed:
          return 'Completado';
        case AppDownloadStatus.canceled:
          return 'Cancelado';
      }
    }

    return Positioned(
      top: 10.0,
      left: 10.0,
      child: Text(
        labelFor(task),
        style: theme.textTheme.labelMedium!.copyWith(
          color: theme.colorScheme.onPrimary,
        ),
      ),
    );
  }
}

class ProjectCardClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    // ============================================================
    // SISTEMA DE COORDENADAS ORIGINAL
    // ============================================================
    //
    // La forma original está diseñada sobre:
    //
    //   WIDTH  = 1300
    //   HEIGHT = 335
    //
    // Esto corresponde al viewBox del SVG:
    //
    //   viewBox="0 0 1300 335"
    //
    // sx y sy permiten adaptar la forma al tamaño real
    // del Container.
    // ============================================================

    const originalWidth = 1300.0;
    const originalHeight = 335.0;

    final double sx = size.width / originalWidth;
    final double sy = size.height / originalHeight;

    double x(double value) => value * sx;
    double y(double value) => value * sy;

    final path = Path();

    // ============================================================
    // PUNTO INICIAL
    // ============================================================
    //
    // Comenzamos en:
    //
    //        (45, 0)
    //
    //                  S1
    //        ●───────────────────────
    //       (45,0)
    //
    // ============================================================

    path.moveTo(x(65), y(0));

    // ============================================================
    // S1 — LÍNEA SUPERIOR
    // ============================================================
    //
    // Desde:
    //      (45, 0)
    //
    // Hasta:
    //      (345, 0)
    //
    // Esta es la parte horizontal superior de la pestaña.
    //
    //        (45,0)                    (345,0)
    //           ●────────────────────────●
    //                         S1
    //
    // ============================================================

    path.lineTo(x(390), y(0));

    // ============================================================
    // S2 — PRIMERA CURVA
    // ============================================================
    //
    // Desde:
    //      (345, 0)
    //
    // Control Point 1:
    //      (390, 0)
    //
    // Control Point 2:
    //      (405, 18)
    //
    // Hasta:
    //      (425, 65)
    //
    // Esta curva comienza a bajar desde la pestaña.
    //
    //                 CP1
    //                  ●
    //                 /
    //                /
    //       S1 ●────
    //                \
    //                 \
    //                  ● CP2
    //                   \
    //                    \
    //                     ● END S2
    //                    (425,65)
    //
    // ============================================================

    path.cubicTo(
      x(435), // CP1
      y(0),

      x(460), // CP2
      y(18),

      x(495), // END S2
      y(65),
    );

    // ============================================================
    // S3 — SEGUNDA CURVA
    // ============================================================
    //
    // ESTA ES LA MODIFICACIÓN.
    //
    // Antes:
    //
    //      END = (530, 155)
    //
    // Ahora:
    //
    //      END = (480, 155)
    //
    // Esto hace que la transición entre S2 y S4 sea
    // horizontalmente más corta.
    //
    // Desde:
    //      (425, 65)
    //
    // CP1:
    //      (440, 100)
    //
    // CP2:
    //      (450, 145)
    //
    // Hasta:
    //      (480, 155)
    //
    //                  S2
    //                   ╲
    //                    ╲
    //                     ● (425,65)
    //                      ╲
    //                       ╲
    //                        ╲
    //                         ● CP2
    //                          ╲
    //                           ● (480,155)
    //                              ─────────── S4
    //
    // ============================================================

    path.cubicTo(
      x(525), // CP1
      y(100),

      x(540), // CP2
      y(105),

      x(575), // END S3 ← MODIFICADO
      y(110),
    );

    // ============================================================
    // S4 — LÍNEA HORIZONTAL DEL CUERPO
    // ============================================================
    //
    // Desde:
    //      (480, 155)
    //
    // Hasta:
    //      (1255, 155)
    //
    // Esta es la línea horizontal que conecta la curva
    // superior con la esquina derecha.
    //
    //       (480,155)
    //            ●──────────────────────────────●
    //                         S4             (1255,155)
    //
    // ============================================================

    path.lineTo(x(1255), y(110));

    // ============================================================
    // S5 — ESQUINA SUPERIOR DERECHA
    // ============================================================
    //
    // Desde:
    //      (1255,155)
    //
    // CP1:
    //      (1280,155)
    //
    // CP2:
    //      (1300,175)
    //
    // Hasta:
    //      (1300,200)
    //
    // Esta curva redondea la transición hacia el lado derecho.
    //
    //                         S4
    //        ────────────────────────●
    //                                ╲
    //                                 ╲ S5
    //                                  ●
    //                                  │
    //
    // ============================================================

    path.cubicTo(x(1280), y(110), x(1300), y(120), x(1300), y(135));

    // ============================================================
    // S6 — LADO DERECHO
    // ============================================================
    //
    // Desde:
    //      (1300,200)
    //
    // Hasta:
    //      (1300,290)
    //
    // Es el lateral derecho vertical.
    //
    //             ●
    //             │
    //             │
    //             │
    //             │ S6
    //             │
    //             │
    //             ●
    //
    // ============================================================

    path.lineTo(x(1300), y(290));

    // ============================================================
    // S7 — ESQUINA INFERIOR DERECHA
    // ============================================================
    //
    // Desde:
    //      (1300,290)
    //
    // CP1:
    //      (1300,315)
    //
    // CP2:
    //      (1280,335)
    //
    // Hasta:
    //      (1255,335)
    //
    // Redondea la esquina inferior derecha.
    //
    //             │
    //             │
    //             ●
    //              ╲
    //               ╲ S7
    //                ╲
    //                 ●────────────────
    //
    // ============================================================

    path.cubicTo(x(1300), y(315), x(1280), y(335), x(1255), y(335));

    // ============================================================
    // S8 — LÍNEA INFERIOR
    // ============================================================
    //
    // Desde:
    //      (1255,335)
    //
    // Hasta:
    //      (45,335)
    //
    // Es toda la parte inferior de la tarjeta.
    //
    //       ●──────────────────────────────────────●
    //      (1255,335)              S8             (45,335)
    //
    // ============================================================

    path.lineTo(x(45), y(335));

    // ============================================================
    // S9 — ESQUINA INFERIOR IZQUIERDA
    // ============================================================
    //
    // Desde:
    //      (45,335)
    //
    // CP1:
    //      (20,335)
    //
    // CP2:
    //      (0,315)
    //
    // Hasta:
    //      (0,290)
    //
    // Redondea la esquina inferior izquierda.
    //
    //       ●
    //        ╲
    //         ╲ S9
    //          ╲
    //           ●
    //           │
    //
    // ============================================================

    path.cubicTo(x(20), y(335), x(0), y(315), x(0), y(290));

    // ============================================================
    // S10 — LADO IZQUIERDO
    // ============================================================
    //
    // Desde:
    //      (0,290)
    //
    // Hasta:
    //      (0,45)
    //
    // Es el lateral izquierdo vertical.
    //
    //           ●
    //           │
    //           │
    //           │
    //           │
    //           │ S10
    //           │
    //           │
    //           ●
    //
    // ============================================================

    path.lineTo(x(0), y(45));

    // ============================================================
    // S11 — ESQUINA SUPERIOR IZQUIERDA
    // ============================================================
    //
    // Desde:
    //      (0,45)
    //
    // CP1:
    //      (0,20)
    //
    // CP2:
    //      (20,0)
    //
    // Hasta:
    //      (45,0)
    //
    // Conecta nuevamente con S1.
    //
    //           ●
    //          ╱
    //       S11
    //        ╱
    //       ●────────────── S1
    //
    // ============================================================

    path.cubicTo(x(0), y(20), x(20), y(0), x(65), y(0));

    // ============================================================
    // CERRAR PATH
    // ============================================================

    path.close();

    return path;
  }

  @override
  bool shouldReclip(covariant ProjectCardClipper oldClipper) {
    return false;
  }
}
