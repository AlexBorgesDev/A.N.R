import 'dart:io';

import 'package:A.N.R/models/chapter.dart';
import 'package:A.N.R/services/book_content.dart';
import 'package:A.N.R/utils/books_path.dart';
import 'package:A.N.R/utils/file_mime_by_url.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  static Future<String> _createBookFolder(String bookId) async {
    final Directory directory = await BooksPath.book(bookId);

    if (directory.existsSync()) {
      return directory.path;
    } else {
      await directory.create(recursive: true);
      return directory.path;
    }
  }

  static Future<String> _createChapterFolder(
    String bookPath,
    Chapter chapter,
  ) async {
    final dir = Directory('$bookPath/${chapter.id}');

    if (dir.existsSync()) {
      return dir.path;
    } else {
      await dir.create(recursive: true);
      return dir.path;
    }
  }

  static Future<void> download(String bookId, List<Chapter> chapters) async {
    final PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted && !status.isLimited) return;

    final String bookPath = await _createBookFolder(bookId);

    for (Chapter chapter in chapters) {
      final List<String> content = await bookContent(chapter.url);
      final String path = await _createChapterFolder(bookPath, chapter);

      Directory(path).listSync().length;

      int index = 0;

      for (String url in content) {
        index++;

        final type = fileMimeByUrl(url);
        await FlutterDownloader.enqueue(
          url: url,
          savedDir: path,
          fileName: '$index.$type',
          showNotification: false,
          openFileFromNotification: false,
        );
      }
    }
  }
}
