import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

Future<List<BookLeitorHighlights>> leitorHighlights() async {
  const String url = 'https://leitor.net/home/getFeaturedSeries.json';

  final DioCacheManager cacheManager = DioCacheManager(
    CacheConfig(baseUrl: url),
  );

  final Options cacheOptions = buildCacheOptions(const Duration(days: 7));

  final Dio dio = Dio();
  dio.interceptors.add(cacheManager.interceptor);

  try {
    Response response = await dio.get(url, options: cacheOptions);

    final List<dynamic> items = response.data['featured'];
    final List<BookLeitorHighlights> itemsData = items.map((item) {
      String url = item['link'];

      url = url.replaceAll('/${item['chapter']['id_release']}', '');
      url = url.replaceAll('/${item['chapter']['number']}', '');

      return BookLeitorHighlights(
        id: item['id_serie'],
        url: url,
        name: item['series_name'],
        hexColor: item['hex_color'],
        imageURL: item['featured_image'],
        domain: item['domain'],
        chapter: item['chapter']['number'].toString(),
      );
    }).toList();

    return itemsData;
  } catch (e) {
    return [];
  }
}

class BookLeitorHighlights {
  final int id;
  final String url;
  final String name;
  final String hexColor;
  final String imageURL;
  final String? domain;
  final String? chapter;

  const BookLeitorHighlights({
    required this.id,
    required this.url,
    required this.name,
    required this.hexColor,
    required this.imageURL,
    this.chapter,
    this.domain,
  });
}
