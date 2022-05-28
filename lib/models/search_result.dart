class SearchResult {
  final int? id;
  final String? tag;
  final String url;
  final String name;
  final String imageURL;
  final String? imageURL2;

  const SearchResult({
    required this.url,
    required this.name,
    required this.imageURL,
    this.imageURL2,
    this.tag,
    this.id,
  });
}
