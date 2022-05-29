class Chapter {
  final String number;
  final String url;
  final String? idSerie;
  final String? name;
  final String? id;

  const Chapter({
    required this.number,
    required this.url,
    this.idSerie,
    this.name,
    this.id,
  });
}
