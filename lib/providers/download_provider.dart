// providers/download_provider.dart

import 'dart:async';

import 'package:background_downloader/background_downloader.dart' as bg;
import 'package:flutter/foundation.dart';

import '../models/app_download.dart';
import '../services/download_service.dart';

class DownloadProvider extends ChangeNotifier {
  DownloadProvider({DownloadService? service})
    : _service = service ?? DownloadService() {
    _sub = _service.updates.listen(_onUpdate);
  }

  final DownloadService _service;

  late final StreamSubscription<bg.TaskUpdate> _sub;

  int maxConcurrentDownloads = 3;

  final Map<String, AppDownload> _tasks = {};

  bool _initialized = false;

  bool get initialized => _initialized;

  bool _initLoading = false;

  bool get initLoading => _initLoading;

  List<AppDownload> get tasks {
    final result = _tasks.values.toList();

    result.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    return result;
  }

  int get activeCount {
    return _tasks.values
        .where((d) => d.status == AppDownloadStatus.downloading)
        .length;
  }

  int get queuedCount {
    return _tasks.values
        .where((d) => d.status == AppDownloadStatus.queued)
        .length;
  }

  int get pausedCount {
    return _tasks.values
        .where((d) => d.status == AppDownloadStatus.paused)
        .length;
  }

  int get completedCount {
    return _tasks.values
        .where((d) => d.status == AppDownloadStatus.completed)
        .length;
  }

  int get errorCount {
    return _tasks.values
        .where((d) => d.status == AppDownloadStatus.error)
        .length;
  }

  /// Inicializa el downloader y recupera las tareas existentes.
  ///
  /// IMPORTANTE:
  /// background_downloader mantiene la información de las tareas
  /// fuera del estado de este Provider.
  ///
  /// Por eso, cuando Flutter vuelve a arrancar, reconstruimos
  /// _tasks desde la información persistente del plugin.
  Future<void> init() async {
    if (_initialized) {
      return;
    }

    _initLoading = true;

    await _service.init(maxConcurrent: maxConcurrentDownloads);

    await _restoreTasks();

    _initialized = true;

    _initLoading = false;

    notifyListeners();
  }

  /// Recupera las tareas almacenadas por background_downloader.
  ///
  /// Utilizamos database.allRecords() porque contiene TaskRecord
  /// persistentes, incluyendo tareas que ya terminaron.
  ///
  /// Además consultamos allTasks() para asegurarnos de que las tareas
  /// activas que existen actualmente en el downloader nativo también
  /// estén presentes.
  Future<void> _restoreTasks() async {
    _tasks.clear();

    // ---------------------------------------------------------------
    // 1. Recuperar registros persistentes
    // ---------------------------------------------------------------

    final records = await _service.taskRecords;

    for (final record in records) {
      if (record.task is! bg.DownloadTask) {
        continue;
      }

      final downloadTask = record.task as bg.DownloadTask;

      final download = AppDownload(task: downloadTask);

      download.status = _mapStatus(record.status);
      download.progress = record.progress;

      if (record.expectedFileSize > 0) {
        download.expectedFileSize = record.expectedFileSize;
      }

      if (record.exception != null) {
        download.errorMessage =
            record.exception?.description ?? 'Error de descarga';
      }

      _tasks[download.id] = download;
    }

    // ---------------------------------------------------------------
    // 2. Recuperar tareas actualmente activas
    // ---------------------------------------------------------------

    final activeTasks = await _service.activeTasks;

    for (final task in activeTasks) {
      if (task is! bg.DownloadTask) {
        continue;
      }

      final existing = _tasks[task.taskId];

      if (existing != null) {
        // Ya tenemos información persistente.
        // Conservamos el objeto y actualizamos la Task.
        existing.task = task;

        continue;
      }

      // La tarea existe en el downloader nativo pero todavía
      // no estaba representada en nuestro mapa.
      final download = AppDownload(task: task);

      _tasks[download.id] = download;
    }
  }

  Future<void> addDownload({
    required String url,
    String? fileName,
    bool requiresWifi = false,
    int priority = 5,
    String dir = "descargas",
  }) async {
    final name = fileName ?? url.split('/').last.split('?').first;

    final nativeTask = await _service.enqueueDownload(
      url: url,
      fileName: name,
      directory: 'descargas',
      requiresWifi: requiresWifi,
      priority: priority
    );

    final download = AppDownload(task: nativeTask);

    download.status = AppDownloadStatus.queued;

    _tasks[download.id] = download;

    notifyListeners();
  }

  AppDownload detectFile (String url){
    final task = _service.detectFile(url: url);


    AppDownload download = AppDownload(task: task );

    return download;
  }

