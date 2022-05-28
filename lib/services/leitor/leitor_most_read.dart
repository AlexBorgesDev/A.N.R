import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

Future<List<BookLeitorMostRead>> leitorMostRead({int? page}) async {
  String url = 'https://leitor.net/home/most_read?page=${page ?? 1}&type=';

  final DioCacheManager cacheManager = DioCacheManager(
    CacheConfig(baseUrl: url),
  );

  final Options cacheOptions = buildCacheOptions(const Duration(days: 7));

  final Dio dio = Dio();
  dio.interceptors.add(cacheManager.interceptor);

  try {
    final Response response = await dio.get(url, options: cacheOptions);

    final List<dynamic> items = response.data['most_read'];
    final List<BookLeitorMostRead> itemsData = items.map((item) {
      return BookLeitorMostRead(
        id: item['id_serie'],
        url: item['link'],
        name: item['serie_name'],
        imageURL: item['cover'],
        imageURL2: item['cover_thumb'],
      );
    }).toList();

    return itemsData;
  } catch (e) {
    return [];
  }
}

class BookLeitorMostRead {
  final int id;
  final String url;
  final String name;
  final String imageURL;
  final String imageURL2;

  const BookLeitorMostRead({
    required this.id,
    required this.url,
    required this.name,
    required this.imageURL,
    required this.imageURL2,
  });
}
