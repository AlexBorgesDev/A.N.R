import 'dart:async';
import 'dart:io';

import 'package:A.N.R/models/book.dart';
import 'package:A.N.R/models/chapter.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/screens/reader_screen.dart';
import 'package:A.N.R/services/book_info.dart';
import 'package:A.N.R/services/download_service.dart';
import 'package:A.N.R/services/favorites.dart';
import 'package:A.N.R/store/downloaded_store.dart';
import 'package:A.N.R/store/favorites_store.dart';
import 'package:A.N.R/store/historic_store.dart';
import 'package:A.N.R/styles/colors.dart';
import 'package:A.N.R/utils/books_path.dart';
import 'package:A.N.R/widgets/accent_subtitle.dart';
import 'package:A.N.R/widgets/sinopse.dart';
import 'package:A.N.R/widgets/to_info_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

import '../models/book_item.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final ScrollController _scroll = ScrollController();

  late BookItem _bookItem;
  late Favorites _favorites;
  late DownloadedStore _downloaded;

  Book? _book;
  List<Chapter> _chapters = [];

  bool _isLoading = true;
  bool _pinnedTitle = false;

  StreamSubscription<FileSystemEvent>? _folderListen;

  void _scrollListener() {
    final double imageHeight = (70 * MediaQuery.of(context).size.height) / 100;

    if (!_pinnedTitle && _scroll.offset >= imageHeight) {
      setState(() => _pinnedTitle = true);
    } else if (_pinnedTitle && _scroll.offset < imageHeight) {
      setState(() => _pinnedTitle = false);
    }
  }

  Future<void> _setWatchFolder() async {
    if (_folderListen != null) {
      _folderListen?.cancel();
      _folderListen = null;
    }

    try {
      final Directory bookDir = await BooksPath.book(_bookItem.id);

      if (!bookDir.existsSync()) {
        final Directory? appDir = await BooksPath.rootDir;
        if (appDir == null) return;

        _folderListen = appDir.watch().listen((event) {
          if (event.path.contains(_bookItem.id)) _setWatchFolder();
        });
      } else {
        _folderListen = bookDir.watch().listen((event) {
          if (event.isDirectory) {
            final String name = event.path.split('/').reversed.first.trim();
            _downloaded.add(name);
          }
        });
      }
    } catch (_) {}
  }

  @override
  void didChangeDependencies() {
    final FavoritesStore store = Provider.of<FavoritesStore>(context);
    final DownloadedStore downloaded = Provider.of<DownloadedStore>(context);

    _bookItem = ModalRoute.of(context)!.settings.arguments as BookItem;
    _favorites = Favorites(book: _bookItem, store: store, context: context);
    _downloaded = downloaded;

    bookInfo(_bookItem.url, _bookItem.name).then((value) {
      if (!mounted) return;
      setState(() {
        _book = value;
        _chapters = value?.chapters ?? [];
        _isLoading = false;
      });
    }).catchError((e) {
      if (!mounted) return;
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            'Algo deu errado ao obter as informações do ${_bookItem.tag ?? 'livro'}.',
          ),
        ),
      );
    });

    BooksPath.getChapters(_bookItem.id).then((value) => downloaded.set(value));
    _setWatchFolder();

    super.didChangeDependencies();
  }

  @override
  void initState() {
    _scroll.addListener(_scrollListener);
    super.initState();
  }

  @override
  void dispose() {
    _scroll.removeListener(_scrollListener);
    _scroll.dispose();
    _downloaded.reset();
    _folderListen?.cancel();
    _folderListen = null;

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HistoricStore store = Provider.of<HistoricStore>(context);
    final DownloadedStore downloaded = Provider.of<DownloadedStore>(context);

    return Scaffold(
      body: CustomScrollView(
        controller: _scroll,
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            title: _pinnedTitle ? Text(_bookItem.name) : null,
            pinned: true,
            centerTitle: false,
            expandedHeight: (74 * MediaQuery.of(context).size.height) / 100,
            backgroundColor: CustomColors.background,
            actions: [_favorites.button],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: CachedNetworkImage(
                      fit: BoxFit.cover,
                      imageUrl: _bookItem.imageURL,
                      errorWidget: (context, url, erro) {
                        if (_bookItem.imageURL2 == null) {
                          return const SizedBox();
                        }

                        return CachedNetworkImage(
                          fit: BoxFit.cover,
                          imageUrl: _bookItem.imageURL2!,
                        );
                      },
                    ),
                  ),
                  Positioned.fill(
                    top: 0,
                    bottom: -1,
                    child: Container(
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          stops: [0, 0.5, 0.95],
                          colors: [
                            CustomColors.background,
                            Colors.transparent,
                            CustomColors.background,
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Text(
                            _bookItem.name,
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        AccentSubtitleWithDots(
                          [
                            'Capítulos ${_book?.totalChapters ?? 0}',
                            (_bookItem.tag ?? _book?.type ?? 'Desconhecido'),
                          ],
                          margin: const EdgeInsets.only(top: 8),
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          isLoading: _isLoading,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  ShortSinopse(
                    '${_book?.sinopse}',
                    margin: const EdgeInsets.symmetric(vertical: 16),
                    isLoading: _isLoading,
                  ),
                  Container(
                    margin: const EdgeInsets.only(bottom: 24),
                    child: FittedBox(
                      child: ToInfoButton(
                        text:
                            'DETALHES DO ${_bookItem.tag?.toUpperCase() ?? 'LIVRO'}',
                        isLoading: _isLoading,
                        onPressed: () {
                          Navigator.of(context).pushNamed(
                            RoutesName.ABOUT,
                            arguments: _book,
                          );
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Capítulos',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Observer(builder: (ctx) {
                          if (_chapters.length == downloaded.total) {
                            return const IconButton(
                              icon: Icon(Icons.download_done_rounded),
                              onPressed: null,
                            );
                          }

                          return IconButton(
                            icon: const Icon(Icons.download),
                            onPressed: () {
                              _setWatchFolder();
                              DownloadService.download(_bookItem.id, _chapters);
                            },
                          );
                        })
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final Chapter chapter = _chapters[index];
                return ListTile(
                  title: Text(chapter.name),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                  trailing: Observer(builder: ((context) {
                    final book = store.historic[_bookItem.id];
                    final bool read = book?.contains(chapter.id) ?? false;

                    final List<Widget> children = [];

                    if (read) children.add(const Icon(Icons.visibility));
                    if (downloaded.chapters.containsKey(chapter.id)) {
                      children.add(const SizedBox(width: 16));
                      children.add(const Icon(Icons.download_done_rounded));
                    }

                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: children,
                    );
                  })),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      RoutesName.READER,
                      arguments: ReaderArguments(
                        book: _bookItem,
                        chapters: _chapters,
                        index: index,
                      ),
                    );
                  },
                  onLongPress: () async {
                    if (downloaded.chapters.containsKey(chapter.id)) return;

                    final String? action = await showModalBottomSheet<String>(
                      context: context,
                      builder: (context) {
                        return Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            ListTile(
                              title: const Text('Baixar capítulo'),
                              leading: const Icon(Icons.download),
                              onTap: () {
                                Navigator.of(context).pop('download');
                              },
                            ),
                          ],
                        );
                      },
                    );

                    if (action == 'download') {
                      _setWatchFolder();
                      DownloadService.download(_bookItem.id, [chapter]);
                    }
                  },
                );
              },
              childCount: _chapters.length,
            ),
          ),
        ],
      ),
    );
  }
}