  Future<void> pauseDownload(String id) async {
    final d = _tasks[id];

    if (d == null) {
      return;
    }

    await _service.pause(d.task);
  }

  Future<void> resumeDownload(String id) async {
    final d = _tasks[id];

    if (d == null) {
      return;
    }

    await _service.resume(d.task);
  }

  /// Reintento manual.
  Future<void> retryDownload(String id) async {
    final d = _tasks[id];

    if (d == null) {
      debugPrint("No existe");
      return;
    }

    await _service.resume(d.task);
  }

  Future<void> removeCompletedDownload(String id) async {
    final download = _tasks[id];

    if (download == null) {
      return;
    }

    if (download.status != AppDownloadStatus.completed) {
      return;
    }

    await _service.deleteTask(id);

    _tasks.remove(id);

    notifyListeners();
  }

  Future<void> cancelDownload(String id) async {
    final d = _tasks[id];

    if (d == null) {
      return;
    }

    await _service.cancelTaskWithId(id);



    notifyListeners();
  }

  Future<void> removeDownload(String id) async {
    final d = _tasks[id];

    if (d == null) {
      return;
    }

    await _service.deleteTaskRecord(d.id);

    _tasks.remove(d.id);

    notifyListeners();
  }

  void clearCompleted() {
    _tasks.removeWhere((_, d) => d.status == AppDownloadStatus.completed);

    notifyListeners();
  }

  Future<void> updateMaxConcurrent(int value) async {
    maxConcurrentDownloads = value;

    await _service.setMaxConcurrent(value);

    notifyListeners();
  }

  void _onUpdate(bg.TaskUpdate update) {
    switch (update) {
      case bg.TaskStatusUpdate():
        _handleStatusUpdate(update);

      case bg.TaskProgressUpdate():
        _handleProgressUpdate(update);
    }
  }

  void _handleStatusUpdate(bg.TaskStatusUpdate update) {
    final task = update.task;

    if (task is! bg.DownloadTask) {
      return;
    }

    var d = _tasks[task.taskId];

    // Puede ocurrir que el evento llegue antes de que la tarea
    // haya sido restaurada manualmente.
    //
    // En ese caso la creamos.
    if (d == null) {
      d = AppDownload(task: task);

      _tasks[task.taskId] = d;
    }

    d.task = task;

    d.status = _mapStatus(update.status);

    if (update.exception != null) {
      d.errorMessage = update.exception?.description ?? 'Error de conexión';
    }

    if (update.status == bg.TaskStatus.complete) {
      unawaited(_moveToDownloadsFolder(d));
    }

    notifyListeners();
  }

  void _handleProgressUpdate(bg.TaskProgressUpdate update) {
    final task = update.task;

    if (task is! bg.DownloadTask) {
      return;
    }

    final d = _tasks[task.taskId];

    if (d == null) {
      return;
    }

    d.task = task;

     // background_downloader utiliza valores negativos como códigos
  // especiales de estado. NO son porcentajes.
  //
  // Por ejemplo:
  // -1 = failed
  // -2 = canceled
  // -3 = notFound
  // -4 = waitingToRetry
  // -5 = paused (versiones que usan este código)
  //
  // Conservamos el último progreso válido.
  if (update.progress >= 0.0 &&
      update.progress <= 1.0) {
    d.progress = update.progress;
  }

    if (update.hasExpectedFileSize) {
      d.expectedFileSize = update.expectedFileSize;
    }

    if (update.hasNetworkSpeed) {
      d.networkSpeedMBs = update.networkSpeed;
    }

    if (update.hasTimeRemaining) {
      d.timeRemaining = update.timeRemaining;
    }

    notifyListeners();
  }

  AppDownloadStatus _mapStatus(bg.TaskStatus status) {
    switch (status) {
      case bg.TaskStatus.enqueued:
      case bg.TaskStatus.waitingToRetry:
        return AppDownloadStatus.queued;

      case bg.TaskStatus.running:
        return AppDownloadStatus.downloading;

      case bg.TaskStatus.paused:
        return AppDownloadStatus.paused;

      case bg.TaskStatus.complete:
        return AppDownloadStatus.completed;

      case bg.TaskStatus.canceled:
        return AppDownloadStatus.canceled;

      case bg.TaskStatus.failed:
      case bg.TaskStatus.notFound:
        return AppDownloadStatus.error;
    }
  }

  Future<void> _moveToDownloadsFolder(AppDownload d) async {
    final newPath = await _service.moveToDownloads(d.task);

    if (newPath != null) {
      d.publicFilePath = newPath;

      notifyListeners();
    }
  }

  @override
  void dispose() {
    _sub.cancel();

    super.dispose();
  }
}
