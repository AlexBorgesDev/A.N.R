// import 'package:animes_player/models/book.dart';
// import 'package:html/dom.dart';
// import 'package:html/parser.dart';
// import 'package:http/http.dart';

// class MarkServices {
//   static String get baseURL => 'https://markscans.online';

//   static Future<List<BookItem>> get lastAdded async {
//     try {
//       final List<BookItem> items = [];

//       final Response response = await get(Uri.parse(baseURL));
//       final Document document = parse(response.body);

//       final List<Element> elements =
//           document.querySelectorAll('#loop-content .page-item-detail');

//       for (var element in elements) {
//         final Element? h3A = element.querySelector('h3 a');
//         final Element? img = element.querySelector('img');
//         if (h3A == null || img == null) continue;

//         final String url = (h3A.attributes['href'] ?? '').trim();
//         final String name = h3A.text.trim();
//         final String imageURL = (img.attributes['src'] ?? '').trim();

//         final String? tag =
//             element.querySelector('span.manga-type')?.text.trim();

//         if (url.isNotEmpty && name.isNotEmpty && imageURL.isNotEmpty) {
//           items.add(
//             BookItem(url: url, tag: tag, name: name, imageURL: imageURL),
//           );
//         }
//       }

//       return items;
//     } catch (e) {
//       return [];
//     }
//   }

//   static Future<List<BookItem>> search(String value) async {
//     final List<BookItem> items = [];

//     final Uri uri = Uri.parse('$baseURL/?s=$value&post_type=wp-manga');
//     final Response response = await get(uri);
//     final Document document = parse(response.body);

//     final List<Element> elements =
//         document.querySelectorAll('.c-tabs-item div.row');

//     for (var element in elements) {
//       final Element? h3A = element.querySelector('h3.h4 > a');
//       final Element? img = element.querySelector('a img');
//       if (h3A == null || img == null) continue;

//       final String url = (h3A.attributes['href'] ?? '').trim();
//       final String name = h3A.text.trim();
//       final String imageURL = (img.attributes['src'] ?? '').trim();

//       if (url.isNotEmpty && name.isNotEmpty && imageURL.isNotEmpty) {
//         items.add(BookItem(url: url, name: name, imageURL: imageURL));
//       }
//     }

//     return items;
//   }

//   static Future<Book> bookInfo(String url, String name) async {
//     final Response response = await get(Uri.parse(url));
//     final Document document = parse(response.body);

//     final List<Chapter> chapters = [];
//     final List<String> categories = [];

//     // Categories
//     List<Element> elements = document.querySelectorAll('.genres-content a');
//     for (var element in elements) {
//       final String name = element.text.trim();
//       if (name.isNotEmpty) categories.add(name);
//     }

//     // Type
//     String? type;
//     elements = document.querySelectorAll('.post-content_item');
//     elements.removeWhere((element) {
//       return element.querySelector('h5')?.text.trim().toLowerCase() != 'tipo';
//     });

//     if (elements.isNotEmpty) {
//       type = elements[0].querySelector('.summary-content')?.text.trim();
//     }

//     // Sinopse
//     final String sinopse = document
//             .querySelector('.description-summary > .post-content_item')
//             ?.text
//             .trim() ??
//         '';

//     // Chapters
//     try {
//       final Response res = await post(Uri.parse('${url}ajax/chapters'));
//       final Document chapterDocument = parse(res.body);

//       elements =
//           chapterDocument.querySelectorAll('ul.main > li.wp-manga-chapter');

//       for (var element in elements) {
//         final Element? a = element.querySelector('a');
//         if (a == null) continue;

//         final String url = (a.attributes['href'] ?? '').trim();
//         final String name = a.text.trim();

//         if (url.isNotEmpty && name.isNotEmpty) {
//           chapters.add(Chapter(url: url, name: name));
//         }
//       }
//       // ignore: empty_catches
//     } catch (e) {}

//     return Book(
//       name: name,
//       type: type,
//       sinopse: sinopse,
//       chapters: chapters,
//       categories: categories,
//     );
//   }

//   static Future<List<String>> getBookContent(String url) async {
//     final List<String> content = [];

//     final Response response = await get(Uri.parse(url));
//     final Document document = parse(response.body);

//     final List<Element> elements =
//         document.querySelectorAll('.reading-content img');

//     for (var element in elements) {
//       final String url = (element.attributes['src'] ?? '').trim();
//       if (url.isNotEmpty) content.add(url);
//     }

//     return content;
//   }
// }
