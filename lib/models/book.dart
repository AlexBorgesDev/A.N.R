class Book {
  final String name;
  final String sinopse;
  final String imageURL;
  final List<String> categories;
  final String? totalChapters;
  final String? updatedAt;

  const Book({
    required this.name,
    required this.sinopse,
    required this.imageURL,
    required this.categories,
    this.totalChapters,
    this.updatedAt,
  });
}
