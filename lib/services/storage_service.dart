import 'dart:io';

import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class StorageService {
  static const String downloadDirectoryName = 'descargas';

  Future<Directory> getDownloadDirectory() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final downloadDirectory = Directory(
      '${documentsDirectory.path}/$downloadDirectoryName',
    );

    if (!await downloadDirectory.exists()) {
      await downloadDirectory.create(recursive: true);
    }

    return downloadDirectory;
  }

  Future<OpenResult> openDownloadDirectory() async {
    final downloadDirectory = await getDownloadDirectory();
    return OpenFilex.open(downloadDirectory.path);
  }
}
