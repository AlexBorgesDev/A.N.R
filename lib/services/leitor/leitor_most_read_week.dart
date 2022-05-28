import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

Future<List<BookLeitorMostReadWeek>> leitorMostReadWeek() async {
  const String url =
      'https://leitor.net/home/most_read_period?period=week&type=';

  final DioCacheManager cacheManager = DioCacheManager(
    CacheConfig(baseUrl: url),
  );

  final Options cacheOptions = buildCacheOptions(const Duration(days: 7));

  final Dio dio = Dio();
  dio.interceptors.add(cacheManager.interceptor);

  try {
    final Response response = await dio.get(url, options: cacheOptions);

    final List<dynamic> items = response.data['most_read'];

    final List<dynamic> filteredItems =
        items.where((item) => item['adult_content'] == 0).toList();

    final List<BookLeitorMostReadWeek> itemsData = filteredItems.map((item) {
      return BookLeitorMostReadWeek(
        id: item['id_serie'],
        url: item['serie_link'],
        name: item['series_name'],
        imageURL: item['series_image'],
        imageURL2: item['series_image_thumb'],
        chapter: item['chapter_number'].toString(),
      );
    }).toList();

    return itemsData;
  } catch (e) {
    return [];
  }
}

class BookLeitorMostReadWeek {
  final int id;
  final String url;
  final String name;
  final String imageURL;
  final String imageURL2;
  final String? chapter;

  const BookLeitorMostReadWeek({
    required this.id,
    required this.url,
    required this.name,
    required this.imageURL,
    required this.imageURL2,
    this.chapter,
  });
}
