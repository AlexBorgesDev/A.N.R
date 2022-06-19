import 'package:A.N.R/models/chapter.dart';

class Book {
  final String name;
  final String? type;
  final String sinopse;
  final List<String> categories;
  final List<Chapter> chapters;

  const Book({
    required this.name,
    required this.sinopse,
    required this.chapters,
    required this.categories,
    this.type,
  });

  String get totalChapters {
    final String lastChapter = chapters.first.name;

    final String totalChapter = lastChapter
        .replaceAll('Cap.', '')
        .replaceAll(RegExp(r'[^0-9.]'), '')
        .replaceAll(RegExp(r','), '.')
        .split('.')
        .first
        .padLeft(2, '0');

    return totalChapter;
  }
}
