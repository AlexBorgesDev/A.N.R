import 'package:A.N.R/constants/providers.dart';

class BookItem {
  final String id;
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
