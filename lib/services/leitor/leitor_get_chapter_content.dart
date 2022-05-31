import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

Future<List<ChapterImages>> leitorGetChapterContent(int id) async {
  String url = 'https://leitor.net/leitor/pages/$id.json';

  final DioCacheManager cacheManager = DioCacheManager(
    CacheConfig(baseUrl: url),
  );

  final Options cacheOptions = buildCacheOptions(const Duration(days: 2));

  final Dio dio = Dio();
  dio.interceptors.add(cacheManager.interceptor);

  final Response response = await dio.get(url, options: cacheOptions);

  final List<dynamic> items = response.data['images'];

  return items.map((e) {
    return ChapterImages(legacy: e['legacy'], avif: e['avif']);
  }).toList();
}

class ChapterImages {
  final String legacy;
  final String avif;

  const ChapterImages({required this.legacy, required this.avif});
}
