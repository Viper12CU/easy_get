// models/app_download.dart

import 'package:background_downloader/background_downloader.dart' as bg;

enum AppDownloadStatus {
  queued,
  downloading,
  paused,
  completed,
  error,
  canceled,
}

class AppDownload {
  AppDownload({
    required this.task,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Tarea nativa de background_downloader.
  ///
  /// Se actualiza cuando recibimos un TaskStatusUpdate.
  bg.DownloadTask task;

  /// Fecha en la que esta descarga fue agregada a nuestra UI.
  ///
  /// Cuando la tarea es restaurada desde background_downloader,
  /// utilizamos la fecha disponible en TaskRecord si existe.
  final DateTime createdAt;

  String get id => task.taskId;

  String get fileName => task.filename;

  String get url => task.url;

  AppDownloadStatus status = AppDownloadStatus.queued;

  /// Progreso 0..1.
  double progress = 0;

  int? expectedFileSize;

  double? networkSpeedMBs;

  Duration? timeRemaining;

  String? errorMessage;

  /// Path en la carpeta pública de Descargas.
  String? publicFilePath;

  int get progressPercent => (progress * 100).round();

  String get formattedSpeed {
    if (networkSpeedMBs == null || networkSpeedMBs! <= 0) {
      return '—';
    }

    return '${networkSpeedMBs!.toStringAsFixed(1)} MB/s';
  }

  String get formattedEta {
    final d = timeRemaining;

    if (d == null || d.isNegative) {
      return '—';
    }

    final m = d.inMinutes;
    final s = d.inSeconds % 60;

    return '$m:${s.toString().padLeft(2, '0')}';
  }

  String get formattedSize {
    final bytes = expectedFileSize;

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