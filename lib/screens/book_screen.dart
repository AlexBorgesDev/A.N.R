import 'package:A.N.R/models/book.dart';
import 'package:A.N.R/models/chapter.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/screens/reader_screen.dart';
import 'package:A.N.R/services/book_info.dart';
import 'package:A.N.R/services/favorites.dart';
import 'package:A.N.R/store/favorites_store.dart';
import 'package:A.N.R/store/historic_store.dart';
import 'package:A.N.R/styles/colors.dart';
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

  Book? _book;
  List<Chapter> _chapters = [];

  bool _isLoading = true;
  bool _pinnedTitle = false;

  void _scrollListener() {
    final double imageHeight = (70 * MediaQuery.of(context).size.height) / 100;

    if (!_pinnedTitle && _scroll.offset >= imageHeight) {
      setState(() => _pinnedTitle = true);
    } else if (_pinnedTitle && _scroll.offset < imageHeight) {
      setState(() => _pinnedTitle = false);
    }
  }

  @override
  void didChangeDependencies() {
    final FavoritesStore store = Provider.of<FavoritesStore>(context);

    _bookItem = ModalRoute.of(context)!.settings.arguments as BookItem;
    _favorites = Favorites(book: _bookItem, store: store, context: context);

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

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final HistoricStore store = Provider.of<HistoricStore>(context);

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
                        onPressed: () {},
                      ),
                    ),
                  ),
                  Container(
                    width: double.infinity,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: const Text(
                      'Capítulos',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
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

                    if (!read) return const SizedBox();
                    return const Icon(Icons.visibility);
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
