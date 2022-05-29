class BookFavorite {
  final int? id;
  final String url;
  final String name;
  final String imageURL;
  final String? imageURL2;

  const BookFavorite({
    required this.url,
    required this.name,
    required this.imageURL,
    this.imageURL2,
    this.id,
  });
}
