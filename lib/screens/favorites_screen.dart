import 'package:A.N.R/constants/providers.dart';
import 'package:A.N.R/models/book_favorite.dart';
import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/store/favorites_store.dart';
import 'package:A.N.R/widgets/book_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoritesStore store = Provider.of<FavoritesStore>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: Observer(builder: (context) {
        final List<BookFavorite> books = store.items;

        return GridView.builder(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
          itemCount: books.length,
          gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
            childAspectRatio: 0.72,
            maxCrossAxisExtent: 156,
          ),
          itemBuilder: (context, index) {
            final BookFavorite book = books[index];

            return BookElement(
              imageURL: book.imageURL2 ?? book.imageURL,
              imageURL2: book.imageURL,
              onTap: () {
                Navigator.of(context).pushNamed(
                  RoutesName.BOOK,
                  arguments: BookItem(
                    id: book.id,
                    url: book.url,
                    name: book.name,
                    provider: Providers.leitor,
                    imageURL: book.imageURL,
                    imageURL2: book.imageURL2,
                  ),
                );
              },
            );
          },
        );
      }),
    );
  }
}
