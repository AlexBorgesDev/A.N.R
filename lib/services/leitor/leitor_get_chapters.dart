import 'package:A.N.R/models/chapter.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';

Future<List<Chapter>> leitorGetChapters({required int id, int? page}) async {
  String url =
      'https://leitor.net/series/chapters_list.json?page=${page ?? 1}&id_serie=$id';

  final DioCacheManager cacheManager = DioCacheManager(
    CacheConfig(baseUrl: url),
  );

  final Options cacheOptions = buildCacheOptions(
    const Duration(days: 7),
    forceRefresh: true,
  );

  final Dio dio = Dio();
  dio.interceptors.add(cacheManager.interceptor);

  final Response response = await dio.get(url, options: cacheOptions);

  final List<dynamic> items = response.data['chapters'] ?? [];

  final List<Chapter> chapters = items.map((e) {
    final Map releases = e['releases'];
    final String link = releases[releases.keys.first]['link'];

    return Chapter(
      id: e['id_chapter'].toString(),
      idSerie: e['id_serie'].toString(),
      number: e['number'].toString(),
      name: e['chapter_name'],
      url: link,
    );
  }).toList();

  return chapters;
}
