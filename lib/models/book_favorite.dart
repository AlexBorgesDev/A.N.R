class BookFavorite {
  final String id;
  final String url;
  final String name;
  final String imageURL;
  final String? imageURL2;

  const BookFavorite({
    required this.id,
    required this.url,
    required this.name,
    required this.imageURL,
    this.imageURL2,
  });

  Map<String, String?> get toMap {
    return {
      'id': id,
      'url': url,
      'name': name,
      'imageURL': imageURL,
      'imageURL2': imageURL2,
    };
  }
}
