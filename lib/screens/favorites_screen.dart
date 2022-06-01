import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/routes.dart';
import 'package:A.N.R/store/favorites_store.dart';
import 'package:A.N.R/utils/grid.dart';
import 'package:A.N.R/widgets/book_element.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FavoritesStore store = Provider.of<FavoritesStore>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: Observer(
        builder: (context) {
          final List<BookItem> favorites = store.items;

          return GridView.builder(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            itemCount: favorites.length,
            gridDelegate: Grid.sliverDelegate,
            itemBuilder: (context, index) {
              final BookItem book = favorites[index];
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
          );
        },
      ),
    );
  }
}
