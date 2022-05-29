import 'package:A.N.R/models/book_favorite.dart';
import 'package:A.N.R/models/book_item.dart';
import 'package:A.N.R/store/favorites_store.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:provider/provider.dart';

class Favorites {
  final BookItem book;
  final FavoritesStore store;
  final BuildContext context;

  const Favorites({
    required this.book,
    required this.store,
    required this.context,
  });

  bool get isFavorite => store.favorites.containsKey(book.id);

  BookFavorite get bookFavorite {
    return BookFavorite(
      id: book.id,
      url: book.url,
      name: book.name,
      imageURL: book.imageURL ?? '',
      imageURL2: book.imageURL2,
    );
  }

  static DatabaseReference? get ref {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user == null) return null;

    final favoritesRef =
        FirebaseDatabase.instance.ref('users/${user.uid}/favorites');

    favoritesRef.keepSynced(true);

    return favoritesRef;
  }

  static Future<void> getAll(BuildContext context) async {
    if (ref == null) return _snackError(context);

    final FavoritesStore store = Provider.of<FavoritesStore>(context);

    try {
      final DataSnapshot snapshot = await ref!.get();
      if (!snapshot.exists) return;

      final Map<String, BookFavorite> favorites = {};

      for (DataSnapshot element in snapshot.children) {
        final item = element.value as Map<dynamic, dynamic>;
        favorites[element.key!] = BookFavorite(
          id: item['id'],
          url: item['url'],
          name: item['name'],
          imageURL: item['imageURL'],
          imageURL2: item['imageURL2'],
        );
      }

      store.favorites.removeWhere((key, value) => !favorites.containsKey(key));
      store.set(favorites);
    } catch (err) {
      _snackError(context);
    }
  }

  void toggleFavorite() {
    if (ref == null) return _snackError(context);

    final DatabaseReference bookRef = ref!.child(book.id);

    if (isFavorite) {
      store.remove(book.id);
      bookRef.remove();
    } else {
      store.add(bookFavorite);
      bookRef.set(bookFavorite.toMap);
    }
  }

  Widget get button {
    return Observer(builder: (_) {
      return IconButton(
        onPressed: toggleFavorite,
        icon: Icon(
          isFavorite ? Icons.favorite : Icons.favorite_outline,
          color: isFavorite ? Colors.red : null,
        ),
      );
    });
  }

  static void _snackError(BuildContext context) {
    final ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);

    messenger.clearSnackBars();
    messenger.showSnackBar(
      const SnackBar(content: Text('Não foi sincronizar seus favoritos')),
    );
  }
}
