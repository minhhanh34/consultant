import 'dart:developer';
import 'dart:io';
import 'package:consultant/models/exercise_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

abstract class DownloaderService {
  Future<File?> download(FileName fileName);
}

class DownloaderServiceIml extends DownloaderService {
  static final DownloaderService _instance =
      DownloaderServiceIml._privateContructor();

  DownloaderServiceIml._privateContructor();

  static DownloaderService get instance => _instance;

  @override
  Future<File?> download(FileName fileName) async {
    final dir = await getExternalStorageDirectory();
    final response = await http.get(Uri.parse(fileName.url));
    if (response.statusCode == 200) {
      try {
        final bytes = response.bodyBytes.toList();
        final file = File('${dir!.path}/${fileName.name}');
        return await file.writeAsBytes(bytes);
      } catch (error) {
        log('error', error: error);
      }
    }
    return null;
  }
}

enum DownloadState {
  unDownload,
  downloading,
  downloaded,
}
