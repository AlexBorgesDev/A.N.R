import 'package:A.N.R/models/search_result.dart';
import 'package:dio/dio.dart';

Future<List<SearchResult>> leitorSearch(String value) async {
  const String url = 'https://leitor.net/lib/search/series.json';
  final Dio dio = Dio();

  final Response response = await dio.post(
    url,
    data: {'search': value},
    options: Options(headers: {'x-requested-with': 'XMLHttpRequest'}),
  );
  final List<dynamic> series = response.data['series'];

  return series.map((item) {
    return SearchResult(
      id: item['id_serie'],
      url: item['link'],
      tag: item['score'],
      name: item['name'] ?? item['label'],
      imageURL: item['cover'],
      imageURL2: item['cover_thumb'],
    );
  }).toList();
}
