import 'dart:io';

import 'package:A.N.R/utils/books_path.dart';

class Folders {
  static Future<String> createBook(String bookId) async {
    final Directory dir = await BooksPath.book(bookId);

    if (dir.existsSync()) return dir.path;

    await dir.create(recursive: true);
    return dir.path;
  }

  static Future<String> createChapter({
    required String bookPath,
    required String chapterId,
  }) async {
    final Directory dir = Directory('$bookPath/$chapterId');

    if (dir.existsSync()) return dir.path;

    await dir.create(recursive: true);
    return dir.path;
  }

  static Future<void> deleteChapter({
    required String bookPath,
    required String chapterId,
  }) async {
    final Directory dir = Directory('$bookPath/$chapterId');

    if (dir.existsSync()) await dir.delete(recursive: true);
  }
}
