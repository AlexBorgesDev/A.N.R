import 'package:A.N.R/constants/providers.dart';

class BookItem {
  final int id;
  final String url;
  final String name;
  final String? imageURL;
  final String? imageURL2;
  final Providers provider;

  const BookItem({
    required this.url,
    required this.name,
    required this.provider,
    required this.id,
    this.imageURL,
    this.imageURL2,
  });
}
