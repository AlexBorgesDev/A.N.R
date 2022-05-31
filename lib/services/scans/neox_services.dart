import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/utils/to_id.dart';
import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:html/dom.dart';
import 'package:html/parser.dart';

class NeoxServices {
  static String get baseURL => 'https://neoxscans.net';

  static final DioCacheManager _cacheManager = DioCacheManager(
    CacheConfig(baseUrl: baseURL),
  );

  static Options _cacheOptions({String? subKey}) {
    return buildCacheOptions(
      const Duration(days: 7),
      subKey: subKey,
      forceRefresh: true,
    );
  }

  static Future<List<BookItem>> get lastAdded async {
    try {
      final List<BookItem> items = [];

      final Dio dio = Dio();
      final Options options = _cacheOptions();
      dio.interceptors.add(_cacheManager.interceptor);

      final Response response = await dio.get(baseURL, options: options);

      final Document document = parse(response.data);

      final List<Element> elements =
          document.querySelectorAll('#loop-content .row div.page-item-detail');

      for (Element element in elements) {
        final Element? a = element.querySelector('h3 a');
        final Element? img = element.querySelector('img');
        if (a == null || img == null) continue;

        final String url = (a.attributes['href'] ?? '').trim();
        final String name = a.text.trim();
        final String imageURL = (img.attributes['src'] ?? '').trim();
        final String? tag = element.querySelector('span')?.text.trim();

        final String? imageURL2 = img.attributes['srcset']
            ?.split('110w, ')
            .last
            .replaceAll('350w', '');

        if (url.isNotEmpty && name.isNotEmpty && imageURL.isNotEmpty) {
          items.add(BookItem(
            id: toId(name),
            url: url,
            tag: tag,
            name: name,
            imageURL: imageURL,
            imageURL2: imageURL2,
          ));
        }
      }

      return items;
    } catch (e) {
      return [];
    }
  }
}
