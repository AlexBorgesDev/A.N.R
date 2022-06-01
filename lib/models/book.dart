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

  String get totalChapters => chapters.length.toString().padLeft(2, '0');
}
