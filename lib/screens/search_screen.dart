import 'package:A.N.R/constants/providers.dart';
import 'package:A.N.R/models/search_result.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/screens/book_screen.dart';
import 'package:A.N.R/services/leitor/leitor_search.dart';
import 'package:A.N.R/styles/colors.dart';
import 'package:A.N.R/widgets/book_element.dart';
import 'package:A.N.R/widgets/book_element_sliver_grid.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  bool _isLoading = false;

  List<SearchResult> _results = [];

  Future _onSubmitted(String value, Function() error) async {
    setState(() => _isLoading = true);

    List<SearchResult> results = [];

    try {
      results = await leitorSearch(value);
    } catch (e) {
      error();
    } finally {
      setState(() {
        _results = results;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as SearchArguments;

    return Scaffold(
      body: CustomScrollView(
        physics: const BouncingScrollPhysics(),
        slivers: [
          SliverAppBar(
            snap: false,
            title: Text('${args.provider.value} - Buscar livro...'),
            pinned: true,
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
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: CustomColors.greyDark,
                                ),
                              ),
                            )
                          : null,
                    ),
                    enabled: !_isLoading,
                    autofocus: true,
                    textInputAction: TextInputAction.search,
                    keyboardAppearance: Brightness.dark,
                    onSubmitted: (value) => _onSubmitted(value, () {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Algo deu errado fazer a busca'),
                      ));
                    }),
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
              : BookElementSliverGrid(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final SearchResult data = _results[index];
                      return BookElement(
                        imageURL: data.imageURL2 ?? data.imageURL,
                        imageURL2: data.imageURL2,
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            RoutesName.BOOK,
                            arguments: BookArguments(
                              id: data.id,
                              url: data.url,
                              name: data.name,
                              provider: args.provider,
                              imageURL: data.imageURL,
                              imageURL2: data.imageURL2,
                            ),
                          );
                        },
                      );
                    },
                    childCount: _results.length,
                  ),
                ),
        ],
      ),
    );
  }
}

class SearchArguments {
  final Providers provider;

  const SearchArguments(this.provider);
}
