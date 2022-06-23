import 'dart:io';

import 'package:A.N.R/models/chapter.dart';
import 'package:A.N.R/services/book_content.dart';
import 'package:A.N.R/store/download_store.dart';
import 'package:A.N.R/utils/books_path.dart';
import 'package:A.N.R/utils/file_mime_by_url.dart';
import 'package:dio/dio.dart';
import 'package:permission_handler/permission_handler.dart';

class DownloadService {
  final String bookId;
  final DownloadStore store;

  const DownloadService({required this.store, required this.bookId});

  Future<void> download(List<Chapter> chapters, {bool? all}) async {
    final PermissionStatus status = await Permission.storage.request();
    if (!status.isGranted && !status.isLimited) return;

    final String bookPath = await _createBookFolder(bookId);

    for (Chapter chapter in chapters) {
      final List<String> content = await bookContent(chapter.url);
      final String path = await _createChapterFolder(bookPath, chapter.id);

      store.addDownloading(bookId, all == true ? null : chapter.id);

      int index = 0;
      for (String url in content) {
        index++;

        final String type = fileMimeByUrl(url);
        final String savePath = Directory('$path/$index.$type').path;

        await Dio().download(url, savePath);
      }

      store.add(chapter);
    }

    store.removeDownloading(bookId);
  }

  Future<String> _createBookFolder(String bookId) async {
    final Directory directory = await BooksPath.book(bookId);

    if (directory.existsSync()) {
      return directory.path;
    } else {
      await directory.create(recursive: true);
      return directory.path;
    }
  }

  Future<String> _createChapterFolder(
    String bookPath,
    String chapterId,
  ) async {
    final dir = Directory('$bookPath/$chapterId');

    if (dir.existsSync()) {
      return dir.path;
    } else {
      await dir.create(recursive: true);
      return dir.path;
    }
  }
}
