import 'package:A.N.R/constants/providers.dart';
import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/services/search.dart';
import 'package:A.N.R/utils/grid.dart';
import 'package:A.N.R/widgets/book_element.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isLoading = false;
  List<BookItem> _results = [];
  Providers _provider = Providers.NEOX;

  Future<void> _onSubmitted(String value) async {
    setState(() => _isLoading = true);

    List<BookItem> results = [];

    try {
      results = await search(value, _provider);
    } catch (e) {
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

      messenger.clearSnackBars();
      messenger.showSnackBar(
        const SnackBar(content: Text('Ocorreu um erro ao buscar pelo livro')),
      );
    } finally {
      setState(() {
        _results = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            snap: false,
            title: Text('${_provider.value} - Buscar livro...'),
            pinned: true,
            actions: [
              PopupMenuButton<Providers>(
                enabled: !_isLoading,
                initialValue: _provider,
                onSelected: (value) => setState(() => _provider = value),
                itemBuilder: (ctx) => <PopupMenuEntry<Providers>>[
                  const PopupMenuItem(
                    value: Providers.NEOX,
                    child: Text('Neox'),
                  ),
                  const PopupMenuItem(
                    value: Providers.RANDOM,
                    child: Text('Random'),
                  ),
                  const PopupMenuItem(
                    value: Providers.MARK,
                    child: Text('Mark'),
                  ),
                  const PopupMenuItem(
                    value: Providers.MANGA_HOST,
                    child: Text('Manga Host'),
                  ),
                ],
              )
            ],
            floating: true,
            centerTitle: false,
            bottom: AppBar(
              automaticallyImplyLeading: false,
              title: SizedBox(
                width: double.infinity,
                height: 40,
                child: Center(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Digite o nome do livro',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _isLoading
                          ? Container(
                              width: 20,
                              alignment: Alignment.centerRight,
                              child: const SizedBox(
                                width: 20,
                                height: 20,
                                child:
                                    CircularProgressIndicator(strokeWidth: 2),
                              ),
                            )
                          : null,
                    ),
                    enabled: !_isLoading,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    keyboardAppearance: Brightness.dark,
                    onSubmitted: _onSubmitted,
                  ),
                ),
              ),
            ),
          ),
          _results.isEmpty
              ? SliverToBoxAdapter(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      'Não foi encontrado nenhum resultado para a sua pesquisa.',
                      style: Theme.of(context).textTheme.titleSmall,
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              : SliverPadding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 8,
                  ),
                  sliver: SliverGrid(
                    gridDelegate: Grid.sliverDelegate,
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        final BookItem book = _results[index];
                        return BookElement(
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
                      childCount: _results.length,
                    ),
                  ),
                ),
        ],
      ),
    );
  }
}
