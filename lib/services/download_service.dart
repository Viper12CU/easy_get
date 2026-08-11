// services/download_service.dart
import 'package:flutter/foundation.dart';
import 'package:background_downloader/background_downloader.dart';
import 'package:flutter/material.dart';

class DownloadService {
  factory DownloadService() => _instance;

  DownloadService._internal();

  static final DownloadService _instance = DownloadService._internal();

  final FileDownloader _downloader = FileDownloader();

  late final Stream<TaskUpdate> _updates = _downloader.updates
      .asBroadcastStream();

  Stream<TaskUpdate> get updates => _updates;

  // ---------------------------------------------------------------------------
  // INITIALIZATION
  // ---------------------------------------------------------------------------
  void _configureNotifications() {
    _downloader.configureNotification(
      running: const TaskNotification(
        'Descargando • {progress}',
        '{filename} •  {networkSpeed} • {timeRemaining}',
      ),
      paused: const TaskNotification(
        'Descarga pausada',
        '{filename} • {progress}',
      ),
      complete: const TaskNotification('Descarga completada', '{filename}'),
      error: const TaskNotification('Error de descarga', '{filename}'),
      canceled: const TaskNotification('Descarga cancelada', '{filename}'),
      progressBar: true,
      tapOpensFile: true,
    );
  }

  Future<void> init({int maxConcurrent = 3}) async {
    _configureNotifications();

    await requestNotificationPermission();

    await _downloader.start(
      doTrackTasks: true,
      doRescheduleKilledTasks: true,
      markDownloadedComplete: true,
      autoCleanDatabase: false,
    );

    await setMaxConcurrent(maxConcurrent);
  }

  Future<void> requestNotificationPermission() async {
    final permission = PermissionType.notifications;

    var status = await _downloader.permissions.status(permission);

    debugPrint('Notification permission status: $status');

    if (status != PermissionStatus.granted) {
      status = await _downloader.permissions.request(permission);

      debugPrint('Notification permission after request: $status');
    }
  }

  // ---------------------------------------------------------------------------
  // TASKS / DATABASE
  // ---------------------------------------------------------------------------

  /// Todas las tareas actualmente activas.
  Future<List<Task>> get activeTasks {
    return _downloader.allTasks(
      allGroups: true,
      includeTasksWaitingToRetry: true,
    );
  }

  /// Todos los registros persistentes.
  Future<List<TaskRecord>> get taskRecords {
    return _downloader.database.allRecords();
  }

  /// Registro persistente de una tarea específica.
  Future<TaskRecord?> recordForId(String taskId) {
    return _downloader.database.recordForId(taskId);
  }

  // ---------------------------------------------------------------------------
  // CONFIGURATION
  // ---------------------------------------------------------------------------

  Future<void> setMaxConcurrent(int value) async {
    await _downloader.configure(
      globalConfig: [(Config.holdingQueue, (value, null, null))],
    );
  }

  // ---------------------------------------------------------------------------
  // DOWNLOAD
  // ---------------------------------------------------------------------------

  Future<DownloadTask> enqueueDownload({
    required String url,
    required String fileName,
    String directory = '',
    BaseDirectory baseDirectory = BaseDirectory.applicationDocuments,
    bool requiresWifi = false,
    int priority = 5,
  }) async {
    final task = DownloadTask(
      url: url,
      filename: fileName,
      directory: directory,
      baseDirectory: baseDirectory,
      updates: Updates.statusAndProgress,
      allowPause: true,
      requiresWiFi: requiresWifi,
      retries: 3,
      priority: priority,
    );

    final enqueued = await _downloader.enqueue(task);

    if (!enqueued) {
      throw Exception('No se pudo encolar la descarga');
    }

    return task;
  }

  // ---------------------------------------------------------------------------
  // PAUSE / RESUME
  // ---------------------------------------------------------------------------

  Future<bool> pause(DownloadTask task) {
    return _downloader.pause(task);
  }

  Future<bool> resume(DownloadTask task) {
    return _downloader.resume(task);
  }

  // ---------------------------------------------------------------------------
  // CANCEL
  // ---------------------------------------------------------------------------

  /// Cancela la tarea y elimina completamente su TaskRecord.
  ///
  /// Después de ejecutar este método:
  ///
  ///   1. La tarea deja de ejecutarse.
  ///   2. Se cancela en el downloader nativo.
  ///   3. Se elimina su registro persistente.
  Future<bool> cancelTaskWithId(String taskId) async {
    final canceled = await _downloader.cancelTaskWithId(taskId);

    // Independientemente de que la tarea ya estuviera cancelada,
    // eliminamos su registro persistente.
    await _deleteRecord(taskId);

    return canceled;
  }

  // ---------------------------------------------------------------------------
  // DELETE
  // ---------------------------------------------------------------------------

  /// Elimina únicamente el registro persistente de una tarea.
  ///
  /// IMPORTANTE:
  /// No cancela la tarea.
  ///
  /// Por eso debe utilizarse solamente cuando sabemos que la tarea
  /// ya está en un estado final y no se está ejecutando.
  Future<void> deleteTaskRecord(String taskId) async {
    await _deleteRecord(taskId);
  }

  /// Elimina una tarea de forma segura.
  ///
  /// Si todavía está activa:
  ///     cancel + delete record
  ///
  /// Si ya terminó:
  ///     delete record
  Future<void> deleteTask(String taskId) async {
    final activeTasks = await _downloader.allTasks(
      allGroups: true,
      includeTasksWaitingToRetry: true,
    );

    final isActive = activeTasks.any((task) => task.taskId == taskId);

    if (isActive) {
      await _downloader.cancelTaskWithId(taskId);
    }

    await _deleteRecord(taskId);
  }

  Future<void> _deleteRecord(String taskId) async {
    await _downloader.database.deleteRecordWithId(taskId);
  }

  // ---------------------------------------------------------------------------
  // STORAGE
  // ---------------------------------------------------------------------------

  Future<String?> moveToDownloads(DownloadTask task) {
    return _downloader.moveToSharedStorage(task, SharedStorage.downloads);
  }
}
