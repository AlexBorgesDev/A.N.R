import 'package:A.N.R/databases/downloads_db.dart';
import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/services/favorites.dart';
import 'package:A.N.R/services/historic.dart';
import 'package:A.N.R/services/scans/manga_host_services.dart';
import 'package:A.N.R/services/scans/mark_services.dart';
import 'package:A.N.R/services/scans/neox_services.dart';
import 'package:A.N.R/services/scans/prisma_services.dart';
import 'package:A.N.R/services/scans/random_services.dart';
import 'package:A.N.R/utils/start_download.dart';
import 'package:A.N.R/widgets/book_element_horizontal_list.dart';
import 'package:A.N.R/widgets/section_list_title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isLoading = true;

  List<BookItem> _neox = [];
  List<BookItem> _mark = [];
  List<BookItem> _random = [];
  List<BookItem> _prisma = [];
  List<BookItem> _mangaHost = [];

  Future<void> _handleGetDatas() async {
    final items = await Future.wait([
      NeoxServices.lastAdded,
      MarkServices.lastAdded,
      RandomServices.lastAdded,
      PrismaServices.lastAdded,
      MangaHostServices.lastAdded,
    ]);

    setState(() {
      _neox = items[0];
      _mark = items[1];
      _random = items[2];
      _prisma = items[3];
      _mangaHost = items[4];
      _isLoading = false;
    });
  }

  Future<void> _handleStartDownload() async {
    final items = await DownloadsDB.db.notFinished;
    if (items.isNotEmpty) startDownload();
  }

  @override
  void initState() {
    FlutterNativeSplash.remove();
    _handleGetDatas();
    _handleStartDownload();

    super.initState();
  }

  @override
  void didChangeDependencies() {
    Favorites.getAll(context);
    Historic.getAll(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('A.N.R'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RoutesName.SEARCH);
            },
            icon: const Icon(Icons.search),
          ),
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(RoutesName.FAVORITES);
            },
            icon: const Icon(Icons.favorite),
          )
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _handleGetDatas,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SectionListTitle('Neox - Últimos adicionados'),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _neox.length,
                itemData: (index) {
                  final BookItem book = _neox[index];
                  return BookElementData(
                    tag: book.tag,
                    imageURL: book.imageURL,
                    imageURL2: book.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: book,
                      );
                    },
                  );
                },
              ),
              const SectionListTitle('Random Scan - Últimos adicionados'),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _random.length,
                itemData: (index) {
                  final BookItem book = _random[index];
                  return BookElementData(
                    tag: book.tag,
                    imageURL: book.imageURL2 ?? book.imageURL,
                    imageURL2: book.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: book,
                      );
                    },
                  );
                },
              ),
              const SectionListTitle('Mark Scans - Últimos adicionados'),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _mark.length,
                itemData: (index) {
                  final BookItem book = _mark[index];
                  return BookElementData(
                    tag: book.tag,
                    imageURL: book.imageURL,
                    imageURL2: book.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: book,
                      );
                    },
                  );
                },
              ),
              const SectionListTitle('Prisma Scans - Últimos adicionados'),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _prisma.length,
                itemData: (index) {
                  final BookItem book = _prisma[index];
                  return BookElementData(
                    tag: book.tag,
                    headers: book.headers,
                    imageURL: book.imageURL,
                    imageURL2: book.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: book,
                      );
                    },
                  );
                },
              ),
              const SectionListTitle('Mangá Host - Últimos adicionados'),
              BookElementHorizontalList(
                isLoading: _isLoading,
                itemCount: _mangaHost.length,
                itemData: (index) {
                  final BookItem book = _mangaHost[index];
                  return BookElementData(
                    tag: book.tag,
                    is18: book.is18,
                    headers: book.headers,
                    imageURL: book.imageURL,
                    imageURL2: book.imageURL2,
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        RoutesName.BOOK,
                        arguments: book,
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
