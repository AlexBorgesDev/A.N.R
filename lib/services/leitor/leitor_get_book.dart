import 'package:A.N.R/models/book.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

Future<Book> leitorGetBook(String url) async {
  String uri = 'https://leitor.net$url';

  final DioCacheManager cacheManager = DioCacheManager(
    CacheConfig(baseUrl: uri),
  );

  final Options cacheOptions = buildCacheOptions(const Duration(days: 2));

  final Dio dio = Dio();
  dio.interceptors.add(cacheManager.interceptor);

  final Response response = await dio.get(uri, options: cacheOptions);

  // ------------------ Scraping ------------------
  final Document document = parse(response.data);

  final String? sinopse =
      document.querySelector('.touchcarousel .series-desc')?.text;

  final Element? img = document.querySelector('.cover img.cover');
  final String imageURL = img?.attributes['src'] ?? '';

  final List<String> categories = [];
  final List<Element> elements = document.querySelectorAll('.tags a > span');

  for (Element element in elements) {
    categories.add(element.text.trim());
  }

  final String name = document.querySelector('.series-title > h1')?.text ?? '';
  final String updatedAt = document.querySelector('a b')?.text ?? '';
  final String total = document.querySelector('h2 > span')?.text ?? '';

  return Book(
    name: name.trim(),
    sinopse: (sinopse ?? '').trim(),
    imageURL: imageURL.trim(),
    categories: categories,
    totalChapters: total.trim(),
    updatedAt: updatedAt.trim(),
  );
}
