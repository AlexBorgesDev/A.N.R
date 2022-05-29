import 'package:A.N.R/models/book.dart';
import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/models/chapter.dart';
import 'package:A.N.R/services/leitor/leitor_get_book.dart';
import 'package:A.N.R/services/leitor/leitor_get_chapters.dart';
import 'package:A.N.R/styles/colors.dart';
import 'package:A.N.R/widgets/accent_subtitle.dart';
import 'package:A.N.R/widgets/sinopse.dart';
import 'package:A.N.R/widgets/to_info_button.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BookScreen extends StatefulWidget {
  const BookScreen({Key? key}) : super(key: key);

  @override
  State<BookScreen> createState() => _BookScreenState();
}

class _BookScreenState extends State<BookScreen> {
  final ScrollController _scroll = ScrollController();

  late BookItem _bookItem;

  Book? _book;

  bool _isLoading = true;
  bool _pinnedTitle = false;

  // ---- Chapter ----
  int _page = 1;
  bool _isLastPage = false;
  bool _isLoadingChapter = true;
  final List<Chapter> _chapters = [];

  void _scrollListener() {
    final double imageHeight = (70 * MediaQuery.of(context).size.height) / 100;

    if (!_pinnedTitle && _scroll.offset >= imageHeight) {
      setState(() => _pinnedTitle = true);
    } else if (_pinnedTitle && _scroll.offset < imageHeight) {
      setState(() => _pinnedTitle = false);
    }
  }

  void _fetchChapterListener() {
    if (_isLastPage || _isLoadingChapter) return;

    final double triggerFetchMoreSize = 0.8 * _scroll.position.maxScrollExtent;
    if (_scroll.position.pixels > triggerFetchMoreSize) {
      _page = _page + 1;
      _handleGetChapters();
    }
  }

  Future<void> _handleGetBook() async {
    try {
      final Book book = await leitorGetBook(_bookItem.url);

      if (_bookItem.imageURL == null) {
        _bookItem = BookItem(
          id: _bookItem.id,
          url: _bookItem.url,
          name: _bookItem.name,
          provider: _bookItem.provider,
          imageURL: book.imageURL,
        );
      }

      setState(() {
        _book = book;
        _isLoading = false;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Algo deu errado ao obter as informações do livro'),
        ),
      );
    }
  }

  Future<void> _handleGetChapters() async {
    _isLoadingChapter = true;

    try {
      final List<Chapter> chapters = await leitorGetChapters(
        id: _bookItem.id,
        page: _page,
      );

      setState(() {
        _chapters.addAll(chapters);
        _isLastPage = chapters.length < 30;
        _isLoadingChapter = false;
      });
    } catch (err) {
      _isLoadingChapter = false;

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Algo deu errado ao obter os capítulos'),
      ));
    }
  }

  @override
  void didChangeDependencies() {
    _bookItem = ModalRoute.of(context)!.settings.arguments as BookItem;
    _handleGetBook();
    _handleGetChapters();
    _scroll.addListener(_fetchChapterListener);

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
    _scroll.removeListener(_fetchChapterListener);
    _scroll.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            actions: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.favorite_outline),
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              collapseMode: CollapseMode.pin,
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Positioned.fill(
                    child: _bookItem.imageURL != null
                        ? CachedNetworkImage(
                            fit: BoxFit.cover,
                            imageUrl: _bookItem.imageURL ?? '',
                            errorWidget: (context, url, error) {
                              if (_bookItem.imageURL2 == null) {
                                return const SizedBox();
                              }

                              return CachedNetworkImage(
                                fit: BoxFit.cover,
                                imageUrl: _bookItem.imageURL2!,
                              );
                            },
                          )
                        : const SizedBox(),
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
                            _book?.totalChapters != null
                                ? '${_book!.totalChapters} capítulos'
                                : '',
                            _book?.updatedAt != null
                                ? 'Atualiza a cada ${_book!.updatedAt}'
                                : ''
                          ],
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          margin: const EdgeInsets.only(top: 6),
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
                        text: 'DETALHES DO LIVRO',
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
            delegate: SliverChildBuilderDelegate((context, index) {
              final Chapter chapter = _chapters[index];

              return ListTile(
                title: Text('Capítulo ${chapter.number}'),
                contentPadding: const EdgeInsets.symmetric(horizontal: 32),
                onTap: () {},
              );
            }, childCount: _chapters.length),
          ),
          SliverToBoxAdapter(
            child: _isLastPage
                ? null
                : const Center(child: CircularProgressIndicator()),
          )
        ],
      ),
    );
  }
}
